XAS99 CROSS-ASSEMBLER   VERSION 1.7.0
**** **** ****     > tivi.asm.19002
0001               ***************************************************************
0002               *
0003               *                          TiVi Editor
0004               *
0005               *                (c)2018-2019 // Filip van Vooren
0006               *
0007               ***************************************************************
0008               * File: tivi.asm                    ; Version 191201-19002
0009               *--------------------------------------------------------------
0010               * TI-99/4a Advanced Editor & IDE
0011               *--------------------------------------------------------------
0012               * TiVi memory layout
0013               *
0014               * Mem range   Bytes    Hex   Purpose
0015               * =========   =====   ====   ==================================
0016               * 8300-83ff     256   >100   scrpad spectra2 layout
0017               * 2000-20ff     256   >100   scrpad backup 1: GPL layout
0018               * 2100-21ff     256   >100   scrpad backup 2: paged out spectra2
0019               * 2200-22ff     256   >100   TiVi frame buffer structure
0020               * 2300-23ff     256   >100   TiVi editor buffer structure
0021               * 2400-24ff     256   >100   TiVi file handling structure
0022               * 2500-25ff     256   >100   Free for future use
0023               * 2600-264f      80   >050   Free for future use
0024               * 2650-2faf    2480   >9b0   Frame buffer 80x31
0025               * 2fb0-2fff      80   >050   Free for future use
0026               * 3000-3fff    4096  >1000   Index
0027               * a000-fffb   24574  >5ffe   Editor buffer
0028               *--------------------------------------------------------------
0029               * SAMS 4k pages in transparent mode
0030               *
0031               * Low memory expansion
0032               * 2000-2fff 3000-3fff
0033               *
0034               * High memory expansion
0035               * a000-afff b000-bfff c000-cfff d000-dfff e000-efff f000-ffff
0036               *--------------------------------------------------------------
0037               *
0038               *--------------------------------------------------------------
0039               * EQUATES  EQUATES  EQUATES  EQUATES  EQUATES  EQUATES  EQUATES
0040               *--------------------------------------------------------------
0041      0001     debug                   equ  1      ; Turn on spectra2 debugging
0042               *--------------------------------------------------------------
0043               * Skip unused spectra2 code modules for reduced code size
0044               *--------------------------------------------------------------
0045      0001     skip_rom_bankswitch     equ  1      ; Skip ROM bankswitching support
0046      0001     skip_grom_cpu_copy      equ  1      ; Skip GROM to CPU copy functions
0047      0001     skip_grom_vram_copy     equ  1      ; Skip GROM to VDP vram copy functions
0048      0001     skip_vdp_hchar          equ  1      ; Skip hchar, xhchar
0049      0001     skip_vdp_vchar          equ  1      ; Skip vchar, xvchar
0050      0001     skip_vdp_boxes          equ  1      ; Skip filbox, putbox
0051      0001     skip_vdp_bitmap         equ  1      ; Skip bitmap functions
0052      0001     skip_vdp_viewport       equ  1      ; Skip viewport functions
0053      0001     skip_vdp_rle_decompress equ  1      ; Skip RLE decompress to VRAM
0054      0001     skip_vdp_px2yx_calc     equ  1      ; Skip pixel to YX calculation
0055      0001     skip_sound_player       equ  1      ; Skip inclusion of sound player code
0056      0001     skip_speech_detection   equ  1      ; Skip speech synthesizer detection
0057      0001     skip_speech_player      equ  1      ; Skip inclusion of speech player code
0058      0001     skip_virtual_keyboard   equ  1      ; Skip virtual keyboard scan
0059      0001     skip_random_generator   equ  1      ; Skip random functions
0060      0001     skip_cpu_hexsupport     equ  1      ; Skip mkhex, puthex
0061      0001     skip_cpu_crc16          equ  1      ; Skip CPU memory CRC-16 calculation
0062               *--------------------------------------------------------------
0063               * SPECTRA2 startup options
0064               *--------------------------------------------------------------
0065      0001     startup_backup_scrpad   equ  1      ; Backup scratchpad @>8300:>83ff to @>2000
0066      0001     startup_keep_vdpmemory  equ  1      ; Do not clear VDP vram upon startup
0067      00F5     spfclr                  equ  >f5    ; Foreground/Background color for font.
0068      0005     spfbck                  equ  >05    ; Screen background color.
0069               *--------------------------------------------------------------
0070               * Scratchpad memory                 @>8300-83ff     (256 bytes)
0071               *--------------------------------------------------------------
0072               ;               equ  >8342          ; >8342-834F **free***
0073      8350     parm1           equ  >8350          ; Function parameter 1
0074      8352     parm2           equ  >8352          ; Function parameter 2
0075      8354     parm3           equ  >8354          ; Function parameter 3
0076      8356     parm4           equ  >8356          ; Function parameter 4
0077      8358     parm5           equ  >8358          ; Function parameter 5
0078      835A     parm6           equ  >835a          ; Function parameter 6
0079      835C     parm7           equ  >835c          ; Function parameter 7
0080      835E     parm8           equ  >835e          ; Function parameter 8
0081      8360     outparm1        equ  >8360          ; Function output parameter 1
0082      8362     outparm2        equ  >8362          ; Function output parameter 2
0083      8364     outparm3        equ  >8364          ; Function output parameter 3
0084      8366     outparm4        equ  >8366          ; Function output parameter 4
0085      8368     outparm5        equ  >8368          ; Function output parameter 5
0086      836A     outparm6        equ  >836a          ; Function output parameter 6
0087      836C     outparm7        equ  >836c          ; Function output parameter 7
0088      836E     outparm8        equ  >836e          ; Function output parameter 8
0089      8370     timers          equ  >8370          ; Timer table
0090      8380     ramsat          equ  >8380          ; Sprite Attribute Table in RAM
0091      8390     rambuf          equ  >8390          ; RAM workbuffer 1
0092               *--------------------------------------------------------------
0093               * Scratchpad backup 1               @>2000-20ff     (256 bytes)
0094               * Scratchpad backup 2               @>2100-21ff     (256 bytes)
0095               *--------------------------------------------------------------
0096      2000     scrpad.backup1  equ  >2000          ; Backup GPL layout
0097      2100     scrpad.backup2  equ  >2100          ; Backup spectra2 layout
0098               *--------------------------------------------------------------
0099               * Frame buffer structure            @>2200-22ff     (256 bytes)
0100               *--------------------------------------------------------------
0101      2200     fb.top.ptr      equ  >2200          ; Pointer to frame buffer
0102      2202     fb.current      equ  fb.top.ptr+2   ; Pointer to current position in frame buffer
0103      2204     fb.topline      equ  fb.top.ptr+4   ; Top line in frame buffer (matching line X in editor buffer)
0104      2206     fb.row          equ  fb.top.ptr+6   ; Current row in frame buffer (offset 0 .. @fb.screenrows)
0105      2208     fb.row.length   equ  fb.top.ptr+8   ; Length of current row in frame buffer
0106      220A     fb.row.dirty    equ  fb.top.ptr+10  ; Current row dirty flag in frame buffer
0107      220C     fb.column       equ  fb.top.ptr+12  ; Current column in frame buffer
0108      220E     fb.colsline     equ  fb.top.ptr+14  ; Columns per row in frame buffer
0109      2210     fb.curshape     equ  fb.top.ptr+16  ; Cursor shape & colour
0110      2212     fb.curtoggle    equ  fb.top.ptr+18  ; Cursor shape toggle
0111      2214     fb.yxsave       equ  fb.top.ptr+20  ; Copy of WYX
0112      2216     fb.dirty        equ  fb.top.ptr+22  ; Frame buffer dirty flag
0113      2218     fb.screenrows   equ  fb.top.ptr+24  ; Number of rows on physical screen
0114               *--------------------------------------------------------------
0115               * Editor buffer structure           @>2300-23ff     (256 bytes)
0116               *--------------------------------------------------------------
0117      2300     edb.top.ptr     equ  >2300          ; Pointer to editor buffer
0118      2302     edb.index.ptr   equ  edb.top.ptr+2  ; Pointer to index
0119      2304     edb.lines       equ  edb.top.ptr+4  ; Total lines in editor buffer
0120      2306     edb.dirty       equ  edb.top.ptr+6  ; Editor buffer dirty flag (Text changed!)
0121      2308     edb.next_free   equ  edb.top.ptr+8  ; Pointer to next free line
0122      230A     edb.insmode     equ  edb.top.ptr+10 ; Editor insert mode (>0000 overwrite / >ffff insert)
0123               *--------------------------------------------------------------
0124               * File handling structures          @>2400-24ff     (256 bytes)
0125               *--------------------------------------------------------------
0126      2400     tfh.top         equ  >2400          ; TiVi file handling structures
0127      2400     dsrlnk.dsrlws   equ  tfh.top        ; Address of dsrlnk workspace 32 bytes
0128      2420     dsrlnk.namsto   equ  tfh.top + 32   ; 8-byte RAM buffer for storing device name
0129      2428     tfh.pabstat     equ  tfh.top + 40   ; Copy of VDP PAB status byte
0130      242A     tfh.ioresult    equ  tfh.top + 42   ; DSRLNK IO-status after file operation
0131      242C     tfh.records     equ  tfh.top + 44   ; File records counter
0132      242E     tfh.reclen      equ  tfh.top + 46   ; Current record length
0133      2430     tfh.kilobytes   equ  tfh.top + 48   ; Kilobytes processed (read/written)
0134      2432     tfh.counter     equ  tfh.top + 50   ; Internal counter used in TiVi file operations
0135      2434     file.pab.ptr    equ  tfh.top + 52   ; Pointer to VDP PAB, required by level 2 FIO
0136               *--------------------------------------------------------------
0137               * Free for future use               @>2500-264f     (336 bytes)
0138               *--------------------------------------------------------------
0139      2500     free.mem1       equ  >2500          ; >2500-25ff   256 bytes
0140      2600     free.mem2       equ  >2600          ; >2600-264f    80 bytes
0141               *--------------------------------------------------------------
0142               * Frame buffer                      @>2650-2fff    (2480 bytes)
0143               * Index buffer                      @>3000-3fff    (4096 bytes)
0144               * Editor buffer                     @>a000-ffff   (24576 bytes)
0145               *--------------------------------------------------------------
0146      2650     fb.top          equ  >2650          ; Frame buffer low memory 2400 bytes (80x30)
0147      3000     idx.top         equ  >3000          ; Top of index
0148      A000     edb.top         equ  >a000          ; Editor buffer high memory
0149               *--------------------------------------------------------------
0150               
0151               
0152               
0153               
0154               *--------------------------------------------------------------
0155               * Cartridge header
0156               *--------------------------------------------------------------
0157                       save  >6000,>7fff
0158                       aorg  >6000
0159               
0160 6000 AA01     grmhdr  byte  >aa,1,1,0,0,0
     6002 0100 
     6004 0000 
0161 6006 6010             data  prog0
0162 6008 0000             byte  0,0,0,0,0,0,0,0
     600A 0000 
     600C 0000 
     600E 0000 
0163 6010 0000     prog0   data  0                     ; No more items following
0164 6012 6F0A             data  runlib
0165               
0167               
0168 6014 1154             byte  17
0169 6015 ....             text  'TIVI 191201-19002'
0170                       even
0171               
0179               *--------------------------------------------------------------
0180               * Include required files
0181               *--------------------------------------------------------------
0182                       copy  "/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
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
     605A 6F12 
0019               
0020               crash_handler.main:
0021 605C 06A0  32         bl    @putat                ; Show crash message
     605E 6292 
0022 6060 0000             data  >0000,crash_handler.message
     6062 6068 
0023 6064 0460  28         b     @tmgr                 ; FNCTN-+ to quit
     6066 6E20 
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
     6094 0205 
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
     609E 00F5 
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
     60A8 03F5 
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
     60B2 03F5 
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
0098               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >400)
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
0067 632C 0262  22 cpyodd  ori   config,>8000        ; Set CONFIG bot 0
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
0016 6468 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     646A 6046 
0017 646C 020C  20         li    r12,>0024
     646E 0024 
0018 6470 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     6472 6500 
0019 6474 04C6  14         clr   tmp2
0020 6476 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 6478 04CC  14         clr   r12
0025 647A 1F08  20         tb    >0008                 ; Shift-key ?
0026 647C 1302  14         jeq   realk1                ; No
0027 647E 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     6480 6530 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 6482 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 6484 1302  14         jeq   realk2                ; No
0033 6486 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     6488 6560 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 648A 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 648C 1302  14         jeq   realk3                ; No
0039 648E 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     6490 6590 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 6492 1E15  20 realk3  sbz   >0015                 ; Set P5
0044 6494 1F07  20         tb    >0007                 ; ALPHA-Lock key ?
0045 6496 1302  14         jeq   realk4                ; No,  CONFIG register bit 0 = 0
0046 6498 E0A0  34         soc   @wbit0,config         ; Yes, CONFIG register bit 0 = 1
     649A 6046 
0047               *--------------------------------------------------------------
0048               * Scan keyboard column
0049               *--------------------------------------------------------------
0050 649C 1D15  20 realk4  sbo   >0015                 ; Reset P5
0051 649E 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     64A0 0006 
0052 64A2 0606  14 realk5  dec   tmp2
0053 64A4 020C  20         li    r12,>24               ; CRU address for P2-P4
     64A6 0024 
0054 64A8 06C6  14         swpb  tmp2
0055 64AA 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0056 64AC 06C6  14         swpb  tmp2
0057 64AE 020C  20         li    r12,6                 ; CRU read address
     64B0 0006 
0058 64B2 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0059 64B4 0547  14         inv   tmp3                  ;
0060 64B6 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     64B8 FF00 
0061               *--------------------------------------------------------------
0062               * Scan keyboard row
0063               *--------------------------------------------------------------
0064 64BA 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0065 64BC 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombinations scanned by shifting left.
0066 64BE 1807  14         joc   realk8                ; If no carry after 8 loops, then it means no key
0067 64C0 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0068 64C2 0285  22         ci    tmp1,8
     64C4 0008 
0069 64C6 1AFA  14         jl    realk6
0070 64C8 C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0071 64CA 1BEB  14         jh    realk5                ; No, next column
0072 64CC 1016  14         jmp   realkz                ; Yes, exit
0073               *--------------------------------------------------------------
0074               * Check for match in data table
0075               *--------------------------------------------------------------
0076 64CE C206  18 realk8  mov   tmp2,tmp4
0077 64D0 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0078 64D2 A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0079 64D4 A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base address of data table (R15)
0080 64D6 D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0081 64D8 13F3  14         jeq   realk7                ; Yes, then discard and continue scanning (FCTN, SHIFT, CTRL)
0082               *--------------------------------------------------------------
0083               * Determine ASCII value of key
0084               *--------------------------------------------------------------
0085 64DA D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0086 64DC 20A0  38         coc   @wbit0,config         ; ALPHA-Lock key pressed ?
     64DE 6046 
0087 64E0 1608  14         jne   realka                ; No, continue saving key
0088 64E2 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     64E4 652A 
0089 64E6 1A05  14         jl    realka
0090 64E8 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     64EA 6528 
0091 64EC 1B02  14         jh    realka                ; No, continue
0092 64EE 0226  22         ai    tmp2,->2000           ; ASCII = ASCII - 32 (lowercase to uppercase!)
     64F0 E000 
0093 64F2 C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     64F4 833C 
0094 64F6 E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     64F8 6030 
0095 64FA 020F  20 realkz  li    r15,vdpw              ; Setup VDP write address again after using R15 as temp storage
     64FC 8C00 
0096 64FE 045B  20         b     *r11                  ; Exit
0097               ********@*****@*********************@**************************
0098 6500 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     6502 0000 
     6504 FF0D 
     6506 203D 
0099 6508 ....             text  'xws29ol.'
0100 6510 ....             text  'ced38ik,'
0101 6518 ....             text  'vrf47ujm'
0102 6520 ....             text  'btg56yhn'
0103 6528 ....             text  'zqa10p;/'
0104 6530 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     6532 0000 
     6534 FF0D 
     6536 202B 
0105 6538 ....             text  'XWS@(OL>'
0106 6540 ....             text  'CED#*IK<'
0107 6548 ....             text  'VRF$&UJM'
0108 6550 ....             text  'BTG%^YHN'
0109 6558 ....             text  'ZQA!)P:-'
0110 6560 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     6562 0000 
     6564 FF0D 
     6566 2005 
0111 6568 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     656A 0804 
     656C 0F27 
     656E C2B9 
0112 6570 600B             data  >600b,>0907,>063f,>c1B8
     6572 0907 
     6574 063F 
     6576 C1B8 
0113 6578 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     657A 7B02 
     657C 015F 
     657E C0C3 
0114 6580 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     6582 7D0E 
     6584 0CC6 
     6586 BFC4 
0115 6588 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     658A 7C03 
     658C BC22 
     658E BDBA 
0116 6590 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     6592 0000 
     6594 FF0D 
     6596 209D 
0117 6598 9897             data  >9897,>93b2,>9f8f,>8c9B
     659A 93B2 
     659C 9F8F 
     659E 8C9B 
0118 65A0 8385             data  >8385,>84b3,>9e89,>8b80
     65A2 84B3 
     65A4 9E89 
     65A6 8B80 
0119 65A8 9692             data  >9692,>86b4,>b795,>8a8D
     65AA 86B4 
     65AC B795 
     65AE 8A8D 
0120 65B0 8294             data  >8294,>87b5,>b698,>888E
     65B2 87B5 
     65B4 B698 
     65B6 888E 
0121 65B8 9A91             data  >9a91,>81b1,>b090,>9cBB
     65BA 81B1 
     65BC B090 
     65BE 9CBB 
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
0019 65C0 0207  20 mknum   li    tmp3,5                ; Digit counter
     65C2 0005 
0020 65C4 C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 65C6 C155  26         mov   *tmp1,tmp1            ; /
0022 65C8 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 65CA 0228  22         ai    tmp4,4                ; Get end of buffer
     65CC 0004 
0024 65CE 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     65D0 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 65D2 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 65D4 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 65D6 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 65D8 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 65DA D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 65DC C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for the next digit
0034 65DE 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 65E0 0607  14         dec   tmp3                  ; Decrease counter
0036 65E2 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 65E4 0207  20         li    tmp3,4                ; Check first 4 digits
     65E6 0004 
0041 65E8 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 65EA C11B  26         mov   *r11,tmp0
0043 65EC 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 65EE 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 65F0 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 65F2 05CB  14 mknum3  inct  r11
0047 65F4 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     65F6 6046 
0048 65F8 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 65FA 045B  20         b     *r11                  ; Exit
0050 65FC DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 65FE 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 6600 13F8  14         jeq   mknum3                ; Yes, exit
0053 6602 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 6604 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     6606 7FFF 
0058 6608 C10B  18         mov   r11,tmp0
0059 660A 0224  22         ai    tmp0,-4
     660C FFFC 
0060 660E C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 6610 0206  20         li    tmp2,>0500            ; String length = 5
     6612 0500 
0062 6614 0460  28         b     @xutstr               ; Display string
     6616 6284 
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
0092 6618 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0093 661A C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0094 661C C1BB  30         mov   *r11+,tmp2            ; Get padding character
0095 661E 06C6  14         swpb  tmp2                  ; LO <-> HI
0096 6620 0207  20         li    tmp3,5                ; Set counter
     6622 0005 
0097                       ;------------------------------------------------------
0098                       ; Scan for padding character from left to right
0099                       ;------------------------------------------------------:
0100               trimnum_scan:
0101 6624 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0102 6626 1604  14         jne   trimnum_setlen        ; No, exit loop
0103 6628 0584  14         inc   tmp0                  ; Next character
0104 662A 0607  14         dec   tmp3                  ; Last digit reached ?
0105 662C 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0106 662E 10FA  14         jmp   trimnum_scan
0107                       ;------------------------------------------------------
0108                       ; Scan completed, set length byte new string
0109                       ;------------------------------------------------------
0110               trimnum_setlen:
0111 6630 06C7  14         swpb  tmp3                  ; LO <-> HI
0112 6632 DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0113 6634 06C7  14         swpb  tmp3                  ; LO <-> HI
0114                       ;------------------------------------------------------
0115                       ; Start filling new string
0116                       ;------------------------------------------------------
0117               trimnum_fill
0118 6636 DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0119 6638 0607  14         dec   tmp3                  ; Last character ?
0120 663A 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0121 663C 045B  20         b     *r11                  ; Return
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
0138 663E C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     6640 832A 
0139 6642 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6644 8000 
0140 6646 10BC  14         jmp   mknum                 ; Convert number and display
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
0021 6648 C820  54         mov   @>8300,@>2000
     664A 8300 
     664C 2000 
0022 664E C820  54         mov   @>8302,@>2002
     6650 8302 
     6652 2002 
0023 6654 C820  54         mov   @>8304,@>2004
     6656 8304 
     6658 2004 
0024 665A C820  54         mov   @>8306,@>2006
     665C 8306 
     665E 2006 
0025 6660 C820  54         mov   @>8308,@>2008
     6662 8308 
     6664 2008 
0026 6666 C820  54         mov   @>830A,@>200A
     6668 830A 
     666A 200A 
0027 666C C820  54         mov   @>830C,@>200C
     666E 830C 
     6670 200C 
0028 6672 C820  54         mov   @>830E,@>200E
     6674 830E 
     6676 200E 
0029 6678 C820  54         mov   @>8310,@>2010
     667A 8310 
     667C 2010 
0030 667E C820  54         mov   @>8312,@>2012
     6680 8312 
     6682 2012 
0031 6684 C820  54         mov   @>8314,@>2014
     6686 8314 
     6688 2014 
0032 668A C820  54         mov   @>8316,@>2016
     668C 8316 
     668E 2016 
0033 6690 C820  54         mov   @>8318,@>2018
     6692 8318 
     6694 2018 
0034 6696 C820  54         mov   @>831A,@>201A
     6698 831A 
     669A 201A 
0035 669C C820  54         mov   @>831C,@>201C
     669E 831C 
     66A0 201C 
0036 66A2 C820  54         mov   @>831E,@>201E
     66A4 831E 
     66A6 201E 
0037 66A8 C820  54         mov   @>8320,@>2020
     66AA 8320 
     66AC 2020 
0038 66AE C820  54         mov   @>8322,@>2022
     66B0 8322 
     66B2 2022 
0039 66B4 C820  54         mov   @>8324,@>2024
     66B6 8324 
     66B8 2024 
0040 66BA C820  54         mov   @>8326,@>2026
     66BC 8326 
     66BE 2026 
0041 66C0 C820  54         mov   @>8328,@>2028
     66C2 8328 
     66C4 2028 
0042 66C6 C820  54         mov   @>832A,@>202A
     66C8 832A 
     66CA 202A 
0043 66CC C820  54         mov   @>832C,@>202C
     66CE 832C 
     66D0 202C 
0044 66D2 C820  54         mov   @>832E,@>202E
     66D4 832E 
     66D6 202E 
0045 66D8 C820  54         mov   @>8330,@>2030
     66DA 8330 
     66DC 2030 
0046 66DE C820  54         mov   @>8332,@>2032
     66E0 8332 
     66E2 2032 
0047 66E4 C820  54         mov   @>8334,@>2034
     66E6 8334 
     66E8 2034 
0048 66EA C820  54         mov   @>8336,@>2036
     66EC 8336 
     66EE 2036 
0049 66F0 C820  54         mov   @>8338,@>2038
     66F2 8338 
     66F4 2038 
0050 66F6 C820  54         mov   @>833A,@>203A
     66F8 833A 
     66FA 203A 
0051 66FC C820  54         mov   @>833C,@>203C
     66FE 833C 
     6700 203C 
0052 6702 C820  54         mov   @>833E,@>203E
     6704 833E 
     6706 203E 
0053 6708 C820  54         mov   @>8340,@>2040
     670A 8340 
     670C 2040 
0054 670E C820  54         mov   @>8342,@>2042
     6710 8342 
     6712 2042 
0055 6714 C820  54         mov   @>8344,@>2044
     6716 8344 
     6718 2044 
0056 671A C820  54         mov   @>8346,@>2046
     671C 8346 
     671E 2046 
0057 6720 C820  54         mov   @>8348,@>2048
     6722 8348 
     6724 2048 
0058 6726 C820  54         mov   @>834A,@>204A
     6728 834A 
     672A 204A 
0059 672C C820  54         mov   @>834C,@>204C
     672E 834C 
     6730 204C 
0060 6732 C820  54         mov   @>834E,@>204E
     6734 834E 
     6736 204E 
0061 6738 C820  54         mov   @>8350,@>2050
     673A 8350 
     673C 2050 
0062 673E C820  54         mov   @>8352,@>2052
     6740 8352 
     6742 2052 
0063 6744 C820  54         mov   @>8354,@>2054
     6746 8354 
     6748 2054 
0064 674A C820  54         mov   @>8356,@>2056
     674C 8356 
     674E 2056 
0065 6750 C820  54         mov   @>8358,@>2058
     6752 8358 
     6754 2058 
0066 6756 C820  54         mov   @>835A,@>205A
     6758 835A 
     675A 205A 
0067 675C C820  54         mov   @>835C,@>205C
     675E 835C 
     6760 205C 
0068 6762 C820  54         mov   @>835E,@>205E
     6764 835E 
     6766 205E 
0069 6768 C820  54         mov   @>8360,@>2060
     676A 8360 
     676C 2060 
0070 676E C820  54         mov   @>8362,@>2062
     6770 8362 
     6772 2062 
0071 6774 C820  54         mov   @>8364,@>2064
     6776 8364 
     6778 2064 
0072 677A C820  54         mov   @>8366,@>2066
     677C 8366 
     677E 2066 
0073 6780 C820  54         mov   @>8368,@>2068
     6782 8368 
     6784 2068 
0074 6786 C820  54         mov   @>836A,@>206A
     6788 836A 
     678A 206A 
0075 678C C820  54         mov   @>836C,@>206C
     678E 836C 
     6790 206C 
0076 6792 C820  54         mov   @>836E,@>206E
     6794 836E 
     6796 206E 
0077 6798 C820  54         mov   @>8370,@>2070
     679A 8370 
     679C 2070 
0078 679E C820  54         mov   @>8372,@>2072
     67A0 8372 
     67A2 2072 
0079 67A4 C820  54         mov   @>8374,@>2074
     67A6 8374 
     67A8 2074 
0080 67AA C820  54         mov   @>8376,@>2076
     67AC 8376 
     67AE 2076 
0081 67B0 C820  54         mov   @>8378,@>2078
     67B2 8378 
     67B4 2078 
0082 67B6 C820  54         mov   @>837A,@>207A
     67B8 837A 
     67BA 207A 
0083 67BC C820  54         mov   @>837C,@>207C
     67BE 837C 
     67C0 207C 
0084 67C2 C820  54         mov   @>837E,@>207E
     67C4 837E 
     67C6 207E 
0085 67C8 C820  54         mov   @>8380,@>2080
     67CA 8380 
     67CC 2080 
0086 67CE C820  54         mov   @>8382,@>2082
     67D0 8382 
     67D2 2082 
0087 67D4 C820  54         mov   @>8384,@>2084
     67D6 8384 
     67D8 2084 
0088 67DA C820  54         mov   @>8386,@>2086
     67DC 8386 
     67DE 2086 
0089 67E0 C820  54         mov   @>8388,@>2088
     67E2 8388 
     67E4 2088 
0090 67E6 C820  54         mov   @>838A,@>208A
     67E8 838A 
     67EA 208A 
0091 67EC C820  54         mov   @>838C,@>208C
     67EE 838C 
     67F0 208C 
0092 67F2 C820  54         mov   @>838E,@>208E
     67F4 838E 
     67F6 208E 
0093 67F8 C820  54         mov   @>8390,@>2090
     67FA 8390 
     67FC 2090 
0094 67FE C820  54         mov   @>8392,@>2092
     6800 8392 
     6802 2092 
0095 6804 C820  54         mov   @>8394,@>2094
     6806 8394 
     6808 2094 
0096 680A C820  54         mov   @>8396,@>2096
     680C 8396 
     680E 2096 
0097 6810 C820  54         mov   @>8398,@>2098
     6812 8398 
     6814 2098 
0098 6816 C820  54         mov   @>839A,@>209A
     6818 839A 
     681A 209A 
0099 681C C820  54         mov   @>839C,@>209C
     681E 839C 
     6820 209C 
0100 6822 C820  54         mov   @>839E,@>209E
     6824 839E 
     6826 209E 
0101 6828 C820  54         mov   @>83A0,@>20A0
     682A 83A0 
     682C 20A0 
0102 682E C820  54         mov   @>83A2,@>20A2
     6830 83A2 
     6832 20A2 
0103 6834 C820  54         mov   @>83A4,@>20A4
     6836 83A4 
     6838 20A4 
0104 683A C820  54         mov   @>83A6,@>20A6
     683C 83A6 
     683E 20A6 
0105 6840 C820  54         mov   @>83A8,@>20A8
     6842 83A8 
     6844 20A8 
0106 6846 C820  54         mov   @>83AA,@>20AA
     6848 83AA 
     684A 20AA 
0107 684C C820  54         mov   @>83AC,@>20AC
     684E 83AC 
     6850 20AC 
0108 6852 C820  54         mov   @>83AE,@>20AE
     6854 83AE 
     6856 20AE 
0109 6858 C820  54         mov   @>83B0,@>20B0
     685A 83B0 
     685C 20B0 
0110 685E C820  54         mov   @>83B2,@>20B2
     6860 83B2 
     6862 20B2 
0111 6864 C820  54         mov   @>83B4,@>20B4
     6866 83B4 
     6868 20B4 
0112 686A C820  54         mov   @>83B6,@>20B6
     686C 83B6 
     686E 20B6 
0113 6870 C820  54         mov   @>83B8,@>20B8
     6872 83B8 
     6874 20B8 
0114 6876 C820  54         mov   @>83BA,@>20BA
     6878 83BA 
     687A 20BA 
0115 687C C820  54         mov   @>83BC,@>20BC
     687E 83BC 
     6880 20BC 
0116 6882 C820  54         mov   @>83BE,@>20BE
     6884 83BE 
     6886 20BE 
0117 6888 C820  54         mov   @>83C0,@>20C0
     688A 83C0 
     688C 20C0 
0118 688E C820  54         mov   @>83C2,@>20C2
     6890 83C2 
     6892 20C2 
0119 6894 C820  54         mov   @>83C4,@>20C4
     6896 83C4 
     6898 20C4 
0120 689A C820  54         mov   @>83C6,@>20C6
     689C 83C6 
     689E 20C6 
0121 68A0 C820  54         mov   @>83C8,@>20C8
     68A2 83C8 
     68A4 20C8 
0122 68A6 C820  54         mov   @>83CA,@>20CA
     68A8 83CA 
     68AA 20CA 
0123 68AC C820  54         mov   @>83CC,@>20CC
     68AE 83CC 
     68B0 20CC 
0124 68B2 C820  54         mov   @>83CE,@>20CE
     68B4 83CE 
     68B6 20CE 
0125 68B8 C820  54         mov   @>83D0,@>20D0
     68BA 83D0 
     68BC 20D0 
0126 68BE C820  54         mov   @>83D2,@>20D2
     68C0 83D2 
     68C2 20D2 
0127 68C4 C820  54         mov   @>83D4,@>20D4
     68C6 83D4 
     68C8 20D4 
0128 68CA C820  54         mov   @>83D6,@>20D6
     68CC 83D6 
     68CE 20D6 
0129 68D0 C820  54         mov   @>83D8,@>20D8
     68D2 83D8 
     68D4 20D8 
0130 68D6 C820  54         mov   @>83DA,@>20DA
     68D8 83DA 
     68DA 20DA 
0131 68DC C820  54         mov   @>83DC,@>20DC
     68DE 83DC 
     68E0 20DC 
0132 68E2 C820  54         mov   @>83DE,@>20DE
     68E4 83DE 
     68E6 20DE 
0133 68E8 C820  54         mov   @>83E0,@>20E0
     68EA 83E0 
     68EC 20E0 
0134 68EE C820  54         mov   @>83E2,@>20E2
     68F0 83E2 
     68F2 20E2 
0135 68F4 C820  54         mov   @>83E4,@>20E4
     68F6 83E4 
     68F8 20E4 
0136 68FA C820  54         mov   @>83E6,@>20E6
     68FC 83E6 
     68FE 20E6 
0137 6900 C820  54         mov   @>83E8,@>20E8
     6902 83E8 
     6904 20E8 
0138 6906 C820  54         mov   @>83EA,@>20EA
     6908 83EA 
     690A 20EA 
0139 690C C820  54         mov   @>83EC,@>20EC
     690E 83EC 
     6910 20EC 
0140 6912 C820  54         mov   @>83EE,@>20EE
     6914 83EE 
     6916 20EE 
0141 6918 C820  54         mov   @>83F0,@>20F0
     691A 83F0 
     691C 20F0 
0142 691E C820  54         mov   @>83F2,@>20F2
     6920 83F2 
     6922 20F2 
0143 6924 C820  54         mov   @>83F4,@>20F4
     6926 83F4 
     6928 20F4 
0144 692A C820  54         mov   @>83F6,@>20F6
     692C 83F6 
     692E 20F6 
0145 6930 C820  54         mov   @>83F8,@>20F8
     6932 83F8 
     6934 20F8 
0146 6936 C820  54         mov   @>83FA,@>20FA
     6938 83FA 
     693A 20FA 
0147 693C C820  54         mov   @>83FC,@>20FC
     693E 83FC 
     6940 20FC 
0148 6942 C820  54         mov   @>83FE,@>20FE
     6944 83FE 
     6946 20FE 
0149 6948 045B  20         b     *r11                  ; Return to caller
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
0164 694A C820  54         mov   @>2000,@>8300
     694C 2000 
     694E 8300 
0165 6950 C820  54         mov   @>2002,@>8302
     6952 2002 
     6954 8302 
0166 6956 C820  54         mov   @>2004,@>8304
     6958 2004 
     695A 8304 
0167 695C C820  54         mov   @>2006,@>8306
     695E 2006 
     6960 8306 
0168 6962 C820  54         mov   @>2008,@>8308
     6964 2008 
     6966 8308 
0169 6968 C820  54         mov   @>200A,@>830A
     696A 200A 
     696C 830A 
0170 696E C820  54         mov   @>200C,@>830C
     6970 200C 
     6972 830C 
0171 6974 C820  54         mov   @>200E,@>830E
     6976 200E 
     6978 830E 
0172 697A C820  54         mov   @>2010,@>8310
     697C 2010 
     697E 8310 
0173 6980 C820  54         mov   @>2012,@>8312
     6982 2012 
     6984 8312 
0174 6986 C820  54         mov   @>2014,@>8314
     6988 2014 
     698A 8314 
0175 698C C820  54         mov   @>2016,@>8316
     698E 2016 
     6990 8316 
0176 6992 C820  54         mov   @>2018,@>8318
     6994 2018 
     6996 8318 
0177 6998 C820  54         mov   @>201A,@>831A
     699A 201A 
     699C 831A 
0178 699E C820  54         mov   @>201C,@>831C
     69A0 201C 
     69A2 831C 
0179 69A4 C820  54         mov   @>201E,@>831E
     69A6 201E 
     69A8 831E 
0180 69AA C820  54         mov   @>2020,@>8320
     69AC 2020 
     69AE 8320 
0181 69B0 C820  54         mov   @>2022,@>8322
     69B2 2022 
     69B4 8322 
0182 69B6 C820  54         mov   @>2024,@>8324
     69B8 2024 
     69BA 8324 
0183 69BC C820  54         mov   @>2026,@>8326
     69BE 2026 
     69C0 8326 
0184 69C2 C820  54         mov   @>2028,@>8328
     69C4 2028 
     69C6 8328 
0185 69C8 C820  54         mov   @>202A,@>832A
     69CA 202A 
     69CC 832A 
0186 69CE C820  54         mov   @>202C,@>832C
     69D0 202C 
     69D2 832C 
0187 69D4 C820  54         mov   @>202E,@>832E
     69D6 202E 
     69D8 832E 
0188 69DA C820  54         mov   @>2030,@>8330
     69DC 2030 
     69DE 8330 
0189 69E0 C820  54         mov   @>2032,@>8332
     69E2 2032 
     69E4 8332 
0190 69E6 C820  54         mov   @>2034,@>8334
     69E8 2034 
     69EA 8334 
0191 69EC C820  54         mov   @>2036,@>8336
     69EE 2036 
     69F0 8336 
0192 69F2 C820  54         mov   @>2038,@>8338
     69F4 2038 
     69F6 8338 
0193 69F8 C820  54         mov   @>203A,@>833A
     69FA 203A 
     69FC 833A 
0194 69FE C820  54         mov   @>203C,@>833C
     6A00 203C 
     6A02 833C 
0195 6A04 C820  54         mov   @>203E,@>833E
     6A06 203E 
     6A08 833E 
0196 6A0A C820  54         mov   @>2040,@>8340
     6A0C 2040 
     6A0E 8340 
0197 6A10 C820  54         mov   @>2042,@>8342
     6A12 2042 
     6A14 8342 
0198 6A16 C820  54         mov   @>2044,@>8344
     6A18 2044 
     6A1A 8344 
0199 6A1C C820  54         mov   @>2046,@>8346
     6A1E 2046 
     6A20 8346 
0200 6A22 C820  54         mov   @>2048,@>8348
     6A24 2048 
     6A26 8348 
0201 6A28 C820  54         mov   @>204A,@>834A
     6A2A 204A 
     6A2C 834A 
0202 6A2E C820  54         mov   @>204C,@>834C
     6A30 204C 
     6A32 834C 
0203 6A34 C820  54         mov   @>204E,@>834E
     6A36 204E 
     6A38 834E 
0204 6A3A C820  54         mov   @>2050,@>8350
     6A3C 2050 
     6A3E 8350 
0205 6A40 C820  54         mov   @>2052,@>8352
     6A42 2052 
     6A44 8352 
0206 6A46 C820  54         mov   @>2054,@>8354
     6A48 2054 
     6A4A 8354 
0207 6A4C C820  54         mov   @>2056,@>8356
     6A4E 2056 
     6A50 8356 
0208 6A52 C820  54         mov   @>2058,@>8358
     6A54 2058 
     6A56 8358 
0209 6A58 C820  54         mov   @>205A,@>835A
     6A5A 205A 
     6A5C 835A 
0210 6A5E C820  54         mov   @>205C,@>835C
     6A60 205C 
     6A62 835C 
0211 6A64 C820  54         mov   @>205E,@>835E
     6A66 205E 
     6A68 835E 
0212 6A6A C820  54         mov   @>2060,@>8360
     6A6C 2060 
     6A6E 8360 
0213 6A70 C820  54         mov   @>2062,@>8362
     6A72 2062 
     6A74 8362 
0214 6A76 C820  54         mov   @>2064,@>8364
     6A78 2064 
     6A7A 8364 
0215 6A7C C820  54         mov   @>2066,@>8366
     6A7E 2066 
     6A80 8366 
0216 6A82 C820  54         mov   @>2068,@>8368
     6A84 2068 
     6A86 8368 
0217 6A88 C820  54         mov   @>206A,@>836A
     6A8A 206A 
     6A8C 836A 
0218 6A8E C820  54         mov   @>206C,@>836C
     6A90 206C 
     6A92 836C 
0219 6A94 C820  54         mov   @>206E,@>836E
     6A96 206E 
     6A98 836E 
0220 6A9A C820  54         mov   @>2070,@>8370
     6A9C 2070 
     6A9E 8370 
0221 6AA0 C820  54         mov   @>2072,@>8372
     6AA2 2072 
     6AA4 8372 
0222 6AA6 C820  54         mov   @>2074,@>8374
     6AA8 2074 
     6AAA 8374 
0223 6AAC C820  54         mov   @>2076,@>8376
     6AAE 2076 
     6AB0 8376 
0224 6AB2 C820  54         mov   @>2078,@>8378
     6AB4 2078 
     6AB6 8378 
0225 6AB8 C820  54         mov   @>207A,@>837A
     6ABA 207A 
     6ABC 837A 
0226 6ABE C820  54         mov   @>207C,@>837C
     6AC0 207C 
     6AC2 837C 
0227 6AC4 C820  54         mov   @>207E,@>837E
     6AC6 207E 
     6AC8 837E 
0228 6ACA C820  54         mov   @>2080,@>8380
     6ACC 2080 
     6ACE 8380 
0229 6AD0 C820  54         mov   @>2082,@>8382
     6AD2 2082 
     6AD4 8382 
0230 6AD6 C820  54         mov   @>2084,@>8384
     6AD8 2084 
     6ADA 8384 
0231 6ADC C820  54         mov   @>2086,@>8386
     6ADE 2086 
     6AE0 8386 
0232 6AE2 C820  54         mov   @>2088,@>8388
     6AE4 2088 
     6AE6 8388 
0233 6AE8 C820  54         mov   @>208A,@>838A
     6AEA 208A 
     6AEC 838A 
0234 6AEE C820  54         mov   @>208C,@>838C
     6AF0 208C 
     6AF2 838C 
0235 6AF4 C820  54         mov   @>208E,@>838E
     6AF6 208E 
     6AF8 838E 
0236 6AFA C820  54         mov   @>2090,@>8390
     6AFC 2090 
     6AFE 8390 
0237 6B00 C820  54         mov   @>2092,@>8392
     6B02 2092 
     6B04 8392 
0238 6B06 C820  54         mov   @>2094,@>8394
     6B08 2094 
     6B0A 8394 
0239 6B0C C820  54         mov   @>2096,@>8396
     6B0E 2096 
     6B10 8396 
0240 6B12 C820  54         mov   @>2098,@>8398
     6B14 2098 
     6B16 8398 
0241 6B18 C820  54         mov   @>209A,@>839A
     6B1A 209A 
     6B1C 839A 
0242 6B1E C820  54         mov   @>209C,@>839C
     6B20 209C 
     6B22 839C 
0243 6B24 C820  54         mov   @>209E,@>839E
     6B26 209E 
     6B28 839E 
0244 6B2A C820  54         mov   @>20A0,@>83A0
     6B2C 20A0 
     6B2E 83A0 
0245 6B30 C820  54         mov   @>20A2,@>83A2
     6B32 20A2 
     6B34 83A2 
0246 6B36 C820  54         mov   @>20A4,@>83A4
     6B38 20A4 
     6B3A 83A4 
0247 6B3C C820  54         mov   @>20A6,@>83A6
     6B3E 20A6 
     6B40 83A6 
0248 6B42 C820  54         mov   @>20A8,@>83A8
     6B44 20A8 
     6B46 83A8 
0249 6B48 C820  54         mov   @>20AA,@>83AA
     6B4A 20AA 
     6B4C 83AA 
0250 6B4E C820  54         mov   @>20AC,@>83AC
     6B50 20AC 
     6B52 83AC 
0251 6B54 C820  54         mov   @>20AE,@>83AE
     6B56 20AE 
     6B58 83AE 
0252 6B5A C820  54         mov   @>20B0,@>83B0
     6B5C 20B0 
     6B5E 83B0 
0253 6B60 C820  54         mov   @>20B2,@>83B2
     6B62 20B2 
     6B64 83B2 
0254 6B66 C820  54         mov   @>20B4,@>83B4
     6B68 20B4 
     6B6A 83B4 
0255 6B6C C820  54         mov   @>20B6,@>83B6
     6B6E 20B6 
     6B70 83B6 
0256 6B72 C820  54         mov   @>20B8,@>83B8
     6B74 20B8 
     6B76 83B8 
0257 6B78 C820  54         mov   @>20BA,@>83BA
     6B7A 20BA 
     6B7C 83BA 
0258 6B7E C820  54         mov   @>20BC,@>83BC
     6B80 20BC 
     6B82 83BC 
0259 6B84 C820  54         mov   @>20BE,@>83BE
     6B86 20BE 
     6B88 83BE 
0260 6B8A C820  54         mov   @>20C0,@>83C0
     6B8C 20C0 
     6B8E 83C0 
0261 6B90 C820  54         mov   @>20C2,@>83C2
     6B92 20C2 
     6B94 83C2 
0262 6B96 C820  54         mov   @>20C4,@>83C4
     6B98 20C4 
     6B9A 83C4 
0263 6B9C C820  54         mov   @>20C6,@>83C6
     6B9E 20C6 
     6BA0 83C6 
0264 6BA2 C820  54         mov   @>20C8,@>83C8
     6BA4 20C8 
     6BA6 83C8 
0265 6BA8 C820  54         mov   @>20CA,@>83CA
     6BAA 20CA 
     6BAC 83CA 
0266 6BAE C820  54         mov   @>20CC,@>83CC
     6BB0 20CC 
     6BB2 83CC 
0267 6BB4 C820  54         mov   @>20CE,@>83CE
     6BB6 20CE 
     6BB8 83CE 
0268 6BBA C820  54         mov   @>20D0,@>83D0
     6BBC 20D0 
     6BBE 83D0 
0269 6BC0 C820  54         mov   @>20D2,@>83D2
     6BC2 20D2 
     6BC4 83D2 
0270 6BC6 C820  54         mov   @>20D4,@>83D4
     6BC8 20D4 
     6BCA 83D4 
0271 6BCC C820  54         mov   @>20D6,@>83D6
     6BCE 20D6 
     6BD0 83D6 
0272 6BD2 C820  54         mov   @>20D8,@>83D8
     6BD4 20D8 
     6BD6 83D8 
0273 6BD8 C820  54         mov   @>20DA,@>83DA
     6BDA 20DA 
     6BDC 83DA 
0274 6BDE C820  54         mov   @>20DC,@>83DC
     6BE0 20DC 
     6BE2 83DC 
0275 6BE4 C820  54         mov   @>20DE,@>83DE
     6BE6 20DE 
     6BE8 83DE 
0276 6BEA C820  54         mov   @>20E0,@>83E0
     6BEC 20E0 
     6BEE 83E0 
0277 6BF0 C820  54         mov   @>20E2,@>83E2
     6BF2 20E2 
     6BF4 83E2 
0278 6BF6 C820  54         mov   @>20E4,@>83E4
     6BF8 20E4 
     6BFA 83E4 
0279 6BFC C820  54         mov   @>20E6,@>83E6
     6BFE 20E6 
     6C00 83E6 
0280 6C02 C820  54         mov   @>20E8,@>83E8
     6C04 20E8 
     6C06 83E8 
0281 6C08 C820  54         mov   @>20EA,@>83EA
     6C0A 20EA 
     6C0C 83EA 
0282 6C0E C820  54         mov   @>20EC,@>83EC
     6C10 20EC 
     6C12 83EC 
0283 6C14 C820  54         mov   @>20EE,@>83EE
     6C16 20EE 
     6C18 83EE 
0284 6C1A C820  54         mov   @>20F0,@>83F0
     6C1C 20F0 
     6C1E 83F0 
0285 6C20 C820  54         mov   @>20F2,@>83F2
     6C22 20F2 
     6C24 83F2 
0286 6C26 C820  54         mov   @>20F4,@>83F4
     6C28 20F4 
     6C2A 83F4 
0287 6C2C C820  54         mov   @>20F6,@>83F6
     6C2E 20F6 
     6C30 83F6 
0288 6C32 C820  54         mov   @>20F8,@>83F8
     6C34 20F8 
     6C36 83F8 
0289 6C38 C820  54         mov   @>20FA,@>83FA
     6C3A 20FA 
     6C3C 83FA 
0290 6C3E C820  54         mov   @>20FC,@>83FC
     6C40 20FC 
     6C42 83FC 
0291 6C44 C820  54         mov   @>20FE,@>83FE
     6C46 20FE 
     6C48 83FE 
0292 6C4A 045B  20         b     *r11                  ; Return to caller
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
0024 6C4C C17B  30         mov   *r11+,tmp1            ; tmp1 = Memory target address
0025                       ;------------------------------------------------------
0026                       ; Copy scratchpad memory to destination
0027                       ;------------------------------------------------------
0028               xmem.scrpad.pgout:
0029 6C4E 0204  20         li    tmp0,>8300            ; tmp0 = Memory source address
     6C50 8300 
0030 6C52 C1C5  18         mov   tmp1,tmp3             ; tmp3 = copy of tmp1
0031 6C54 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     6C56 0080 
0032                       ;------------------------------------------------------
0033                       ; Copy memory
0034                       ;------------------------------------------------------
0035 6C58 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0036 6C5A 0606  14         dec   tmp2
0037 6C5C 16FD  14         jne   -!                    ; Loop until done
0038                       ;------------------------------------------------------
0039                       ; Switch to new workspace
0040                       ;------------------------------------------------------
0041 6C5E C347  18         mov   tmp3,r13              ; R13=WP   (pop tmp1 from stack)
0042 6C60 020E  20         li    r14,mem.scrpad.pgout.after.rtwp
     6C62 6C68 
0043                                                   ; R14=PC
0044 6C64 04CF  14         clr   r15                   ; R15=STATUS
0045                       ;------------------------------------------------------
0046                       ; If we get here, WS was copied to specified
0047                       ; destination.  Also contents of r13,r14,r15
0048                       ; are about to be overwritten by rtwp instruction.
0049                       ;------------------------------------------------------
0050 6C66 0380  18         rtwp                        ; Activate copied workspace
0051                                                   ; in non-scratchpad memory!
0052               
0053               mem.scrpad.pgout.after.rtwp:
0054 6C68 0460  28         b     @mem.scrpad.restore   ; Restore scratchpad memory from @>2000
     6C6A 694A 
0055               
0056                       ;------------------------------------------------------
0057                       ; Exit
0058                       ;------------------------------------------------------
0059               mem.scrpad.pgout.$$:
0060 6C6C 045B  20         b     *r11                  ; Return to caller
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
0077 6C6E C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
0078                       ;------------------------------------------------------
0079                       ; Copy scratchpad memory to destination
0080                       ;------------------------------------------------------
0081               xmem.scrpad.pgin:
0082 6C70 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
     6C72 8300 
0083 6C74 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     6C76 0080 
0084                       ;------------------------------------------------------
0085                       ; Copy memory
0086                       ;------------------------------------------------------
0087 6C78 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0088 6C7A 0606  14         dec   tmp2
0089 6C7C 16FD  14         jne   -!                    ; Loop until done
0090                       ;------------------------------------------------------
0091                       ; Switch workspace to scratchpad memory
0092                       ;------------------------------------------------------
0093 6C7E 02E0  18         lwpi  >8300                 ; Activate copied workspace
     6C80 8300 
0094                       ;------------------------------------------------------
0095                       ; Exit
0096                       ;------------------------------------------------------
0097               mem.scrpad.pgin.$$:
0098 6C82 045B  20         b     *r11                  ; Return to caller
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
0041 6C84 2400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0042 6C86 6C88             data  dsrlnk.init           ; entry point
0043                       ;------------------------------------------------------
0044                       ; DSRLNK entry point
0045                       ;------------------------------------------------------
0046               dsrlnk.init:
0047 6C88 C17E  30         mov   *r14+,r5              ; get pgm type for link
0048 6C8A C805  38         mov   r5,@dsrlnk.sav8a      ; save data following blwp @dsrlnk (8 or >a)
     6C8C 8322 
0049 6C8E 53E0  34         szcb  @hb$20,r15            ; reset equal bit
     6C90 6042 
0050 6C92 C020  34         mov   @>8356,r0             ; get ptr to pab
     6C94 8356 
0051 6C96 C240  18         mov   r0,r9                 ; save ptr
0052                       ;------------------------------------------------------
0053                       ; Fetch file descriptor length from PAB
0054                       ;------------------------------------------------------
0055 6C98 0229  22         ai    r9,>fff8              ; adjust r9 to addr PAB flag -> (pabaddr+9)-8
     6C9A FFF8 
0056               
0057                       ;---------------------------; Inline VSBR start
0058 6C9C 06C0  14         swpb  r0                    ;
0059 6C9E D800  38         movb  r0,@vdpa              ; send low byte
     6CA0 8C02 
0060 6CA2 06C0  14         swpb  r0                    ;
0061 6CA4 D800  38         movb  r0,@vdpa              ; send high byte
     6CA6 8C02 
0062 6CA8 D0E0  34         movb  @vdpr,r3              ; read byte from VDP ram
     6CAA 8800 
0063                       ;---------------------------; Inline VSBR end
0064 6CAC 0983  56         srl   r3,8                  ; Move to low byte
0065               
0066                       ;------------------------------------------------------
0067                       ; Fetch file descriptor device name from PAB
0068                       ;------------------------------------------------------
0069 6CAE 0704  14         seto  r4                    ; init counter
0070 6CB0 0202  20         li    r2,dsrlnk.namsto      ; point to 8-byte CPU buffer
     6CB2 2420 
0071 6CB4 0580  14 !       inc   r0                    ; point to next char of name
0072 6CB6 0584  14         inc   r4                    ; incr char counter
0073 6CB8 0284  22         ci    r4,>0007              ; see if length more than 7 chars
     6CBA 0007 
0074 6CBC 1565  14         jgt   dsrlnk.error.devicename_invalid
0075                                                   ; yes, error
0076 6CBE 80C4  18         c     r4,r3                 ; end of name?
0077 6CC0 130C  14         jeq   dsrlnk.device_name.get_length
0078                                                   ; yes
0079               
0080                       ;---------------------------; Inline VSBR start
0081 6CC2 06C0  14         swpb  r0                    ;
0082 6CC4 D800  38         movb  r0,@vdpa              ; send low byte
     6CC6 8C02 
0083 6CC8 06C0  14         swpb  r0                    ;
0084 6CCA D800  38         movb  r0,@vdpa              ; send high byte
     6CCC 8C02 
0085 6CCE D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6CD0 8800 
0086                       ;---------------------------; Inline VSBR end
0087               
0088                       ;------------------------------------------------------
0089                       ; Look for end of device name, for example "DSK1."
0090                       ;------------------------------------------------------
0091 6CD2 DC81  32         movb  r1,*r2+               ; move into buffer
0092 6CD4 9801  38         cb    r1,@dsrlnk.period     ; is character a '.'
     6CD6 6D98 
0093 6CD8 16ED  14         jne   -!                    ; no, loop next char
0094                       ;------------------------------------------------------
0095                       ; Determine device name length
0096                       ;------------------------------------------------------
0097               dsrlnk.device_name.get_length:
0098 6CDA C104  18         mov   r4,r4                 ; Check if length = 0
0099 6CDC 1355  14         jeq   dsrlnk.error.devicename_invalid
0100                                                   ; yes, error
0101 6CDE 04E0  34         clr   @>83d0
     6CE0 83D0 
0102 6CE2 C804  38         mov   r4,@>8354             ; save name length for search
     6CE4 8354 
0103 6CE6 0584  14         inc   r4                    ; adjust for dot
0104 6CE8 A804  38         a     r4,@>8356             ; point to position after name
     6CEA 8356 
0105                       ;------------------------------------------------------
0106                       ; Prepare for DSR scan >1000 - >1f00
0107                       ;------------------------------------------------------
0108               dsrlnk.dsrscan.start:
0109 6CEC 02E0  18         lwpi  >83e0                 ; Use GPL WS
     6CEE 83E0 
0110 6CF0 04C1  14         clr   r1                    ; version found of dsr
0111 6CF2 020C  20         li    r12,>0f00             ; init cru addr
     6CF4 0F00 
0112                       ;------------------------------------------------------
0113                       ; Turn off ROM on current card
0114                       ;------------------------------------------------------
0115               dsrlnk.dsrscan.cardoff:
0116 6CF6 C30C  18         mov   r12,r12               ; anything to turn off?
0117 6CF8 1301  14         jeq   dsrlnk.dsrscan.cardloop
0118                                                   ; no, loop over cards
0119 6CFA 1E00  20         sbz   0                     ; yes, turn off
0120                       ;------------------------------------------------------
0121                       ; Loop over cards and look if DSR present
0122                       ;------------------------------------------------------
0123               dsrlnk.dsrscan.cardloop:
0124 6CFC 022C  22         ai    r12,>0100             ; next rom to turn on
     6CFE 0100 
0125 6D00 04E0  34         clr   @>83d0                ; clear in case we are done
     6D02 83D0 
0126 6D04 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     6D06 2000 
0127 6D08 133D  14         jeq   dsrlnk.error.nodsr_found
0128                                                   ; yes, no matching DSR found
0129 6D0A C80C  38         mov   r12,@>83d0            ; save addr of next cru
     6D0C 83D0 
0130                       ;------------------------------------------------------
0131                       ; Look at card ROM (@>4000 eq 'AA' ?)
0132                       ;------------------------------------------------------
0133 6D0E 1D00  20         sbo   0                     ; turn on rom
0134 6D10 0202  20         li    r2,>4000              ; start at beginning of rom
     6D12 4000 
0135 6D14 9812  46         cb    *r2,@dsrlnk.$aa00     ; check for a valid DSR header
     6D16 6D94 
0136 6D18 16EE  14         jne   dsrlnk.dsrscan.cardoff
0137                                                   ; no rom found on card
0138                       ;------------------------------------------------------
0139                       ; Valid DSR ROM found. Now loop over chain/subprograms
0140                       ;------------------------------------------------------
0141                       ; dstype is the address of R5 of the DSRLNK workspace,
0142                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0143                       ; is stored before the DSR ROM is searched.
0144                       ;------------------------------------------------------
0145 6D1A A0A0  34         a     @dsrlnk.dstype,r2     ; go to first pointer (byte 8 or 10)
     6D1C 240A 
0146 6D1E 1003  14         jmp   dsrlnk.dsrscan.getentry
0147                       ;------------------------------------------------------
0148                       ; Next DSR entry
0149                       ;------------------------------------------------------
0150               dsrlnk.dsrscan.nextentry:
0151 6D20 C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or subprogram
     6D22 83D2 
0152 6D24 1D00  20         sbo   0                     ; turn rom back on
0153                       ;------------------------------------------------------
0154                       ; Get DSR entry
0155                       ;------------------------------------------------------
0156               dsrlnk.dsrscan.getentry:
0157 6D26 C092  26         mov   *r2,r2                ; is addr a zero? (end of chain?)
0158 6D28 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0159                                                   ; yes, no more DSRs or programs to check
0160 6D2A C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or subprogram
     6D2C 83D2 
0161 6D2E 05C2  14         inct  r2                    ; Offset 2 > Has call address of current DSR/subprogram code
0162 6D30 C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to offset 4 (DSR/subprogram name)
0163                       ;------------------------------------------------------
0164                       ; Check file descriptor in DSR
0165                       ;------------------------------------------------------
0166 6D32 04C5  14         clr   r5                    ; Remove any old stuff
0167 6D34 D160  34         movb  @>8355,r5             ; get length as counter
     6D36 8355 
0168 6D38 130B  14         jeq   dsrlnk.dsrscan.call_dsr
0169                                                   ; if zero, do not further check, call DSR program
0170 6D3A 9C85  32         cb    r5,*r2+               ; see if length matches
0171 6D3C 16F1  14         jne   dsrlnk.dsrscan.nextentry
0172                                                   ; no, length does not match. Go process next DSR entry
0173 6D3E 0985  56         srl   r5,8                  ; yes, move to low byte
0174 6D40 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     6D42 2420 
0175 6D44 9CB6  42 !       cb    *r6+,*r2+             ; compare byte in CPU buffer with byte in DSR ROM
0176 6D46 16EC  14         jne   dsrlnk.dsrscan.nextentry
0177                                                   ; try next DSR entry if no match
0178 6D48 0605  14         dec   r5                    ; loop until full length checked
0179 6D4A 16FC  14         jne   -!
0180                       ;------------------------------------------------------
0181                       ; Device name/Subprogram match
0182                       ;------------------------------------------------------
0183               dsrlnk.dsrscan.match:
0184 6D4C C802  38         mov   r2,@>83d2             ; DSR entry addr must be saved at @>83d2
     6D4E 83D2 
0185               
0186                       ;------------------------------------------------------
0187                       ; Call DSR program in device card
0188                       ;------------------------------------------------------
0189               dsrlnk.dsrscan.call_dsr:
0190 6D50 0581  14         inc   r1                    ; next version found
0191 6D52 0699  24         bl    *r9                   ; go run routine
0192                       ;
0193                       ; Depending on IO result the DSR in card ROM does RET
0194                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0195                       ;
0196 6D54 10E5  14         jmp   dsrlnk.dsrscan.nextentry
0197                                                   ; (1) error return
0198 6D56 1E00  20         sbz   0                     ; (2) turn off rom if good return
0199 6D58 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     6D5A 2400 
0200 6D5C C009  18         mov   r9,r0                 ; point to flag in pab
0201 6D5E C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     6D60 8322 
0202                                                   ; (8 or >a)
0203 6D62 0281  22         ci    r1,8                  ; was it 8?
     6D64 0008 
0204 6D66 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0205 6D68 D060  34         movb  @>8350,r1             ; no, we have a data >a.
     6D6A 8350 
0206                                                   ; Get error byte from @>8350
0207 6D6C 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0208               
0209                       ;------------------------------------------------------
0210                       ; Read VDP PAB byte 1 after DSR call completed (status)
0211                       ;------------------------------------------------------
0212               dsrlnk.dsrscan.dsr.8:
0213                       ;---------------------------; Inline VSBR start
0214 6D6E 06C0  14         swpb  r0                    ;
0215 6D70 D800  38         movb  r0,@vdpa              ; send low byte
     6D72 8C02 
0216 6D74 06C0  14         swpb  r0                    ;
0217 6D76 D800  38         movb  r0,@vdpa              ; send high byte
     6D78 8C02 
0218 6D7A D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     6D7C 8800 
0219                       ;---------------------------; Inline VSBR end
0220               
0221                       ;------------------------------------------------------
0222                       ; Return DSR error to caller
0223                       ;------------------------------------------------------
0224               dsrlnk.dsrscan.dsr.a:
0225 6D7E 09D1  56         srl   r1,13                 ; just keep error bits
0226 6D80 1604  14         jne   dsrlnk.error.io_error
0227                                                   ; handle IO error
0228 6D82 0380  18         rtwp                        ; Return from DSR workspace to caller workspace
0229               
0230                       ;------------------------------------------------------
0231                       ; IO-error handler
0232                       ;------------------------------------------------------
0233               dsrlnk.error.nodsr_found:
0234 6D84 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     6D86 2400 
0235               dsrlnk.error.devicename_invalid:
0236 6D88 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0237               dsrlnk.error.io_error:
0238 6D8A 06C1  14         swpb  r1                    ; put error in hi byte
0239 6D8C D741  30         movb  r1,*r13               ; store error flags in callers r0
0240 6D8E F3E0  34         socb  @hb$20,r15            ; set equal bit to indicate error
     6D90 6042 
0241 6D92 0380  18         rtwp                        ; Return from DSR workspace to caller workspace
0242               
0243               ****************************************************************************************
0244               
0245 6D94 AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0246 6D96 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows a @blwp @dsrlnk
0247 6D98 ....     dsrlnk.period     text  '.'         ; For finding end of device name
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
0043 6D9A C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0044               *--------------------------------------------------------------
0045               * Initialisation
0046               *--------------------------------------------------------------
0047               xfile.open:
0048 6D9C C04B  18         mov   r11,r1                ; Save return address
0049 6D9E C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     6DA0 2434 
0050 6DA2 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0051 6DA4 04C5  14         clr   tmp1                  ; io.op.open
0052 6DA6 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     6DA8 612E 
0053               file.open_init:
0054 6DAA 0220  22         ai    r0,9                  ; Move to file descriptor length
     6DAC 0009 
0055 6DAE C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6DB0 8356 
0056               *--------------------------------------------------------------
0057               * Main
0058               *--------------------------------------------------------------
0059               file.open_main:
0060 6DB2 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6DB4 6C84 
0061 6DB6 0008             data  8                     ; Level 2 IO call
0062               *--------------------------------------------------------------
0063               * Exit
0064               *--------------------------------------------------------------
0065               file.open_exit:
0066 6DB8 1029  14         jmp   file.record.pab.details
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
0082               *  R0 = Address of PAB in VD RAM
0083               *--------------------------------------------------------------
0084               *  Output:
0085               *  tmp0 LSB = VDP PAB byte 1 (status)
0086               *  tmp1 LSB = VDP PAB byte 5 (characters read)
0087               *  tmp2     = Status register contents upon DSRLNK return
0088               ********@*****@*********************@**************************
0089               file.close:
0090 6DBA C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0091               *--------------------------------------------------------------
0092               * Initialisation
0093               *--------------------------------------------------------------
0094               xfile.close:
0095 6DBC C04B  18         mov   r11,r1                ; Save return address
0096 6DBE C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     6DC0 2434 
0097 6DC2 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0098 6DC4 0205  20         li    tmp1,io.op.close      ; io.op.close
     6DC6 0001 
0099 6DC8 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     6DCA 612E 
0100               file.close_init:
0101 6DCC 0220  22         ai    r0,9                  ; Move to file descriptor length
     6DCE 0009 
0102 6DD0 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6DD2 8356 
0103               *--------------------------------------------------------------
0104               * Main
0105               *--------------------------------------------------------------
0106               file.close_main:
0107 6DD4 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6DD6 6C84 
0108 6DD8 0008             data  8                     ;
0109               *--------------------------------------------------------------
0110               * Exit
0111               *--------------------------------------------------------------
0112               file.close_exit:
0113 6DDA 1018  14         jmp   file.record.pab.details
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
0139 6DDC C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0140               *--------------------------------------------------------------
0141               * Initialisation
0142               *--------------------------------------------------------------
0143               xfile.record.read:
0144 6DDE C04B  18         mov   r11,r1                ; Save return address
0145 6DE0 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     6DE2 2434 
0146 6DE4 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0147 6DE6 0205  20         li    tmp1,io.op.read       ; io.op.read
     6DE8 0002 
0148 6DEA 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     6DEC 612E 
0149               file.record.read_init:
0150 6DEE 0220  22         ai    r0,9                  ; Move to file descriptor length
     6DF0 0009 
0151 6DF2 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     6DF4 8356 
0152               *--------------------------------------------------------------
0153               * Main
0154               *--------------------------------------------------------------
0155               file.record.read_main:
0156 6DF6 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     6DF8 6C84 
0157 6DFA 0008             data  8                     ;
0158               *--------------------------------------------------------------
0159               * Exit
0160               *--------------------------------------------------------------
0161               file.record.read_exit:
0162 6DFC 1007  14         jmp   file.record.pab.details
0163                                                   ; Get status and return to caller
0164                                                   ; Status register bits are unaffected
0165               
0166               
0167               
0168               
0169               file.record.write:
0170 6DFE 1000  14         nop
0171               
0172               
0173               file.record.seek:
0174 6E00 1000  14         nop
0175               
0176               
0177               file.image.load:
0178 6E02 1000  14         nop
0179               
0180               
0181               file.image.save:
0182 6E04 1000  14         nop
0183               
0184               
0185               file.delete:
0186 6E06 1000  14         nop
0187               
0188               
0189               file.rename:
0190 6E08 1000  14         nop
0191               
0192               
0193               file.status:
0194 6E0A 1000  14         nop
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
0211 6E0C 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0212                                                   ; Upon DSRLNK return status register EQ bit
0213                                                   ; 1 = No file error
0214                                                   ; 0 = File error occured
0215               *--------------------------------------------------------------
0216               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0217               *--------------------------------------------------------------
0218 6E0E C120  34         mov   @file.pab.ptr,tmp0    ; Get VDP address of current PAB
     6E10 2434 
0219 6E12 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     6E14 0005 
0220 6E16 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     6E18 6146 
0221 6E1A C144  18         mov   tmp0,tmp1             ; Move to destination
0222               *--------------------------------------------------------------
0223               * Get PAB byte 1 from VDP ram into tmp0 (status)
0224               *--------------------------------------------------------------
0225 6E1C C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0249 6E1E 0451  20         b     *r1                   ; Return to caller
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
0020 6E20 0300  24 tmgr    limi  0                     ; No interrupt processing
     6E22 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 6E24 D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     6E26 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 6E28 2360  38         coc   @wbit2,r13            ; C flag on ?
     6E2A 6042 
0029 6E2C 1602  14         jne   tmgr1a                ; No, so move on
0030 6E2E E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     6E30 602E 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 6E32 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     6E34 6046 
0035 6E36 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 6E38 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     6E3A 6036 
0048 6E3C 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 6E3E 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     6E40 6034 
0050 6E42 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 6E44 0460  28         b     @kthread              ; Run kernel thread
     6E46 6EBE 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 6E48 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     6E4A 603A 
0056 6E4C 13EB  14         jeq   tmgr1
0057 6E4E 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     6E50 6038 
0058 6E52 16E8  14         jne   tmgr1
0059 6E54 C120  34         mov   @wtiusr,tmp0
     6E56 832E 
0060 6E58 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 6E5A 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     6E5C 6EBC 
0065 6E5E C10A  18         mov   r10,tmp0
0066 6E60 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     6E62 00FF 
0067 6E64 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     6E66 6042 
0068 6E68 1303  14         jeq   tmgr5
0069 6E6A 0284  22         ci    tmp0,60               ; 1 second reached ?
     6E6C 003C 
0070 6E6E 1002  14         jmp   tmgr6
0071 6E70 0284  22 tmgr5   ci    tmp0,50
     6E72 0032 
0072 6E74 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 6E76 1001  14         jmp   tmgr8
0074 6E78 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 6E7A C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     6E7C 832C 
0079 6E7E 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     6E80 FF00 
0080 6E82 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 6E84 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 6E86 05C4  14         inct  tmp0                  ; Second word of slot data
0086 6E88 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 6E8A C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 6E8C 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     6E8E 830C 
     6E90 830D 
0089 6E92 1608  14         jne   tmgr10                ; No, get next slot
0090 6E94 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     6E96 FF00 
0091 6E98 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 6E9A C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     6E9C 8330 
0096 6E9E 0697  24         bl    *tmp3                 ; Call routine in slot
0097 6EA0 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     6EA2 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 6EA4 058A  14 tmgr10  inc   r10                   ; Next slot
0102 6EA6 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     6EA8 8315 
     6EAA 8314 
0103 6EAC 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 6EAE 05C4  14         inct  tmp0                  ; Offset for next slot
0105 6EB0 10E8  14         jmp   tmgr9                 ; Process next slot
0106 6EB2 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 6EB4 10F7  14         jmp   tmgr10                ; Process next slot
0108 6EB6 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     6EB8 FF00 
0109 6EBA 10B4  14         jmp   tmgr1
0110 6EBC 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 6EBE E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     6EC0 6036 
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
0041 6EC2 06A0  32         bl    @realkb               ; Scan full keyboard
     6EC4 6468 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 6EC6 0460  28         b     @tmgr3                ; Exit
     6EC8 6E48 
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
0017 6ECA C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     6ECC 832E 
0018 6ECE E0A0  34         soc   @wbit7,config         ; Enable user hook
     6ED0 6038 
0019 6ED2 045B  20 mkhoo1  b     *r11                  ; Return
0020      6E24     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********@*****@*********************@**************************
0028 6ED4 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     6ED6 832E 
0029 6ED8 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     6EDA FEFF 
0030 6EDC 045B  20         b     *r11                  ; Return
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
0017 6EDE C13B  30 mkslot  mov   *r11+,tmp0
0018 6EE0 C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 6EE2 C184  18         mov   tmp0,tmp2
0023 6EE4 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 6EE6 A1A0  34         a     @wtitab,tmp2          ; Add table base
     6EE8 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 6EEA CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 6EEC 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 6EEE C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 6EF0 881B  46         c     *r11,@w$ffff          ; End of list ?
     6EF2 6048 
0035 6EF4 1301  14         jeq   mkslo1                ; Yes, exit
0036 6EF6 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 6EF8 05CB  14 mkslo1  inct  r11
0041 6EFA 045B  20         b     *r11                  ; Exit
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
0052 6EFC C13B  30 clslot  mov   *r11+,tmp0
0053 6EFE 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 6F00 A120  34         a     @wtitab,tmp0          ; Add table base
     6F02 832C 
0055 6F04 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 6F06 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 6F08 045B  20         b     *r11                  ; Exit
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
0237 6F0A 06A0  32 runlib  bl    @mem.scrpad.backup    ; Backup scratchpad memory to @>2000
     6F0C 6648 
0238 6F0E 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     6F10 8302 
0242               *--------------------------------------------------------------
0243               * Alternative entry point
0244               *--------------------------------------------------------------
0245 6F12 0300  24 runli1  limi  0                     ; Turn off interrupts
     6F14 0000 
0246 6F16 02E0  18         lwpi  ws1                   ; Activate workspace 1
     6F18 8300 
0247 6F1A C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     6F1C 83C0 
0248               *--------------------------------------------------------------
0249               * Clear scratch-pad memory from R4 upwards
0250               *--------------------------------------------------------------
0251 6F1E 0202  20 runli2  li    r2,>8308
     6F20 8308 
0252 6F22 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0253 6F24 0282  22         ci    r2,>8400
     6F26 8400 
0254 6F28 16FC  14         jne   runli3
0255               *--------------------------------------------------------------
0256               * Exit to TI-99/4A title screen ?
0257               *--------------------------------------------------------------
0258               runli3a
0259 6F2A 0281  22         ci    r1,>ffff              ; Exit flag set ?
     6F2C FFFF 
0260 6F2E 1602  14         jne   runli4                ; No, continue
0261 6F30 0420  54         blwp  @0                    ; Yes, bye bye
     6F32 0000 
0262               *--------------------------------------------------------------
0263               * Determine if VDP is PAL or NTSC
0264               *--------------------------------------------------------------
0265 6F34 C803  38 runli4  mov   r3,@waux1             ; Store random seed
     6F36 833C 
0266 6F38 04C1  14         clr   r1                    ; Reset counter
0267 6F3A 0202  20         li    r2,10                 ; We test 10 times
     6F3C 000A 
0268 6F3E C0E0  34 runli5  mov   @vdps,r3
     6F40 8802 
0269 6F42 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     6F44 6046 
0270 6F46 1302  14         jeq   runli6
0271 6F48 0581  14         inc   r1                    ; Increase counter
0272 6F4A 10F9  14         jmp   runli5
0273 6F4C 0602  14 runli6  dec   r2                    ; Next test
0274 6F4E 16F7  14         jne   runli5
0275 6F50 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     6F52 1250 
0276 6F54 1202  14         jle   runli7                ; No, so it must be NTSC
0277 6F56 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     6F58 6042 
0278               *--------------------------------------------------------------
0279               * Copy machine code to scratchpad (prepare tight loop)
0280               *--------------------------------------------------------------
0281 6F5A 0201  20 runli7  li    r1,mccode             ; Machinecode to patch
     6F5C 60B6 
0282 6F5E 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     6F60 8322 
0283 6F62 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0284 6F64 CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0285 6F66 CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0286               *--------------------------------------------------------------
0287               * Initialize registers, memory, ...
0288               *--------------------------------------------------------------
0289 6F68 04C1  14 runli9  clr   r1
0290 6F6A 04C2  14         clr   r2
0291 6F6C 04C3  14         clr   r3
0292 6F6E 0209  20         li    stack,>8400           ; Set stack
     6F70 8400 
0293 6F72 020F  20         li    r15,vdpw              ; Set VDP write address
     6F74 8C00 
0297               *--------------------------------------------------------------
0298               * Setup video memory
0299               *--------------------------------------------------------------
0301 6F76 0280  22         ci    r0,>4a4a              ; Crash flag set?
     6F78 4A4A 
0302 6F7A 1605  14         jne   runlia
0303 6F7C 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     6F7E 60F0 
0304 6F80 0000             data  >0000,>00,>3fff       ; of 16K, so that PABs survive
     6F82 0000 
     6F84 3FFF 
0309 6F86 06A0  32 runlia  bl    @filv
     6F88 60F0 
0310 6F8A 0FC0             data  pctadr,spfclr,16      ; Load color table
     6F8C 00F5 
     6F8E 0010 
0311               *--------------------------------------------------------------
0312               * Check if there is a F18A present
0313               *--------------------------------------------------------------
0317 6F90 06A0  32         bl    @f18unl               ; Unlock the F18A
     6F92 63D8 
0318 6F94 06A0  32         bl    @f18chk               ; Check if F18A is there
     6F96 63F2 
0319 6F98 06A0  32         bl    @f18lck               ; Lock the F18A again
     6F9A 63E8 
0321               *--------------------------------------------------------------
0322               * Check if there is a speech synthesizer attached
0323               *--------------------------------------------------------------
0325               *       <<skipped>>
0329               *--------------------------------------------------------------
0330               * Load video mode table & font
0331               *--------------------------------------------------------------
0332 6F9C 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     6F9E 615A 
0333 6FA0 60AC             data  spvmod                ; Equate selected video mode table
0334 6FA2 0204  20         li    tmp0,spfont           ; Get font option
     6FA4 000C 
0335 6FA6 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0336 6FA8 1304  14         jeq   runlid                ; Yes, skip it
0337 6FAA 06A0  32         bl    @ldfnt
     6FAC 61C2 
0338 6FAE 1100             data  fntadr,spfont         ; Load specified font
     6FB0 000C 
0339               *--------------------------------------------------------------
0340               * Did a system crash occur before runlib was called?
0341               *--------------------------------------------------------------
0342 6FB2 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     6FB4 4A4A 
0343 6FB6 1602  14         jne   runlie                ; No, continue
0344 6FB8 0460  28         b     @crash_handler.main   ; Yes, back to crash handler
     6FBA 605C 
0345               *--------------------------------------------------------------
0346               * Branch to main program
0347               *--------------------------------------------------------------
0348 6FBC 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     6FBE 0040 
0349 6FC0 0460  28         b     @main                 ; Give control to main program
     6FC2 6FC4 
**** **** ****     > tivi.asm.19002
0183               
0184               *--------------------------------------------------------------
0185               * Video mode configuration
0186               *--------------------------------------------------------------
0187      60AC     spvmod  equ   tx8030                ; Video mode.   See VIDTAB for details.
0188      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0189      0050     colrow  equ   80                    ; Columns per row
0190      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0191      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0192      1800     sprpdt  equ   >1800                 ; VDP sprite pattern table
0193      2000     sprsat  equ   >2000                 ; VDP sprite attribute table
0194               
0195               
0196               ***************************************************************
0197               * Main
0198               ********@*****@*********************@**************************
0199 6FC4 20A0  38 main    coc   @wbit1,config         ; F18a detected?
     6FC6 6044 
0200 6FC8 1302  14         jeq   main.continue
0201 6FCA 0420  54         blwp  @0                    ; Exit for now if no F18a detected
     6FCC 0000 
0202               
0203               main.continue:
0204 6FCE 06A0  32         bl    @scroff               ; Turn screen off
     6FD0 6334 
0205 6FD2 06A0  32         bl    @f18unl               ; Unlock the F18a
     6FD4 63D8 
0206 6FD6 06A0  32         bl    @putvr                ; Turn on 30 rows mode.
     6FD8 6194 
0207 6FDA 3140                   data >3140            ; F18a VR49 (>31), bit 40
0208                       ;------------------------------------------------------
0209                       ; Initialize VDP SIT
0210                       ;------------------------------------------------------
0211 6FDC 06A0  32         bl    @filv
     6FDE 60F0 
0212 6FE0 0000                   data >0000,32,31*80   ; Clear VDP SIT
     6FE2 0020 
     6FE4 09B0 
0213 6FE6 06A0  32         bl    @scron                ; Turn screen on
     6FE8 633C 
0214                       ;------------------------------------------------------
0215                       ; Initialize low + high memory expansion
0216                       ;------------------------------------------------------
0217 6FEA 06A0  32         bl    @film
     6FEC 60CC 
0218 6FEE 2200                   data >2200,00,8*1024-256*2
     6FF0 0000 
     6FF2 3E00 
0219                                                   ; Clear part of 8k low-memory
0220               
0221 6FF4 06A0  32         bl    @film
     6FF6 60CC 
0222 6FF8 A000                   data >a000,00,24*1024 ; Clear 24k high-memory
     6FFA 0000 
     6FFC 6000 
0223                       ;------------------------------------------------------
0224                       ; Setup cursor, screen, etc.
0225                       ;------------------------------------------------------
0226 6FFE 06A0  32         bl    @smag1x               ; Sprite magnification 1x
     7000 6354 
0227 7002 06A0  32         bl    @s8x8                 ; Small sprite
     7004 6364 
0228               
0229 7006 06A0  32         bl    @cpym2m
     7008 62E2 
0230 700A 7A7E                   data romsat,ramsat,4  ; Load sprite SAT
     700C 8380 
     700E 0004 
0231               
0232 7010 C820  54         mov   @romsat+2,@fb.curshape
     7012 7A80 
     7014 2210 
0233                                                   ; Save cursor shape & color
0234               
0235 7016 06A0  32         bl    @cpym2v
     7018 629A 
0236 701A 1800                   data sprpdt,cursors,3*8
     701C 7A82 
     701E 0018 
0237                                                   ; Load sprite cursor patterns
0238               *--------------------------------------------------------------
0239               * Initialize
0240               *--------------------------------------------------------------
0241 7020 06A0  32         bl    @edb.init             ; Initialize editor buffer
     7022 7864 
0242 7024 06A0  32         bl    @idx.init             ; Initialize index
     7026 778A 
0243 7028 06A0  32         bl    @fb.init              ; Initialize framebuffer
     702A 76B8 
0244               
0245 702C 06A0  32         bl    @tfh.file.dv80.read
     702E 79BC 
0246               
0247                       ;-------------------------------------------------------
0248                       ; Setup editor tasks & hook
0249                       ;-------------------------------------------------------
0250 7030 0204  20         li    tmp0,>0200
     7032 0200 
0251 7034 C804  38         mov   tmp0,@btihi           ; Highest slot in use
     7036 8314 
0252               
0253 7038 06A0  32         bl    @at
     703A 6374 
0254 703C 0000             data  >0000                 ; Cursor YX position = >0000
0255               
0256 703E 0204  20         li    tmp0,timers
     7040 8370 
0257 7042 C804  38         mov   tmp0,@wtitab
     7044 832C 
0258               
0259 7046 06A0  32         bl    @mkslot
     7048 6EDE 
0260 704A 0001                   data >0001,task0      ; Task 0 - Update screen
     704C 7544 
0261 704E 0101                   data >0101,task1      ; Task 1 - Update cursor position
     7050 75C8 
0262 7052 020F                   data >020f,task2,eol  ; Task 2 - Toggle cursor shape
     7054 75D6 
     7056 FFFF 
0263               
0264 7058 06A0  32         bl    @mkhook
     705A 6ECA 
0265 705C 7062                   data editor           ; Setup user hook
0266               
0267 705E 0460  28         b     @tmgr                 ; Start timers and kthread
     7060 6E20 
0268               
0269               
0270               ****************************************************************
0271               * Editor - Main loop
0272               ****************************************************************
0273 7062 20A0  38 editor  coc   @wbit11,config        ; ANYKEY pressed ?
     7064 6030 
0274 7066 160A  14         jne   ed_clear_kbbuffer     ; No, clear buffer and exit
0275               *---------------------------------------------------------------
0276               * Identical key pressed ?
0277               *---------------------------------------------------------------
0278 7068 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
     706A 6030 
0279 706C 8820  54         c     @waux1,@waux2         ; Still pressing previous key?
     706E 833C 
     7070 833E 
0280 7072 1308  14         jeq   ed_wait
0281               *--------------------------------------------------------------
0282               * New key pressed
0283               *--------------------------------------------------------------
0284               ed_new_key
0285 7074 C820  54         mov   @waux1,@waux2         ; Save as previous key
     7076 833C 
     7078 833E 
0286 707A 102F  14         jmp   ed_pk
0287               *--------------------------------------------------------------
0288               * Clear keyboard buffer if no key pressed
0289               *--------------------------------------------------------------
0290               ed_clear_kbbuffer
0291 707C 04E0  34         clr   @waux1
     707E 833C 
0292 7080 04E0  34         clr   @waux2
     7082 833E 
0293               *--------------------------------------------------------------
0294               * Delay to avoid key bouncing
0295               *--------------------------------------------------------------
0296               ed_wait
0297 7084 0204  20         li    tmp0,1800             ; Key delay to avoid bouncing keys
     7086 0708 
0298                       ;------------------------------------------------------
0299                       ; Delay loop
0300                       ;------------------------------------------------------
0301               ed_wait_loop
0302 7088 0604  14         dec   tmp0
0303 708A 16FE  14         jne   ed_wait_loop
0304               *--------------------------------------------------------------
0305               * Exit
0306               *--------------------------------------------------------------
0307 708C 0460  28 ed_exit b     @hookok               ; Return
     708E 6E24 
0308               
0309               
0310               
0311               
0312               
0313               
0314               ***************************************************************
0315               *              ed_pk - Editor Process Key module
0316               ***************************************************************
0317                       copy  "ed_pk.asm"
**** **** ****     > ed_pk.asm
0001               * FILE......: ed_pk.asm
0002               * Purpose...: Editor Process Key
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Movement keys
0007               *---------------------------------------------------------------
0008      0800     key_left      equ >0800                      ; fnctn + s
0009      0900     key_right     equ >0900                      ; fnctn + d
0010      0B00     key_up        equ >0b00                      ; fnctn + e
0011      0A00     key_down      equ >0a00                      ; fnctn + x
0012      8100     key_home      equ >8100                      ; ctrl  + a
0013      8600     key_end       equ >8600                      ; ctrl  + f
0014      9300     key_pword     equ >9300                      ; ctrl  + s
0015      8400     key_nword     equ >8400                      ; ctrl  + d
0016      8500     key_ppage     equ >8500                      ; ctrl  + e
0017      9800     key_npage     equ >9800                      ; ctrl  + x
0018               *---------------------------------------------------------------
0019               * Modifier keys
0020               *---------------------------------------------------------------
0021      0D00     key_enter       equ >0d00                    ; enter
0022      0300     key_del_char    equ >0300                    ; fnctn + 1
0023      0700     key_del_line    equ >0700                    ; fnctn + 3
0024      8B00     key_del_eol     equ >8b00                    ; ctrl  + k
0025      0400     key_ins_char    equ >0400                    ; fnctn + 2
0026      B200     key_ins_onoff   equ >b200                    ; ctrl  + 2
0027      0E00     key_ins_line    equ >0e00                    ; fnctn + 5
0028      0500     key_quit1       equ >0500                    ; fnctn + +
0029      9D00     key_quit2       equ >9d00                    ; ctrl  + +
0030               *---------------------------------------------------------------
0031               * Action keys mapping <-> actions table
0032               *---------------------------------------------------------------
0033               keymap_actions
0034                       ;-------------------------------------------------------
0035                       ; Movement keys
0036                       ;-------------------------------------------------------
0037 7090 0D00             data  key_enter,ed_pk.action.enter          ; New line
     7092 748E 
0038 7094 0800             data  key_left,ed_pk.action.left            ; Move cursor left
     7096 7104 
0039 7098 0900             data  key_right,ed_pk.action.right          ; Move cursor right
     709A 711A 
0040 709C 0B00             data  key_up,ed_pk.action.up                ; Move cursor up
     709E 7132 
0041 70A0 0A00             data  key_down,ed_pk.action.down            ; Move cursor down
     70A2 7184 
0042 70A4 8100             data  key_home,ed_pk.action.home            ; Move cursor to line begin
     70A6 71F0 
0043 70A8 8600             data  key_end,ed_pk.action.end              ; Move cursor to line end
     70AA 7208 
0044 70AC 9300             data  key_pword,ed_pk.action.pword          ; Move cursor previous word
     70AE 721C 
0045 70B0 8400             data  key_nword,ed_pk.action.nword          ; Move cursor next word
     70B2 726E 
0046 70B4 8500             data  key_ppage,ed_pk.action.ppage          ; Move cursor previous page
     70B6 72CE 
0047 70B8 9800             data  key_npage,ed_pk.action.npage          ; Move cursor next page
     70BA 7318 
0048                       ;-------------------------------------------------------
0049                       ; Modifier keys - Delete
0050                       ;-------------------------------------------------------
0051 70BC 0300             data  key_del_char,ed_pk.action.del_char    ; Delete character
     70BE 7344 
0052 70C0 8B00             data  key_del_eol,ed_pk.action.del_eol      ; Delete until end of line
     70C2 7378 
0053 70C4 0700             data  key_del_line,ed_pk.action.del_line    ; Delete current line
     70C6 73A8 
0054                       ;-------------------------------------------------------
0055                       ; Modifier keys - Insert
0056                       ;-------------------------------------------------------
0057 70C8 0400             data  key_ins_char,ed_pk.action.ins_char.ws ; Insert whitespace
     70CA 73FC 
0058 70CC B200             data  key_ins_onoff,ed_pk.action.ins_onoff  ; Insert mode on/off
     70CE 74F8 
0059 70D0 0E00             data  key_ins_line,ed_pk.action.ins_line    ; Insert new line
     70D2 744E 
0060                       ;-------------------------------------------------------
0061                       ; Other action keys
0062                       ;-------------------------------------------------------
0063 70D4 0500             data  key_quit1,ed_pk.action.quit           ; Quit TiVi
     70D6 70FC 
0064 70D8 FFFF             data  >ffff                                 ; EOL
0065               
0066               
0067               
0068               ****************************************************************
0069               * Editor - Process key
0070               ****************************************************************
0071 70DA C160  34 ed_pk   mov   @waux1,tmp1           ; Get key value
     70DC 833C 
0072 70DE 0245  22         andi  tmp1,>ff00            ; Get rid of LSB
     70E0 FF00 
0073               
0074 70E2 0206  20         li    tmp2,keymap_actions   ; Load keyboard map
     70E4 7090 
0075 70E6 0707  14         seto  tmp3                  ; EOL marker
0076                       ;-------------------------------------------------------
0077                       ; Iterate over keyboard map for matching key
0078                       ;-------------------------------------------------------
0079               ed_pk.check_next_key:
0080 70E8 81D6  26         c     *tmp2,tmp3            ; EOL reached ?
0081 70EA 1306  14         jeq   ed_pk.do_action.set   ; Yes, so go add letter
0082               
0083 70EC 8D85  34         c     tmp1,*tmp2+           ; Key matched?
0084 70EE 1302  14         jeq   ed_pk.do_action       ; Yes, do action
0085 70F0 05C6  14         inct  tmp2                  ; No, skip action
0086 70F2 10FA  14         jmp   ed_pk.check_next_key  ; Next key
0087               
0088               ed_pk.do_action:
0089 70F4 C196  26         mov  *tmp2,tmp2             ; Get action address
0090 70F6 0456  20         b    *tmp2                  ; Process key action
0091               ed_pk.do_action.set:
0092 70F8 0460  28         b    @ed_pk.action.char     ; Add character to buffer
     70FA 7508 
0093               
0094               
0095               
0096               *---------------------------------------------------------------
0097               * Quit
0098               *---------------------------------------------------------------
0099               ed_pk.action.quit:
0100 70FC 06A0  32         bl    @f18rst               ; Reset and lock the F18A
     70FE 643C 
0101 7100 0420  54         blwp  @0                    ; Exit
     7102 0000 
0102               
0103               
0104               *---------------------------------------------------------------
0105               * Cursor left
0106               *---------------------------------------------------------------
0107               ed_pk.action.left:
0108 7104 C120  34         mov   @fb.column,tmp0
     7106 220C 
0109 7108 1306  14         jeq   !jmp2b                ; column=0 ? Skip further processing
0110                       ;-------------------------------------------------------
0111                       ; Update
0112                       ;-------------------------------------------------------
0113 710A 0620  34         dec   @fb.column            ; Column-- in screen buffer
     710C 220C 
0114 710E 0620  34         dec   @wyx                  ; Column-- VDP cursor
     7110 832A 
0115 7112 0620  34         dec   @fb.current
     7114 2202 
0116                       ;-------------------------------------------------------
0117                       ; Exit
0118                       ;-------------------------------------------------------
0119 7116 0460  28 !jmp2b  b     @ed_wait              ; Back to editor main
     7118 7084 
0120               
0121               
0122               *---------------------------------------------------------------
0123               * Cursor right
0124               *---------------------------------------------------------------
0125               ed_pk.action.right:
0126 711A 8820  54         c     @fb.column,@fb.row.length
     711C 220C 
     711E 2208 
0127 7120 1406  14         jhe   !jmp2b                ; column > length line ? Skip further processing
0128                       ;-------------------------------------------------------
0129                       ; Update
0130                       ;-------------------------------------------------------
0131 7122 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     7124 220C 
0132 7126 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     7128 832A 
0133 712A 05A0  34         inc   @fb.current
     712C 2202 
0134                       ;-------------------------------------------------------
0135                       ; Exit
0136                       ;-------------------------------------------------------
0137 712E 0460  28 !jmp2b  b     @ed_wait              ; Back to editor main
     7130 7084 
0138               
0139               
0140               *---------------------------------------------------------------
0141               * Cursor up
0142               *---------------------------------------------------------------
0143               ed_pk.action.up:
0144                       ;-------------------------------------------------------
0145                       ; Crunch current line if dirty
0146                       ;-------------------------------------------------------
0147 7132 8820  54         c     @fb.row.dirty,@w$ffff
     7134 220A 
     7136 6048 
0148 7138 1604  14         jne   ed_pk.action.up.cursor
0149 713A 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     713C 787C 
0150 713E 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     7140 220A 
0151                       ;-------------------------------------------------------
0152                       ; Move cursor
0153                       ;-------------------------------------------------------
0154               ed_pk.action.up.cursor:
0155 7142 C120  34         mov   @fb.row,tmp0
     7144 2206 
0156 7146 1509  14         jgt   ed_pk.action.up.cursor_up
0157                                                   ; Move cursor up if fb.row>0
0158 7148 C120  34         mov   @fb.topline,tmp0      ; Do we need to scroll?
     714A 2204 
0159 714C 130A  14         jeq   ed_pk.action.up.set_cursorx
0160                                                   ; At top, only position cursor X
0161                       ;-------------------------------------------------------
0162                       ; Scroll 1 line
0163                       ;-------------------------------------------------------
0164 714E 0604  14         dec   tmp0                  ; fb.topline--
0165 7150 C804  38         mov   tmp0,@parm1
     7152 8350 
0166 7154 06A0  32         bl    @fb.refresh           ; Scroll one line up
     7156 7718 
0167 7158 1004  14         jmp   ed_pk.action.up.set_cursorx
0168                       ;-------------------------------------------------------
0169                       ; Move cursor up
0170                       ;-------------------------------------------------------
0171               ed_pk.action.up.cursor_up:
0172 715A 0620  34         dec   @fb.row               ; Row-- in screen buffer
     715C 2206 
0173 715E 06A0  32         bl    @up                   ; Row-- VDP cursor
     7160 6382 
0174                       ;-------------------------------------------------------
0175                       ; Check line length and position cursor
0176                       ;-------------------------------------------------------
0177               ed_pk.action.up.set_cursorx:
0178 7162 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     7164 7998 
0179 7166 8820  54         c     @fb.column,@fb.row.length
     7168 220C 
     716A 2208 
0180 716C 1207  14         jle   ed_pk.action.up.$$
0181                       ;-------------------------------------------------------
0182                       ; Adjust cursor column position
0183                       ;-------------------------------------------------------
0184 716E C820  54         mov   @fb.row.length,@fb.column
     7170 2208 
     7172 220C 
0185 7174 C120  34         mov   @fb.column,tmp0
     7176 220C 
0186 7178 06A0  32         bl    @xsetx                ; Set VDP cursor X
     717A 638C 
0187                       ;-------------------------------------------------------
0188                       ; Exit
0189                       ;-------------------------------------------------------
0190               ed_pk.action.up.$$:
0191 717C 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     717E 76FC 
0192 7180 0460  28         b     @ed_wait              ; Back to editor main
     7182 7084 
0193               
0194               
0195               
0196               *---------------------------------------------------------------
0197               * Cursor down
0198               *---------------------------------------------------------------
0199               ed_pk.action.down:
0200 7184 8820  54         c     @fb.row,@edb.lines    ; Last line in editor buffer ?
     7186 2206 
     7188 2304 
0201 718A 1330  14         jeq   !jmp2b                ; Yes, skip further processing
0202                       ;-------------------------------------------------------
0203                       ; Crunch current row if dirty
0204                       ;-------------------------------------------------------
0205 718C 8820  54         c     @fb.row.dirty,@w$ffff
     718E 220A 
     7190 6048 
0206 7192 1604  14         jne   ed_pk.action.down.move
0207 7194 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     7196 787C 
0208 7198 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     719A 220A 
0209                       ;-------------------------------------------------------
0210                       ; Move cursor
0211                       ;-------------------------------------------------------
0212               ed_pk.action.down.move:
0213                       ;-------------------------------------------------------
0214                       ; EOF reached?
0215                       ;-------------------------------------------------------
0216 719C C120  34         mov   @fb.topline,tmp0
     719E 2204 
0217 71A0 A120  34         a     @fb.row,tmp0
     71A2 2206 
0218 71A4 8120  34         c     @edb.lines,tmp0       ; fb.topline + fb.row = edb.lines ?
     71A6 2304 
0219 71A8 1312  14         jeq   ed_pk.action.down.set_cursorx
0220                                                   ; Yes, only position cursor X
0221                       ;-------------------------------------------------------
0222                       ; Check if scrolling required
0223                       ;-------------------------------------------------------
0224 71AA C120  34         mov   @fb.screenrows,tmp0
     71AC 2218 
0225 71AE 0604  14         dec   tmp0
0226 71B0 8120  34         c     @fb.row,tmp0
     71B2 2206 
0227 71B4 1108  14         jlt   ed_pk.action.down.cursor
0228                       ;-------------------------------------------------------
0229                       ; Scroll 1 line
0230                       ;-------------------------------------------------------
0231 71B6 C820  54         mov   @fb.topline,@parm1
     71B8 2204 
     71BA 8350 
0232 71BC 05A0  34         inc   @parm1
     71BE 8350 
0233 71C0 06A0  32         bl    @fb.refresh
     71C2 7718 
0234 71C4 1004  14         jmp   ed_pk.action.down.set_cursorx
0235                       ;-------------------------------------------------------
0236                       ; Move cursor down a row, there are still rows left
0237                       ;-------------------------------------------------------
0238               ed_pk.action.down.cursor:
0239 71C6 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     71C8 2206 
0240 71CA 06A0  32         bl    @down                 ; Row++ VDP cursor
     71CC 637A 
0241                       ;-------------------------------------------------------
0242                       ; Check line length and position cursor
0243                       ;-------------------------------------------------------
0244               ed_pk.action.down.set_cursorx:
0245 71CE 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     71D0 7998 
0246 71D2 8820  54         c     @fb.column,@fb.row.length
     71D4 220C 
     71D6 2208 
0247 71D8 1207  14         jle   ed_pk.action.down.$$  ; Exit
0248                       ;-------------------------------------------------------
0249                       ; Adjust cursor column position
0250                       ;-------------------------------------------------------
0251 71DA C820  54         mov   @fb.row.length,@fb.column
     71DC 2208 
     71DE 220C 
0252 71E0 C120  34         mov   @fb.column,tmp0
     71E2 220C 
0253 71E4 06A0  32         bl    @xsetx                ; Set VDP cursor X
     71E6 638C 
0254                       ;-------------------------------------------------------
0255                       ; Exit
0256                       ;-------------------------------------------------------
0257               ed_pk.action.down.$$:
0258 71E8 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     71EA 76FC 
0259 71EC 0460  28 !jmp2b  b     @ed_wait              ; Back to editor main
     71EE 7084 
0260               
0261               
0262               
0263               *---------------------------------------------------------------
0264               * Cursor beginning of line
0265               *---------------------------------------------------------------
0266               ed_pk.action.home:
0267 71F0 C120  34         mov   @wyx,tmp0
     71F2 832A 
0268 71F4 0244  22         andi  tmp0,>ff00
     71F6 FF00 
0269 71F8 C804  38         mov   tmp0,@wyx             ; VDP cursor column=0
     71FA 832A 
0270 71FC 04E0  34         clr   @fb.column
     71FE 220C 
0271 7200 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7202 76FC 
0272 7204 0460  28         b     @ed_wait              ; Back to editor main
     7206 7084 
0273               
0274               *---------------------------------------------------------------
0275               * Cursor end of line
0276               *---------------------------------------------------------------
0277               ed_pk.action.end:
0278 7208 C120  34         mov   @fb.row.length,tmp0
     720A 2208 
0279 720C C804  38         mov   tmp0,@fb.column
     720E 220C 
0280 7210 06A0  32         bl    @xsetx                ; Set VDP cursor column position
     7212 638C 
0281 7214 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7216 76FC 
0282 7218 0460  28         b     @ed_wait              ; Back to editor main
     721A 7084 
0283               
0284               
0285               
0286               *---------------------------------------------------------------
0287               * Cursor beginning of word or previous word
0288               *---------------------------------------------------------------
0289               ed_pk.action.pword:
0290 721C C120  34         mov   @fb.column,tmp0
     721E 220C 
0291 7220 1324  14         jeq   !jmp2b                ; column=0 ? Skip further processing
0292                       ;-------------------------------------------------------
0293                       ; Prepare 2 char buffer
0294                       ;-------------------------------------------------------
0295 7222 C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     7224 2202 
0296 7226 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0297 7228 1003  14         jmp   ed_pk.action.pword_scan_char
0298                       ;-------------------------------------------------------
0299                       ; Scan backwards to first character following space
0300                       ;-------------------------------------------------------
0301               ed_pk.action.pword_scan
0302 722A 0605  14         dec   tmp1
0303 722C 0604  14         dec   tmp0                  ; Column-- in screen buffer
0304 722E 1315  14         jeq   ed_pk.action.pword_done
0305                                                   ; Column=0 ? Skip further processing
0306                       ;-------------------------------------------------------
0307                       ; Check character
0308                       ;-------------------------------------------------------
0309               ed_pk.action.pword_scan_char
0310 7230 D195  26         movb  *tmp1,tmp2            ; Get character
0311 7232 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0312 7234 D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0313 7236 0986  56         srl   tmp2,8                ; Right justify
0314 7238 0286  22         ci    tmp2,32               ; Space character found?
     723A 0020 
0315 723C 16F6  14         jne   ed_pk.action.pword_scan
0316                                                   ; No space found, try again
0317                       ;-------------------------------------------------------
0318                       ; Space found, now look closer
0319                       ;-------------------------------------------------------
0320 723E 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     7240 2020 
0321 7242 13F3  14         jeq   ed_pk.action.pword_scan
0322                                                   ; Yes, so continue scanning
0323 7244 0287  22         ci    tmp3,>20ff            ; First character is space
     7246 20FF 
0324 7248 13F0  14         jeq   ed_pk.action.pword_scan
0325                       ;-------------------------------------------------------
0326                       ; Check distance travelled
0327                       ;-------------------------------------------------------
0328 724A C1E0  34         mov   @fb.column,tmp3       ; re-use tmp3
     724C 220C 
0329 724E 61C4  18         s     tmp0,tmp3
0330 7250 0287  22         ci    tmp3,2                ; Did we move at least 2 positions?
     7252 0002 
0331 7254 11EA  14         jlt   ed_pk.action.pword_scan
0332                                                   ; Didn't move enough so keep on scanning
0333                       ;--------------------------------------------------------
0334                       ; Set cursor following space
0335                       ;--------------------------------------------------------
0336 7256 0585  14         inc   tmp1
0337 7258 0584  14         inc   tmp0                  ; Column++ in screen buffer
0338                       ;-------------------------------------------------------
0339                       ; Save position and position hardware cursor
0340                       ;-------------------------------------------------------
0341               ed_pk.action.pword_done:
0342 725A C805  38         mov   tmp1,@fb.current
     725C 2202 
0343 725E C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     7260 220C 
0344 7262 06A0  32         bl    @xsetx                ; Set VDP cursor X
     7264 638C 
0345                       ;-------------------------------------------------------
0346                       ; Exit
0347                       ;-------------------------------------------------------
0348               ed_pk.action.pword.$$:
0349 7266 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7268 76FC 
0350 726A 0460  28 !jmp2b  b     @ed_wait              ; Back to editor main
     726C 7084 
0351               
0352               
0353               
0354               *---------------------------------------------------------------
0355               * Cursor next word
0356               *---------------------------------------------------------------
0357               ed_pk.action.nword:
0358 726E 04C8  14         clr   tmp4                  ; Reset multiple spaces mode
0359 7270 C120  34         mov   @fb.column,tmp0
     7272 220C 
0360 7274 8804  38         c     tmp0,@fb.row.length
     7276 2208 
0361 7278 1428  14         jhe   !jmp2b                ; column=last char ? Skip further processing
0362                       ;-------------------------------------------------------
0363                       ; Prepare 2 char buffer
0364                       ;-------------------------------------------------------
0365 727A C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     727C 2202 
0366 727E 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0367 7280 1006  14         jmp   ed_pk.action.nword_scan_char
0368                       ;-------------------------------------------------------
0369                       ; Multiple spaces mode
0370                       ;-------------------------------------------------------
0371               ed_pk.action.nword_ms:
0372 7282 0708  14         seto  tmp4                  ; Set multiple spaces mode
0373                       ;-------------------------------------------------------
0374                       ; Scan forward to first character following space
0375                       ;-------------------------------------------------------
0376               ed_pk.action.nword_scan
0377 7284 0585  14         inc   tmp1
0378 7286 0584  14         inc   tmp0                  ; Column++ in screen buffer
0379 7288 8804  38         c     tmp0,@fb.row.length
     728A 2208 
0380 728C 1316  14         jeq   ed_pk.action.nword_done
0381                                                   ; Column=last char ? Skip further processing
0382                       ;-------------------------------------------------------
0383                       ; Check character
0384                       ;-------------------------------------------------------
0385               ed_pk.action.nword_scan_char
0386 728E D195  26         movb  *tmp1,tmp2            ; Get character
0387 7290 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0388 7292 D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0389 7294 0986  56         srl   tmp2,8                ; Right justify
0390               
0391 7296 0288  22         ci    tmp4,>ffff            ; Multiple space mode on?
     7298 FFFF 
0392 729A 1604  14         jne   ed_pk.action.nword_scan_char_other
0393                       ;-------------------------------------------------------
0394                       ; Special handling if multiple spaces found
0395                       ;-------------------------------------------------------
0396               ed_pk.action.nword_scan_char_ms:
0397 729C 0286  22         ci    tmp2,32
     729E 0020 
0398 72A0 160C  14         jne   ed_pk.action.nword_done
0399                                                   ; Exit if non-space found
0400 72A2 10F0  14         jmp   ed_pk.action.nword_scan
0401                       ;-------------------------------------------------------
0402                       ; Normal handling
0403                       ;-------------------------------------------------------
0404               ed_pk.action.nword_scan_char_other:
0405 72A4 0286  22         ci    tmp2,32               ; Space character found?
     72A6 0020 
0406 72A8 16ED  14         jne   ed_pk.action.nword_scan
0407                                                   ; No space found, try again
0408                       ;-------------------------------------------------------
0409                       ; Space found, now look closer
0410                       ;-------------------------------------------------------
0411 72AA 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     72AC 2020 
0412 72AE 13E9  14         jeq   ed_pk.action.nword_ms
0413                                                   ; Yes, so continue scanning
0414 72B0 0287  22         ci    tmp3,>20ff            ; First characer is space?
     72B2 20FF 
0415 72B4 13E7  14         jeq   ed_pk.action.nword_scan
0416                       ;--------------------------------------------------------
0417                       ; Set cursor following space
0418                       ;--------------------------------------------------------
0419 72B6 0585  14         inc   tmp1
0420 72B8 0584  14         inc   tmp0                  ; Column++ in screen buffer
0421                       ;-------------------------------------------------------
0422                       ; Save position and position hardware cursor
0423                       ;-------------------------------------------------------
0424               ed_pk.action.nword_done:
0425 72BA C805  38         mov   tmp1,@fb.current
     72BC 2202 
0426 72BE C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     72C0 220C 
0427 72C2 06A0  32         bl    @xsetx                ; Set VDP cursor X
     72C4 638C 
0428                       ;-------------------------------------------------------
0429                       ; Exit
0430                       ;-------------------------------------------------------
0431               ed_pk.action.nword.$$:
0432 72C6 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     72C8 76FC 
0433 72CA 0460  28 !jmp2b  b     @ed_wait              ; Back to editor main
     72CC 7084 
0434               
0435               
0436               
0437               
0438               *---------------------------------------------------------------
0439               * Previous page
0440               *---------------------------------------------------------------
0441               ed_pk.action.ppage:
0442                       ;-------------------------------------------------------
0443                       ; Sanity check
0444                       ;-------------------------------------------------------
0445 72CE C120  34         mov   @fb.topline,tmp0      ; Exit if already on line 1
     72D0 2204 
0446 72D2 1316  14         jeq   ed_pk.action.ppage.$$
0447                       ;-------------------------------------------------------
0448                       ; Special treatment top page
0449                       ;-------------------------------------------------------
0450 72D4 8804  38         c     tmp0,@fb.screenrows   ; topline > rows on screen?
     72D6 2218 
0451 72D8 1503  14         jgt   ed_pk.action.ppage.topline
0452 72DA 04E0  34         clr   @fb.topline           ; topline = 0
     72DC 2204 
0453 72DE 1003  14         jmp   ed_pk.action.ppage.crunch
0454                       ;-------------------------------------------------------
0455                       ; Adjust topline
0456                       ;-------------------------------------------------------
0457               ed_pk.action.ppage.topline:
0458 72E0 6820  54         s     @fb.screenrows,@fb.topline
     72E2 2218 
     72E4 2204 
0459                       ;-------------------------------------------------------
0460                       ; Crunch current row if dirty
0461                       ;-------------------------------------------------------
0462               ed_pk.action.ppage.crunch:
0463 72E6 8820  54         c     @fb.row.dirty,@w$ffff
     72E8 220A 
     72EA 6048 
0464 72EC 1604  14         jne   ed_pk.action.ppage.refresh
0465 72EE 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     72F0 787C 
0466 72F2 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     72F4 220A 
0467                       ;-------------------------------------------------------
0468                       ; Refresh page
0469                       ;-------------------------------------------------------
0470               ed_pk.action.ppage.refresh:
0471 72F6 C820  54         mov   @fb.topline,@parm1
     72F8 2204 
     72FA 8350 
0472 72FC 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     72FE 7718 
0473                       ;-------------------------------------------------------
0474                       ; Exit
0475                       ;-------------------------------------------------------
0476               ed_pk.action.ppage.$$:
0477 7300 04E0  34         clr   @fb.row
     7302 2206 
0478 7304 05A0  34         inc   @fb.row               ; Set fb.row=1
     7306 2206 
0479 7308 04E0  34         clr   @fb.column
     730A 220C 
0480 730C 0204  20         li    tmp0,>0100            ; Set VDP cursor on line 1, column 0
     730E 0100 
0481 7310 C804  38         mov   tmp0,@wyx             ; In ed_pk.action up cursor is moved up
     7312 832A 
0482 7314 0460  28         b     @ed_pk.action.up      ; Do rest of logic
     7316 7132 
0483               
0484               
0485               
0486               *---------------------------------------------------------------
0487               * Next page
0488               *---------------------------------------------------------------
0489               ed_pk.action.npage:
0490                       ;-------------------------------------------------------
0491                       ; Sanity check
0492                       ;-------------------------------------------------------
0493 7318 C120  34         mov   @fb.topline,tmp0
     731A 2204 
0494 731C A120  34         a     @fb.screenrows,tmp0
     731E 2218 
0495 7320 8804  38         c     tmp0,@edb.lines       ; Exit if on last page
     7322 2304 
0496 7324 150D  14         jgt   ed_pk.action.npage.$$
0497                       ;-------------------------------------------------------
0498                       ; Adjust topline
0499                       ;-------------------------------------------------------
0500               ed_pk.action.npage.topline:
0501 7326 A820  54         a     @fb.screenrows,@fb.topline
     7328 2218 
     732A 2204 
0502                       ;-------------------------------------------------------
0503                       ; Crunch current row if dirty
0504                       ;-------------------------------------------------------
0505               ed_pk.action.npage.crunch:
0506 732C 8820  54         c     @fb.row.dirty,@w$ffff
     732E 220A 
     7330 6048 
0507 7332 1604  14         jne   ed_pk.action.npage.refresh
0508 7334 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     7336 787C 
0509 7338 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     733A 220A 
0510                       ;-------------------------------------------------------
0511                       ; Refresh page
0512                       ;-------------------------------------------------------
0513               ed_pk.action.npage.refresh:
0514 733C 0460  28         b     @ed_pk.action.ppage.refresh
     733E 72F6 
0515                                                   ; Same logic as previous pabe
0516                       ;-------------------------------------------------------
0517                       ; Exit
0518                       ;-------------------------------------------------------
0519               ed_pk.action.npage.$$:
0520 7340 0460  28         b     @ed_wait              ; Back to editor main
     7342 7084 
0521               
0522               
0523               *---------------------------------------------------------------
0524               * Delete character
0525               *---------------------------------------------------------------
0526               ed_pk.action.del_char:
0527 7344 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7346 76FC 
0528                       ;-------------------------------------------------------
0529                       ; Sanity check 1
0530                       ;-------------------------------------------------------
0531 7348 C120  34         mov   @fb.current,tmp0      ; Get pointer
     734A 2202 
0532 734C C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     734E 2208 
0533 7350 1311  14         jeq   ed_pk.action.del_char.$$
0534                                                   ; Exit if empty line
0535                       ;-------------------------------------------------------
0536                       ; Sanity check 2
0537                       ;-------------------------------------------------------
0538 7352 8820  54         c     @fb.column,@fb.row.length
     7354 220C 
     7356 2208 
0539 7358 130D  14         jeq   ed_pk.action.del_char.$$
0540                                                   ; Exit if at EOL
0541                       ;-------------------------------------------------------
0542                       ; Prepare for delete operation
0543                       ;-------------------------------------------------------
0544 735A C120  34         mov   @fb.current,tmp0      ; Get pointer
     735C 2202 
0545 735E C144  18         mov   tmp0,tmp1             ; Add 1 to pointer
0546 7360 0585  14         inc   tmp1
0547                       ;-------------------------------------------------------
0548                       ; Loop until end of line
0549                       ;-------------------------------------------------------
0550               ed_pk.action.del_char_loop:
0551 7362 DD35  42         movb  *tmp1+,*tmp0+         ; Overwrite current char with next char
0552 7364 0606  14         dec   tmp2
0553 7366 16FD  14         jne   ed_pk.action.del_char_loop
0554                       ;-------------------------------------------------------
0555                       ; Save variables
0556                       ;-------------------------------------------------------
0557 7368 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     736A 220A 
0558 736C 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     736E 2216 
0559 7370 0620  34         dec   @fb.row.length        ; @fb.row.length--
     7372 2208 
0560                       ;-------------------------------------------------------
0561                       ; Exit
0562                       ;-------------------------------------------------------
0563               ed_pk.action.del_char.$$:
0564 7374 0460  28         b     @ed_wait              ; Back to editor main
     7376 7084 
0565               
0566               
0567               *---------------------------------------------------------------
0568               * Delete until end of line
0569               *---------------------------------------------------------------
0570               ed_pk.action.del_eol:
0571 7378 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     737A 76FC 
0572 737C C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     737E 2208 
0573 7380 1311  14         jeq   ed_pk.action.del_eol.$$
0574                                                   ; Exit if empty line
0575                       ;-------------------------------------------------------
0576                       ; Prepare for erase operation
0577                       ;-------------------------------------------------------
0578 7382 C120  34         mov   @fb.current,tmp0      ; Get pointer
     7384 2202 
0579 7386 C1A0  34         mov   @fb.colsline,tmp2
     7388 220E 
0580 738A 61A0  34         s     @fb.column,tmp2
     738C 220C 
0581 738E 04C5  14         clr   tmp1
0582                       ;-------------------------------------------------------
0583                       ; Loop until last column in frame buffer
0584                       ;-------------------------------------------------------
0585               ed_pk.action.del_eol_loop:
0586 7390 DD05  32         movb  tmp1,*tmp0+           ; Overwrite current char with >00
0587 7392 0606  14         dec   tmp2
0588 7394 16FD  14         jne   ed_pk.action.del_eol_loop
0589                       ;-------------------------------------------------------
0590                       ; Save variables
0591                       ;-------------------------------------------------------
0592 7396 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     7398 220A 
0593 739A 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     739C 2216 
0594               
0595 739E C820  54         mov   @fb.column,@fb.row.length
     73A0 220C 
     73A2 2208 
0596                                                   ; Set new row length
0597                       ;-------------------------------------------------------
0598                       ; Exit
0599                       ;-------------------------------------------------------
0600               ed_pk.action.del_eol.$$:
0601 73A4 0460  28         b     @ed_wait              ; Back to editor main
     73A6 7084 
0602               
0603               
0604               *---------------------------------------------------------------
0605               * Delete current line
0606               *---------------------------------------------------------------
0607               ed_pk.action.del_line:
0608                       ;-------------------------------------------------------
0609                       ; Special treatment if only 1 line in file
0610                       ;-------------------------------------------------------
0611 73A8 C120  34         mov   @edb.lines,tmp0
     73AA 2304 
0612 73AC 1604  14         jne   !
0613 73AE 04E0  34         clr   @fb.column            ; Column 0
     73B0 220C 
0614 73B2 0460  28         b     @ed_pk.action.del_eol ; Delete until end of line
     73B4 7378 
0615                       ;-------------------------------------------------------
0616                       ; Delete entry in index
0617                       ;-------------------------------------------------------
0618 73B6 06A0  32 !       bl    @fb.calc_pointer      ; Calculate position in frame buffer
     73B8 76FC 
0619 73BA 04E0  34         clr   @fb.row.dirty         ; Discard current line
     73BC 220A 
0620 73BE C820  54         mov   @fb.topline,@parm1
     73C0 2204 
     73C2 8350 
0621 73C4 A820  54         a     @fb.row,@parm1        ; Line number to remove
     73C6 2206 
     73C8 8350 
0622 73CA C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     73CC 2304 
     73CE 8352 
0623 73D0 06A0  32         bl    @idx.entry.delete     ; Reorganize index
     73D2 77BE 
0624 73D4 0620  34         dec   @edb.lines            ; One line less in editor buffer
     73D6 2304 
0625                       ;-------------------------------------------------------
0626                       ; Refresh frame buffer and physical screen
0627                       ;-------------------------------------------------------
0628 73D8 C820  54         mov   @fb.topline,@parm1
     73DA 2204 
     73DC 8350 
0629 73DE 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     73E0 7718 
0630 73E2 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     73E4 2216 
0631                       ;-------------------------------------------------------
0632                       ; Special treatment if current line was last line
0633                       ;-------------------------------------------------------
0634 73E6 C120  34         mov   @fb.topline,tmp0
     73E8 2204 
0635 73EA A120  34         a     @fb.row,tmp0
     73EC 2206 
0636 73EE 8804  38         c     tmp0,@edb.lines       ; Was last line?
     73F0 2304 
0637 73F2 1202  14         jle   ed_pk.action.del_line.$$
0638 73F4 0460  28         b     @ed_pk.action.up      ; One line up
     73F6 7132 
0639                       ;-------------------------------------------------------
0640                       ; Exit
0641                       ;-------------------------------------------------------
0642               ed_pk.action.del_line.$$:
0643 73F8 0460  28         b     @ed_pk.action.home    ; Move cursor to home and return
     73FA 71F0 
0644               
0645               
0646               
0647               *---------------------------------------------------------------
0648               * Insert character
0649               *
0650               * @parm1 = high byte has character to insert
0651               *---------------------------------------------------------------
0652               ed_pk.action.ins_char.ws
0653 73FC 0204  20         li    tmp0,>2000            ; White space
     73FE 2000 
0654 7400 C804  38         mov   tmp0,@parm1
     7402 8350 
0655               ed_pk.action.ins_char:
0656 7404 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7406 76FC 
0657                       ;-------------------------------------------------------
0658                       ; Sanity check 1 - Empty line
0659                       ;-------------------------------------------------------
0660 7408 C120  34         mov   @fb.current,tmp0      ; Get pointer
     740A 2202 
0661 740C C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     740E 2208 
0662 7410 131A  14         jeq   ed_pk.action.ins_char.sanity
0663                                                   ; Add character in overwrite mode
0664                       ;-------------------------------------------------------
0665                       ; Sanity check 2 - EOL
0666                       ;-------------------------------------------------------
0667 7412 8820  54         c     @fb.column,@fb.row.length
     7414 220C 
     7416 2208 
0668 7418 1316  14         jeq   ed_pk.action.ins_char.sanity
0669                                                   ; Add character in overwrite mode
0670                       ;-------------------------------------------------------
0671                       ; Prepare for insert operation
0672                       ;-------------------------------------------------------
0673               ed_pk.action.skipsanity:
0674 741A C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0675 741C 61E0  34         s     @fb.column,tmp3
     741E 220C 
0676 7420 A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0677 7422 C144  18         mov   tmp0,tmp1
0678 7424 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0679 7426 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     7428 220C 
0680 742A 0586  14         inc   tmp2
0681                       ;-------------------------------------------------------
0682                       ; Loop from end of line until current character
0683                       ;-------------------------------------------------------
0684               ed_pk.action.ins_char_loop:
0685 742C D554  38         movb  *tmp0,*tmp1           ; Move char to the right
0686 742E 0604  14         dec   tmp0
0687 7430 0605  14         dec   tmp1
0688 7432 0606  14         dec   tmp2
0689 7434 16FB  14         jne   ed_pk.action.ins_char_loop
0690                       ;-------------------------------------------------------
0691                       ; Set specified character on current position
0692                       ;-------------------------------------------------------
0693 7436 D560  46         movb  @parm1,*tmp1
     7438 8350 
0694                       ;-------------------------------------------------------
0695                       ; Save variables
0696                       ;-------------------------------------------------------
0697 743A 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     743C 220A 
0698 743E 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     7440 2216 
0699 7442 05A0  34         inc   @fb.row.length        ; @fb.row.length
     7444 2208 
0700                       ;-------------------------------------------------------
0701                       ; Add character in overwrite mode
0702                       ;-------------------------------------------------------
0703               ed_pk.action.ins_char.sanity
0704 7446 0460  28         b     @ed_pk.action.char.overwrite
     7448 7516 
0705                       ;-------------------------------------------------------
0706                       ; Exit
0707                       ;-------------------------------------------------------
0708               ed_pk.action.ins_char.$$:
0709 744A 0460  28         b     @ed_wait              ; Back to editor main
     744C 7084 
0710               
0711               
0712               
0713               
0714               
0715               
0716               *---------------------------------------------------------------
0717               * Insert new line
0718               *---------------------------------------------------------------
0719               ed_pk.action.ins_line:
0720                       ;-------------------------------------------------------
0721                       ; Crunch current line if dirty
0722                       ;-------------------------------------------------------
0723 744E 8820  54         c     @fb.row.dirty,@w$ffff
     7450 220A 
     7452 6048 
0724 7454 1604  14         jne   ed_pk.action.ins_line.insert
0725 7456 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     7458 787C 
0726 745A 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     745C 220A 
0727                       ;-------------------------------------------------------
0728                       ; Insert entry in index
0729                       ;-------------------------------------------------------
0730               ed_pk.action.ins_line.insert:
0731 745E 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7460 76FC 
0732 7462 C820  54         mov   @fb.topline,@parm1
     7464 2204 
     7466 8350 
0733 7468 A820  54         a     @fb.row,@parm1        ; Line number to insert
     746A 2206 
     746C 8350 
0734               
0735 746E C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     7470 2304 
     7472 8352 
0736 7474 06A0  32         bl    @idx.entry.insert     ; Reorganize index
     7476 77F4 
0737 7478 05A0  34         inc   @edb.lines            ; One line more in editor buffer
     747A 2304 
0738                       ;-------------------------------------------------------
0739                       ; Refresh frame buffer and physical screen
0740                       ;-------------------------------------------------------
0741 747C C820  54         mov   @fb.topline,@parm1
     747E 2204 
     7480 8350 
0742 7482 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     7484 7718 
0743 7486 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     7488 2216 
0744                       ;-------------------------------------------------------
0745                       ; Exit
0746                       ;-------------------------------------------------------
0747               ed_pk.action.ins_line.$$:
0748 748A 0460  28         b     @ed_wait              ; Back to editor main
     748C 7084 
0749               
0750               
0751               
0752               
0753               
0754               
0755               *---------------------------------------------------------------
0756               * Enter
0757               *---------------------------------------------------------------
0758               ed_pk.action.enter:
0759                       ;-------------------------------------------------------
0760                       ; Crunch current line if dirty
0761                       ;-------------------------------------------------------
0762 748E 8820  54         c     @fb.row.dirty,@w$ffff
     7490 220A 
     7492 6048 
0763 7494 1604  14         jne   ed_pk.action.enter.upd_counter
0764 7496 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     7498 787C 
0765 749A 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     749C 220A 
0766                       ;-------------------------------------------------------
0767                       ; Update line counter
0768                       ;-------------------------------------------------------
0769               ed_pk.action.enter.upd_counter:
0770 749E C120  34         mov   @fb.topline,tmp0
     74A0 2204 
0771 74A2 A120  34         a     @fb.row,tmp0
     74A4 2206 
0772 74A6 8804  38         c     tmp0,@edb.lines       ; Last line in editor buffer?
     74A8 2304 
0773 74AA 1602  14         jne   ed_pk.action.newline  ; No, continue newline
0774 74AC 05A0  34         inc   @edb.lines            ; Total lines++
     74AE 2304 
0775                       ;-------------------------------------------------------
0776                       ; Process newline
0777                       ;-------------------------------------------------------
0778               ed_pk.action.newline:
0779                       ;-------------------------------------------------------
0780                       ; Scroll 1 line if cursor at bottom row of screen
0781                       ;-------------------------------------------------------
0782 74B0 C120  34         mov   @fb.screenrows,tmp0
     74B2 2218 
0783 74B4 0604  14         dec   tmp0
0784 74B6 8120  34         c     @fb.row,tmp0
     74B8 2206 
0785 74BA 110A  14         jlt   ed_pk.action.newline.down
0786                       ;-------------------------------------------------------
0787                       ; Scroll
0788                       ;-------------------------------------------------------
0789 74BC C120  34         mov   @fb.screenrows,tmp0
     74BE 2218 
0790 74C0 C820  54         mov   @fb.topline,@parm1
     74C2 2204 
     74C4 8350 
0791 74C6 05A0  34         inc   @parm1
     74C8 8350 
0792 74CA 06A0  32         bl    @fb.refresh
     74CC 7718 
0793 74CE 1004  14         jmp   ed_pk.action.newline.rest
0794                       ;-------------------------------------------------------
0795                       ; Move cursor down a row, there are still rows left
0796                       ;-------------------------------------------------------
0797               ed_pk.action.newline.down:
0798 74D0 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     74D2 2206 
0799 74D4 06A0  32         bl    @down                 ; Row++ VDP cursor
     74D6 637A 
0800                       ;-------------------------------------------------------
0801                       ; Set VDP cursor and save variables
0802                       ;-------------------------------------------------------
0803               ed_pk.action.newline.rest:
0804 74D8 06A0  32         bl    @fb.get.firstnonblank
     74DA 7742 
0805 74DC C120  34         mov   @outparm1,tmp0
     74DE 8360 
0806 74E0 C804  38         mov   tmp0,@fb.column
     74E2 220C 
0807 74E4 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
     74E6 638C 
0808 74E8 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
     74EA 7998 
0809 74EC 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     74EE 76FC 
0810 74F0 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     74F2 2216 
0811                       ;-------------------------------------------------------
0812                       ; Exit
0813                       ;-------------------------------------------------------
0814               ed_pk.action.newline.$$:
0815 74F4 0460  28         b     @ed_wait              ; Back to editor main
     74F6 7084 
0816               
0817               
0818               
0819               
0820               *---------------------------------------------------------------
0821               * Toggle insert/overwrite mode
0822               *---------------------------------------------------------------
0823               ed_pk.action.ins_onoff:
0824 74F8 0560  34         inv   @edb.insmode          ; Toggle insert/overwrite mode
     74FA 230A 
0825                       ;-------------------------------------------------------
0826                       ; Delay
0827                       ;-------------------------------------------------------
0828 74FC 0204  20         li    tmp0,2000
     74FE 07D0 
0829               ed_pk.action.ins_onoff.loop:
0830 7500 0604  14         dec   tmp0
0831 7502 16FE  14         jne   ed_pk.action.ins_onoff.loop
0832                       ;-------------------------------------------------------
0833                       ; Exit
0834                       ;-------------------------------------------------------
0835               ed_pk.action.ins_onoff.$$:
0836 7504 0460  28         b     @task2.cur_visible    ; Update cursor shape
     7506 75E2 
0837               
0838               
0839               
0840               
0841               
0842               
0843               *---------------------------------------------------------------
0844               * Process character
0845               *---------------------------------------------------------------
0846               ed_pk.action.char:
0847 7508 D805  38         movb  tmp1,@parm1           ; Store character for insert
     750A 8350 
0848 750C C120  34         mov   @edb.insmode,tmp0     ; Insert or overwrite ?
     750E 230A 
0849 7510 1302  14         jeq   ed_pk.action.char.overwrite
0850                       ;-------------------------------------------------------
0851                       ; Insert mode
0852                       ;-------------------------------------------------------
0853               ed_pk.action.char.insert:
0854 7512 0460  28         b     @ed_pk.action.ins_char
     7514 7404 
0855                       ;-------------------------------------------------------
0856                       ; Overwrite mode
0857                       ;-------------------------------------------------------
0858               ed_pk.action.char.overwrite:
0859 7516 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7518 76FC 
0860 751A C120  34         mov   @fb.current,tmp0      ; Get pointer
     751C 2202 
0861               
0862 751E D520  46         movb  @parm1,*tmp0          ; Store character in editor buffer
     7520 8350 
0863 7522 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     7524 220A 
0864 7526 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     7528 2216 
0865               
0866 752A 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     752C 220C 
0867 752E 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     7530 832A 
0868                       ;-------------------------------------------------------
0869                       ; Update line length in frame buffer
0870                       ;-------------------------------------------------------
0871 7532 8820  54         c     @fb.column,@fb.row.length
     7534 220C 
     7536 2208 
0872 7538 1103  14         jlt   ed_pk.action.char.$$  ; column < length line ? Skip further processing
0873 753A C820  54         mov   @fb.column,@fb.row.length
     753C 220C 
     753E 2208 
0874                       ;-------------------------------------------------------
0875                       ; Exit
0876                       ;-------------------------------------------------------
0877               ed_pk.action.char.$$:
0878 7540 0460  28         b     @ed_wait              ; Back to editor main
     7542 7084 
0879               
**** **** ****     > tivi.asm.19002
0318               
0319               
0320               
0321               
0322               ***************************************************************
0323               * Task 0 - Copy frame buffer to VDP
0324               ***************************************************************
0325 7544 C120  34 task0   mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
     7546 2216 
0326 7548 133D  14         jeq   task0.$$              ; No, skip update
0327                       ;------------------------------------------------------
0328                       ; Determine how many rows to copy
0329                       ;------------------------------------------------------
0330 754A 8820  54         c     @edb.lines,@fb.screenrows
     754C 2304 
     754E 2218 
0331 7550 1103  14         jlt   task0.setrows.small
0332 7552 C160  34         mov   @fb.screenrows,tmp1   ; Lines to copy
     7554 2218 
0333 7556 1003  14         jmp   task0.copy.framebuffer
0334                       ;------------------------------------------------------
0335                       ; Less lines in editor buffer as rows in frame buffer
0336                       ;------------------------------------------------------
0337               task0.setrows.small:
0338 7558 C160  34         mov   @edb.lines,tmp1       ; Lines to copy
     755A 2304 
0339 755C 0585  14         inc   tmp1
0340                       ;------------------------------------------------------
0341                       ; Determine area to copy
0342                       ;------------------------------------------------------
0343               task0.copy.framebuffer:
0344 755E 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     7560 220E 
0345                                                   ; 16 bit part is in tmp2!
0346 7562 04C4  14         clr   tmp0                  ; VDP target address
0347 7564 C160  34         mov   @fb.top.ptr,tmp1      ; RAM Source address
     7566 2200 
0348                       ;------------------------------------------------------
0349                       ; Copy memory block
0350                       ;------------------------------------------------------
0351 7568 06A0  32         bl    @xpym2v               ; Copy to VDP
     756A 62A0 
0352                                                   ; tmp0 = VDP target address
0353                                                   ; tmp1 = RAM source address
0354                                                   ; tmp2 = Bytes to copy
0355 756C 04E0  34         clr   @fb.dirty             ; Reset frame buffer dirty flag
     756E 2216 
0356                       ;-------------------------------------------------------
0357                       ; Draw EOF marker at end-of-file
0358                       ;-------------------------------------------------------
0359 7570 C120  34         mov   @edb.lines,tmp0
     7572 2304 
0360 7574 6120  34         s     @fb.topline,tmp0      ; Y = @edb.lines - @fb.topline
     7576 2204 
0361 7578 0584  14         inc   tmp0                  ; Y++
0362 757A 8120  34         c     @fb.screenrows,tmp0   ; Hide if last line on screen
     757C 2218 
0363 757E 1222  14         jle   task0.$$
0364                       ;-------------------------------------------------------
0365                       ; Draw EOF marker
0366                       ;-------------------------------------------------------
0367               task0.draw_marker:
0368 7580 C820  54         mov   @wyx,@fb.yxsave       ; Backup VDP cursor position
     7582 832A 
     7584 2214 
0369 7586 0A84  56         sla   tmp0,8                ; X=0
0370 7588 C804  38         mov   tmp0,@wyx             ; Set VDP cursor
     758A 832A 
0371 758C 06A0  32         bl    @putstr
     758E 6280 
0372 7590 7A9C                   data txt_marker       ; Display *EOF*
0373                       ;-------------------------------------------------------
0374                       ; Draw empty line after (and below) EOF marker
0375                       ;-------------------------------------------------------
0376 7592 06A0  32         bl    @setx
     7594 638A 
0377 7596 0005                   data  5               ; Cursor after *EOF* string
0378               
0379 7598 C120  34         mov   @wyx,tmp0
     759A 832A 
0380 759C 0984  56         srl   tmp0,8                ; Right justify
0381 759E 0584  14         inc   tmp0                  ; One time adjust
0382 75A0 8120  34         c     @fb.screenrows,tmp0   ; Don't spill on last line on screen
     75A2 2218 
0383 75A4 1303  14         jeq   !
0384 75A6 0206  20         li    tmp2,colrow+colrow-5  ; Repeat count for 2 lines
     75A8 009B 
0385 75AA 1002  14         jmp   task0.draw_marker.line
0386 75AC 0206  20 !       li    tmp2,colrow-5         ; Repeat count for 1 line
     75AE 004B 
0387                       ;-------------------------------------------------------
0388                       ; Draw empty line
0389                       ;-------------------------------------------------------
0390               task0.draw_marker.line:
0391 75B0 0604  14         dec   tmp0                  ; One time adjust
0392 75B2 06A0  32         bl    @yx2pnt               ; Set VDP address in tmp0
     75B4 625C 
0393 75B6 0205  20         li    tmp1,32               ; Character to write (whitespace)
     75B8 0020 
0394 75BA 06A0  32         bl    @xfilv                ; Write characters
     75BC 60F6 
0395 75BE C820  54         mov   @fb.yxsave,@wyx       ; Restore VDP cursor postion
     75C0 2214 
     75C2 832A 
0396               *--------------------------------------------------------------
0397               * Task 0 - Exit
0398               *--------------------------------------------------------------
0399               task0.$$:
0400 75C4 0460  28         b     @slotok
     75C6 6EA0 
0401               
0402               
0403               
0404               ***************************************************************
0405               * Task 1 - Copy SAT to VDP
0406               ***************************************************************
0407 75C8 E0A0  34 task1   soc   @wbit0,config          ; Sprite adjustment on
     75CA 6046 
0408 75CC 06A0  32         bl    @yx2px                 ; Calculate pixel position, result in tmp0
     75CE 6396 
0409 75D0 C804  38         mov   tmp0,@ramsat           ; Set cursor YX
     75D2 8380 
0410 75D4 1012  14         jmp   task.sub_copy_ramsat   ; Update VDP SAT and exit task
0411               
0412               
0413               ***************************************************************
0414               * Task 2 - Update cursor shape (blink)
0415               ***************************************************************
0416 75D6 0560  34 task2   inv   @fb.curtoggle          ; Flip cursor shape flag
     75D8 2212 
0417 75DA 1303  14         jeq   task2.cur_visible
0418 75DC 04E0  34         clr   @ramsat+2              ; Hide cursor
     75DE 8382 
0419 75E0 100C  14         jmp   task.sub_copy_ramsat   ; Update VDP SAT and exit task
0420               
0421               task2.cur_visible:
0422 75E2 C120  34         mov   @edb.insmode,tmp0      ; Get Editor buffer insert mode
     75E4 230A 
0423 75E6 1303  14         jeq   task2.cur_visible.overwrite_mode
0424                       ;------------------------------------------------------
0425                       ; Cursor in insert mode
0426                       ;------------------------------------------------------
0427               task2.cur_visible.insert_mode:
0428 75E8 0204  20         li    tmp0,>000f
     75EA 000F 
0429 75EC 1002  14         jmp   task2.cur_visible.cursorshape
0430                       ;------------------------------------------------------
0431                       ; Cursor in overwrite mode
0432                       ;------------------------------------------------------
0433               task2.cur_visible.overwrite_mode:
0434 75EE 0204  20         li    tmp0,>020f
     75F0 020F 
0435                       ;------------------------------------------------------
0436                       ; Set cursor shape
0437                       ;------------------------------------------------------
0438               task2.cur_visible.cursorshape:
0439 75F2 C804  38         mov   tmp0,@fb.curshape
     75F4 2210 
0440 75F6 C804  38         mov   tmp0,@ramsat+2
     75F8 8382 
0441               
0442               
0443               
0444               
0445               
0446               
0447               
0448               *--------------------------------------------------------------
0449               * Copy ramsat to VDP SAT and show bottom line - Tasks 1,2
0450               *--------------------------------------------------------------
0451               task.sub_copy_ramsat
0452 75FA 06A0  32         bl    @cpym2v
     75FC 629A 
0453 75FE 2000                   data sprsat,ramsat,4   ; Update sprite
     7600 8380 
     7602 0004 
0454               
0455 7604 C820  54         mov   @wyx,@fb.yxsave
     7606 832A 
     7608 2214 
0456                       ;------------------------------------------------------
0457                       ; Show text editing mode
0458                       ;------------------------------------------------------
0459               task.botline.show_mode
0460 760A C120  34         mov   @edb.insmode,tmp0
     760C 230A 
0461 760E 1605  14         jne   task.botline.show_mode.insert
0462                       ;------------------------------------------------------
0463                       ; Overwrite mode
0464                       ;------------------------------------------------------
0465               task.botline.show_mode.overwrite:
0466 7610 06A0  32         bl    @putat
     7612 6292 
0467 7614 1D32                   byte  29,50
0468 7616 7AA8                   data  txt_ovrwrite
0469 7618 1004  14         jmp   task.botline.show_linecol
0470                       ;------------------------------------------------------
0471                       ; Insert  mode
0472                       ;------------------------------------------------------
0473               task.botline.show_mode.insert
0474 761A 06A0  32         bl    @putat
     761C 6292 
0475 761E 1D32                   byte  29,50
0476 7620 7AAC                   data  txt_insert
0477                       ;------------------------------------------------------
0478                       ; Show "line,column"
0479                       ;------------------------------------------------------
0480               task.botline.show_linecol:
0481 7622 C820  54         mov   @fb.row,@parm1
     7624 2206 
     7626 8350 
0482 7628 06A0  32         bl    @fb.row2line
     762A 76E8 
0483 762C 05A0  34         inc   @outparm1
     762E 8360 
0484                       ;------------------------------------------------------
0485                       ; Show line
0486                       ;------------------------------------------------------
0487 7630 06A0  32         bl    @putnum
     7632 663E 
0488 7634 1D40                   byte  29,64            ; YX
0489 7636 8360                   data  outparm1,rambuf
     7638 8390 
0490 763A 3020                   byte  48               ; ASCII offset
0491                             byte  32               ; Padding character
0492                       ;------------------------------------------------------
0493                       ; Show comma
0494                       ;------------------------------------------------------
0495 763C 06A0  32         bl    @putat
     763E 6292 
0496 7640 1D45                   byte  29,69
0497 7642 7A9A                   data  txt_delim
0498                       ;------------------------------------------------------
0499                       ; Show column
0500                       ;------------------------------------------------------
0501 7644 06A0  32         bl    @film
     7646 60CC 
0502 7648 8396                   data rambuf+6,32,12    ; Clear work buffer with space character
     764A 0020 
     764C 000C 
0503               
0504 764E C820  54         mov   @fb.column,@waux1
     7650 220C 
     7652 833C 
0505 7654 05A0  34         inc   @waux1                 ; Offset 1
     7656 833C 
0506               
0507 7658 06A0  32         bl    @mknum                 ; Convert unsigned number to string
     765A 65C0 
0508 765C 833C                   data  waux1,rambuf
     765E 8390 
0509 7660 3020                   byte  48               ; ASCII offset
0510                             byte  32               ; Fill character
0511               
0512 7662 06A0  32         bl    @trimnum               ; Trim number to the left
     7664 6618 
0513 7666 8390                   data  rambuf,rambuf+6,32
     7668 8396 
     766A 0020 
0514               
0515 766C 0204  20         li    tmp0,>0200
     766E 0200 
0516 7670 D804  38         movb  tmp0,@rambuf+6         ; "Fix" number length to clear junk chars
     7672 8396 
0517               
0518 7674 06A0  32         bl    @putat
     7676 6292 
0519 7678 1D46                   byte 29,70
0520 767A 8396                   data rambuf+6          ; Show column
0521                       ;------------------------------------------------------
0522                       ; Show lines in buffer unless on last line in file
0523                       ;------------------------------------------------------
0524 767C C820  54         mov   @fb.row,@parm1
     767E 2206 
     7680 8350 
0525 7682 06A0  32         bl    @fb.row2line
     7684 76E8 
0526 7686 8820  54         c     @edb.lines,@outparm1
     7688 2304 
     768A 8360 
0527 768C 1605  14         jne   task.botline.show_lines_in_buffer
0528               
0529 768E 06A0  32         bl    @putat
     7690 6292 
0530 7692 1D49                   byte 29,73
0531 7694 7AA2                   data txt_bottom
0532               
0533 7696 100B  14         jmp   task.botline.$$
0534                       ;------------------------------------------------------
0535                       ; Show lines in buffer
0536                       ;------------------------------------------------------
0537               task.botline.show_lines_in_buffer:
0538 7698 C820  54         mov   @edb.lines,@waux1
     769A 2304 
     769C 833C 
0539 769E 05A0  34         inc   @waux1                 ; Offset 1
     76A0 833C 
0540 76A2 06A0  32         bl    @putnum
     76A4 663E 
0541 76A6 1D49                   byte 29,73             ; YX
0542 76A8 833C                   data waux1,rambuf
     76AA 8390 
0543 76AC 3020                   byte 48
0544                             byte 32
0545                       ;------------------------------------------------------
0546                       ; Exit
0547                       ;------------------------------------------------------
0548               task.botline.$$
0549 76AE C820  54         mov   @fb.yxsave,@wyx
     76B0 2214 
     76B2 832A 
0550 76B4 0460  28         b     @slotok                ; Exit running task
     76B6 6EA0 
0551               
0552               
0553               
0554               ***************************************************************
0555               *                  fb - Framebuffer module
0556               ***************************************************************
0557                       copy  "framebuffer.asm"
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
0024 76B8 0649  14         dect  stack
0025 76BA C64B  30         mov   r11,*stack            ; Save return address
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 76BC 0204  20         li    tmp0,fb.top
     76BE 2650 
0030 76C0 C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     76C2 2200 
0031 76C4 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     76C6 2204 
0032 76C8 04E0  34         clr   @fb.row               ; Current row=0
     76CA 2206 
0033 76CC 04E0  34         clr   @fb.column            ; Current column=0
     76CE 220C 
0034 76D0 0204  20         li    tmp0,80
     76D2 0050 
0035 76D4 C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     76D6 220E 
0036 76D8 0204  20         li    tmp0,29
     76DA 001D 
0037 76DC C804  38         mov   tmp0,@fb.screenrows   ; Physical rows on screen = 29
     76DE 2218 
0038 76E0 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     76E2 2216 
0039                       ;------------------------------------------------------
0040                       ; Exit
0041                       ;------------------------------------------------------
0042               fb.init.$$
0043 76E4 0460  28         b     @poprt                ; Return to caller
     76E6 60C8 
0044               
0045               
0046               
0047               
0048               ***************************************************************
0049               * fb.row2line
0050               * Calculate line in editor buffer
0051               ***************************************************************
0052               * bl @fb.row2line
0053               *--------------------------------------------------------------
0054               * INPUT
0055               * @fb.topline = Top line in frame buffer
0056               * @parm1      = Row in frame buffer (offset 0..@fb.screenrows)
0057               *--------------------------------------------------------------
0058               * OUTPUT
0059               * @outparm1 = Matching line in editor buffer
0060               *--------------------------------------------------------------
0061               * Register usage
0062               * tmp2,tmp3
0063               *--------------------------------------------------------------
0064               * Formula
0065               * outparm1 = @fb.topline + @parm1
0066               ********@*****@*********************@**************************
0067               fb.row2line:
0068 76E8 0649  14         dect  stack
0069 76EA C64B  30         mov   r11,*stack            ; Save return address
0070                       ;------------------------------------------------------
0071                       ; Calculate line in editor buffer
0072                       ;------------------------------------------------------
0073 76EC C120  34         mov   @parm1,tmp0
     76EE 8350 
0074 76F0 A120  34         a     @fb.topline,tmp0
     76F2 2204 
0075 76F4 C804  38         mov   tmp0,@outparm1
     76F6 8360 
0076                       ;------------------------------------------------------
0077                       ; Exit
0078                       ;------------------------------------------------------
0079               fb.row2line$$:
0080 76F8 0460  28         b    @poprt                 ; Return to caller
     76FA 60C8 
0081               
0082               
0083               
0084               
0085               ***************************************************************
0086               * fb.calc_pointer
0087               * Calculate pointer address in frame buffer
0088               ***************************************************************
0089               * bl @fb.calc_pointer
0090               *--------------------------------------------------------------
0091               * INPUT
0092               * @fb.top       = Address of top row in frame buffer
0093               * @fb.topline   = Top line in frame buffer
0094               * @fb.row       = Current row in frame buffer (offset 0..@fb.screenrows)
0095               * @fb.column    = Current column in frame buffer
0096               * @fb.colsline  = Columns per line in frame buffer
0097               *--------------------------------------------------------------
0098               * OUTPUT
0099               * @fb.current   = Updated pointer
0100               *--------------------------------------------------------------
0101               * Register usage
0102               * tmp2,tmp3
0103               *--------------------------------------------------------------
0104               * Formula
0105               * pointer = row * colsline + column + deref(@fb.top.ptr)
0106               ********@*****@*********************@**************************
0107               fb.calc_pointer:
0108 76FC 0649  14         dect  stack
0109 76FE C64B  30         mov   r11,*stack            ; Save return address
0110                       ;------------------------------------------------------
0111                       ; Calculate pointer
0112                       ;------------------------------------------------------
0113 7700 C1A0  34         mov   @fb.row,tmp2
     7702 2206 
0114 7704 39A0  72         mpy   @fb.colsline,tmp2     ; tmp3 = row  * colsline
     7706 220E 
0115 7708 A1E0  34         a     @fb.column,tmp3       ; tmp3 = tmp3 + column
     770A 220C 
0116 770C A1E0  34         a     @fb.top.ptr,tmp3      ; tmp3 = tmp3 + base
     770E 2200 
0117 7710 C807  38         mov   tmp3,@fb.current
     7712 2202 
0118                       ;------------------------------------------------------
0119                       ; Exit
0120                       ;------------------------------------------------------
0121               fb.calc_pointer.$$
0122 7714 0460  28         b    @poprt                 ; Return to caller
     7716 60C8 
0123               
0124               
0125               
0126               
0127               ***************************************************************
0128               * fb.refresh
0129               * Refresh frame buffer with editor buffer content
0130               ***************************************************************
0131               * bl @fb.refresh
0132               *--------------------------------------------------------------
0133               * INPUT
0134               * @parm1 = Line to start with (becomes @fb.topline)
0135               *--------------------------------------------------------------
0136               * OUTPUT
0137               * none
0138               ********@*****@*********************@**************************
0139               fb.refresh:
0140 7718 0649  14         dect  stack
0141 771A C64B  30         mov   r11,*stack            ; Save return address
0142                       ;------------------------------------------------------
0143                       ; Setup starting position in index
0144                       ;------------------------------------------------------
0145 771C C820  54         mov   @parm1,@fb.topline
     771E 8350 
     7720 2204 
0146 7722 04E0  34         clr   @parm2                ; Target row in frame buffer
     7724 8352 
0147                       ;------------------------------------------------------
0148                       ; Unpack line to frame buffer
0149                       ;------------------------------------------------------
0150               fb.refresh.unpack_line:
0151 7726 06A0  32         bl    @edb.line.unpack
     7728 790A 
0152 772A 05A0  34         inc   @parm1                ; Next line in editor buffer
     772C 8350 
0153 772E 05A0  34         inc   @parm2                ; Next row in frame buffer
     7730 8352 
0154 7732 8820  54         c     @parm2,@fb.screenrows ; Last row reached ?
     7734 8352 
     7736 2218 
0155 7738 11F6  14         jlt   fb.refresh.unpack_line
0156 773A 0720  34         seto  @fb.dirty             ; Refresh screen
     773C 2216 
0157                       ;------------------------------------------------------
0158                       ; Exit
0159                       ;------------------------------------------------------
0160               fb.refresh.$$
0161 773E 0460  28         b    @poprt                 ; Return to caller
     7740 60C8 
0162               
0163               
0164               
0165               
0166               ***************************************************************
0167               * fb.get.firstnonblank
0168               * Get column of first non-blank character in specified line
0169               ***************************************************************
0170               * bl @fb.get.firstnonblank
0171               *--------------------------------------------------------------
0172               * OUTPUT
0173               * @outparm1 = Column containing first non-blank character
0174               * @outparm2 = Character
0175               ********@*****@*********************@**************************
0176               fb.get.firstnonblank
0177 7742 0649  14         dect  stack
0178 7744 C64B  30         mov   r11,*stack            ; Save return address
0179                       ;------------------------------------------------------
0180                       ; Prepare for scanning
0181                       ;------------------------------------------------------
0182 7746 04E0  34         clr   @fb.column
     7748 220C 
0183 774A 06A0  32         bl    @fb.calc_pointer
     774C 76FC 
0184 774E 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     7750 7998 
0185 7752 C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
     7754 2208 
0186 7756 1313  14         jeq   fb.get.firstnonblank.nomatch
0187                                                   ; Exit if empty line
0188 7758 C120  34         mov   @fb.current,tmp0      ; Pointer to current char
     775A 2202 
0189 775C 04C5  14         clr   tmp1
0190                       ;------------------------------------------------------
0191                       ; Scan line for non-blank character
0192                       ;------------------------------------------------------
0193               fb.get.firstnonblank.loop:
0194 775E D174  28         movb  *tmp0+,tmp1           ; Get character
0195 7760 130E  14         jeq   fb.get.firstnonblank.nomatch
0196                                                   ; Exit if empty line
0197 7762 0285  22         ci    tmp1,>2000            ; Whitespace?
     7764 2000 
0198 7766 1503  14         jgt   fb.get.firstnonblank.match
0199 7768 0606  14         dec   tmp2                  ; Counter--
0200 776A 16F9  14         jne   fb.get.firstnonblank.loop
0201 776C 1008  14         jmp   fb.get.firstnonblank.nomatch
0202                       ;------------------------------------------------------
0203                       ; Non-blank character found
0204                       ;------------------------------------------------------
0205               fb.get.firstnonblank.match
0206 776E 6120  34         s     @fb.current,tmp0      ; Calculate column
     7770 2202 
0207 7772 0604  14         dec   tmp0
0208 7774 C804  38         mov   tmp0,@outparm1        ; Save column
     7776 8360 
0209 7778 D805  38         movb  tmp1,@outparm2        ; Save character
     777A 8362 
0210 777C 1004  14         jmp   fb.get.firstnonblank.$$
0211                       ;------------------------------------------------------
0212                       ; No non-blank character found
0213                       ;------------------------------------------------------
0214               fb.get.firstnonblank.nomatch
0215 777E 04E0  34         clr   @outparm1             ; X=0
     7780 8360 
0216 7782 04E0  34         clr   @outparm2             ; Null
     7784 8362 
0217                       ;------------------------------------------------------
0218                       ; Exit
0219                       ;------------------------------------------------------
0220               fb.get.firstnonblank.$$
0221 7786 0460  28         b    @poprt                 ; Return to caller
     7788 60C8 
0222               
0223               
0224               
0225               
0226               
0227               
**** **** ****     > tivi.asm.19002
0558               
0559               
0560               ***************************************************************
0561               *              idx - Index management module
0562               ***************************************************************
0563                       copy  "index.asm"
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
0030 778A 0649  14         dect  stack
0031 778C C64B  30         mov   r11,*stack            ; Save return address
0032                       ;------------------------------------------------------
0033                       ; Initialize
0034                       ;------------------------------------------------------
0035 778E 0204  20         li    tmp0,idx.top
     7790 3000 
0036 7792 C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     7794 2302 
0037                       ;------------------------------------------------------
0038                       ; Create index slot 0
0039                       ;------------------------------------------------------
0040 7796 04F4  30         clr   *tmp0+                ; Set empty pointer
0041 7798 04F4  30         clr   *tmp0+                ; Set packed/unpacked length to 0
0042                       ;------------------------------------------------------
0043                       ; Exit
0044                       ;------------------------------------------------------
0045               idx.init.$$:
0046 779A 0460  28         b     @poprt                ; Return to caller
     779C 60C8 
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
0059               * @parm3    = Length of line
0060               *--------------------------------------------------------------
0061               * OUTPUT
0062               * @outparm1 = Pointer to updated index entry
0063               *--------------------------------------------------------------
0064               * Register usage
0065               * tmp0,tmp1,tmp2
0066               *--------------------------------------------------------------
0067               idx.entry.update:
0068 779E C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     77A0 8350 
0069                       ;------------------------------------------------------
0070                       ; Calculate address of index entry and update
0071                       ;------------------------------------------------------
0072 77A2 0A24  56         sla   tmp0,2                ; line number * 4
0073 77A4 C920  54         mov   @parm2,@idx.top(tmp0) ; Update index slot -> Pointer
     77A6 8352 
     77A8 3000 
0074                       ;------------------------------------------------------
0075                       ; Set packed / unpacked length of string and update
0076                       ;------------------------------------------------------
0077 77AA C160  34         mov   @parm3,tmp1           ; Set unpacked length
     77AC 8354 
0078 77AE C185  18         mov   tmp1,tmp2
0079 77B0 06C6  14         swpb  tmp2
0080 77B2 D146  18         movb  tmp2,tmp1             ; Set packed length (identical for now!)
0081 77B4 C905  38         mov   tmp1,@idx.top+2(tmp0) ; Update index slot -> Lengths
     77B6 3002 
0082                       ;------------------------------------------------------
0083                       ; Set EOL marker if necessary
0084                       ;------------------------------------------------------
0085               *       c     @parm1,@edb.lines     ; line > total lines in editor buffer ?
0086               *       jlt   idx.entry.update.$$   ; No, exit
0087               *       seto  @idx.top+4(tmp0)      ; Set EOL marker
0088                       ;------------------------------------------------------
0089                       ; Exit
0090                       ;------------------------------------------------------
0091               idx.entry.update.$$:
0092 77B8 C804  38         mov   tmp0,@outparm1        ; Pointer to update index entry
     77BA 8360 
0093 77BC 045B  20         b     *r11                  ; Return
0094               
0095               
0096               ***************************************************************
0097               * idx.entry.delete
0098               * Delete index entry - Closing gap created by delete
0099               ***************************************************************
0100               * bl @idx.entry.delete
0101               *--------------------------------------------------------------
0102               * INPUT
0103               * @parm1    = Line number in editor buffer to delete
0104               * @parm2    = Line number of last line to check for reorg
0105               *--------------------------------------------------------------
0106               * OUTPUT
0107               * @outparm1 = Pointer to deleted line (for undo)
0108               *--------------------------------------------------------------
0109               * Register usage
0110               * tmp0,tmp2
0111               *--------------------------------------------------------------
0112               idx.entry.delete:
0113 77BE C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     77C0 8350 
0114                       ;------------------------------------------------------
0115                       ; Calculate address of index entry and save pointer
0116                       ;------------------------------------------------------
0117 77C2 0A24  56         sla   tmp0,2                ; line number * 4
0118 77C4 C824  54         mov   @idx.top(tmp0),@outparm1
     77C6 3000 
     77C8 8360 
0119                                                   ; Pointer to deleted line
0120                       ;------------------------------------------------------
0121                       ; Prepare for index reorg
0122                       ;------------------------------------------------------
0123 77CA C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     77CC 8352 
0124 77CE 61A0  34         s     @parm1,tmp2           ; Calculate loop
     77D0 8350 
0125 77D2 1605  14         jne   idx.entry.delete.reorg
0126                       ;------------------------------------------------------
0127                       ; Special treatment if last line
0128                       ;------------------------------------------------------
0129 77D4 0724  34         seto  @idx.top+0(tmp0)
     77D6 3000 
0130 77D8 04E4  34         clr   @idx.top+2(tmp0)
     77DA 3002 
0131 77DC 100A  14         jmp   idx.entry.delete.$$
0132                       ;------------------------------------------------------
0133                       ; Reorganize index entries
0134                       ;------------------------------------------------------
0135               idx.entry.delete.reorg:
0136 77DE C924  54         mov   @idx.top+4(tmp0),@idx.top+0(tmp0)
     77E0 3004 
     77E2 3000 
0137 77E4 C924  54         mov   @idx.top+6(tmp0),@idx.top+2(tmp0)
     77E6 3006 
     77E8 3002 
0138 77EA 0224  22         ai    tmp0,4                ; Next index entry
     77EC 0004 
0139               
0140 77EE 0606  14         dec   tmp2                  ; tmp2--
0141 77F0 16F6  14         jne   idx.entry.delete.reorg
0142                                                   ; Loop unless completed
0143                       ;------------------------------------------------------
0144                       ; Exit
0145                       ;------------------------------------------------------
0146               idx.entry.delete.$$:
0147 77F2 045B  20         b     *r11                  ; Return
0148               
0149               
0150               ***************************************************************
0151               * idx.entry.insert
0152               * Insert index entry
0153               ***************************************************************
0154               * bl @idx.entry.insert
0155               *--------------------------------------------------------------
0156               * INPUT
0157               * @parm1    = Line number in editor buffer to insert
0158               * @parm2    = Line number of last line to check for reorg
0159               *--------------------------------------------------------------
0160               * OUTPUT
0161               * NONE
0162               *--------------------------------------------------------------
0163               * Register usage
0164               * tmp0,tmp2
0165               *--------------------------------------------------------------
0166               idx.entry.insert:
0167 77F4 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     77F6 8352 
0168                       ;------------------------------------------------------
0169                       ; Calculate address of index entry and save pointer
0170                       ;------------------------------------------------------
0171 77F8 0A24  56         sla   tmp0,2                ; line number * 4
0172                       ;------------------------------------------------------
0173                       ; Prepare for index reorg
0174                       ;------------------------------------------------------
0175 77FA C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     77FC 8352 
0176 77FE 61A0  34         s     @parm1,tmp2           ; Calculate loop
     7800 8350 
0177 7802 160B  14         jne   idx.entry.insert.reorg
0178                       ;------------------------------------------------------
0179                       ; Special treatment if last line
0180                       ;------------------------------------------------------
0181 7804 C924  54         mov   @idx.top+0(tmp0),@idx.top+4(tmp0)
     7806 3000 
     7808 3004 
0182 780A C924  54         mov   @idx.top+2(tmp0),@idx.top+6(tmp0)
     780C 3002 
     780E 3006 
0183 7810 04E4  34         clr   @idx.top+0(tmp0)      ; Clear new index entry word 1
     7812 3000 
0184 7814 04E4  34         clr   @idx.top+2(tmp0)      ; Clear new index entry word 2
     7816 3002 
0185 7818 100F  14         jmp   idx.entry.insert.$$
0186                       ;------------------------------------------------------
0187                       ; Reorganize index entries
0188                       ;------------------------------------------------------
0189               idx.entry.insert.reorg:
0190 781A 05C6  14         inct  tmp2                  ; Adjust one time
0191 781C C924  54 !       mov   @idx.top+0(tmp0),@idx.top+4(tmp0)
     781E 3000 
     7820 3004 
0192 7822 C924  54         mov   @idx.top+2(tmp0),@idx.top+6(tmp0)
     7824 3002 
     7826 3006 
0193 7828 0224  22         ai    tmp0,-4               ; Previous index entry
     782A FFFC 
0194               
0195 782C 0606  14         dec   tmp2                  ; tmp2--
0196 782E 16F6  14         jne   -!                    ; Loop unless completed
0197 7830 04E4  34         clr   @idx.top+8(tmp0)      ; Clear new index entry word 1
     7832 3008 
0198 7834 04E4  34         clr   @idx.top+10(tmp0)     ; Clear new index entry word 2
     7836 300A 
0199                       ;------------------------------------------------------
0200                       ; Exit
0201                       ;------------------------------------------------------
0202               idx.entry.insert.$$:
0203 7838 045B  20         b     *r11                  ; Return
0204               
0205               
0206               
0207               ***************************************************************
0208               * idx.pointer.get
0209               * Get pointer to editor buffer line content
0210               ***************************************************************
0211               * bl @idx.pointer.get
0212               *--------------------------------------------------------------
0213               * INPUT
0214               * @parm1 = Line number in editor buffer
0215               *--------------------------------------------------------------
0216               * OUTPUT
0217               * @outparm1 = Pointer to editor buffer line content
0218               * @outparm2 = Line length
0219               *--------------------------------------------------------------
0220               * Register usage
0221               * tmp0,tmp1,tmp2
0222               *--------------------------------------------------------------
0223               idx.pointer.get:
0224 783A 0649  14         dect  stack
0225 783C C64B  30         mov   r11,*stack            ; Save return address
0226                       ;------------------------------------------------------
0227                       ; Get pointer
0228                       ;------------------------------------------------------
0229 783E C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     7840 8350 
0230                       ;------------------------------------------------------
0231                       ; Calculate index entry
0232                       ;------------------------------------------------------
0233 7842 0A24  56         sla   tmp0,2                     ; line number * 4
0234 7844 C824  54         mov   @idx.top(tmp0),@outparm1   ; Index slot -> Pointer
     7846 3000 
     7848 8360 
0235                       ;------------------------------------------------------
0236                       ; Get SAMS page
0237                       ;------------------------------------------------------
0238 784A C164  34         mov   @idx.top+2(tmp0),tmp1 ; SAMS Page
     784C 3002 
0239 784E 0985  56         srl   tmp1,8                ; Right justify
0240 7850 C805  38         mov   tmp1,@outparm2
     7852 8362 
0241                       ;------------------------------------------------------
0242                       ; Get line length
0243                       ;------------------------------------------------------
0244 7854 C164  34         mov   @idx.top+2(tmp0),tmp1
     7856 3002 
0245 7858 0245  22         andi  tmp1,>00ff            ; Get rid of MSB (SAMS page)
     785A 00FF 
0246 785C C805  38         mov   tmp1,@outparm3
     785E 8364 
0247                       ;------------------------------------------------------
0248                       ; Exit
0249                       ;------------------------------------------------------
0250               idx.pointer.get.$$:
0251 7860 0460  28         b     @poprt                ; Return to caller
     7862 60C8 
**** **** ****     > tivi.asm.19002
0564               
0565               
0566               ***************************************************************
0567               *               edb - Editor Buffer module
0568               ***************************************************************
0569                       copy  "editorbuffer.asm"
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
0026 7864 0649  14         dect  stack
0027 7866 C64B  30         mov   r11,*stack            ; Save return address
0028                       ;------------------------------------------------------
0029                       ; Initialize
0030                       ;------------------------------------------------------
0031 7868 0204  20         li    tmp0,edb.top
     786A A000 
0032 786C C804  38         mov   tmp0,@edb.top.ptr     ; Set pointer to top of editor buffer
     786E 2300 
0033 7870 C804  38         mov   tmp0,@edb.next_free   ; Set pointer to next free line in editor buffer
     7872 2308 
0034 7874 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     7876 230A 
0035               edb.init.$$:
0036                       ;------------------------------------------------------
0037                       ; Exit
0038                       ;------------------------------------------------------
0039 7878 0460  28         b     @poprt                ; Return to caller
     787A 60C8 
0040               
0041               
0042               
0043               ***************************************************************
0044               * edb.line.pack
0045               * Pack current line in framebuffer
0046               ***************************************************************
0047               *  bl   @edb.line.pack
0048               *--------------------------------------------------------------
0049               * INPUT
0050               * @fb.top       = Address of top row in frame buffer
0051               * @fb.row       = Current row in frame buffer
0052               * @fb.column    = Current column in frame buffer
0053               * @fb.colsline  = Columns per line in frame buffer
0054               *--------------------------------------------------------------
0055               * OUTPUT
0056               *--------------------------------------------------------------
0057               * Register usage
0058               * tmp0,tmp1,tmp2
0059               *--------------------------------------------------------------
0060               * Memory usage
0061               * rambuf   = Saved @fb.column
0062               * rambuf+2 = Saved beginning of row
0063               * rambuf+4 = Saved length of row
0064               ********@*****@*********************@**************************
0065               edb.line.pack:
0066 787C 0649  14         dect  stack
0067 787E C64B  30         mov   r11,*stack            ; Save return address
0068                       ;------------------------------------------------------
0069                       ; Get values
0070                       ;------------------------------------------------------
0071 7880 C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     7882 220C 
     7884 8390 
0072 7886 04E0  34         clr   @fb.column
     7888 220C 
0073 788A 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
     788C 76FC 
0074                       ;------------------------------------------------------
0075                       ; Prepare scan
0076                       ;------------------------------------------------------
0077 788E 04C4  14         clr   tmp0                  ; Counter
0078 7890 C160  34         mov   @fb.current,tmp1      ; Get position
     7892 2202 
0079 7894 C805  38         mov   tmp1,@rambuf+2        ; Save beginning of row
     7896 8392 
0080                       ;------------------------------------------------------
0081                       ; Scan line for >00 byte termination
0082                       ;------------------------------------------------------
0083               edb.line.pack.scan:
0084 7898 D1B5  28         movb  *tmp1+,tmp2           ; Get char
0085 789A 0986  56         srl   tmp2,8                ; Right justify
0086 789C 1302  14         jeq   edb.line.pack.idx     ; Stop scan if >00 found
0087 789E 0584  14         inc   tmp0                  ; Increase string length
0088 78A0 10FB  14         jmp   edb.line.pack.scan    ; Next character
0089                       ;------------------------------------------------------
0090                       ; Update index entry
0091                       ;------------------------------------------------------
0092               edb.line.pack.idx:
0093 78A2 C820  54         mov   @fb.topline,@parm1    ; parm1 = fb.topline + fb.row
     78A4 2204 
     78A6 8350 
0094 78A8 A820  54         a     @fb.row,@parm1        ;
     78AA 2206 
     78AC 8350 
0095 78AE C804  38         mov   tmp0,@rambuf+4        ; Save length of line
     78B0 8394 
0096 78B2 1607  14         jne   edb.line.pack.idx.normal
0097                                                   ; tmp0 != 0 ?
0098                       ;------------------------------------------------------
0099                       ; Special handling if empty line (length=0)
0100                       ;------------------------------------------------------
0101 78B4 04E0  34         clr   @parm2                ; Set pointer to >0000
     78B6 8352 
0102 78B8 04E0  34         clr   @parm3                ; Set length of line = 0
     78BA 8354 
0103 78BC 06A0  32         bl    @idx.entry.update     ; parm1=fb.topline + fb.row
     78BE 779E 
0104 78C0 101F  14         jmp   edb.line.pack.$$      ; Exit
0105                       ;------------------------------------------------------
0106                       ; Update index and store line in editor buffer
0107                       ;------------------------------------------------------
0108               edb.line.pack.idx.normal:
0109 78C2 C820  54         mov   @edb.next_free,@parm2 ; Block where packed string will reside
     78C4 2308 
     78C6 8352 
0110 78C8 C1A0  34         mov   @rambuf+4,tmp2        ; Number of bytes to copy
     78CA 8394 
0111 78CC C804  38         mov   tmp0,@parm3           ; Set length of line
     78CE 8354 
0112 78D0 06A0  32         bl    @idx.entry.update     ; parm1=fb.topline + fb.row
     78D2 779E 
0113                       ;------------------------------------------------------
0114                       ; Pack line from framebuffer to editor buffer
0115                       ;------------------------------------------------------
0116 78D4 C120  34         mov   @rambuf+2,tmp0        ; Source for memory copy
     78D6 8392 
0117 78D8 C160  34         mov   @edb.next_free,tmp1   ; Destination for memory copy
     78DA 2308 
0118 78DC C1A0  34         mov   @rambuf+4,tmp2        ; Number of bytes to copy
     78DE 8394 
0119                       ;------------------------------------------------------
0120                       ; Pack line from framebuffer to editor buffer
0121                       ;------------------------------------------------------
0122 78E0 C120  34         mov   @rambuf+2,tmp0        ; Source for memory copy
     78E2 8392 
0123 78E4 0286  22         ci    tmp2,2
     78E6 0002 
0124 78E8 1506  14         jgt   edb.line.pack.idx.normal.copy
0125                       ;------------------------------------------------------
0126                       ; Special handling 1-2 bytes copy
0127                       ;------------------------------------------------------
0128 78EA C554  38         mov   *tmp0,*tmp1           ; Copy word
0129 78EC 0204  20         li    tmp0,2                ; Set length=2
     78EE 0002 
0130 78F0 A804  38         a     tmp0,@edb.next_free   ; Update pointer to next free block
     78F2 2308 
0131 78F4 1005  14         jmp   edb.line.pack.$$      ; Exit
0132                       ;------------------------------------------------------
0133                       ; Copy memory block
0134                       ;------------------------------------------------------
0135               edb.line.pack.idx.normal.copy:
0136 78F6 06A0  32         bl    @xpym2m               ; Copy memory block
     78F8 62E8 
0137                                                   ;   tmp0 = source
0138                                                   ;   tmp1 = destination
0139                                                   ;   tmp2 = bytes to copy
0140 78FA A820  54         a     @rambuf+4,@edb.next_free
     78FC 8394 
     78FE 2308 
0141                                                   ; Update pointer to next free block
0142                       ;------------------------------------------------------
0143                       ; Exit
0144                       ;------------------------------------------------------
0145               edb.line.pack.$$:
0146 7900 C820  54         mov   @rambuf,@fb.column    ; Retrieve @fb.column
     7902 8390 
     7904 220C 
0147 7906 0460  28         b     @poprt                ; Return to caller
     7908 60C8 
0148               
0149               
0150               ***************************************************************
0151               * edb.line.unpack
0152               * Unpack specified line to framebuffer
0153               ***************************************************************
0154               *  bl   @edb.line.unpack
0155               *--------------------------------------------------------------
0156               * INPUT
0157               * @parm1 = Line to unpack from editor buffer
0158               * @parm2 = Target row in frame buffer
0159               *--------------------------------------------------------------
0160               * OUTPUT
0161               * none
0162               *--------------------------------------------------------------
0163               * Register usage
0164               * tmp0,tmp1,tmp2
0165               *--------------------------------------------------------------
0166               * Memory usage
0167               * rambuf   = Saved @parm1 of edb.line.unpack
0168               * rambuf+2 = Saved @parm2 of edb.line.unpack
0169               * rambuf+4 = Source memory address in editor buffer
0170               * rambuf+6 = Destination memory address in frame buffer
0171               * rambuf+8 = Length of unpacked line
0172               ********@*****@*********************@**************************
0173               edb.line.unpack:
0174 790A 0649  14         dect  stack
0175 790C C64B  30         mov   r11,*stack            ; Save return address
0176                       ;------------------------------------------------------
0177                       ; Save parameters
0178                       ;------------------------------------------------------
0179 790E C820  54         mov   @parm1,@rambuf
     7910 8350 
     7912 8390 
0180 7914 C820  54         mov   @parm2,@rambuf+2
     7916 8352 
     7918 8392 
0181                       ;------------------------------------------------------
0182                       ; Calculate offset in frame buffer
0183                       ;------------------------------------------------------
0184 791A C120  34         mov   @fb.colsline,tmp0
     791C 220E 
0185 791E 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
     7920 8352 
0186 7922 C1A0  34         mov   @fb.top.ptr,tmp2
     7924 2200 
0187 7926 A146  18         a     tmp2,tmp1             ; Add base to offset
0188 7928 C805  38         mov   tmp1,@rambuf+6        ; Destination row in frame buffer
     792A 8396 
0189                       ;------------------------------------------------------
0190                       ; Get length of line to unpack
0191                       ;------------------------------------------------------
0192 792C 06A0  32         bl    @edb.line.getlength   ; Get length of line
     792E 7978 
0193                                                   ; parm1 = Line number
0194 7930 C820  54         mov   @outparm1,@rambuf+8   ; Bytes to copy
     7932 8360 
     7934 8398 
0195 7936 1312  14         jeq   edb.line.unpack.clear ; Clear line if length=0
0196                       ;------------------------------------------------------
0197                       ; Index. Calculate address of entry and get pointer
0198                       ;------------------------------------------------------
0199 7938 06A0  32         bl    @idx.pointer.get      ; Get pointer to editor buffer entry
     793A 783A 
0200                                                   ; parm1 = Line number
0201 793C C820  54         mov   @outparm1,@rambuf+4   ; Source memory address in editor buffer
     793E 8360 
     7940 8394 
0202                       ;------------------------------------------------------
0203                       ; Copy line from editor buffer to frame buffer
0204                       ;------------------------------------------------------
0205               edb.line.unpack.copy:
0206 7942 C120  34         mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
     7944 8394 
0207 7946 C160  34         mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
     7948 8396 
0208 794A C1A0  34         mov   @rambuf+8,tmp2        ; Bytes to copy
     794C 8398 
0209               
0210 794E 0286  22         ci    tmp2,2
     7950 0002 
0211 7952 1203  14         jle   edb.line.unpack.copy.word
0212                       ;------------------------------------------------------
0213                       ; Copy memory block
0214                       ;------------------------------------------------------
0215 7954 06A0  32         bl    @xpym2m               ; Copy line to frame buffer
     7956 62E8 
0216                                                   ;   tmp0 = Source address
0217                                                   ;   tmp1 = Target address
0218                                                   ;   tmp2 = Bytes to copy
0219 7958 1001  14         jmp   edb.line.unpack.clear
0220                       ;------------------------------------------------------
0221                       ; Copy single word
0222                       ;------------------------------------------------------
0223               edb.line.unpack.copy.word:
0224 795A C554  38         mov   *tmp0,*tmp1           ; Copy word
0225                       ;------------------------------------------------------
0226                       ; Clear rest of row in framebuffer
0227                       ;------------------------------------------------------
0228               edb.line.unpack.clear:
0229 795C C120  34         mov   @rambuf+6,tmp0        ; Start of row in frame buffer
     795E 8396 
0230 7960 A120  34         a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer
     7962 8398 
0231 7964 0584  14         inc   tmp0                  ; Don't erase last character
0232 7966 04C5  14         clr   tmp1                  ; Fill with >00
0233 7968 C1A0  34         mov   @fb.colsline,tmp2
     796A 220E 
0234 796C 61A0  34         s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
     796E 8398 
0235 7970 06A0  32         bl    @xfilm                ; Clear rest of row
     7972 60D2 
0236                       ;------------------------------------------------------
0237                       ; Exit
0238                       ;------------------------------------------------------
0239               edb.line.unpack.$$:
0240 7974 0460  28         b     @poprt                ; Return to caller
     7976 60C8 
0241               
0242               
0243               
0244               
0245               ***************************************************************
0246               * edb.line.getlength
0247               * Get length of specified line
0248               ***************************************************************
0249               *  bl   @edb.line.getlength
0250               *--------------------------------------------------------------
0251               * INPUT
0252               * @parm1 = Line number
0253               *--------------------------------------------------------------
0254               * OUTPUT
0255               * @outparm1 = Length of line
0256               *--------------------------------------------------------------
0257               * Register usage
0258               * tmp0,tmp1
0259               ********@*****@*********************@**************************
0260               edb.line.getlength:
0261 7978 0649  14         dect  stack
0262 797A C64B  30         mov   r11,*stack            ; Save return address
0263                       ;------------------------------------------------------
0264                       ; Get length
0265                       ;------------------------------------------------------
0266 797C C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     797E 220C 
     7980 8390 
0267 7982 C120  34         mov   @parm1,tmp0           ; Get specified line
     7984 8350 
0268 7986 0A24  56         sla   tmp0,2                ; Line number * 4
0269 7988 C164  34         mov   @idx.top+2(tmp0),tmp1 ; Get index entry line length
     798A 3002 
0270 798C 0245  22         andi  tmp1,>00ff            ; Get rid of packed length
     798E 00FF 
0271 7990 C805  38         mov   tmp1,@outparm1        ; Save line length
     7992 8360 
0272                       ;------------------------------------------------------
0273                       ; Exit
0274                       ;------------------------------------------------------
0275               edb.line.getlength.$$:
0276 7994 0460  28         b     @poprt                ; Return to caller
     7996 60C8 
0277               
0278               
0279               
0280               
0281               ***************************************************************
0282               * edb.line.getlength2
0283               * Get length of current row (as seen from editor buffer side)
0284               ***************************************************************
0285               *  bl   @edb.line.getlength2
0286               *--------------------------------------------------------------
0287               * INPUT
0288               * @fb.row = Row in frame buffer
0289               *--------------------------------------------------------------
0290               * OUTPUT
0291               * @fb.row.length = Length of row
0292               *--------------------------------------------------------------
0293               * Register usage
0294               * tmp0,tmp1
0295               ********@*****@*********************@**************************
0296               edb.line.getlength2:
0297 7998 0649  14         dect  stack
0298 799A C64B  30         mov   r11,*stack            ; Save return address
0299                       ;------------------------------------------------------
0300                       ; Get length
0301                       ;------------------------------------------------------
0302 799C C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     799E 220C 
     79A0 8390 
0303 79A2 C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     79A4 2204 
0304 79A6 A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     79A8 2206 
0305 79AA 0A24  56         sla   tmp0,2                ; Line number * 4
0306 79AC C164  34         mov   @idx.top+2(tmp0),tmp1 ; Get index entry line length
     79AE 3002 
0307 79B0 0245  22         andi  tmp1,>00ff            ; Get rid of SAMS page
     79B2 00FF 
0308 79B4 C805  38         mov   tmp1,@fb.row.length   ; Save row length
     79B6 2208 
0309                       ;------------------------------------------------------
0310                       ; Exit
0311                       ;------------------------------------------------------
0312               edb.line.getlength2.$$:
0313 79B8 0460  28         b     @poprt                ; Return to caller
     79BA 60C8 
0314               
**** **** ****     > tivi.asm.19002
0570               
0571               
0572               ***************************************************************
0573               *               edb - Editor Buffer module
0574               ***************************************************************
0575                       copy  "filehandler.asm"
**** **** ****     > filehandler.asm
0001               * FILE......: filehandler.asm
0002               * Purpose...: File handling module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                     Load and save files
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ;--------------------------------------------------------------
0009               ; VDP space for PAB and file buffer
0010               ;--------------------------------------------------------------
0011      0300     vpab    equ   >0300                 ; VDP PAB    @>0300
0012      0400     vrecbuf equ   >0400                 ; VDP Buffer @>0400
0013               
0014               
0015               ***************************************************************
0016               * tfh.file.dv80.read
0017               * Read DIS/VAR 80 file into editor buffer
0018               ***************************************************************
0019               *  bl   @tfh.file.dv80.read
0020               *--------------------------------------------------------------
0021               * INPUT
0022               *--------------------------------------------------------------
0023               * OUTPUT
0024               *--------------------------------------------------------------
0025               * Register usage
0026               * tmp0, tmp1, tmp2
0027               *--------------------------------------------------------------
0028               * Memory usage
0029               ********@*****@*********************@**************************
0030               tfh.file.dv80.read:
0031 79BC 0649  14         dect  stack
0032 79BE C64B  30         mov   r11,*stack            ; Save return address
0033                       ;------------------------------------------------------
0034                       ; Initialisation
0035                       ;------------------------------------------------------
0036 79C0 04E0  34         clr   @tfh.records          ; Reset records counter
     79C2 242C 
0037 79C4 04E0  34         clr   @tfh.counter          ; Clear internal counter
     79C6 2432 
0038 79C8 04E0  34         clr   @tfh.kilobytes        ; Clear kilobytes processed
     79CA 2430 
0039 79CC 04E0  34         clr   @tfh.pabstat          ; Clear copy of VDP PAB status byte
     79CE 2428 
0040 79D0 04E0  34         clr   @tfh.ioresult         ; Clear status register contents
     79D2 242A 
0041               
0042 79D4 06A0  32         bl    @cpym2v
     79D6 629A 
0043 79D8 0300                   data vpab,pab,25      ; Copy PAB to VDP
     79DA 7AB2 
     79DC 0019 
0044                       ;------------------------------------------------------
0045                       ; Load GPL scratchpad layout
0046                       ;------------------------------------------------------
0047 79DE 06A0  32         bl    @mem.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     79E0 6C4C 
0048 79E2 2100                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0049                       ;------------------------------------------------------
0050                       ; Open DV/80 file
0051                       ;------------------------------------------------------
0052 79E4 06A0  32         bl    @file.open
     79E6 6D9A 
0053 79E8 0300                   data vpab             ; Pass file descriptor to DSRLNK
0054 79EA 21A0  38         coc   @wbit2,tmp2           ; Equal bit set?
     79EC 6042 
0055 79EE 133A  14         jeq   tfh.file.dv80.read.error
0056                                                   ; Yes, IO error occured
0057                       ;------------------------------------------------------
0058                       ; Read DV/80 file record
0059                       ;------------------------------------------------------
0060               tfh.file.dv80.read.record:
0061 79F0 05A0  34         inc   @tfh.records          ; Update counter
     79F2 242C 
0062 79F4 04E0  34         clr   @tfh.reclen           ; Reset record length
     79F6 242E 
0063               
0064 79F8 06A0  32         bl    @file.record.read     ; Read record
     79FA 6DDC 
0065 79FC 0300                   data vpab             ; tmp0=Status byte
0066                                                   ; tmp1=Bytes read
0067                                                   ; tmp2=Status register contents upon DSRLNK return
0068               
0069 79FE C804  38         mov   tmp0,@tfh.pabstat     ; Save VDP PAB status byte
     7A00 2428 
0070 7A02 C805  38         mov   tmp1,@tfh.reclen      ; Save bytes read
     7A04 242E 
0071 7A06 C806  38         mov   tmp2,@tfh.ioresult    ; Save status register contents
     7A08 242A 
0072                       ;------------------------------------------------------
0073                       ; Calculate kilobytes processed
0074                       ;------------------------------------------------------
0075 7A0A A805  38         a     tmp1,@tfh.counter
     7A0C 2432 
0076 7A0E A160  34         a     @tfh.counter,tmp1
     7A10 2432 
0077 7A12 0285  22         ci    tmp1,1024
     7A14 0400 
0078 7A16 1106  14         jlt   tfh.file.dv80.read.display
0079 7A18 05A0  34         inc   @tfh.kilobytes
     7A1A 2430 
0080 7A1C 0225  22         ai    tmp1,-1024            ; Remove KB portion and keep bytes
     7A1E FC00 
0081 7A20 C805  38         mov   tmp1,@tfh.counter
     7A22 2432 
0082                       ;------------------------------------------------------
0083                       ; Load spectra scratchpad layout
0084                       ;------------------------------------------------------
0085               tfh.file.dv80.read.display:
0086 7A24 06A0  32         bl    @mem.scrpad.backup    ; Backup GPL layout to >2000
     7A26 6648 
0087 7A28 06A0  32         bl    @mem.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     7A2A 6C6E 
0088 7A2C 2100                   data scrpad.backup2   ; / >2100->8300
0089                       ;------------------------------------------------------
0090                       ; Display results
0091                       ;------------------------------------------------------
0092 7A2E 06A0  32         bl    @putnum
     7A30 663E 
0093 7A32 0A00                   byte 10,0
0094 7A34 242C                   data tfh.records,rambuf,>3020
     7A36 8390 
     7A38 3020 
0095               
0096 7A3A 06A0  32         bl    @putnum
     7A3C 663E 
0097 7A3E 0A07                   byte 10,7
0098 7A40 242E                   data tfh.reclen,rambuf,>3020
     7A42 8390 
     7A44 3020 
0099               
0100 7A46 06A0  32         bl    @putnum
     7A48 663E 
0101 7A4A 0A0E                   byte 10,14
0102 7A4C 2430                   data tfh.kilobytes,rambuf,>3020
     7A4E 8390 
     7A50 3020 
0103                       ;------------------------------------------------------
0104                       ; Check if a file error occured
0105                       ;------------------------------------------------------
0106               tfh.file.dv80.read.check:
0107 7A52 C1A0  34         mov   @tfh.ioresult,tmp2
     7A54 242A 
0108 7A56 21A0  38         coc   @wbit2,tmp2           ; IO error occured?
     7A58 6042 
0109 7A5A 1304  14         jeq   tfh.file.dv80.read.error
0110                                                   ; Yes, so handle file error
0111                       ;------------------------------------------------------
0112                       ; Copy record to CPU memory
0113                       ;------------------------------------------------------
0114               ;       li    tmp0,vrecbuf          ; VDP source address
0115               ;       mov   tmp4,tmp1             ; RAM target address
0116               ;       mov   @reclen,tmp2          ; Number of bytes to copy
0117               ;       bl    @xpyv2m               ; Copy memory
0118                       ;------------------------------------------------------
0119                       ; Load GPL scratchpad layout again
0120                       ;------------------------------------------------------
0121 7A5C 06A0  32         bl    @mem.scrpad.pgout     ; \ Swap scratchpad memory (SPECTRA->GPL)
     7A5E 6C4C 
0122 7A60 2100                   data scrpad.backup2   ; / 8300->2100, 2000->8300
0123               
0124 7A62 10C6  14         jmp   tfh.file.dv80.read.record
0125                                                   ; Next record
0126                       ;------------------------------------------------------
0127                       ; Error handler
0128                       ;------------------------------------------------------
0129               tfh.file.dv80.read.error:
0130 7A64 C120  34         mov   @tfh.pabstat,tmp0     ; Get VDP PAB status byte
     7A66 2428 
0131 7A68 0984  56         srl   tmp0,8                ; Right align VDP PAB 1 status byte
0132 7A6A 0284  22         ci    tmp0,io.err.eof       ; EOF reached ?
     7A6C 0005 
0133 7A6E 1302  14         jeq   tfh.file.dv80.read.eof
0134                                                   ; All good. File closed by DSRLNK
0135 7A70 0460  28         b     @crash_handler        ; A File error occured. System crashed
     7A72 604C 
0136                       ;------------------------------------------------------
0137                       ; End-Of-File reached
0138                       ;------------------------------------------------------
0139               tfh.file.dv80.read.eof:
0140 7A74 06A0  32         bl    @mem.scrpad.pgin      ; \ Swap scratchpad memory (GPL->SPECTRA)
     7A76 6C6E 
0141 7A78 2100                   data scrpad.backup2   ; / >2100->8300
0142               *--------------------------------------------------------------
0143               * Exit
0144               *--------------------------------------------------------------
0145               tfh.file.dv80.read_exit:
0146 7A7A 0460  28         b     @poprt                ; Return to caller
     7A7C 60C8 
**** **** ****     > tivi.asm.19002
0576               
0577               
0578               ***************************************************************
0579               *                      Constants
0580               ***************************************************************
0581               romsat:
0582 7A7E 0303             data >0303,>000f              ; Cursor YX, shape and colour
     7A80 000F 
0583               
0584               cursors:
0585 7A82 0000             data >0000,>0000,>0000,>001c  ; Cursor 1 - Insert mode
     7A84 0000 
     7A86 0000 
     7A88 001C 
0586 7A8A 1010             data >1010,>1010,>1010,>1000  ; Cursor 2 - Insert mode
     7A8C 1010 
     7A8E 1010 
     7A90 1000 
0587 7A92 1C1C             data >1c1c,>1c1c,>1c1c,>1c00  ; Cursor 3 - Overwrite mode
     7A94 1C1C 
     7A96 1C1C 
     7A98 1C00 
0588               
0589               ***************************************************************
0590               *                       Strings
0591               ***************************************************************
0592               txt_delim
0593 7A9A 012C             byte  1
0594 7A9B ....             text  ','
0595                       even
0596               
0597               txt_marker
0598 7A9C 052A             byte  5
0599 7A9D ....             text  '*EOF*'
0600                       even
0601               
0602               txt_bottom
0603 7AA2 0520             byte  5
0604 7AA3 ....             text  '  BOT'
0605                       even
0606               
0607               txt_ovrwrite
0608 7AA8 0320             byte  3
0609 7AA9 ....             text  '   '
0610                       even
0611               
0612               txt_insert
0613 7AAC 0349             byte  3
0614 7AAD ....             text  'INS'
0615                       even
0616               
0617 7AB0 7AB0     end          data    $
0618               
0619               
0620               
0621               ***************************************************************
0622               * PAB for accessing DV/80 file
0623               ********@*****@*********************@**************************
0624 7AB2 0014     pab     byte  io.op.open            ;  0    - OPEN
0625                       byte  io.ft.sf.ivd          ;  1    - INPUT, VARIABLE, DISPLAY
0626 7AB4 0400             data  vrecbuf               ;  2-3  - Record buffer in VDP memory
0627 7AB6 5000             byte  80                    ;  4    - Record length (80 characters maximum)
0628                       byte  00                    ;  5    - Character count
0629 7AB8 0000             data  >0000                 ;  6-7  - Seek record (only for fixed records)
0630 7ABA 000F             byte  >00                   ;  8    - Screen offset (cassette DSR only)
0631               fname   byte  15                    ;  9    - File descriptor length
0632 7ABC ....             text 'DSK1.SPEECHDOCS'      ; 10-.. - File descriptor (Device + '.' + File name)
0633               
0634               
0635                       even

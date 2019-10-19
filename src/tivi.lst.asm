XAS99 CROSS-ASSEMBLER   VERSION 1.7.0
**** **** ****     > tivi.asm.2077
0001               ***************************************************************
0002               *
0003               *                          TiVi Editor
0004               *
0005               *                (c)2018-2019 // Filip van Vooren
0006               *
0007               ***************************************************************
0008               * File: tivi.asm                    ; Version 191019-2077
0009               *--------------------------------------------------------------
0010               * TI-99/4a Advanced Editor & IDE
0011               *--------------------------------------------------------------
0012               * 2018-11-01   Development started
0013               ********@*****@*********************@**************************
0014                       save  >6000,>7fff
0015                       aorg  >6000
0016               *--------------------------------------------------------------
0017      0001     debug                  equ  1       ; Turn on debugging
0018               *--------------------------------------------------------------
0019               * Skip unused spectra2 code modules for reduced code size
0020               *--------------------------------------------------------------
0021      0001     skip_rom_bankswitch     equ  1      ; Skip ROM bankswitching support
0022      0001     skip_grom_cpu_copy      equ  1      ; Skip GROM to CPU copy functions
0023      0001     skip_grom_vram_copy     equ  1      ; Skip GROM to VDP vram copy functions
0024      0001     skip_vdp_hchar          equ  1      ; Skip hchar, xhchar
0025      0001     skip_vdp_vchar          equ  1      ; Skip vchar, xvchar
0026      0001     skip_vdp_boxes          equ  1      ; Skip filbox, putbox
0027      0001     skip_vdp_bitmap         equ  1      ; Skip bitmap functions
0028      0001     skip_vdp_viewport       equ  1      ; Skip viewport functions
0029      0001     skip_vdp_rle_decompress equ  1      ; Skip RLE decompress to VRAM
0030      0001     skip_vdp_px2yx_calc     equ  1      ; Skip pixel to YX calculation
0031      0001     skip_sound_player       equ  1      ; Skip inclusion of sound player code
0032      0001     skip_tms52xx_detection  equ  1      ; Skip speech synthesizer detection
0033      0001     skip_tms52xx_player     equ  1      ; Skip inclusion of speech player code
0034      0001     skip_virtual_keyboard   equ  1      ; Skip virtual keyboard scan
0035      0001     skip_random_generator   equ  1      ; Skip random functions
0036      0001     skip_cpu_hexsupport     equ  1      ; Skip mkhex, puthex
0037      0001     skip_cpu_crc16          equ  1      ; Skip CPU memory CRC-16 calculation
0038               
0039               *--------------------------------------------------------------
0040               * Cartridge header
0041               *--------------------------------------------------------------
0042 6000 AA01     grmhdr  byte  >aa,1,1,0,0,0
     6002 0100 
     6004 0000 
0043 6006 6010             data  prog0
0044 6008 0000             byte  0,0,0,0,0,0,0,0
     600A 0000 
     600C 0000 
     600E 0000 
0045 6010 0000     prog0   data  0                     ; No more items following
0046 6012 6E30             data  runlib
0047               
0049               
0050 6014 1054             byte  16
0051 6015 ....             text  'TIVI 191019-2077'
0052                       even
0053               
0061               *--------------------------------------------------------------
0062               * Include required files
0063               *--------------------------------------------------------------
0064                       copy  "/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
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
0046               * skip_tms52xx_detection    equ  1  ; Skip speech synthesizer detection
0047               * skip_tms52xx_player       equ  1  ; Skip inclusion of speech player code
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
0062               * skip_iosupport            equ  1  ; Skip support for file I/O, dsrlnk
0063               *
0064               * == Startup behaviour
0065               * startup_backup_scrpad     equ  1  ; Backup scratchpad @>8300:>83ff to @>2000
0066               * startup_keep_vdpdiskbuf   equ  1  ; Keep VDP memory reseved for 3 VDP disk buffers
0067               *******************************************************************************
0068               
0069               *//////////////////////////////////////////////////////////////
0070               *                       RUNLIB SETUP
0071               *//////////////////////////////////////////////////////////////
0072               
0073                       copy  "memsetup.equ"             ; runlib scratchpad memory setup
**** **** ****     > memsetup.equ
0001               * FILE......: memsetup.equ
0002               * Purpose...: Equates for memory setup
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
0074                       copy  "registers.equ"            ; runlib registers
**** **** ****     > registers.equ
0001               * FILE......: registers.equ
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
0075                       copy  "portaddr.equ"             ; runlib hardware port addresses
**** **** ****     > portaddr.equ
0001               * FILE......: portaddr.equ
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
0076                       copy  "param.equ"                ; runlib parameters
**** **** ****     > param.equ
0001               * FILE......: param.equ
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
0082                       copy  "constants.asm"            ; Define constants
**** **** ****     > constants.asm
0001               * FILE......: constants.asm
0002               * Purpose...: Definition of constants used by runlib modules
0003               
0004               ***************************************************************
0005               *                      Some constants
0006               ********@*****@*********************@**************************
0037 6026 8000     wbit0   data  >8000                 ; Binary 1000000000000000
0038 6028 4000     wbit1   data  >4000                 ; Binary 0100000000000000
0039 602A 2000     wbit2   data  >2000                 ; Binary 0010000000000000
0040 602C 1000     wbit3   data  >1000                 ; Binary 0001000000000000
0041 602E 0800     wbit4   data  >0800                 ; Binary 0000100000000000
0042 6030 0400     wbit5   data  >0400                 ; Binary 0000010000000000
0043 6032 0200     wbit6   data  >0200                 ; Binary 0000001000000000
0044 6034 0100     wbit7   data  >0100                 ; Binary 0000000100000000
0045 6036 0080     wbit8   data  >0080                 ; Binary 0000000010000000
0046 6038 0040     wbit9   data  >0040                 ; Binary 0000000001000000
0047 603A 0020     wbit10  data  >0020                 ; Binary 0000000000100000
0048 603C 0010     wbit11  data  >0010                 ; Binary 0000000000010000
0049 603E 0008     wbit12  data  >0008                 ; Binary 0000000000001000
0050 6040 0004     wbit13  data  >0004                 ; Binary 0000000000000100
0051 6042 0002     wbit14  data  >0002                 ; Binary 0000000000000010
0052 6044 0001     wbit15  data  >0001                 ; Binary 0000000000000001
0053 6046 FFFF     whffff  data  >ffff                 ; Binary 1111111111111111
0054 6048 0001     bd0     byte  0                     ; Digit 0
0055               bd1     byte  1                     ; Digit 1
0056 604A 0203     bd2     byte  2                     ; Digit 2
0057               bd3     byte  3                     ; Digit 3
0058 604C 0405     bd4     byte  4                     ; Digit 4
0059               bd5     byte  5                     ; Digit 5
0060 604E 0607     bd6     byte  6                     ; Digit 6
0061               bd7     byte  7                     ; Digit 7
0062 6050 0809     bd8     byte  8                     ; Digit 8
0063               bd9     byte  9                     ; Digit 9
0064 6052 D000     bd208   byte  208                   ; Digit 208 (>D0)
0065                       even
**** **** ****     > runlib.asm
0083                       copy  "values.equ"               ; Equates for word/MSB/LSB-values
**** **** ****     > values.equ
0001               * FILE......: values.equ
0002               * Purpose...: Equates for word/MSB/LSB-values
0003               
0004               --------------------------------------------------------------
0005               * Word values
0006               *--------------------------------------------------------------
0007      6044     w$0001  equ   wbit15                ; >0001
0008      6042     w$0002  equ   wbit14                ; >0002
0009      6040     w$0004  equ   wbit13                ; >0004
0010      603E     w$0008  equ   wbit12                ; >0008
0011      603C     w$0010  equ   wbit11                ; >0010
0012      603A     w$0020  equ   wbit10                ; >0020
0013      6038     w$0040  equ   wbit9                 ; >0040
0014      6036     w$0080  equ   wbit8                 ; >0080
0015      6034     w$0100  equ   wbit7                 ; >0100
0016      6032     w$0200  equ   wbit6                 ; >0200
0017      6030     w$0400  equ   wbit5                 ; >0400
0018      602E     w$0800  equ   wbit4                 ; >0800
0019      602C     w$1000  equ   wbit3                 ; >1000
0020      602A     w$2000  equ   wbit2                 ; >2000
0021      6028     w$4000  equ   wbit1                 ; >4000
0022      6026     w$8000  equ   wbit0                 ; >8000
0023      6046     w$ffff  equ   whffff                ; >ffff
0024               *--------------------------------------------------------------
0025               * MSB values: >01 - >0f for byte operations AB, SB, CB, ...
0026               *--------------------------------------------------------------
0027      6034     hb$01   equ   wbit7                 ; >0100
0028      6032     hb$02   equ   wbit6                 ; >0200
0029      6030     hb$04   equ   wbit5                 ; >0400
0030      602E     hb$08   equ   wbit4                 ; >0800
0031      602C     hb$10   equ   wbit3                 ; >1000
0032      602A     hb$20   equ   wbit2                 ; >2000
0033      6028     hb$40   equ   wbit1                 ; >4000
0034      6026     hb$80   equ   wbit0                 ; >8000
0035               *--------------------------------------------------------------
0036               * LSB values: >01 - >0f for byte operations AB, SB, CB, ...
0037               *--------------------------------------------------------------
0038      6044     lb$01   equ   wbit15                ; >0001
0039      6042     lb$02   equ   wbit14                ; >0002
0040      6040     lb$04   equ   wbit13                ; >0004
0041      603E     lb$08   equ   wbit12                ; >0008
0042      603C     lb$10   equ   wbit11                ; >0010
0043      603A     lb$20   equ   wbit10                ; >0020
0044      6038     lb$40   equ   wbit9                 ; >0040
0045      6036     lb$80   equ   wbit8                 ; >0080
**** **** ****     > runlib.asm
0084                       copy  "config.equ"               ; Equates for bits in config register
**** **** ****     > config.equ
0001               * FILE......: config.equ
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
0027      602A     palon   equ   wbit2                 ; bit 2=1   (VDP9918 PAL version)
0028      6034     enusr   equ   wbit7                 ; bit 7=1   (Enable user hook)
0029      6038     enknl   equ   wbit9                 ; bit 9=1   (Enable kernel thread)
0030      603A     tms5200 equ   wbit10                ; bit 10=1  (Speech Synthesizer present)
0031      603C     anykey  equ   wbit11                ; BIT 11 in the CONFIG register
0032               ***************************************************************
0033               
**** **** ****     > runlib.asm
0085                       copy  "cpu_crash_hndlr.asm"      ; CPU program crashed handler
**** **** ****     > cpu_crash_hndlr.asm
0001               * FILE......: cpu_crash_hndlr.asm
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
0012               *  bl  @crash
0013               *--------------------------------------------------------------
0014               *  REMARKS
0015               *  Is expected to be called via bl statement so that R11
0016               *  contains address that triggered us
0017               ********@*****@*********************@**************************
0018 6054 0420  54 crash   blwp  @>0000                ; Soft-reset
     6056 0000 
**** **** ****     > runlib.asm
0086                       copy  "vdp_tables.asm"           ; Data used by runtime library
**** **** ****     > vdp_tables.asm
0001               * FILE......: vdp_tables.a99
0002               * Purpose...: Video mode tables
0003               
0004               ***************************************************************
0005               * Graphics mode 1 (32 columns/24 rows)
0006               *--------------------------------------------------------------
0007 6058 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     605A 000E 
     605C 0106 
     605E 0205 
     6060 0020 
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
0032 6062 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     6064 000E 
     6066 0106 
     6068 00F5 
     606A 0028 
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
0058 606C 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     606E 003F 
     6070 0240 
     6072 03F5 
     6074 0050 
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
0084 6076 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     6078 003F 
     607A 0240 
     607C 03F5 
     607E 0050 
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
0013 6080 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 6082 16FD             data  >16fd                 ; |         jne   mcloop
0015 6084 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 6086 D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 6088 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
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
0038 608A C0F9  30 popr3   mov   *stack+,r3
0039 608C C0B9  30 popr2   mov   *stack+,r2
0040 608E C079  30 popr1   mov   *stack+,r1
0041 6090 C039  30 popr0   mov   *stack+,r0
0042 6092 C2F9  30 poprt   mov   *stack+,r11
0043 6094 045B  20         b     *r11
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
0067 6096 C13B  30 film    mov   *r11+,tmp0            ; Memory start
0068 6098 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0069 609A C1BB  30         mov   *r11+,tmp2            ; Repeat count
0070               *--------------------------------------------------------------
0071               * Fill memory with 16 bit words
0072               *--------------------------------------------------------------
0073 609C C1C6  18 xfilm   mov   tmp2,tmp3
0074 609E 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     60A0 0001 
0075               
0076 60A2 1301  14         jeq   film1
0077 60A4 0606  14         dec   tmp2                  ; Make TMP2 even
0078 60A6 D820  54 film1   movb  @tmp1lb,@tmp1hb       ; Duplicate value
     60A8 830B 
     60AA 830A 
0079 60AC CD05  34 film2   mov   tmp1,*tmp0+
0080 60AE 0646  14         dect  tmp2
0081 60B0 16FD  14         jne   film2
0082               *--------------------------------------------------------------
0083               * Fill last byte if ODD
0084               *--------------------------------------------------------------
0085 60B2 C1C7  18         mov   tmp3,tmp3
0086 60B4 1301  14         jeq   filmz
0087 60B6 D505  30         movb  tmp1,*tmp0
0088 60B8 045B  20 filmz   b     *r11
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
0107 60BA C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0108 60BC C17B  30         mov   *r11+,tmp1            ; Byte to fill
0109 60BE C1BB  30         mov   *r11+,tmp2            ; Repeat count
0110               *--------------------------------------------------------------
0111               *    Setup VDP write address
0112               *--------------------------------------------------------------
0113 60C0 0264  22 xfilv   ori   tmp0,>4000
     60C2 4000 
0114 60C4 06C4  14         swpb  tmp0
0115 60C6 D804  38         movb  tmp0,@vdpa
     60C8 8C02 
0116 60CA 06C4  14         swpb  tmp0
0117 60CC D804  38         movb  tmp0,@vdpa
     60CE 8C02 
0118               *--------------------------------------------------------------
0119               *    Fill bytes in VDP memory
0120               *--------------------------------------------------------------
0121 60D0 020F  20         li    r15,vdpw              ; Set VDP write address
     60D2 8C00 
0122 60D4 06C5  14         swpb  tmp1
0123 60D6 C820  54         mov   @filzz,@mcloop        ; Setup move command
     60D8 60E0 
     60DA 8320 
0124 60DC 0460  28         b     @mcloop               ; Write data to VDP
     60DE 8320 
0125               *--------------------------------------------------------------
0129 60E0 D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
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
0149 60E2 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     60E4 4000 
0150 60E6 06C4  14 vdra    swpb  tmp0
0151 60E8 D804  38         movb  tmp0,@vdpa
     60EA 8C02 
0152 60EC 06C4  14         swpb  tmp0
0153 60EE D804  38         movb  tmp0,@vdpa            ; Set VDP address
     60F0 8C02 
0154 60F2 045B  20         b     *r11
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
0165 60F4 C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0166 60F6 C17B  30         mov   *r11+,tmp1
0167 60F8 C18B  18 xvputb  mov   r11,tmp2              ; Save R11
0168 60FA 06A0  32         bl    @vdwa                 ; Set VDP write address
     60FC 60E2 
0169               
0170 60FE 06C5  14         swpb  tmp1                  ; Get byte to write
0171 6100 D7C5  30         movb  tmp1,*r15             ; Write byte
0172 6102 0456  20         b     *tmp2                 ; Exit
0173               
0174               
0175               ***************************************************************
0176               * VGETB - VDP get single byte
0177               ***************************************************************
0178               *  BL @VGETB
0179               *  DATA P0
0180               *--------------------------------------------------------------
0181               *  P0 = VDP source address
0182               ********@*****@*********************@**************************
0183 6104 C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0184 6106 C18B  18 xvgetb  mov   r11,tmp2              ; Save R11
0185 6108 06A0  32         bl    @vdra                 ; Set VDP read address
     610A 60E6 
0186               
0187 610C D120  34         movb  @vdpr,tmp0            ; Read byte
     610E 8800 
0188               
0189 6110 0984  56         srl   tmp0,8                ; Right align
0190 6112 0456  20         b     *tmp2                 ; Exit
0191               
0192               
0193               ***************************************************************
0194               * VIDTAB - Dump videomode table
0195               ***************************************************************
0196               *  BL   @VIDTAB
0197               *  DATA P0
0198               *--------------------------------------------------------------
0199               *  P0 = Address of video mode table
0200               *--------------------------------------------------------------
0201               *  BL   @XIDTAB
0202               *
0203               *  TMP0 = Address of video mode table
0204               *--------------------------------------------------------------
0205               *  Remarks
0206               *  TMP1 = MSB is the VDP target register
0207               *         LSB is the value to write
0208               ********@*****@*********************@**************************
0209 6114 C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0210 6116 C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0211               *--------------------------------------------------------------
0212               * Calculate PNT base address
0213               *--------------------------------------------------------------
0214 6118 C144  18         mov   tmp0,tmp1
0215 611A 05C5  14         inct  tmp1
0216 611C D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0217 611E 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     6120 FF00 
0218 6122 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0219 6124 C805  38         mov   tmp1,@wbase           ; Store calculated base
     6126 8328 
0220               *--------------------------------------------------------------
0221               * Dump VDP shadow registers
0222               *--------------------------------------------------------------
0223 6128 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     612A 8000 
0224 612C 0206  20         li    tmp2,8
     612E 0008 
0225 6130 D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     6132 830B 
0226 6134 06C5  14         swpb  tmp1
0227 6136 D805  38         movb  tmp1,@vdpa
     6138 8C02 
0228 613A 06C5  14         swpb  tmp1
0229 613C D805  38         movb  tmp1,@vdpa
     613E 8C02 
0230 6140 0225  22         ai    tmp1,>0100
     6142 0100 
0231 6144 0606  14         dec   tmp2
0232 6146 16F4  14         jne   vidta1                ; Next register
0233 6148 C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     614A 833A 
0234 614C 045B  20         b     *r11
0235               
0236               
0237               ***************************************************************
0238               * PUTVR  - Put single VDP register
0239               ***************************************************************
0240               *  BL   @PUTVR
0241               *  DATA P0
0242               *--------------------------------------------------------------
0243               *  P0 = MSB is the VDP target register
0244               *       LSB is the value to write
0245               *--------------------------------------------------------------
0246               *  BL   @PUTVRX
0247               *
0248               *  TMP0 = MSB is the VDP target register
0249               *         LSB is the value to write
0250               ********@*****@*********************@**************************
0251 614E C13B  30 putvr   mov   *r11+,tmp0
0252 6150 0264  22 putvrx  ori   tmp0,>8000
     6152 8000 
0253 6154 06C4  14         swpb  tmp0
0254 6156 D804  38         movb  tmp0,@vdpa
     6158 8C02 
0255 615A 06C4  14         swpb  tmp0
0256 615C D804  38         movb  tmp0,@vdpa
     615E 8C02 
0257 6160 045B  20         b     *r11
0258               
0259               
0260               ***************************************************************
0261               * PUTV01  - Put VDP registers #0 and #1
0262               ***************************************************************
0263               *  BL   @PUTV01
0264               ********@*****@*********************@**************************
0265 6162 C20B  18 putv01  mov   r11,tmp4              ; Save R11
0266 6164 C10E  18         mov   r14,tmp0
0267 6166 0984  56         srl   tmp0,8
0268 6168 06A0  32         bl    @putvrx               ; Write VR#0
     616A 6150 
0269 616C 0204  20         li    tmp0,>0100
     616E 0100 
0270 6170 D820  54         movb  @r14lb,@tmp0lb
     6172 831D 
     6174 8309 
0271 6176 06A0  32         bl    @putvrx               ; Write VR#1
     6178 6150 
0272 617A 0458  20         b     *tmp4                 ; Exit
0273               
0274               
0275               ***************************************************************
0276               * LDFNT - Load TI-99/4A font from GROM into VDP
0277               ***************************************************************
0278               *  BL   @LDFNT
0279               *  DATA P0,P1
0280               *--------------------------------------------------------------
0281               *  P0 = VDP Target address
0282               *  P1 = Font options
0283               *--------------------------------------------------------------
0284               * Uses registers tmp0-tmp4
0285               ********@*****@*********************@**************************
0286 617C C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0287 617E 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0288 6180 C11B  26         mov   *r11,tmp0             ; Get P0
0289 6182 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     6184 7FFF 
0290 6186 2120  38         coc   @wbit0,tmp0
     6188 6026 
0291 618A 1604  14         jne   ldfnt1
0292 618C 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     618E 8000 
0293 6190 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     6192 7FFF 
0294               *--------------------------------------------------------------
0295               * Read font table address from GROM into tmp1
0296               *--------------------------------------------------------------
0297 6194 C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     6196 61FE 
0298 6198 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     619A 9C02 
0299 619C 06C4  14         swpb  tmp0
0300 619E D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     61A0 9C02 
0301 61A2 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     61A4 9800 
0302 61A6 06C5  14         swpb  tmp1
0303 61A8 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     61AA 9800 
0304 61AC 06C5  14         swpb  tmp1
0305               *--------------------------------------------------------------
0306               * Setup GROM source address from tmp1
0307               *--------------------------------------------------------------
0308 61AE D805  38         movb  tmp1,@grmwa
     61B0 9C02 
0309 61B2 06C5  14         swpb  tmp1
0310 61B4 D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     61B6 9C02 
0311               *--------------------------------------------------------------
0312               * Setup VDP target address
0313               *--------------------------------------------------------------
0314 61B8 C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0315 61BA 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     61BC 60E2 
0316 61BE 05C8  14         inct  tmp4                  ; R11=R11+2
0317 61C0 C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0318 61C2 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     61C4 7FFF 
0319 61C6 C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     61C8 6200 
0320 61CA C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     61CC 6202 
0321               *--------------------------------------------------------------
0322               * Copy from GROM to VRAM
0323               *--------------------------------------------------------------
0324 61CE 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0325 61D0 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0326 61D2 D120  34         movb  @grmrd,tmp0
     61D4 9800 
0327               *--------------------------------------------------------------
0328               *   Make font fat
0329               *--------------------------------------------------------------
0330 61D6 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     61D8 6026 
0331 61DA 1603  14         jne   ldfnt3                ; No, so skip
0332 61DC D1C4  18         movb  tmp0,tmp3
0333 61DE 0917  56         srl   tmp3,1
0334 61E0 E107  18         soc   tmp3,tmp0
0335               *--------------------------------------------------------------
0336               *   Dump byte to VDP and do housekeeping
0337               *--------------------------------------------------------------
0338 61E2 D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     61E4 8C00 
0339 61E6 0606  14         dec   tmp2
0340 61E8 16F2  14         jne   ldfnt2
0341 61EA 05C8  14         inct  tmp4                  ; R11=R11+2
0342 61EC 020F  20         li    r15,vdpw              ; Set VDP write address
     61EE 8C00 
0343 61F0 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     61F2 7FFF 
0344 61F4 0458  20         b     *tmp4                 ; Exit
0345 61F6 D820  54 ldfnt4  movb  @bd0,@vdpw            ; Insert byte >00 into VRAM
     61F8 6048 
     61FA 8C00 
0346 61FC 10E8  14         jmp   ldfnt2
0347               *--------------------------------------------------------------
0348               * Fonts pointer table
0349               *--------------------------------------------------------------
0350 61FE 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     6200 0200 
     6202 0000 
0351 6204 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     6206 01C0 
     6208 0101 
0352 620A 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     620C 02A0 
     620E 0101 
0353 6210 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     6212 00E0 
     6214 0101 
0354               
0355               
0356               
0357               ***************************************************************
0358               * YX2PNT - Get VDP PNT address for current YX cursor position
0359               ***************************************************************
0360               *  BL   @YX2PNT
0361               *--------------------------------------------------------------
0362               *  INPUT
0363               *  @WYX = Cursor YX position
0364               *--------------------------------------------------------------
0365               *  OUTPUT
0366               *  TMP0 = VDP address for entry in Pattern Name Table
0367               *--------------------------------------------------------------
0368               *  Register usage
0369               *  TMP0, R14, R15
0370               ********@*****@*********************@**************************
0371 6216 C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0372 6218 C3A0  34         mov   @wyx,r14              ; Get YX
     621A 832A 
0373 621C 098E  56         srl   r14,8                 ; Right justify (remove X)
0374 621E 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     6220 833A 
0375               *--------------------------------------------------------------
0376               * Do rest of calculation with R15 (16 bit part is there)
0377               * Re-use R14
0378               *--------------------------------------------------------------
0379 6222 C3A0  34         mov   @wyx,r14              ; Get YX
     6224 832A 
0380 6226 024E  22         andi  r14,>00ff             ; Remove Y
     6228 00FF 
0381 622A A3CE  18         a     r14,r15               ; pos = pos + X
0382 622C A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     622E 8328 
0383               *--------------------------------------------------------------
0384               * Clean up before exit
0385               *--------------------------------------------------------------
0386 6230 C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0387 6232 C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0388 6234 020F  20         li    r15,vdpw              ; VDP write address
     6236 8C00 
0389 6238 045B  20         b     *r11
0390               
0391               
0392               
0393               ***************************************************************
0394               * Put length-byte prefixed string at current YX
0395               ***************************************************************
0396               *  BL   @PUTSTR
0397               *  DATA P0
0398               *
0399               *  P0 = Pointer to string
0400               *--------------------------------------------------------------
0401               *  REMARKS
0402               *  First byte of string must contain length
0403               ********@*****@*********************@**************************
0404 623A C17B  30 putstr  mov   *r11+,tmp1
0405 623C D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0406 623E C1CB  18 xutstr  mov   r11,tmp3
0407 6240 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     6242 6216 
0408 6244 C2C7  18         mov   tmp3,r11
0409 6246 0986  56         srl   tmp2,8                ; Right justify length byte
0410 6248 0460  28         b     @xpym2v               ; Display string
     624A 625A 
0411               
0412               
0413               ***************************************************************
0414               * Put length-byte prefixed string at YX
0415               ***************************************************************
0416               *  BL   @PUTAT
0417               *  DATA P0,P1
0418               *
0419               *  P0 = YX position
0420               *  P1 = Pointer to string
0421               *--------------------------------------------------------------
0422               *  REMARKS
0423               *  First byte of string must contain length
0424               ********@*****@*********************@**************************
0425 624C C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     624E 832A 
0426 6250 0460  28         b     @putstr
     6252 623A 
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
0020 6254 C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 6256 C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 6258 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP write address
0025               *--------------------------------------------------------------
0026 625A 0264  22 xpym2v  ori   tmp0,>4000
     625C 4000 
0027 625E 06C4  14         swpb  tmp0
0028 6260 D804  38         movb  tmp0,@vdpa
     6262 8C02 
0029 6264 06C4  14         swpb  tmp0
0030 6266 D804  38         movb  tmp0,@vdpa
     6268 8C02 
0031               *--------------------------------------------------------------
0032               *    Copy bytes from CPU memory to VRAM
0033               *--------------------------------------------------------------
0034 626A 020F  20         li    r15,vdpw              ; Set VDP write address
     626C 8C00 
0035 626E C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     6270 6278 
     6272 8320 
0036 6274 0460  28         b     @mcloop               ; Write data to VDP
     6276 8320 
0037 6278 D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
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
0020 627A C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 627C C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 627E C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 6280 06C4  14 xpyv2m  swpb  tmp0
0027 6282 D804  38         movb  tmp0,@vdpa
     6284 8C02 
0028 6286 06C4  14         swpb  tmp0
0029 6288 D804  38         movb  tmp0,@vdpa
     628A 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 628C 020F  20         li    r15,vdpr              ; Set VDP read address
     628E 8800 
0034 6290 C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     6292 629A 
     6294 8320 
0035 6296 0460  28         b     @mcloop               ; Read data from VDP
     6298 8320 
0036 629A DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
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
0024 629C C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 629E C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 62A0 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 62A2 C186  18 xpym2m  mov    tmp2,tmp2            ; Bytes to copy = 0 ?
0031 62A4 1602  14         jne    cpym0
0032 62A6 0460  28         b      @crash               ; Yes, crash
     62A8 6054 
0033 62AA 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     62AC 7FFF 
0034 62AE C1C4  18         mov   tmp0,tmp3
0035 62B0 0247  22         andi  tmp3,1
     62B2 0001 
0036 62B4 1618  14         jne   cpyodd                ; Odd source address handling
0037 62B6 C1C5  18 cpym1   mov   tmp1,tmp3
0038 62B8 0247  22         andi  tmp3,1
     62BA 0001 
0039 62BC 1614  14         jne   cpyodd                ; Odd target address handling
0040               *--------------------------------------------------------------
0041               * 8 bit copy
0042               *--------------------------------------------------------------
0043 62BE 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     62C0 6026 
0044 62C2 1605  14         jne   cpym3
0045 62C4 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     62C6 62EC 
     62C8 8320 
0046 62CA 0460  28         b     @mcloop               ; Copy memory and exit
     62CC 8320 
0047               *--------------------------------------------------------------
0048               * 16 bit copy
0049               *--------------------------------------------------------------
0050 62CE C1C6  18 cpym3   mov   tmp2,tmp3
0051 62D0 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     62D2 0001 
0052 62D4 1301  14         jeq   cpym4
0053 62D6 0606  14         dec   tmp2                  ; Make TMP2 even
0054 62D8 CD74  46 cpym4   mov   *tmp0+,*tmp1+
0055 62DA 0646  14         dect  tmp2
0056 62DC 16FD  14         jne   cpym4
0057               *--------------------------------------------------------------
0058               * Copy last byte if ODD
0059               *--------------------------------------------------------------
0060 62DE C1C7  18         mov   tmp3,tmp3
0061 62E0 1301  14         jeq   cpymz
0062 62E2 D554  38         movb  *tmp0,*tmp1
0063 62E4 045B  20 cpymz   b     *r11
0064               *--------------------------------------------------------------
0065               * Handle odd source/target address
0066               *--------------------------------------------------------------
0067 62E6 0262  22 cpyodd  ori   config,>8000        ; Set CONFIG bot 0
     62E8 8000 
0068 62EA 10E9  14         jmp   cpym2
0069 62EC DD74     tmp011  data  >dd74               ; MOVB *TMP0+,*TMP1+
**** **** ****     > runlib.asm
0100               
0104               
0108               
0112               
0114                       copy  "vdp_intscr.asm"           ; VDP interrupt & screen on/off
**** **** ****     > vdp_intscr.asm
0001               * FILE......: vdp_intscr.asm
0002               * Purpose...: VDP interrupt & screen on/off
0003               
0004               ***************************************************************
0005               * SCROFF - Disable screen display
0006               ***************************************************************
0007               *  BL @SCROFF
0008               ********@*****@*********************@**************************
0009 62EE 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     62F0 FFBF 
0010 62F2 0460  28         b     @putv01
     62F4 6162 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********@*****@*********************@**************************
0017 62F6 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     62F8 0040 
0018 62FA 0460  28         b     @putv01
     62FC 6162 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********@*****@*********************@**************************
0025 62FE 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     6300 FFDF 
0026 6302 0460  28         b     @putv01
     6304 6162 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********@*****@*********************@**************************
0033 6306 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     6308 0020 
0034 630A 0460  28         b     @putv01
     630C 6162 
**** **** ****     > runlib.asm
0116               
0118                       copy  "vdp_sprites.asm"          ; VDP sprites
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
0010 630E 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     6310 FFFE 
0011 6312 0460  28         b     @putv01
     6314 6162 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********@*****@*********************@**************************
0018 6316 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     6318 0001 
0019 631A 0460  28         b     @putv01
     631C 6162 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********@*****@*********************@**************************
0026 631E 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     6320 FFFD 
0027 6322 0460  28         b     @putv01
     6324 6162 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********@*****@*********************@**************************
0034 6326 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     6328 0002 
0035 632A 0460  28         b     @putv01
     632C 6162 
**** **** ****     > runlib.asm
0120               
0122                       copy  "vdp_cursor.asm"           ; VDP cursor handling
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
0018 632E C83B  50 at      mov   *r11+,@wyx
     6330 832A 
0019 6332 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********@*****@*********************@**************************
0027 6334 B820  54 down    ab    @hb$01,@wyx
     6336 6034 
     6338 832A 
0028 633A 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********@*****@*********************@**************************
0036 633C 7820  54 up      sb    @hb$01,@wyx
     633E 6034 
     6340 832A 
0037 6342 045B  20         b     *r11
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
0049 6344 C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 6346 D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     6348 832A 
0051 634A C804  38         mov   tmp0,@wyx             ; Save as new YX position
     634C 832A 
0052 634E 045B  20         b     *r11
**** **** ****     > runlib.asm
0124               
0126                       copy  "vdp_yx2px_calc.asm"       ; VDP calculate pixel pos for YX coordinate
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
0021 6350 C120  34 yx2px   mov   @wyx,tmp0
     6352 832A 
0022 6354 C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 6356 06C4  14         swpb  tmp0                  ; Y<->X
0024 6358 04C5  14         clr   tmp1                  ; Clear before copy
0025 635A D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 635C 20A0  38         coc   @wbit1,config         ; f18a present ?
     635E 6028 
0030 6360 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 6362 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     6364 833A 
     6366 6390 
0032 6368 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 636A 0A15  56         sla   tmp1,1                ; X = X * 2
0035 636C B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 636E 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     6370 0500 
0037 6372 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 6374 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 6376 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 6378 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 637A D105  18         movb  tmp1,tmp0
0051 637C 06C4  14         swpb  tmp0                  ; X<->Y
0052 637E 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     6380 6026 
0053 6382 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 6384 7120  34 yx2pi2  sb    @bd1,tmp0             ; Adjust Y. Top of screen is at >FF
     6386 6049 
0059 6388 9120  34         cb    @bd208,tmp0           ; Y position = >D0 ?
     638A 6052 
0060 638C 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 638E 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 6390 0050            data   80
0067               
0068               
**** **** ****     > runlib.asm
0128               
0132               
0136               
0138                       copy  "vdp_f18a_support.asm"     ; VDP F18a low-level functions
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
0013 6392 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 6394 06A0  32         bl    @putvr                ; Write once
     6396 614E 
0015 6398 391C             data  >391c                 ; VR1/57, value 00011100
0016 639A 06A0  32         bl    @putvr                ; Write twice
     639C 614E 
0017 639E 391C             data  >391c                 ; VR1/57, value 00011100
0018 63A0 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********@*****@*********************@**************************
0026 63A2 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 63A4 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     63A6 614E 
0028 63A8 391C             data  >391c
0029 63AA 0458  20         b     *tmp4                 ; Exit
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
0040 63AC C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 63AE 06A0  32         bl    @cpym2v
     63B0 6254 
0042 63B2 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     63B4 63F0 
     63B6 0006 
0043 63B8 06A0  32         bl    @putvr
     63BA 614E 
0044 63BC 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 63BE 06A0  32         bl    @putvr
     63C0 614E 
0046 63C2 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 63C4 0204  20         li    tmp0,>3f00
     63C6 3F00 
0052 63C8 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     63CA 60E6 
0053 63CC D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     63CE 8800 
0054 63D0 0984  56         srl   tmp0,8
0055 63D2 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     63D4 8800 
0056 63D6 C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 63D8 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 63DA 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     63DC BFFF 
0060 63DE 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 63E0 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     63E2 4000 
0063               f18chk_exit:
0064 63E4 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     63E6 60BA 
0065 63E8 3F00             data  >3f00,>00,6
     63EA 0000 
     63EC 0006 
0066 63EE 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********@*****@*********************@**************************
0070               f18chk_gpu
0071 63F0 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 63F2 3F00             data  >3f00                 ; 3f02 / 3f00
0073 63F4 0340             data  >0340                 ; 3f04   0340  idle
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
0092 63F6 C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0093                       ;------------------------------------------------------
0094                       ; Reset all F18a VDP registers to power-on defaults
0095                       ;------------------------------------------------------
0096 63F8 06A0  32         bl    @putvr
     63FA 614E 
0097 63FC 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0098               
0099 63FE 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     6400 614E 
0100 6402 391C             data  >391c                 ; Lock the F18a
0101 6404 0458  20         b     *tmp4                 ; Exit
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
0120 6406 C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0121 6408 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     640A 6028 
0122 640C 1609  14         jne   f18fw1
0123               ***************************************************************
0124               * Read F18A major/minor version
0125               ***************************************************************
0126 640E C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     6410 8802 
0127 6412 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     6414 614E 
0128 6416 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0129 6418 04C4  14         clr   tmp0
0130 641A D120  34         movb  @vdps,tmp0
     641C 8802 
0131 641E 0984  56         srl   tmp0,8
0132 6420 0458  20 f18fw1  b     *tmp4                 ; Exit
**** **** ****     > runlib.asm
0140               
0144               
0148               
0152               
0156               
0160               
0164               
0168               
0172               
0174                       copy  "keyb_real.asm"            ; Real Keyboard support
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
0016 6422 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     6424 6026 
0017 6426 020C  20         li    r12,>0024
     6428 0024 
0018 642A 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     642C 64BA 
0019 642E 04C6  14         clr   tmp2
0020 6430 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 6432 04CC  14         clr   r12
0025 6434 1F08  20         tb    >0008                 ; Shift-key ?
0026 6436 1302  14         jeq   realk1                ; No
0027 6438 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     643A 64EA 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 643C 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 643E 1302  14         jeq   realk2                ; No
0033 6440 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     6442 651A 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 6444 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 6446 1302  14         jeq   realk3                ; No
0039 6448 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     644A 654A 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 644C 1E15  20 realk3  sbz   >0015                 ; Set P5
0044 644E 1F07  20         tb    >0007                 ; ALPHA-Lock key ?
0045 6450 1302  14         jeq   realk4                ; No,  CONFIG register bit 0 = 0
0046 6452 E0A0  34         soc   @wbit0,config         ; Yes, CONFIG register bit 0 = 1
     6454 6026 
0047               *--------------------------------------------------------------
0048               * Scan keyboard column
0049               *--------------------------------------------------------------
0050 6456 1D15  20 realk4  sbo   >0015                 ; Reset P5
0051 6458 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     645A 0006 
0052 645C 0606  14 realk5  dec   tmp2
0053 645E 020C  20         li    r12,>24               ; CRU address for P2-P4
     6460 0024 
0054 6462 06C6  14         swpb  tmp2
0055 6464 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0056 6466 06C6  14         swpb  tmp2
0057 6468 020C  20         li    r12,6                 ; CRU read address
     646A 0006 
0058 646C 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0059 646E 0547  14         inv   tmp3                  ;
0060 6470 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     6472 FF00 
0061               *--------------------------------------------------------------
0062               * Scan keyboard row
0063               *--------------------------------------------------------------
0064 6474 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0065 6476 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombinations scanned by shifting left.
0066 6478 1807  14         joc   realk8                ; If no carry after 8 loops, then it means no key
0067 647A 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0068 647C 0285  22         ci    tmp1,8
     647E 0008 
0069 6480 1AFA  14         jl    realk6
0070 6482 C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0071 6484 1BEB  14         jh    realk5                ; No, next column
0072 6486 1016  14         jmp   realkz                ; Yes, exit
0073               *--------------------------------------------------------------
0074               * Check for match in data table
0075               *--------------------------------------------------------------
0076 6488 C206  18 realk8  mov   tmp2,tmp4
0077 648A 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0078 648C A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0079 648E A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base address of data table (R15)
0080 6490 D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0081 6492 13F3  14         jeq   realk7                ; Yes, then discard and continue scanning (FCTN, SHIFT, CTRL)
0082               *--------------------------------------------------------------
0083               * Determine ASCII value of key
0084               *--------------------------------------------------------------
0085 6494 D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0086 6496 20A0  38         coc   @wbit0,config         ; ALPHA-Lock key pressed ?
     6498 6026 
0087 649A 1608  14         jne   realka                ; No, continue saving key
0088 649C 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     649E 64E4 
0089 64A0 1A05  14         jl    realka
0090 64A2 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     64A4 64E2 
0091 64A6 1B02  14         jh    realka                ; No, continue
0092 64A8 0226  22         ai    tmp2,->2000           ; ASCII = ASCII - 32 (lowercase to uppercase!)
     64AA E000 
0093 64AC C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     64AE 833C 
0094 64B0 E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     64B2 603C 
0095 64B4 020F  20 realkz  li    r15,vdpw              ; Setup VDP write address again after using R15 as temp storage
     64B6 8C00 
0096 64B8 045B  20         b     *r11                  ; Exit
0097               ********@*****@*********************@**************************
0098 64BA FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     64BC 0000 
     64BE FF0D 
     64C0 203D 
0099 64C2 ....             text  'xws29ol.'
0100 64CA ....             text  'ced38ik,'
0101 64D2 ....             text  'vrf47ujm'
0102 64DA ....             text  'btg56yhn'
0103 64E2 ....             text  'zqa10p;/'
0104 64EA FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     64EC 0000 
     64EE FF0D 
     64F0 202B 
0105 64F2 ....             text  'XWS@(OL>'
0106 64FA ....             text  'CED#*IK<'
0107 6502 ....             text  'VRF$&UJM'
0108 650A ....             text  'BTG%^YHN'
0109 6512 ....             text  'ZQA!)P:-'
0110 651A FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     651C 0000 
     651E FF0D 
     6520 2005 
0111 6522 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     6524 0804 
     6526 0F27 
     6528 C2B9 
0112 652A 600B             data  >600b,>0907,>063f,>c1B8
     652C 0907 
     652E 063F 
     6530 C1B8 
0113 6532 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     6534 7B02 
     6536 015F 
     6538 C0C3 
0114 653A BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     653C 7D0E 
     653E 0CC6 
     6540 BFC4 
0115 6542 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     6544 7C03 
     6546 BC22 
     6548 BDBA 
0116 654A FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     654C 0000 
     654E FF0D 
     6550 209D 
0117 6552 9897             data  >9897,>93b2,>9f8f,>8c9B
     6554 93B2 
     6556 9F8F 
     6558 8C9B 
0118 655A 8385             data  >8385,>84b3,>9e89,>8b80
     655C 84B3 
     655E 9E89 
     6560 8B80 
0119 6562 9692             data  >9692,>86b4,>b795,>8a8D
     6564 86B4 
     6566 B795 
     6568 8A8D 
0120 656A 8294             data  >8294,>87b5,>b698,>888E
     656C 87B5 
     656E B698 
     6570 888E 
0121 6572 9A91             data  >9a91,>81b1,>b090,>9cBB
     6574 81B1 
     6576 B090 
     6578 9CBB 
**** **** ****     > runlib.asm
0176               
0180               
0182                       copy  "cpu_numsupport.asm"       ; CPU unsigned numbers support
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
0019 657A 0207  20 mknum   li    tmp3,5                ; Digit counter
     657C 0005 
0020 657E C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 6580 C155  26         mov   *tmp1,tmp1            ; /
0022 6582 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 6584 0228  22         ai    tmp4,4                ; Get end of buffer
     6586 0004 
0024 6588 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     658A 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 658C 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 658E 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 6590 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 6592 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 6594 D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 6596 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for the next digit
0034 6598 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 659A 0607  14         dec   tmp3                  ; Decrease counter
0036 659C 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 659E 0207  20         li    tmp3,4                ; Check first 4 digits
     65A0 0004 
0041 65A2 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 65A4 C11B  26         mov   *r11,tmp0
0043 65A6 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 65A8 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 65AA 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 65AC 05CB  14 mknum3  inct  r11
0047 65AE 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     65B0 6026 
0048 65B2 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 65B4 045B  20         b     *r11                  ; Exit
0050 65B6 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 65B8 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 65BA 13F8  14         jeq   mknum3                ; Yes, exit
0053 65BC 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 65BE 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     65C0 7FFF 
0058 65C2 C10B  18         mov   r11,tmp0
0059 65C4 0224  22         ai    tmp0,-4
     65C6 FFFC 
0060 65C8 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 65CA 0206  20         li    tmp2,>0500            ; String length = 5
     65CC 0500 
0062 65CE 0460  28         b     @xutstr               ; Display string
     65D0 623E 
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
0092 65D2 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0093 65D4 C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0094 65D6 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0095 65D8 06C6  14         swpb  tmp2                  ; LO <-> HI
0096 65DA 0207  20         li    tmp3,5                ; Set counter
     65DC 0005 
0097                       ;------------------------------------------------------
0098                       ; Scan for padding character from left to right
0099                       ;------------------------------------------------------:
0100               trimnum_scan:
0101 65DE 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0102 65E0 1604  14         jne   trimnum_setlen        ; No, exit loop
0103 65E2 0584  14         inc   tmp0                  ; Next character
0104 65E4 0607  14         dec   tmp3                  ; Last digit reached ?
0105 65E6 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0106 65E8 10FA  14         jmp   trimnum_scan
0107                       ;------------------------------------------------------
0108                       ; Scan completed, set length byte new string
0109                       ;------------------------------------------------------
0110               trimnum_setlen:
0111 65EA 06C7  14         swpb  tmp3                  ; LO <-> HI
0112 65EC DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0113 65EE 06C7  14         swpb  tmp3                  ; LO <-> HI
0114                       ;------------------------------------------------------
0115                       ; Start filling new string
0116                       ;------------------------------------------------------
0117               trimnum_fill
0118 65F0 DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0119 65F2 0607  14         dec   tmp3                  ; Last character ?
0120 65F4 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0121 65F6 045B  20         b     *r11                  ; Return
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
0138 65F8 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     65FA 832A 
0139 65FC 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     65FE 8000 
0140 6600 10BC  14         jmp   mknum                 ; Convert number and display
**** **** ****     > runlib.asm
0184               
0188               
0192               
0194                       copy  "mem_scrpad_backrest.asm"  ; Scratchpad backup/restore
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
0021 6602 C820  54         mov   @>8300,@>2000
     6604 8300 
     6606 2000 
0022 6608 C820  54         mov   @>8302,@>2002
     660A 8302 
     660C 2002 
0023 660E C820  54         mov   @>8304,@>2004
     6610 8304 
     6612 2004 
0024 6614 C820  54         mov   @>8306,@>2006
     6616 8306 
     6618 2006 
0025 661A C820  54         mov   @>8308,@>2008
     661C 8308 
     661E 2008 
0026 6620 C820  54         mov   @>830A,@>200A
     6622 830A 
     6624 200A 
0027 6626 C820  54         mov   @>830C,@>200C
     6628 830C 
     662A 200C 
0028 662C C820  54         mov   @>830E,@>200E
     662E 830E 
     6630 200E 
0029 6632 C820  54         mov   @>8310,@>2010
     6634 8310 
     6636 2010 
0030 6638 C820  54         mov   @>8312,@>2012
     663A 8312 
     663C 2012 
0031 663E C820  54         mov   @>8314,@>2014
     6640 8314 
     6642 2014 
0032 6644 C820  54         mov   @>8316,@>2016
     6646 8316 
     6648 2016 
0033 664A C820  54         mov   @>8318,@>2018
     664C 8318 
     664E 2018 
0034 6650 C820  54         mov   @>831A,@>201A
     6652 831A 
     6654 201A 
0035 6656 C820  54         mov   @>831C,@>201C
     6658 831C 
     665A 201C 
0036 665C C820  54         mov   @>831E,@>201E
     665E 831E 
     6660 201E 
0037 6662 C820  54         mov   @>8320,@>2020
     6664 8320 
     6666 2020 
0038 6668 C820  54         mov   @>8322,@>2022
     666A 8322 
     666C 2022 
0039 666E C820  54         mov   @>8324,@>2024
     6670 8324 
     6672 2024 
0040 6674 C820  54         mov   @>8326,@>2026
     6676 8326 
     6678 2026 
0041 667A C820  54         mov   @>8328,@>2028
     667C 8328 
     667E 2028 
0042 6680 C820  54         mov   @>832A,@>202A
     6682 832A 
     6684 202A 
0043 6686 C820  54         mov   @>832C,@>202C
     6688 832C 
     668A 202C 
0044 668C C820  54         mov   @>832E,@>202E
     668E 832E 
     6690 202E 
0045 6692 C820  54         mov   @>8330,@>2030
     6694 8330 
     6696 2030 
0046 6698 C820  54         mov   @>8332,@>2032
     669A 8332 
     669C 2032 
0047 669E C820  54         mov   @>8334,@>2034
     66A0 8334 
     66A2 2034 
0048 66A4 C820  54         mov   @>8336,@>2036
     66A6 8336 
     66A8 2036 
0049 66AA C820  54         mov   @>8338,@>2038
     66AC 8338 
     66AE 2038 
0050 66B0 C820  54         mov   @>833A,@>203A
     66B2 833A 
     66B4 203A 
0051 66B6 C820  54         mov   @>833C,@>203C
     66B8 833C 
     66BA 203C 
0052 66BC C820  54         mov   @>833E,@>203E
     66BE 833E 
     66C0 203E 
0053 66C2 C820  54         mov   @>8340,@>2040
     66C4 8340 
     66C6 2040 
0054 66C8 C820  54         mov   @>8342,@>2042
     66CA 8342 
     66CC 2042 
0055 66CE C820  54         mov   @>8344,@>2044
     66D0 8344 
     66D2 2044 
0056 66D4 C820  54         mov   @>8346,@>2046
     66D6 8346 
     66D8 2046 
0057 66DA C820  54         mov   @>8348,@>2048
     66DC 8348 
     66DE 2048 
0058 66E0 C820  54         mov   @>834A,@>204A
     66E2 834A 
     66E4 204A 
0059 66E6 C820  54         mov   @>834C,@>204C
     66E8 834C 
     66EA 204C 
0060 66EC C820  54         mov   @>834E,@>204E
     66EE 834E 
     66F0 204E 
0061 66F2 C820  54         mov   @>8350,@>2050
     66F4 8350 
     66F6 2050 
0062 66F8 C820  54         mov   @>8352,@>2052
     66FA 8352 
     66FC 2052 
0063 66FE C820  54         mov   @>8354,@>2054
     6700 8354 
     6702 2054 
0064 6704 C820  54         mov   @>8356,@>2056
     6706 8356 
     6708 2056 
0065 670A C820  54         mov   @>8358,@>2058
     670C 8358 
     670E 2058 
0066 6710 C820  54         mov   @>835A,@>205A
     6712 835A 
     6714 205A 
0067 6716 C820  54         mov   @>835C,@>205C
     6718 835C 
     671A 205C 
0068 671C C820  54         mov   @>835E,@>205E
     671E 835E 
     6720 205E 
0069 6722 C820  54         mov   @>8360,@>2060
     6724 8360 
     6726 2060 
0070 6728 C820  54         mov   @>8362,@>2062
     672A 8362 
     672C 2062 
0071 672E C820  54         mov   @>8364,@>2064
     6730 8364 
     6732 2064 
0072 6734 C820  54         mov   @>8366,@>2066
     6736 8366 
     6738 2066 
0073 673A C820  54         mov   @>8368,@>2068
     673C 8368 
     673E 2068 
0074 6740 C820  54         mov   @>836A,@>206A
     6742 836A 
     6744 206A 
0075 6746 C820  54         mov   @>836C,@>206C
     6748 836C 
     674A 206C 
0076 674C C820  54         mov   @>836E,@>206E
     674E 836E 
     6750 206E 
0077 6752 C820  54         mov   @>8370,@>2070
     6754 8370 
     6756 2070 
0078 6758 C820  54         mov   @>8372,@>2072
     675A 8372 
     675C 2072 
0079 675E C820  54         mov   @>8374,@>2074
     6760 8374 
     6762 2074 
0080 6764 C820  54         mov   @>8376,@>2076
     6766 8376 
     6768 2076 
0081 676A C820  54         mov   @>8378,@>2078
     676C 8378 
     676E 2078 
0082 6770 C820  54         mov   @>837A,@>207A
     6772 837A 
     6774 207A 
0083 6776 C820  54         mov   @>837C,@>207C
     6778 837C 
     677A 207C 
0084 677C C820  54         mov   @>837E,@>207E
     677E 837E 
     6780 207E 
0085 6782 C820  54         mov   @>8380,@>2080
     6784 8380 
     6786 2080 
0086 6788 C820  54         mov   @>8382,@>2082
     678A 8382 
     678C 2082 
0087 678E C820  54         mov   @>8384,@>2084
     6790 8384 
     6792 2084 
0088 6794 C820  54         mov   @>8386,@>2086
     6796 8386 
     6798 2086 
0089 679A C820  54         mov   @>8388,@>2088
     679C 8388 
     679E 2088 
0090 67A0 C820  54         mov   @>838A,@>208A
     67A2 838A 
     67A4 208A 
0091 67A6 C820  54         mov   @>838C,@>208C
     67A8 838C 
     67AA 208C 
0092 67AC C820  54         mov   @>838E,@>208E
     67AE 838E 
     67B0 208E 
0093 67B2 C820  54         mov   @>8390,@>2090
     67B4 8390 
     67B6 2090 
0094 67B8 C820  54         mov   @>8392,@>2092
     67BA 8392 
     67BC 2092 
0095 67BE C820  54         mov   @>8394,@>2094
     67C0 8394 
     67C2 2094 
0096 67C4 C820  54         mov   @>8396,@>2096
     67C6 8396 
     67C8 2096 
0097 67CA C820  54         mov   @>8398,@>2098
     67CC 8398 
     67CE 2098 
0098 67D0 C820  54         mov   @>839A,@>209A
     67D2 839A 
     67D4 209A 
0099 67D6 C820  54         mov   @>839C,@>209C
     67D8 839C 
     67DA 209C 
0100 67DC C820  54         mov   @>839E,@>209E
     67DE 839E 
     67E0 209E 
0101 67E2 C820  54         mov   @>83A0,@>20A0
     67E4 83A0 
     67E6 20A0 
0102 67E8 C820  54         mov   @>83A2,@>20A2
     67EA 83A2 
     67EC 20A2 
0103 67EE C820  54         mov   @>83A4,@>20A4
     67F0 83A4 
     67F2 20A4 
0104 67F4 C820  54         mov   @>83A6,@>20A6
     67F6 83A6 
     67F8 20A6 
0105 67FA C820  54         mov   @>83A8,@>20A8
     67FC 83A8 
     67FE 20A8 
0106 6800 C820  54         mov   @>83AA,@>20AA
     6802 83AA 
     6804 20AA 
0107 6806 C820  54         mov   @>83AC,@>20AC
     6808 83AC 
     680A 20AC 
0108 680C C820  54         mov   @>83AE,@>20AE
     680E 83AE 
     6810 20AE 
0109 6812 C820  54         mov   @>83B0,@>20B0
     6814 83B0 
     6816 20B0 
0110 6818 C820  54         mov   @>83B2,@>20B2
     681A 83B2 
     681C 20B2 
0111 681E C820  54         mov   @>83B4,@>20B4
     6820 83B4 
     6822 20B4 
0112 6824 C820  54         mov   @>83B6,@>20B6
     6826 83B6 
     6828 20B6 
0113 682A C820  54         mov   @>83B8,@>20B8
     682C 83B8 
     682E 20B8 
0114 6830 C820  54         mov   @>83BA,@>20BA
     6832 83BA 
     6834 20BA 
0115 6836 C820  54         mov   @>83BC,@>20BC
     6838 83BC 
     683A 20BC 
0116 683C C820  54         mov   @>83BE,@>20BE
     683E 83BE 
     6840 20BE 
0117 6842 C820  54         mov   @>83C0,@>20C0
     6844 83C0 
     6846 20C0 
0118 6848 C820  54         mov   @>83C2,@>20C2
     684A 83C2 
     684C 20C2 
0119 684E C820  54         mov   @>83C4,@>20C4
     6850 83C4 
     6852 20C4 
0120 6854 C820  54         mov   @>83C6,@>20C6
     6856 83C6 
     6858 20C6 
0121 685A C820  54         mov   @>83C8,@>20C8
     685C 83C8 
     685E 20C8 
0122 6860 C820  54         mov   @>83CA,@>20CA
     6862 83CA 
     6864 20CA 
0123 6866 C820  54         mov   @>83CC,@>20CC
     6868 83CC 
     686A 20CC 
0124 686C C820  54         mov   @>83CE,@>20CE
     686E 83CE 
     6870 20CE 
0125 6872 C820  54         mov   @>83D0,@>20D0
     6874 83D0 
     6876 20D0 
0126 6878 C820  54         mov   @>83D2,@>20D2
     687A 83D2 
     687C 20D2 
0127 687E C820  54         mov   @>83D4,@>20D4
     6880 83D4 
     6882 20D4 
0128 6884 C820  54         mov   @>83D6,@>20D6
     6886 83D6 
     6888 20D6 
0129 688A C820  54         mov   @>83D8,@>20D8
     688C 83D8 
     688E 20D8 
0130 6890 C820  54         mov   @>83DA,@>20DA
     6892 83DA 
     6894 20DA 
0131 6896 C820  54         mov   @>83DC,@>20DC
     6898 83DC 
     689A 20DC 
0132 689C C820  54         mov   @>83DE,@>20DE
     689E 83DE 
     68A0 20DE 
0133 68A2 C820  54         mov   @>83E0,@>20E0
     68A4 83E0 
     68A6 20E0 
0134 68A8 C820  54         mov   @>83E2,@>20E2
     68AA 83E2 
     68AC 20E2 
0135 68AE C820  54         mov   @>83E4,@>20E4
     68B0 83E4 
     68B2 20E4 
0136 68B4 C820  54         mov   @>83E6,@>20E6
     68B6 83E6 
     68B8 20E6 
0137 68BA C820  54         mov   @>83E8,@>20E8
     68BC 83E8 
     68BE 20E8 
0138 68C0 C820  54         mov   @>83EA,@>20EA
     68C2 83EA 
     68C4 20EA 
0139 68C6 C820  54         mov   @>83EC,@>20EC
     68C8 83EC 
     68CA 20EC 
0140 68CC C820  54         mov   @>83EE,@>20EE
     68CE 83EE 
     68D0 20EE 
0141 68D2 C820  54         mov   @>83F0,@>20F0
     68D4 83F0 
     68D6 20F0 
0142 68D8 C820  54         mov   @>83F2,@>20F2
     68DA 83F2 
     68DC 20F2 
0143 68DE C820  54         mov   @>83F4,@>20F4
     68E0 83F4 
     68E2 20F4 
0144 68E4 C820  54         mov   @>83F6,@>20F6
     68E6 83F6 
     68E8 20F6 
0145 68EA C820  54         mov   @>83F8,@>20F8
     68EC 83F8 
     68EE 20F8 
0146 68F0 C820  54         mov   @>83FA,@>20FA
     68F2 83FA 
     68F4 20FA 
0147 68F6 C820  54         mov   @>83FC,@>20FC
     68F8 83FC 
     68FA 20FC 
0148 68FC C820  54         mov   @>83FE,@>20FE
     68FE 83FE 
     6900 20FE 
0149 6902 045B  20         b     *r11                  ; Return to caller
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
0164 6904 C820  54         mov   @>2000,@>8300
     6906 2000 
     6908 8300 
0165 690A C820  54         mov   @>2002,@>8302
     690C 2002 
     690E 8302 
0166 6910 C820  54         mov   @>2004,@>8304
     6912 2004 
     6914 8304 
0167 6916 C820  54         mov   @>2006,@>8306
     6918 2006 
     691A 8306 
0168 691C C820  54         mov   @>2008,@>8308
     691E 2008 
     6920 8308 
0169 6922 C820  54         mov   @>200A,@>830A
     6924 200A 
     6926 830A 
0170 6928 C820  54         mov   @>200C,@>830C
     692A 200C 
     692C 830C 
0171 692E C820  54         mov   @>200E,@>830E
     6930 200E 
     6932 830E 
0172 6934 C820  54         mov   @>2010,@>8310
     6936 2010 
     6938 8310 
0173 693A C820  54         mov   @>2012,@>8312
     693C 2012 
     693E 8312 
0174 6940 C820  54         mov   @>2014,@>8314
     6942 2014 
     6944 8314 
0175 6946 C820  54         mov   @>2016,@>8316
     6948 2016 
     694A 8316 
0176 694C C820  54         mov   @>2018,@>8318
     694E 2018 
     6950 8318 
0177 6952 C820  54         mov   @>201A,@>831A
     6954 201A 
     6956 831A 
0178 6958 C820  54         mov   @>201C,@>831C
     695A 201C 
     695C 831C 
0179 695E C820  54         mov   @>201E,@>831E
     6960 201E 
     6962 831E 
0180 6964 C820  54         mov   @>2020,@>8320
     6966 2020 
     6968 8320 
0181 696A C820  54         mov   @>2022,@>8322
     696C 2022 
     696E 8322 
0182 6970 C820  54         mov   @>2024,@>8324
     6972 2024 
     6974 8324 
0183 6976 C820  54         mov   @>2026,@>8326
     6978 2026 
     697A 8326 
0184 697C C820  54         mov   @>2028,@>8328
     697E 2028 
     6980 8328 
0185 6982 C820  54         mov   @>202A,@>832A
     6984 202A 
     6986 832A 
0186 6988 C820  54         mov   @>202C,@>832C
     698A 202C 
     698C 832C 
0187 698E C820  54         mov   @>202E,@>832E
     6990 202E 
     6992 832E 
0188 6994 C820  54         mov   @>2030,@>8330
     6996 2030 
     6998 8330 
0189 699A C820  54         mov   @>2032,@>8332
     699C 2032 
     699E 8332 
0190 69A0 C820  54         mov   @>2034,@>8334
     69A2 2034 
     69A4 8334 
0191 69A6 C820  54         mov   @>2036,@>8336
     69A8 2036 
     69AA 8336 
0192 69AC C820  54         mov   @>2038,@>8338
     69AE 2038 
     69B0 8338 
0193 69B2 C820  54         mov   @>203A,@>833A
     69B4 203A 
     69B6 833A 
0194 69B8 C820  54         mov   @>203C,@>833C
     69BA 203C 
     69BC 833C 
0195 69BE C820  54         mov   @>203E,@>833E
     69C0 203E 
     69C2 833E 
0196 69C4 C820  54         mov   @>2040,@>8340
     69C6 2040 
     69C8 8340 
0197 69CA C820  54         mov   @>2042,@>8342
     69CC 2042 
     69CE 8342 
0198 69D0 C820  54         mov   @>2044,@>8344
     69D2 2044 
     69D4 8344 
0199 69D6 C820  54         mov   @>2046,@>8346
     69D8 2046 
     69DA 8346 
0200 69DC C820  54         mov   @>2048,@>8348
     69DE 2048 
     69E0 8348 
0201 69E2 C820  54         mov   @>204A,@>834A
     69E4 204A 
     69E6 834A 
0202 69E8 C820  54         mov   @>204C,@>834C
     69EA 204C 
     69EC 834C 
0203 69EE C820  54         mov   @>204E,@>834E
     69F0 204E 
     69F2 834E 
0204 69F4 C820  54         mov   @>2050,@>8350
     69F6 2050 
     69F8 8350 
0205 69FA C820  54         mov   @>2052,@>8352
     69FC 2052 
     69FE 8352 
0206 6A00 C820  54         mov   @>2054,@>8354
     6A02 2054 
     6A04 8354 
0207 6A06 C820  54         mov   @>2056,@>8356
     6A08 2056 
     6A0A 8356 
0208 6A0C C820  54         mov   @>2058,@>8358
     6A0E 2058 
     6A10 8358 
0209 6A12 C820  54         mov   @>205A,@>835A
     6A14 205A 
     6A16 835A 
0210 6A18 C820  54         mov   @>205C,@>835C
     6A1A 205C 
     6A1C 835C 
0211 6A1E C820  54         mov   @>205E,@>835E
     6A20 205E 
     6A22 835E 
0212 6A24 C820  54         mov   @>2060,@>8360
     6A26 2060 
     6A28 8360 
0213 6A2A C820  54         mov   @>2062,@>8362
     6A2C 2062 
     6A2E 8362 
0214 6A30 C820  54         mov   @>2064,@>8364
     6A32 2064 
     6A34 8364 
0215 6A36 C820  54         mov   @>2066,@>8366
     6A38 2066 
     6A3A 8366 
0216 6A3C C820  54         mov   @>2068,@>8368
     6A3E 2068 
     6A40 8368 
0217 6A42 C820  54         mov   @>206A,@>836A
     6A44 206A 
     6A46 836A 
0218 6A48 C820  54         mov   @>206C,@>836C
     6A4A 206C 
     6A4C 836C 
0219 6A4E C820  54         mov   @>206E,@>836E
     6A50 206E 
     6A52 836E 
0220 6A54 C820  54         mov   @>2070,@>8370
     6A56 2070 
     6A58 8370 
0221 6A5A C820  54         mov   @>2072,@>8372
     6A5C 2072 
     6A5E 8372 
0222 6A60 C820  54         mov   @>2074,@>8374
     6A62 2074 
     6A64 8374 
0223 6A66 C820  54         mov   @>2076,@>8376
     6A68 2076 
     6A6A 8376 
0224 6A6C C820  54         mov   @>2078,@>8378
     6A6E 2078 
     6A70 8378 
0225 6A72 C820  54         mov   @>207A,@>837A
     6A74 207A 
     6A76 837A 
0226 6A78 C820  54         mov   @>207C,@>837C
     6A7A 207C 
     6A7C 837C 
0227 6A7E C820  54         mov   @>207E,@>837E
     6A80 207E 
     6A82 837E 
0228 6A84 C820  54         mov   @>2080,@>8380
     6A86 2080 
     6A88 8380 
0229 6A8A C820  54         mov   @>2082,@>8382
     6A8C 2082 
     6A8E 8382 
0230 6A90 C820  54         mov   @>2084,@>8384
     6A92 2084 
     6A94 8384 
0231 6A96 C820  54         mov   @>2086,@>8386
     6A98 2086 
     6A9A 8386 
0232 6A9C C820  54         mov   @>2088,@>8388
     6A9E 2088 
     6AA0 8388 
0233 6AA2 C820  54         mov   @>208A,@>838A
     6AA4 208A 
     6AA6 838A 
0234 6AA8 C820  54         mov   @>208C,@>838C
     6AAA 208C 
     6AAC 838C 
0235 6AAE C820  54         mov   @>208E,@>838E
     6AB0 208E 
     6AB2 838E 
0236 6AB4 C820  54         mov   @>2090,@>8390
     6AB6 2090 
     6AB8 8390 
0237 6ABA C820  54         mov   @>2092,@>8392
     6ABC 2092 
     6ABE 8392 
0238 6AC0 C820  54         mov   @>2094,@>8394
     6AC2 2094 
     6AC4 8394 
0239 6AC6 C820  54         mov   @>2096,@>8396
     6AC8 2096 
     6ACA 8396 
0240 6ACC C820  54         mov   @>2098,@>8398
     6ACE 2098 
     6AD0 8398 
0241 6AD2 C820  54         mov   @>209A,@>839A
     6AD4 209A 
     6AD6 839A 
0242 6AD8 C820  54         mov   @>209C,@>839C
     6ADA 209C 
     6ADC 839C 
0243 6ADE C820  54         mov   @>209E,@>839E
     6AE0 209E 
     6AE2 839E 
0244 6AE4 C820  54         mov   @>20A0,@>83A0
     6AE6 20A0 
     6AE8 83A0 
0245 6AEA C820  54         mov   @>20A2,@>83A2
     6AEC 20A2 
     6AEE 83A2 
0246 6AF0 C820  54         mov   @>20A4,@>83A4
     6AF2 20A4 
     6AF4 83A4 
0247 6AF6 C820  54         mov   @>20A6,@>83A6
     6AF8 20A6 
     6AFA 83A6 
0248 6AFC C820  54         mov   @>20A8,@>83A8
     6AFE 20A8 
     6B00 83A8 
0249 6B02 C820  54         mov   @>20AA,@>83AA
     6B04 20AA 
     6B06 83AA 
0250 6B08 C820  54         mov   @>20AC,@>83AC
     6B0A 20AC 
     6B0C 83AC 
0251 6B0E C820  54         mov   @>20AE,@>83AE
     6B10 20AE 
     6B12 83AE 
0252 6B14 C820  54         mov   @>20B0,@>83B0
     6B16 20B0 
     6B18 83B0 
0253 6B1A C820  54         mov   @>20B2,@>83B2
     6B1C 20B2 
     6B1E 83B2 
0254 6B20 C820  54         mov   @>20B4,@>83B4
     6B22 20B4 
     6B24 83B4 
0255 6B26 C820  54         mov   @>20B6,@>83B6
     6B28 20B6 
     6B2A 83B6 
0256 6B2C C820  54         mov   @>20B8,@>83B8
     6B2E 20B8 
     6B30 83B8 
0257 6B32 C820  54         mov   @>20BA,@>83BA
     6B34 20BA 
     6B36 83BA 
0258 6B38 C820  54         mov   @>20BC,@>83BC
     6B3A 20BC 
     6B3C 83BC 
0259 6B3E C820  54         mov   @>20BE,@>83BE
     6B40 20BE 
     6B42 83BE 
0260 6B44 C820  54         mov   @>20C0,@>83C0
     6B46 20C0 
     6B48 83C0 
0261 6B4A C820  54         mov   @>20C2,@>83C2
     6B4C 20C2 
     6B4E 83C2 
0262 6B50 C820  54         mov   @>20C4,@>83C4
     6B52 20C4 
     6B54 83C4 
0263 6B56 C820  54         mov   @>20C6,@>83C6
     6B58 20C6 
     6B5A 83C6 
0264 6B5C C820  54         mov   @>20C8,@>83C8
     6B5E 20C8 
     6B60 83C8 
0265 6B62 C820  54         mov   @>20CA,@>83CA
     6B64 20CA 
     6B66 83CA 
0266 6B68 C820  54         mov   @>20CC,@>83CC
     6B6A 20CC 
     6B6C 83CC 
0267 6B6E C820  54         mov   @>20CE,@>83CE
     6B70 20CE 
     6B72 83CE 
0268 6B74 C820  54         mov   @>20D0,@>83D0
     6B76 20D0 
     6B78 83D0 
0269 6B7A C820  54         mov   @>20D2,@>83D2
     6B7C 20D2 
     6B7E 83D2 
0270 6B80 C820  54         mov   @>20D4,@>83D4
     6B82 20D4 
     6B84 83D4 
0271 6B86 C820  54         mov   @>20D6,@>83D6
     6B88 20D6 
     6B8A 83D6 
0272 6B8C C820  54         mov   @>20D8,@>83D8
     6B8E 20D8 
     6B90 83D8 
0273 6B92 C820  54         mov   @>20DA,@>83DA
     6B94 20DA 
     6B96 83DA 
0274 6B98 C820  54         mov   @>20DC,@>83DC
     6B9A 20DC 
     6B9C 83DC 
0275 6B9E C820  54         mov   @>20DE,@>83DE
     6BA0 20DE 
     6BA2 83DE 
0276 6BA4 C820  54         mov   @>20E0,@>83E0
     6BA6 20E0 
     6BA8 83E0 
0277 6BAA C820  54         mov   @>20E2,@>83E2
     6BAC 20E2 
     6BAE 83E2 
0278 6BB0 C820  54         mov   @>20E4,@>83E4
     6BB2 20E4 
     6BB4 83E4 
0279 6BB6 C820  54         mov   @>20E6,@>83E6
     6BB8 20E6 
     6BBA 83E6 
0280 6BBC C820  54         mov   @>20E8,@>83E8
     6BBE 20E8 
     6BC0 83E8 
0281 6BC2 C820  54         mov   @>20EA,@>83EA
     6BC4 20EA 
     6BC6 83EA 
0282 6BC8 C820  54         mov   @>20EC,@>83EC
     6BCA 20EC 
     6BCC 83EC 
0283 6BCE C820  54         mov   @>20EE,@>83EE
     6BD0 20EE 
     6BD2 83EE 
0284 6BD4 C820  54         mov   @>20F0,@>83F0
     6BD6 20F0 
     6BD8 83F0 
0285 6BDA C820  54         mov   @>20F2,@>83F2
     6BDC 20F2 
     6BDE 83F2 
0286 6BE0 C820  54         mov   @>20F4,@>83F4
     6BE2 20F4 
     6BE4 83F4 
0287 6BE6 C820  54         mov   @>20F6,@>83F6
     6BE8 20F6 
     6BEA 83F6 
0288 6BEC C820  54         mov   @>20F8,@>83F8
     6BEE 20F8 
     6BF0 83F8 
0289 6BF2 C820  54         mov   @>20FA,@>83FA
     6BF4 20FA 
     6BF6 83FA 
0290 6BF8 C820  54         mov   @>20FC,@>83FC
     6BFA 20FC 
     6BFC 83FC 
0291 6BFE C820  54         mov   @>20FE,@>83FE
     6C00 20FE 
     6C02 83FE 
0292 6C04 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0195                       copy  "mem_scrpad_paging.asm"    ; Scratchpad memory paging
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
0024 6C06 C17B  30         mov   *r11+,tmp1            ; tmp1 = Memory target address
0025                       ;------------------------------------------------------
0026                       ; Copy scratchpad memory to destination
0027                       ;------------------------------------------------------
0028               xmem.scrpad.pgout:
0029 6C08 0204  20         li    tmp0,>8300            ; tmp0 = Memory source address
     6C0A 8300 
0030 6C0C C1C5  18         mov   tmp1,tmp3             ; tmp3 = copy of tmp1
0031 6C0E 0206  20         li    tmp2,128              ; tmp2 = Bytes to copy
     6C10 0080 
0032                       ;------------------------------------------------------
0033                       ; Copy memory
0034                       ;------------------------------------------------------
0035 6C12 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0036 6C14 0606  14         dec   tmp2
0037 6C16 16FD  14         jne   -!                    ; Loop until done
0038                       ;------------------------------------------------------
0039                       ; Switch to new workspace
0040                       ;------------------------------------------------------
0041 6C18 C347  18         mov   tmp3,r13              ; R13=WP   (pop tmp1 from stack)
0042 6C1A 020E  20         li    r14,mem.scrpad.pgout.after.rtwp
     6C1C 6C22 
0043                                                   ; R14=PC
0044 6C1E 04CF  14         clr   r15                   ; R15=STATUS
0045                       ;------------------------------------------------------
0046                       ; If we get here, WS was copied to specified
0047                       ; destination.  Also contents of r13,r14,r15
0048                       ; are about to be overwritten by rtwp instruction.
0049                       ;------------------------------------------------------
0050 6C20 0380  18         rtwp                        ; Activate copied workspace
0051                                                   ; in non-scratchpad memory!
0052               
0053               mem.scrpad.pgout.after.rtwp:
0054 6C22 0460  28         b     @mem.scrpad.restore   ; Restore scratchpad memory from @>2000
     6C24 6904 
0055               
0056                       ;------------------------------------------------------
0057                       ; Exit
0058                       ;------------------------------------------------------
0059               mem.scrpad.pgout.$$:
0060 6C26 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0197               
0199                       copy  "dsrlnk.asm"               ; DSRLNK for peripheral communication
**** **** ****     > dsrlnk.asm
0001               * FILE......: dsrlnk.asm
0002               * Purpose...: Custom DSRLNK implementation
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                          DSRLNK
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * >8300 - >83ff       Equates for DSRLNK (alternative layout)
0010               ***************************************************************
0011               * Equates are used in DSRLNK.
0012               * Scratchpad memory needs to be paged out before use of DSRLNK.
0013               ********@*****@*********************@**************************
0014      8320     haa     equ   >8320                 ; Loaded with HI-byte value >aa
0015      8322     sav8a   equ   >8322                 ; Contains >08 or >0a
0016               
0017               
0018               
0019               **** Low memory expansion. Official documentation?
0020      2100     namsto  equ   >2100                 ; 8-byte buffer for device name
0021      B000     dsrlws  equ   >b000                 ; dsrlnk workspace
0022      B00A     dstype  equ   >b00a                 ; dstype is address of R5 of DSRLNK ws
0023               
0024               
0025               
0026               ***************************************************************
0027               * dsrlnk - DSRLNK for file I/O in DSR >1000 - >1F00
0028               ***************************************************************
0029               *  blwp @dsrlnk
0030               *  data p0
0031               *--------------------------------------------------------------
0032               *  P0 = 8 or 10 (a)
0033               *--------------------------------------------------------------
0034               ; dsrlnk routine
0035               ;
0036               ; Scratchpad memory used in DSRLNK
0037               ;
0038               ; >8356            Pointer to PAB
0039               ; >83D0            CRU address of current device
0040               ; >83D2            DSR entry address
0041               ; >83e0 - >83ff    GPL/DSRLNK workspace
0042               ;
0043               ; Credits
0044               ; Originally appeared in Miller Graphics The Smart Programmer.
0045               ; Enhanced by Paolo Bagnaresi.
0046               *--------------------------------------------------------------
0047 6C28 B000     dsrlnk  data  dsrlws               ; dsrlnk workspace
0048 6C2A 6C2C             data  dsrlnk.init          ; entry point
0049                       ;------------------------------------------------------
0050                       ; DSRLNK entry point
0051                       ;------------------------------------------------------
0052               dsrlnk.init:
0053 6C2C 0200  20         li    r0,>aa00
     6C2E AA00 
0054 6C30 D800  38         movb  r0,@haa              ; load haa at @>8320
     6C32 8320 
0055 6C34 C17E  30         mov   *r14+,r5             ; get pgm type for link
0056 6C36 C805  38         mov   r5,@sav8a            ; save data following blwp @dsrlnk (8 or >a)
     6C38 8322 
0057 6C3A 53E0  34         szcb  @h20,r15             ; reset equal bit
     6C3C 6D44 
0058 6C3E C020  34         mov   @>8356,r0            ; get ptr to pab
     6C40 8356 
0059 6C42 C240  18         mov   r0,r9                ; save ptr
0060                       ;------------------------------------------------------
0061                       ; Fetch file descriptor length from PAB
0062                       ;------------------------------------------------------
0063 6C44 0229  22         ai    r9,>fff8             ; adjust r9 to addr PAB flag -> (pabaddr+9)-8
     6C46 FFF8 
0064               
0065                       ;--------------------------; Inline VSBR start
0066 6C48 06C0  14         swpb  r0                   ;
0067 6C4A D800  38         movb  r0,@vdpa             ; send low byte
     6C4C 8C02 
0068 6C4E 06C0  14         swpb  r0                   ;
0069 6C50 D800  38         movb  r0,@vdpa             ; send high byte
     6C52 8C02 
0070 6C54 D0E0  34         movb  @vdpr,r3             ; read byte from VDP ram
     6C56 8800 
0071                       ;--------------------------; Inline VSBR end
0072 6C58 0983  56         srl   r3,8                 ; Move to low byte
0073                       ;------------------------------------------------------
0074                       ; Fetch file descriptor device name from PAB
0075                       ;------------------------------------------------------
0076 6C5A 0704  14         seto  r4                   ; init counter
0077 6C5C 0202  20         li    r2,namsto            ; point to 8-byte buffer
     6C5E 2100 
0078 6C60 0580  14 !       inc   r0                   ; point to next char of name
0079 6C62 0584  14         inc   r4                   ; incr char counter
0080 6C64 0284  22         ci    r4,>0007             ; see if length more than 7 chars
     6C66 0007 
0081 6C68 1565  14         jgt   dsrlnk.error.devicename_invalid
0082                                                  ; yes, error
0083 6C6A 80C4  18         c     r4,r3                ; end of name?
0084 6C6C 130C  14         jeq   dsrlnk.device_name.get_length
0085                                                  ; yes
0086               
0087                       ;--------------------------; Inline VSBR start
0088 6C6E 06C0  14         swpb  r0                   ;
0089 6C70 D800  38         movb  r0,@vdpa             ; send low byte
     6C72 8C02 
0090 6C74 06C0  14         swpb  r0                   ;
0091 6C76 D800  38         movb  r0,@vdpa             ; send high byte
     6C78 8C02 
0092 6C7A D060  34         movb  @vdpr,r1             ; read byte from VDP ram
     6C7C 8800 
0093                       ;--------------------------; Inline VSBR end
0094               
0095 6C7E DC81  32         movb  r1,*r2+              ; move into buffer
0096 6C80 9801  38         cb    r1,@decmal           ; is it a '.' period?
     6C82 6D42 
0097 6C84 16ED  14         jne   -!                   ; no, loop next char
0098                       ;------------------------------------------------------
0099                       ; Determine device name length
0100                       ;------------------------------------------------------
0101               dsrlnk.device_name.get_length:
0102 6C86 C104  18         mov   r4,r4                ; Check if length = 0
0103 6C88 1355  14         jeq   dsrlnk.error.devicename_invalid
0104                                                  ; yes, error
0105 6C8A 04E0  34         clr   @>83d0
     6C8C 83D0 
0106 6C8E C804  38         mov   r4,@>8354            ; save name length for search
     6C90 8354 
0107 6C92 0584  14         inc   r4                   ; adjust for dot
0108 6C94 A804  38         a     r4,@>8356            ; point to position after name
     6C96 8356 
0109                       ;------------------------------------------------------
0110                       ; Prepare for DSR scan >1000 - >1f00
0111                       ;------------------------------------------------------
0112               dsrlnk.dsrscan.start:
0113 6C98 02E0  18         lwpi  >83e0                ; use gplws
     6C9A 83E0 
0114 6C9C 04C1  14         clr   r1                   ; version found of dsr
0115 6C9E 020C  20         li    r12,>0f00            ; init cru addr
     6CA0 0F00 
0116                       ;------------------------------------------------------
0117                       ; Turn off ROM on current card
0118                       ;------------------------------------------------------
0119               dsrlnk.dsrscan.cardoff:
0120 6CA2 C30C  18         mov   r12,r12              ; anything to turn off?
0121 6CA4 1301  14         jeq   dsrlnk.dsrscan.cardloop
0122                                                  ; no, loop over cards
0123 6CA6 1E00  20         sbz   0                    ; yes, turn off
0124                       ;------------------------------------------------------
0125                       ; Loop over cards and look if DSR present
0126                       ;------------------------------------------------------
0127               dsrlnk.dsrscan.cardloop:
0128 6CA8 022C  22         ai    r12,>0100            ; next rom to turn on
     6CAA 0100 
0129 6CAC 04E0  34         clr   @>83d0               ; clear in case we are done
     6CAE 83D0 
0130 6CB0 028C  22         ci    r12,>2000            ; Card scan complete? (>1000 to >1F00)
     6CB2 2000 
0131 6CB4 133D  14         jeq   dsrlnk.error.nodsr_found
0132                                                  ; yes, no matching DSR found
0133 6CB6 C80C  38         mov   r12,@>83d0           ; save addr of next cru
     6CB8 83D0 
0134                       ;------------------------------------------------------
0135                       ; Look at card ROM (@>4000 eq 'AA' ?)
0136                       ;------------------------------------------------------
0137 6CBA 1D00  20         sbo   0                    ; turn on rom
0138 6CBC 0202  20         li    r2,>4000             ; start at beginning of rom
     6CBE 4000 
0139 6CC0 9812  46         cb    *r2,@haa             ; check for a valid DSR header
     6CC2 8320 
0140 6CC4 16EE  14         jne   dsrlnk.dsrscan.cardoff
0141                                                  ; no rom found on card
0142                       ;------------------------------------------------------
0143                       ; Valid DSR ROM found. Now loop over chain/subprograms
0144                       ;------------------------------------------------------
0145                       ; dstype is the address of R5 of the DSRLNK workspace,
0146                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0147                       ; is stored before the DSR ROM is searched.
0148                       ;------------------------------------------------------
0149 6CC6 A0A0  34         a     @dstype,r2           ; go to first pointer (byte 8 or 10)
     6CC8 B00A 
0150 6CCA 1003  14         jmp   dsrlnk.dsrscan.getentry
0151                       ;------------------------------------------------------
0152                       ; Next DSR entry
0153                       ;------------------------------------------------------
0154               dsrlnk.dsrscan.nextentry:
0155 6CCC C0A0  34         mov   @>83d2,r2            ; Offset 0 > Fetch link to next DSR or subprogram
     6CCE 83D2 
0156 6CD0 1D00  20         sbo   0                    ; turn rom back on
0157                       ;------------------------------------------------------
0158                       ; Get DSR entry
0159                       ;------------------------------------------------------
0160               dsrlnk.dsrscan.getentry:
0161 6CD2 C092  26         mov   *r2,r2               ; is addr a zero? (end of chain?)
0162 6CD4 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0163                                                  ; yes, no more DSRs or programs to check
0164 6CD6 C802  38         mov   r2,@>83d2            ; Offset 0 > Store link to next DSR or subprogram
     6CD8 83D2 
0165 6CDA 05C2  14         inct  r2                   ; Offset 2 > Has call address of current DSR/subprogram code
0166 6CDC C272  30         mov   *r2+,r9              ; Store call address in r9. Move r2 to offset 4 (DSR/subprogram name)
0167                       ;------------------------------------------------------
0168                       ; Check file descriptor in DSR
0169                       ;------------------------------------------------------
0170 6CDE 04C5  14         clr   r5                   ; Remove any old stuff
0171 6CE0 D160  34         movb  @>8355,r5            ; get length as counter
     6CE2 8355 
0172 6CE4 130B  14         jeq   dsrlnk.dsrscan.call_dsr
0173                                                  ; if zero, do not further check, call DSR program
0174 6CE6 9C85  32         cb    r5,*r2+              ; see if length matches
0175 6CE8 16F1  14         jne   dsrlnk.dsrscan.nextentry
0176                                                  ; no, length does not match. Go process next DSR entry
0177 6CEA 0985  56         srl   r5,8                 ; yes, move to low byte
0178 6CEC 0206  20         li    r6,namsto            ; Point to 8-byte CPU buffer
     6CEE 2100 
0179 6CF0 9CB6  42 !       cb    *r6+,*r2+            ; compare byte in CPU buffer with byte in DSR ROM
0180 6CF2 16EC  14         jne   dsrlnk.dsrscan.nextentry
0181                                                  ; try next DSR entry if no match
0182 6CF4 0605  14         dec   r5                   ; loop until full length checked
0183 6CF6 16FC  14         jne   -!
0184                       ;------------------------------------------------------
0185                       ; Device name/Subprogram match
0186                       ;------------------------------------------------------
0187               dsrlnk.dsrscan.match:
0188 6CF8 C802  38         mov   r2,@>83d2            ; DSR entry addr must be saved at @>83d2
     6CFA 83D2 
0189               
0190                       ;------------------------------------------------------
0191                       ; Call DSR program in device card
0192                       ;------------------------------------------------------
0193               dsrlnk.dsrscan.call_dsr:
0194 6CFC 0581  14         inc   r1                   ; next version found
0195 6CFE 0699  24         bl    *r9                  ; go run routine
0196                       ;
0197                       ; Depending on IO result the DSR in card ROM does RET
0198                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0199                       ;
0200 6D00 10E5  14         jmp   dsrlnk.dsrscan.nextentry
0201                                                  ; (1) error return
0202 6D02 1E00  20         sbz   0                    ; (2) turn off rom if good return
0203 6D04 02E0  18         lwpi  dsrlws               ; (2) restore workspace
     6D06 B000 
0204 6D08 C009  18         mov   r9,r0                ; point to flag in pab
0205 6D0A C060  34         mov   @sav8a,r1            ; get back data following blwp @dsrlnk
     6D0C 8322 
0206                                                  ; (8 or >a)
0207 6D0E 0281  22         ci    r1,8                 ; was it 8?
     6D10 0008 
0208 6D12 1303  14         jeq   dsrlnk.dsrscan.dsr.8 ; yes, jump: normal dsrlnk
0209 6D14 D060  34         movb  @>8350,r1            ; no, we have a data >a.
     6D16 8350 
0210                                                  ; Get error byte from @>8350
0211 6D18 1000  14         jmp   dsrlnk.dsrscan.dsr.8 ; go and return error byte to the caller
0212               
0213                       ;------------------------------------------------------
0214                       ; Read PAB status flag after DSR call completed
0215                       ;------------------------------------------------------
0216               dsrlnk.dsrscan.dsr.8:
0217                       ;--------------------------; Inline VSBR start
0218 6D1A 06C0  14         swpb  r0                   ;
0219 6D1C D800  38         movb  r0,@vdpa             ; send low byte
     6D1E 8C02 
0220 6D20 06C0  14         swpb  r0                   ;
0221 6D22 D800  38         movb  r0,@vdpa             ; send high byte
     6D24 8C02 
0222 6D26 D060  34         movb  @vdpr,r1             ; read byte from VDP ram
     6D28 8800 
0223                       ;--------------------------; Inline VSBR end
0224               
0225                       ;------------------------------------------------------
0226                       ; Return DSR error to caller
0227                       ;------------------------------------------------------
0228               dsrlnk.dsrscan.dsr.a:
0229 6D2A 09D1  56         srl   r1,13                ; just keep error bits
0230 6D2C 1604  14         jne   dsrlnk.error.io_error
0231                                                  ; handle IO error
0232 6D2E 0380  18         rtwp                       ; Return from DSR workspace to caller workspace
0233               
0234                       ;------------------------------------------------------
0235                       ; IO-error handler
0236                       ;------------------------------------------------------
0237               dsrlnk.error.nodsr_found:
0238 6D30 02E0  18         lwpi  dsrlws               ; No DSR found, restore workspace
     6D32 B000 
0239               dsrlnk.error.devicename_invalid:
0240 6D34 04C1  14         clr   r1                   ; clear flag for error 0 = bad device name
0241               dsrlnk.error.io_error:
0242 6D36 06C1  14         swpb  r1                   ; put error in hi byte
0243 6D38 D741  30         movb  r1,*r13              ; store error flags in callers r0
0244 6D3A F3E0  34         socb  @h20,r15             ; set equal bit to indicate error
     6D3C 6D44 
0245 6D3E 0380  18         rtwp                       ; Return from DSR workspace to caller workspace
0246               
0247               ****************************************************************************************
0248               
0249 6D40 0008     data8   data  >8                   ; just to compare. 8 is the data that
0250                                                  ; usually follows a blwp @dsrlnk
0251 6D42 ....     decmal  text  '.'                  ; for finding end of device name
0252                       even
0253 6D44 2000     h20     data  >2000
**** **** ****     > runlib.asm
0200                       copy  "fio_files.asm"            ; Files I/O support
**** **** ****     > fio_files.asm
0001               * FILE......: fio_files.asm
0002               * Purpose...: File I/O support
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
0015      0009     io.op.status     equ >09            ; STATUS
0016               ***************************************************************
0017               * File types - All relative files are fixed length
0018               ************************************@**************************
0019      0001     io.ft.rf.ud      equ >01            ; UPDATE, DISPLAY
0020      0003     io.ft.rf.od      equ >03            ; OUTPUT, DISPLAY
0021      0005     io.ft.rf.id      equ >05            ; INPUT,  DISPLAY
0022      0009     io.ft.rf.ui      equ >09            ; UPDATE, INTERNAL
0023      000B     io.ft.rf.oi      equ >0b            ; OUTPUT, INTERNAL
0024      000D     io.ft.rf.ii      equ >0d            ; INPUT,  INTERNAL
0025               ***************************************************************
0026               * File types - Sequential files
0027               ************************************@**************************
0028      0002     io.ft.sf.ofd     equ >02            ; OUTPUT, FIXED, DISPLAY
0029      0004     io.ft.sf.ifd     equ >04            ; INPUT,  FIXED, DISPLAY
0030      0006     io.ft.sf.afd     equ >06            ; APPEND, FIXED, DISPLAY
0031      000A     io.ft.sf.ofi     equ >0a            ; OUTPUT, FIXED, INTERNAL
0032      000C     io.ft.sf.ifi     equ >0c            ; INPUT,  FIXED, INTERNAL
0033      000E     io.ft.sf.afi     equ >0e            ; APPEND, FIXED, INTERNAL
0034      0012     io.ft.sf.ovd     equ >12            ; OUTPUT, VARIABLE, DISPLAY
0035      0014     io.ft.sf.ivd     equ >14            ; INPUT,  VARIABLE, DISPLAY
0036      0016     io.ft.sf.avd     equ >16            ; APPEND, VARIABLE, DISPLAY
0037      001A     io.ft.sf.ovi     equ >1a            ; OUTPUT, VARIABLE, INTERNAL
0038      001C     io.ft.sf.ivi     equ >1c            ; INPUT,  VARIABLE, INTERNAL
0039      001E     io.ft.sf.avi     equ >1e            ; APPEND, VARIABLE, INTERNAL
0040               
0041               
0042               
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
0020 6D46 0300  24 tmgr    limi  0                     ; No interrupt processing
     6D48 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 6D4A D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     6D4C 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 6D4E 2360  38         coc   @wbit2,r13            ; C flag on ?
     6D50 602A 
0029 6D52 1602  14         jne   tmgr1a                ; No, so move on
0030 6D54 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     6D56 603E 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 6D58 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     6D5A 6026 
0035 6D5C 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 6D5E 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     6D60 6036 
0048 6D62 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 6D64 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     6D66 6038 
0050 6D68 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 6D6A 0460  28         b     @kthread              ; Run kernel thread
     6D6C 6DE4 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 6D6E 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     6D70 6032 
0056 6D72 13EB  14         jeq   tmgr1
0057 6D74 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     6D76 6034 
0058 6D78 16E8  14         jne   tmgr1
0059 6D7A C120  34         mov   @wtiusr,tmp0
     6D7C 832E 
0060 6D7E 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 6D80 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     6D82 6DE2 
0065 6D84 C10A  18         mov   r10,tmp0
0066 6D86 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     6D88 00FF 
0067 6D8A 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     6D8C 602A 
0068 6D8E 1303  14         jeq   tmgr5
0069 6D90 0284  22         ci    tmp0,60               ; 1 second reached ?
     6D92 003C 
0070 6D94 1002  14         jmp   tmgr6
0071 6D96 0284  22 tmgr5   ci    tmp0,50
     6D98 0032 
0072 6D9A 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 6D9C 1001  14         jmp   tmgr8
0074 6D9E 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 6DA0 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     6DA2 832C 
0079 6DA4 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     6DA6 FF00 
0080 6DA8 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 6DAA 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 6DAC 05C4  14         inct  tmp0                  ; Second word of slot data
0086 6DAE 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 6DB0 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 6DB2 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     6DB4 830C 
     6DB6 830D 
0089 6DB8 1608  14         jne   tmgr10                ; No, get next slot
0090 6DBA 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     6DBC FF00 
0091 6DBE C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 6DC0 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     6DC2 8330 
0096 6DC4 0697  24         bl    *tmp3                 ; Call routine in slot
0097 6DC6 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     6DC8 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 6DCA 058A  14 tmgr10  inc   r10                   ; Next slot
0102 6DCC 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     6DCE 8315 
     6DD0 8314 
0103 6DD2 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 6DD4 05C4  14         inct  tmp0                  ; Offset for next slot
0105 6DD6 10E8  14         jmp   tmgr9                 ; Process next slot
0106 6DD8 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 6DDA 10F7  14         jmp   tmgr10                ; Process next slot
0108 6DDC 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     6DDE FF00 
0109 6DE0 10B4  14         jmp   tmgr1
0110 6DE2 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 6DE4 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     6DE6 6036 
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
0041 6DE8 06A0  32         bl    @realkb               ; Scan full keyboard
     6DEA 6422 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 6DEC 0460  28         b     @tmgr3                ; Exit
     6DEE 6D6E 
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
0017 6DF0 C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     6DF2 832E 
0018 6DF4 E0A0  34         soc   @wbit7,config         ; Enable user hook
     6DF6 6034 
0019 6DF8 045B  20 mkhoo1  b     *r11                  ; Return
0020      6D4A     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********@*****@*********************@**************************
0028 6DFA 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     6DFC 832E 
0029 6DFE 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     6E00 FEFF 
0030 6E02 045B  20         b     *r11                  ; Return
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
0017 6E04 C13B  30 mkslot  mov   *r11+,tmp0
0018 6E06 C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 6E08 C184  18         mov   tmp0,tmp2
0023 6E0A 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 6E0C A1A0  34         a     @wtitab,tmp2          ; Add table base
     6E0E 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 6E10 CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 6E12 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 6E14 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 6E16 881B  46         c     *r11,@whffff          ; End of list ?
     6E18 6046 
0035 6E1A 1301  14         jeq   mkslo1                ; Yes, exit
0036 6E1C 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 6E1E 05CB  14 mkslo1  inct  r11
0041 6E20 045B  20         b     *r11                  ; Exit
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
0052 6E22 C13B  30 clslot  mov   *r11+,tmp0
0053 6E24 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 6E26 A120  34         a     @wtitab,tmp0          ; Add table base
     6E28 832C 
0055 6E2A 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 6E2C 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 6E2E 045B  20         b     *r11                  ; Exit
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
0229               *  If R1 in WS1 equals >FFFF we return to the TI title screen
0230               *  after clearing scratchpad memory.
0231               *  Use 'B @RUNLI1' to exit your program.
0232               ********@*****@*********************@**************************
0237 6E30 04E0  34 runlib  clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     6E32 8302 
0239               *--------------------------------------------------------------
0240               * Alternative entry point
0241               *--------------------------------------------------------------
0242 6E34 0300  24 runli1  limi  0                     ; Turn off interrupts
     6E36 0000 
0243 6E38 02E0  18         lwpi  ws1                   ; Activate workspace 1
     6E3A 8300 
0244 6E3C C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     6E3E 83C0 
0245               *--------------------------------------------------------------
0246               * Clear scratch-pad memory from R4 upwards
0247               *--------------------------------------------------------------
0248 6E40 0202  20 runli2  li    r2,>8308
     6E42 8308 
0249 6E44 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0250 6E46 0282  22         ci    r2,>8400
     6E48 8400 
0251 6E4A 16FC  14         jne   runli3
0252               *--------------------------------------------------------------
0253               * Exit to TI-99/4A title screen ?
0254               *--------------------------------------------------------------
0255 6E4C 0281  22         ci    r1,>ffff              ; Exit flag set ?
     6E4E FFFF 
0256 6E50 1602  14         jne   runli4                ; No, continue
0257 6E52 0420  54         blwp  @0                    ; Yes, bye bye
     6E54 0000 
0258               *--------------------------------------------------------------
0259               * Determine if VDP is PAL or NTSC
0260               *--------------------------------------------------------------
0261 6E56 C803  38 runli4  mov   r3,@waux1             ; Store random seed
     6E58 833C 
0262 6E5A 04C1  14         clr   r1                    ; Reset counter
0263 6E5C 0202  20         li    r2,10                 ; We test 10 times
     6E5E 000A 
0264 6E60 C0E0  34 runli5  mov   @vdps,r3
     6E62 8802 
0265 6E64 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     6E66 6026 
0266 6E68 1302  14         jeq   runli6
0267 6E6A 0581  14         inc   r1                    ; Increase counter
0268 6E6C 10F9  14         jmp   runli5
0269 6E6E 0602  14 runli6  dec   r2                    ; Next test
0270 6E70 16F7  14         jne   runli5
0271 6E72 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     6E74 1250 
0272 6E76 1202  14         jle   runli7                ; No, so it must be NTSC
0273 6E78 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     6E7A 602A 
0274               *--------------------------------------------------------------
0275               * Copy machine code to scratchpad (prepare tight loop)
0276               *--------------------------------------------------------------
0277 6E7C 0201  20 runli7  li    r1,mccode             ; Machinecode to patch
     6E7E 6080 
0278 6E80 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     6E82 8322 
0279 6E84 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0280 6E86 CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0281 6E88 CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0282               *--------------------------------------------------------------
0283               * Initialize registers, memory, ...
0284               *--------------------------------------------------------------
0285 6E8A 04C1  14 runli9  clr   r1
0286 6E8C 04C2  14         clr   r2
0287 6E8E 04C3  14         clr   r3
0288 6E90 0209  20         li    stack,>8400           ; Set stack
     6E92 8400 
0289 6E94 020F  20         li    r15,vdpw              ; Set VDP write address
     6E96 8C00 
0293               *--------------------------------------------------------------
0294               * Setup video memory
0295               *--------------------------------------------------------------
0300 6E98 06A0  32         bl    @filv                 ; Clear all of 16K VDP memory
     6E9A 60BA 
0301 6E9C 0000             data  >0000,>00,>3fff
     6E9E 0000 
     6EA0 3FFF 
0303 6EA2 06A0  32         bl    @filv
     6EA4 60BA 
0304 6EA6 0FC0             data  pctadr,spfclr,16      ; Load color table
     6EA8 00F5 
     6EAA 0010 
0305               *--------------------------------------------------------------
0306               * Check if there is a F18A present
0307               *--------------------------------------------------------------
0311 6EAC 06A0  32         bl    @f18unl               ; Unlock the F18A
     6EAE 6392 
0312 6EB0 06A0  32         bl    @f18chk               ; Check if F18A is there
     6EB2 63AC 
0313 6EB4 06A0  32         bl    @f18lck               ; Lock the F18A again
     6EB6 63A2 
0315               *--------------------------------------------------------------
0316               * Check if there is a speech synthesizer attached
0317               *--------------------------------------------------------------
0319               *       <<skipped>>
0323               *--------------------------------------------------------------
0324               * Load video mode table & font
0325               *--------------------------------------------------------------
0326 6EB8 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     6EBA 6114 
0327 6EBC 6076             data  spvmod                ; Equate selected video mode table
0328 6EBE 0204  20         li    tmp0,spfont           ; Get font option
     6EC0 000C 
0329 6EC2 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0330 6EC4 1304  14         jeq   runlid                ; Yes, skip it
0331 6EC6 06A0  32         bl    @ldfnt
     6EC8 617C 
0332 6ECA 1100             data  fntadr,spfont         ; Load specified font
     6ECC 000C 
0333               *--------------------------------------------------------------
0334               * Branch to main program
0335               *--------------------------------------------------------------
0336 6ECE 0262  22 runlid  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     6ED0 0040 
0337 6ED2 0460  28         b     @main                 ; Give control to main program
     6ED4 6ED6 
**** **** ****     > tivi.asm.2077
0065               *--------------------------------------------------------------
0066               * SPECTRA2 startup options
0067               *--------------------------------------------------------------
0068      00F5     spfclr  equ   >f5                   ; Foreground/Background color for font.
0069      0005     spfbck  equ   >05                   ; Screen background color.
0070               ;spfclr  equ   >a1                   ; Foreground/Background color for font.
0071               ;spfbck  equ   >01                   ; Screen background color.
0072               
0073               *--------------------------------------------------------------
0074               * Scratchpad memory
0075               *--------------------------------------------------------------
0076               ;           equ  >8342              ; >8342-834F **free***
0077      8350     parm1       equ  >8350              ; Function parameter 1
0078      8352     parm2       equ  >8352              ; Function parameter 2
0079      8354     parm3       equ  >8354              ; Function parameter 3
0080      8356     parm4       equ  >8356              ; Function parameter 4
0081      8358     parm5       equ  >8358              ; Function parameter 5
0082      835A     parm6       equ  >835a              ; Function parameter 6
0083      835C     parm7       equ  >835c              ; Function parameter 7
0084      835E     parm8       equ  >835e              ; Function parameter 8
0085      8360     outparm1    equ  >8360              ; Function output parameter 1
0086      8362     outparm2    equ  >8362              ; Function output parameter 2
0087      8364     outparm3    equ  >8364              ; Function output parameter 3
0088      8366     outparm4    equ  >8366              ; Function output parameter 4
0089      8368     outparm5    equ  >8368              ; Function output parameter 5
0090      836A     outparm6    equ  >836a              ; Function output parameter 6
0091      836C     outparm7    equ  >836c              ; Function output parameter 7
0092      836E     outparm8    equ  >836e              ; Function output parameter 8
0093      8370     timers      equ  >8370              ; Timer table
0094      8380     ramsat      equ  >8380              ; Sprite Attribute Table in RAM
0095      8390     rambuf      equ  >8390              ; RAM workbuffer 1
0096               
0097               
0098               *--------------------------------------------------------------
0099               * Frame buffer structure @ >2000
0100               * Frame buffer itself    @ >3000 - >3fff
0101               *--------------------------------------------------------------
0102      2000     fb.top.ptr      equ  >2000          ; Pointer to frame buffer
0103      2002     fb.current      equ  fb.top.ptr+2   ; Pointer to current position in frame buffer
0104      2004     fb.topline      equ  fb.top.ptr+4   ; Top line in frame buffer (matching line X in editor buffer)
0105      2006     fb.row          equ  fb.top.ptr+6   ; Current row in frame buffer (offset 0 .. @fb.screenrows)
0106      2008     fb.row.length   equ  fb.top.ptr+8   ; Length of current row in frame buffer
0107      200A     fb.row.dirty    equ  fb.top.ptr+10  ; Current row dirty flag in frame buffer
0108      200C     fb.column       equ  fb.top.ptr+12  ; Current column in frame buffer
0109      200E     fb.colsline     equ  fb.top.ptr+14  ; Columns per row in frame buffer
0110      2010     fb.curshape     equ  fb.top.ptr+16  ; Cursor shape & colour
0111      2012     fb.curtoggle    equ  fb.top.ptr+18  ; Cursor shape toggle
0112      2014     fb.yxsave       equ  fb.top.ptr+20  ; Copy of WYX
0113      2016     fb.dirty        equ  fb.top.ptr+22  ; Frame buffer dirty flag
0114      2018     fb.screenrows   equ  fb.top.ptr+24  ; Number of rows on physical screen
0115      3000     fb.top          equ  >3000          ; Frame buffer low memory 2400 bytes (80x30)
0116               ;                    >200c-20ff     ; ** FREE **
0117               
0118               
0119               *--------------------------------------------------------------
0120               * Editor buffer structure @ >2100
0121               *--------------------------------------------------------------
0122      2100     edb.top.ptr     equ  >2100          ; Pointer to editor buffer
0123      2102     edb.index.ptr   equ  >2102          ; Pointer to index
0124      2104     edb.lines       equ  >2104          ; Total lines in editor buffer
0125      2108     edb.dirty       equ  >2108          ; Editor buffer dirty flag (Text changed!)
0126      210A     edb.next_free   equ  >210a          ; Pointer to next free line
0127      210C     edb.insmode     equ  >210c          ; Editor insert mode (>0000 overwrite / >ffff insert)
0128      A000     edb.top         equ  >a000          ; Editor buffer high memory 24576 bytes
0129               ;                    >2102-21ff     ; ** FREE **
0130               
0131               
0132               *--------------------------------------------------------------
0133               * Index @ >2200 - >2fff
0134               *--------------------------------------------------------------
0135      2200     idx.top        equ  >2200           ; Top of index
0136               
0137               
0138               *--------------------------------------------------------------
0139               * Video mode configuration
0140               *--------------------------------------------------------------
0141      6076     spvmod  equ   tx8030                ; Video mode.   See VIDTAB for details.
0142      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0143      0050     colrow  equ   80                    ; Columns per row
0144      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0145      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0146      1800     sprpdt  equ   >1800                 ; VDP sprite pattern table
0147      2000     sprsat  equ   >2000                 ; VDP sprite attribute table
0148               
0149               
0150               
0151               ***************************************************************
0152               * Main
0153               ********@*****@*********************@**************************
0154 6ED6 20A0  38 main    coc   @wbit1,config         ; F18a detected?
     6ED8 6028 
0155 6EDA 1302  14         jeq   main.continue
0156 6EDC 0420  54         blwp  @0                    ; Exit for now if no F18a detected
     6EDE 0000 
0157               
0158               main.continue:
0159 6EE0 06A0  32         bl    @f18unl               ; Unlock the F18a
     6EE2 6392 
0160 6EE4 06A0  32         bl    @putvr                ; Turn on 30 rows mode.
     6EE6 614E 
0161 6EE8 3140             data  >3140                 ; F18a VR49 (>31), bit 40
0162               
0163                       ;------------------------------------------------------
0164                       ; Initialize low + high memory expansion
0165                       ;------------------------------------------------------
0166 6EEA 06A0  32         bl    @film
     6EEC 6096 
0167 6EEE 2000                   data >2000,00,8*1024  ; Clear 8k low-memory
     6EF0 0000 
     6EF2 2000 
0168               
0169 6EF4 06A0  32         bl    @film
     6EF6 6096 
0170 6EF8 A000                   data >a000,00,24*1024 ; Clear 24k high-memory
     6EFA 0000 
     6EFC 6000 
0171                       ;------------------------------------------------------
0172                       ; Setup cursor, screen, etc.
0173                       ;------------------------------------------------------
0174 6EFE 06A0  32         bl    @smag1x               ; Sprite magnification 1x
     6F00 630E 
0175 6F02 06A0  32         bl    @s8x8                 ; Small sprite
     6F04 631E 
0176               
0177 6F06 06A0  32         bl    @cpym2m
     6F08 629C 
0178 6F0A 78C0                   data romsat,ramsat,4  ; Load sprite SAT
     6F0C 8380 
     6F0E 0004 
0179               
0180 6F10 C820  54         mov   @romsat+2,@fb.curshape
     6F12 78C2 
     6F14 2010 
0181                                                   ; Save cursor shape & color
0182               
0183 6F16 06A0  32         bl    @cpym2v
     6F18 6254 
0184 6F1A 1800                   data sprpdt,cursors,3*8
     6F1C 78C4 
     6F1E 0018 
0185                                                   ; Load sprite cursor patterns
0186               
0187 6F20 06A0  32         bl    @putat
     6F22 624C 
0188 6F24 1D00                   byte 29,0
0189 6F26 78DC                   data txt_title        ; Show TiVi banner
0190               
0191               *--------------------------------------------------------------
0192               * Initialize
0193               *--------------------------------------------------------------
0194 6F28 06A0  32         bl    @edb.init             ; Initialize editor buffer
     6F2A 7768 
0195 6F2C 06A0  32         bl    @idx.init             ; Initialize index
     6F2E 768E 
0196 6F30 06A0  32         bl    @fb.init              ; Initialize framebuffer
     6F32 75BC 
0197               
0198                       ;-------------------------------------------------------
0199                       ; Setup editor tasks & hook
0200                       ;-------------------------------------------------------
0201 6F34 0204  20         li    tmp0,>0200
     6F36 0200 
0202 6F38 C804  38         mov   tmp0,@btihi           ; Highest slot in use
     6F3A 8314 
0203               
0204 6F3C 06A0  32         bl    @at
     6F3E 632E 
0205 6F40 0000             data  >0000                 ; Cursor YX position = >0000
0206               
0207 6F42 0204  20         li    tmp0,timers
     6F44 8370 
0208 6F46 C804  38         mov   tmp0,@wtitab
     6F48 832C 
0209               
0210 6F4A 06A0  32         bl    @mkslot
     6F4C 6E04 
0211 6F4E 0001                   data >0001,task0      ; Task 0 - Update screen
     6F50 7448 
0212 6F52 0101                   data >0101,task1      ; Task 1 - Update cursor position
     6F54 74CC 
0213 6F56 020F                   data >020f,task2,eol  ; Task 2 - Toggle cursor shape
     6F58 74DA 
     6F5A FFFF 
0214               
0215 6F5C 06A0  32         bl    @mkhook
     6F5E 6DF0 
0216 6F60 6F66                   data editor           ; Setup user hook
0217               
0218 6F62 0460  28         b     @tmgr                 ; Start timers and kthread
     6F64 6D46 
0219               
0220               
0221               ****************************************************************
0222               * Editor - Main loop
0223               ****************************************************************
0224 6F66 20A0  38 editor  coc   @wbit11,config        ; ANYKEY pressed ?
     6F68 603C 
0225 6F6A 160A  14         jne   ed_clear_kbbuffer     ; No, clear buffer and exit
0226               *---------------------------------------------------------------
0227               * Identical key pressed ?
0228               *---------------------------------------------------------------
0229 6F6C 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
     6F6E 603C 
0230 6F70 8820  54         c     @waux1,@waux2         ; Still pressing previous key?
     6F72 833C 
     6F74 833E 
0231 6F76 1308  14         jeq   ed_wait
0232               *--------------------------------------------------------------
0233               * New key pressed
0234               *--------------------------------------------------------------
0235               ed_new_key
0236 6F78 C820  54         mov   @waux1,@waux2         ; Save as previous key
     6F7A 833C 
     6F7C 833E 
0237 6F7E 102F  14         jmp   ed_pk
0238               *--------------------------------------------------------------
0239               * Clear keyboard buffer if no key pressed
0240               *--------------------------------------------------------------
0241               ed_clear_kbbuffer
0242 6F80 04E0  34         clr   @waux1
     6F82 833C 
0243 6F84 04E0  34         clr   @waux2
     6F86 833E 
0244               *--------------------------------------------------------------
0245               * Delay to avoid key bouncing
0246               *--------------------------------------------------------------
0247               ed_wait
0248 6F88 0204  20         li    tmp0,1800             ; Key delay to avoid bouncing keys
     6F8A 0708 
0249                       ;------------------------------------------------------
0250                       ; Delay loop
0251                       ;------------------------------------------------------
0252               ed_wait_loop
0253 6F8C 0604  14         dec   tmp0
0254 6F8E 16FE  14         jne   ed_wait_loop
0255               *--------------------------------------------------------------
0256               * Exit
0257               *--------------------------------------------------------------
0258 6F90 0460  28 ed_exit b     @hookok               ; Return
     6F92 6D4A 
0259               
0260               
0261               
0262               
0263               
0264               
0265               ***************************************************************
0266               *              ed_pk - Editor Process Key module
0267               ***************************************************************
0268                       copy  "ed_pk.asm"
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
0037 6F94 0D00             data  key_enter,ed_pk.action.enter          ; New line
     6F96 7392 
0038 6F98 0800             data  key_left,ed_pk.action.left            ; Move cursor left
     6F9A 7008 
0039 6F9C 0900             data  key_right,ed_pk.action.right          ; Move cursor right
     6F9E 701E 
0040 6FA0 0B00             data  key_up,ed_pk.action.up                ; Move cursor up
     6FA2 7036 
0041 6FA4 0A00             data  key_down,ed_pk.action.down            ; Move cursor down
     6FA6 7088 
0042 6FA8 8100             data  key_home,ed_pk.action.home            ; Move cursor to line begin
     6FAA 70F4 
0043 6FAC 8600             data  key_end,ed_pk.action.end              ; Move cursor to line end
     6FAE 710C 
0044 6FB0 9300             data  key_pword,ed_pk.action.pword          ; Move cursor previous word
     6FB2 7120 
0045 6FB4 8400             data  key_nword,ed_pk.action.nword          ; Move cursor next word
     6FB6 7172 
0046 6FB8 8500             data  key_ppage,ed_pk.action.ppage          ; Move cursor previous page
     6FBA 71D2 
0047 6FBC 9800             data  key_npage,ed_pk.action.npage          ; Move cursor next page
     6FBE 721C 
0048                       ;-------------------------------------------------------
0049                       ; Modifier keys - Delete
0050                       ;-------------------------------------------------------
0051 6FC0 0300             data  key_del_char,ed_pk.action.del_char    ; Delete character
     6FC2 7248 
0052 6FC4 8B00             data  key_del_eol,ed_pk.action.del_eol      ; Delete until end of line
     6FC6 727C 
0053 6FC8 0700             data  key_del_line,ed_pk.action.del_line    ; Delete current line
     6FCA 72AC 
0054                       ;-------------------------------------------------------
0055                       ; Modifier keys - Insert
0056                       ;-------------------------------------------------------
0057 6FCC 0400             data  key_ins_char,ed_pk.action.ins_char.ws ; Insert whitespace
     6FCE 7300 
0058 6FD0 B200             data  key_ins_onoff,ed_pk.action.ins_onoff  ; Insert mode on/off
     6FD2 73FC 
0059 6FD4 0E00             data  key_ins_line,ed_pk.action.ins_line    ; Insert new line
     6FD6 7352 
0060                       ;-------------------------------------------------------
0061                       ; Other action keys
0062                       ;-------------------------------------------------------
0063 6FD8 0500             data  key_quit1,ed_pk.action.quit           ; Quit TiVi
     6FDA 7000 
0064 6FDC FFFF             data  >ffff                                 ; EOL
0065               
0066               
0067               
0068               ****************************************************************
0069               * Editor - Process key
0070               ****************************************************************
0071 6FDE C160  34 ed_pk   mov   @waux1,tmp1           ; Get key value
     6FE0 833C 
0072 6FE2 0245  22         andi  tmp1,>ff00            ; Get rid of LSB
     6FE4 FF00 
0073               
0074 6FE6 0206  20         li    tmp2,keymap_actions   ; Load keyboard map
     6FE8 6F94 
0075 6FEA 0707  14         seto  tmp3                  ; EOL marker
0076                       ;-------------------------------------------------------
0077                       ; Iterate over keyboard map for matching key
0078                       ;-------------------------------------------------------
0079               ed_pk.check_next_key:
0080 6FEC 81D6  26         c     *tmp2,tmp3            ; EOL reached ?
0081 6FEE 1306  14         jeq   ed_pk.do_action.set   ; Yes, so go add letter
0082               
0083 6FF0 8D85  34         c     tmp1,*tmp2+           ; Key matched?
0084 6FF2 1302  14         jeq   ed_pk.do_action       ; Yes, do action
0085 6FF4 05C6  14         inct  tmp2                  ; No, skip action
0086 6FF6 10FA  14         jmp   ed_pk.check_next_key  ; Next key
0087               
0088               ed_pk.do_action:
0089 6FF8 C196  26         mov  *tmp2,tmp2             ; Get action address
0090 6FFA 0456  20         b    *tmp2                  ; Process key action
0091               ed_pk.do_action.set:
0092 6FFC 0460  28         b    @ed_pk.action.char     ; Add character to buffer
     6FFE 740C 
0093               
0094               
0095               
0096               *---------------------------------------------------------------
0097               * Quit
0098               *---------------------------------------------------------------
0099               ed_pk.action.quit:
0100 7000 06A0  32         bl    @f18rst               ; Reset and lock the F18A
     7002 63F6 
0101 7004 0420  54         blwp  @0                    ; Exit
     7006 0000 
0102               
0103               
0104               *---------------------------------------------------------------
0105               * Cursor left
0106               *---------------------------------------------------------------
0107               ed_pk.action.left:
0108 7008 C120  34         mov   @fb.column,tmp0
     700A 200C 
0109 700C 1306  14         jeq   !jmp2b                ; column=0 ? Skip further processing
0110                       ;-------------------------------------------------------
0111                       ; Update
0112                       ;-------------------------------------------------------
0113 700E 0620  34         dec   @fb.column            ; Column-- in screen buffer
     7010 200C 
0114 7012 0620  34         dec   @wyx                  ; Column-- VDP cursor
     7014 832A 
0115 7016 0620  34         dec   @fb.current
     7018 2002 
0116                       ;-------------------------------------------------------
0117                       ; Exit
0118                       ;-------------------------------------------------------
0119 701A 0460  28 !jmp2b  b     @ed_wait              ; Back to editor main
     701C 6F88 
0120               
0121               
0122               *---------------------------------------------------------------
0123               * Cursor right
0124               *---------------------------------------------------------------
0125               ed_pk.action.right:
0126 701E 8820  54         c     @fb.column,@fb.row.length
     7020 200C 
     7022 2008 
0127 7024 1406  14         jhe   !jmp2b                ; column > length line ? Skip further processing
0128                       ;-------------------------------------------------------
0129                       ; Update
0130                       ;-------------------------------------------------------
0131 7026 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     7028 200C 
0132 702A 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     702C 832A 
0133 702E 05A0  34         inc   @fb.current
     7030 2002 
0134                       ;-------------------------------------------------------
0135                       ; Exit
0136                       ;-------------------------------------------------------
0137 7032 0460  28 !jmp2b  b     @ed_wait              ; Back to editor main
     7034 6F88 
0138               
0139               
0140               *---------------------------------------------------------------
0141               * Cursor up
0142               *---------------------------------------------------------------
0143               ed_pk.action.up:
0144                       ;-------------------------------------------------------
0145                       ; Crunch current line if dirty
0146                       ;-------------------------------------------------------
0147 7036 8820  54         c     @fb.row.dirty,@whffff
     7038 200A 
     703A 6046 
0148 703C 1604  14         jne   ed_pk.action.up.cursor
0149 703E 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     7040 7780 
0150 7042 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     7044 200A 
0151                       ;-------------------------------------------------------
0152                       ; Move cursor
0153                       ;-------------------------------------------------------
0154               ed_pk.action.up.cursor:
0155 7046 C120  34         mov   @fb.row,tmp0
     7048 2006 
0156 704A 1509  14         jgt   ed_pk.action.up.cursor_up
0157                                                   ; Move cursor up if fb.row>0
0158 704C C120  34         mov   @fb.topline,tmp0      ; Do we need to scroll?
     704E 2004 
0159 7050 130A  14         jeq   ed_pk.action.up.set_cursorx
0160                                                   ; At top, only position cursor X
0161                       ;-------------------------------------------------------
0162                       ; Scroll 1 line
0163                       ;-------------------------------------------------------
0164 7052 0604  14         dec   tmp0                  ; fb.topline--
0165 7054 C804  38         mov   tmp0,@parm1
     7056 8350 
0166 7058 06A0  32         bl    @fb.refresh           ; Scroll one line up
     705A 761C 
0167 705C 1004  14         jmp   ed_pk.action.up.set_cursorx
0168                       ;-------------------------------------------------------
0169                       ; Move cursor up
0170                       ;-------------------------------------------------------
0171               ed_pk.action.up.cursor_up:
0172 705E 0620  34         dec   @fb.row               ; Row-- in screen buffer
     7060 2006 
0173 7062 06A0  32         bl    @up                   ; Row-- VDP cursor
     7064 633C 
0174                       ;-------------------------------------------------------
0175                       ; Check line length and position cursor
0176                       ;-------------------------------------------------------
0177               ed_pk.action.up.set_cursorx:
0178 7066 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     7068 789C 
0179 706A 8820  54         c     @fb.column,@fb.row.length
     706C 200C 
     706E 2008 
0180 7070 1207  14         jle   ed_pk.action.up.$$
0181                       ;-------------------------------------------------------
0182                       ; Adjust cursor column position
0183                       ;-------------------------------------------------------
0184 7072 C820  54         mov   @fb.row.length,@fb.column
     7074 2008 
     7076 200C 
0185 7078 C120  34         mov   @fb.column,tmp0
     707A 200C 
0186 707C 06A0  32         bl    @xsetx                ; Set VDP cursor X
     707E 6346 
0187                       ;-------------------------------------------------------
0188                       ; Exit
0189                       ;-------------------------------------------------------
0190               ed_pk.action.up.$$:
0191 7080 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7082 7600 
0192 7084 0460  28         b     @ed_wait              ; Back to editor main
     7086 6F88 
0193               
0194               
0195               
0196               *---------------------------------------------------------------
0197               * Cursor down
0198               *---------------------------------------------------------------
0199               ed_pk.action.down:
0200 7088 8820  54         c     @fb.row,@edb.lines    ; Last line in editor buffer ?
     708A 2006 
     708C 2104 
0201 708E 1330  14         jeq   !jmp2b                ; Yes, skip further processing
0202                       ;-------------------------------------------------------
0203                       ; Crunch current row if dirty
0204                       ;-------------------------------------------------------
0205 7090 8820  54         c     @fb.row.dirty,@whffff
     7092 200A 
     7094 6046 
0206 7096 1604  14         jne   ed_pk.action.down.move
0207 7098 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     709A 7780 
0208 709C 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     709E 200A 
0209                       ;-------------------------------------------------------
0210                       ; Move cursor
0211                       ;-------------------------------------------------------
0212               ed_pk.action.down.move:
0213                       ;-------------------------------------------------------
0214                       ; EOF reached?
0215                       ;-------------------------------------------------------
0216 70A0 C120  34         mov   @fb.topline,tmp0
     70A2 2004 
0217 70A4 A120  34         a     @fb.row,tmp0
     70A6 2006 
0218 70A8 8120  34         c     @edb.lines,tmp0       ; fb.topline + fb.row = edb.lines ?
     70AA 2104 
0219 70AC 1312  14         jeq   ed_pk.action.down.set_cursorx
0220                                                   ; Yes, only position cursor X
0221                       ;-------------------------------------------------------
0222                       ; Check if scrolling required
0223                       ;-------------------------------------------------------
0224 70AE C120  34         mov   @fb.screenrows,tmp0
     70B0 2018 
0225 70B2 0604  14         dec   tmp0
0226 70B4 8120  34         c     @fb.row,tmp0
     70B6 2006 
0227 70B8 1108  14         jlt   ed_pk.action.down.cursor
0228                       ;-------------------------------------------------------
0229                       ; Scroll 1 line
0230                       ;-------------------------------------------------------
0231 70BA C820  54         mov   @fb.topline,@parm1
     70BC 2004 
     70BE 8350 
0232 70C0 05A0  34         inc   @parm1
     70C2 8350 
0233 70C4 06A0  32         bl    @fb.refresh
     70C6 761C 
0234 70C8 1004  14         jmp   ed_pk.action.down.set_cursorx
0235                       ;-------------------------------------------------------
0236                       ; Move cursor down a row, there are still rows left
0237                       ;-------------------------------------------------------
0238               ed_pk.action.down.cursor:
0239 70CA 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     70CC 2006 
0240 70CE 06A0  32         bl    @down                 ; Row++ VDP cursor
     70D0 6334 
0241                       ;-------------------------------------------------------
0242                       ; Check line length and position cursor
0243                       ;-------------------------------------------------------
0244               ed_pk.action.down.set_cursorx:
0245 70D2 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     70D4 789C 
0246 70D6 8820  54         c     @fb.column,@fb.row.length
     70D8 200C 
     70DA 2008 
0247 70DC 1207  14         jle   ed_pk.action.down.$$  ; Exit
0248                       ;-------------------------------------------------------
0249                       ; Adjust cursor column position
0250                       ;-------------------------------------------------------
0251 70DE C820  54         mov   @fb.row.length,@fb.column
     70E0 2008 
     70E2 200C 
0252 70E4 C120  34         mov   @fb.column,tmp0
     70E6 200C 
0253 70E8 06A0  32         bl    @xsetx                ; Set VDP cursor X
     70EA 6346 
0254                       ;-------------------------------------------------------
0255                       ; Exit
0256                       ;-------------------------------------------------------
0257               ed_pk.action.down.$$:
0258 70EC 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     70EE 7600 
0259 70F0 0460  28 !jmp2b  b     @ed_wait              ; Back to editor main
     70F2 6F88 
0260               
0261               
0262               
0263               *---------------------------------------------------------------
0264               * Cursor beginning of line
0265               *---------------------------------------------------------------
0266               ed_pk.action.home:
0267 70F4 C120  34         mov   @wyx,tmp0
     70F6 832A 
0268 70F8 0244  22         andi  tmp0,>ff00
     70FA FF00 
0269 70FC C804  38         mov   tmp0,@wyx             ; VDP cursor column=0
     70FE 832A 
0270 7100 04E0  34         clr   @fb.column
     7102 200C 
0271 7104 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7106 7600 
0272 7108 0460  28         b     @ed_wait              ; Back to editor main
     710A 6F88 
0273               
0274               *---------------------------------------------------------------
0275               * Cursor end of line
0276               *---------------------------------------------------------------
0277               ed_pk.action.end:
0278 710C C120  34         mov   @fb.row.length,tmp0
     710E 2008 
0279 7110 C804  38         mov   tmp0,@fb.column
     7112 200C 
0280 7114 06A0  32         bl    @xsetx                ; Set VDP cursor column position
     7116 6346 
0281 7118 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     711A 7600 
0282 711C 0460  28         b     @ed_wait              ; Back to editor main
     711E 6F88 
0283               
0284               
0285               
0286               *---------------------------------------------------------------
0287               * Cursor beginning of word or previous word
0288               *---------------------------------------------------------------
0289               ed_pk.action.pword:
0290 7120 C120  34         mov   @fb.column,tmp0
     7122 200C 
0291 7124 1324  14         jeq   !jmp2b                ; column=0 ? Skip further processing
0292                       ;-------------------------------------------------------
0293                       ; Prepare 2 char buffer
0294                       ;-------------------------------------------------------
0295 7126 C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     7128 2002 
0296 712A 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0297 712C 1003  14         jmp   ed_pk.action.pword_scan_char
0298                       ;-------------------------------------------------------
0299                       ; Scan backwards to first character following space
0300                       ;-------------------------------------------------------
0301               ed_pk.action.pword_scan
0302 712E 0605  14         dec   tmp1
0303 7130 0604  14         dec   tmp0                  ; Column-- in screen buffer
0304 7132 1315  14         jeq   ed_pk.action.pword_done
0305                                                   ; Column=0 ? Skip further processing
0306                       ;-------------------------------------------------------
0307                       ; Check character
0308                       ;-------------------------------------------------------
0309               ed_pk.action.pword_scan_char
0310 7134 D195  26         movb  *tmp1,tmp2            ; Get character
0311 7136 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0312 7138 D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0313 713A 0986  56         srl   tmp2,8                ; Right justify
0314 713C 0286  22         ci    tmp2,32               ; Space character found?
     713E 0020 
0315 7140 16F6  14         jne   ed_pk.action.pword_scan
0316                                                   ; No space found, try again
0317                       ;-------------------------------------------------------
0318                       ; Space found, now look closer
0319                       ;-------------------------------------------------------
0320 7142 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     7144 2020 
0321 7146 13F3  14         jeq   ed_pk.action.pword_scan
0322                                                   ; Yes, so continue scanning
0323 7148 0287  22         ci    tmp3,>20ff            ; First character is space
     714A 20FF 
0324 714C 13F0  14         jeq   ed_pk.action.pword_scan
0325                       ;-------------------------------------------------------
0326                       ; Check distance travelled
0327                       ;-------------------------------------------------------
0328 714E C1E0  34         mov   @fb.column,tmp3       ; re-use tmp3
     7150 200C 
0329 7152 61C4  18         s     tmp0,tmp3
0330 7154 0287  22         ci    tmp3,2                ; Did we move at least 2 positions?
     7156 0002 
0331 7158 11EA  14         jlt   ed_pk.action.pword_scan
0332                                                   ; Didn't move enough so keep on scanning
0333                       ;--------------------------------------------------------
0334                       ; Set cursor following space
0335                       ;--------------------------------------------------------
0336 715A 0585  14         inc   tmp1
0337 715C 0584  14         inc   tmp0                  ; Column++ in screen buffer
0338                       ;-------------------------------------------------------
0339                       ; Save position and position hardware cursor
0340                       ;-------------------------------------------------------
0341               ed_pk.action.pword_done:
0342 715E C805  38         mov   tmp1,@fb.current
     7160 2002 
0343 7162 C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     7164 200C 
0344 7166 06A0  32         bl    @xsetx                ; Set VDP cursor X
     7168 6346 
0345                       ;-------------------------------------------------------
0346                       ; Exit
0347                       ;-------------------------------------------------------
0348               ed_pk.action.pword.$$:
0349 716A 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     716C 7600 
0350 716E 0460  28 !jmp2b  b     @ed_wait              ; Back to editor main
     7170 6F88 
0351               
0352               
0353               
0354               *---------------------------------------------------------------
0355               * Cursor next word
0356               *---------------------------------------------------------------
0357               ed_pk.action.nword:
0358 7172 04C8  14         clr   tmp4                  ; Reset multiple spaces mode
0359 7174 C120  34         mov   @fb.column,tmp0
     7176 200C 
0360 7178 8804  38         c     tmp0,@fb.row.length
     717A 2008 
0361 717C 1428  14         jhe   !jmp2b                ; column=last char ? Skip further processing
0362                       ;-------------------------------------------------------
0363                       ; Prepare 2 char buffer
0364                       ;-------------------------------------------------------
0365 717E C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     7180 2002 
0366 7182 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0367 7184 1006  14         jmp   ed_pk.action.nword_scan_char
0368                       ;-------------------------------------------------------
0369                       ; Multiple spaces mode
0370                       ;-------------------------------------------------------
0371               ed_pk.action.nword_ms:
0372 7186 0708  14         seto  tmp4                  ; Set multiple spaces mode
0373                       ;-------------------------------------------------------
0374                       ; Scan forward to first character following space
0375                       ;-------------------------------------------------------
0376               ed_pk.action.nword_scan
0377 7188 0585  14         inc   tmp1
0378 718A 0584  14         inc   tmp0                  ; Column++ in screen buffer
0379 718C 8804  38         c     tmp0,@fb.row.length
     718E 2008 
0380 7190 1316  14         jeq   ed_pk.action.nword_done
0381                                                   ; Column=last char ? Skip further processing
0382                       ;-------------------------------------------------------
0383                       ; Check character
0384                       ;-------------------------------------------------------
0385               ed_pk.action.nword_scan_char
0386 7192 D195  26         movb  *tmp1,tmp2            ; Get character
0387 7194 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0388 7196 D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0389 7198 0986  56         srl   tmp2,8                ; Right justify
0390               
0391 719A 0288  22         ci    tmp4,>ffff            ; Multiple space mode on?
     719C FFFF 
0392 719E 1604  14         jne   ed_pk.action.nword_scan_char_other
0393                       ;-------------------------------------------------------
0394                       ; Special handling if multiple spaces found
0395                       ;-------------------------------------------------------
0396               ed_pk.action.nword_scan_char_ms:
0397 71A0 0286  22         ci    tmp2,32
     71A2 0020 
0398 71A4 160C  14         jne   ed_pk.action.nword_done
0399                                                   ; Exit if non-space found
0400 71A6 10F0  14         jmp   ed_pk.action.nword_scan
0401                       ;-------------------------------------------------------
0402                       ; Normal handling
0403                       ;-------------------------------------------------------
0404               ed_pk.action.nword_scan_char_other:
0405 71A8 0286  22         ci    tmp2,32               ; Space character found?
     71AA 0020 
0406 71AC 16ED  14         jne   ed_pk.action.nword_scan
0407                                                   ; No space found, try again
0408                       ;-------------------------------------------------------
0409                       ; Space found, now look closer
0410                       ;-------------------------------------------------------
0411 71AE 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     71B0 2020 
0412 71B2 13E9  14         jeq   ed_pk.action.nword_ms
0413                                                   ; Yes, so continue scanning
0414 71B4 0287  22         ci    tmp3,>20ff            ; First characer is space?
     71B6 20FF 
0415 71B8 13E7  14         jeq   ed_pk.action.nword_scan
0416                       ;--------------------------------------------------------
0417                       ; Set cursor following space
0418                       ;--------------------------------------------------------
0419 71BA 0585  14         inc   tmp1
0420 71BC 0584  14         inc   tmp0                  ; Column++ in screen buffer
0421                       ;-------------------------------------------------------
0422                       ; Save position and position hardware cursor
0423                       ;-------------------------------------------------------
0424               ed_pk.action.nword_done:
0425 71BE C805  38         mov   tmp1,@fb.current
     71C0 2002 
0426 71C2 C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     71C4 200C 
0427 71C6 06A0  32         bl    @xsetx                ; Set VDP cursor X
     71C8 6346 
0428                       ;-------------------------------------------------------
0429                       ; Exit
0430                       ;-------------------------------------------------------
0431               ed_pk.action.nword.$$:
0432 71CA 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     71CC 7600 
0433 71CE 0460  28 !jmp2b  b     @ed_wait              ; Back to editor main
     71D0 6F88 
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
0445 71D2 C120  34         mov   @fb.topline,tmp0      ; Exit if already on line 1
     71D4 2004 
0446 71D6 1316  14         jeq   ed_pk.action.ppage.$$
0447                       ;-------------------------------------------------------
0448                       ; Special treatment top page
0449                       ;-------------------------------------------------------
0450 71D8 8804  38         c     tmp0,@fb.screenrows   ; topline > rows on screen?
     71DA 2018 
0451 71DC 1503  14         jgt   ed_pk.action.ppage.topline
0452 71DE 04E0  34         clr   @fb.topline           ; topline = 0
     71E0 2004 
0453 71E2 1003  14         jmp   ed_pk.action.ppage.crunch
0454                       ;-------------------------------------------------------
0455                       ; Adjust topline
0456                       ;-------------------------------------------------------
0457               ed_pk.action.ppage.topline:
0458 71E4 6820  54         s     @fb.screenrows,@fb.topline
     71E6 2018 
     71E8 2004 
0459                       ;-------------------------------------------------------
0460                       ; Crunch current row if dirty
0461                       ;-------------------------------------------------------
0462               ed_pk.action.ppage.crunch:
0463 71EA 8820  54         c     @fb.row.dirty,@whffff
     71EC 200A 
     71EE 6046 
0464 71F0 1604  14         jne   ed_pk.action.ppage.refresh
0465 71F2 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     71F4 7780 
0466 71F6 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     71F8 200A 
0467                       ;-------------------------------------------------------
0468                       ; Refresh page
0469                       ;-------------------------------------------------------
0470               ed_pk.action.ppage.refresh:
0471 71FA C820  54         mov   @fb.topline,@parm1
     71FC 2004 
     71FE 8350 
0472 7200 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     7202 761C 
0473                       ;-------------------------------------------------------
0474                       ; Exit
0475                       ;-------------------------------------------------------
0476               ed_pk.action.ppage.$$:
0477 7204 04E0  34         clr   @fb.row
     7206 2006 
0478 7208 05A0  34         inc   @fb.row               ; Set fb.row=1
     720A 2006 
0479 720C 04E0  34         clr   @fb.column
     720E 200C 
0480 7210 0204  20         li    tmp0,>0100            ; Set VDP cursor on line 1, column 0
     7212 0100 
0481 7214 C804  38         mov   tmp0,@wyx             ; In ed_pk.action up cursor is moved up
     7216 832A 
0482 7218 0460  28         b     @ed_pk.action.up      ; Do rest of logic
     721A 7036 
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
0493 721C C120  34         mov   @fb.topline,tmp0
     721E 2004 
0494 7220 A120  34         a     @fb.screenrows,tmp0
     7222 2018 
0495 7224 8804  38         c     tmp0,@edb.lines       ; Exit if on last page
     7226 2104 
0496 7228 150D  14         jgt   ed_pk.action.npage.$$
0497                       ;-------------------------------------------------------
0498                       ; Adjust topline
0499                       ;-------------------------------------------------------
0500               ed_pk.action.npage.topline:
0501 722A A820  54         a     @fb.screenrows,@fb.topline
     722C 2018 
     722E 2004 
0502                       ;-------------------------------------------------------
0503                       ; Crunch current row if dirty
0504                       ;-------------------------------------------------------
0505               ed_pk.action.npage.crunch:
0506 7230 8820  54         c     @fb.row.dirty,@whffff
     7232 200A 
     7234 6046 
0507 7236 1604  14         jne   ed_pk.action.npage.refresh
0508 7238 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     723A 7780 
0509 723C 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     723E 200A 
0510                       ;-------------------------------------------------------
0511                       ; Refresh page
0512                       ;-------------------------------------------------------
0513               ed_pk.action.npage.refresh:
0514 7240 0460  28         b     @ed_pk.action.ppage.refresh
     7242 71FA 
0515                                                   ; Same logic as previous pabe
0516                       ;-------------------------------------------------------
0517                       ; Exit
0518                       ;-------------------------------------------------------
0519               ed_pk.action.npage.$$:
0520 7244 0460  28         b     @ed_wait              ; Back to editor main
     7246 6F88 
0521               
0522               
0523               *---------------------------------------------------------------
0524               * Delete character
0525               *---------------------------------------------------------------
0526               ed_pk.action.del_char:
0527 7248 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     724A 7600 
0528                       ;-------------------------------------------------------
0529                       ; Sanity check 1
0530                       ;-------------------------------------------------------
0531 724C C120  34         mov   @fb.current,tmp0      ; Get pointer
     724E 2002 
0532 7250 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     7252 2008 
0533 7254 1311  14         jeq   ed_pk.action.del_char.$$
0534                                                   ; Exit if empty line
0535                       ;-------------------------------------------------------
0536                       ; Sanity check 2
0537                       ;-------------------------------------------------------
0538 7256 8820  54         c     @fb.column,@fb.row.length
     7258 200C 
     725A 2008 
0539 725C 130D  14         jeq   ed_pk.action.del_char.$$
0540                                                   ; Exit if at EOL
0541                       ;-------------------------------------------------------
0542                       ; Prepare for delete operation
0543                       ;-------------------------------------------------------
0544 725E C120  34         mov   @fb.current,tmp0      ; Get pointer
     7260 2002 
0545 7262 C144  18         mov   tmp0,tmp1             ; Add 1 to pointer
0546 7264 0585  14         inc   tmp1
0547                       ;-------------------------------------------------------
0548                       ; Loop until end of line
0549                       ;-------------------------------------------------------
0550               ed_pk.action.del_char_loop:
0551 7266 DD35  42         movb  *tmp1+,*tmp0+         ; Overwrite current char with next char
0552 7268 0606  14         dec   tmp2
0553 726A 16FD  14         jne   ed_pk.action.del_char_loop
0554                       ;-------------------------------------------------------
0555                       ; Save variables
0556                       ;-------------------------------------------------------
0557 726C 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     726E 200A 
0558 7270 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     7272 2016 
0559 7274 0620  34         dec   @fb.row.length        ; @fb.row.length--
     7276 2008 
0560                       ;-------------------------------------------------------
0561                       ; Exit
0562                       ;-------------------------------------------------------
0563               ed_pk.action.del_char.$$:
0564 7278 0460  28         b     @ed_wait              ; Back to editor main
     727A 6F88 
0565               
0566               
0567               *---------------------------------------------------------------
0568               * Delete until end of line
0569               *---------------------------------------------------------------
0570               ed_pk.action.del_eol:
0571 727C 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     727E 7600 
0572 7280 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     7282 2008 
0573 7284 1311  14         jeq   ed_pk.action.del_eol.$$
0574                                                   ; Exit if empty line
0575                       ;-------------------------------------------------------
0576                       ; Prepare for erase operation
0577                       ;-------------------------------------------------------
0578 7286 C120  34         mov   @fb.current,tmp0      ; Get pointer
     7288 2002 
0579 728A C1A0  34         mov   @fb.colsline,tmp2
     728C 200E 
0580 728E 61A0  34         s     @fb.column,tmp2
     7290 200C 
0581 7292 04C5  14         clr   tmp1
0582                       ;-------------------------------------------------------
0583                       ; Loop until last column in frame buffer
0584                       ;-------------------------------------------------------
0585               ed_pk.action.del_eol_loop:
0586 7294 DD05  32         movb  tmp1,*tmp0+           ; Overwrite current char with >00
0587 7296 0606  14         dec   tmp2
0588 7298 16FD  14         jne   ed_pk.action.del_eol_loop
0589                       ;-------------------------------------------------------
0590                       ; Save variables
0591                       ;-------------------------------------------------------
0592 729A 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     729C 200A 
0593 729E 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     72A0 2016 
0594               
0595 72A2 C820  54         mov   @fb.column,@fb.row.length
     72A4 200C 
     72A6 2008 
0596                                                   ; Set new row length
0597                       ;-------------------------------------------------------
0598                       ; Exit
0599                       ;-------------------------------------------------------
0600               ed_pk.action.del_eol.$$:
0601 72A8 0460  28         b     @ed_wait              ; Back to editor main
     72AA 6F88 
0602               
0603               
0604               *---------------------------------------------------------------
0605               * Delete current line
0606               *---------------------------------------------------------------
0607               ed_pk.action.del_line:
0608                       ;-------------------------------------------------------
0609                       ; Special treatment if only 1 line in file
0610                       ;-------------------------------------------------------
0611 72AC C120  34         mov   @edb.lines,tmp0
     72AE 2104 
0612 72B0 1604  14         jne   !
0613 72B2 04E0  34         clr   @fb.column            ; Column 0
     72B4 200C 
0614 72B6 0460  28         b     @ed_pk.action.del_eol ; Delete until end of line
     72B8 727C 
0615                       ;-------------------------------------------------------
0616                       ; Delete entry in index
0617                       ;-------------------------------------------------------
0618 72BA 06A0  32 !       bl    @fb.calc_pointer      ; Calculate position in frame buffer
     72BC 7600 
0619 72BE 04E0  34         clr   @fb.row.dirty         ; Discard current line
     72C0 200A 
0620 72C2 C820  54         mov   @fb.topline,@parm1
     72C4 2004 
     72C6 8350 
0621 72C8 A820  54         a     @fb.row,@parm1        ; Line number to remove
     72CA 2006 
     72CC 8350 
0622 72CE C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     72D0 2104 
     72D2 8352 
0623 72D4 06A0  32         bl    @idx.entry.delete     ; Reorganize index
     72D6 76C2 
0624 72D8 0620  34         dec   @edb.lines            ; One line less in editor buffer
     72DA 2104 
0625                       ;-------------------------------------------------------
0626                       ; Refresh frame buffer and physical screen
0627                       ;-------------------------------------------------------
0628 72DC C820  54         mov   @fb.topline,@parm1
     72DE 2004 
     72E0 8350 
0629 72E2 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     72E4 761C 
0630 72E6 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     72E8 2016 
0631                       ;-------------------------------------------------------
0632                       ; Special treatment if current line was last line
0633                       ;-------------------------------------------------------
0634 72EA C120  34         mov   @fb.topline,tmp0
     72EC 2004 
0635 72EE A120  34         a     @fb.row,tmp0
     72F0 2006 
0636 72F2 8804  38         c     tmp0,@edb.lines       ; Was last line?
     72F4 2104 
0637 72F6 1202  14         jle   ed_pk.action.del_line.$$
0638 72F8 0460  28         b     @ed_pk.action.up      ; One line up
     72FA 7036 
0639                       ;-------------------------------------------------------
0640                       ; Exit
0641                       ;-------------------------------------------------------
0642               ed_pk.action.del_line.$$:
0643 72FC 0460  28         b     @ed_pk.action.home    ; Move cursor to home and return
     72FE 70F4 
0644               
0645               
0646               
0647               *---------------------------------------------------------------
0648               * Insert character
0649               *
0650               * @parm1 = high byte has character to insert
0651               *---------------------------------------------------------------
0652               ed_pk.action.ins_char.ws
0653 7300 0204  20         li    tmp0,>2000            ; White space
     7302 2000 
0654 7304 C804  38         mov   tmp0,@parm1
     7306 8350 
0655               ed_pk.action.ins_char:
0656 7308 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     730A 7600 
0657                       ;-------------------------------------------------------
0658                       ; Sanity check 1 - Empty line
0659                       ;-------------------------------------------------------
0660 730C C120  34         mov   @fb.current,tmp0      ; Get pointer
     730E 2002 
0661 7310 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     7312 2008 
0662 7314 131A  14         jeq   ed_pk.action.ins_char.sanity
0663                                                   ; Add character in overwrite mode
0664                       ;-------------------------------------------------------
0665                       ; Sanity check 2 - EOL
0666                       ;-------------------------------------------------------
0667 7316 8820  54         c     @fb.column,@fb.row.length
     7318 200C 
     731A 2008 
0668 731C 1316  14         jeq   ed_pk.action.ins_char.sanity
0669                                                   ; Add character in overwrite mode
0670                       ;-------------------------------------------------------
0671                       ; Prepare for insert operation
0672                       ;-------------------------------------------------------
0673               ed_pk.action.skipsanity:
0674 731E C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0675 7320 61E0  34         s     @fb.column,tmp3
     7322 200C 
0676 7324 A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0677 7326 C144  18         mov   tmp0,tmp1
0678 7328 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0679 732A 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     732C 200C 
0680 732E 0586  14         inc   tmp2
0681                       ;-------------------------------------------------------
0682                       ; Loop from end of line until current character
0683                       ;-------------------------------------------------------
0684               ed_pk.action.ins_char_loop:
0685 7330 D554  38         movb  *tmp0,*tmp1           ; Move char to the right
0686 7332 0604  14         dec   tmp0
0687 7334 0605  14         dec   tmp1
0688 7336 0606  14         dec   tmp2
0689 7338 16FB  14         jne   ed_pk.action.ins_char_loop
0690                       ;-------------------------------------------------------
0691                       ; Set specified character on current position
0692                       ;-------------------------------------------------------
0693 733A D560  46         movb  @parm1,*tmp1
     733C 8350 
0694                       ;-------------------------------------------------------
0695                       ; Save variables
0696                       ;-------------------------------------------------------
0697 733E 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     7340 200A 
0698 7342 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     7344 2016 
0699 7346 05A0  34         inc   @fb.row.length        ; @fb.row.length
     7348 2008 
0700                       ;-------------------------------------------------------
0701                       ; Add character in overwrite mode
0702                       ;-------------------------------------------------------
0703               ed_pk.action.ins_char.sanity
0704 734A 0460  28         b     @ed_pk.action.char.overwrite
     734C 741A 
0705                       ;-------------------------------------------------------
0706                       ; Exit
0707                       ;-------------------------------------------------------
0708               ed_pk.action.ins_char.$$:
0709 734E 0460  28         b     @ed_wait              ; Back to editor main
     7350 6F88 
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
0723 7352 8820  54         c     @fb.row.dirty,@whffff
     7354 200A 
     7356 6046 
0724 7358 1604  14         jne   ed_pk.action.ins_line.insert
0725 735A 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     735C 7780 
0726 735E 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     7360 200A 
0727                       ;-------------------------------------------------------
0728                       ; Insert entry in index
0729                       ;-------------------------------------------------------
0730               ed_pk.action.ins_line.insert:
0731 7362 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7364 7600 
0732 7366 C820  54         mov   @fb.topline,@parm1
     7368 2004 
     736A 8350 
0733 736C A820  54         a     @fb.row,@parm1        ; Line number to insert
     736E 2006 
     7370 8350 
0734               
0735 7372 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     7374 2104 
     7376 8352 
0736 7378 06A0  32         bl    @idx.entry.insert     ; Reorganize index
     737A 76F8 
0737 737C 05A0  34         inc   @edb.lines            ; One line more in editor buffer
     737E 2104 
0738                       ;-------------------------------------------------------
0739                       ; Refresh frame buffer and physical screen
0740                       ;-------------------------------------------------------
0741 7380 C820  54         mov   @fb.topline,@parm1
     7382 2004 
     7384 8350 
0742 7386 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     7388 761C 
0743 738A 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     738C 2016 
0744                       ;-------------------------------------------------------
0745                       ; Exit
0746                       ;-------------------------------------------------------
0747               ed_pk.action.ins_line.$$:
0748 738E 0460  28         b     @ed_wait              ; Back to editor main
     7390 6F88 
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
0762 7392 8820  54         c     @fb.row.dirty,@whffff
     7394 200A 
     7396 6046 
0763 7398 1604  14         jne   ed_pk.action.enter.upd_counter
0764 739A 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     739C 7780 
0765 739E 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     73A0 200A 
0766                       ;-------------------------------------------------------
0767                       ; Update line counter
0768                       ;-------------------------------------------------------
0769               ed_pk.action.enter.upd_counter:
0770 73A2 C120  34         mov   @fb.topline,tmp0
     73A4 2004 
0771 73A6 A120  34         a     @fb.row,tmp0
     73A8 2006 
0772 73AA 8804  38         c     tmp0,@edb.lines       ; Last line in editor buffer?
     73AC 2104 
0773 73AE 1602  14         jne   ed_pk.action.newline  ; No, continue newline
0774 73B0 05A0  34         inc   @edb.lines            ; Total lines++
     73B2 2104 
0775                       ;-------------------------------------------------------
0776                       ; Process newline
0777                       ;-------------------------------------------------------
0778               ed_pk.action.newline:
0779                       ;-------------------------------------------------------
0780                       ; Scroll 1 line if cursor at bottom row of screen
0781                       ;-------------------------------------------------------
0782 73B4 C120  34         mov   @fb.screenrows,tmp0
     73B6 2018 
0783 73B8 0604  14         dec   tmp0
0784 73BA 8120  34         c     @fb.row,tmp0
     73BC 2006 
0785 73BE 110A  14         jlt   ed_pk.action.newline.down
0786                       ;-------------------------------------------------------
0787                       ; Scroll
0788                       ;-------------------------------------------------------
0789 73C0 C120  34         mov   @fb.screenrows,tmp0
     73C2 2018 
0790 73C4 C820  54         mov   @fb.topline,@parm1
     73C6 2004 
     73C8 8350 
0791 73CA 05A0  34         inc   @parm1
     73CC 8350 
0792 73CE 06A0  32         bl    @fb.refresh
     73D0 761C 
0793 73D2 1004  14         jmp   ed_pk.action.newline.rest
0794                       ;-------------------------------------------------------
0795                       ; Move cursor down a row, there are still rows left
0796                       ;-------------------------------------------------------
0797               ed_pk.action.newline.down:
0798 73D4 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     73D6 2006 
0799 73D8 06A0  32         bl    @down                 ; Row++ VDP cursor
     73DA 6334 
0800                       ;-------------------------------------------------------
0801                       ; Set VDP cursor and save variables
0802                       ;-------------------------------------------------------
0803               ed_pk.action.newline.rest:
0804 73DC 06A0  32         bl    @fb.get.firstnonblank
     73DE 7646 
0805 73E0 C120  34         mov   @outparm1,tmp0
     73E2 8360 
0806 73E4 C804  38         mov   tmp0,@fb.column
     73E6 200C 
0807 73E8 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
     73EA 6346 
0808 73EC 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
     73EE 789C 
0809 73F0 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     73F2 7600 
0810 73F4 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     73F6 2016 
0811                       ;-------------------------------------------------------
0812                       ; Exit
0813                       ;-------------------------------------------------------
0814               ed_pk.action.newline.$$:
0815 73F8 0460  28         b     @ed_wait              ; Back to editor main
     73FA 6F88 
0816               
0817               
0818               
0819               
0820               *---------------------------------------------------------------
0821               * Toggle insert/overwrite mode
0822               *---------------------------------------------------------------
0823               ed_pk.action.ins_onoff:
0824 73FC 0560  34         inv   @edb.insmode          ; Toggle insert/overwrite mode
     73FE 210C 
0825                       ;-------------------------------------------------------
0826                       ; Delay
0827                       ;-------------------------------------------------------
0828 7400 0204  20         li    tmp0,2000
     7402 07D0 
0829               ed_pk.action.ins_onoff.loop:
0830 7404 0604  14         dec   tmp0
0831 7406 16FE  14         jne   ed_pk.action.ins_onoff.loop
0832                       ;-------------------------------------------------------
0833                       ; Exit
0834                       ;-------------------------------------------------------
0835               ed_pk.action.ins_onoff.$$:
0836 7408 0460  28         b     @task2.cur_visible    ; Update cursor shape
     740A 74E6 
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
0847 740C D805  38         movb  tmp1,@parm1           ; Store character for insert
     740E 8350 
0848 7410 C120  34         mov   @edb.insmode,tmp0     ; Insert or overwrite ?
     7412 210C 
0849 7414 1302  14         jeq   ed_pk.action.char.overwrite
0850                       ;-------------------------------------------------------
0851                       ; Insert mode
0852                       ;-------------------------------------------------------
0853               ed_pk.action.char.insert:
0854 7416 0460  28         b     @ed_pk.action.ins_char
     7418 7308 
0855                       ;-------------------------------------------------------
0856                       ; Overwrite mode
0857                       ;-------------------------------------------------------
0858               ed_pk.action.char.overwrite:
0859 741A 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     741C 7600 
0860 741E C120  34         mov   @fb.current,tmp0      ; Get pointer
     7420 2002 
0861               
0862 7422 D520  46         movb  @parm1,*tmp0          ; Store character in editor buffer
     7424 8350 
0863 7426 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     7428 200A 
0864 742A 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     742C 2016 
0865               
0866 742E 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     7430 200C 
0867 7432 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     7434 832A 
0868                       ;-------------------------------------------------------
0869                       ; Update line length in frame buffer
0870                       ;-------------------------------------------------------
0871 7436 8820  54         c     @fb.column,@fb.row.length
     7438 200C 
     743A 2008 
0872 743C 1103  14         jlt   ed_pk.action.char.$$  ; column < length line ? Skip further processing
0873 743E C820  54         mov   @fb.column,@fb.row.length
     7440 200C 
     7442 2008 
0874                       ;-------------------------------------------------------
0875                       ; Exit
0876                       ;-------------------------------------------------------
0877               ed_pk.action.char.$$:
0878 7444 0460  28         b     @ed_wait              ; Back to editor main
     7446 6F88 
0879               
**** **** ****     > tivi.asm.2077
0269               
0270               
0271               
0272               
0273               ***************************************************************
0274               * Task 0 - Copy frame buffer to VDP
0275               ***************************************************************
0276 7448 C120  34 task0   mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
     744A 2016 
0277 744C 133D  14         jeq   task0.$$              ; No, skip update
0278                       ;------------------------------------------------------
0279                       ; Determine how many rows to copy
0280                       ;------------------------------------------------------
0281 744E 8820  54         c     @edb.lines,@fb.screenrows
     7450 2104 
     7452 2018 
0282 7454 1103  14         jlt   task0.setrows.small
0283 7456 C160  34         mov   @fb.screenrows,tmp1   ; Lines to copy
     7458 2018 
0284 745A 1003  14         jmp   task0.copy.framebuffer
0285                       ;------------------------------------------------------
0286                       ; Less lines in editor buffer as rows in frame buffer
0287                       ;------------------------------------------------------
0288               task0.setrows.small:
0289 745C C160  34         mov   @edb.lines,tmp1       ; Lines to copy
     745E 2104 
0290 7460 0585  14         inc   tmp1
0291                       ;------------------------------------------------------
0292                       ; Determine area to copy
0293                       ;------------------------------------------------------
0294               task0.copy.framebuffer:
0295 7462 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     7464 200E 
0296                                                   ; 16 bit part is in tmp2!
0297 7466 04C4  14         clr   tmp0                  ; VDP target address
0298 7468 C160  34         mov   @fb.top.ptr,tmp1      ; RAM Source address
     746A 2000 
0299                       ;------------------------------------------------------
0300                       ; Copy memory block
0301                       ;------------------------------------------------------
0302 746C 06A0  32         bl    @xpym2v               ; Copy to VDP
     746E 625A 
0303                                                   ; tmp0 = VDP target address
0304                                                   ; tmp1 = RAM source address
0305                                                   ; tmp2 = Bytes to copy
0306 7470 04E0  34         clr   @fb.dirty             ; Reset frame buffer dirty flag
     7472 2016 
0307                       ;-------------------------------------------------------
0308                       ; Draw EOF marker at end-of-file
0309                       ;-------------------------------------------------------
0310 7474 C120  34         mov   @edb.lines,tmp0
     7476 2104 
0311 7478 6120  34         s     @fb.topline,tmp0      ; Y = @edb.lines - @fb.topline
     747A 2004 
0312 747C 0584  14         inc   tmp0                  ; Y++
0313 747E 8120  34         c     @fb.screenrows,tmp0   ; Hide if last line on screen
     7480 2018 
0314 7482 1222  14         jle   task0.$$
0315                       ;-------------------------------------------------------
0316                       ; Draw EOF marker
0317                       ;-------------------------------------------------------
0318               task0.draw_marker:
0319 7484 C820  54         mov   @wyx,@fb.yxsave       ; Backup VDP cursor position
     7486 832A 
     7488 2014 
0320 748A 0A84  56         sla   tmp0,8                ; X=0
0321 748C C804  38         mov   tmp0,@wyx             ; Set VDP cursor
     748E 832A 
0322 7490 06A0  32         bl    @putstr
     7492 623A 
0323 7494 78F0                   data txt_marker       ; Display *EOF*
0324                       ;-------------------------------------------------------
0325                       ; Draw empty line after (and below) EOF marker
0326                       ;-------------------------------------------------------
0327 7496 06A0  32         bl    @setx
     7498 6344 
0328 749A 0005                   data  5               ; Cursor after *EOF* string
0329               
0330 749C C120  34         mov   @wyx,tmp0
     749E 832A 
0331 74A0 0984  56         srl   tmp0,8                ; Right justify
0332 74A2 0584  14         inc   tmp0                  ; One time adjust
0333 74A4 8120  34         c     @fb.screenrows,tmp0   ; Don't spill on last line on screen
     74A6 2018 
0334 74A8 1303  14         jeq   !
0335 74AA 0206  20         li    tmp2,colrow+colrow-5  ; Repeat count for 2 lines
     74AC 009B 
0336 74AE 1002  14         jmp   task0.draw_marker.line
0337 74B0 0206  20 !       li    tmp2,colrow-5         ; Repeat count for 1 line
     74B2 004B 
0338                       ;-------------------------------------------------------
0339                       ; Draw empty line
0340                       ;-------------------------------------------------------
0341               task0.draw_marker.line:
0342 74B4 0604  14         dec   tmp0                  ; One time adjust
0343 74B6 06A0  32         bl    @yx2pnt               ; Set VDP address in tmp0
     74B8 6216 
0344 74BA 0205  20         li    tmp1,32               ; Character to write (whitespace)
     74BC 0020 
0345 74BE 06A0  32         bl    @xfilv                ; Write characters
     74C0 60C0 
0346 74C2 C820  54         mov   @fb.yxsave,@wyx       ; Restore VDP cursor postion
     74C4 2014 
     74C6 832A 
0347               *--------------------------------------------------------------
0348               * Task 0 - Exit
0349               *--------------------------------------------------------------
0350               task0.$$:
0351 74C8 0460  28         b     @slotok
     74CA 6DC6 
0352               
0353               
0354               
0355               ***************************************************************
0356               * Task 1 - Copy SAT to VDP
0357               ***************************************************************
0358 74CC E0A0  34 task1   soc   @wbit0,config          ; Sprite adjustment on
     74CE 6026 
0359 74D0 06A0  32         bl    @yx2px                 ; Calculate pixel position, result in tmp0
     74D2 6350 
0360 74D4 C804  38         mov   tmp0,@ramsat           ; Set cursor YX
     74D6 8380 
0361 74D8 1012  14         jmp   task.sub_copy_ramsat   ; Update VDP SAT and exit task
0362               
0363               
0364               ***************************************************************
0365               * Task 2 - Update cursor shape (blink)
0366               ***************************************************************
0367 74DA 0560  34 task2   inv   @fb.curtoggle          ; Flip cursor shape flag
     74DC 2012 
0368 74DE 1303  14         jeq   task2.cur_visible
0369 74E0 04E0  34         clr   @ramsat+2              ; Hide cursor
     74E2 8382 
0370 74E4 100C  14         jmp   task.sub_copy_ramsat   ; Update VDP SAT and exit task
0371               
0372               task2.cur_visible:
0373 74E6 C120  34         mov   @edb.insmode,tmp0      ; Get Editor buffer insert mode
     74E8 210C 
0374 74EA 1303  14         jeq   task2.cur_visible.overwrite_mode
0375                       ;------------------------------------------------------
0376                       ; Cursor in insert mode
0377                       ;------------------------------------------------------
0378               task2.cur_visible.insert_mode:
0379 74EC 0204  20         li    tmp0,>000f
     74EE 000F 
0380 74F0 1002  14         jmp   task2.cur_visible.cursorshape
0381                       ;------------------------------------------------------
0382                       ; Cursor in overwrite mode
0383                       ;------------------------------------------------------
0384               task2.cur_visible.overwrite_mode:
0385 74F2 0204  20         li    tmp0,>020f
     74F4 020F 
0386                       ;------------------------------------------------------
0387                       ; Set cursor shape
0388                       ;------------------------------------------------------
0389               task2.cur_visible.cursorshape:
0390 74F6 C804  38         mov   tmp0,@fb.curshape
     74F8 2010 
0391 74FA C804  38         mov   tmp0,@ramsat+2
     74FC 8382 
0392               
0393               
0394               
0395               
0396               
0397               
0398               
0399               *--------------------------------------------------------------
0400               * Copy ramsat to VDP SAT and show bottom line - Tasks 1,2
0401               *--------------------------------------------------------------
0402               task.sub_copy_ramsat
0403 74FE 06A0  32         bl    @cpym2v
     7500 6254 
0404 7502 2000                   data sprsat,ramsat,4   ; Update sprite
     7504 8380 
     7506 0004 
0405               
0406 7508 C820  54         mov   @wyx,@fb.yxsave
     750A 832A 
     750C 2014 
0407                       ;------------------------------------------------------
0408                       ; Show text editing mode
0409                       ;------------------------------------------------------
0410               task.botline.show_mode
0411 750E C120  34         mov   @edb.insmode,tmp0
     7510 210C 
0412 7512 1605  14         jne   task.botline.show_mode.insert
0413                       ;------------------------------------------------------
0414                       ; Overwrite mode
0415                       ;------------------------------------------------------
0416               task.botline.show_mode.overwrite:
0417 7514 06A0  32         bl    @putat
     7516 624C 
0418 7518 1D32                   byte  29,50
0419 751A 78FC                   data  txt_ovrwrite
0420 751C 1004  14         jmp   task.botline.show_linecol
0421                       ;------------------------------------------------------
0422                       ; Insert  mode
0423                       ;------------------------------------------------------
0424               task.botline.show_mode.insert
0425 751E 06A0  32         bl    @putat
     7520 624C 
0426 7522 1D32                   byte  29,50
0427 7524 7900                   data  txt_insert
0428                       ;------------------------------------------------------
0429                       ; Show "line,column"
0430                       ;------------------------------------------------------
0431               task.botline.show_linecol:
0432 7526 C820  54         mov   @fb.row,@parm1
     7528 2006 
     752A 8350 
0433 752C 06A0  32         bl    @fb.row2line
     752E 75EC 
0434 7530 05A0  34         inc   @outparm1
     7532 8360 
0435                       ;------------------------------------------------------
0436                       ; Show line
0437                       ;------------------------------------------------------
0438 7534 06A0  32         bl    @putnum
     7536 65F8 
0439 7538 1D40                   byte  29,64            ; YX
0440 753A 8360                   data  outparm1,rambuf
     753C 8390 
0441 753E 3020                   byte  48               ; ASCII offset
0442                             byte  32               ; Padding character
0443                       ;------------------------------------------------------
0444                       ; Show comma
0445                       ;------------------------------------------------------
0446 7540 06A0  32         bl    @putat
     7542 624C 
0447 7544 1D45                   byte  29,69
0448 7546 78EE                   data  txt_delim
0449                       ;------------------------------------------------------
0450                       ; Show column
0451                       ;------------------------------------------------------
0452 7548 06A0  32         bl    @film
     754A 6096 
0453 754C 8396                   data rambuf+6,32,12    ; Clear work buffer with space character
     754E 0020 
     7550 000C 
0454               
0455 7552 C820  54         mov   @fb.column,@waux1
     7554 200C 
     7556 833C 
0456 7558 05A0  34         inc   @waux1                 ; Offset 1
     755A 833C 
0457               
0458 755C 06A0  32         bl    @mknum                 ; Convert unsigned number to string
     755E 657A 
0459 7560 833C                   data  waux1,rambuf
     7562 8390 
0460 7564 3020                   byte  48               ; ASCII offset
0461                             byte  32               ; Fill character
0462               
0463 7566 06A0  32         bl    @trimnum               ; Trim number to the left
     7568 65D2 
0464 756A 8390                   data  rambuf,rambuf+6,32
     756C 8396 
     756E 0020 
0465               
0466 7570 0204  20         li    tmp0,>0200
     7572 0200 
0467 7574 D804  38         movb  tmp0,@rambuf+6         ; "Fix" number length to clear junk chars
     7576 8396 
0468               
0469 7578 06A0  32         bl    @putat
     757A 624C 
0470 757C 1D46                   byte 29,70
0471 757E 8396                   data rambuf+6          ; Show column
0472                       ;------------------------------------------------------
0473                       ; Show lines in buffer unless on last line in file
0474                       ;------------------------------------------------------
0475 7580 C820  54         mov   @fb.row,@parm1
     7582 2006 
     7584 8350 
0476 7586 06A0  32         bl    @fb.row2line
     7588 75EC 
0477 758A 8820  54         c     @edb.lines,@outparm1
     758C 2104 
     758E 8360 
0478 7590 1605  14         jne   task.botline.show_lines_in_buffer
0479               
0480 7592 06A0  32         bl    @putat
     7594 624C 
0481 7596 1D49                   byte 29,73
0482 7598 78F6                   data txt_bottom
0483               
0484 759A 100B  14         jmp   task.botline.$$
0485                       ;------------------------------------------------------
0486                       ; Show lines in buffer
0487                       ;------------------------------------------------------
0488               task.botline.show_lines_in_buffer:
0489 759C C820  54         mov   @edb.lines,@waux1
     759E 2104 
     75A0 833C 
0490 75A2 05A0  34         inc   @waux1                 ; Offset 1
     75A4 833C 
0491 75A6 06A0  32         bl    @putnum
     75A8 65F8 
0492 75AA 1D49                   byte 29,73             ; YX
0493 75AC 833C                   data waux1,rambuf
     75AE 8390 
0494 75B0 3020                   byte 48
0495                             byte 32
0496                       ;------------------------------------------------------
0497                       ; Exit
0498                       ;------------------------------------------------------
0499               task.botline.$$
0500 75B2 C820  54         mov   @fb.yxsave,@wyx
     75B4 2014 
     75B6 832A 
0501 75B8 0460  28         b     @slotok                ; Exit running task
     75BA 6DC6 
0502               
0503               
0504               
0505               ***************************************************************
0506               *                  fb - Framebuffer module
0507               ***************************************************************
0508                       copy  "fb.asm"
**** **** ****     > fb.asm
0001               * FILE......: fb.asm
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
0024 75BC 0649  14         dect  stack
0025 75BE C64B  30         mov   r11,*stack            ; Save return address
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 75C0 0204  20         li    tmp0,fb.top
     75C2 3000 
0030 75C4 C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     75C6 2000 
0031 75C8 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     75CA 2004 
0032 75CC 04E0  34         clr   @fb.row               ; Current row=0
     75CE 2006 
0033 75D0 04E0  34         clr   @fb.column            ; Current column=0
     75D2 200C 
0034 75D4 0204  20         li    tmp0,80
     75D6 0050 
0035 75D8 C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     75DA 200E 
0036 75DC 0204  20         li    tmp0,29
     75DE 001D 
0037 75E0 C804  38         mov   tmp0,@fb.screenrows   ; Physical rows on screen = 29
     75E2 2018 
0038 75E4 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     75E6 2016 
0039                       ;------------------------------------------------------
0040                       ; Exit
0041                       ;------------------------------------------------------
0042               fb.init.$$
0043 75E8 0460  28         b     @poprt                ; Return to caller
     75EA 6092 
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
0068 75EC 0649  14         dect  stack
0069 75EE C64B  30         mov   r11,*stack            ; Save return address
0070                       ;------------------------------------------------------
0071                       ; Calculate line in editor buffer
0072                       ;------------------------------------------------------
0073 75F0 C120  34         mov   @parm1,tmp0
     75F2 8350 
0074 75F4 A120  34         a     @fb.topline,tmp0
     75F6 2004 
0075 75F8 C804  38         mov   tmp0,@outparm1
     75FA 8360 
0076                       ;------------------------------------------------------
0077                       ; Exit
0078                       ;------------------------------------------------------
0079               fb.row2line$$:
0080 75FC 0460  28         b    @poprt                 ; Return to caller
     75FE 6092 
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
0108 7600 0649  14         dect  stack
0109 7602 C64B  30         mov   r11,*stack            ; Save return address
0110                       ;------------------------------------------------------
0111                       ; Calculate pointer
0112                       ;------------------------------------------------------
0113 7604 C1A0  34         mov   @fb.row,tmp2
     7606 2006 
0114 7608 39A0  72         mpy   @fb.colsline,tmp2     ; tmp3 = row  * colsline
     760A 200E 
0115 760C A1E0  34         a     @fb.column,tmp3       ; tmp3 = tmp3 + column
     760E 200C 
0116 7610 A1E0  34         a     @fb.top.ptr,tmp3      ; tmp3 = tmp3 + base
     7612 2000 
0117 7614 C807  38         mov   tmp3,@fb.current
     7616 2002 
0118                       ;------------------------------------------------------
0119                       ; Exit
0120                       ;------------------------------------------------------
0121               fb.calc_pointer.$$
0122 7618 0460  28         b    @poprt                 ; Return to caller
     761A 6092 
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
0140 761C 0649  14         dect  stack
0141 761E C64B  30         mov   r11,*stack            ; Save return address
0142                       ;------------------------------------------------------
0143                       ; Setup starting position in index
0144                       ;------------------------------------------------------
0145 7620 C820  54         mov   @parm1,@fb.topline
     7622 8350 
     7624 2004 
0146 7626 04E0  34         clr   @parm2                ; Target row in frame buffer
     7628 8352 
0147                       ;------------------------------------------------------
0148                       ; Unpack line to frame buffer
0149                       ;------------------------------------------------------
0150               fb.refresh.unpack_line:
0151 762A 06A0  32         bl    @edb.line.unpack
     762C 780E 
0152 762E 05A0  34         inc   @parm1                ; Next line in editor buffer
     7630 8350 
0153 7632 05A0  34         inc   @parm2                ; Next row in frame buffer
     7634 8352 
0154 7636 8820  54         c     @parm2,@fb.screenrows ; Last row reached ?
     7638 8352 
     763A 2018 
0155 763C 11F6  14         jlt   fb.refresh.unpack_line
0156 763E 0720  34         seto  @fb.dirty             ; Refresh screen
     7640 2016 
0157                       ;------------------------------------------------------
0158                       ; Exit
0159                       ;------------------------------------------------------
0160               fb.refresh.$$
0161 7642 0460  28         b    @poprt                 ; Return to caller
     7644 6092 
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
0177 7646 0649  14         dect  stack
0178 7648 C64B  30         mov   r11,*stack            ; Save return address
0179                       ;------------------------------------------------------
0180                       ; Prepare for scanning
0181                       ;------------------------------------------------------
0182 764A 04E0  34         clr   @fb.column
     764C 200C 
0183 764E 06A0  32         bl    @fb.calc_pointer
     7650 7600 
0184 7652 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     7654 789C 
0185 7656 C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
     7658 2008 
0186 765A 1313  14         jeq   fb.get.firstnonblank.nomatch
0187                                                   ; Exit if empty line
0188 765C C120  34         mov   @fb.current,tmp0      ; Pointer to current char
     765E 2002 
0189 7660 04C5  14         clr   tmp1
0190                       ;------------------------------------------------------
0191                       ; Scan line for non-blank character
0192                       ;------------------------------------------------------
0193               fb.get.firstnonblank.loop:
0194 7662 D174  28         movb  *tmp0+,tmp1           ; Get character
0195 7664 130E  14         jeq   fb.get.firstnonblank.nomatch
0196                                                   ; Exit if empty line
0197 7666 0285  22         ci    tmp1,>2000            ; Whitespace?
     7668 2000 
0198 766A 1503  14         jgt   fb.get.firstnonblank.match
0199 766C 0606  14         dec   tmp2                  ; Counter--
0200 766E 16F9  14         jne   fb.get.firstnonblank.loop
0201 7670 1008  14         jmp   fb.get.firstnonblank.nomatch
0202                       ;------------------------------------------------------
0203                       ; Non-blank character found
0204                       ;------------------------------------------------------
0205               fb.get.firstnonblank.match
0206 7672 6120  34         s     @fb.current,tmp0      ; Calculate column
     7674 2002 
0207 7676 0604  14         dec   tmp0
0208 7678 C804  38         mov   tmp0,@outparm1        ; Save column
     767A 8360 
0209 767C D805  38         movb  tmp1,@outparm2        ; Save character
     767E 8362 
0210 7680 1004  14         jmp   fb.get.firstnonblank.$$
0211                       ;------------------------------------------------------
0212                       ; No non-blank character found
0213                       ;------------------------------------------------------
0214               fb.get.firstnonblank.nomatch
0215 7682 04E0  34         clr   @outparm1             ; X=0
     7684 8360 
0216 7686 04E0  34         clr   @outparm2             ; Null
     7688 8362 
0217                       ;------------------------------------------------------
0218                       ; Exit
0219                       ;------------------------------------------------------
0220               fb.get.firstnonblank.$$
0221 768A 0460  28         b    @poprt                 ; Return to caller
     768C 6092 
0222               
0223               
0224               
0225               
0226               
0227               
**** **** ****     > tivi.asm.2077
0509               
0510               
0511               ***************************************************************
0512               *              idx - Index management module
0513               ***************************************************************
0514                       copy  "idx.asm"
**** **** ****     > idx.asm
0001               * FILE......: idx.asm
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
0030 768E 0649  14         dect  stack
0031 7690 C64B  30         mov   r11,*stack            ; Save return address
0032                       ;------------------------------------------------------
0033                       ; Initialize
0034                       ;------------------------------------------------------
0035 7692 0204  20         li    tmp0,idx.top
     7694 2200 
0036 7696 C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     7698 2102 
0037                       ;------------------------------------------------------
0038                       ; Create index slot 0
0039                       ;------------------------------------------------------
0040 769A 04F4  30         clr   *tmp0+                ; Set empty pointer
0041 769C 04F4  30         clr   *tmp0+                ; Set packed/unpacked length to 0
0042                       ;------------------------------------------------------
0043                       ; Exit
0044                       ;------------------------------------------------------
0045               idx.init.$$:
0046 769E 0460  28         b     @poprt                ; Return to caller
     76A0 6092 
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
0068 76A2 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     76A4 8350 
0069                       ;------------------------------------------------------
0070                       ; Calculate address of index entry and update
0071                       ;------------------------------------------------------
0072 76A6 0A24  56         sla   tmp0,2                ; line number * 4
0073 76A8 C920  54         mov   @parm2,@idx.top(tmp0) ; Update index slot -> Pointer
     76AA 8352 
     76AC 2200 
0074                       ;------------------------------------------------------
0075                       ; Set packed / unpacked length of string and update
0076                       ;------------------------------------------------------
0077 76AE C160  34         mov   @parm3,tmp1           ; Set unpacked length
     76B0 8354 
0078 76B2 C185  18         mov   tmp1,tmp2
0079 76B4 06C6  14         swpb  tmp2
0080 76B6 D146  18         movb  tmp2,tmp1             ; Set packed length (identical for now!)
0081 76B8 C905  38         mov   tmp1,@idx.top+2(tmp0) ; Update index slot -> Lengths
     76BA 2202 
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
0092 76BC C804  38         mov   tmp0,@outparm1        ; Pointer to update index entry
     76BE 8360 
0093 76C0 045B  20         b     *r11                  ; Return
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
0113 76C2 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     76C4 8350 
0114                       ;------------------------------------------------------
0115                       ; Calculate address of index entry and save pointer
0116                       ;------------------------------------------------------
0117 76C6 0A24  56         sla   tmp0,2                ; line number * 4
0118 76C8 C824  54         mov   @idx.top(tmp0),@outparm1
     76CA 2200 
     76CC 8360 
0119                                                   ; Pointer to deleted line
0120                       ;------------------------------------------------------
0121                       ; Prepare for index reorg
0122                       ;------------------------------------------------------
0123 76CE C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     76D0 8352 
0124 76D2 61A0  34         s     @parm1,tmp2           ; Calculate loop
     76D4 8350 
0125 76D6 1605  14         jne   idx.entry.delete.reorg
0126                       ;------------------------------------------------------
0127                       ; Special treatment if last line
0128                       ;------------------------------------------------------
0129 76D8 0724  34         seto  @idx.top+0(tmp0)
     76DA 2200 
0130 76DC 04E4  34         clr   @idx.top+2(tmp0)
     76DE 2202 
0131 76E0 100A  14         jmp   idx.entry.delete.$$
0132                       ;------------------------------------------------------
0133                       ; Reorganize index entries
0134                       ;------------------------------------------------------
0135               idx.entry.delete.reorg:
0136 76E2 C924  54         mov   @idx.top+4(tmp0),@idx.top+0(tmp0)
     76E4 2204 
     76E6 2200 
0137 76E8 C924  54         mov   @idx.top+6(tmp0),@idx.top+2(tmp0)
     76EA 2206 
     76EC 2202 
0138 76EE 0224  22         ai    tmp0,4                ; Next index entry
     76F0 0004 
0139               
0140 76F2 0606  14         dec   tmp2                  ; tmp2--
0141 76F4 16F6  14         jne   idx.entry.delete.reorg
0142                                                   ; Loop unless completed
0143                       ;------------------------------------------------------
0144                       ; Exit
0145                       ;------------------------------------------------------
0146               idx.entry.delete.$$:
0147 76F6 045B  20         b     *r11                  ; Return
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
0167 76F8 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     76FA 8352 
0168                       ;------------------------------------------------------
0169                       ; Calculate address of index entry and save pointer
0170                       ;------------------------------------------------------
0171 76FC 0A24  56         sla   tmp0,2                ; line number * 4
0172                       ;------------------------------------------------------
0173                       ; Prepare for index reorg
0174                       ;------------------------------------------------------
0175 76FE C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     7700 8352 
0176 7702 61A0  34         s     @parm1,tmp2           ; Calculate loop
     7704 8350 
0177 7706 160B  14         jne   idx.entry.insert.reorg
0178                       ;------------------------------------------------------
0179                       ; Special treatment if last line
0180                       ;------------------------------------------------------
0181 7708 C924  54         mov   @idx.top+0(tmp0),@idx.top+4(tmp0)
     770A 2200 
     770C 2204 
0182 770E C924  54         mov   @idx.top+2(tmp0),@idx.top+6(tmp0)
     7710 2202 
     7712 2206 
0183 7714 04E4  34         clr   @idx.top+0(tmp0)      ; Clear new index entry word 1
     7716 2200 
0184 7718 04E4  34         clr   @idx.top+2(tmp0)      ; Clear new index entry word 2
     771A 2202 
0185 771C 100F  14         jmp   idx.entry.insert.$$
0186                       ;------------------------------------------------------
0187                       ; Reorganize index entries
0188                       ;------------------------------------------------------
0189               idx.entry.insert.reorg:
0190 771E 05C6  14         inct  tmp2                  ; Adjust one time
0191 7720 C924  54 !       mov   @idx.top+0(tmp0),@idx.top+4(tmp0)
     7722 2200 
     7724 2204 
0192 7726 C924  54         mov   @idx.top+2(tmp0),@idx.top+6(tmp0)
     7728 2202 
     772A 2206 
0193 772C 0224  22         ai    tmp0,-4               ; Previous index entry
     772E FFFC 
0194               
0195 7730 0606  14         dec   tmp2                  ; tmp2--
0196 7732 16F6  14         jne   -!                    ; Loop unless completed
0197 7734 04E4  34         clr   @idx.top+8(tmp0)      ; Clear new index entry word 1
     7736 2208 
0198 7738 04E4  34         clr   @idx.top+10(tmp0)     ; Clear new index entry word 2
     773A 220A 
0199                       ;------------------------------------------------------
0200                       ; Exit
0201                       ;------------------------------------------------------
0202               idx.entry.insert.$$:
0203 773C 045B  20         b     *r11                  ; Return
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
0224 773E 0649  14         dect  stack
0225 7740 C64B  30         mov   r11,*stack            ; Save return address
0226                       ;------------------------------------------------------
0227                       ; Get pointer
0228                       ;------------------------------------------------------
0229 7742 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     7744 8350 
0230                       ;------------------------------------------------------
0231                       ; Calculate index entry
0232                       ;------------------------------------------------------
0233 7746 0A24  56         sla   tmp0,2                     ; line number * 4
0234 7748 C824  54         mov   @idx.top(tmp0),@outparm1   ; Index slot -> Pointer
     774A 2200 
     774C 8360 
0235                       ;------------------------------------------------------
0236                       ; Get SAMS page
0237                       ;------------------------------------------------------
0238 774E C164  34         mov   @idx.top+2(tmp0),tmp1 ; SAMS Page
     7750 2202 
0239 7752 0985  56         srl   tmp1,8                ; Right justify
0240 7754 C805  38         mov   tmp1,@outparm2
     7756 8362 
0241                       ;------------------------------------------------------
0242                       ; Get line length
0243                       ;------------------------------------------------------
0244 7758 C164  34         mov   @idx.top+2(tmp0),tmp1
     775A 2202 
0245 775C 0245  22         andi  tmp1,>00ff            ; Get rid of MSB (SAMS page)
     775E 00FF 
0246 7760 C805  38         mov   tmp1,@outparm3
     7762 8364 
0247                       ;------------------------------------------------------
0248                       ; Exit
0249                       ;------------------------------------------------------
0250               idx.pointer.get.$$:
0251 7764 0460  28         b     @poprt                ; Return to caller
     7766 6092 
**** **** ****     > tivi.asm.2077
0515               
0516               
0517               ***************************************************************
0518               *               edb - Editor Buffer module
0519               ***************************************************************
0520                       copy  "edb.asm"
**** **** ****     > edb.asm
0001               * FILE......: edb.asm
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
0026 7768 0649  14         dect  stack
0027 776A C64B  30         mov   r11,*stack            ; Save return address
0028                       ;------------------------------------------------------
0029                       ; Initialize
0030                       ;------------------------------------------------------
0031 776C 0204  20         li    tmp0,edb.top
     776E A000 
0032 7770 C804  38         mov   tmp0,@edb.top.ptr     ; Set pointer to top of editor buffer
     7772 2100 
0033 7774 C804  38         mov   tmp0,@edb.next_free   ; Set pointer to next free line in editor buffer
     7776 210A 
0034 7778 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     777A 210C 
0035               edb.init.$$:
0036                       ;------------------------------------------------------
0037                       ; Exit
0038                       ;------------------------------------------------------
0039 777C 0460  28         b     @poprt                ; Return to caller
     777E 6092 
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
0066 7780 0649  14         dect  stack
0067 7782 C64B  30         mov   r11,*stack            ; Save return address
0068                       ;------------------------------------------------------
0069                       ; Get values
0070                       ;------------------------------------------------------
0071 7784 C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     7786 200C 
     7788 8390 
0072 778A 04E0  34         clr   @fb.column
     778C 200C 
0073 778E 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
     7790 7600 
0074                       ;------------------------------------------------------
0075                       ; Prepare scan
0076                       ;------------------------------------------------------
0077 7792 04C4  14         clr   tmp0                  ; Counter
0078 7794 C160  34         mov   @fb.current,tmp1      ; Get position
     7796 2002 
0079 7798 C805  38         mov   tmp1,@rambuf+2        ; Save beginning of row
     779A 8392 
0080                       ;------------------------------------------------------
0081                       ; Scan line for >00 byte termination
0082                       ;------------------------------------------------------
0083               edb.line.pack.scan:
0084 779C D1B5  28         movb  *tmp1+,tmp2           ; Get char
0085 779E 0986  56         srl   tmp2,8                ; Right justify
0086 77A0 1302  14         jeq   edb.line.pack.idx     ; Stop scan if >00 found
0087 77A2 0584  14         inc   tmp0                  ; Increase string length
0088 77A4 10FB  14         jmp   edb.line.pack.scan    ; Next character
0089                       ;------------------------------------------------------
0090                       ; Update index entry
0091                       ;------------------------------------------------------
0092               edb.line.pack.idx:
0093 77A6 C820  54         mov   @fb.topline,@parm1    ; parm1 = fb.topline + fb.row
     77A8 2004 
     77AA 8350 
0094 77AC A820  54         a     @fb.row,@parm1        ;
     77AE 2006 
     77B0 8350 
0095 77B2 C804  38         mov   tmp0,@rambuf+4        ; Save length of line
     77B4 8394 
0096 77B6 1607  14         jne   edb.line.pack.idx.normal
0097                                                   ; tmp0 != 0 ?
0098                       ;------------------------------------------------------
0099                       ; Special handling if empty line (length=0)
0100                       ;------------------------------------------------------
0101 77B8 04E0  34         clr   @parm2                ; Set pointer to >0000
     77BA 8352 
0102 77BC 04E0  34         clr   @parm3                ; Set length of line = 0
     77BE 8354 
0103 77C0 06A0  32         bl    @idx.entry.update     ; parm1=fb.topline + fb.row
     77C2 76A2 
0104 77C4 101F  14         jmp   edb.line.pack.$$      ; Exit
0105                       ;------------------------------------------------------
0106                       ; Update index and store line in editor buffer
0107                       ;------------------------------------------------------
0108               edb.line.pack.idx.normal:
0109 77C6 C820  54         mov   @edb.next_free,@parm2 ; Block where packed string will reside
     77C8 210A 
     77CA 8352 
0110 77CC C1A0  34         mov   @rambuf+4,tmp2        ; Number of bytes to copy
     77CE 8394 
0111 77D0 C804  38         mov   tmp0,@parm3           ; Set length of line
     77D2 8354 
0112 77D4 06A0  32         bl    @idx.entry.update     ; parm1=fb.topline + fb.row
     77D6 76A2 
0113                       ;------------------------------------------------------
0114                       ; Pack line from framebuffer to editor buffer
0115                       ;------------------------------------------------------
0116 77D8 C120  34         mov   @rambuf+2,tmp0        ; Source for memory copy
     77DA 8392 
0117 77DC C160  34         mov   @edb.next_free,tmp1   ; Destination for memory copy
     77DE 210A 
0118 77E0 C1A0  34         mov   @rambuf+4,tmp2        ; Number of bytes to copy
     77E2 8394 
0119                       ;------------------------------------------------------
0120                       ; Pack line from framebuffer to editor buffer
0121                       ;------------------------------------------------------
0122 77E4 C120  34         mov   @rambuf+2,tmp0        ; Source for memory copy
     77E6 8392 
0123 77E8 0286  22         ci    tmp2,2
     77EA 0002 
0124 77EC 1506  14         jgt   edb.line.pack.idx.normal.copy
0125                       ;------------------------------------------------------
0126                       ; Special handling 1-2 bytes copy
0127                       ;------------------------------------------------------
0128 77EE C554  38         mov   *tmp0,*tmp1           ; Copy word
0129 77F0 0204  20         li    tmp0,2                ; Set length=2
     77F2 0002 
0130 77F4 A804  38         a     tmp0,@edb.next_free   ; Update pointer to next free block
     77F6 210A 
0131 77F8 1005  14         jmp   edb.line.pack.$$      ; Exit
0132                       ;------------------------------------------------------
0133                       ; Copy memory block
0134                       ;------------------------------------------------------
0135               edb.line.pack.idx.normal.copy:
0136 77FA 06A0  32         bl    @xpym2m               ; Copy memory block
     77FC 62A2 
0137                                                   ;   tmp0 = source
0138                                                   ;   tmp1 = destination
0139                                                   ;   tmp2 = bytes to copy
0140 77FE A820  54         a     @rambuf+4,@edb.next_free
     7800 8394 
     7802 210A 
0141                                                   ; Update pointer to next free block
0142                       ;------------------------------------------------------
0143                       ; Exit
0144                       ;------------------------------------------------------
0145               edb.line.pack.$$:
0146 7804 C820  54         mov   @rambuf,@fb.column    ; Retrieve @fb.column
     7806 8390 
     7808 200C 
0147 780A 0460  28         b     @poprt                ; Return to caller
     780C 6092 
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
0174 780E 0649  14         dect  stack
0175 7810 C64B  30         mov   r11,*stack            ; Save return address
0176                       ;------------------------------------------------------
0177                       ; Save parameters
0178                       ;------------------------------------------------------
0179 7812 C820  54         mov   @parm1,@rambuf
     7814 8350 
     7816 8390 
0180 7818 C820  54         mov   @parm2,@rambuf+2
     781A 8352 
     781C 8392 
0181                       ;------------------------------------------------------
0182                       ; Calculate offset in frame buffer
0183                       ;------------------------------------------------------
0184 781E C120  34         mov   @fb.colsline,tmp0
     7820 200E 
0185 7822 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
     7824 8352 
0186 7826 C1A0  34         mov   @fb.top.ptr,tmp2
     7828 2000 
0187 782A A146  18         a     tmp2,tmp1             ; Add base to offset
0188 782C C805  38         mov   tmp1,@rambuf+6        ; Destination row in frame buffer
     782E 8396 
0189                       ;------------------------------------------------------
0190                       ; Get length of line to unpack
0191                       ;------------------------------------------------------
0192 7830 06A0  32         bl    @edb.line.getlength   ; Get length of line
     7832 787C 
0193                                                   ; parm1 = Line number
0194 7834 C820  54         mov   @outparm1,@rambuf+8   ; Bytes to copy
     7836 8360 
     7838 8398 
0195 783A 1312  14         jeq   edb.line.unpack.clear ; Clear line if length=0
0196                       ;------------------------------------------------------
0197                       ; Index. Calculate address of entry and get pointer
0198                       ;------------------------------------------------------
0199 783C 06A0  32         bl    @idx.pointer.get      ; Get pointer to editor buffer entry
     783E 773E 
0200                                                   ; parm1 = Line number
0201 7840 C820  54         mov   @outparm1,@rambuf+4   ; Source memory address in editor buffer
     7842 8360 
     7844 8394 
0202                       ;------------------------------------------------------
0203                       ; Copy line from editor buffer to frame buffer
0204                       ;------------------------------------------------------
0205               edb.line.unpack.copy:
0206 7846 C120  34         mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
     7848 8394 
0207 784A C160  34         mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
     784C 8396 
0208 784E C1A0  34         mov   @rambuf+8,tmp2        ; Bytes to copy
     7850 8398 
0209               
0210 7852 0286  22         ci    tmp2,2
     7854 0002 
0211 7856 1203  14         jle   edb.line.unpack.copy.word
0212                       ;------------------------------------------------------
0213                       ; Copy memory block
0214                       ;------------------------------------------------------
0215 7858 06A0  32         bl    @xpym2m               ; Copy line to frame buffer
     785A 62A2 
0216                                                   ;   tmp0 = Source address
0217                                                   ;   tmp1 = Target address
0218                                                   ;   tmp2 = Bytes to copy
0219 785C 1001  14         jmp   edb.line.unpack.clear
0220                       ;------------------------------------------------------
0221                       ; Copy single word
0222                       ;------------------------------------------------------
0223               edb.line.unpack.copy.word:
0224 785E C554  38         mov   *tmp0,*tmp1           ; Copy word
0225                       ;------------------------------------------------------
0226                       ; Clear rest of row in framebuffer
0227                       ;------------------------------------------------------
0228               edb.line.unpack.clear:
0229 7860 C120  34         mov   @rambuf+6,tmp0        ; Start of row in frame buffer
     7862 8396 
0230 7864 A120  34         a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer
     7866 8398 
0231 7868 0584  14         inc   tmp0                  ; Don't erase last character
0232 786A 04C5  14         clr   tmp1                  ; Fill with >00
0233 786C C1A0  34         mov   @fb.colsline,tmp2
     786E 200E 
0234 7870 61A0  34         s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
     7872 8398 
0235 7874 06A0  32         bl    @xfilm                ; Clear rest of row
     7876 609C 
0236                       ;------------------------------------------------------
0237                       ; Exit
0238                       ;------------------------------------------------------
0239               edb.line.unpack.$$:
0240 7878 0460  28         b     @poprt                ; Return to caller
     787A 6092 
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
0261 787C 0649  14         dect  stack
0262 787E C64B  30         mov   r11,*stack            ; Save return address
0263                       ;------------------------------------------------------
0264                       ; Get length
0265                       ;------------------------------------------------------
0266 7880 C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     7882 200C 
     7884 8390 
0267 7886 C120  34         mov   @parm1,tmp0           ; Get specified line
     7888 8350 
0268 788A 0A24  56         sla   tmp0,2                ; Line number * 4
0269 788C C164  34         mov   @idx.top+2(tmp0),tmp1 ; Get index entry line length
     788E 2202 
0270 7890 0245  22         andi  tmp1,>00ff            ; Get rid of packed length
     7892 00FF 
0271 7894 C805  38         mov   tmp1,@outparm1        ; Save line length
     7896 8360 
0272                       ;------------------------------------------------------
0273                       ; Exit
0274                       ;------------------------------------------------------
0275               edb.line.getlength.$$:
0276 7898 0460  28         b     @poprt                ; Return to caller
     789A 6092 
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
0297 789C 0649  14         dect  stack
0298 789E C64B  30         mov   r11,*stack            ; Save return address
0299                       ;------------------------------------------------------
0300                       ; Get length
0301                       ;------------------------------------------------------
0302 78A0 C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     78A2 200C 
     78A4 8390 
0303 78A6 C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     78A8 2004 
0304 78AA A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     78AC 2006 
0305 78AE 0A24  56         sla   tmp0,2                ; Line number * 4
0306 78B0 C164  34         mov   @idx.top+2(tmp0),tmp1 ; Get index entry line length
     78B2 2202 
0307 78B4 0245  22         andi  tmp1,>00ff            ; Get rid of SAMS page
     78B6 00FF 
0308 78B8 C805  38         mov   tmp1,@fb.row.length   ; Save row length
     78BA 2008 
0309                       ;------------------------------------------------------
0310                       ; Exit
0311                       ;------------------------------------------------------
0312               edb.line.getlength2.$$:
0313 78BC 0460  28         b     @poprt                ; Return to caller
     78BE 6092 
0314               
**** **** ****     > tivi.asm.2077
0521               
0522               
0523               ***************************************************************
0524               *                      Constants
0525               ***************************************************************
0526               romsat:
0527 78C0 0303             data >0303,>000f              ; Cursor YX, shape and colour
     78C2 000F 
0528               
0529               cursors:
0530 78C4 0000             data >0000,>0000,>0000,>001c  ; Cursor 1 - Insert mode
     78C6 0000 
     78C8 0000 
     78CA 001C 
0531 78CC 1010             data >1010,>1010,>1010,>1000  ; Cursor 2 - Insert mode
     78CE 1010 
     78D0 1010 
     78D2 1000 
0532 78D4 1C1C             data >1c1c,>1c1c,>1c1c,>1c00  ; Cursor 3 - Overwrite mode
     78D6 1C1C 
     78D8 1C1C 
     78DA 1C00 
0533               
0534               ***************************************************************
0535               *                       Strings
0536               ***************************************************************
0537               txt_title
0538 78DC 1054             byte  16
0539 78DD ....             text  'TIVI 191019-2077'
0540                       even
0541               
0542               txt_delim
0543 78EE 012C             byte  1
0544 78EF ....             text  ','
0545                       even
0546               
0547               txt_marker
0548 78F0 052A             byte  5
0549 78F1 ....             text  '*EOF*'
0550                       even
0551               
0552               txt_bottom
0553 78F6 0520             byte  5
0554 78F7 ....             text  '  BOT'
0555                       even
0556               
0557               txt_ovrwrite
0558 78FC 0320             byte  3
0559 78FD ....             text  '   '
0560                       even
0561               
0562               txt_insert
0563 7900 0349             byte  3
0564 7901 ....             text  'INS'
0565                       even
0566               
0567 7904 7904     end          data    $

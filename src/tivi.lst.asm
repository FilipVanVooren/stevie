XAS99 CROSS-ASSEMBLER   VERSION 1.7.0
**** **** ****     > tivi.asm.32581
0001               ***************************************************************
0002               *
0003               *                          TiVi Editor
0004               *
0005               *                (c)2018-2019 // Filip van Vooren
0006               *
0007               ***************************************************************
0008               * File: tivi.asm                    ; Version 191020-32581
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
0038      0001     skip_iosupport          equ  1      ; Skip support for file I/O, dsrlnk
0039               
0040               *--------------------------------------------------------------
0041               * Cartridge header
0042               *--------------------------------------------------------------
0043 6000 AA01     grmhdr  byte  >aa,1,1,0,0,0
     6002 0100 
     6004 0000 
0044 6006 6010             data  prog0
0045 6008 0000             byte  0,0,0,0,0,0,0,0
     600A 0000 
     600C 0000 
     600E 0000 
0046 6010 0000     prog0   data  0                     ; No more items following
0047 6012 6D0A             data  runlib
0048               
0050               
0051 6014 1154             byte  17
0052 6015 ....             text  'TIVI 191020-32581'
0053                       even
0054               
0062               *--------------------------------------------------------------
0063               * Include required files
0064               *--------------------------------------------------------------
0065                       copy  "/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
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
0083                       copy  "config.equ"               ; Equates for bits in config register
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
0027      6042     palon   equ   wbit2                 ; bit 2=1   (VDP9918 PAL version)
0028      6038     enusr   equ   wbit7                 ; bit 7=1   (Enable user hook)
0029      6034     enknl   equ   wbit9                 ; bit 9=1   (Enable kernel thread)
0030      6032     tms5200 equ   wbit10                ; bit 10=1  (Speech Synthesizer present)
0031      6030     anykey  equ   wbit11                ; BIT 11 in the CONFIG register
0032               ***************************************************************
0033               
**** **** ****     > runlib.asm
0084                       copy  "cpu_crash_hndlr.asm"      ; CPU program crashed handler
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
0018 604C 0420  54 crash   blwp  @>0000                ; Soft-reset
     604E 0000 
**** **** ****     > runlib.asm
0085                       copy  "vdp_tables.asm"           ; Data used by runtime library
**** **** ****     > vdp_tables.asm
0001               * FILE......: vdp_tables.a99
0002               * Purpose...: Video mode tables
0003               
0004               ***************************************************************
0005               * Graphics mode 1 (32 columns/24 rows)
0006               *--------------------------------------------------------------
0007 6050 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     6052 000E 
     6054 0106 
     6056 0205 
     6058 0020 
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
0032 605A 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     605C 000E 
     605E 0106 
     6060 00F5 
     6062 0028 
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
0058 6064 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     6066 003F 
     6068 0240 
     606A 03F5 
     606C 0050 
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
0084 606E 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     6070 003F 
     6072 0240 
     6074 03F5 
     6076 0050 
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
0013 6078 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 607A 16FD             data  >16fd                 ; |         jne   mcloop
0015 607C 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 607E D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 6080 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
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
0038 6082 C0F9  30 popr3   mov   *stack+,r3
0039 6084 C0B9  30 popr2   mov   *stack+,r2
0040 6086 C079  30 popr1   mov   *stack+,r1
0041 6088 C039  30 popr0   mov   *stack+,r0
0042 608A C2F9  30 poprt   mov   *stack+,r11
0043 608C 045B  20         b     *r11
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
0067 608E C13B  30 film    mov   *r11+,tmp0            ; Memory start
0068 6090 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0069 6092 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0070               *--------------------------------------------------------------
0071               * Fill memory with 16 bit words
0072               *--------------------------------------------------------------
0073 6094 C1C6  18 xfilm   mov   tmp2,tmp3
0074 6096 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     6098 0001 
0075               
0076 609A 1301  14         jeq   film1
0077 609C 0606  14         dec   tmp2                  ; Make TMP2 even
0078 609E D820  54 film1   movb  @tmp1lb,@tmp1hb       ; Duplicate value
     60A0 830B 
     60A2 830A 
0079 60A4 CD05  34 film2   mov   tmp1,*tmp0+
0080 60A6 0646  14         dect  tmp2
0081 60A8 16FD  14         jne   film2
0082               *--------------------------------------------------------------
0083               * Fill last byte if ODD
0084               *--------------------------------------------------------------
0085 60AA C1C7  18         mov   tmp3,tmp3
0086 60AC 1301  14         jeq   filmz
0087 60AE D505  30         movb  tmp1,*tmp0
0088 60B0 045B  20 filmz   b     *r11
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
0107 60B2 C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0108 60B4 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0109 60B6 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0110               *--------------------------------------------------------------
0111               *    Setup VDP write address
0112               *--------------------------------------------------------------
0113 60B8 0264  22 xfilv   ori   tmp0,>4000
     60BA 4000 
0114 60BC 06C4  14         swpb  tmp0
0115 60BE D804  38         movb  tmp0,@vdpa
     60C0 8C02 
0116 60C2 06C4  14         swpb  tmp0
0117 60C4 D804  38         movb  tmp0,@vdpa
     60C6 8C02 
0118               *--------------------------------------------------------------
0119               *    Fill bytes in VDP memory
0120               *--------------------------------------------------------------
0121 60C8 020F  20         li    r15,vdpw              ; Set VDP write address
     60CA 8C00 
0122 60CC 06C5  14         swpb  tmp1
0123 60CE C820  54         mov   @filzz,@mcloop        ; Setup move command
     60D0 60D8 
     60D2 8320 
0124 60D4 0460  28         b     @mcloop               ; Write data to VDP
     60D6 8320 
0125               *--------------------------------------------------------------
0129 60D8 D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
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
0149 60DA 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     60DC 4000 
0150 60DE 06C4  14 vdra    swpb  tmp0
0151 60E0 D804  38         movb  tmp0,@vdpa
     60E2 8C02 
0152 60E4 06C4  14         swpb  tmp0
0153 60E6 D804  38         movb  tmp0,@vdpa            ; Set VDP address
     60E8 8C02 
0154 60EA 045B  20         b     *r11
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
0165 60EC C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0166 60EE C17B  30         mov   *r11+,tmp1
0167 60F0 C18B  18 xvputb  mov   r11,tmp2              ; Save R11
0168 60F2 06A0  32         bl    @vdwa                 ; Set VDP write address
     60F4 60DA 
0169               
0170 60F6 06C5  14         swpb  tmp1                  ; Get byte to write
0171 60F8 D7C5  30         movb  tmp1,*r15             ; Write byte
0172 60FA 0456  20         b     *tmp2                 ; Exit
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
0183 60FC C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0184 60FE C18B  18 xvgetb  mov   r11,tmp2              ; Save R11
0185 6100 06A0  32         bl    @vdra                 ; Set VDP read address
     6102 60DE 
0186               
0187 6104 D120  34         movb  @vdpr,tmp0            ; Read byte
     6106 8800 
0188               
0189 6108 0984  56         srl   tmp0,8                ; Right align
0190 610A 0456  20         b     *tmp2                 ; Exit
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
0209 610C C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0210 610E C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0211               *--------------------------------------------------------------
0212               * Calculate PNT base address
0213               *--------------------------------------------------------------
0214 6110 C144  18         mov   tmp0,tmp1
0215 6112 05C5  14         inct  tmp1
0216 6114 D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0217 6116 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     6118 FF00 
0218 611A 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0219 611C C805  38         mov   tmp1,@wbase           ; Store calculated base
     611E 8328 
0220               *--------------------------------------------------------------
0221               * Dump VDP shadow registers
0222               *--------------------------------------------------------------
0223 6120 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     6122 8000 
0224 6124 0206  20         li    tmp2,8
     6126 0008 
0225 6128 D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     612A 830B 
0226 612C 06C5  14         swpb  tmp1
0227 612E D805  38         movb  tmp1,@vdpa
     6130 8C02 
0228 6132 06C5  14         swpb  tmp1
0229 6134 D805  38         movb  tmp1,@vdpa
     6136 8C02 
0230 6138 0225  22         ai    tmp1,>0100
     613A 0100 
0231 613C 0606  14         dec   tmp2
0232 613E 16F4  14         jne   vidta1                ; Next register
0233 6140 C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     6142 833A 
0234 6144 045B  20         b     *r11
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
0251 6146 C13B  30 putvr   mov   *r11+,tmp0
0252 6148 0264  22 putvrx  ori   tmp0,>8000
     614A 8000 
0253 614C 06C4  14         swpb  tmp0
0254 614E D804  38         movb  tmp0,@vdpa
     6150 8C02 
0255 6152 06C4  14         swpb  tmp0
0256 6154 D804  38         movb  tmp0,@vdpa
     6156 8C02 
0257 6158 045B  20         b     *r11
0258               
0259               
0260               ***************************************************************
0261               * PUTV01  - Put VDP registers #0 and #1
0262               ***************************************************************
0263               *  BL   @PUTV01
0264               ********@*****@*********************@**************************
0265 615A C20B  18 putv01  mov   r11,tmp4              ; Save R11
0266 615C C10E  18         mov   r14,tmp0
0267 615E 0984  56         srl   tmp0,8
0268 6160 06A0  32         bl    @putvrx               ; Write VR#0
     6162 6148 
0269 6164 0204  20         li    tmp0,>0100
     6166 0100 
0270 6168 D820  54         movb  @r14lb,@tmp0lb
     616A 831D 
     616C 8309 
0271 616E 06A0  32         bl    @putvrx               ; Write VR#1
     6170 6148 
0272 6172 0458  20         b     *tmp4                 ; Exit
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
0286 6174 C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0287 6176 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0288 6178 C11B  26         mov   *r11,tmp0             ; Get P0
0289 617A 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     617C 7FFF 
0290 617E 2120  38         coc   @wbit0,tmp0
     6180 6046 
0291 6182 1604  14         jne   ldfnt1
0292 6184 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     6186 8000 
0293 6188 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     618A 7FFF 
0294               *--------------------------------------------------------------
0295               * Read font table address from GROM into tmp1
0296               *--------------------------------------------------------------
0297 618C C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     618E 61F6 
0298 6190 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     6192 9C02 
0299 6194 06C4  14         swpb  tmp0
0300 6196 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     6198 9C02 
0301 619A D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     619C 9800 
0302 619E 06C5  14         swpb  tmp1
0303 61A0 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     61A2 9800 
0304 61A4 06C5  14         swpb  tmp1
0305               *--------------------------------------------------------------
0306               * Setup GROM source address from tmp1
0307               *--------------------------------------------------------------
0308 61A6 D805  38         movb  tmp1,@grmwa
     61A8 9C02 
0309 61AA 06C5  14         swpb  tmp1
0310 61AC D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     61AE 9C02 
0311               *--------------------------------------------------------------
0312               * Setup VDP target address
0313               *--------------------------------------------------------------
0314 61B0 C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0315 61B2 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     61B4 60DA 
0316 61B6 05C8  14         inct  tmp4                  ; R11=R11+2
0317 61B8 C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0318 61BA 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     61BC 7FFF 
0319 61BE C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     61C0 61F8 
0320 61C2 C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     61C4 61FA 
0321               *--------------------------------------------------------------
0322               * Copy from GROM to VRAM
0323               *--------------------------------------------------------------
0324 61C6 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0325 61C8 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0326 61CA D120  34         movb  @grmrd,tmp0
     61CC 9800 
0327               *--------------------------------------------------------------
0328               *   Make font fat
0329               *--------------------------------------------------------------
0330 61CE 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     61D0 6046 
0331 61D2 1603  14         jne   ldfnt3                ; No, so skip
0332 61D4 D1C4  18         movb  tmp0,tmp3
0333 61D6 0917  56         srl   tmp3,1
0334 61D8 E107  18         soc   tmp3,tmp0
0335               *--------------------------------------------------------------
0336               *   Dump byte to VDP and do housekeeping
0337               *--------------------------------------------------------------
0338 61DA D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     61DC 8C00 
0339 61DE 0606  14         dec   tmp2
0340 61E0 16F2  14         jne   ldfnt2
0341 61E2 05C8  14         inct  tmp4                  ; R11=R11+2
0342 61E4 020F  20         li    r15,vdpw              ; Set VDP write address
     61E6 8C00 
0343 61E8 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     61EA 7FFF 
0344 61EC 0458  20         b     *tmp4                 ; Exit
0345 61EE D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     61F0 6026 
     61F2 8C00 
0346 61F4 10E8  14         jmp   ldfnt2
0347               *--------------------------------------------------------------
0348               * Fonts pointer table
0349               *--------------------------------------------------------------
0350 61F6 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     61F8 0200 
     61FA 0000 
0351 61FC 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     61FE 01C0 
     6200 0101 
0352 6202 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     6204 02A0 
     6206 0101 
0353 6208 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     620A 00E0 
     620C 0101 
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
0371 620E C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0372 6210 C3A0  34         mov   @wyx,r14              ; Get YX
     6212 832A 
0373 6214 098E  56         srl   r14,8                 ; Right justify (remove X)
0374 6216 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     6218 833A 
0375               *--------------------------------------------------------------
0376               * Do rest of calculation with R15 (16 bit part is there)
0377               * Re-use R14
0378               *--------------------------------------------------------------
0379 621A C3A0  34         mov   @wyx,r14              ; Get YX
     621C 832A 
0380 621E 024E  22         andi  r14,>00ff             ; Remove Y
     6220 00FF 
0381 6222 A3CE  18         a     r14,r15               ; pos = pos + X
0382 6224 A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     6226 8328 
0383               *--------------------------------------------------------------
0384               * Clean up before exit
0385               *--------------------------------------------------------------
0386 6228 C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0387 622A C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0388 622C 020F  20         li    r15,vdpw              ; VDP write address
     622E 8C00 
0389 6230 045B  20         b     *r11
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
0404 6232 C17B  30 putstr  mov   *r11+,tmp1
0405 6234 D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0406 6236 C1CB  18 xutstr  mov   r11,tmp3
0407 6238 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     623A 620E 
0408 623C C2C7  18         mov   tmp3,r11
0409 623E 0986  56         srl   tmp2,8                ; Right justify length byte
0410 6240 0460  28         b     @xpym2v               ; Display string
     6242 6252 
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
0425 6244 C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     6246 832A 
0426 6248 0460  28         b     @putstr
     624A 6232 
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
0020 624C C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 624E C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 6250 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP write address
0025               *--------------------------------------------------------------
0026 6252 0264  22 xpym2v  ori   tmp0,>4000
     6254 4000 
0027 6256 06C4  14         swpb  tmp0
0028 6258 D804  38         movb  tmp0,@vdpa
     625A 8C02 
0029 625C 06C4  14         swpb  tmp0
0030 625E D804  38         movb  tmp0,@vdpa
     6260 8C02 
0031               *--------------------------------------------------------------
0032               *    Copy bytes from CPU memory to VRAM
0033               *--------------------------------------------------------------
0034 6262 020F  20         li    r15,vdpw              ; Set VDP write address
     6264 8C00 
0035 6266 C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     6268 6270 
     626A 8320 
0036 626C 0460  28         b     @mcloop               ; Write data to VDP
     626E 8320 
0037 6270 D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
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
0020 6272 C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 6274 C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 6276 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 6278 06C4  14 xpyv2m  swpb  tmp0
0027 627A D804  38         movb  tmp0,@vdpa
     627C 8C02 
0028 627E 06C4  14         swpb  tmp0
0029 6280 D804  38         movb  tmp0,@vdpa
     6282 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 6284 020F  20         li    r15,vdpr              ; Set VDP read address
     6286 8800 
0034 6288 C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     628A 6292 
     628C 8320 
0035 628E 0460  28         b     @mcloop               ; Read data from VDP
     6290 8320 
0036 6292 DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
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
0024 6294 C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 6296 C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 6298 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 629A C186  18 xpym2m  mov    tmp2,tmp2            ; Bytes to copy = 0 ?
0031 629C 1602  14         jne    cpym0
0032 629E 0460  28         b      @crash               ; Yes, crash
     62A0 604C 
0033 62A2 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     62A4 7FFF 
0034 62A6 C1C4  18         mov   tmp0,tmp3
0035 62A8 0247  22         andi  tmp3,1
     62AA 0001 
0036 62AC 1618  14         jne   cpyodd                ; Odd source address handling
0037 62AE C1C5  18 cpym1   mov   tmp1,tmp3
0038 62B0 0247  22         andi  tmp3,1
     62B2 0001 
0039 62B4 1614  14         jne   cpyodd                ; Odd target address handling
0040               *--------------------------------------------------------------
0041               * 8 bit copy
0042               *--------------------------------------------------------------
0043 62B6 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     62B8 6046 
0044 62BA 1605  14         jne   cpym3
0045 62BC C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     62BE 62E4 
     62C0 8320 
0046 62C2 0460  28         b     @mcloop               ; Copy memory and exit
     62C4 8320 
0047               *--------------------------------------------------------------
0048               * 16 bit copy
0049               *--------------------------------------------------------------
0050 62C6 C1C6  18 cpym3   mov   tmp2,tmp3
0051 62C8 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     62CA 0001 
0052 62CC 1301  14         jeq   cpym4
0053 62CE 0606  14         dec   tmp2                  ; Make TMP2 even
0054 62D0 CD74  46 cpym4   mov   *tmp0+,*tmp1+
0055 62D2 0646  14         dect  tmp2
0056 62D4 16FD  14         jne   cpym4
0057               *--------------------------------------------------------------
0058               * Copy last byte if ODD
0059               *--------------------------------------------------------------
0060 62D6 C1C7  18         mov   tmp3,tmp3
0061 62D8 1301  14         jeq   cpymz
0062 62DA D554  38         movb  *tmp0,*tmp1
0063 62DC 045B  20 cpymz   b     *r11
0064               *--------------------------------------------------------------
0065               * Handle odd source/target address
0066               *--------------------------------------------------------------
0067 62DE 0262  22 cpyodd  ori   config,>8000        ; Set CONFIG bot 0
     62E0 8000 
0068 62E2 10E9  14         jmp   cpym2
0069 62E4 DD74     tmp011  data  >dd74               ; MOVB *TMP0+,*TMP1+
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
0009 62E6 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     62E8 FFBF 
0010 62EA 0460  28         b     @putv01
     62EC 615A 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********@*****@*********************@**************************
0017 62EE 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     62F0 0040 
0018 62F2 0460  28         b     @putv01
     62F4 615A 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********@*****@*********************@**************************
0025 62F6 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     62F8 FFDF 
0026 62FA 0460  28         b     @putv01
     62FC 615A 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********@*****@*********************@**************************
0033 62FE 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     6300 0020 
0034 6302 0460  28         b     @putv01
     6304 615A 
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
0010 6306 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     6308 FFFE 
0011 630A 0460  28         b     @putv01
     630C 615A 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********@*****@*********************@**************************
0018 630E 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     6310 0001 
0019 6312 0460  28         b     @putv01
     6314 615A 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********@*****@*********************@**************************
0026 6316 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     6318 FFFD 
0027 631A 0460  28         b     @putv01
     631C 615A 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********@*****@*********************@**************************
0034 631E 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     6320 0002 
0035 6322 0460  28         b     @putv01
     6324 615A 
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
0018 6326 C83B  50 at      mov   *r11+,@wyx
     6328 832A 
0019 632A 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********@*****@*********************@**************************
0027 632C B820  54 down    ab    @hb$01,@wyx
     632E 6038 
     6330 832A 
0028 6332 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********@*****@*********************@**************************
0036 6334 7820  54 up      sb    @hb$01,@wyx
     6336 6038 
     6338 832A 
0037 633A 045B  20         b     *r11
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
0049 633C C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 633E D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     6340 832A 
0051 6342 C804  38         mov   tmp0,@wyx             ; Save as new YX position
     6344 832A 
0052 6346 045B  20         b     *r11
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
0021 6348 C120  34 yx2px   mov   @wyx,tmp0
     634A 832A 
0022 634C C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 634E 06C4  14         swpb  tmp0                  ; Y<->X
0024 6350 04C5  14         clr   tmp1                  ; Clear before copy
0025 6352 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 6354 20A0  38         coc   @wbit1,config         ; f18a present ?
     6356 6044 
0030 6358 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 635A 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     635C 833A 
     635E 6388 
0032 6360 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 6362 0A15  56         sla   tmp1,1                ; X = X * 2
0035 6364 B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 6366 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     6368 0500 
0037 636A 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 636C D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 636E 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 6370 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 6372 D105  18         movb  tmp1,tmp0
0051 6374 06C4  14         swpb  tmp0                  ; X<->Y
0052 6376 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     6378 6046 
0053 637A 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 637C 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     637E 6038 
0059 6380 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     6382 604A 
0060 6384 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 6386 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 6388 0050            data   80
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
0013 638A C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 638C 06A0  32         bl    @putvr                ; Write once
     638E 6146 
0015 6390 391C             data  >391c                 ; VR1/57, value 00011100
0016 6392 06A0  32         bl    @putvr                ; Write twice
     6394 6146 
0017 6396 391C             data  >391c                 ; VR1/57, value 00011100
0018 6398 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********@*****@*********************@**************************
0026 639A C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 639C 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     639E 6146 
0028 63A0 391C             data  >391c
0029 63A2 0458  20         b     *tmp4                 ; Exit
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
0040 63A4 C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 63A6 06A0  32         bl    @cpym2v
     63A8 624C 
0042 63AA 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     63AC 63E8 
     63AE 0006 
0043 63B0 06A0  32         bl    @putvr
     63B2 6146 
0044 63B4 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 63B6 06A0  32         bl    @putvr
     63B8 6146 
0046 63BA 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 63BC 0204  20         li    tmp0,>3f00
     63BE 3F00 
0052 63C0 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     63C2 60DE 
0053 63C4 D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     63C6 8800 
0054 63C8 0984  56         srl   tmp0,8
0055 63CA D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     63CC 8800 
0056 63CE C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 63D0 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 63D2 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     63D4 BFFF 
0060 63D6 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 63D8 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     63DA 4000 
0063               f18chk_exit:
0064 63DC 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     63DE 60B2 
0065 63E0 3F00             data  >3f00,>00,6
     63E2 0000 
     63E4 0006 
0066 63E6 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********@*****@*********************@**************************
0070               f18chk_gpu
0071 63E8 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 63EA 3F00             data  >3f00                 ; 3f02 / 3f00
0073 63EC 0340             data  >0340                 ; 3f04   0340  idle
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
0092 63EE C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0093                       ;------------------------------------------------------
0094                       ; Reset all F18a VDP registers to power-on defaults
0095                       ;------------------------------------------------------
0096 63F0 06A0  32         bl    @putvr
     63F2 6146 
0097 63F4 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0098               
0099 63F6 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     63F8 6146 
0100 63FA 391C             data  >391c                 ; Lock the F18a
0101 63FC 0458  20         b     *tmp4                 ; Exit
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
0120 63FE C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0121 6400 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     6402 6044 
0122 6404 1609  14         jne   f18fw1
0123               ***************************************************************
0124               * Read F18A major/minor version
0125               ***************************************************************
0126 6406 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     6408 8802 
0127 640A 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     640C 6146 
0128 640E 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0129 6410 04C4  14         clr   tmp0
0130 6412 D120  34         movb  @vdps,tmp0
     6414 8802 
0131 6416 0984  56         srl   tmp0,8
0132 6418 0458  20 f18fw1  b     *tmp4                 ; Exit
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
0016 641A 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     641C 6046 
0017 641E 020C  20         li    r12,>0024
     6420 0024 
0018 6422 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     6424 64B2 
0019 6426 04C6  14         clr   tmp2
0020 6428 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 642A 04CC  14         clr   r12
0025 642C 1F08  20         tb    >0008                 ; Shift-key ?
0026 642E 1302  14         jeq   realk1                ; No
0027 6430 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     6432 64E2 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 6434 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 6436 1302  14         jeq   realk2                ; No
0033 6438 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     643A 6512 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 643C 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 643E 1302  14         jeq   realk3                ; No
0039 6440 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     6442 6542 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 6444 1E15  20 realk3  sbz   >0015                 ; Set P5
0044 6446 1F07  20         tb    >0007                 ; ALPHA-Lock key ?
0045 6448 1302  14         jeq   realk4                ; No,  CONFIG register bit 0 = 0
0046 644A E0A0  34         soc   @wbit0,config         ; Yes, CONFIG register bit 0 = 1
     644C 6046 
0047               *--------------------------------------------------------------
0048               * Scan keyboard column
0049               *--------------------------------------------------------------
0050 644E 1D15  20 realk4  sbo   >0015                 ; Reset P5
0051 6450 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     6452 0006 
0052 6454 0606  14 realk5  dec   tmp2
0053 6456 020C  20         li    r12,>24               ; CRU address for P2-P4
     6458 0024 
0054 645A 06C6  14         swpb  tmp2
0055 645C 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0056 645E 06C6  14         swpb  tmp2
0057 6460 020C  20         li    r12,6                 ; CRU read address
     6462 0006 
0058 6464 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0059 6466 0547  14         inv   tmp3                  ;
0060 6468 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     646A FF00 
0061               *--------------------------------------------------------------
0062               * Scan keyboard row
0063               *--------------------------------------------------------------
0064 646C 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0065 646E 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombinations scanned by shifting left.
0066 6470 1807  14         joc   realk8                ; If no carry after 8 loops, then it means no key
0067 6472 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0068 6474 0285  22         ci    tmp1,8
     6476 0008 
0069 6478 1AFA  14         jl    realk6
0070 647A C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0071 647C 1BEB  14         jh    realk5                ; No, next column
0072 647E 1016  14         jmp   realkz                ; Yes, exit
0073               *--------------------------------------------------------------
0074               * Check for match in data table
0075               *--------------------------------------------------------------
0076 6480 C206  18 realk8  mov   tmp2,tmp4
0077 6482 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0078 6484 A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0079 6486 A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base address of data table (R15)
0080 6488 D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0081 648A 13F3  14         jeq   realk7                ; Yes, then discard and continue scanning (FCTN, SHIFT, CTRL)
0082               *--------------------------------------------------------------
0083               * Determine ASCII value of key
0084               *--------------------------------------------------------------
0085 648C D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0086 648E 20A0  38         coc   @wbit0,config         ; ALPHA-Lock key pressed ?
     6490 6046 
0087 6492 1608  14         jne   realka                ; No, continue saving key
0088 6494 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     6496 64DC 
0089 6498 1A05  14         jl    realka
0090 649A 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     649C 64DA 
0091 649E 1B02  14         jh    realka                ; No, continue
0092 64A0 0226  22         ai    tmp2,->2000           ; ASCII = ASCII - 32 (lowercase to uppercase!)
     64A2 E000 
0093 64A4 C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     64A6 833C 
0094 64A8 E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     64AA 6030 
0095 64AC 020F  20 realkz  li    r15,vdpw              ; Setup VDP write address again after using R15 as temp storage
     64AE 8C00 
0096 64B0 045B  20         b     *r11                  ; Exit
0097               ********@*****@*********************@**************************
0098 64B2 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     64B4 0000 
     64B6 FF0D 
     64B8 203D 
0099 64BA ....             text  'xws29ol.'
0100 64C2 ....             text  'ced38ik,'
0101 64CA ....             text  'vrf47ujm'
0102 64D2 ....             text  'btg56yhn'
0103 64DA ....             text  'zqa10p;/'
0104 64E2 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     64E4 0000 
     64E6 FF0D 
     64E8 202B 
0105 64EA ....             text  'XWS@(OL>'
0106 64F2 ....             text  'CED#*IK<'
0107 64FA ....             text  'VRF$&UJM'
0108 6502 ....             text  'BTG%^YHN'
0109 650A ....             text  'ZQA!)P:-'
0110 6512 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     6514 0000 
     6516 FF0D 
     6518 2005 
0111 651A 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     651C 0804 
     651E 0F27 
     6520 C2B9 
0112 6522 600B             data  >600b,>0907,>063f,>c1B8
     6524 0907 
     6526 063F 
     6528 C1B8 
0113 652A 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     652C 7B02 
     652E 015F 
     6530 C0C3 
0114 6532 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     6534 7D0E 
     6536 0CC6 
     6538 BFC4 
0115 653A 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     653C 7C03 
     653E BC22 
     6540 BDBA 
0116 6542 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     6544 0000 
     6546 FF0D 
     6548 209D 
0117 654A 9897             data  >9897,>93b2,>9f8f,>8c9B
     654C 93B2 
     654E 9F8F 
     6550 8C9B 
0118 6552 8385             data  >8385,>84b3,>9e89,>8b80
     6554 84B3 
     6556 9E89 
     6558 8B80 
0119 655A 9692             data  >9692,>86b4,>b795,>8a8D
     655C 86B4 
     655E B795 
     6560 8A8D 
0120 6562 8294             data  >8294,>87b5,>b698,>888E
     6564 87B5 
     6566 B698 
     6568 888E 
0121 656A 9A91             data  >9a91,>81b1,>b090,>9cBB
     656C 81B1 
     656E B090 
     6570 9CBB 
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
0019 6572 0207  20 mknum   li    tmp3,5                ; Digit counter
     6574 0005 
0020 6576 C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 6578 C155  26         mov   *tmp1,tmp1            ; /
0022 657A C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 657C 0228  22         ai    tmp4,4                ; Get end of buffer
     657E 0004 
0024 6580 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     6582 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 6584 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 6586 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 6588 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 658A B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 658C D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 658E C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for the next digit
0034 6590 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 6592 0607  14         dec   tmp3                  ; Decrease counter
0036 6594 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 6596 0207  20         li    tmp3,4                ; Check first 4 digits
     6598 0004 
0041 659A 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 659C C11B  26         mov   *r11,tmp0
0043 659E 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 65A0 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 65A2 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 65A4 05CB  14 mknum3  inct  r11
0047 65A6 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     65A8 6046 
0048 65AA 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 65AC 045B  20         b     *r11                  ; Exit
0050 65AE DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 65B0 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 65B2 13F8  14         jeq   mknum3                ; Yes, exit
0053 65B4 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 65B6 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     65B8 7FFF 
0058 65BA C10B  18         mov   r11,tmp0
0059 65BC 0224  22         ai    tmp0,-4
     65BE FFFC 
0060 65C0 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 65C2 0206  20         li    tmp2,>0500            ; String length = 5
     65C4 0500 
0062 65C6 0460  28         b     @xutstr               ; Display string
     65C8 6236 
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
0092 65CA C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0093 65CC C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0094 65CE C1BB  30         mov   *r11+,tmp2            ; Get padding character
0095 65D0 06C6  14         swpb  tmp2                  ; LO <-> HI
0096 65D2 0207  20         li    tmp3,5                ; Set counter
     65D4 0005 
0097                       ;------------------------------------------------------
0098                       ; Scan for padding character from left to right
0099                       ;------------------------------------------------------:
0100               trimnum_scan:
0101 65D6 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0102 65D8 1604  14         jne   trimnum_setlen        ; No, exit loop
0103 65DA 0584  14         inc   tmp0                  ; Next character
0104 65DC 0607  14         dec   tmp3                  ; Last digit reached ?
0105 65DE 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0106 65E0 10FA  14         jmp   trimnum_scan
0107                       ;------------------------------------------------------
0108                       ; Scan completed, set length byte new string
0109                       ;------------------------------------------------------
0110               trimnum_setlen:
0111 65E2 06C7  14         swpb  tmp3                  ; LO <-> HI
0112 65E4 DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0113 65E6 06C7  14         swpb  tmp3                  ; LO <-> HI
0114                       ;------------------------------------------------------
0115                       ; Start filling new string
0116                       ;------------------------------------------------------
0117               trimnum_fill
0118 65E8 DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0119 65EA 0607  14         dec   tmp3                  ; Last character ?
0120 65EC 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0121 65EE 045B  20         b     *r11                  ; Return
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
0138 65F0 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     65F2 832A 
0139 65F4 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     65F6 8000 
0140 65F8 10BC  14         jmp   mknum                 ; Convert number and display
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
0021 65FA C820  54         mov   @>8300,@>2000
     65FC 8300 
     65FE 2000 
0022 6600 C820  54         mov   @>8302,@>2002
     6602 8302 
     6604 2002 
0023 6606 C820  54         mov   @>8304,@>2004
     6608 8304 
     660A 2004 
0024 660C C820  54         mov   @>8306,@>2006
     660E 8306 
     6610 2006 
0025 6612 C820  54         mov   @>8308,@>2008
     6614 8308 
     6616 2008 
0026 6618 C820  54         mov   @>830A,@>200A
     661A 830A 
     661C 200A 
0027 661E C820  54         mov   @>830C,@>200C
     6620 830C 
     6622 200C 
0028 6624 C820  54         mov   @>830E,@>200E
     6626 830E 
     6628 200E 
0029 662A C820  54         mov   @>8310,@>2010
     662C 8310 
     662E 2010 
0030 6630 C820  54         mov   @>8312,@>2012
     6632 8312 
     6634 2012 
0031 6636 C820  54         mov   @>8314,@>2014
     6638 8314 
     663A 2014 
0032 663C C820  54         mov   @>8316,@>2016
     663E 8316 
     6640 2016 
0033 6642 C820  54         mov   @>8318,@>2018
     6644 8318 
     6646 2018 
0034 6648 C820  54         mov   @>831A,@>201A
     664A 831A 
     664C 201A 
0035 664E C820  54         mov   @>831C,@>201C
     6650 831C 
     6652 201C 
0036 6654 C820  54         mov   @>831E,@>201E
     6656 831E 
     6658 201E 
0037 665A C820  54         mov   @>8320,@>2020
     665C 8320 
     665E 2020 
0038 6660 C820  54         mov   @>8322,@>2022
     6662 8322 
     6664 2022 
0039 6666 C820  54         mov   @>8324,@>2024
     6668 8324 
     666A 2024 
0040 666C C820  54         mov   @>8326,@>2026
     666E 8326 
     6670 2026 
0041 6672 C820  54         mov   @>8328,@>2028
     6674 8328 
     6676 2028 
0042 6678 C820  54         mov   @>832A,@>202A
     667A 832A 
     667C 202A 
0043 667E C820  54         mov   @>832C,@>202C
     6680 832C 
     6682 202C 
0044 6684 C820  54         mov   @>832E,@>202E
     6686 832E 
     6688 202E 
0045 668A C820  54         mov   @>8330,@>2030
     668C 8330 
     668E 2030 
0046 6690 C820  54         mov   @>8332,@>2032
     6692 8332 
     6694 2032 
0047 6696 C820  54         mov   @>8334,@>2034
     6698 8334 
     669A 2034 
0048 669C C820  54         mov   @>8336,@>2036
     669E 8336 
     66A0 2036 
0049 66A2 C820  54         mov   @>8338,@>2038
     66A4 8338 
     66A6 2038 
0050 66A8 C820  54         mov   @>833A,@>203A
     66AA 833A 
     66AC 203A 
0051 66AE C820  54         mov   @>833C,@>203C
     66B0 833C 
     66B2 203C 
0052 66B4 C820  54         mov   @>833E,@>203E
     66B6 833E 
     66B8 203E 
0053 66BA C820  54         mov   @>8340,@>2040
     66BC 8340 
     66BE 2040 
0054 66C0 C820  54         mov   @>8342,@>2042
     66C2 8342 
     66C4 2042 
0055 66C6 C820  54         mov   @>8344,@>2044
     66C8 8344 
     66CA 2044 
0056 66CC C820  54         mov   @>8346,@>2046
     66CE 8346 
     66D0 2046 
0057 66D2 C820  54         mov   @>8348,@>2048
     66D4 8348 
     66D6 2048 
0058 66D8 C820  54         mov   @>834A,@>204A
     66DA 834A 
     66DC 204A 
0059 66DE C820  54         mov   @>834C,@>204C
     66E0 834C 
     66E2 204C 
0060 66E4 C820  54         mov   @>834E,@>204E
     66E6 834E 
     66E8 204E 
0061 66EA C820  54         mov   @>8350,@>2050
     66EC 8350 
     66EE 2050 
0062 66F0 C820  54         mov   @>8352,@>2052
     66F2 8352 
     66F4 2052 
0063 66F6 C820  54         mov   @>8354,@>2054
     66F8 8354 
     66FA 2054 
0064 66FC C820  54         mov   @>8356,@>2056
     66FE 8356 
     6700 2056 
0065 6702 C820  54         mov   @>8358,@>2058
     6704 8358 
     6706 2058 
0066 6708 C820  54         mov   @>835A,@>205A
     670A 835A 
     670C 205A 
0067 670E C820  54         mov   @>835C,@>205C
     6710 835C 
     6712 205C 
0068 6714 C820  54         mov   @>835E,@>205E
     6716 835E 
     6718 205E 
0069 671A C820  54         mov   @>8360,@>2060
     671C 8360 
     671E 2060 
0070 6720 C820  54         mov   @>8362,@>2062
     6722 8362 
     6724 2062 
0071 6726 C820  54         mov   @>8364,@>2064
     6728 8364 
     672A 2064 
0072 672C C820  54         mov   @>8366,@>2066
     672E 8366 
     6730 2066 
0073 6732 C820  54         mov   @>8368,@>2068
     6734 8368 
     6736 2068 
0074 6738 C820  54         mov   @>836A,@>206A
     673A 836A 
     673C 206A 
0075 673E C820  54         mov   @>836C,@>206C
     6740 836C 
     6742 206C 
0076 6744 C820  54         mov   @>836E,@>206E
     6746 836E 
     6748 206E 
0077 674A C820  54         mov   @>8370,@>2070
     674C 8370 
     674E 2070 
0078 6750 C820  54         mov   @>8372,@>2072
     6752 8372 
     6754 2072 
0079 6756 C820  54         mov   @>8374,@>2074
     6758 8374 
     675A 2074 
0080 675C C820  54         mov   @>8376,@>2076
     675E 8376 
     6760 2076 
0081 6762 C820  54         mov   @>8378,@>2078
     6764 8378 
     6766 2078 
0082 6768 C820  54         mov   @>837A,@>207A
     676A 837A 
     676C 207A 
0083 676E C820  54         mov   @>837C,@>207C
     6770 837C 
     6772 207C 
0084 6774 C820  54         mov   @>837E,@>207E
     6776 837E 
     6778 207E 
0085 677A C820  54         mov   @>8380,@>2080
     677C 8380 
     677E 2080 
0086 6780 C820  54         mov   @>8382,@>2082
     6782 8382 
     6784 2082 
0087 6786 C820  54         mov   @>8384,@>2084
     6788 8384 
     678A 2084 
0088 678C C820  54         mov   @>8386,@>2086
     678E 8386 
     6790 2086 
0089 6792 C820  54         mov   @>8388,@>2088
     6794 8388 
     6796 2088 
0090 6798 C820  54         mov   @>838A,@>208A
     679A 838A 
     679C 208A 
0091 679E C820  54         mov   @>838C,@>208C
     67A0 838C 
     67A2 208C 
0092 67A4 C820  54         mov   @>838E,@>208E
     67A6 838E 
     67A8 208E 
0093 67AA C820  54         mov   @>8390,@>2090
     67AC 8390 
     67AE 2090 
0094 67B0 C820  54         mov   @>8392,@>2092
     67B2 8392 
     67B4 2092 
0095 67B6 C820  54         mov   @>8394,@>2094
     67B8 8394 
     67BA 2094 
0096 67BC C820  54         mov   @>8396,@>2096
     67BE 8396 
     67C0 2096 
0097 67C2 C820  54         mov   @>8398,@>2098
     67C4 8398 
     67C6 2098 
0098 67C8 C820  54         mov   @>839A,@>209A
     67CA 839A 
     67CC 209A 
0099 67CE C820  54         mov   @>839C,@>209C
     67D0 839C 
     67D2 209C 
0100 67D4 C820  54         mov   @>839E,@>209E
     67D6 839E 
     67D8 209E 
0101 67DA C820  54         mov   @>83A0,@>20A0
     67DC 83A0 
     67DE 20A0 
0102 67E0 C820  54         mov   @>83A2,@>20A2
     67E2 83A2 
     67E4 20A2 
0103 67E6 C820  54         mov   @>83A4,@>20A4
     67E8 83A4 
     67EA 20A4 
0104 67EC C820  54         mov   @>83A6,@>20A6
     67EE 83A6 
     67F0 20A6 
0105 67F2 C820  54         mov   @>83A8,@>20A8
     67F4 83A8 
     67F6 20A8 
0106 67F8 C820  54         mov   @>83AA,@>20AA
     67FA 83AA 
     67FC 20AA 
0107 67FE C820  54         mov   @>83AC,@>20AC
     6800 83AC 
     6802 20AC 
0108 6804 C820  54         mov   @>83AE,@>20AE
     6806 83AE 
     6808 20AE 
0109 680A C820  54         mov   @>83B0,@>20B0
     680C 83B0 
     680E 20B0 
0110 6810 C820  54         mov   @>83B2,@>20B2
     6812 83B2 
     6814 20B2 
0111 6816 C820  54         mov   @>83B4,@>20B4
     6818 83B4 
     681A 20B4 
0112 681C C820  54         mov   @>83B6,@>20B6
     681E 83B6 
     6820 20B6 
0113 6822 C820  54         mov   @>83B8,@>20B8
     6824 83B8 
     6826 20B8 
0114 6828 C820  54         mov   @>83BA,@>20BA
     682A 83BA 
     682C 20BA 
0115 682E C820  54         mov   @>83BC,@>20BC
     6830 83BC 
     6832 20BC 
0116 6834 C820  54         mov   @>83BE,@>20BE
     6836 83BE 
     6838 20BE 
0117 683A C820  54         mov   @>83C0,@>20C0
     683C 83C0 
     683E 20C0 
0118 6840 C820  54         mov   @>83C2,@>20C2
     6842 83C2 
     6844 20C2 
0119 6846 C820  54         mov   @>83C4,@>20C4
     6848 83C4 
     684A 20C4 
0120 684C C820  54         mov   @>83C6,@>20C6
     684E 83C6 
     6850 20C6 
0121 6852 C820  54         mov   @>83C8,@>20C8
     6854 83C8 
     6856 20C8 
0122 6858 C820  54         mov   @>83CA,@>20CA
     685A 83CA 
     685C 20CA 
0123 685E C820  54         mov   @>83CC,@>20CC
     6860 83CC 
     6862 20CC 
0124 6864 C820  54         mov   @>83CE,@>20CE
     6866 83CE 
     6868 20CE 
0125 686A C820  54         mov   @>83D0,@>20D0
     686C 83D0 
     686E 20D0 
0126 6870 C820  54         mov   @>83D2,@>20D2
     6872 83D2 
     6874 20D2 
0127 6876 C820  54         mov   @>83D4,@>20D4
     6878 83D4 
     687A 20D4 
0128 687C C820  54         mov   @>83D6,@>20D6
     687E 83D6 
     6880 20D6 
0129 6882 C820  54         mov   @>83D8,@>20D8
     6884 83D8 
     6886 20D8 
0130 6888 C820  54         mov   @>83DA,@>20DA
     688A 83DA 
     688C 20DA 
0131 688E C820  54         mov   @>83DC,@>20DC
     6890 83DC 
     6892 20DC 
0132 6894 C820  54         mov   @>83DE,@>20DE
     6896 83DE 
     6898 20DE 
0133 689A C820  54         mov   @>83E0,@>20E0
     689C 83E0 
     689E 20E0 
0134 68A0 C820  54         mov   @>83E2,@>20E2
     68A2 83E2 
     68A4 20E2 
0135 68A6 C820  54         mov   @>83E4,@>20E4
     68A8 83E4 
     68AA 20E4 
0136 68AC C820  54         mov   @>83E6,@>20E6
     68AE 83E6 
     68B0 20E6 
0137 68B2 C820  54         mov   @>83E8,@>20E8
     68B4 83E8 
     68B6 20E8 
0138 68B8 C820  54         mov   @>83EA,@>20EA
     68BA 83EA 
     68BC 20EA 
0139 68BE C820  54         mov   @>83EC,@>20EC
     68C0 83EC 
     68C2 20EC 
0140 68C4 C820  54         mov   @>83EE,@>20EE
     68C6 83EE 
     68C8 20EE 
0141 68CA C820  54         mov   @>83F0,@>20F0
     68CC 83F0 
     68CE 20F0 
0142 68D0 C820  54         mov   @>83F2,@>20F2
     68D2 83F2 
     68D4 20F2 
0143 68D6 C820  54         mov   @>83F4,@>20F4
     68D8 83F4 
     68DA 20F4 
0144 68DC C820  54         mov   @>83F6,@>20F6
     68DE 83F6 
     68E0 20F6 
0145 68E2 C820  54         mov   @>83F8,@>20F8
     68E4 83F8 
     68E6 20F8 
0146 68E8 C820  54         mov   @>83FA,@>20FA
     68EA 83FA 
     68EC 20FA 
0147 68EE C820  54         mov   @>83FC,@>20FC
     68F0 83FC 
     68F2 20FC 
0148 68F4 C820  54         mov   @>83FE,@>20FE
     68F6 83FE 
     68F8 20FE 
0149 68FA 045B  20         b     *r11                  ; Return to caller
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
0164 68FC C820  54         mov   @>2000,@>8300
     68FE 2000 
     6900 8300 
0165 6902 C820  54         mov   @>2002,@>8302
     6904 2002 
     6906 8302 
0166 6908 C820  54         mov   @>2004,@>8304
     690A 2004 
     690C 8304 
0167 690E C820  54         mov   @>2006,@>8306
     6910 2006 
     6912 8306 
0168 6914 C820  54         mov   @>2008,@>8308
     6916 2008 
     6918 8308 
0169 691A C820  54         mov   @>200A,@>830A
     691C 200A 
     691E 830A 
0170 6920 C820  54         mov   @>200C,@>830C
     6922 200C 
     6924 830C 
0171 6926 C820  54         mov   @>200E,@>830E
     6928 200E 
     692A 830E 
0172 692C C820  54         mov   @>2010,@>8310
     692E 2010 
     6930 8310 
0173 6932 C820  54         mov   @>2012,@>8312
     6934 2012 
     6936 8312 
0174 6938 C820  54         mov   @>2014,@>8314
     693A 2014 
     693C 8314 
0175 693E C820  54         mov   @>2016,@>8316
     6940 2016 
     6942 8316 
0176 6944 C820  54         mov   @>2018,@>8318
     6946 2018 
     6948 8318 
0177 694A C820  54         mov   @>201A,@>831A
     694C 201A 
     694E 831A 
0178 6950 C820  54         mov   @>201C,@>831C
     6952 201C 
     6954 831C 
0179 6956 C820  54         mov   @>201E,@>831E
     6958 201E 
     695A 831E 
0180 695C C820  54         mov   @>2020,@>8320
     695E 2020 
     6960 8320 
0181 6962 C820  54         mov   @>2022,@>8322
     6964 2022 
     6966 8322 
0182 6968 C820  54         mov   @>2024,@>8324
     696A 2024 
     696C 8324 
0183 696E C820  54         mov   @>2026,@>8326
     6970 2026 
     6972 8326 
0184 6974 C820  54         mov   @>2028,@>8328
     6976 2028 
     6978 8328 
0185 697A C820  54         mov   @>202A,@>832A
     697C 202A 
     697E 832A 
0186 6980 C820  54         mov   @>202C,@>832C
     6982 202C 
     6984 832C 
0187 6986 C820  54         mov   @>202E,@>832E
     6988 202E 
     698A 832E 
0188 698C C820  54         mov   @>2030,@>8330
     698E 2030 
     6990 8330 
0189 6992 C820  54         mov   @>2032,@>8332
     6994 2032 
     6996 8332 
0190 6998 C820  54         mov   @>2034,@>8334
     699A 2034 
     699C 8334 
0191 699E C820  54         mov   @>2036,@>8336
     69A0 2036 
     69A2 8336 
0192 69A4 C820  54         mov   @>2038,@>8338
     69A6 2038 
     69A8 8338 
0193 69AA C820  54         mov   @>203A,@>833A
     69AC 203A 
     69AE 833A 
0194 69B0 C820  54         mov   @>203C,@>833C
     69B2 203C 
     69B4 833C 
0195 69B6 C820  54         mov   @>203E,@>833E
     69B8 203E 
     69BA 833E 
0196 69BC C820  54         mov   @>2040,@>8340
     69BE 2040 
     69C0 8340 
0197 69C2 C820  54         mov   @>2042,@>8342
     69C4 2042 
     69C6 8342 
0198 69C8 C820  54         mov   @>2044,@>8344
     69CA 2044 
     69CC 8344 
0199 69CE C820  54         mov   @>2046,@>8346
     69D0 2046 
     69D2 8346 
0200 69D4 C820  54         mov   @>2048,@>8348
     69D6 2048 
     69D8 8348 
0201 69DA C820  54         mov   @>204A,@>834A
     69DC 204A 
     69DE 834A 
0202 69E0 C820  54         mov   @>204C,@>834C
     69E2 204C 
     69E4 834C 
0203 69E6 C820  54         mov   @>204E,@>834E
     69E8 204E 
     69EA 834E 
0204 69EC C820  54         mov   @>2050,@>8350
     69EE 2050 
     69F0 8350 
0205 69F2 C820  54         mov   @>2052,@>8352
     69F4 2052 
     69F6 8352 
0206 69F8 C820  54         mov   @>2054,@>8354
     69FA 2054 
     69FC 8354 
0207 69FE C820  54         mov   @>2056,@>8356
     6A00 2056 
     6A02 8356 
0208 6A04 C820  54         mov   @>2058,@>8358
     6A06 2058 
     6A08 8358 
0209 6A0A C820  54         mov   @>205A,@>835A
     6A0C 205A 
     6A0E 835A 
0210 6A10 C820  54         mov   @>205C,@>835C
     6A12 205C 
     6A14 835C 
0211 6A16 C820  54         mov   @>205E,@>835E
     6A18 205E 
     6A1A 835E 
0212 6A1C C820  54         mov   @>2060,@>8360
     6A1E 2060 
     6A20 8360 
0213 6A22 C820  54         mov   @>2062,@>8362
     6A24 2062 
     6A26 8362 
0214 6A28 C820  54         mov   @>2064,@>8364
     6A2A 2064 
     6A2C 8364 
0215 6A2E C820  54         mov   @>2066,@>8366
     6A30 2066 
     6A32 8366 
0216 6A34 C820  54         mov   @>2068,@>8368
     6A36 2068 
     6A38 8368 
0217 6A3A C820  54         mov   @>206A,@>836A
     6A3C 206A 
     6A3E 836A 
0218 6A40 C820  54         mov   @>206C,@>836C
     6A42 206C 
     6A44 836C 
0219 6A46 C820  54         mov   @>206E,@>836E
     6A48 206E 
     6A4A 836E 
0220 6A4C C820  54         mov   @>2070,@>8370
     6A4E 2070 
     6A50 8370 
0221 6A52 C820  54         mov   @>2072,@>8372
     6A54 2072 
     6A56 8372 
0222 6A58 C820  54         mov   @>2074,@>8374
     6A5A 2074 
     6A5C 8374 
0223 6A5E C820  54         mov   @>2076,@>8376
     6A60 2076 
     6A62 8376 
0224 6A64 C820  54         mov   @>2078,@>8378
     6A66 2078 
     6A68 8378 
0225 6A6A C820  54         mov   @>207A,@>837A
     6A6C 207A 
     6A6E 837A 
0226 6A70 C820  54         mov   @>207C,@>837C
     6A72 207C 
     6A74 837C 
0227 6A76 C820  54         mov   @>207E,@>837E
     6A78 207E 
     6A7A 837E 
0228 6A7C C820  54         mov   @>2080,@>8380
     6A7E 2080 
     6A80 8380 
0229 6A82 C820  54         mov   @>2082,@>8382
     6A84 2082 
     6A86 8382 
0230 6A88 C820  54         mov   @>2084,@>8384
     6A8A 2084 
     6A8C 8384 
0231 6A8E C820  54         mov   @>2086,@>8386
     6A90 2086 
     6A92 8386 
0232 6A94 C820  54         mov   @>2088,@>8388
     6A96 2088 
     6A98 8388 
0233 6A9A C820  54         mov   @>208A,@>838A
     6A9C 208A 
     6A9E 838A 
0234 6AA0 C820  54         mov   @>208C,@>838C
     6AA2 208C 
     6AA4 838C 
0235 6AA6 C820  54         mov   @>208E,@>838E
     6AA8 208E 
     6AAA 838E 
0236 6AAC C820  54         mov   @>2090,@>8390
     6AAE 2090 
     6AB0 8390 
0237 6AB2 C820  54         mov   @>2092,@>8392
     6AB4 2092 
     6AB6 8392 
0238 6AB8 C820  54         mov   @>2094,@>8394
     6ABA 2094 
     6ABC 8394 
0239 6ABE C820  54         mov   @>2096,@>8396
     6AC0 2096 
     6AC2 8396 
0240 6AC4 C820  54         mov   @>2098,@>8398
     6AC6 2098 
     6AC8 8398 
0241 6ACA C820  54         mov   @>209A,@>839A
     6ACC 209A 
     6ACE 839A 
0242 6AD0 C820  54         mov   @>209C,@>839C
     6AD2 209C 
     6AD4 839C 
0243 6AD6 C820  54         mov   @>209E,@>839E
     6AD8 209E 
     6ADA 839E 
0244 6ADC C820  54         mov   @>20A0,@>83A0
     6ADE 20A0 
     6AE0 83A0 
0245 6AE2 C820  54         mov   @>20A2,@>83A2
     6AE4 20A2 
     6AE6 83A2 
0246 6AE8 C820  54         mov   @>20A4,@>83A4
     6AEA 20A4 
     6AEC 83A4 
0247 6AEE C820  54         mov   @>20A6,@>83A6
     6AF0 20A6 
     6AF2 83A6 
0248 6AF4 C820  54         mov   @>20A8,@>83A8
     6AF6 20A8 
     6AF8 83A8 
0249 6AFA C820  54         mov   @>20AA,@>83AA
     6AFC 20AA 
     6AFE 83AA 
0250 6B00 C820  54         mov   @>20AC,@>83AC
     6B02 20AC 
     6B04 83AC 
0251 6B06 C820  54         mov   @>20AE,@>83AE
     6B08 20AE 
     6B0A 83AE 
0252 6B0C C820  54         mov   @>20B0,@>83B0
     6B0E 20B0 
     6B10 83B0 
0253 6B12 C820  54         mov   @>20B2,@>83B2
     6B14 20B2 
     6B16 83B2 
0254 6B18 C820  54         mov   @>20B4,@>83B4
     6B1A 20B4 
     6B1C 83B4 
0255 6B1E C820  54         mov   @>20B6,@>83B6
     6B20 20B6 
     6B22 83B6 
0256 6B24 C820  54         mov   @>20B8,@>83B8
     6B26 20B8 
     6B28 83B8 
0257 6B2A C820  54         mov   @>20BA,@>83BA
     6B2C 20BA 
     6B2E 83BA 
0258 6B30 C820  54         mov   @>20BC,@>83BC
     6B32 20BC 
     6B34 83BC 
0259 6B36 C820  54         mov   @>20BE,@>83BE
     6B38 20BE 
     6B3A 83BE 
0260 6B3C C820  54         mov   @>20C0,@>83C0
     6B3E 20C0 
     6B40 83C0 
0261 6B42 C820  54         mov   @>20C2,@>83C2
     6B44 20C2 
     6B46 83C2 
0262 6B48 C820  54         mov   @>20C4,@>83C4
     6B4A 20C4 
     6B4C 83C4 
0263 6B4E C820  54         mov   @>20C6,@>83C6
     6B50 20C6 
     6B52 83C6 
0264 6B54 C820  54         mov   @>20C8,@>83C8
     6B56 20C8 
     6B58 83C8 
0265 6B5A C820  54         mov   @>20CA,@>83CA
     6B5C 20CA 
     6B5E 83CA 
0266 6B60 C820  54         mov   @>20CC,@>83CC
     6B62 20CC 
     6B64 83CC 
0267 6B66 C820  54         mov   @>20CE,@>83CE
     6B68 20CE 
     6B6A 83CE 
0268 6B6C C820  54         mov   @>20D0,@>83D0
     6B6E 20D0 
     6B70 83D0 
0269 6B72 C820  54         mov   @>20D2,@>83D2
     6B74 20D2 
     6B76 83D2 
0270 6B78 C820  54         mov   @>20D4,@>83D4
     6B7A 20D4 
     6B7C 83D4 
0271 6B7E C820  54         mov   @>20D6,@>83D6
     6B80 20D6 
     6B82 83D6 
0272 6B84 C820  54         mov   @>20D8,@>83D8
     6B86 20D8 
     6B88 83D8 
0273 6B8A C820  54         mov   @>20DA,@>83DA
     6B8C 20DA 
     6B8E 83DA 
0274 6B90 C820  54         mov   @>20DC,@>83DC
     6B92 20DC 
     6B94 83DC 
0275 6B96 C820  54         mov   @>20DE,@>83DE
     6B98 20DE 
     6B9A 83DE 
0276 6B9C C820  54         mov   @>20E0,@>83E0
     6B9E 20E0 
     6BA0 83E0 
0277 6BA2 C820  54         mov   @>20E2,@>83E2
     6BA4 20E2 
     6BA6 83E2 
0278 6BA8 C820  54         mov   @>20E4,@>83E4
     6BAA 20E4 
     6BAC 83E4 
0279 6BAE C820  54         mov   @>20E6,@>83E6
     6BB0 20E6 
     6BB2 83E6 
0280 6BB4 C820  54         mov   @>20E8,@>83E8
     6BB6 20E8 
     6BB8 83E8 
0281 6BBA C820  54         mov   @>20EA,@>83EA
     6BBC 20EA 
     6BBE 83EA 
0282 6BC0 C820  54         mov   @>20EC,@>83EC
     6BC2 20EC 
     6BC4 83EC 
0283 6BC6 C820  54         mov   @>20EE,@>83EE
     6BC8 20EE 
     6BCA 83EE 
0284 6BCC C820  54         mov   @>20F0,@>83F0
     6BCE 20F0 
     6BD0 83F0 
0285 6BD2 C820  54         mov   @>20F2,@>83F2
     6BD4 20F2 
     6BD6 83F2 
0286 6BD8 C820  54         mov   @>20F4,@>83F4
     6BDA 20F4 
     6BDC 83F4 
0287 6BDE C820  54         mov   @>20F6,@>83F6
     6BE0 20F6 
     6BE2 83F6 
0288 6BE4 C820  54         mov   @>20F8,@>83F8
     6BE6 20F8 
     6BE8 83F8 
0289 6BEA C820  54         mov   @>20FA,@>83FA
     6BEC 20FA 
     6BEE 83FA 
0290 6BF0 C820  54         mov   @>20FC,@>83FC
     6BF2 20FC 
     6BF4 83FC 
0291 6BF6 C820  54         mov   @>20FE,@>83FE
     6BF8 20FE 
     6BFA 83FE 
0292 6BFC 045B  20         b     *r11                  ; Return to caller
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
0024 6BFE C17B  30         mov   *r11+,tmp1            ; tmp1 = Memory target address
0025                       ;------------------------------------------------------
0026                       ; Copy scratchpad memory to destination
0027                       ;------------------------------------------------------
0028               xmem.scrpad.pgout:
0029 6C00 0204  20         li    tmp0,>8300            ; tmp0 = Memory source address
     6C02 8300 
0030 6C04 C1C5  18         mov   tmp1,tmp3             ; tmp3 = copy of tmp1
0031 6C06 0206  20         li    tmp2,128              ; tmp2 = Bytes to copy
     6C08 0080 
0032                       ;------------------------------------------------------
0033                       ; Copy memory
0034                       ;------------------------------------------------------
0035 6C0A CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0036 6C0C 0606  14         dec   tmp2
0037 6C0E 16FD  14         jne   -!                    ; Loop until done
0038                       ;------------------------------------------------------
0039                       ; Switch to new workspace
0040                       ;------------------------------------------------------
0041 6C10 C347  18         mov   tmp3,r13              ; R13=WP   (pop tmp1 from stack)
0042 6C12 020E  20         li    r14,mem.scrpad.pgout.after.rtwp
     6C14 6C1A 
0043                                                   ; R14=PC
0044 6C16 04CF  14         clr   r15                   ; R15=STATUS
0045                       ;------------------------------------------------------
0046                       ; If we get here, WS was copied to specified
0047                       ; destination.  Also contents of r13,r14,r15
0048                       ; are about to be overwritten by rtwp instruction.
0049                       ;------------------------------------------------------
0050 6C18 0380  18         rtwp                        ; Activate copied workspace
0051                                                   ; in non-scratchpad memory!
0052               
0053               mem.scrpad.pgout.after.rtwp:
0054 6C1A 0460  28         b     @mem.scrpad.restore   ; Restore scratchpad memory from @>2000
     6C1C 68FC 
0055               
0056                       ;------------------------------------------------------
0057                       ; Exit
0058                       ;------------------------------------------------------
0059               mem.scrpad.pgout.$$:
0060 6C1E 045B  20         b     *r11                  ; Return to caller
**** **** ****     > runlib.asm
0196               
0201               
0202               
0203               
0204               *//////////////////////////////////////////////////////////////
0205               *                            TIMERS
0206               *//////////////////////////////////////////////////////////////
0207               
0208                       copy  "timers_tmgr.asm"          ; Timers / Thread scheduler
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
0020 6C20 0300  24 tmgr    limi  0                     ; No interrupt processing
     6C22 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 6C24 D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     6C26 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 6C28 2360  38         coc   @wbit2,r13            ; C flag on ?
     6C2A 6042 
0029 6C2C 1602  14         jne   tmgr1a                ; No, so move on
0030 6C2E E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     6C30 602E 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 6C32 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     6C34 6046 
0035 6C36 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 6C38 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     6C3A 6036 
0048 6C3C 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 6C3E 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     6C40 6034 
0050 6C42 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 6C44 0460  28         b     @kthread              ; Run kernel thread
     6C46 6CBE 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 6C48 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     6C4A 603A 
0056 6C4C 13EB  14         jeq   tmgr1
0057 6C4E 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     6C50 6038 
0058 6C52 16E8  14         jne   tmgr1
0059 6C54 C120  34         mov   @wtiusr,tmp0
     6C56 832E 
0060 6C58 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 6C5A 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     6C5C 6CBC 
0065 6C5E C10A  18         mov   r10,tmp0
0066 6C60 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     6C62 00FF 
0067 6C64 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     6C66 6042 
0068 6C68 1303  14         jeq   tmgr5
0069 6C6A 0284  22         ci    tmp0,60               ; 1 second reached ?
     6C6C 003C 
0070 6C6E 1002  14         jmp   tmgr6
0071 6C70 0284  22 tmgr5   ci    tmp0,50
     6C72 0032 
0072 6C74 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 6C76 1001  14         jmp   tmgr8
0074 6C78 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 6C7A C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     6C7C 832C 
0079 6C7E 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     6C80 FF00 
0080 6C82 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 6C84 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 6C86 05C4  14         inct  tmp0                  ; Second word of slot data
0086 6C88 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 6C8A C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 6C8C 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     6C8E 830C 
     6C90 830D 
0089 6C92 1608  14         jne   tmgr10                ; No, get next slot
0090 6C94 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     6C96 FF00 
0091 6C98 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 6C9A C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     6C9C 8330 
0096 6C9E 0697  24         bl    *tmp3                 ; Call routine in slot
0097 6CA0 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     6CA2 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 6CA4 058A  14 tmgr10  inc   r10                   ; Next slot
0102 6CA6 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     6CA8 8315 
     6CAA 8314 
0103 6CAC 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 6CAE 05C4  14         inct  tmp0                  ; Offset for next slot
0105 6CB0 10E8  14         jmp   tmgr9                 ; Process next slot
0106 6CB2 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 6CB4 10F7  14         jmp   tmgr10                ; Process next slot
0108 6CB6 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     6CB8 FF00 
0109 6CBA 10B4  14         jmp   tmgr1
0110 6CBC 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
0111               
**** **** ****     > runlib.asm
0209                       copy  "timers_kthread.asm"       ; Timers / Kernel thread
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
0015 6CBE E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     6CC0 6036 
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
0041 6CC2 06A0  32         bl    @realkb               ; Scan full keyboard
     6CC4 641A 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 6CC6 0460  28         b     @tmgr3                ; Exit
     6CC8 6C48 
**** **** ****     > runlib.asm
0210                       copy  "timers_hooks.asm"         ; Timers / User hooks
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
0017 6CCA C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     6CCC 832E 
0018 6CCE E0A0  34         soc   @wbit7,config         ; Enable user hook
     6CD0 6038 
0019 6CD2 045B  20 mkhoo1  b     *r11                  ; Return
0020      6C24     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********@*****@*********************@**************************
0028 6CD4 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     6CD6 832E 
0029 6CD8 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     6CDA FEFF 
0030 6CDC 045B  20         b     *r11                  ; Return
**** **** ****     > runlib.asm
0211               
0213                       copy  "timers_alloc.asm"         ; Timers / Slot calculation
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
0017 6CDE C13B  30 mkslot  mov   *r11+,tmp0
0018 6CE0 C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 6CE2 C184  18         mov   tmp0,tmp2
0023 6CE4 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 6CE6 A1A0  34         a     @wtitab,tmp2          ; Add table base
     6CE8 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 6CEA CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 6CEC 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 6CEE C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 6CF0 881B  46         c     *r11,@w$ffff          ; End of list ?
     6CF2 6048 
0035 6CF4 1301  14         jeq   mkslo1                ; Yes, exit
0036 6CF6 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 6CF8 05CB  14 mkslo1  inct  r11
0041 6CFA 045B  20         b     *r11                  ; Exit
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
0052 6CFC C13B  30 clslot  mov   *r11+,tmp0
0053 6CFE 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 6D00 A120  34         a     @wtitab,tmp0          ; Add table base
     6D02 832C 
0055 6D04 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 6D06 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 6D08 045B  20         b     *r11                  ; Exit
**** **** ****     > runlib.asm
0215               
0216               
0217               
0218               *//////////////////////////////////////////////////////////////
0219               *                    RUNLIB INITIALISATION
0220               *//////////////////////////////////////////////////////////////
0221               
0222               ***************************************************************
0223               *  RUNLIB - Runtime library initalisation
0224               ***************************************************************
0225               *  B  @RUNLIB
0226               *--------------------------------------------------------------
0227               *  REMARKS
0228               *  If R1 in WS1 equals >FFFF we return to the TI title screen
0229               *  after clearing scratchpad memory.
0230               *  Use 'B @RUNLI1' to exit your program.
0231               ********@*****@*********************@**************************
0236 6D0A 04E0  34 runlib  clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     6D0C 8302 
0238               *--------------------------------------------------------------
0239               * Alternative entry point
0240               *--------------------------------------------------------------
0241 6D0E 0300  24 runli1  limi  0                     ; Turn off interrupts
     6D10 0000 
0242 6D12 02E0  18         lwpi  ws1                   ; Activate workspace 1
     6D14 8300 
0243 6D16 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     6D18 83C0 
0244               *--------------------------------------------------------------
0245               * Clear scratch-pad memory from R4 upwards
0246               *--------------------------------------------------------------
0247 6D1A 0202  20 runli2  li    r2,>8308
     6D1C 8308 
0248 6D1E 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0249 6D20 0282  22         ci    r2,>8400
     6D22 8400 
0250 6D24 16FC  14         jne   runli3
0251               *--------------------------------------------------------------
0252               * Exit to TI-99/4A title screen ?
0253               *--------------------------------------------------------------
0254 6D26 0281  22         ci    r1,>ffff              ; Exit flag set ?
     6D28 FFFF 
0255 6D2A 1602  14         jne   runli4                ; No, continue
0256 6D2C 0420  54         blwp  @0                    ; Yes, bye bye
     6D2E 0000 
0257               *--------------------------------------------------------------
0258               * Determine if VDP is PAL or NTSC
0259               *--------------------------------------------------------------
0260 6D30 C803  38 runli4  mov   r3,@waux1             ; Store random seed
     6D32 833C 
0261 6D34 04C1  14         clr   r1                    ; Reset counter
0262 6D36 0202  20         li    r2,10                 ; We test 10 times
     6D38 000A 
0263 6D3A C0E0  34 runli5  mov   @vdps,r3
     6D3C 8802 
0264 6D3E 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     6D40 6046 
0265 6D42 1302  14         jeq   runli6
0266 6D44 0581  14         inc   r1                    ; Increase counter
0267 6D46 10F9  14         jmp   runli5
0268 6D48 0602  14 runli6  dec   r2                    ; Next test
0269 6D4A 16F7  14         jne   runli5
0270 6D4C 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     6D4E 1250 
0271 6D50 1202  14         jle   runli7                ; No, so it must be NTSC
0272 6D52 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     6D54 6042 
0273               *--------------------------------------------------------------
0274               * Copy machine code to scratchpad (prepare tight loop)
0275               *--------------------------------------------------------------
0276 6D56 0201  20 runli7  li    r1,mccode             ; Machinecode to patch
     6D58 6078 
0277 6D5A 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     6D5C 8322 
0278 6D5E CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0279 6D60 CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0280 6D62 CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0281               *--------------------------------------------------------------
0282               * Initialize registers, memory, ...
0283               *--------------------------------------------------------------
0284 6D64 04C1  14 runli9  clr   r1
0285 6D66 04C2  14         clr   r2
0286 6D68 04C3  14         clr   r3
0287 6D6A 0209  20         li    stack,>8400           ; Set stack
     6D6C 8400 
0288 6D6E 020F  20         li    r15,vdpw              ; Set VDP write address
     6D70 8C00 
0292               *--------------------------------------------------------------
0293               * Setup video memory
0294               *--------------------------------------------------------------
0299 6D72 06A0  32         bl    @filv                 ; Clear all of 16K VDP memory
     6D74 60B2 
0300 6D76 0000             data  >0000,>00,>3fff
     6D78 0000 
     6D7A 3FFF 
0302 6D7C 06A0  32         bl    @filv
     6D7E 60B2 
0303 6D80 0FC0             data  pctadr,spfclr,16      ; Load color table
     6D82 00F5 
     6D84 0010 
0304               *--------------------------------------------------------------
0305               * Check if there is a F18A present
0306               *--------------------------------------------------------------
0310 6D86 06A0  32         bl    @f18unl               ; Unlock the F18A
     6D88 638A 
0311 6D8A 06A0  32         bl    @f18chk               ; Check if F18A is there
     6D8C 63A4 
0312 6D8E 06A0  32         bl    @f18lck               ; Lock the F18A again
     6D90 639A 
0314               *--------------------------------------------------------------
0315               * Check if there is a speech synthesizer attached
0316               *--------------------------------------------------------------
0318               *       <<skipped>>
0322               *--------------------------------------------------------------
0323               * Load video mode table & font
0324               *--------------------------------------------------------------
0325 6D92 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     6D94 610C 
0326 6D96 606E             data  spvmod                ; Equate selected video mode table
0327 6D98 0204  20         li    tmp0,spfont           ; Get font option
     6D9A 000C 
0328 6D9C 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0329 6D9E 1304  14         jeq   runlid                ; Yes, skip it
0330 6DA0 06A0  32         bl    @ldfnt
     6DA2 6174 
0331 6DA4 1100             data  fntadr,spfont         ; Load specified font
     6DA6 000C 
0332               *--------------------------------------------------------------
0333               * Branch to main program
0334               *--------------------------------------------------------------
0335 6DA8 0262  22 runlid  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     6DAA 0040 
0336 6DAC 0460  28         b     @main                 ; Give control to main program
     6DAE 6DB0 
**** **** ****     > tivi.asm.32581
0066               *--------------------------------------------------------------
0067               * SPECTRA2 startup options
0068               *--------------------------------------------------------------
0069      00F5     spfclr  equ   >f5                   ; Foreground/Background color for font.
0070      0005     spfbck  equ   >05                   ; Screen background color.
0071               ;spfclr  equ   >a1                   ; Foreground/Background color for font.
0072               ;spfbck  equ   >01                   ; Screen background color.
0073               
0074               *--------------------------------------------------------------
0075               * Scratchpad memory
0076               *--------------------------------------------------------------
0077               ;           equ  >8342              ; >8342-834F **free***
0078      8350     parm1       equ  >8350              ; Function parameter 1
0079      8352     parm2       equ  >8352              ; Function parameter 2
0080      8354     parm3       equ  >8354              ; Function parameter 3
0081      8356     parm4       equ  >8356              ; Function parameter 4
0082      8358     parm5       equ  >8358              ; Function parameter 5
0083      835A     parm6       equ  >835a              ; Function parameter 6
0084      835C     parm7       equ  >835c              ; Function parameter 7
0085      835E     parm8       equ  >835e              ; Function parameter 8
0086      8360     outparm1    equ  >8360              ; Function output parameter 1
0087      8362     outparm2    equ  >8362              ; Function output parameter 2
0088      8364     outparm3    equ  >8364              ; Function output parameter 3
0089      8366     outparm4    equ  >8366              ; Function output parameter 4
0090      8368     outparm5    equ  >8368              ; Function output parameter 5
0091      836A     outparm6    equ  >836a              ; Function output parameter 6
0092      836C     outparm7    equ  >836c              ; Function output parameter 7
0093      836E     outparm8    equ  >836e              ; Function output parameter 8
0094      8370     timers      equ  >8370              ; Timer table
0095      8380     ramsat      equ  >8380              ; Sprite Attribute Table in RAM
0096      8390     rambuf      equ  >8390              ; RAM workbuffer 1
0097               
0098               
0099               *--------------------------------------------------------------
0100               * Frame buffer structure @ >2000
0101               * Frame buffer itself    @ >3000 - >3fff
0102               *--------------------------------------------------------------
0103      2000     fb.top.ptr      equ  >2000          ; Pointer to frame buffer
0104      2002     fb.current      equ  fb.top.ptr+2   ; Pointer to current position in frame buffer
0105      2004     fb.topline      equ  fb.top.ptr+4   ; Top line in frame buffer (matching line X in editor buffer)
0106      2006     fb.row          equ  fb.top.ptr+6   ; Current row in frame buffer (offset 0 .. @fb.screenrows)
0107      2008     fb.row.length   equ  fb.top.ptr+8   ; Length of current row in frame buffer
0108      200A     fb.row.dirty    equ  fb.top.ptr+10  ; Current row dirty flag in frame buffer
0109      200C     fb.column       equ  fb.top.ptr+12  ; Current column in frame buffer
0110      200E     fb.colsline     equ  fb.top.ptr+14  ; Columns per row in frame buffer
0111      2010     fb.curshape     equ  fb.top.ptr+16  ; Cursor shape & colour
0112      2012     fb.curtoggle    equ  fb.top.ptr+18  ; Cursor shape toggle
0113      2014     fb.yxsave       equ  fb.top.ptr+20  ; Copy of WYX
0114      2016     fb.dirty        equ  fb.top.ptr+22  ; Frame buffer dirty flag
0115      2018     fb.screenrows   equ  fb.top.ptr+24  ; Number of rows on physical screen
0116      3000     fb.top          equ  >3000          ; Frame buffer low memory 2400 bytes (80x30)
0117               ;                    >200c-20ff     ; ** FREE **
0118               
0119               
0120               *--------------------------------------------------------------
0121               * Editor buffer structure @ >2100
0122               *--------------------------------------------------------------
0123      2100     edb.top.ptr     equ  >2100          ; Pointer to editor buffer
0124      2102     edb.index.ptr   equ  >2102          ; Pointer to index
0125      2104     edb.lines       equ  >2104          ; Total lines in editor buffer
0126      2108     edb.dirty       equ  >2108          ; Editor buffer dirty flag (Text changed!)
0127      210A     edb.next_free   equ  >210a          ; Pointer to next free line
0128      210C     edb.insmode     equ  >210c          ; Editor insert mode (>0000 overwrite / >ffff insert)
0129      A000     edb.top         equ  >a000          ; Editor buffer high memory 24576 bytes
0130               ;                    >2102-21ff     ; ** FREE **
0131               
0132               
0133               *--------------------------------------------------------------
0134               * Index @ >2200 - >2fff
0135               *--------------------------------------------------------------
0136      2200     idx.top        equ  >2200           ; Top of index
0137               
0138               
0139               *--------------------------------------------------------------
0140               * Video mode configuration
0141               *--------------------------------------------------------------
0142      606E     spvmod  equ   tx8030                ; Video mode.   See VIDTAB for details.
0143      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0144      0050     colrow  equ   80                    ; Columns per row
0145      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0146      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0147      1800     sprpdt  equ   >1800                 ; VDP sprite pattern table
0148      2000     sprsat  equ   >2000                 ; VDP sprite attribute table
0149               
0150               
0151               
0152               ***************************************************************
0153               * Main
0154               ********@*****@*********************@**************************
0155 6DB0 20A0  38 main    coc   @wbit1,config         ; F18a detected?
     6DB2 6044 
0156 6DB4 1302  14         jeq   main.continue
0157 6DB6 0420  54         blwp  @0                    ; Exit for now if no F18a detected
     6DB8 0000 
0158               
0159               main.continue:
0160 6DBA 06A0  32         bl    @f18unl               ; Unlock the F18a
     6DBC 638A 
0161 6DBE 06A0  32         bl    @putvr                ; Turn on 30 rows mode.
     6DC0 6146 
0162 6DC2 3140             data  >3140                 ; F18a VR49 (>31), bit 40
0163               
0164                       ;------------------------------------------------------
0165                       ; Initialize low + high memory expansion
0166                       ;------------------------------------------------------
0167 6DC4 06A0  32         bl    @film
     6DC6 608E 
0168 6DC8 2000                   data >2000,00,8*1024  ; Clear 8k low-memory
     6DCA 0000 
     6DCC 2000 
0169               
0170 6DCE 06A0  32         bl    @film
     6DD0 608E 
0171 6DD2 A000                   data >a000,00,24*1024 ; Clear 24k high-memory
     6DD4 0000 
     6DD6 6000 
0172                       ;------------------------------------------------------
0173                       ; Setup cursor, screen, etc.
0174                       ;------------------------------------------------------
0175 6DD8 06A0  32         bl    @smag1x               ; Sprite magnification 1x
     6DDA 6306 
0176 6DDC 06A0  32         bl    @s8x8                 ; Small sprite
     6DDE 6316 
0177               
0178 6DE0 06A0  32         bl    @cpym2m
     6DE2 6294 
0179 6DE4 779A                   data romsat,ramsat,4  ; Load sprite SAT
     6DE6 8380 
     6DE8 0004 
0180               
0181 6DEA C820  54         mov   @romsat+2,@fb.curshape
     6DEC 779C 
     6DEE 2010 
0182                                                   ; Save cursor shape & color
0183               
0184 6DF0 06A0  32         bl    @cpym2v
     6DF2 624C 
0185 6DF4 1800                   data sprpdt,cursors,3*8
     6DF6 779E 
     6DF8 0018 
0186                                                   ; Load sprite cursor patterns
0187               
0188 6DFA 06A0  32         bl    @putat
     6DFC 6244 
0189 6DFE 1D00                   byte 29,0
0190 6E00 77B6                   data txt_title        ; Show TiVi banner
0191               
0192               *--------------------------------------------------------------
0193               * Initialize
0194               *--------------------------------------------------------------
0195 6E02 06A0  32         bl    @edb.init             ; Initialize editor buffer
     6E04 7642 
0196 6E06 06A0  32         bl    @idx.init             ; Initialize index
     6E08 7568 
0197 6E0A 06A0  32         bl    @fb.init              ; Initialize framebuffer
     6E0C 7496 
0198               
0199                       ;-------------------------------------------------------
0200                       ; Setup editor tasks & hook
0201                       ;-------------------------------------------------------
0202 6E0E 0204  20         li    tmp0,>0200
     6E10 0200 
0203 6E12 C804  38         mov   tmp0,@btihi           ; Highest slot in use
     6E14 8314 
0204               
0205 6E16 06A0  32         bl    @at
     6E18 6326 
0206 6E1A 0000             data  >0000                 ; Cursor YX position = >0000
0207               
0208 6E1C 0204  20         li    tmp0,timers
     6E1E 8370 
0209 6E20 C804  38         mov   tmp0,@wtitab
     6E22 832C 
0210               
0211 6E24 06A0  32         bl    @mkslot
     6E26 6CDE 
0212 6E28 0001                   data >0001,task0      ; Task 0 - Update screen
     6E2A 7322 
0213 6E2C 0101                   data >0101,task1      ; Task 1 - Update cursor position
     6E2E 73A6 
0214 6E30 020F                   data >020f,task2,eol  ; Task 2 - Toggle cursor shape
     6E32 73B4 
     6E34 FFFF 
0215               
0216 6E36 06A0  32         bl    @mkhook
     6E38 6CCA 
0217 6E3A 6E40                   data editor           ; Setup user hook
0218               
0219 6E3C 0460  28         b     @tmgr                 ; Start timers and kthread
     6E3E 6C20 
0220               
0221               
0222               ****************************************************************
0223               * Editor - Main loop
0224               ****************************************************************
0225 6E40 20A0  38 editor  coc   @wbit11,config        ; ANYKEY pressed ?
     6E42 6030 
0226 6E44 160A  14         jne   ed_clear_kbbuffer     ; No, clear buffer and exit
0227               *---------------------------------------------------------------
0228               * Identical key pressed ?
0229               *---------------------------------------------------------------
0230 6E46 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
     6E48 6030 
0231 6E4A 8820  54         c     @waux1,@waux2         ; Still pressing previous key?
     6E4C 833C 
     6E4E 833E 
0232 6E50 1308  14         jeq   ed_wait
0233               *--------------------------------------------------------------
0234               * New key pressed
0235               *--------------------------------------------------------------
0236               ed_new_key
0237 6E52 C820  54         mov   @waux1,@waux2         ; Save as previous key
     6E54 833C 
     6E56 833E 
0238 6E58 102F  14         jmp   ed_pk
0239               *--------------------------------------------------------------
0240               * Clear keyboard buffer if no key pressed
0241               *--------------------------------------------------------------
0242               ed_clear_kbbuffer
0243 6E5A 04E0  34         clr   @waux1
     6E5C 833C 
0244 6E5E 04E0  34         clr   @waux2
     6E60 833E 
0245               *--------------------------------------------------------------
0246               * Delay to avoid key bouncing
0247               *--------------------------------------------------------------
0248               ed_wait
0249 6E62 0204  20         li    tmp0,1800             ; Key delay to avoid bouncing keys
     6E64 0708 
0250                       ;------------------------------------------------------
0251                       ; Delay loop
0252                       ;------------------------------------------------------
0253               ed_wait_loop
0254 6E66 0604  14         dec   tmp0
0255 6E68 16FE  14         jne   ed_wait_loop
0256               *--------------------------------------------------------------
0257               * Exit
0258               *--------------------------------------------------------------
0259 6E6A 0460  28 ed_exit b     @hookok               ; Return
     6E6C 6C24 
0260               
0261               
0262               
0263               
0264               
0265               
0266               ***************************************************************
0267               *              ed_pk - Editor Process Key module
0268               ***************************************************************
0269                       copy  "ed_pk.asm"
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
0037 6E6E 0D00             data  key_enter,ed_pk.action.enter          ; New line
     6E70 726C 
0038 6E72 0800             data  key_left,ed_pk.action.left            ; Move cursor left
     6E74 6EE2 
0039 6E76 0900             data  key_right,ed_pk.action.right          ; Move cursor right
     6E78 6EF8 
0040 6E7A 0B00             data  key_up,ed_pk.action.up                ; Move cursor up
     6E7C 6F10 
0041 6E7E 0A00             data  key_down,ed_pk.action.down            ; Move cursor down
     6E80 6F62 
0042 6E82 8100             data  key_home,ed_pk.action.home            ; Move cursor to line begin
     6E84 6FCE 
0043 6E86 8600             data  key_end,ed_pk.action.end              ; Move cursor to line end
     6E88 6FE6 
0044 6E8A 9300             data  key_pword,ed_pk.action.pword          ; Move cursor previous word
     6E8C 6FFA 
0045 6E8E 8400             data  key_nword,ed_pk.action.nword          ; Move cursor next word
     6E90 704C 
0046 6E92 8500             data  key_ppage,ed_pk.action.ppage          ; Move cursor previous page
     6E94 70AC 
0047 6E96 9800             data  key_npage,ed_pk.action.npage          ; Move cursor next page
     6E98 70F6 
0048                       ;-------------------------------------------------------
0049                       ; Modifier keys - Delete
0050                       ;-------------------------------------------------------
0051 6E9A 0300             data  key_del_char,ed_pk.action.del_char    ; Delete character
     6E9C 7122 
0052 6E9E 8B00             data  key_del_eol,ed_pk.action.del_eol      ; Delete until end of line
     6EA0 7156 
0053 6EA2 0700             data  key_del_line,ed_pk.action.del_line    ; Delete current line
     6EA4 7186 
0054                       ;-------------------------------------------------------
0055                       ; Modifier keys - Insert
0056                       ;-------------------------------------------------------
0057 6EA6 0400             data  key_ins_char,ed_pk.action.ins_char.ws ; Insert whitespace
     6EA8 71DA 
0058 6EAA B200             data  key_ins_onoff,ed_pk.action.ins_onoff  ; Insert mode on/off
     6EAC 72D6 
0059 6EAE 0E00             data  key_ins_line,ed_pk.action.ins_line    ; Insert new line
     6EB0 722C 
0060                       ;-------------------------------------------------------
0061                       ; Other action keys
0062                       ;-------------------------------------------------------
0063 6EB2 0500             data  key_quit1,ed_pk.action.quit           ; Quit TiVi
     6EB4 6EDA 
0064 6EB6 FFFF             data  >ffff                                 ; EOL
0065               
0066               
0067               
0068               ****************************************************************
0069               * Editor - Process key
0070               ****************************************************************
0071 6EB8 C160  34 ed_pk   mov   @waux1,tmp1           ; Get key value
     6EBA 833C 
0072 6EBC 0245  22         andi  tmp1,>ff00            ; Get rid of LSB
     6EBE FF00 
0073               
0074 6EC0 0206  20         li    tmp2,keymap_actions   ; Load keyboard map
     6EC2 6E6E 
0075 6EC4 0707  14         seto  tmp3                  ; EOL marker
0076                       ;-------------------------------------------------------
0077                       ; Iterate over keyboard map for matching key
0078                       ;-------------------------------------------------------
0079               ed_pk.check_next_key:
0080 6EC6 81D6  26         c     *tmp2,tmp3            ; EOL reached ?
0081 6EC8 1306  14         jeq   ed_pk.do_action.set   ; Yes, so go add letter
0082               
0083 6ECA 8D85  34         c     tmp1,*tmp2+           ; Key matched?
0084 6ECC 1302  14         jeq   ed_pk.do_action       ; Yes, do action
0085 6ECE 05C6  14         inct  tmp2                  ; No, skip action
0086 6ED0 10FA  14         jmp   ed_pk.check_next_key  ; Next key
0087               
0088               ed_pk.do_action:
0089 6ED2 C196  26         mov  *tmp2,tmp2             ; Get action address
0090 6ED4 0456  20         b    *tmp2                  ; Process key action
0091               ed_pk.do_action.set:
0092 6ED6 0460  28         b    @ed_pk.action.char     ; Add character to buffer
     6ED8 72E6 
0093               
0094               
0095               
0096               *---------------------------------------------------------------
0097               * Quit
0098               *---------------------------------------------------------------
0099               ed_pk.action.quit:
0100 6EDA 06A0  32         bl    @f18rst               ; Reset and lock the F18A
     6EDC 63EE 
0101 6EDE 0420  54         blwp  @0                    ; Exit
     6EE0 0000 
0102               
0103               
0104               *---------------------------------------------------------------
0105               * Cursor left
0106               *---------------------------------------------------------------
0107               ed_pk.action.left:
0108 6EE2 C120  34         mov   @fb.column,tmp0
     6EE4 200C 
0109 6EE6 1306  14         jeq   !jmp2b                ; column=0 ? Skip further processing
0110                       ;-------------------------------------------------------
0111                       ; Update
0112                       ;-------------------------------------------------------
0113 6EE8 0620  34         dec   @fb.column            ; Column-- in screen buffer
     6EEA 200C 
0114 6EEC 0620  34         dec   @wyx                  ; Column-- VDP cursor
     6EEE 832A 
0115 6EF0 0620  34         dec   @fb.current
     6EF2 2002 
0116                       ;-------------------------------------------------------
0117                       ; Exit
0118                       ;-------------------------------------------------------
0119 6EF4 0460  28 !jmp2b  b     @ed_wait              ; Back to editor main
     6EF6 6E62 
0120               
0121               
0122               *---------------------------------------------------------------
0123               * Cursor right
0124               *---------------------------------------------------------------
0125               ed_pk.action.right:
0126 6EF8 8820  54         c     @fb.column,@fb.row.length
     6EFA 200C 
     6EFC 2008 
0127 6EFE 1406  14         jhe   !jmp2b                ; column > length line ? Skip further processing
0128                       ;-------------------------------------------------------
0129                       ; Update
0130                       ;-------------------------------------------------------
0131 6F00 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     6F02 200C 
0132 6F04 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     6F06 832A 
0133 6F08 05A0  34         inc   @fb.current
     6F0A 2002 
0134                       ;-------------------------------------------------------
0135                       ; Exit
0136                       ;-------------------------------------------------------
0137 6F0C 0460  28 !jmp2b  b     @ed_wait              ; Back to editor main
     6F0E 6E62 
0138               
0139               
0140               *---------------------------------------------------------------
0141               * Cursor up
0142               *---------------------------------------------------------------
0143               ed_pk.action.up:
0144                       ;-------------------------------------------------------
0145                       ; Crunch current line if dirty
0146                       ;-------------------------------------------------------
0147 6F10 8820  54         c     @fb.row.dirty,@w$ffff
     6F12 200A 
     6F14 6048 
0148 6F16 1604  14         jne   ed_pk.action.up.cursor
0149 6F18 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6F1A 765A 
0150 6F1C 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6F1E 200A 
0151                       ;-------------------------------------------------------
0152                       ; Move cursor
0153                       ;-------------------------------------------------------
0154               ed_pk.action.up.cursor:
0155 6F20 C120  34         mov   @fb.row,tmp0
     6F22 2006 
0156 6F24 1509  14         jgt   ed_pk.action.up.cursor_up
0157                                                   ; Move cursor up if fb.row>0
0158 6F26 C120  34         mov   @fb.topline,tmp0      ; Do we need to scroll?
     6F28 2004 
0159 6F2A 130A  14         jeq   ed_pk.action.up.set_cursorx
0160                                                   ; At top, only position cursor X
0161                       ;-------------------------------------------------------
0162                       ; Scroll 1 line
0163                       ;-------------------------------------------------------
0164 6F2C 0604  14         dec   tmp0                  ; fb.topline--
0165 6F2E C804  38         mov   tmp0,@parm1
     6F30 8350 
0166 6F32 06A0  32         bl    @fb.refresh           ; Scroll one line up
     6F34 74F6 
0167 6F36 1004  14         jmp   ed_pk.action.up.set_cursorx
0168                       ;-------------------------------------------------------
0169                       ; Move cursor up
0170                       ;-------------------------------------------------------
0171               ed_pk.action.up.cursor_up:
0172 6F38 0620  34         dec   @fb.row               ; Row-- in screen buffer
     6F3A 2006 
0173 6F3C 06A0  32         bl    @up                   ; Row-- VDP cursor
     6F3E 6334 
0174                       ;-------------------------------------------------------
0175                       ; Check line length and position cursor
0176                       ;-------------------------------------------------------
0177               ed_pk.action.up.set_cursorx:
0178 6F40 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     6F42 7776 
0179 6F44 8820  54         c     @fb.column,@fb.row.length
     6F46 200C 
     6F48 2008 
0180 6F4A 1207  14         jle   ed_pk.action.up.$$
0181                       ;-------------------------------------------------------
0182                       ; Adjust cursor column position
0183                       ;-------------------------------------------------------
0184 6F4C C820  54         mov   @fb.row.length,@fb.column
     6F4E 2008 
     6F50 200C 
0185 6F52 C120  34         mov   @fb.column,tmp0
     6F54 200C 
0186 6F56 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6F58 633E 
0187                       ;-------------------------------------------------------
0188                       ; Exit
0189                       ;-------------------------------------------------------
0190               ed_pk.action.up.$$:
0191 6F5A 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6F5C 74DA 
0192 6F5E 0460  28         b     @ed_wait              ; Back to editor main
     6F60 6E62 
0193               
0194               
0195               
0196               *---------------------------------------------------------------
0197               * Cursor down
0198               *---------------------------------------------------------------
0199               ed_pk.action.down:
0200 6F62 8820  54         c     @fb.row,@edb.lines    ; Last line in editor buffer ?
     6F64 2006 
     6F66 2104 
0201 6F68 1330  14         jeq   !jmp2b                ; Yes, skip further processing
0202                       ;-------------------------------------------------------
0203                       ; Crunch current row if dirty
0204                       ;-------------------------------------------------------
0205 6F6A 8820  54         c     @fb.row.dirty,@w$ffff
     6F6C 200A 
     6F6E 6048 
0206 6F70 1604  14         jne   ed_pk.action.down.move
0207 6F72 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     6F74 765A 
0208 6F76 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6F78 200A 
0209                       ;-------------------------------------------------------
0210                       ; Move cursor
0211                       ;-------------------------------------------------------
0212               ed_pk.action.down.move:
0213                       ;-------------------------------------------------------
0214                       ; EOF reached?
0215                       ;-------------------------------------------------------
0216 6F7A C120  34         mov   @fb.topline,tmp0
     6F7C 2004 
0217 6F7E A120  34         a     @fb.row,tmp0
     6F80 2006 
0218 6F82 8120  34         c     @edb.lines,tmp0       ; fb.topline + fb.row = edb.lines ?
     6F84 2104 
0219 6F86 1312  14         jeq   ed_pk.action.down.set_cursorx
0220                                                   ; Yes, only position cursor X
0221                       ;-------------------------------------------------------
0222                       ; Check if scrolling required
0223                       ;-------------------------------------------------------
0224 6F88 C120  34         mov   @fb.screenrows,tmp0
     6F8A 2018 
0225 6F8C 0604  14         dec   tmp0
0226 6F8E 8120  34         c     @fb.row,tmp0
     6F90 2006 
0227 6F92 1108  14         jlt   ed_pk.action.down.cursor
0228                       ;-------------------------------------------------------
0229                       ; Scroll 1 line
0230                       ;-------------------------------------------------------
0231 6F94 C820  54         mov   @fb.topline,@parm1
     6F96 2004 
     6F98 8350 
0232 6F9A 05A0  34         inc   @parm1
     6F9C 8350 
0233 6F9E 06A0  32         bl    @fb.refresh
     6FA0 74F6 
0234 6FA2 1004  14         jmp   ed_pk.action.down.set_cursorx
0235                       ;-------------------------------------------------------
0236                       ; Move cursor down a row, there are still rows left
0237                       ;-------------------------------------------------------
0238               ed_pk.action.down.cursor:
0239 6FA4 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     6FA6 2006 
0240 6FA8 06A0  32         bl    @down                 ; Row++ VDP cursor
     6FAA 632C 
0241                       ;-------------------------------------------------------
0242                       ; Check line length and position cursor
0243                       ;-------------------------------------------------------
0244               ed_pk.action.down.set_cursorx:
0245 6FAC 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     6FAE 7776 
0246 6FB0 8820  54         c     @fb.column,@fb.row.length
     6FB2 200C 
     6FB4 2008 
0247 6FB6 1207  14         jle   ed_pk.action.down.$$  ; Exit
0248                       ;-------------------------------------------------------
0249                       ; Adjust cursor column position
0250                       ;-------------------------------------------------------
0251 6FB8 C820  54         mov   @fb.row.length,@fb.column
     6FBA 2008 
     6FBC 200C 
0252 6FBE C120  34         mov   @fb.column,tmp0
     6FC0 200C 
0253 6FC2 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6FC4 633E 
0254                       ;-------------------------------------------------------
0255                       ; Exit
0256                       ;-------------------------------------------------------
0257               ed_pk.action.down.$$:
0258 6FC6 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6FC8 74DA 
0259 6FCA 0460  28 !jmp2b  b     @ed_wait              ; Back to editor main
     6FCC 6E62 
0260               
0261               
0262               
0263               *---------------------------------------------------------------
0264               * Cursor beginning of line
0265               *---------------------------------------------------------------
0266               ed_pk.action.home:
0267 6FCE C120  34         mov   @wyx,tmp0
     6FD0 832A 
0268 6FD2 0244  22         andi  tmp0,>ff00
     6FD4 FF00 
0269 6FD6 C804  38         mov   tmp0,@wyx             ; VDP cursor column=0
     6FD8 832A 
0270 6FDA 04E0  34         clr   @fb.column
     6FDC 200C 
0271 6FDE 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6FE0 74DA 
0272 6FE2 0460  28         b     @ed_wait              ; Back to editor main
     6FE4 6E62 
0273               
0274               *---------------------------------------------------------------
0275               * Cursor end of line
0276               *---------------------------------------------------------------
0277               ed_pk.action.end:
0278 6FE6 C120  34         mov   @fb.row.length,tmp0
     6FE8 2008 
0279 6FEA C804  38         mov   tmp0,@fb.column
     6FEC 200C 
0280 6FEE 06A0  32         bl    @xsetx                ; Set VDP cursor column position
     6FF0 633E 
0281 6FF2 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6FF4 74DA 
0282 6FF6 0460  28         b     @ed_wait              ; Back to editor main
     6FF8 6E62 
0283               
0284               
0285               
0286               *---------------------------------------------------------------
0287               * Cursor beginning of word or previous word
0288               *---------------------------------------------------------------
0289               ed_pk.action.pword:
0290 6FFA C120  34         mov   @fb.column,tmp0
     6FFC 200C 
0291 6FFE 1324  14         jeq   !jmp2b                ; column=0 ? Skip further processing
0292                       ;-------------------------------------------------------
0293                       ; Prepare 2 char buffer
0294                       ;-------------------------------------------------------
0295 7000 C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     7002 2002 
0296 7004 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0297 7006 1003  14         jmp   ed_pk.action.pword_scan_char
0298                       ;-------------------------------------------------------
0299                       ; Scan backwards to first character following space
0300                       ;-------------------------------------------------------
0301               ed_pk.action.pword_scan
0302 7008 0605  14         dec   tmp1
0303 700A 0604  14         dec   tmp0                  ; Column-- in screen buffer
0304 700C 1315  14         jeq   ed_pk.action.pword_done
0305                                                   ; Column=0 ? Skip further processing
0306                       ;-------------------------------------------------------
0307                       ; Check character
0308                       ;-------------------------------------------------------
0309               ed_pk.action.pword_scan_char
0310 700E D195  26         movb  *tmp1,tmp2            ; Get character
0311 7010 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0312 7012 D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0313 7014 0986  56         srl   tmp2,8                ; Right justify
0314 7016 0286  22         ci    tmp2,32               ; Space character found?
     7018 0020 
0315 701A 16F6  14         jne   ed_pk.action.pword_scan
0316                                                   ; No space found, try again
0317                       ;-------------------------------------------------------
0318                       ; Space found, now look closer
0319                       ;-------------------------------------------------------
0320 701C 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     701E 2020 
0321 7020 13F3  14         jeq   ed_pk.action.pword_scan
0322                                                   ; Yes, so continue scanning
0323 7022 0287  22         ci    tmp3,>20ff            ; First character is space
     7024 20FF 
0324 7026 13F0  14         jeq   ed_pk.action.pword_scan
0325                       ;-------------------------------------------------------
0326                       ; Check distance travelled
0327                       ;-------------------------------------------------------
0328 7028 C1E0  34         mov   @fb.column,tmp3       ; re-use tmp3
     702A 200C 
0329 702C 61C4  18         s     tmp0,tmp3
0330 702E 0287  22         ci    tmp3,2                ; Did we move at least 2 positions?
     7030 0002 
0331 7032 11EA  14         jlt   ed_pk.action.pword_scan
0332                                                   ; Didn't move enough so keep on scanning
0333                       ;--------------------------------------------------------
0334                       ; Set cursor following space
0335                       ;--------------------------------------------------------
0336 7034 0585  14         inc   tmp1
0337 7036 0584  14         inc   tmp0                  ; Column++ in screen buffer
0338                       ;-------------------------------------------------------
0339                       ; Save position and position hardware cursor
0340                       ;-------------------------------------------------------
0341               ed_pk.action.pword_done:
0342 7038 C805  38         mov   tmp1,@fb.current
     703A 2002 
0343 703C C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     703E 200C 
0344 7040 06A0  32         bl    @xsetx                ; Set VDP cursor X
     7042 633E 
0345                       ;-------------------------------------------------------
0346                       ; Exit
0347                       ;-------------------------------------------------------
0348               ed_pk.action.pword.$$:
0349 7044 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7046 74DA 
0350 7048 0460  28 !jmp2b  b     @ed_wait              ; Back to editor main
     704A 6E62 
0351               
0352               
0353               
0354               *---------------------------------------------------------------
0355               * Cursor next word
0356               *---------------------------------------------------------------
0357               ed_pk.action.nword:
0358 704C 04C8  14         clr   tmp4                  ; Reset multiple spaces mode
0359 704E C120  34         mov   @fb.column,tmp0
     7050 200C 
0360 7052 8804  38         c     tmp0,@fb.row.length
     7054 2008 
0361 7056 1428  14         jhe   !jmp2b                ; column=last char ? Skip further processing
0362                       ;-------------------------------------------------------
0363                       ; Prepare 2 char buffer
0364                       ;-------------------------------------------------------
0365 7058 C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     705A 2002 
0366 705C 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0367 705E 1006  14         jmp   ed_pk.action.nword_scan_char
0368                       ;-------------------------------------------------------
0369                       ; Multiple spaces mode
0370                       ;-------------------------------------------------------
0371               ed_pk.action.nword_ms:
0372 7060 0708  14         seto  tmp4                  ; Set multiple spaces mode
0373                       ;-------------------------------------------------------
0374                       ; Scan forward to first character following space
0375                       ;-------------------------------------------------------
0376               ed_pk.action.nword_scan
0377 7062 0585  14         inc   tmp1
0378 7064 0584  14         inc   tmp0                  ; Column++ in screen buffer
0379 7066 8804  38         c     tmp0,@fb.row.length
     7068 2008 
0380 706A 1316  14         jeq   ed_pk.action.nword_done
0381                                                   ; Column=last char ? Skip further processing
0382                       ;-------------------------------------------------------
0383                       ; Check character
0384                       ;-------------------------------------------------------
0385               ed_pk.action.nword_scan_char
0386 706C D195  26         movb  *tmp1,tmp2            ; Get character
0387 706E 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0388 7070 D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0389 7072 0986  56         srl   tmp2,8                ; Right justify
0390               
0391 7074 0288  22         ci    tmp4,>ffff            ; Multiple space mode on?
     7076 FFFF 
0392 7078 1604  14         jne   ed_pk.action.nword_scan_char_other
0393                       ;-------------------------------------------------------
0394                       ; Special handling if multiple spaces found
0395                       ;-------------------------------------------------------
0396               ed_pk.action.nword_scan_char_ms:
0397 707A 0286  22         ci    tmp2,32
     707C 0020 
0398 707E 160C  14         jne   ed_pk.action.nword_done
0399                                                   ; Exit if non-space found
0400 7080 10F0  14         jmp   ed_pk.action.nword_scan
0401                       ;-------------------------------------------------------
0402                       ; Normal handling
0403                       ;-------------------------------------------------------
0404               ed_pk.action.nword_scan_char_other:
0405 7082 0286  22         ci    tmp2,32               ; Space character found?
     7084 0020 
0406 7086 16ED  14         jne   ed_pk.action.nword_scan
0407                                                   ; No space found, try again
0408                       ;-------------------------------------------------------
0409                       ; Space found, now look closer
0410                       ;-------------------------------------------------------
0411 7088 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     708A 2020 
0412 708C 13E9  14         jeq   ed_pk.action.nword_ms
0413                                                   ; Yes, so continue scanning
0414 708E 0287  22         ci    tmp3,>20ff            ; First characer is space?
     7090 20FF 
0415 7092 13E7  14         jeq   ed_pk.action.nword_scan
0416                       ;--------------------------------------------------------
0417                       ; Set cursor following space
0418                       ;--------------------------------------------------------
0419 7094 0585  14         inc   tmp1
0420 7096 0584  14         inc   tmp0                  ; Column++ in screen buffer
0421                       ;-------------------------------------------------------
0422                       ; Save position and position hardware cursor
0423                       ;-------------------------------------------------------
0424               ed_pk.action.nword_done:
0425 7098 C805  38         mov   tmp1,@fb.current
     709A 2002 
0426 709C C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     709E 200C 
0427 70A0 06A0  32         bl    @xsetx                ; Set VDP cursor X
     70A2 633E 
0428                       ;-------------------------------------------------------
0429                       ; Exit
0430                       ;-------------------------------------------------------
0431               ed_pk.action.nword.$$:
0432 70A4 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     70A6 74DA 
0433 70A8 0460  28 !jmp2b  b     @ed_wait              ; Back to editor main
     70AA 6E62 
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
0445 70AC C120  34         mov   @fb.topline,tmp0      ; Exit if already on line 1
     70AE 2004 
0446 70B0 1316  14         jeq   ed_pk.action.ppage.$$
0447                       ;-------------------------------------------------------
0448                       ; Special treatment top page
0449                       ;-------------------------------------------------------
0450 70B2 8804  38         c     tmp0,@fb.screenrows   ; topline > rows on screen?
     70B4 2018 
0451 70B6 1503  14         jgt   ed_pk.action.ppage.topline
0452 70B8 04E0  34         clr   @fb.topline           ; topline = 0
     70BA 2004 
0453 70BC 1003  14         jmp   ed_pk.action.ppage.crunch
0454                       ;-------------------------------------------------------
0455                       ; Adjust topline
0456                       ;-------------------------------------------------------
0457               ed_pk.action.ppage.topline:
0458 70BE 6820  54         s     @fb.screenrows,@fb.topline
     70C0 2018 
     70C2 2004 
0459                       ;-------------------------------------------------------
0460                       ; Crunch current row if dirty
0461                       ;-------------------------------------------------------
0462               ed_pk.action.ppage.crunch:
0463 70C4 8820  54         c     @fb.row.dirty,@w$ffff
     70C6 200A 
     70C8 6048 
0464 70CA 1604  14         jne   ed_pk.action.ppage.refresh
0465 70CC 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     70CE 765A 
0466 70D0 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     70D2 200A 
0467                       ;-------------------------------------------------------
0468                       ; Refresh page
0469                       ;-------------------------------------------------------
0470               ed_pk.action.ppage.refresh:
0471 70D4 C820  54         mov   @fb.topline,@parm1
     70D6 2004 
     70D8 8350 
0472 70DA 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     70DC 74F6 
0473                       ;-------------------------------------------------------
0474                       ; Exit
0475                       ;-------------------------------------------------------
0476               ed_pk.action.ppage.$$:
0477 70DE 04E0  34         clr   @fb.row
     70E0 2006 
0478 70E2 05A0  34         inc   @fb.row               ; Set fb.row=1
     70E4 2006 
0479 70E6 04E0  34         clr   @fb.column
     70E8 200C 
0480 70EA 0204  20         li    tmp0,>0100            ; Set VDP cursor on line 1, column 0
     70EC 0100 
0481 70EE C804  38         mov   tmp0,@wyx             ; In ed_pk.action up cursor is moved up
     70F0 832A 
0482 70F2 0460  28         b     @ed_pk.action.up      ; Do rest of logic
     70F4 6F10 
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
0493 70F6 C120  34         mov   @fb.topline,tmp0
     70F8 2004 
0494 70FA A120  34         a     @fb.screenrows,tmp0
     70FC 2018 
0495 70FE 8804  38         c     tmp0,@edb.lines       ; Exit if on last page
     7100 2104 
0496 7102 150D  14         jgt   ed_pk.action.npage.$$
0497                       ;-------------------------------------------------------
0498                       ; Adjust topline
0499                       ;-------------------------------------------------------
0500               ed_pk.action.npage.topline:
0501 7104 A820  54         a     @fb.screenrows,@fb.topline
     7106 2018 
     7108 2004 
0502                       ;-------------------------------------------------------
0503                       ; Crunch current row if dirty
0504                       ;-------------------------------------------------------
0505               ed_pk.action.npage.crunch:
0506 710A 8820  54         c     @fb.row.dirty,@w$ffff
     710C 200A 
     710E 6048 
0507 7110 1604  14         jne   ed_pk.action.npage.refresh
0508 7112 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     7114 765A 
0509 7116 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     7118 200A 
0510                       ;-------------------------------------------------------
0511                       ; Refresh page
0512                       ;-------------------------------------------------------
0513               ed_pk.action.npage.refresh:
0514 711A 0460  28         b     @ed_pk.action.ppage.refresh
     711C 70D4 
0515                                                   ; Same logic as previous pabe
0516                       ;-------------------------------------------------------
0517                       ; Exit
0518                       ;-------------------------------------------------------
0519               ed_pk.action.npage.$$:
0520 711E 0460  28         b     @ed_wait              ; Back to editor main
     7120 6E62 
0521               
0522               
0523               *---------------------------------------------------------------
0524               * Delete character
0525               *---------------------------------------------------------------
0526               ed_pk.action.del_char:
0527 7122 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7124 74DA 
0528                       ;-------------------------------------------------------
0529                       ; Sanity check 1
0530                       ;-------------------------------------------------------
0531 7126 C120  34         mov   @fb.current,tmp0      ; Get pointer
     7128 2002 
0532 712A C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     712C 2008 
0533 712E 1311  14         jeq   ed_pk.action.del_char.$$
0534                                                   ; Exit if empty line
0535                       ;-------------------------------------------------------
0536                       ; Sanity check 2
0537                       ;-------------------------------------------------------
0538 7130 8820  54         c     @fb.column,@fb.row.length
     7132 200C 
     7134 2008 
0539 7136 130D  14         jeq   ed_pk.action.del_char.$$
0540                                                   ; Exit if at EOL
0541                       ;-------------------------------------------------------
0542                       ; Prepare for delete operation
0543                       ;-------------------------------------------------------
0544 7138 C120  34         mov   @fb.current,tmp0      ; Get pointer
     713A 2002 
0545 713C C144  18         mov   tmp0,tmp1             ; Add 1 to pointer
0546 713E 0585  14         inc   tmp1
0547                       ;-------------------------------------------------------
0548                       ; Loop until end of line
0549                       ;-------------------------------------------------------
0550               ed_pk.action.del_char_loop:
0551 7140 DD35  42         movb  *tmp1+,*tmp0+         ; Overwrite current char with next char
0552 7142 0606  14         dec   tmp2
0553 7144 16FD  14         jne   ed_pk.action.del_char_loop
0554                       ;-------------------------------------------------------
0555                       ; Save variables
0556                       ;-------------------------------------------------------
0557 7146 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     7148 200A 
0558 714A 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     714C 2016 
0559 714E 0620  34         dec   @fb.row.length        ; @fb.row.length--
     7150 2008 
0560                       ;-------------------------------------------------------
0561                       ; Exit
0562                       ;-------------------------------------------------------
0563               ed_pk.action.del_char.$$:
0564 7152 0460  28         b     @ed_wait              ; Back to editor main
     7154 6E62 
0565               
0566               
0567               *---------------------------------------------------------------
0568               * Delete until end of line
0569               *---------------------------------------------------------------
0570               ed_pk.action.del_eol:
0571 7156 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7158 74DA 
0572 715A C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     715C 2008 
0573 715E 1311  14         jeq   ed_pk.action.del_eol.$$
0574                                                   ; Exit if empty line
0575                       ;-------------------------------------------------------
0576                       ; Prepare for erase operation
0577                       ;-------------------------------------------------------
0578 7160 C120  34         mov   @fb.current,tmp0      ; Get pointer
     7162 2002 
0579 7164 C1A0  34         mov   @fb.colsline,tmp2
     7166 200E 
0580 7168 61A0  34         s     @fb.column,tmp2
     716A 200C 
0581 716C 04C5  14         clr   tmp1
0582                       ;-------------------------------------------------------
0583                       ; Loop until last column in frame buffer
0584                       ;-------------------------------------------------------
0585               ed_pk.action.del_eol_loop:
0586 716E DD05  32         movb  tmp1,*tmp0+           ; Overwrite current char with >00
0587 7170 0606  14         dec   tmp2
0588 7172 16FD  14         jne   ed_pk.action.del_eol_loop
0589                       ;-------------------------------------------------------
0590                       ; Save variables
0591                       ;-------------------------------------------------------
0592 7174 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     7176 200A 
0593 7178 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     717A 2016 
0594               
0595 717C C820  54         mov   @fb.column,@fb.row.length
     717E 200C 
     7180 2008 
0596                                                   ; Set new row length
0597                       ;-------------------------------------------------------
0598                       ; Exit
0599                       ;-------------------------------------------------------
0600               ed_pk.action.del_eol.$$:
0601 7182 0460  28         b     @ed_wait              ; Back to editor main
     7184 6E62 
0602               
0603               
0604               *---------------------------------------------------------------
0605               * Delete current line
0606               *---------------------------------------------------------------
0607               ed_pk.action.del_line:
0608                       ;-------------------------------------------------------
0609                       ; Special treatment if only 1 line in file
0610                       ;-------------------------------------------------------
0611 7186 C120  34         mov   @edb.lines,tmp0
     7188 2104 
0612 718A 1604  14         jne   !
0613 718C 04E0  34         clr   @fb.column            ; Column 0
     718E 200C 
0614 7190 0460  28         b     @ed_pk.action.del_eol ; Delete until end of line
     7192 7156 
0615                       ;-------------------------------------------------------
0616                       ; Delete entry in index
0617                       ;-------------------------------------------------------
0618 7194 06A0  32 !       bl    @fb.calc_pointer      ; Calculate position in frame buffer
     7196 74DA 
0619 7198 04E0  34         clr   @fb.row.dirty         ; Discard current line
     719A 200A 
0620 719C C820  54         mov   @fb.topline,@parm1
     719E 2004 
     71A0 8350 
0621 71A2 A820  54         a     @fb.row,@parm1        ; Line number to remove
     71A4 2006 
     71A6 8350 
0622 71A8 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     71AA 2104 
     71AC 8352 
0623 71AE 06A0  32         bl    @idx.entry.delete     ; Reorganize index
     71B0 759C 
0624 71B2 0620  34         dec   @edb.lines            ; One line less in editor buffer
     71B4 2104 
0625                       ;-------------------------------------------------------
0626                       ; Refresh frame buffer and physical screen
0627                       ;-------------------------------------------------------
0628 71B6 C820  54         mov   @fb.topline,@parm1
     71B8 2004 
     71BA 8350 
0629 71BC 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     71BE 74F6 
0630 71C0 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     71C2 2016 
0631                       ;-------------------------------------------------------
0632                       ; Special treatment if current line was last line
0633                       ;-------------------------------------------------------
0634 71C4 C120  34         mov   @fb.topline,tmp0
     71C6 2004 
0635 71C8 A120  34         a     @fb.row,tmp0
     71CA 2006 
0636 71CC 8804  38         c     tmp0,@edb.lines       ; Was last line?
     71CE 2104 
0637 71D0 1202  14         jle   ed_pk.action.del_line.$$
0638 71D2 0460  28         b     @ed_pk.action.up      ; One line up
     71D4 6F10 
0639                       ;-------------------------------------------------------
0640                       ; Exit
0641                       ;-------------------------------------------------------
0642               ed_pk.action.del_line.$$:
0643 71D6 0460  28         b     @ed_pk.action.home    ; Move cursor to home and return
     71D8 6FCE 
0644               
0645               
0646               
0647               *---------------------------------------------------------------
0648               * Insert character
0649               *
0650               * @parm1 = high byte has character to insert
0651               *---------------------------------------------------------------
0652               ed_pk.action.ins_char.ws
0653 71DA 0204  20         li    tmp0,>2000            ; White space
     71DC 2000 
0654 71DE C804  38         mov   tmp0,@parm1
     71E0 8350 
0655               ed_pk.action.ins_char:
0656 71E2 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     71E4 74DA 
0657                       ;-------------------------------------------------------
0658                       ; Sanity check 1 - Empty line
0659                       ;-------------------------------------------------------
0660 71E6 C120  34         mov   @fb.current,tmp0      ; Get pointer
     71E8 2002 
0661 71EA C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     71EC 2008 
0662 71EE 131A  14         jeq   ed_pk.action.ins_char.sanity
0663                                                   ; Add character in overwrite mode
0664                       ;-------------------------------------------------------
0665                       ; Sanity check 2 - EOL
0666                       ;-------------------------------------------------------
0667 71F0 8820  54         c     @fb.column,@fb.row.length
     71F2 200C 
     71F4 2008 
0668 71F6 1316  14         jeq   ed_pk.action.ins_char.sanity
0669                                                   ; Add character in overwrite mode
0670                       ;-------------------------------------------------------
0671                       ; Prepare for insert operation
0672                       ;-------------------------------------------------------
0673               ed_pk.action.skipsanity:
0674 71F8 C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0675 71FA 61E0  34         s     @fb.column,tmp3
     71FC 200C 
0676 71FE A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0677 7200 C144  18         mov   tmp0,tmp1
0678 7202 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0679 7204 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     7206 200C 
0680 7208 0586  14         inc   tmp2
0681                       ;-------------------------------------------------------
0682                       ; Loop from end of line until current character
0683                       ;-------------------------------------------------------
0684               ed_pk.action.ins_char_loop:
0685 720A D554  38         movb  *tmp0,*tmp1           ; Move char to the right
0686 720C 0604  14         dec   tmp0
0687 720E 0605  14         dec   tmp1
0688 7210 0606  14         dec   tmp2
0689 7212 16FB  14         jne   ed_pk.action.ins_char_loop
0690                       ;-------------------------------------------------------
0691                       ; Set specified character on current position
0692                       ;-------------------------------------------------------
0693 7214 D560  46         movb  @parm1,*tmp1
     7216 8350 
0694                       ;-------------------------------------------------------
0695                       ; Save variables
0696                       ;-------------------------------------------------------
0697 7218 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     721A 200A 
0698 721C 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     721E 2016 
0699 7220 05A0  34         inc   @fb.row.length        ; @fb.row.length
     7222 2008 
0700                       ;-------------------------------------------------------
0701                       ; Add character in overwrite mode
0702                       ;-------------------------------------------------------
0703               ed_pk.action.ins_char.sanity
0704 7224 0460  28         b     @ed_pk.action.char.overwrite
     7226 72F4 
0705                       ;-------------------------------------------------------
0706                       ; Exit
0707                       ;-------------------------------------------------------
0708               ed_pk.action.ins_char.$$:
0709 7228 0460  28         b     @ed_wait              ; Back to editor main
     722A 6E62 
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
0723 722C 8820  54         c     @fb.row.dirty,@w$ffff
     722E 200A 
     7230 6048 
0724 7232 1604  14         jne   ed_pk.action.ins_line.insert
0725 7234 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     7236 765A 
0726 7238 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     723A 200A 
0727                       ;-------------------------------------------------------
0728                       ; Insert entry in index
0729                       ;-------------------------------------------------------
0730               ed_pk.action.ins_line.insert:
0731 723C 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     723E 74DA 
0732 7240 C820  54         mov   @fb.topline,@parm1
     7242 2004 
     7244 8350 
0733 7246 A820  54         a     @fb.row,@parm1        ; Line number to insert
     7248 2006 
     724A 8350 
0734               
0735 724C C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     724E 2104 
     7250 8352 
0736 7252 06A0  32         bl    @idx.entry.insert     ; Reorganize index
     7254 75D2 
0737 7256 05A0  34         inc   @edb.lines            ; One line more in editor buffer
     7258 2104 
0738                       ;-------------------------------------------------------
0739                       ; Refresh frame buffer and physical screen
0740                       ;-------------------------------------------------------
0741 725A C820  54         mov   @fb.topline,@parm1
     725C 2004 
     725E 8350 
0742 7260 06A0  32         bl    @fb.refresh           ; Refresh frame buffer
     7262 74F6 
0743 7264 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     7266 2016 
0744                       ;-------------------------------------------------------
0745                       ; Exit
0746                       ;-------------------------------------------------------
0747               ed_pk.action.ins_line.$$:
0748 7268 0460  28         b     @ed_wait              ; Back to editor main
     726A 6E62 
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
0762 726C 8820  54         c     @fb.row.dirty,@w$ffff
     726E 200A 
     7270 6048 
0763 7272 1604  14         jne   ed_pk.action.enter.upd_counter
0764 7274 06A0  32         bl    @edb.line.pack        ; Copy line to editor buffer
     7276 765A 
0765 7278 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     727A 200A 
0766                       ;-------------------------------------------------------
0767                       ; Update line counter
0768                       ;-------------------------------------------------------
0769               ed_pk.action.enter.upd_counter:
0770 727C C120  34         mov   @fb.topline,tmp0
     727E 2004 
0771 7280 A120  34         a     @fb.row,tmp0
     7282 2006 
0772 7284 8804  38         c     tmp0,@edb.lines       ; Last line in editor buffer?
     7286 2104 
0773 7288 1602  14         jne   ed_pk.action.newline  ; No, continue newline
0774 728A 05A0  34         inc   @edb.lines            ; Total lines++
     728C 2104 
0775                       ;-------------------------------------------------------
0776                       ; Process newline
0777                       ;-------------------------------------------------------
0778               ed_pk.action.newline:
0779                       ;-------------------------------------------------------
0780                       ; Scroll 1 line if cursor at bottom row of screen
0781                       ;-------------------------------------------------------
0782 728E C120  34         mov   @fb.screenrows,tmp0
     7290 2018 
0783 7292 0604  14         dec   tmp0
0784 7294 8120  34         c     @fb.row,tmp0
     7296 2006 
0785 7298 110A  14         jlt   ed_pk.action.newline.down
0786                       ;-------------------------------------------------------
0787                       ; Scroll
0788                       ;-------------------------------------------------------
0789 729A C120  34         mov   @fb.screenrows,tmp0
     729C 2018 
0790 729E C820  54         mov   @fb.topline,@parm1
     72A0 2004 
     72A2 8350 
0791 72A4 05A0  34         inc   @parm1
     72A6 8350 
0792 72A8 06A0  32         bl    @fb.refresh
     72AA 74F6 
0793 72AC 1004  14         jmp   ed_pk.action.newline.rest
0794                       ;-------------------------------------------------------
0795                       ; Move cursor down a row, there are still rows left
0796                       ;-------------------------------------------------------
0797               ed_pk.action.newline.down:
0798 72AE 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     72B0 2006 
0799 72B2 06A0  32         bl    @down                 ; Row++ VDP cursor
     72B4 632C 
0800                       ;-------------------------------------------------------
0801                       ; Set VDP cursor and save variables
0802                       ;-------------------------------------------------------
0803               ed_pk.action.newline.rest:
0804 72B6 06A0  32         bl    @fb.get.firstnonblank
     72B8 7520 
0805 72BA C120  34         mov   @outparm1,tmp0
     72BC 8360 
0806 72BE C804  38         mov   tmp0,@fb.column
     72C0 200C 
0807 72C2 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
     72C4 633E 
0808 72C6 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
     72C8 7776 
0809 72CA 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     72CC 74DA 
0810 72CE 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     72D0 2016 
0811                       ;-------------------------------------------------------
0812                       ; Exit
0813                       ;-------------------------------------------------------
0814               ed_pk.action.newline.$$:
0815 72D2 0460  28         b     @ed_wait              ; Back to editor main
     72D4 6E62 
0816               
0817               
0818               
0819               
0820               *---------------------------------------------------------------
0821               * Toggle insert/overwrite mode
0822               *---------------------------------------------------------------
0823               ed_pk.action.ins_onoff:
0824 72D6 0560  34         inv   @edb.insmode          ; Toggle insert/overwrite mode
     72D8 210C 
0825                       ;-------------------------------------------------------
0826                       ; Delay
0827                       ;-------------------------------------------------------
0828 72DA 0204  20         li    tmp0,2000
     72DC 07D0 
0829               ed_pk.action.ins_onoff.loop:
0830 72DE 0604  14         dec   tmp0
0831 72E0 16FE  14         jne   ed_pk.action.ins_onoff.loop
0832                       ;-------------------------------------------------------
0833                       ; Exit
0834                       ;-------------------------------------------------------
0835               ed_pk.action.ins_onoff.$$:
0836 72E2 0460  28         b     @task2.cur_visible    ; Update cursor shape
     72E4 73C0 
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
0847 72E6 D805  38         movb  tmp1,@parm1           ; Store character for insert
     72E8 8350 
0848 72EA C120  34         mov   @edb.insmode,tmp0     ; Insert or overwrite ?
     72EC 210C 
0849 72EE 1302  14         jeq   ed_pk.action.char.overwrite
0850                       ;-------------------------------------------------------
0851                       ; Insert mode
0852                       ;-------------------------------------------------------
0853               ed_pk.action.char.insert:
0854 72F0 0460  28         b     @ed_pk.action.ins_char
     72F2 71E2 
0855                       ;-------------------------------------------------------
0856                       ; Overwrite mode
0857                       ;-------------------------------------------------------
0858               ed_pk.action.char.overwrite:
0859 72F4 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     72F6 74DA 
0860 72F8 C120  34         mov   @fb.current,tmp0      ; Get pointer
     72FA 2002 
0861               
0862 72FC D520  46         movb  @parm1,*tmp0          ; Store character in editor buffer
     72FE 8350 
0863 7300 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     7302 200A 
0864 7304 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     7306 2016 
0865               
0866 7308 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     730A 200C 
0867 730C 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     730E 832A 
0868                       ;-------------------------------------------------------
0869                       ; Update line length in frame buffer
0870                       ;-------------------------------------------------------
0871 7310 8820  54         c     @fb.column,@fb.row.length
     7312 200C 
     7314 2008 
0872 7316 1103  14         jlt   ed_pk.action.char.$$  ; column < length line ? Skip further processing
0873 7318 C820  54         mov   @fb.column,@fb.row.length
     731A 200C 
     731C 2008 
0874                       ;-------------------------------------------------------
0875                       ; Exit
0876                       ;-------------------------------------------------------
0877               ed_pk.action.char.$$:
0878 731E 0460  28         b     @ed_wait              ; Back to editor main
     7320 6E62 
0879               
**** **** ****     > tivi.asm.32581
0270               
0271               
0272               
0273               
0274               ***************************************************************
0275               * Task 0 - Copy frame buffer to VDP
0276               ***************************************************************
0277 7322 C120  34 task0   mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
     7324 2016 
0278 7326 133D  14         jeq   task0.$$              ; No, skip update
0279                       ;------------------------------------------------------
0280                       ; Determine how many rows to copy
0281                       ;------------------------------------------------------
0282 7328 8820  54         c     @edb.lines,@fb.screenrows
     732A 2104 
     732C 2018 
0283 732E 1103  14         jlt   task0.setrows.small
0284 7330 C160  34         mov   @fb.screenrows,tmp1   ; Lines to copy
     7332 2018 
0285 7334 1003  14         jmp   task0.copy.framebuffer
0286                       ;------------------------------------------------------
0287                       ; Less lines in editor buffer as rows in frame buffer
0288                       ;------------------------------------------------------
0289               task0.setrows.small:
0290 7336 C160  34         mov   @edb.lines,tmp1       ; Lines to copy
     7338 2104 
0291 733A 0585  14         inc   tmp1
0292                       ;------------------------------------------------------
0293                       ; Determine area to copy
0294                       ;------------------------------------------------------
0295               task0.copy.framebuffer:
0296 733C 3960  72         mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
     733E 200E 
0297                                                   ; 16 bit part is in tmp2!
0298 7340 04C4  14         clr   tmp0                  ; VDP target address
0299 7342 C160  34         mov   @fb.top.ptr,tmp1      ; RAM Source address
     7344 2000 
0300                       ;------------------------------------------------------
0301                       ; Copy memory block
0302                       ;------------------------------------------------------
0303 7346 06A0  32         bl    @xpym2v               ; Copy to VDP
     7348 6252 
0304                                                   ; tmp0 = VDP target address
0305                                                   ; tmp1 = RAM source address
0306                                                   ; tmp2 = Bytes to copy
0307 734A 04E0  34         clr   @fb.dirty             ; Reset frame buffer dirty flag
     734C 2016 
0308                       ;-------------------------------------------------------
0309                       ; Draw EOF marker at end-of-file
0310                       ;-------------------------------------------------------
0311 734E C120  34         mov   @edb.lines,tmp0
     7350 2104 
0312 7352 6120  34         s     @fb.topline,tmp0      ; Y = @edb.lines - @fb.topline
     7354 2004 
0313 7356 0584  14         inc   tmp0                  ; Y++
0314 7358 8120  34         c     @fb.screenrows,tmp0   ; Hide if last line on screen
     735A 2018 
0315 735C 1222  14         jle   task0.$$
0316                       ;-------------------------------------------------------
0317                       ; Draw EOF marker
0318                       ;-------------------------------------------------------
0319               task0.draw_marker:
0320 735E C820  54         mov   @wyx,@fb.yxsave       ; Backup VDP cursor position
     7360 832A 
     7362 2014 
0321 7364 0A84  56         sla   tmp0,8                ; X=0
0322 7366 C804  38         mov   tmp0,@wyx             ; Set VDP cursor
     7368 832A 
0323 736A 06A0  32         bl    @putstr
     736C 6232 
0324 736E 77CA                   data txt_marker       ; Display *EOF*
0325                       ;-------------------------------------------------------
0326                       ; Draw empty line after (and below) EOF marker
0327                       ;-------------------------------------------------------
0328 7370 06A0  32         bl    @setx
     7372 633C 
0329 7374 0005                   data  5               ; Cursor after *EOF* string
0330               
0331 7376 C120  34         mov   @wyx,tmp0
     7378 832A 
0332 737A 0984  56         srl   tmp0,8                ; Right justify
0333 737C 0584  14         inc   tmp0                  ; One time adjust
0334 737E 8120  34         c     @fb.screenrows,tmp0   ; Don't spill on last line on screen
     7380 2018 
0335 7382 1303  14         jeq   !
0336 7384 0206  20         li    tmp2,colrow+colrow-5  ; Repeat count for 2 lines
     7386 009B 
0337 7388 1002  14         jmp   task0.draw_marker.line
0338 738A 0206  20 !       li    tmp2,colrow-5         ; Repeat count for 1 line
     738C 004B 
0339                       ;-------------------------------------------------------
0340                       ; Draw empty line
0341                       ;-------------------------------------------------------
0342               task0.draw_marker.line:
0343 738E 0604  14         dec   tmp0                  ; One time adjust
0344 7390 06A0  32         bl    @yx2pnt               ; Set VDP address in tmp0
     7392 620E 
0345 7394 0205  20         li    tmp1,32               ; Character to write (whitespace)
     7396 0020 
0346 7398 06A0  32         bl    @xfilv                ; Write characters
     739A 60B8 
0347 739C C820  54         mov   @fb.yxsave,@wyx       ; Restore VDP cursor postion
     739E 2014 
     73A0 832A 
0348               *--------------------------------------------------------------
0349               * Task 0 - Exit
0350               *--------------------------------------------------------------
0351               task0.$$:
0352 73A2 0460  28         b     @slotok
     73A4 6CA0 
0353               
0354               
0355               
0356               ***************************************************************
0357               * Task 1 - Copy SAT to VDP
0358               ***************************************************************
0359 73A6 E0A0  34 task1   soc   @wbit0,config          ; Sprite adjustment on
     73A8 6046 
0360 73AA 06A0  32         bl    @yx2px                 ; Calculate pixel position, result in tmp0
     73AC 6348 
0361 73AE C804  38         mov   tmp0,@ramsat           ; Set cursor YX
     73B0 8380 
0362 73B2 1012  14         jmp   task.sub_copy_ramsat   ; Update VDP SAT and exit task
0363               
0364               
0365               ***************************************************************
0366               * Task 2 - Update cursor shape (blink)
0367               ***************************************************************
0368 73B4 0560  34 task2   inv   @fb.curtoggle          ; Flip cursor shape flag
     73B6 2012 
0369 73B8 1303  14         jeq   task2.cur_visible
0370 73BA 04E0  34         clr   @ramsat+2              ; Hide cursor
     73BC 8382 
0371 73BE 100C  14         jmp   task.sub_copy_ramsat   ; Update VDP SAT and exit task
0372               
0373               task2.cur_visible:
0374 73C0 C120  34         mov   @edb.insmode,tmp0      ; Get Editor buffer insert mode
     73C2 210C 
0375 73C4 1303  14         jeq   task2.cur_visible.overwrite_mode
0376                       ;------------------------------------------------------
0377                       ; Cursor in insert mode
0378                       ;------------------------------------------------------
0379               task2.cur_visible.insert_mode:
0380 73C6 0204  20         li    tmp0,>000f
     73C8 000F 
0381 73CA 1002  14         jmp   task2.cur_visible.cursorshape
0382                       ;------------------------------------------------------
0383                       ; Cursor in overwrite mode
0384                       ;------------------------------------------------------
0385               task2.cur_visible.overwrite_mode:
0386 73CC 0204  20         li    tmp0,>020f
     73CE 020F 
0387                       ;------------------------------------------------------
0388                       ; Set cursor shape
0389                       ;------------------------------------------------------
0390               task2.cur_visible.cursorshape:
0391 73D0 C804  38         mov   tmp0,@fb.curshape
     73D2 2010 
0392 73D4 C804  38         mov   tmp0,@ramsat+2
     73D6 8382 
0393               
0394               
0395               
0396               
0397               
0398               
0399               
0400               *--------------------------------------------------------------
0401               * Copy ramsat to VDP SAT and show bottom line - Tasks 1,2
0402               *--------------------------------------------------------------
0403               task.sub_copy_ramsat
0404 73D8 06A0  32         bl    @cpym2v
     73DA 624C 
0405 73DC 2000                   data sprsat,ramsat,4   ; Update sprite
     73DE 8380 
     73E0 0004 
0406               
0407 73E2 C820  54         mov   @wyx,@fb.yxsave
     73E4 832A 
     73E6 2014 
0408                       ;------------------------------------------------------
0409                       ; Show text editing mode
0410                       ;------------------------------------------------------
0411               task.botline.show_mode
0412 73E8 C120  34         mov   @edb.insmode,tmp0
     73EA 210C 
0413 73EC 1605  14         jne   task.botline.show_mode.insert
0414                       ;------------------------------------------------------
0415                       ; Overwrite mode
0416                       ;------------------------------------------------------
0417               task.botline.show_mode.overwrite:
0418 73EE 06A0  32         bl    @putat
     73F0 6244 
0419 73F2 1D32                   byte  29,50
0420 73F4 77D6                   data  txt_ovrwrite
0421 73F6 1004  14         jmp   task.botline.show_linecol
0422                       ;------------------------------------------------------
0423                       ; Insert  mode
0424                       ;------------------------------------------------------
0425               task.botline.show_mode.insert
0426 73F8 06A0  32         bl    @putat
     73FA 6244 
0427 73FC 1D32                   byte  29,50
0428 73FE 77DA                   data  txt_insert
0429                       ;------------------------------------------------------
0430                       ; Show "line,column"
0431                       ;------------------------------------------------------
0432               task.botline.show_linecol:
0433 7400 C820  54         mov   @fb.row,@parm1
     7402 2006 
     7404 8350 
0434 7406 06A0  32         bl    @fb.row2line
     7408 74C6 
0435 740A 05A0  34         inc   @outparm1
     740C 8360 
0436                       ;------------------------------------------------------
0437                       ; Show line
0438                       ;------------------------------------------------------
0439 740E 06A0  32         bl    @putnum
     7410 65F0 
0440 7412 1D40                   byte  29,64            ; YX
0441 7414 8360                   data  outparm1,rambuf
     7416 8390 
0442 7418 3020                   byte  48               ; ASCII offset
0443                             byte  32               ; Padding character
0444                       ;------------------------------------------------------
0445                       ; Show comma
0446                       ;------------------------------------------------------
0447 741A 06A0  32         bl    @putat
     741C 6244 
0448 741E 1D45                   byte  29,69
0449 7420 77C8                   data  txt_delim
0450                       ;------------------------------------------------------
0451                       ; Show column
0452                       ;------------------------------------------------------
0453 7422 06A0  32         bl    @film
     7424 608E 
0454 7426 8396                   data rambuf+6,32,12    ; Clear work buffer with space character
     7428 0020 
     742A 000C 
0455               
0456 742C C820  54         mov   @fb.column,@waux1
     742E 200C 
     7430 833C 
0457 7432 05A0  34         inc   @waux1                 ; Offset 1
     7434 833C 
0458               
0459 7436 06A0  32         bl    @mknum                 ; Convert unsigned number to string
     7438 6572 
0460 743A 833C                   data  waux1,rambuf
     743C 8390 
0461 743E 3020                   byte  48               ; ASCII offset
0462                             byte  32               ; Fill character
0463               
0464 7440 06A0  32         bl    @trimnum               ; Trim number to the left
     7442 65CA 
0465 7444 8390                   data  rambuf,rambuf+6,32
     7446 8396 
     7448 0020 
0466               
0467 744A 0204  20         li    tmp0,>0200
     744C 0200 
0468 744E D804  38         movb  tmp0,@rambuf+6         ; "Fix" number length to clear junk chars
     7450 8396 
0469               
0470 7452 06A0  32         bl    @putat
     7454 6244 
0471 7456 1D46                   byte 29,70
0472 7458 8396                   data rambuf+6          ; Show column
0473                       ;------------------------------------------------------
0474                       ; Show lines in buffer unless on last line in file
0475                       ;------------------------------------------------------
0476 745A C820  54         mov   @fb.row,@parm1
     745C 2006 
     745E 8350 
0477 7460 06A0  32         bl    @fb.row2line
     7462 74C6 
0478 7464 8820  54         c     @edb.lines,@outparm1
     7466 2104 
     7468 8360 
0479 746A 1605  14         jne   task.botline.show_lines_in_buffer
0480               
0481 746C 06A0  32         bl    @putat
     746E 6244 
0482 7470 1D49                   byte 29,73
0483 7472 77D0                   data txt_bottom
0484               
0485 7474 100B  14         jmp   task.botline.$$
0486                       ;------------------------------------------------------
0487                       ; Show lines in buffer
0488                       ;------------------------------------------------------
0489               task.botline.show_lines_in_buffer:
0490 7476 C820  54         mov   @edb.lines,@waux1
     7478 2104 
     747A 833C 
0491 747C 05A0  34         inc   @waux1                 ; Offset 1
     747E 833C 
0492 7480 06A0  32         bl    @putnum
     7482 65F0 
0493 7484 1D49                   byte 29,73             ; YX
0494 7486 833C                   data waux1,rambuf
     7488 8390 
0495 748A 3020                   byte 48
0496                             byte 32
0497                       ;------------------------------------------------------
0498                       ; Exit
0499                       ;------------------------------------------------------
0500               task.botline.$$
0501 748C C820  54         mov   @fb.yxsave,@wyx
     748E 2014 
     7490 832A 
0502 7492 0460  28         b     @slotok                ; Exit running task
     7494 6CA0 
0503               
0504               
0505               
0506               ***************************************************************
0507               *                  fb - Framebuffer module
0508               ***************************************************************
0509                       copy  "fb.asm"
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
0024 7496 0649  14         dect  stack
0025 7498 C64B  30         mov   r11,*stack            ; Save return address
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 749A 0204  20         li    tmp0,fb.top
     749C 3000 
0030 749E C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     74A0 2000 
0031 74A2 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     74A4 2004 
0032 74A6 04E0  34         clr   @fb.row               ; Current row=0
     74A8 2006 
0033 74AA 04E0  34         clr   @fb.column            ; Current column=0
     74AC 200C 
0034 74AE 0204  20         li    tmp0,80
     74B0 0050 
0035 74B2 C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     74B4 200E 
0036 74B6 0204  20         li    tmp0,29
     74B8 001D 
0037 74BA C804  38         mov   tmp0,@fb.screenrows   ; Physical rows on screen = 29
     74BC 2018 
0038 74BE 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     74C0 2016 
0039                       ;------------------------------------------------------
0040                       ; Exit
0041                       ;------------------------------------------------------
0042               fb.init.$$
0043 74C2 0460  28         b     @poprt                ; Return to caller
     74C4 608A 
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
0068 74C6 0649  14         dect  stack
0069 74C8 C64B  30         mov   r11,*stack            ; Save return address
0070                       ;------------------------------------------------------
0071                       ; Calculate line in editor buffer
0072                       ;------------------------------------------------------
0073 74CA C120  34         mov   @parm1,tmp0
     74CC 8350 
0074 74CE A120  34         a     @fb.topline,tmp0
     74D0 2004 
0075 74D2 C804  38         mov   tmp0,@outparm1
     74D4 8360 
0076                       ;------------------------------------------------------
0077                       ; Exit
0078                       ;------------------------------------------------------
0079               fb.row2line$$:
0080 74D6 0460  28         b    @poprt                 ; Return to caller
     74D8 608A 
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
0108 74DA 0649  14         dect  stack
0109 74DC C64B  30         mov   r11,*stack            ; Save return address
0110                       ;------------------------------------------------------
0111                       ; Calculate pointer
0112                       ;------------------------------------------------------
0113 74DE C1A0  34         mov   @fb.row,tmp2
     74E0 2006 
0114 74E2 39A0  72         mpy   @fb.colsline,tmp2     ; tmp3 = row  * colsline
     74E4 200E 
0115 74E6 A1E0  34         a     @fb.column,tmp3       ; tmp3 = tmp3 + column
     74E8 200C 
0116 74EA A1E0  34         a     @fb.top.ptr,tmp3      ; tmp3 = tmp3 + base
     74EC 2000 
0117 74EE C807  38         mov   tmp3,@fb.current
     74F0 2002 
0118                       ;------------------------------------------------------
0119                       ; Exit
0120                       ;------------------------------------------------------
0121               fb.calc_pointer.$$
0122 74F2 0460  28         b    @poprt                 ; Return to caller
     74F4 608A 
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
0140 74F6 0649  14         dect  stack
0141 74F8 C64B  30         mov   r11,*stack            ; Save return address
0142                       ;------------------------------------------------------
0143                       ; Setup starting position in index
0144                       ;------------------------------------------------------
0145 74FA C820  54         mov   @parm1,@fb.topline
     74FC 8350 
     74FE 2004 
0146 7500 04E0  34         clr   @parm2                ; Target row in frame buffer
     7502 8352 
0147                       ;------------------------------------------------------
0148                       ; Unpack line to frame buffer
0149                       ;------------------------------------------------------
0150               fb.refresh.unpack_line:
0151 7504 06A0  32         bl    @edb.line.unpack
     7506 76E8 
0152 7508 05A0  34         inc   @parm1                ; Next line in editor buffer
     750A 8350 
0153 750C 05A0  34         inc   @parm2                ; Next row in frame buffer
     750E 8352 
0154 7510 8820  54         c     @parm2,@fb.screenrows ; Last row reached ?
     7512 8352 
     7514 2018 
0155 7516 11F6  14         jlt   fb.refresh.unpack_line
0156 7518 0720  34         seto  @fb.dirty             ; Refresh screen
     751A 2016 
0157                       ;------------------------------------------------------
0158                       ; Exit
0159                       ;------------------------------------------------------
0160               fb.refresh.$$
0161 751C 0460  28         b    @poprt                 ; Return to caller
     751E 608A 
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
0177 7520 0649  14         dect  stack
0178 7522 C64B  30         mov   r11,*stack            ; Save return address
0179                       ;------------------------------------------------------
0180                       ; Prepare for scanning
0181                       ;------------------------------------------------------
0182 7524 04E0  34         clr   @fb.column
     7526 200C 
0183 7528 06A0  32         bl    @fb.calc_pointer
     752A 74DA 
0184 752C 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     752E 7776 
0185 7530 C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
     7532 2008 
0186 7534 1313  14         jeq   fb.get.firstnonblank.nomatch
0187                                                   ; Exit if empty line
0188 7536 C120  34         mov   @fb.current,tmp0      ; Pointer to current char
     7538 2002 
0189 753A 04C5  14         clr   tmp1
0190                       ;------------------------------------------------------
0191                       ; Scan line for non-blank character
0192                       ;------------------------------------------------------
0193               fb.get.firstnonblank.loop:
0194 753C D174  28         movb  *tmp0+,tmp1           ; Get character
0195 753E 130E  14         jeq   fb.get.firstnonblank.nomatch
0196                                                   ; Exit if empty line
0197 7540 0285  22         ci    tmp1,>2000            ; Whitespace?
     7542 2000 
0198 7544 1503  14         jgt   fb.get.firstnonblank.match
0199 7546 0606  14         dec   tmp2                  ; Counter--
0200 7548 16F9  14         jne   fb.get.firstnonblank.loop
0201 754A 1008  14         jmp   fb.get.firstnonblank.nomatch
0202                       ;------------------------------------------------------
0203                       ; Non-blank character found
0204                       ;------------------------------------------------------
0205               fb.get.firstnonblank.match
0206 754C 6120  34         s     @fb.current,tmp0      ; Calculate column
     754E 2002 
0207 7550 0604  14         dec   tmp0
0208 7552 C804  38         mov   tmp0,@outparm1        ; Save column
     7554 8360 
0209 7556 D805  38         movb  tmp1,@outparm2        ; Save character
     7558 8362 
0210 755A 1004  14         jmp   fb.get.firstnonblank.$$
0211                       ;------------------------------------------------------
0212                       ; No non-blank character found
0213                       ;------------------------------------------------------
0214               fb.get.firstnonblank.nomatch
0215 755C 04E0  34         clr   @outparm1             ; X=0
     755E 8360 
0216 7560 04E0  34         clr   @outparm2             ; Null
     7562 8362 
0217                       ;------------------------------------------------------
0218                       ; Exit
0219                       ;------------------------------------------------------
0220               fb.get.firstnonblank.$$
0221 7564 0460  28         b    @poprt                 ; Return to caller
     7566 608A 
0222               
0223               
0224               
0225               
0226               
0227               
**** **** ****     > tivi.asm.32581
0510               
0511               
0512               ***************************************************************
0513               *              idx - Index management module
0514               ***************************************************************
0515                       copy  "idx.asm"
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
0030 7568 0649  14         dect  stack
0031 756A C64B  30         mov   r11,*stack            ; Save return address
0032                       ;------------------------------------------------------
0033                       ; Initialize
0034                       ;------------------------------------------------------
0035 756C 0204  20         li    tmp0,idx.top
     756E 2200 
0036 7570 C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     7572 2102 
0037                       ;------------------------------------------------------
0038                       ; Create index slot 0
0039                       ;------------------------------------------------------
0040 7574 04F4  30         clr   *tmp0+                ; Set empty pointer
0041 7576 04F4  30         clr   *tmp0+                ; Set packed/unpacked length to 0
0042                       ;------------------------------------------------------
0043                       ; Exit
0044                       ;------------------------------------------------------
0045               idx.init.$$:
0046 7578 0460  28         b     @poprt                ; Return to caller
     757A 608A 
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
0068 757C C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     757E 8350 
0069                       ;------------------------------------------------------
0070                       ; Calculate address of index entry and update
0071                       ;------------------------------------------------------
0072 7580 0A24  56         sla   tmp0,2                ; line number * 4
0073 7582 C920  54         mov   @parm2,@idx.top(tmp0) ; Update index slot -> Pointer
     7584 8352 
     7586 2200 
0074                       ;------------------------------------------------------
0075                       ; Set packed / unpacked length of string and update
0076                       ;------------------------------------------------------
0077 7588 C160  34         mov   @parm3,tmp1           ; Set unpacked length
     758A 8354 
0078 758C C185  18         mov   tmp1,tmp2
0079 758E 06C6  14         swpb  tmp2
0080 7590 D146  18         movb  tmp2,tmp1             ; Set packed length (identical for now!)
0081 7592 C905  38         mov   tmp1,@idx.top+2(tmp0) ; Update index slot -> Lengths
     7594 2202 
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
0092 7596 C804  38         mov   tmp0,@outparm1        ; Pointer to update index entry
     7598 8360 
0093 759A 045B  20         b     *r11                  ; Return
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
0113 759C C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     759E 8350 
0114                       ;------------------------------------------------------
0115                       ; Calculate address of index entry and save pointer
0116                       ;------------------------------------------------------
0117 75A0 0A24  56         sla   tmp0,2                ; line number * 4
0118 75A2 C824  54         mov   @idx.top(tmp0),@outparm1
     75A4 2200 
     75A6 8360 
0119                                                   ; Pointer to deleted line
0120                       ;------------------------------------------------------
0121                       ; Prepare for index reorg
0122                       ;------------------------------------------------------
0123 75A8 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     75AA 8352 
0124 75AC 61A0  34         s     @parm1,tmp2           ; Calculate loop
     75AE 8350 
0125 75B0 1605  14         jne   idx.entry.delete.reorg
0126                       ;------------------------------------------------------
0127                       ; Special treatment if last line
0128                       ;------------------------------------------------------
0129 75B2 0724  34         seto  @idx.top+0(tmp0)
     75B4 2200 
0130 75B6 04E4  34         clr   @idx.top+2(tmp0)
     75B8 2202 
0131 75BA 100A  14         jmp   idx.entry.delete.$$
0132                       ;------------------------------------------------------
0133                       ; Reorganize index entries
0134                       ;------------------------------------------------------
0135               idx.entry.delete.reorg:
0136 75BC C924  54         mov   @idx.top+4(tmp0),@idx.top+0(tmp0)
     75BE 2204 
     75C0 2200 
0137 75C2 C924  54         mov   @idx.top+6(tmp0),@idx.top+2(tmp0)
     75C4 2206 
     75C6 2202 
0138 75C8 0224  22         ai    tmp0,4                ; Next index entry
     75CA 0004 
0139               
0140 75CC 0606  14         dec   tmp2                  ; tmp2--
0141 75CE 16F6  14         jne   idx.entry.delete.reorg
0142                                                   ; Loop unless completed
0143                       ;------------------------------------------------------
0144                       ; Exit
0145                       ;------------------------------------------------------
0146               idx.entry.delete.$$:
0147 75D0 045B  20         b     *r11                  ; Return
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
0167 75D2 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     75D4 8352 
0168                       ;------------------------------------------------------
0169                       ; Calculate address of index entry and save pointer
0170                       ;------------------------------------------------------
0171 75D6 0A24  56         sla   tmp0,2                ; line number * 4
0172                       ;------------------------------------------------------
0173                       ; Prepare for index reorg
0174                       ;------------------------------------------------------
0175 75D8 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     75DA 8352 
0176 75DC 61A0  34         s     @parm1,tmp2           ; Calculate loop
     75DE 8350 
0177 75E0 160B  14         jne   idx.entry.insert.reorg
0178                       ;------------------------------------------------------
0179                       ; Special treatment if last line
0180                       ;------------------------------------------------------
0181 75E2 C924  54         mov   @idx.top+0(tmp0),@idx.top+4(tmp0)
     75E4 2200 
     75E6 2204 
0182 75E8 C924  54         mov   @idx.top+2(tmp0),@idx.top+6(tmp0)
     75EA 2202 
     75EC 2206 
0183 75EE 04E4  34         clr   @idx.top+0(tmp0)      ; Clear new index entry word 1
     75F0 2200 
0184 75F2 04E4  34         clr   @idx.top+2(tmp0)      ; Clear new index entry word 2
     75F4 2202 
0185 75F6 100F  14         jmp   idx.entry.insert.$$
0186                       ;------------------------------------------------------
0187                       ; Reorganize index entries
0188                       ;------------------------------------------------------
0189               idx.entry.insert.reorg:
0190 75F8 05C6  14         inct  tmp2                  ; Adjust one time
0191 75FA C924  54 !       mov   @idx.top+0(tmp0),@idx.top+4(tmp0)
     75FC 2200 
     75FE 2204 
0192 7600 C924  54         mov   @idx.top+2(tmp0),@idx.top+6(tmp0)
     7602 2202 
     7604 2206 
0193 7606 0224  22         ai    tmp0,-4               ; Previous index entry
     7608 FFFC 
0194               
0195 760A 0606  14         dec   tmp2                  ; tmp2--
0196 760C 16F6  14         jne   -!                    ; Loop unless completed
0197 760E 04E4  34         clr   @idx.top+8(tmp0)      ; Clear new index entry word 1
     7610 2208 
0198 7612 04E4  34         clr   @idx.top+10(tmp0)     ; Clear new index entry word 2
     7614 220A 
0199                       ;------------------------------------------------------
0200                       ; Exit
0201                       ;------------------------------------------------------
0202               idx.entry.insert.$$:
0203 7616 045B  20         b     *r11                  ; Return
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
0224 7618 0649  14         dect  stack
0225 761A C64B  30         mov   r11,*stack            ; Save return address
0226                       ;------------------------------------------------------
0227                       ; Get pointer
0228                       ;------------------------------------------------------
0229 761C C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     761E 8350 
0230                       ;------------------------------------------------------
0231                       ; Calculate index entry
0232                       ;------------------------------------------------------
0233 7620 0A24  56         sla   tmp0,2                     ; line number * 4
0234 7622 C824  54         mov   @idx.top(tmp0),@outparm1   ; Index slot -> Pointer
     7624 2200 
     7626 8360 
0235                       ;------------------------------------------------------
0236                       ; Get SAMS page
0237                       ;------------------------------------------------------
0238 7628 C164  34         mov   @idx.top+2(tmp0),tmp1 ; SAMS Page
     762A 2202 
0239 762C 0985  56         srl   tmp1,8                ; Right justify
0240 762E C805  38         mov   tmp1,@outparm2
     7630 8362 
0241                       ;------------------------------------------------------
0242                       ; Get line length
0243                       ;------------------------------------------------------
0244 7632 C164  34         mov   @idx.top+2(tmp0),tmp1
     7634 2202 
0245 7636 0245  22         andi  tmp1,>00ff            ; Get rid of MSB (SAMS page)
     7638 00FF 
0246 763A C805  38         mov   tmp1,@outparm3
     763C 8364 
0247                       ;------------------------------------------------------
0248                       ; Exit
0249                       ;------------------------------------------------------
0250               idx.pointer.get.$$:
0251 763E 0460  28         b     @poprt                ; Return to caller
     7640 608A 
**** **** ****     > tivi.asm.32581
0516               
0517               
0518               ***************************************************************
0519               *               edb - Editor Buffer module
0520               ***************************************************************
0521                       copy  "edb.asm"
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
0026 7642 0649  14         dect  stack
0027 7644 C64B  30         mov   r11,*stack            ; Save return address
0028                       ;------------------------------------------------------
0029                       ; Initialize
0030                       ;------------------------------------------------------
0031 7646 0204  20         li    tmp0,edb.top
     7648 A000 
0032 764A C804  38         mov   tmp0,@edb.top.ptr     ; Set pointer to top of editor buffer
     764C 2100 
0033 764E C804  38         mov   tmp0,@edb.next_free   ; Set pointer to next free line in editor buffer
     7650 210A 
0034 7652 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     7654 210C 
0035               edb.init.$$:
0036                       ;------------------------------------------------------
0037                       ; Exit
0038                       ;------------------------------------------------------
0039 7656 0460  28         b     @poprt                ; Return to caller
     7658 608A 
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
0066 765A 0649  14         dect  stack
0067 765C C64B  30         mov   r11,*stack            ; Save return address
0068                       ;------------------------------------------------------
0069                       ; Get values
0070                       ;------------------------------------------------------
0071 765E C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     7660 200C 
     7662 8390 
0072 7664 04E0  34         clr   @fb.column
     7666 200C 
0073 7668 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
     766A 74DA 
0074                       ;------------------------------------------------------
0075                       ; Prepare scan
0076                       ;------------------------------------------------------
0077 766C 04C4  14         clr   tmp0                  ; Counter
0078 766E C160  34         mov   @fb.current,tmp1      ; Get position
     7670 2002 
0079 7672 C805  38         mov   tmp1,@rambuf+2        ; Save beginning of row
     7674 8392 
0080                       ;------------------------------------------------------
0081                       ; Scan line for >00 byte termination
0082                       ;------------------------------------------------------
0083               edb.line.pack.scan:
0084 7676 D1B5  28         movb  *tmp1+,tmp2           ; Get char
0085 7678 0986  56         srl   tmp2,8                ; Right justify
0086 767A 1302  14         jeq   edb.line.pack.idx     ; Stop scan if >00 found
0087 767C 0584  14         inc   tmp0                  ; Increase string length
0088 767E 10FB  14         jmp   edb.line.pack.scan    ; Next character
0089                       ;------------------------------------------------------
0090                       ; Update index entry
0091                       ;------------------------------------------------------
0092               edb.line.pack.idx:
0093 7680 C820  54         mov   @fb.topline,@parm1    ; parm1 = fb.topline + fb.row
     7682 2004 
     7684 8350 
0094 7686 A820  54         a     @fb.row,@parm1        ;
     7688 2006 
     768A 8350 
0095 768C C804  38         mov   tmp0,@rambuf+4        ; Save length of line
     768E 8394 
0096 7690 1607  14         jne   edb.line.pack.idx.normal
0097                                                   ; tmp0 != 0 ?
0098                       ;------------------------------------------------------
0099                       ; Special handling if empty line (length=0)
0100                       ;------------------------------------------------------
0101 7692 04E0  34         clr   @parm2                ; Set pointer to >0000
     7694 8352 
0102 7696 04E0  34         clr   @parm3                ; Set length of line = 0
     7698 8354 
0103 769A 06A0  32         bl    @idx.entry.update     ; parm1=fb.topline + fb.row
     769C 757C 
0104 769E 101F  14         jmp   edb.line.pack.$$      ; Exit
0105                       ;------------------------------------------------------
0106                       ; Update index and store line in editor buffer
0107                       ;------------------------------------------------------
0108               edb.line.pack.idx.normal:
0109 76A0 C820  54         mov   @edb.next_free,@parm2 ; Block where packed string will reside
     76A2 210A 
     76A4 8352 
0110 76A6 C1A0  34         mov   @rambuf+4,tmp2        ; Number of bytes to copy
     76A8 8394 
0111 76AA C804  38         mov   tmp0,@parm3           ; Set length of line
     76AC 8354 
0112 76AE 06A0  32         bl    @idx.entry.update     ; parm1=fb.topline + fb.row
     76B0 757C 
0113                       ;------------------------------------------------------
0114                       ; Pack line from framebuffer to editor buffer
0115                       ;------------------------------------------------------
0116 76B2 C120  34         mov   @rambuf+2,tmp0        ; Source for memory copy
     76B4 8392 
0117 76B6 C160  34         mov   @edb.next_free,tmp1   ; Destination for memory copy
     76B8 210A 
0118 76BA C1A0  34         mov   @rambuf+4,tmp2        ; Number of bytes to copy
     76BC 8394 
0119                       ;------------------------------------------------------
0120                       ; Pack line from framebuffer to editor buffer
0121                       ;------------------------------------------------------
0122 76BE C120  34         mov   @rambuf+2,tmp0        ; Source for memory copy
     76C0 8392 
0123 76C2 0286  22         ci    tmp2,2
     76C4 0002 
0124 76C6 1506  14         jgt   edb.line.pack.idx.normal.copy
0125                       ;------------------------------------------------------
0126                       ; Special handling 1-2 bytes copy
0127                       ;------------------------------------------------------
0128 76C8 C554  38         mov   *tmp0,*tmp1           ; Copy word
0129 76CA 0204  20         li    tmp0,2                ; Set length=2
     76CC 0002 
0130 76CE A804  38         a     tmp0,@edb.next_free   ; Update pointer to next free block
     76D0 210A 
0131 76D2 1005  14         jmp   edb.line.pack.$$      ; Exit
0132                       ;------------------------------------------------------
0133                       ; Copy memory block
0134                       ;------------------------------------------------------
0135               edb.line.pack.idx.normal.copy:
0136 76D4 06A0  32         bl    @xpym2m               ; Copy memory block
     76D6 629A 
0137                                                   ;   tmp0 = source
0138                                                   ;   tmp1 = destination
0139                                                   ;   tmp2 = bytes to copy
0140 76D8 A820  54         a     @rambuf+4,@edb.next_free
     76DA 8394 
     76DC 210A 
0141                                                   ; Update pointer to next free block
0142                       ;------------------------------------------------------
0143                       ; Exit
0144                       ;------------------------------------------------------
0145               edb.line.pack.$$:
0146 76DE C820  54         mov   @rambuf,@fb.column    ; Retrieve @fb.column
     76E0 8390 
     76E2 200C 
0147 76E4 0460  28         b     @poprt                ; Return to caller
     76E6 608A 
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
0174 76E8 0649  14         dect  stack
0175 76EA C64B  30         mov   r11,*stack            ; Save return address
0176                       ;------------------------------------------------------
0177                       ; Save parameters
0178                       ;------------------------------------------------------
0179 76EC C820  54         mov   @parm1,@rambuf
     76EE 8350 
     76F0 8390 
0180 76F2 C820  54         mov   @parm2,@rambuf+2
     76F4 8352 
     76F6 8392 
0181                       ;------------------------------------------------------
0182                       ; Calculate offset in frame buffer
0183                       ;------------------------------------------------------
0184 76F8 C120  34         mov   @fb.colsline,tmp0
     76FA 200E 
0185 76FC 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
     76FE 8352 
0186 7700 C1A0  34         mov   @fb.top.ptr,tmp2
     7702 2000 
0187 7704 A146  18         a     tmp2,tmp1             ; Add base to offset
0188 7706 C805  38         mov   tmp1,@rambuf+6        ; Destination row in frame buffer
     7708 8396 
0189                       ;------------------------------------------------------
0190                       ; Get length of line to unpack
0191                       ;------------------------------------------------------
0192 770A 06A0  32         bl    @edb.line.getlength   ; Get length of line
     770C 7756 
0193                                                   ; parm1 = Line number
0194 770E C820  54         mov   @outparm1,@rambuf+8   ; Bytes to copy
     7710 8360 
     7712 8398 
0195 7714 1312  14         jeq   edb.line.unpack.clear ; Clear line if length=0
0196                       ;------------------------------------------------------
0197                       ; Index. Calculate address of entry and get pointer
0198                       ;------------------------------------------------------
0199 7716 06A0  32         bl    @idx.pointer.get      ; Get pointer to editor buffer entry
     7718 7618 
0200                                                   ; parm1 = Line number
0201 771A C820  54         mov   @outparm1,@rambuf+4   ; Source memory address in editor buffer
     771C 8360 
     771E 8394 
0202                       ;------------------------------------------------------
0203                       ; Copy line from editor buffer to frame buffer
0204                       ;------------------------------------------------------
0205               edb.line.unpack.copy:
0206 7720 C120  34         mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
     7722 8394 
0207 7724 C160  34         mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
     7726 8396 
0208 7728 C1A0  34         mov   @rambuf+8,tmp2        ; Bytes to copy
     772A 8398 
0209               
0210 772C 0286  22         ci    tmp2,2
     772E 0002 
0211 7730 1203  14         jle   edb.line.unpack.copy.word
0212                       ;------------------------------------------------------
0213                       ; Copy memory block
0214                       ;------------------------------------------------------
0215 7732 06A0  32         bl    @xpym2m               ; Copy line to frame buffer
     7734 629A 
0216                                                   ;   tmp0 = Source address
0217                                                   ;   tmp1 = Target address
0218                                                   ;   tmp2 = Bytes to copy
0219 7736 1001  14         jmp   edb.line.unpack.clear
0220                       ;------------------------------------------------------
0221                       ; Copy single word
0222                       ;------------------------------------------------------
0223               edb.line.unpack.copy.word:
0224 7738 C554  38         mov   *tmp0,*tmp1           ; Copy word
0225                       ;------------------------------------------------------
0226                       ; Clear rest of row in framebuffer
0227                       ;------------------------------------------------------
0228               edb.line.unpack.clear:
0229 773A C120  34         mov   @rambuf+6,tmp0        ; Start of row in frame buffer
     773C 8396 
0230 773E A120  34         a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer
     7740 8398 
0231 7742 0584  14         inc   tmp0                  ; Don't erase last character
0232 7744 04C5  14         clr   tmp1                  ; Fill with >00
0233 7746 C1A0  34         mov   @fb.colsline,tmp2
     7748 200E 
0234 774A 61A0  34         s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
     774C 8398 
0235 774E 06A0  32         bl    @xfilm                ; Clear rest of row
     7750 6094 
0236                       ;------------------------------------------------------
0237                       ; Exit
0238                       ;------------------------------------------------------
0239               edb.line.unpack.$$:
0240 7752 0460  28         b     @poprt                ; Return to caller
     7754 608A 
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
0261 7756 0649  14         dect  stack
0262 7758 C64B  30         mov   r11,*stack            ; Save return address
0263                       ;------------------------------------------------------
0264                       ; Get length
0265                       ;------------------------------------------------------
0266 775A C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     775C 200C 
     775E 8390 
0267 7760 C120  34         mov   @parm1,tmp0           ; Get specified line
     7762 8350 
0268 7764 0A24  56         sla   tmp0,2                ; Line number * 4
0269 7766 C164  34         mov   @idx.top+2(tmp0),tmp1 ; Get index entry line length
     7768 2202 
0270 776A 0245  22         andi  tmp1,>00ff            ; Get rid of packed length
     776C 00FF 
0271 776E C805  38         mov   tmp1,@outparm1        ; Save line length
     7770 8360 
0272                       ;------------------------------------------------------
0273                       ; Exit
0274                       ;------------------------------------------------------
0275               edb.line.getlength.$$:
0276 7772 0460  28         b     @poprt                ; Return to caller
     7774 608A 
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
0297 7776 0649  14         dect  stack
0298 7778 C64B  30         mov   r11,*stack            ; Save return address
0299                       ;------------------------------------------------------
0300                       ; Get length
0301                       ;------------------------------------------------------
0302 777A C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     777C 200C 
     777E 8390 
0303 7780 C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     7782 2004 
0304 7784 A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     7786 2006 
0305 7788 0A24  56         sla   tmp0,2                ; Line number * 4
0306 778A C164  34         mov   @idx.top+2(tmp0),tmp1 ; Get index entry line length
     778C 2202 
0307 778E 0245  22         andi  tmp1,>00ff            ; Get rid of SAMS page
     7790 00FF 
0308 7792 C805  38         mov   tmp1,@fb.row.length   ; Save row length
     7794 2008 
0309                       ;------------------------------------------------------
0310                       ; Exit
0311                       ;------------------------------------------------------
0312               edb.line.getlength2.$$:
0313 7796 0460  28         b     @poprt                ; Return to caller
     7798 608A 
0314               
**** **** ****     > tivi.asm.32581
0522               
0523               
0524               ***************************************************************
0525               *                      Constants
0526               ***************************************************************
0527               romsat:
0528 779A 0303             data >0303,>000f              ; Cursor YX, shape and colour
     779C 000F 
0529               
0530               cursors:
0531 779E 0000             data >0000,>0000,>0000,>001c  ; Cursor 1 - Insert mode
     77A0 0000 
     77A2 0000 
     77A4 001C 
0532 77A6 1010             data >1010,>1010,>1010,>1000  ; Cursor 2 - Insert mode
     77A8 1010 
     77AA 1010 
     77AC 1000 
0533 77AE 1C1C             data >1c1c,>1c1c,>1c1c,>1c00  ; Cursor 3 - Overwrite mode
     77B0 1C1C 
     77B2 1C1C 
     77B4 1C00 
0534               
0535               ***************************************************************
0536               *                       Strings
0537               ***************************************************************
0538               txt_title
0539 77B6 1154             byte  17
0540 77B7 ....             text  'TIVI 191020-32581'
0541                       even
0542               
0543               txt_delim
0544 77C8 012C             byte  1
0545 77C9 ....             text  ','
0546                       even
0547               
0548               txt_marker
0549 77CA 052A             byte  5
0550 77CB ....             text  '*EOF*'
0551                       even
0552               
0553               txt_bottom
0554 77D0 0520             byte  5
0555 77D1 ....             text  '  BOT'
0556                       even
0557               
0558               txt_ovrwrite
0559 77D6 0320             byte  3
0560 77D7 ....             text  '   '
0561                       even
0562               
0563               txt_insert
0564 77DA 0349             byte  3
0565 77DB ....             text  'INS'
0566                       even
0567               
0568 77DE 77DE     end          data    $

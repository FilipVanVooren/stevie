XAS99 CROSS-ASSEMBLER   VERSION 2.0.1
**** **** ****     > tivi_b1.asm.32332
0001               ***************************************************************
0002               *                          TiVi Editor
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2020 // Filip van Vooren
0008               ***************************************************************
0009               * File: tivi_b1.asm                 ; Version 200224-32332
0010               
0011               
0012               ***************************************************************
0013               * BANK 1 - TiVi support modules
0014               ********|*****|*********************|**************************
0015                       aorg  2000                  ;
0016                       copy  "/mnt/2TBHDD/bitbucket/projects/ti994a/spectra2/src/runlib.asm"
**** **** ****     > runlib.asm
0001               *******************************************************************************
0002               *              ___  ____  ____  ___  ____  ____    __    ___
0003               *             / __)(  _ \( ___)/ __)(_  _)(  _ \  /__\  (__ \  v.2021
0004               *             \__ \ )___/ )__)( (__   )(   )   / /(__)\  / _/
0005               *             (___/(__)  (____)\___) (__) (_)\_)(__)(__)(____)
0006               *
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
0076                       copy  "equ_memsetup.asm"         ; Equates runlib scratchpad mem setup
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
0077                       copy  "equ_registers.asm"        ; Equates runlib registers
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
0078                       copy  "equ_portaddr.asm"         ; Equates runlib hw port addresses
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
0079                       copy  "equ_param.asm"            ; Equates runlib parameters
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
0082                       copy  "rom_bankswitch.asm"       ; Bank switch routine
**** **** ****     > rom_bankswitch.asm
0001               * FILE......: rom_bankswitch.asm
0002               * Purpose...: ROM bankswitching Support module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                   BANKSWITCHING FUNCTIONS
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * SWBNK - Switch ROM bank
0010               ***************************************************************
0011               *  BL   @SWBNK
0012               *  DATA P0,P1
0013               *--------------------------------------------------------------
0014               *  P0 = Bank selection address (>600X)
0015               *  P1 = Vector address
0016               *--------------------------------------------------------------
0017               *  B    @SWBNKX
0018               *
0019               *  TMP0 = Bank selection address (>600X)
0020               *  TMP1 = Vector address
0021               *--------------------------------------------------------------
0022               *  Important! The bank-switch routine must be at the exact
0023               *  same location accross banks
0024               ********|*****|*********************|**************************
0025 07D0 C13B  30 swbnk   mov   *r11+,tmp0
0026 07D2 C17B  30         mov   *r11+,tmp1
0027 07D4 04D4  26 swbnkx  clr   *tmp0                 ; Select bank in TMP0
0028 07D6 C155  26         mov   *tmp1,tmp1
0029 07D8 0455  20         b     *tmp1                 ; Switch to routine in TMP1
**** **** ****     > runlib.asm
0084               
0085                       copy  "cpu_constants.asm"        ; Define constants for word/MSB/LSB
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
0012 07DA 0000     w$0000  data  >0000                 ; >0000 0000000000000000
0013 07DC 0001     w$0001  data  >0001                 ; >0001 0000000000000001
0014 07DE 0002     w$0002  data  >0002                 ; >0002 0000000000000010
0015 07E0 0004     w$0004  data  >0004                 ; >0004 0000000000000100
0016 07E2 0008     w$0008  data  >0008                 ; >0008 0000000000001000
0017 07E4 0010     w$0010  data  >0010                 ; >0010 0000000000010000
0018 07E6 0020     w$0020  data  >0020                 ; >0020 0000000000100000
0019 07E8 0040     w$0040  data  >0040                 ; >0040 0000000001000000
0020 07EA 0080     w$0080  data  >0080                 ; >0080 0000000010000000
0021 07EC 0100     w$0100  data  >0100                 ; >0100 0000000100000000
0022 07EE 0200     w$0200  data  >0200                 ; >0200 0000001000000000
0023 07F0 0400     w$0400  data  >0400                 ; >0400 0000010000000000
0024 07F2 0800     w$0800  data  >0800                 ; >0800 0000100000000000
0025 07F4 1000     w$1000  data  >1000                 ; >1000 0001000000000000
0026 07F6 2000     w$2000  data  >2000                 ; >2000 0010000000000000
0027 07F8 4000     w$4000  data  >4000                 ; >4000 0100000000000000
0028 07FA 8000     w$8000  data  >8000                 ; >8000 1000000000000000
0029 07FC FFFF     w$ffff  data  >ffff                 ; >ffff 1111111111111111
0030 07FE D000     w$d000  data  >d000                 ; >d000
0031               *--------------------------------------------------------------
0032               * Byte values - High byte (=MSB) for byte operations
0033               *--------------------------------------------------------------
0034      07DA     hb$00   equ   w$0000                ; >0000
0035      07EC     hb$01   equ   w$0100                ; >0100
0036      07EE     hb$02   equ   w$0200                ; >0200
0037      07F0     hb$04   equ   w$0400                ; >0400
0038      07F2     hb$08   equ   w$0800                ; >0800
0039      07F4     hb$10   equ   w$1000                ; >1000
0040      07F6     hb$20   equ   w$2000                ; >2000
0041      07F8     hb$40   equ   w$4000                ; >4000
0042      07FA     hb$80   equ   w$8000                ; >8000
0043      07FE     hb$d0   equ   w$d000                ; >d000
0044               *--------------------------------------------------------------
0045               * Byte values - Low byte (=LSB) for byte operations
0046               *--------------------------------------------------------------
0047      07DA     lb$00   equ   w$0000                ; >0000
0048      07DC     lb$01   equ   w$0001                ; >0001
0049      07DE     lb$02   equ   w$0002                ; >0002
0050      07E0     lb$04   equ   w$0004                ; >0004
0051      07E2     lb$08   equ   w$0008                ; >0008
0052      07E4     lb$10   equ   w$0010                ; >0010
0053      07E6     lb$20   equ   w$0020                ; >0020
0054      07E8     lb$40   equ   w$0040                ; >0040
0055      07EA     lb$80   equ   w$0080                ; >0080
0056               *--------------------------------------------------------------
0057               * Bit values
0058               *--------------------------------------------------------------
0059               ;                                   ;       0123456789ABCDEF
0060      07DC     wbit15  equ   w$0001                ; >0001 0000000000000001
0061      07DE     wbit14  equ   w$0002                ; >0002 0000000000000010
0062      07E0     wbit13  equ   w$0004                ; >0004 0000000000000100
0063      07E2     wbit12  equ   w$0008                ; >0008 0000000000001000
0064      07E4     wbit11  equ   w$0010                ; >0010 0000000000010000
0065      07E6     wbit10  equ   w$0020                ; >0020 0000000000100000
0066      07E8     wbit9   equ   w$0040                ; >0040 0000000001000000
0067      07EA     wbit8   equ   w$0080                ; >0080 0000000010000000
0068      07EC     wbit7   equ   w$0100                ; >0100 0000000100000000
0069      07EE     wbit6   equ   w$0200                ; >0200 0000001000000000
0070      07F0     wbit5   equ   w$0400                ; >0400 0000010000000000
0071      07F2     wbit4   equ   w$0800                ; >0800 0000100000000000
0072      07F4     wbit3   equ   w$1000                ; >1000 0001000000000000
0073      07F6     wbit2   equ   w$2000                ; >2000 0010000000000000
0074      07F8     wbit1   equ   w$4000                ; >4000 0100000000000000
0075      07FA     wbit0   equ   w$8000                ; >8000 1000000000000000
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
0027      07F6     palon   equ   wbit2                 ; bit 2=1   (VDP9918 PAL version)
0028      07EC     enusr   equ   wbit7                 ; bit 7=1   (Enable user hook)
0029      07E8     enknl   equ   wbit9                 ; bit 9=1   (Enable kernel thread)
0030      07E4     anykey  equ   wbit11                ; BIT 11 in the CONFIG register
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
0018               * >ffdc  wp
0019               * >ffde  st
0020               * >ffe0  r0
0021               * >ffe2  r1
0022               * >ffe4  r2  (config)
0023               * >ffe6  r3
0024               * >ffe8  r4  (tmp0)
0025               * >ffea  r5  (tmp1)
0026               * >ffec  r6  (tmp2)
0027               * >ffee  r7  (tmp3)
0028               * >fff0  r8  (tmp4)
0029               * >fff2  r9  (stack)
0030               * >fff4  r10
0031               * >fff6  r11
0032               * >fff8  r12
0033               * >fffa  r13
0034               * >fffc  r14
0035               * >fffe  r15
0036               ********|*****|*********************|**************************
0037               cpu.crash:
0038 0800 022B  22         ai    r11,-4                ; Remove opcode offset
     0802 FFFC 
0039               *--------------------------------------------------------------
0040               *    Save registers to high memory
0041               *--------------------------------------------------------------
0042 0804 C800  38         mov   r0,@>ffe0
     0806 FFE0 
0043 0808 C801  38         mov   r1,@>ffe2
     080A FFE2 
0044 080C C802  38         mov   r2,@>ffe4
     080E FFE4 
0045 0810 C803  38         mov   r3,@>ffe6
     0812 FFE6 
0046 0814 C804  38         mov   r4,@>ffe8
     0816 FFE8 
0047 0818 C805  38         mov   r5,@>ffea
     081A FFEA 
0048 081C C806  38         mov   r6,@>ffec
     081E FFEC 
0049 0820 C807  38         mov   r7,@>ffee
     0822 FFEE 
0050 0824 C808  38         mov   r8,@>fff0
     0826 FFF0 
0051 0828 C809  38         mov   r9,@>fff2
     082A FFF2 
0052 082C C80A  38         mov   r10,@>fff4
     082E FFF4 
0053 0830 C80B  38         mov   r11,@>fff6
     0832 FFF6 
0054 0834 C80C  38         mov   r12,@>fff8
     0836 FFF8 
0055 0838 C80D  38         mov   r13,@>fffa
     083A FFFA 
0056 083C C80E  38         mov   r14,@>fffc
     083E FFFC 
0057 0840 C80F  38         mov   r15,@>ffff
     0842 FFFF 
0058 0844 02A0  12         stwp  r0
0059 0846 C800  38         mov   r0,@>ffdc
     0848 FFDC 
0060 084A 02C0  12         stst  r0
0061 084C C800  38         mov   r0,@>ffde
     084E FFDE 
0062               *--------------------------------------------------------------
0063               *    Reset system
0064               *--------------------------------------------------------------
0065               cpu.crash.reset:
0066 0850 02E0  18         lwpi  ws1                   ; Activate workspace 1
     0852 8300 
0067 0854 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     0856 8302 
0068 0858 0200  20         li    r0,>4a4a              ; Note that a crash occured (Flag = >4a4a)
     085A 4A4A 
0069 085C 0460  28         b     @runli1               ; Initialize system again (VDP, Memory, etc.)
     085E 1DB4 
0070               *--------------------------------------------------------------
0071               *    Show diagnostics after system reset
0072               *--------------------------------------------------------------
0073               cpu.crash.main:
0074                       ;------------------------------------------------------
0075                       ; Show crash details
0076                       ;------------------------------------------------------
0077 0860 06A0  32         bl    @putat                ; Show crash message
     0862 0BE0 
0078 0864 0000                   data >0000,cpu.crash.msg.crashed
     0866 093A 
0079               
0080 0868 06A0  32         bl    @puthex               ; Put hex value on screen
     086A 1626 
0081 086C 0015                   byte 0,21             ; \ i  p0 = YX position
0082 086E FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0083 0870 8390                   data rambuf           ; | i  p2 = Pointer to ram buffer
0084 0872 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0085                                                   ; /         LSB offset for ASCII digit 0-9
0086                       ;------------------------------------------------------
0087                       ; Show caller details
0088                       ;------------------------------------------------------
0089 0874 06A0  32         bl    @putat                ; Show caller message
     0876 0BE0 
0090 0878 0100                   data >0100,cpu.crash.msg.caller
     087A 0950 
0091               
0092 087C 06A0  32         bl    @puthex               ; Put hex value on screen
     087E 1626 
0093 0880 0115                   byte 1,21             ; \ i  p0 = YX position
0094 0882 FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0095 0884 8390                   data rambuf           ; | i  p2 = Pointer to ram buffer
0096 0886 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0097                                                   ; /         LSB offset for ASCII digit 0-9
0098                       ;------------------------------------------------------
0099                       ; Display labels
0100                       ;------------------------------------------------------
0101 0888 06A0  32         bl    @putat
     088A 0BE0 
0102 088C 0300                   byte 3,0
0103 088E 096A                   data cpu.crash.msg.wp
0104 0890 06A0  32         bl    @putat
     0892 0BE0 
0105 0894 0400                   byte 4,0
0106 0896 0970                   data cpu.crash.msg.st
0107 0898 06A0  32         bl    @putat
     089A 0BE0 
0108 089C 1600                   byte 22,0
0109 089E 0976                   data cpu.crash.msg.source
0110 08A0 06A0  32         bl    @putat
     08A2 0BE0 
0111 08A4 1700                   byte 23,0
0112 08A6 0990                   data cpu.crash.msg.id
0113                       ;------------------------------------------------------
0114                       ; Show crash registers WP, ST, R0 - R15
0115                       ;------------------------------------------------------
0116 08A8 06A0  32         bl    @at                   ; Put cursor at YX
     08AA 0E72 
0117 08AC 0304                   byte 3,4              ; \ i p0 = YX position
0118                                                   ; /
0119               
0120 08AE 0204  20         li    tmp0,>ffdc            ; Crash registers >ffdc - >ffff
     08B0 FFDC 
0121 08B2 04C6  14         clr   tmp2                  ; Loop counter
0122               
0123               cpu.crash.showreg:
0124 08B4 C034  30         mov   *tmp0+,r0             ; Move crash register content to r0
0125               
0126 08B6 0649  14         dect  stack
0127 08B8 C644  30         mov   tmp0,*stack           ; Push tmp0
0128 08BA 0649  14         dect  stack
0129 08BC C645  30         mov   tmp1,*stack           ; Push tmp1
0130 08BE 0649  14         dect  stack
0131 08C0 C646  30         mov   tmp2,*stack           ; Push tmp2
0132                       ;------------------------------------------------------
0133                       ; Display crash register number
0134                       ;------------------------------------------------------
0135               cpu.crash.showreg.label:
0136 08C2 C046  18         mov   tmp2,r1               ; Save register number
0137 08C4 0286  22         ci    tmp2,1                ; Skip labels WP/ST?
     08C6 0001 
0138 08C8 121C  14         jle   cpu.crash.showreg.content
0139                                                   ; Yes, skip
0140               
0141 08CA 0641  14         dect  r1                    ; Adjust because of "dummy" WP/ST registers
0142 08CC 06A0  32         bl    @mknum
     08CE 1630 
0143 08D0 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0144 08D2 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
0145 08D4 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0146                                                   ; /         LSB offset for ASCII digit 0-9
0147               
0148 08D6 06A0  32         bl    @setx                 ; Set cursor X position
     08D8 0E88 
0149 08DA 0000                   data 0                ; \ i  p0 =  Cursor Y position
0150                                                   ; /
0151               
0152 08DC 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     08DE 0BCE 
0153 08E0 8390                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0154                                                   ; /
0155               
0156 08E2 06A0  32         bl    @setx                 ; Set cursor X position
     08E4 0E88 
0157 08E6 0002                   data 2                ; \ i  p0 =  Cursor Y position
0158                                                   ; /
0159               
0160 08E8 0281  22         ci    r1,10
     08EA 000A 
0161 08EC 1102  14         jlt   !
0162 08EE 0620  34         dec   @wyx                  ; x=x-1
     08F0 832A 
0163               
0164 08F2 06A0  32 !       bl    @putstr
     08F4 0BCE 
0165 08F6 0966                   data cpu.crash.msg.r
0166               
0167 08F8 06A0  32         bl    @mknum
     08FA 1630 
0168 08FC 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0169 08FE 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
0170 0900 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0171                                                   ; /         LSB offset for ASCII digit 0-9
0172                       ;------------------------------------------------------
0173                       ; Display crash register content
0174                       ;------------------------------------------------------
0175               cpu.crash.showreg.content:
0176 0902 06A0  32         bl    @mkhex                ; Convert hex word to string
     0904 15A2 
0177 0906 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0178 0908 8390                   data rambuf           ; | i  p1 = Pointer to ram buffer
0179 090A 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0180                                                   ; /         LSB offset for ASCII digit 0-9
0181               
0182 090C 06A0  32         bl    @setx                 ; Set cursor X position
     090E 0E88 
0183 0910 0006                   data 6                ; \ i  p0 =  Cursor Y position
0184                                                   ; /
0185               
0186 0912 06A0  32         bl    @putstr
     0914 0BCE 
0187 0916 0968                   data cpu.crash.msg.marker
0188               
0189 0918 06A0  32         bl    @setx                 ; Set cursor X position
     091A 0E88 
0190 091C 0007                   data 7                ; \ i  p0 =  Cursor Y position
0191                                                   ; /
0192               
0193 091E 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     0920 0BCE 
0194 0922 8390                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0195                                                   ; /
0196               
0197 0924 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0198 0926 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0199 0928 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0200               
0201 092A 06A0  32         bl    @down                 ; y=y+1
     092C 0E78 
0202               
0203 092E 0586  14         inc   tmp2
0204 0930 0286  22         ci    tmp2,17
     0932 0011 
0205 0934 12BF  14         jle   cpu.crash.showreg     ; Show next register
0206                       ;------------------------------------------------------
0207                       ; Kernel takes over
0208                       ;------------------------------------------------------
0209 0936 0460  28         b     @tmgr                 ; Start kernel again for polling keyboard
     0938 1CAE 
0210               
0211               
0212               cpu.crash.msg.crashed
0213 093A 1553             byte  21
0214 093B ....             text  'System crashed near >'
0215                       even
0216               
0217               cpu.crash.msg.caller
0218 0950 1543             byte  21
0219 0951 ....             text  'Caller address near >'
0220                       even
0221               
0222               cpu.crash.msg.r
0223 0966 0152             byte  1
0224 0967 ....             text  'R'
0225                       even
0226               
0227               cpu.crash.msg.marker
0228 0968 013E             byte  1
0229 0969 ....             text  '>'
0230                       even
0231               
0232               cpu.crash.msg.wp
0233 096A 042A             byte  4
0234 096B ....             text  '**WP'
0235                       even
0236               
0237               cpu.crash.msg.st
0238 0970 042A             byte  4
0239 0971 ....             text  '**ST'
0240                       even
0241               
0242               cpu.crash.msg.source
0243 0976 1953             byte  25
0244 0977 ....             text  'Source    tivi_b1.lst.asm'
0245                       even
0246               
0247               cpu.crash.msg.id
0248 0990 1642             byte  22
0249 0991 ....             text  'Build-ID  200224-32332'
0250                       even
0251               
**** **** ****     > runlib.asm
0088                       copy  "vdp_tables.asm"           ; Data used by runtime library
**** **** ****     > vdp_tables.asm
0001               * FILE......: vdp_tables.a99
0002               * Purpose...: Video mode tables
0003               
0004               ***************************************************************
0005               * Graphics mode 1 (32 columns/24 rows)
0006               *--------------------------------------------------------------
0007 09A8 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     09AA 000E 
     09AC 0106 
     09AE 0204 
     09B0 0020 
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
0032 09B2 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     09B4 000E 
     09B6 0106 
     09B8 00F4 
     09BA 0028 
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
0058 09BC 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     09BE 003F 
     09C0 0240 
     09C2 03F4 
     09C4 0050 
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
0084 09C6 04F0     tx8030  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     09C8 003F 
     09CA 0240 
     09CC 03F4 
     09CE 0050 
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
0013 09D0 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 09D2 16FD             data  >16fd                 ; |         jne   mcloop
0015 09D4 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 09D6 D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 09D8 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
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
0038 09DA C0F9  30 popr3   mov   *stack+,r3
0039 09DC C0B9  30 popr2   mov   *stack+,r2
0040 09DE C079  30 popr1   mov   *stack+,r1
0041 09E0 C039  30 popr0   mov   *stack+,r0
0042 09E2 C2F9  30 poprt   mov   *stack+,r11
0043 09E4 045B  20         b     *r11
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
0067 09E6 C13B  30 film    mov   *r11+,tmp0            ; Memory start
0068 09E8 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0069 09EA C1BB  30         mov   *r11+,tmp2            ; Repeat count
0070               *--------------------------------------------------------------
0071               * Do some checks first
0072               *--------------------------------------------------------------
0073 09EC C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
0074 09EE 1604  14         jne   filchk                ; No, continue checking
0075               
0076 09F0 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     09F2 FFCE 
0077 09F4 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     09F6 0800 
0078               *--------------------------------------------------------------
0079               *       Check: 1 byte fill
0080               *--------------------------------------------------------------
0081 09F8 D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
     09FA 830B 
     09FC 830A 
0082               
0083 09FE 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
     0A00 0001 
0084 0A02 1602  14         jne   filchk2
0085 0A04 DD05  32         movb  tmp1,*tmp0+
0086 0A06 045B  20         b     *r11                  ; Exit
0087               *--------------------------------------------------------------
0088               *       Check: 2 byte fill
0089               *--------------------------------------------------------------
0090 0A08 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
     0A0A 0002 
0091 0A0C 1603  14         jne   filchk3
0092 0A0E DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
0093 0A10 DD05  32         movb  tmp1,*tmp0+
0094 0A12 045B  20         b     *r11                  ; Exit
0095               *--------------------------------------------------------------
0096               *       Check: Handle uneven start address
0097               *--------------------------------------------------------------
0098 0A14 C1C4  18 filchk3 mov   tmp0,tmp3
0099 0A16 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     0A18 0001 
0100 0A1A 1605  14         jne   fil16b
0101 0A1C DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
0102 0A1E 0606  14         dec   tmp2
0103 0A20 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
     0A22 0002 
0104 0A24 13F1  14         jeq   filchk2               ; Yes, copy word and exit
0105               *--------------------------------------------------------------
0106               *       Fill memory with 16 bit words
0107               *--------------------------------------------------------------
0108 0A26 C1C6  18 fil16b  mov   tmp2,tmp3
0109 0A28 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     0A2A 0001 
0110 0A2C 1301  14         jeq   dofill
0111 0A2E 0606  14         dec   tmp2                  ; Make TMP2 even
0112 0A30 CD05  34 dofill  mov   tmp1,*tmp0+
0113 0A32 0646  14         dect  tmp2
0114 0A34 16FD  14         jne   dofill
0115               *--------------------------------------------------------------
0116               * Fill last byte if ODD
0117               *--------------------------------------------------------------
0118 0A36 C1C7  18         mov   tmp3,tmp3
0119 0A38 1301  14         jeq   fil.$$
0120 0A3A DD05  32         movb  tmp1,*tmp0+
0121 0A3C 045B  20 fil.$$  b     *r11
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
0140 0A3E C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0141 0A40 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0142 0A42 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0143               *--------------------------------------------------------------
0144               *    Setup VDP write address
0145               *--------------------------------------------------------------
0146 0A44 0264  22 xfilv   ori   tmp0,>4000
     0A46 4000 
0147 0A48 06C4  14         swpb  tmp0
0148 0A4A D804  38         movb  tmp0,@vdpa
     0A4C 8C02 
0149 0A4E 06C4  14         swpb  tmp0
0150 0A50 D804  38         movb  tmp0,@vdpa
     0A52 8C02 
0151               *--------------------------------------------------------------
0152               *    Fill bytes in VDP memory
0153               *--------------------------------------------------------------
0154 0A54 020F  20         li    r15,vdpw              ; Set VDP write address
     0A56 8C00 
0155 0A58 06C5  14         swpb  tmp1
0156 0A5A C820  54         mov   @filzz,@mcloop        ; Setup move command
     0A5C 0A64 
     0A5E 8320 
0157 0A60 0460  28         b     @mcloop               ; Write data to VDP
     0A62 8320 
0158               *--------------------------------------------------------------
0162 0A64 D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
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
0182 0A66 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     0A68 4000 
0183 0A6A 06C4  14 vdra    swpb  tmp0
0184 0A6C D804  38         movb  tmp0,@vdpa
     0A6E 8C02 
0185 0A70 06C4  14         swpb  tmp0
0186 0A72 D804  38         movb  tmp0,@vdpa            ; Set VDP address
     0A74 8C02 
0187 0A76 045B  20         b     *r11                  ; Exit
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
0198 0A78 C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0199 0A7A C17B  30         mov   *r11+,tmp1            ; Get byte to write
0200               *--------------------------------------------------------------
0201               * Set VDP write address
0202               *--------------------------------------------------------------
0203 0A7C 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     0A7E 4000 
0204 0A80 06C4  14         swpb  tmp0                  ; \
0205 0A82 D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     0A84 8C02 
0206 0A86 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0207 0A88 D804  38         movb  tmp0,@vdpa            ; /
     0A8A 8C02 
0208               *--------------------------------------------------------------
0209               * Write byte
0210               *--------------------------------------------------------------
0211 0A8C 06C5  14         swpb  tmp1                  ; LSB to MSB
0212 0A8E D7C5  30         movb  tmp1,*r15             ; Write byte
0213 0A90 045B  20         b     *r11                  ; Exit
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
0232 0A92 C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0233               *--------------------------------------------------------------
0234               * Set VDP read address
0235               *--------------------------------------------------------------
0236 0A94 06C4  14 xvgetb  swpb  tmp0                  ; \
0237 0A96 D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     0A98 8C02 
0238 0A9A 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0239 0A9C D804  38         movb  tmp0,@vdpa            ; /
     0A9E 8C02 
0240               *--------------------------------------------------------------
0241               * Read byte
0242               *--------------------------------------------------------------
0243 0AA0 D120  34         movb  @vdpr,tmp0            ; Read byte
     0AA2 8800 
0244 0AA4 0984  56         srl   tmp0,8                ; Right align
0245 0AA6 045B  20         b     *r11                  ; Exit
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
0264 0AA8 C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0265 0AAA C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0266               *--------------------------------------------------------------
0267               * Calculate PNT base address
0268               *--------------------------------------------------------------
0269 0AAC C144  18         mov   tmp0,tmp1
0270 0AAE 05C5  14         inct  tmp1
0271 0AB0 D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0272 0AB2 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     0AB4 FF00 
0273 0AB6 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0274 0AB8 C805  38         mov   tmp1,@wbase           ; Store calculated base
     0ABA 8328 
0275               *--------------------------------------------------------------
0276               * Dump VDP shadow registers
0277               *--------------------------------------------------------------
0278 0ABC 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     0ABE 8000 
0279 0AC0 0206  20         li    tmp2,8
     0AC2 0008 
0280 0AC4 D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     0AC6 830B 
0281 0AC8 06C5  14         swpb  tmp1
0282 0ACA D805  38         movb  tmp1,@vdpa
     0ACC 8C02 
0283 0ACE 06C5  14         swpb  tmp1
0284 0AD0 D805  38         movb  tmp1,@vdpa
     0AD2 8C02 
0285 0AD4 0225  22         ai    tmp1,>0100
     0AD6 0100 
0286 0AD8 0606  14         dec   tmp2
0287 0ADA 16F4  14         jne   vidta1                ; Next register
0288 0ADC C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     0ADE 833A 
0289 0AE0 045B  20         b     *r11
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
0306 0AE2 C13B  30 putvr   mov   *r11+,tmp0
0307 0AE4 0264  22 putvrx  ori   tmp0,>8000
     0AE6 8000 
0308 0AE8 06C4  14         swpb  tmp0
0309 0AEA D804  38         movb  tmp0,@vdpa
     0AEC 8C02 
0310 0AEE 06C4  14         swpb  tmp0
0311 0AF0 D804  38         movb  tmp0,@vdpa
     0AF2 8C02 
0312 0AF4 045B  20         b     *r11
0313               
0314               
0315               ***************************************************************
0316               * PUTV01  - Put VDP registers #0 and #1
0317               ***************************************************************
0318               *  BL   @PUTV01
0319               ********|*****|*********************|**************************
0320 0AF6 C20B  18 putv01  mov   r11,tmp4              ; Save R11
0321 0AF8 C10E  18         mov   r14,tmp0
0322 0AFA 0984  56         srl   tmp0,8
0323 0AFC 06A0  32         bl    @putvrx               ; Write VR#0
     0AFE 0AE4 
0324 0B00 0204  20         li    tmp0,>0100
     0B02 0100 
0325 0B04 D820  54         movb  @r14lb,@tmp0lb
     0B06 831D 
     0B08 8309 
0326 0B0A 06A0  32         bl    @putvrx               ; Write VR#1
     0B0C 0AE4 
0327 0B0E 0458  20         b     *tmp4                 ; Exit
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
0341 0B10 C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0342 0B12 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0343 0B14 C11B  26         mov   *r11,tmp0             ; Get P0
0344 0B16 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     0B18 7FFF 
0345 0B1A 2120  38         coc   @wbit0,tmp0
     0B1C 07FA 
0346 0B1E 1604  14         jne   ldfnt1
0347 0B20 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     0B22 8000 
0348 0B24 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     0B26 7FFF 
0349               *--------------------------------------------------------------
0350               * Read font table address from GROM into tmp1
0351               *--------------------------------------------------------------
0352 0B28 C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     0B2A 0B92 
0353 0B2C D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     0B2E 9C02 
0354 0B30 06C4  14         swpb  tmp0
0355 0B32 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     0B34 9C02 
0356 0B36 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     0B38 9800 
0357 0B3A 06C5  14         swpb  tmp1
0358 0B3C D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     0B3E 9800 
0359 0B40 06C5  14         swpb  tmp1
0360               *--------------------------------------------------------------
0361               * Setup GROM source address from tmp1
0362               *--------------------------------------------------------------
0363 0B42 D805  38         movb  tmp1,@grmwa
     0B44 9C02 
0364 0B46 06C5  14         swpb  tmp1
0365 0B48 D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     0B4A 9C02 
0366               *--------------------------------------------------------------
0367               * Setup VDP target address
0368               *--------------------------------------------------------------
0369 0B4C C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0370 0B4E 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     0B50 0A66 
0371 0B52 05C8  14         inct  tmp4                  ; R11=R11+2
0372 0B54 C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0373 0B56 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     0B58 7FFF 
0374 0B5A C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     0B5C 0B94 
0375 0B5E C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     0B60 0B96 
0376               *--------------------------------------------------------------
0377               * Copy from GROM to VRAM
0378               *--------------------------------------------------------------
0379 0B62 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0380 0B64 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0381 0B66 D120  34         movb  @grmrd,tmp0
     0B68 9800 
0382               *--------------------------------------------------------------
0383               *   Make font fat
0384               *--------------------------------------------------------------
0385 0B6A 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     0B6C 07FA 
0386 0B6E 1603  14         jne   ldfnt3                ; No, so skip
0387 0B70 D1C4  18         movb  tmp0,tmp3
0388 0B72 0917  56         srl   tmp3,1
0389 0B74 E107  18         soc   tmp3,tmp0
0390               *--------------------------------------------------------------
0391               *   Dump byte to VDP and do housekeeping
0392               *--------------------------------------------------------------
0393 0B76 D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     0B78 8C00 
0394 0B7A 0606  14         dec   tmp2
0395 0B7C 16F2  14         jne   ldfnt2
0396 0B7E 05C8  14         inct  tmp4                  ; R11=R11+2
0397 0B80 020F  20         li    r15,vdpw              ; Set VDP write address
     0B82 8C00 
0398 0B84 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     0B86 7FFF 
0399 0B88 0458  20         b     *tmp4                 ; Exit
0400 0B8A D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     0B8C 07DA 
     0B8E 8C00 
0401 0B90 10E8  14         jmp   ldfnt2
0402               *--------------------------------------------------------------
0403               * Fonts pointer table
0404               *--------------------------------------------------------------
0405 0B92 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     0B94 0200 
     0B96 0000 
0406 0B98 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     0B9A 01C0 
     0B9C 0101 
0407 0B9E 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     0BA0 02A0 
     0BA2 0101 
0408 0BA4 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     0BA6 00E0 
     0BA8 0101 
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
0426 0BAA C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0427 0BAC C3A0  34         mov   @wyx,r14              ; Get YX
     0BAE 832A 
0428 0BB0 098E  56         srl   r14,8                 ; Right justify (remove X)
0429 0BB2 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     0BB4 833A 
0430               *--------------------------------------------------------------
0431               * Do rest of calculation with R15 (16 bit part is there)
0432               * Re-use R14
0433               *--------------------------------------------------------------
0434 0BB6 C3A0  34         mov   @wyx,r14              ; Get YX
     0BB8 832A 
0435 0BBA 024E  22         andi  r14,>00ff             ; Remove Y
     0BBC 00FF 
0436 0BBE A3CE  18         a     r14,r15               ; pos = pos + X
0437 0BC0 A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     0BC2 8328 
0438               *--------------------------------------------------------------
0439               * Clean up before exit
0440               *--------------------------------------------------------------
0441 0BC4 C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0442 0BC6 C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0443 0BC8 020F  20         li    r15,vdpw              ; VDP write address
     0BCA 8C00 
0444 0BCC 045B  20         b     *r11
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
0459 0BCE C17B  30 putstr  mov   *r11+,tmp1
0460 0BD0 D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0461 0BD2 C1CB  18 xutstr  mov   r11,tmp3
0462 0BD4 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     0BD6 0BAA 
0463 0BD8 C2C7  18         mov   tmp3,r11
0464 0BDA 0986  56         srl   tmp2,8                ; Right justify length byte
0465 0BDC 0460  28         b     @xpym2v               ; Display string
     0BDE 0BEE 
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
0480 0BE0 C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     0BE2 832A 
0481 0BE4 0460  28         b     @putstr
     0BE6 0BCE 
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
0020 0BE8 C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 0BEA C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 0BEC C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP write address
0025               *--------------------------------------------------------------
0026 0BEE 0264  22 xpym2v  ori   tmp0,>4000
     0BF0 4000 
0027 0BF2 06C4  14         swpb  tmp0
0028 0BF4 D804  38         movb  tmp0,@vdpa
     0BF6 8C02 
0029 0BF8 06C4  14         swpb  tmp0
0030 0BFA D804  38         movb  tmp0,@vdpa
     0BFC 8C02 
0031               *--------------------------------------------------------------
0032               *    Copy bytes from CPU memory to VRAM
0033               *--------------------------------------------------------------
0034 0BFE 020F  20         li    r15,vdpw              ; Set VDP write address
     0C00 8C00 
0035 0C02 C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     0C04 0C0C 
     0C06 8320 
0036 0C08 0460  28         b     @mcloop               ; Write data to VDP
     0C0A 8320 
0037 0C0C D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
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
0020 0C0E C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 0C10 C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 0C12 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 0C14 06C4  14 xpyv2m  swpb  tmp0
0027 0C16 D804  38         movb  tmp0,@vdpa
     0C18 8C02 
0028 0C1A 06C4  14         swpb  tmp0
0029 0C1C D804  38         movb  tmp0,@vdpa
     0C1E 8C02 
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 0C20 020F  20         li    r15,vdpr              ; Set VDP read address
     0C22 8800 
0034 0C24 C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     0C26 0C2E 
     0C28 8320 
0035 0C2A 0460  28         b     @mcloop               ; Read data from VDP
     0C2C 8320 
0036 0C2E DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
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
0024 0C30 C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 0C32 C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 0C34 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 0C36 C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 0C38 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 0C3A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     0C3C FFCE 
0034 0C3E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     0C40 0800 
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 0C42 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     0C44 0001 
0039 0C46 1603  14         jne   cpym0                 ; No, continue checking
0040 0C48 DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 0C4A 04C6  14         clr   tmp2                  ; Reset counter
0042 0C4C 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 0C4E 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     0C50 7FFF 
0047 0C52 C1C4  18         mov   tmp0,tmp3
0048 0C54 0247  22         andi  tmp3,1
     0C56 0001 
0049 0C58 1618  14         jne   cpyodd                ; Odd source address handling
0050 0C5A C1C5  18 cpym1   mov   tmp1,tmp3
0051 0C5C 0247  22         andi  tmp3,1
     0C5E 0001 
0052 0C60 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 0C62 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     0C64 07FA 
0057 0C66 1605  14         jne   cpym3
0058 0C68 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     0C6A 0C90 
     0C6C 8320 
0059 0C6E 0460  28         b     @mcloop               ; Copy memory and exit
     0C70 8320 
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 0C72 C1C6  18 cpym3   mov   tmp2,tmp3
0064 0C74 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     0C76 0001 
0065 0C78 1301  14         jeq   cpym4
0066 0C7A 0606  14         dec   tmp2                  ; Make TMP2 even
0067 0C7C CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 0C7E 0646  14         dect  tmp2
0069 0C80 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 0C82 C1C7  18         mov   tmp3,tmp3
0074 0C84 1301  14         jeq   cpymz
0075 0C86 D554  38         movb  *tmp0,*tmp1
0076 0C88 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 0C8A 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     0C8C 8000 
0081 0C8E 10E9  14         jmp   cpym2
0082 0C90 DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
**** **** ****     > runlib.asm
0102               
0104                       copy  "copy_grom_cpu.asm"        ; GROM to CPU copy functions
**** **** ****     > copy_grom_cpu.asm
0001               * FILE......: copy_grom_cpu.asm
0002               * Purpose...: GROM -> CPU copy support module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                       GROM COPY FUNCTIONS
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * CPYG2M - Copy GROM memory to CPU memory
0011               ***************************************************************
0012               *  BL   @CPYG2M
0013               *  DATA P0,P1,P2
0014               *--------------------------------------------------------------
0015               *  P0 = GROM source address
0016               *  P1 = CPU target address
0017               *  P2 = Number of bytes to copy
0018               *--------------------------------------------------------------
0019               *  BL @CPYG2M
0020               *
0021               *  TMP0 = GROM source address
0022               *  TMP1 = CPU target address
0023               *  TMP2 = Number of bytes to copy
0024               ********|*****|*********************|**************************
0025 0C92 C13B  30 cpyg2m  mov   *r11+,tmp0            ; Memory source address
0026 0C94 C17B  30         mov   *r11+,tmp1            ; Memory target address
0027 0C96 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0028               *--------------------------------------------------------------
0029               * Setup GROM source address
0030               *--------------------------------------------------------------
0031 0C98 D804  38 xpyg2m  movb  tmp0,@grmwa
     0C9A 9C02 
0032 0C9C 06C4  14         swpb  tmp0
0033 0C9E D804  38         movb  tmp0,@grmwa
     0CA0 9C02 
0034               *--------------------------------------------------------------
0035               *    Copy bytes from GROM to CPU memory
0036               *--------------------------------------------------------------
0037 0CA2 0204  20         li    tmp0,grmrd            ; Set TMP0 to GROM data port
     0CA4 9800 
0038 0CA6 C820  54         mov   @tmp003,@mcloop       ; Setup copy command
     0CA8 0CB0 
     0CAA 8320 
0039 0CAC 0460  28         b     @mcloop               ; Copy bytes
     0CAE 8320 
0040 0CB0 DD54     tmp003  data  >dd54                 ; MOVB *TMP0,*TMP1+
**** **** ****     > runlib.asm
0106               
0108                       copy  "copy_grom_vram.asm"       ; GROM to VRAM copy functions
**** **** ****     > copy_grom_vram.asm
0001               * FILE......: copy_grom_vram.asm
0002               * Purpose...: GROM to VDP vram copy support module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                       GROM COPY FUNCTIONS
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * CPYG2V - Copy GROM memory to VRAM memory
0010               ***************************************************************
0011               *  BL   @CPYG2V
0012               *  DATA P0,P1,P2
0013               *--------------------------------------------------------------
0014               *  P0 = GROM source address
0015               *  P1 = VDP target address
0016               *  P2 = Number of bytes to copy
0017               *--------------------------------------------------------------
0018               *  BL @CPYG2V
0019               *
0020               *  TMP0 = GROM source address
0021               *  TMP1 = VDP target address
0022               *  TMP2 = Number of bytes to copy
0023               ********|*****|*********************|**************************
0024 0CB2 C13B  30 cpyg2v  mov   *r11+,tmp0            ; Memory source address
0025 0CB4 C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 0CB6 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Setup GROM source address
0029               *--------------------------------------------------------------
0030 0CB8 D804  38 xpyg2v  movb  tmp0,@grmwa
     0CBA 9C02 
0031 0CBC 06C4  14         swpb  tmp0
0032 0CBE D804  38         movb  tmp0,@grmwa
     0CC0 9C02 
0033               *--------------------------------------------------------------
0034               * Setup VDP target address
0035               *--------------------------------------------------------------
0036 0CC2 0265  22         ori   tmp1,>4000
     0CC4 4000 
0037 0CC6 06C5  14         swpb  tmp1
0038 0CC8 D805  38         movb  tmp1,@vdpa
     0CCA 8C02 
0039 0CCC 06C5  14         swpb  tmp1
0040 0CCE D805  38         movb  tmp1,@vdpa            ; Set VDP target address
     0CD0 8C02 
0041               *--------------------------------------------------------------
0042               *    Copy bytes from GROM to VDP memory
0043               *--------------------------------------------------------------
0044 0CD2 0207  20         li    tmp3,grmrd            ; Set TMP3 to GROM data port
     0CD4 9800 
0045 0CD6 020F  20         li    r15,vdpw              ; Set VDP write address
     0CD8 8C00 
0046 0CDA C820  54         mov   @tmp002,@mcloop       ; Setup copy command
     0CDC 0CE4 
     0CDE 8320 
0047 0CE0 0460  28         b     @mcloop               ; Copy bytes
     0CE2 8320 
0048 0CE4 D7D7     tmp002  data  >d7d7                 ; MOVB *TMP3,*R15
**** **** ****     > runlib.asm
0110               
0112                       copy  "cpu_sams_support.asm"     ; CPU support for SAMS memory card
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
0017               *    (bl  @sams.page.set)
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
0062 0CE6 C13B  30         mov   *r11+,tmp0            ; Memory address
0063               xsams.page.get:
0064 0CE8 0649  14         dect  stack
0065 0CEA C64B  30         mov   r11,*stack            ; Push return address
0066 0CEC 0649  14         dect  stack
0067 0CEE C640  30         mov   r0,*stack             ; Push r0
0068 0CF0 0649  14         dect  stack
0069 0CF2 C64C  30         mov   r12,*stack            ; Push r12
0070               *--------------------------------------------------------------
0071               * Determine memory bank
0072               *--------------------------------------------------------------
0073 0CF4 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
0074 0CF6 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
0075               
0076 0CF8 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
     0CFA 4000 
0077 0CFC C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
     0CFE 833E 
0078               *--------------------------------------------------------------
0079               * Switch memory bank to specified SAMS page
0080               *--------------------------------------------------------------
0081 0D00 020C  20         li    r12,>1e00             ; SAMS CRU address
     0D02 1E00 
0082 0D04 04C0  14         clr   r0
0083 0D06 1D00  20         sbo   0                     ; Enable access to SAMS registers
0084 0D08 D014  26         movb  *tmp0,r0              ; Get SAMS page number
0085 0D0A D100  18         movb  r0,tmp0
0086 0D0C 0984  56         srl   tmp0,8                ; Right align
0087 0D0E C804  38         mov   tmp0,@waux1           ; Save SAMS page number
     0D10 833C 
0088 0D12 1E00  20         sbz   0                     ; Disable access to SAMS registers
0089               *--------------------------------------------------------------
0090               * Exit
0091               *--------------------------------------------------------------
0092               sams.page.get.exit:
0093 0D14 C339  30         mov   *stack+,r12           ; Pop r12
0094 0D16 C039  30         mov   *stack+,r0            ; Pop r0
0095 0D18 C2F9  30         mov   *stack+,r11           ; Pop return address
0096 0D1A 045B  20         b     *r11                  ; Return to caller
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
0131 0D1C C13B  30         mov   *r11+,tmp0            ; Get SAMS page
0132 0D1E C17B  30         mov   *r11+,tmp1            ; Get memory address
0133               xsams.page.set:
0134 0D20 0649  14         dect  stack
0135 0D22 C64B  30         mov   r11,*stack            ; Push return address
0136 0D24 0649  14         dect  stack
0137 0D26 C640  30         mov   r0,*stack             ; Push r0
0138 0D28 0649  14         dect  stack
0139 0D2A C64C  30         mov   r12,*stack            ; Push r12
0140 0D2C 0649  14         dect  stack
0141 0D2E C644  30         mov   tmp0,*stack           ; Push tmp0
0142 0D30 0649  14         dect  stack
0143 0D32 C645  30         mov   tmp1,*stack           ; Push tmp1
0144               *--------------------------------------------------------------
0145               * Determine memory bank
0146               *--------------------------------------------------------------
0147 0D34 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0148 0D36 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0149               *--------------------------------------------------------------
0150               * Sanity check on SAMS register
0151               *--------------------------------------------------------------
0152 0D38 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
     0D3A 001E 
0153 0D3C 150A  14         jgt   !
0154 0D3E 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
     0D40 0004 
0155 0D42 1107  14         jlt   !
0156 0D44 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
     0D46 0012 
0157 0D48 1508  14         jgt   sams.page.set.switch_page
0158 0D4A 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
     0D4C 0006 
0159 0D4E 1501  14         jgt   !
0160 0D50 1004  14         jmp   sams.page.set.switch_page
0161                       ;------------------------------------------------------
0162                       ; Crash the system
0163                       ;------------------------------------------------------
0164 0D52 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     0D54 FFCE 
0165 0D56 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     0D58 0800 
0166               *--------------------------------------------------------------
0167               * Switch memory bank to specified SAMS page
0168               *--------------------------------------------------------------
0169               sams.page.set.switch_page
0170 0D5A 020C  20         li    r12,>1e00             ; SAMS CRU address
     0D5C 1E00 
0171 0D5E C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0172 0D60 06C0  14         swpb  r0                    ; LSB to MSB
0173 0D62 1D00  20         sbo   0                     ; Enable access to SAMS registers
0174 0D64 D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     0D66 4000 
0175 0D68 1E00  20         sbz   0                     ; Disable access to SAMS registers
0176               *--------------------------------------------------------------
0177               * Exit
0178               *--------------------------------------------------------------
0179               sams.page.set.exit:
0180 0D6A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0181 0D6C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0182 0D6E C339  30         mov   *stack+,r12           ; Pop r12
0183 0D70 C039  30         mov   *stack+,r0            ; Pop r0
0184 0D72 C2F9  30         mov   *stack+,r11           ; Pop return address
0185 0D74 045B  20         b     *r11                  ; Return to caller
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
0199 0D76 020C  20         li    r12,>1e00             ; SAMS CRU address
     0D78 1E00 
0200 0D7A 1D01  20         sbo   1                     ; Enable SAMS mapper
0201               *--------------------------------------------------------------
0202               * Exit
0203               *--------------------------------------------------------------
0204               sams.mapping.on.exit:
0205 0D7C 045B  20         b     *r11                  ; Return to caller
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
0222 0D7E 020C  20         li    r12,>1e00             ; SAMS CRU address
     0D80 1E00 
0223 0D82 1E01  20         sbz   1                     ; Disable SAMS mapper
0224               *--------------------------------------------------------------
0225               * Exit
0226               *--------------------------------------------------------------
0227               sams.mapping.off.exit:
0228 0D84 045B  20         b     *r11                  ; Return to caller
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
0255 0D86 C1FB  30         mov   *r11+,tmp3            ; Get P0
0256               xsams.layout:
0257 0D88 0649  14         dect  stack
0258 0D8A C64B  30         mov   r11,*stack            ; Save return address
0259 0D8C 0649  14         dect  stack
0260 0D8E C644  30         mov   tmp0,*stack           ; Save tmp0
0261 0D90 0649  14         dect  stack
0262 0D92 C645  30         mov   tmp1,*stack           ; Save tmp1
0263 0D94 0649  14         dect  stack
0264 0D96 C646  30         mov   tmp2,*stack           ; Save tmp2
0265 0D98 0649  14         dect  stack
0266 0D9A C647  30         mov   tmp3,*stack           ; Save tmp3
0267                       ;------------------------------------------------------
0268                       ; Initialize
0269                       ;------------------------------------------------------
0270 0D9C 0206  20         li    tmp2,8                ; Set loop counter
     0D9E 0008 
0271                       ;------------------------------------------------------
0272                       ; Set SAMS memory pages
0273                       ;------------------------------------------------------
0274               sams.layout.loop:
0275 0DA0 C177  30         mov   *tmp3+,tmp1           ; Get memory address
0276 0DA2 C137  30         mov   *tmp3+,tmp0           ; Get SAMS page
0277               
0278 0DA4 06A0  32         bl    @xsams.page.set       ; \ Switch SAMS page
     0DA6 0D20 
0279                                                   ; | i  tmp0 = SAMS page
0280                                                   ; / i  tmp1 = Memory address
0281               
0282 0DA8 0606  14         dec   tmp2                  ; Next iteration
0283 0DAA 16FA  14         jne   sams.layout.loop      ; Loop until done
0284                       ;------------------------------------------------------
0285                       ; Exit
0286                       ;------------------------------------------------------
0287               sams.init.exit:
0288 0DAC 06A0  32         bl    @sams.mapping.on      ; \ Turn on SAMS mapping for
     0DAE 0D76 
0289                                                   ; / activating changes.
0290               
0291 0DB0 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0292 0DB2 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0293 0DB4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0294 0DB6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0295 0DB8 C2F9  30         mov   *stack+,r11           ; Pop r11
0296 0DBA 045B  20         b     *r11                  ; Return to caller
0297               
0298               
0299               
0300               ***************************************************************
0301               * sams.reset.layout
0302               * Reset SAMS memory banks to standard layout
0303               ***************************************************************
0304               * bl  @sams.reset.layout
0305               *--------------------------------------------------------------
0306               * OUTPUT
0307               * none
0308               *--------------------------------------------------------------
0309               * Register usage
0310               * none
0311               ********|*****|*********************|**************************
0312               sams.reset.layout:
0313 0DBC 0649  14         dect  stack
0314 0DBE C64B  30         mov   r11,*stack            ; Save return address
0315                       ;------------------------------------------------------
0316                       ; Set SAMS standard layout
0317                       ;------------------------------------------------------
0318 0DC0 06A0  32         bl    @sams.layout
     0DC2 0D86 
0319 0DC4 0DCA                   data sams.reset.layout.data
0320                       ;------------------------------------------------------
0321                       ; Exit
0322                       ;------------------------------------------------------
0323               sams.reset.layout.exit:
0324 0DC6 C2F9  30         mov   *stack+,r11           ; Pop r11
0325 0DC8 045B  20         b     *r11                  ; Return to caller
0326               ***************************************************************
0327               * SAMS standard page layout table (16 words)
0328               *--------------------------------------------------------------
0329               sams.reset.layout.data:
0330 0DCA 2000             data  >2000,>0002           ; >2000-2fff, SAMS page >02
     0DCC 0002 
0331 0DCE 3000             data  >3000,>0003           ; >3000-3fff, SAMS page >03
     0DD0 0003 
0332 0DD2 A000             data  >a000,>000a           ; >a000-afff, SAMS page >0a
     0DD4 000A 
0333 0DD6 B000             data  >b000,>000b           ; >b000-bfff, SAMS page >0b
     0DD8 000B 
0334 0DDA C000             data  >c000,>000c           ; >c000-cfff, SAMS page >0c
     0DDC 000C 
0335 0DDE D000             data  >d000,>000d           ; >d000-dfff, SAMS page >0d
     0DE0 000D 
0336 0DE2 E000             data  >e000,>000e           ; >e000-efff, SAMS page >0e
     0DE4 000E 
0337 0DE6 F000             data  >f000,>000f           ; >f000-ffff, SAMS page >0f
     0DE8 000F 
0338               
0339               
0340               
0341               ***************************************************************
0342               * sams.copy.layout
0343               * Copy SAMS memory layout
0344               ***************************************************************
0345               * bl  @sams.copy.layout
0346               *     data P0
0347               *--------------------------------------------------------------
0348               * P0 = Pointer to 8 words RAM buffer for results
0349               *--------------------------------------------------------------
0350               * OUTPUT
0351               * RAM buffer will have the SAMS page number for each range
0352               * 2000-2fff, 3000-3fff, a000-afff, b000-bfff, ...
0353               *--------------------------------------------------------------
0354               * Register usage
0355               * tmp0, tmp1, tmp2, tmp3
0356               ***************************************************************
0357               sams.copy.layout:
0358 0DEA C1FB  30         mov   *r11+,tmp3            ; Get P0
0359               
0360 0DEC 0649  14         dect  stack
0361 0DEE C64B  30         mov   r11,*stack            ; Push return address
0362 0DF0 0649  14         dect  stack
0363 0DF2 C644  30         mov   tmp0,*stack           ; Push tmp0
0364 0DF4 0649  14         dect  stack
0365 0DF6 C645  30         mov   tmp1,*stack           ; Push tmp1
0366 0DF8 0649  14         dect  stack
0367 0DFA C646  30         mov   tmp2,*stack           ; Push tmp2
0368 0DFC 0649  14         dect  stack
0369 0DFE C647  30         mov   tmp3,*stack           ; Push tmp3
0370                       ;------------------------------------------------------
0371                       ; Copy SAMS layout
0372                       ;------------------------------------------------------
0373 0E00 0205  20         li    tmp1,sams.copy.layout.data
     0E02 0E22 
0374 0E04 0206  20         li    tmp2,8                ; Set loop counter
     0E06 0008 
0375                       ;------------------------------------------------------
0376                       ; Set SAMS memory pages
0377                       ;------------------------------------------------------
0378               sams.copy.layout.loop:
0379 0E08 C135  30         mov   *tmp1+,tmp0           ; Get memory address
0380 0E0A 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
     0E0C 0CE8 
0381                                                   ; | i  tmp0   = Memory address
0382                                                   ; / o  @waux1 = SAMS page
0383               
0384 0E0E CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
     0E10 833C 
0385               
0386 0E12 0606  14         dec   tmp2                  ; Next iteration
0387 0E14 16F9  14         jne   sams.copy.layout.loop ; Loop until done
0388                       ;------------------------------------------------------
0389                       ; Exit
0390                       ;------------------------------------------------------
0391               sams.copy.layout.exit:
0392 0E16 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0393 0E18 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0394 0E1A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0395 0E1C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0396 0E1E C2F9  30         mov   *stack+,r11           ; Pop r11
0397 0E20 045B  20         b     *r11                  ; Return to caller
0398               ***************************************************************
0399               * SAMS memory range table (8 words)
0400               *--------------------------------------------------------------
0401               sams.copy.layout.data:
0402 0E22 2000             data  >2000                 ; >2000-2fff
0403 0E24 3000             data  >3000                 ; >3000-3fff
0404 0E26 A000             data  >a000                 ; >a000-afff
0405 0E28 B000             data  >b000                 ; >b000-bfff
0406 0E2A C000             data  >c000                 ; >c000-cfff
0407 0E2C D000             data  >d000                 ; >d000-dfff
0408 0E2E E000             data  >e000                 ; >e000-efff
0409 0E30 F000             data  >f000                 ; >f000-ffff
0410               
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
0009 0E32 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     0E34 FFBF 
0010 0E36 0460  28         b     @putv01
     0E38 0AF6 
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 0E3A 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     0E3C 0040 
0018 0E3E 0460  28         b     @putv01
     0E40 0AF6 
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 0E42 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     0E44 FFDF 
0026 0E46 0460  28         b     @putv01
     0E48 0AF6 
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 0E4A 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     0E4C 0020 
0034 0E4E 0460  28         b     @putv01
     0E50 0AF6 
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
0010 0E52 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     0E54 FFFE 
0011 0E56 0460  28         b     @putv01
     0E58 0AF6 
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 0E5A 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     0E5C 0001 
0019 0E5E 0460  28         b     @putv01
     0E60 0AF6 
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 0E62 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     0E64 FFFD 
0027 0E66 0460  28         b     @putv01
     0E68 0AF6 
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 0E6A 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     0E6C 0002 
0035 0E6E 0460  28         b     @putv01
     0E70 0AF6 
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
0018 0E72 C83B  50 at      mov   *r11+,@wyx
     0E74 832A 
0019 0E76 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 0E78 B820  54 down    ab    @hb$01,@wyx
     0E7A 07EC 
     0E7C 832A 
0028 0E7E 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 0E80 7820  54 up      sb    @hb$01,@wyx
     0E82 07EC 
     0E84 832A 
0037 0E86 045B  20         b     *r11
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
0049 0E88 C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 0E8A D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     0E8C 832A 
0051 0E8E C804  38         mov   tmp0,@wyx             ; Save as new YX position
     0E90 832A 
0052 0E92 045B  20         b     *r11
**** **** ****     > runlib.asm
0126               
0128                       copy  "vdp_yx2px_calc.asm"       ; VDP calculate pixel pos for YX coord
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
0021 0E94 C120  34 yx2px   mov   @wyx,tmp0
     0E96 832A 
0022 0E98 C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 0E9A 06C4  14         swpb  tmp0                  ; Y<->X
0024 0E9C 04C5  14         clr   tmp1                  ; Clear before copy
0025 0E9E D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 0EA0 20A0  38         coc   @wbit1,config         ; f18a present ?
     0EA2 07F8 
0030 0EA4 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 0EA6 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     0EA8 833A 
     0EAA 0ED4 
0032 0EAC 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 0EAE 0A15  56         sla   tmp1,1                ; X = X * 2
0035 0EB0 B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 0EB2 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     0EB4 0500 
0037 0EB6 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 0EB8 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 0EBA 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 0EBC 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 0EBE D105  18         movb  tmp1,tmp0
0051 0EC0 06C4  14         swpb  tmp0                  ; X<->Y
0052 0EC2 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     0EC4 07FA 
0053 0EC6 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 0EC8 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     0ECA 07EC 
0059 0ECC 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     0ECE 07FE 
0060 0ED0 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 0ED2 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 0ED4 0050            data   80
0067               
0068               
**** **** ****     > runlib.asm
0130               
0132                       copy  "vdp_px2yx_calc.asm"       ; VDP calculate YX coord for pixel pos
**** **** ****     > vdp_px2yx_calc.asm
0001               * FILE......: vdp_px2yx_calc.asm
0002               * Purpose...: Calculate YX coordinate for pixel position
0003               
0004               ***************************************************************
0005               * PX2YX - Get YX tile position for specified YX pixel position
0006               ***************************************************************
0007               *  BL   @PX2YX
0008               *--------------------------------------------------------------
0009               *  INPUT
0010               *  TMP0   = Pixel YX position
0011               *
0012               *  (CONFIG:0 = 1) = Skip sprite adjustment
0013               *--------------------------------------------------------------
0014               *  OUTPUT
0015               *  TMP0HB = Y tile position
0016               *  TMP0LB = X tile position
0017               *  TMP1HB = Y pixel offset
0018               *  TMP1LB = X pixel offset
0019               *--------------------------------------------------------------
0020               *  Remarks
0021               *  This subroutine does not support multicolor or text mode
0022               ********|*****|*********************|**************************
0023 0ED6 20A0  38 px2yx   coc   @wbit0,config         ; Skip sprite adjustment ?
     0ED8 07FA 
0024 0EDA 1302  14         jeq   px2yx1
0025 0EDC 0224  22         ai    tmp0,>0100            ; Adjust Y. Top of screen is at >FF
     0EDE 0100 
0026 0EE0 C144  18 px2yx1  mov   tmp0,tmp1             ; Copy YX
0027 0EE2 C184  18         mov   tmp0,tmp2             ; Copy YX
0028               *--------------------------------------------------------------
0029               * Calculate Y tile position
0030               *--------------------------------------------------------------
0031 0EE4 09B4  56         srl   tmp0,11               ; Y: Move to TMP0LB & (Y = Y / 8)
0032               *--------------------------------------------------------------
0033               * Calculate Y pixel offset
0034               *--------------------------------------------------------------
0035 0EE6 C1C4  18         mov   tmp0,tmp3             ; Y: Copy Y tile to TMP3LB
0036 0EE8 0AB7  56         sla   tmp3,11               ; Y: Move to TMP3HB & (Y = Y * 8)
0037 0EEA 0507  16         neg   tmp3
0038 0EEC B1C5  18         ab    tmp1,tmp3             ; Y: offset = Y pixel old + (-Y) pixel new
0039               *--------------------------------------------------------------
0040               * Calculate X tile position
0041               *--------------------------------------------------------------
0042 0EEE 0245  22         andi  tmp1,>00ff            ; Clear TMP1HB
     0EF0 00FF 
0043 0EF2 0A55  56         sla   tmp1,5                ; X: Move to TMP1HB & (X = X / 8)
0044 0EF4 D105  18         movb  tmp1,tmp0             ; X: TMP0 <-- XY tile position
0045 0EF6 06C4  14         swpb  tmp0                  ; XY tile position <-> YX tile position
0046               *--------------------------------------------------------------
0047               * Calculate X pixel offset
0048               *--------------------------------------------------------------
0049 0EF8 0245  22         andi  tmp1,>ff00            ; X: Get rid of remaining junk in TMP1LB
     0EFA FF00 
0050 0EFC 0A35  56         sla   tmp1,3                ; X: (X = X * 8)
0051 0EFE 0505  16         neg   tmp1
0052 0F00 06C6  14         swpb  tmp2                  ; YX <-> XY
0053 0F02 B146  18         ab    tmp2,tmp1             ; offset X = X pixel old  + (-X) pixel new
0054 0F04 06C5  14         swpb  tmp1                  ; X0 <-> 0X
0055 0F06 D147  18         movb  tmp3,tmp1             ; 0X --> YX
0056 0F08 045B  20         b     *r11                  ; Exit
**** **** ****     > runlib.asm
0134               
0136                       copy  "vdp_bitmap.asm"           ; VDP Bitmap functions
**** **** ****     > vdp_bitmap.asm
0001               * FILE......: vdp_bitmap.asm
0002               * Purpose...: VDP bitmap support module
0003               
0004               ***************************************************************
0005               * BITMAP - Set tiles for displaying bitmap picture
0006               ***************************************************************
0007               *  BL   @BITMAP
0008               ********|*****|*********************|**************************
0009 0F0A C1CB  18 bitmap  mov   r11,tmp3              ; Save R11
0010 0F0C C120  34         mov   @wbase,tmp0           ; Get PNT base address
     0F0E 8328 
0011 0F10 06A0  32         bl    @vdwa                 ; Setup VDP write address
     0F12 0A66 
0012 0F14 04C5  14         clr   tmp1
0013 0F16 0206  20         li    tmp2,768              ; Write 768 bytes
     0F18 0300 
0014               *--------------------------------------------------------------
0015               * Repeat 3 times: write bytes >00 .. >FF
0016               *--------------------------------------------------------------
0017 0F1A D7C5  30 bitma1  movb  tmp1,*r15             ; Write byte
0018 0F1C 0225  22         ai    tmp1,>0100
     0F1E 0100 
0019 0F20 0606  14         dec   tmp2
0020 0F22 16FB  14         jne   bitma1
0021 0F24 0457  20         b     *tmp3                 ; Exit
**** **** ****     > runlib.asm
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
0013 0F26 C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 0F28 06A0  32         bl    @putvr                ; Write once
     0F2A 0AE2 
0015 0F2C 391C             data  >391c                 ; VR1/57, value 00011100
0016 0F2E 06A0  32         bl    @putvr                ; Write twice
     0F30 0AE2 
0017 0F32 391C             data  >391c                 ; VR1/57, value 00011100
0018 0F34 0458  20         b     *tmp4                 ; Exit
0019               
0020               
0021               ***************************************************************
0022               * f18lck - Lock F18A VDP
0023               ***************************************************************
0024               *  bl   @f18lck
0025               ********|*****|*********************|**************************
0026 0F36 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0027 0F38 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     0F3A 0AE2 
0028 0F3C 391C             data  >391c
0029 0F3E 0458  20         b     *tmp4                 ; Exit
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
0040 0F40 C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0041 0F42 06A0  32         bl    @cpym2v
     0F44 0BE8 
0042 0F46 3F00             data  >3f00,f18chk_gpu,6    ; Copy F18A GPU code to VRAM
     0F48 0F84 
     0F4A 0006 
0043 0F4C 06A0  32         bl    @putvr
     0F4E 0AE2 
0044 0F50 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0045 0F52 06A0  32         bl    @putvr
     0F54 0AE2 
0046 0F56 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0047                                                   ; GPU code should run now
0048               ***************************************************************
0049               * VDP @>3f00 == 0 ? F18A present : F18a not present
0050               ***************************************************************
0051 0F58 0204  20         li    tmp0,>3f00
     0F5A 3F00 
0052 0F5C 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     0F5E 0A6A 
0053 0F60 D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     0F62 8800 
0054 0F64 0984  56         srl   tmp0,8
0055 0F66 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     0F68 8800 
0056 0F6A C104  18         mov   tmp0,tmp0             ; For comparing with 0
0057 0F6C 1303  14         jeq   f18chk_yes
0058               f18chk_no:
0059 0F6E 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     0F70 BFFF 
0060 0F72 1002  14         jmp   f18chk_exit
0061               f18chk_yes:
0062 0F74 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     0F76 4000 
0063               f18chk_exit:
0064 0F78 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f07
     0F7A 0A3E 
0065 0F7C 3F00             data  >3f00,>00,6
     0F7E 0000 
     0F80 0006 
0066 0F82 0458  20         b     *tmp4                 ; Exit
0067               ***************************************************************
0068               * GPU code
0069               ********|*****|*********************|**************************
0070               f18chk_gpu
0071 0F84 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0072 0F86 3F00             data  >3f00                 ; 3f02 / 3f00
0073 0F88 0340             data  >0340                 ; 3f04   0340  idle
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
0092 0F8A C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0093                       ;------------------------------------------------------
0094                       ; Reset all F18a VDP registers to power-on defaults
0095                       ;------------------------------------------------------
0096 0F8C 06A0  32         bl    @putvr
     0F8E 0AE2 
0097 0F90 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0098               
0099 0F92 06A0  32         bl    @putvr                ; VR1/57, value 00011100
     0F94 0AE2 
0100 0F96 391C             data  >391c                 ; Lock the F18a
0101 0F98 0458  20         b     *tmp4                 ; Exit
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
0120 0F9A C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0121 0F9C 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     0F9E 07F8 
0122 0FA0 1609  14         jne   f18fw1
0123               ***************************************************************
0124               * Read F18A major/minor version
0125               ***************************************************************
0126 0FA2 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     0FA4 8802 
0127 0FA6 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     0FA8 0AE2 
0128 0FAA 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0129 0FAC 04C4  14         clr   tmp0
0130 0FAE D120  34         movb  @vdps,tmp0
     0FB0 8802 
0131 0FB2 0984  56         srl   tmp0,8
0132 0FB4 0458  20 f18fw1  b     *tmp4                 ; Exit
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
0017 0FB6 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     0FB8 832A 
0018 0FBA D17B  28         movb  *r11+,tmp1
0019 0FBC 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 0FBE D1BB  28         movb  *r11+,tmp2
0021 0FC0 0986  56         srl   tmp2,8                ; Repeat count
0022 0FC2 C1CB  18         mov   r11,tmp3
0023 0FC4 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     0FC6 0BAA 
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 0FC8 020B  20         li    r11,hchar1
     0FCA 0FD0 
0028 0FCC 0460  28         b     @xfilv                ; Draw
     0FCE 0A44 
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 0FD0 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     0FD2 07FC 
0033 0FD4 1302  14         jeq   hchar2                ; Yes, exit
0034 0FD6 C2C7  18         mov   tmp3,r11
0035 0FD8 10EE  14         jmp   hchar                 ; Next one
0036 0FDA 05C7  14 hchar2  inct  tmp3
0037 0FDC 0457  20         b     *tmp3                 ; Exit
**** **** ****     > runlib.asm
0146               
0148                       copy  "vdp_vchar.asm"            ; VDP vchar functions
**** **** ****     > vdp_vchar.asm
0001               * FILE......: vdp_vchar.a99
0002               * Purpose...: VDP vchar module
0003               
0004               ***************************************************************
0005               * Repeat characters vertically at YX
0006               ***************************************************************
0007               *  BL    @VCHAR
0008               *  DATA  P0,P1
0009               *  ...
0010               *  DATA  EOL                        ; End-of-list
0011               *--------------------------------------------------------------
0012               *  P0HB = Y position
0013               *  P0LB = X position
0014               *  P1HB = Byte to write
0015               *  P1LB = Number of times to repeat
0016               ********|*****|*********************|**************************
0017 0FDE C83B  50 vchar   mov   *r11+,@wyx            ; Set YX position
     0FE0 832A 
0018 0FE2 C1CB  18         mov   r11,tmp3              ; Save R11 in TMP3
0019 0FE4 C220  34 vchar1  mov   @wcolmn,tmp4          ; Get columns per row
     0FE6 833A 
0020 0FE8 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     0FEA 0BAA 
0021 0FEC D177  28         movb  *tmp3+,tmp1           ; Byte to write
0022 0FEE D1B7  28         movb  *tmp3+,tmp2
0023 0FF0 0986  56         srl   tmp2,8                ; Repeat count
0024               *--------------------------------------------------------------
0025               *    Setup VDP write address
0026               *--------------------------------------------------------------
0027 0FF2 06A0  32 vchar2  bl    @vdwa                 ; Setup VDP write address
     0FF4 0A66 
0028               *--------------------------------------------------------------
0029               *    Dump tile to VDP and do housekeeping
0030               *--------------------------------------------------------------
0031 0FF6 D7C5  30         movb  tmp1,*r15             ; Dump tile to VDP
0032 0FF8 A108  18         a     tmp4,tmp0             ; Next row
0033 0FFA 0606  14         dec   tmp2
0034 0FFC 16FA  14         jne   vchar2
0035 0FFE 8817  46         c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     1000 07FC 
0036 1002 1303  14         jeq   vchar3                ; Yes, exit
0037 1004 C837  50         mov   *tmp3+,@wyx           ; Save YX position
     1006 832A 
0038 1008 10ED  14         jmp   vchar1                ; Next one
0039 100A 05C7  14 vchar3  inct  tmp3
0040 100C 0457  20         b     *tmp3                 ; Exit
0041               
0042               ***************************************************************
0043               * Repeat characters vertically at YX
0044               ***************************************************************
0045               * TMP0 = YX position
0046               * TMP1 = Byte to write
0047               * TMP2 = Repeat count
0048               ***************************************************************
0049 100E C20B  18 xvchar  mov   r11,tmp4              ; Save return address
0050 1010 C804  38         mov   tmp0,@wyx             ; Set cursor position
     1012 832A 
0051 1014 06C5  14         swpb  tmp1                  ; Byte to write into MSB
0052 1016 C1E0  34         mov   @wcolmn,tmp3          ; Get columns per row
     1018 833A 
0053 101A 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     101C 0BAA 
0054               *--------------------------------------------------------------
0055               *    Setup VDP write address
0056               *--------------------------------------------------------------
0057 101E 06A0  32 xvcha1  bl    @vdwa                 ; Setup VDP write address
     1020 0A66 
0058               *--------------------------------------------------------------
0059               *    Dump tile to VDP and do housekeeping
0060               *--------------------------------------------------------------
0061 1022 D7C5  30         movb  tmp1,*r15             ; Dump tile to VDP
0062 1024 A120  34         a     @wcolmn,tmp0          ; Next row
     1026 833A 
0063 1028 0606  14         dec   tmp2
0064 102A 16F9  14         jne   xvcha1
0065 102C 0458  20         b     *tmp4                 ; Exit
**** **** ****     > runlib.asm
0150               
0152                       copy  "vdp_boxes.asm"            ; VDP box functions
**** **** ****     > vdp_boxes.asm
0001               * FILE......: vdp_boxes.a99
0002               * Purpose...: VDP Fillbox, Putbox module
0003               
0004               ***************************************************************
0005               * FILBOX - Fill box with character
0006               ***************************************************************
0007               *  BL   @FILBOX
0008               *  DATA P0,P1,P2
0009               *  ...
0010               *  DATA EOL
0011               *--------------------------------------------------------------
0012               *  P0HB = Upper left corner Y
0013               *  P0LB = Upper left corner X
0014               *  P1HB = Height
0015               *  P1LB = Width
0016               *  P2HB = >00
0017               *  P2LB = Character to fill
0018               ********|*****|*********************|**************************
0019 102E C83B  50 filbox  mov   *r11+,@wyx            ; Upper left corner
     1030 832A 
0020 1032 D1FB  28         movb  *r11+,tmp3            ; Height in TMP3
0021 1034 D1BB  28         movb  *r11+,tmp2            ; Width in TMP2
0022 1036 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0023 1038 C20B  18         mov   r11,tmp4              ; Save R11
0024 103A 0986  56         srl   tmp2,8                ; Right-align width
0025 103C 0987  56         srl   tmp3,8                ; Right-align height
0026               *--------------------------------------------------------------
0027               *  Do single row
0028               *--------------------------------------------------------------
0029 103E 06A0  32 filbo1  bl    @yx2pnt               ; Get VDP address into TMP0
     1040 0BAA 
0030 1042 020B  20         li    r11,filbo2            ; New return address
     1044 104A 
0031 1046 0460  28         b     @xfilv                ; Fill VRAM with byte
     1048 0A44 
0032               *--------------------------------------------------------------
0033               *  Recover width & character
0034               *--------------------------------------------------------------
0035 104A C108  18 filbo2  mov   tmp4,tmp0
0036 104C 0224  22         ai    tmp0,-3               ; R11 - 3
     104E FFFD 
0037 1050 D1B4  28         movb  *tmp0+,tmp2           ; Get Width/Height
0038 1052 0986  56         srl   tmp2,8                ; Right align
0039 1054 C154  26         mov   *tmp0,tmp1            ; Get character to fill
0040               *--------------------------------------------------------------
0041               *  Housekeeping
0042               *--------------------------------------------------------------
0043 1056 A820  54         a     @w$0100,@by           ; Y=Y+1
     1058 07EC 
     105A 832A 
0044 105C 0607  14         dec   tmp3
0045 105E 15EF  14         jgt   filbo1                ; Process next row
0046 1060 8818  46         c     *tmp4,@w$ffff         ; End-Of-List marker found ?
     1062 07FC 
0047 1064 1302  14         jeq   filbo3                ; Yes, exit
0048 1066 C2C8  18         mov   tmp4,r11
0049 1068 10E2  14         jmp   filbox                ; Next one
0050 106A 05C8  14 filbo3  inct  tmp4
0051 106C 0458  20         b     *tmp4                 ; Exit
0052               
0053               
0054               ***************************************************************
0055               * PUTBOX - Put tiles in box
0056               ***************************************************************
0057               *  BL   @PUTBOX
0058               *  DATA P0,P1,P2,P3
0059               *  ...
0060               *  DATA EOL
0061               *--------------------------------------------------------------
0062               *  P0HB = Upper left corner Y
0063               *  P0LB = Upper left corner X
0064               *  P1HB = Box height
0065               *  P1LB = Box width
0066               *  P2   = Pointer to length-byte prefixed string
0067               *  P3HB = Repeat box A-times vertically
0068               *  P3LB = Repeat box B-times horizontally
0069               *--------------------------------------------------------------
0070               *  Register usage
0071               *  ; TMP0   = work copy of YX cursor position
0072               *  ; TMP1HB = Width  of box + X
0073               *  ; TMP2HB = Height of box + Y
0074               *  ; TMP3   = Pointer to string
0075               *  ; TMP4   = Counter for string
0076               *  ; @WAUX1 = Box AB repeat count
0077               *  ; @WAUX2 = Copy of R11
0078               *  ; @WAUX3 = YX position for next diagonal box
0079               *--------------------------------------------------------------
0080               *  ; Only byte operations on TMP1HB & TMP2HB.
0081               *  ; LO bytes of TMP1 and TMP2 reserved for future use.
0082               ********|*****|*********************|**************************
0083 106E C13B  30 putbox  mov   *r11+,tmp0            ; P0 - Upper left corner YX
0084 1070 C15B  26         mov   *r11,tmp1             ; P1 - Height/Width in TMP1
0085 1072 C1BB  30         mov   *r11+,tmp2            ; P1 - Height/Width in TMP2
0086 1074 C1FB  30         mov   *r11+,tmp3            ; P2 - Pointer to string
0087 1076 C83B  50         mov   *r11+,@waux1          ; P3 - Box repeat count AB
     1078 833C 
0088 107A C80B  38         mov   r11,@waux2            ; Save R11
     107C 833E 
0089               *--------------------------------------------------------------
0090               *  Calculate some positions
0091               *--------------------------------------------------------------
0092 107E B184  18 putbo0  ab    tmp0,tmp2             ; TMP2HB = height + Y
0093 1080 06C4  14         swpb  tmp0
0094 1082 06C5  14         swpb  tmp1
0095 1084 B144  18         ab    tmp0,tmp1             ; TMP1HB = width  + X
0096 1086 06C4  14         swpb  tmp0
0097 1088 0A12  56         sla   config,1              ; \ clear config bit 0
0098 108A 0912  56         srl   config,1              ; / is only 4 bytes
0099 108C C804  38         mov   tmp0,@waux3           ; Set additional work copy of YX cursor
     108E 8340 
0100               *--------------------------------------------------------------
0101               *  Setup VDP write address
0102               *--------------------------------------------------------------
0103 1090 C804  38 putbo1  mov   tmp0,@wyx             ; Set YX cursor
     1092 832A 
0104 1094 06A0  32         bl    @yx2pnt               ; Calculate VDP address from @WYX
     1096 0BAA 
0105 1098 06A0  32         bl    @vdwa                 ; Set VDP write address from TMP0
     109A 0A66 
0106 109C C120  34         mov   @wyx,tmp0
     109E 832A 
0107               *--------------------------------------------------------------
0108               *  Prepare string for processing
0109               *--------------------------------------------------------------
0110 10A0 20A0  38         coc   @wbit0,config         ; state flag set ?
     10A2 07FA 
0111 10A4 1302  14         jeq   putbo2                ; Yes, skip length byte
0112 10A6 D237  28         movb  *tmp3+,tmp4           ; Get length byte ...
0113 10A8 0988  56         srl   tmp4,8                ; ... and right justify
0114               *--------------------------------------------------------------
0115               *  Write line of tiles in box
0116               *--------------------------------------------------------------
0117 10AA D7F7  40 putbo2  movb  *tmp3+,*r15           ; Write to VDP
0118 10AC 0608  14         dec   tmp4
0119 10AE 1310  14         jeq   putbo3                ; End of string. Repeat box ?
0120               *--------------------------------------------------------------
0121               *    Adjust cursor
0122               *--------------------------------------------------------------
0123 10B0 0584  14         inc   tmp0                  ; X=X+1
0124 10B2 06C4  14         swpb  tmp0
0125 10B4 9144  18         cb    tmp0,tmp1             ; Right boundary reached ?
0126 10B6 06C4  14         swpb  tmp0
0127 10B8 11F8  14         jlt   putbo2                ; Not yet, continue
0128 10BA 0224  22         ai    tmp0,>0100            ; Y=Y+1
     10BC 0100 
0129 10BE D804  38         movb  tmp0,@wyx             ; Update Y cursor
     10C0 832A 
0130 10C2 9184  18         cb    tmp0,tmp2             ; Bottom boundary reached ?
0131 10C4 1305  14         jeq   putbo3                ; Yes, exit
0132               *--------------------------------------------------------------
0133               *  Recover starting column
0134               *--------------------------------------------------------------
0135 10C6 C120  34         mov   @wyx,tmp0             ; ... from YX cursor
     10C8 832A 
0136 10CA 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     10CC 8000 
0137 10CE 10E0  14         jmp   putbo1                ; Draw next line
0138               *--------------------------------------------------------------
0139               *  Handling repeating of box
0140               *--------------------------------------------------------------
0141 10D0 C120  34 putbo3  mov   @waux1,tmp0           ; Repeat box ?
     10D2 833C 
0142 10D4 1328  14         jeq   putbo9                ; No, move on to next list entry
0143               *--------------------------------------------------------------
0144               *     Repeat horizontally
0145               *--------------------------------------------------------------
0146 10D6 06C4  14         swpb  tmp0                  ; BA
0147 10D8 D104  18         movb  tmp0,tmp0             ; B = 0 ?
0148 10DA 130D  14         jeq   putbo4                ; Yes, repeat vertically
0149 10DC 06C4  14         swpb  tmp0                  ; AB
0150 10DE 0604  14         dec   tmp0                  ; B = B - 1
0151 10E0 C804  38         mov   tmp0,@waux1           ; Update AB repeat count
     10E2 833C 
0152 10E4 D805  38         movb  tmp1,@waux3+1         ; New X position
     10E6 8341 
0153 10E8 C120  34         mov   @waux3,tmp0           ; Get new YX position
     10EA 8340 
0154 10EC C1E0  34         mov   @waux2,tmp3
     10EE 833E 
0155 10F0 0227  22         ai    tmp3,-6               ; Back to P1
     10F2 FFFA 
0156 10F4 1014  14         jmp   putbo8
0157               *--------------------------------------------------------------
0158               *     Repeat vertically
0159               *--------------------------------------------------------------
0160 10F6 06C4  14 putbo4  swpb  tmp0                  ; AB
0161 10F8 D104  18         movb  tmp0,tmp0             ; A = 0 ?
0162 10FA 13EA  14         jeq   putbo3                ; Yes, check next entry in list
0163 10FC 0224  22         ai    tmp0,->0100           ; A = A - 1
     10FE FF00 
0164 1100 C804  38         mov   tmp0,@waux1           ; Update AB repeat count
     1102 833C 
0165 1104 C1E0  34         mov   @waux2,tmp3           ; \
     1106 833E 
0166 1108 0607  14         dec   tmp3                  ; / Back to P3LB
0167 110A D817  46         movb  *tmp3,@waux1+1        ; Update B repeat count
     110C 833D 
0168 110E D106  18         movb  tmp2,tmp0             ; New Y position
0169 1110 06C4  14         swpb  tmp0
0170 1112 0227  22         ai    tmp3,-6               ; Back to P0LB
     1114 FFFA 
0171 1116 D137  28         movb  *tmp3+,tmp0
0172 1118 06C4  14         swpb  tmp0
0173 111A C804  38         mov   tmp0,@waux3           ; Set new YX position
     111C 8340 
0174               *--------------------------------------------------------------
0175               *      Get Height, Width and reset string pointer
0176               *--------------------------------------------------------------
0177 111E C157  26 putbo8  mov   *tmp3,tmp1            ; Get P1 into TMP1
0178 1120 C1B7  30         mov   *tmp3+,tmp2           ; Get P1 into TMP2
0179 1122 C1D7  26         mov   *tmp3,tmp3            ; Get P2 into TMP3
0180 1124 10AC  14         jmp   putbo0                ; Next box
0181               *--------------------------------------------------------------
0182               *  Next entry in list
0183               *--------------------------------------------------------------
0184 1126 C2E0  34 putbo9  mov   @waux2,r11            ; Restore R11
     1128 833E 
0185 112A 881B  46         c     *r11,@w$ffff          ; End-Of-List marker found ?
     112C 07FC 
0186 112E 1301  14         jeq   putboa                ; Yes, exit
0187 1130 109E  14         jmp   putbox                ; Next one
0188 1132 0A22  56 putboa  sla   config,2              ; \ clear config bits 0 & 1
0189 1134 0922  56         srl   config,2              ; / is only 4 bytes
0190 1136 045B  20         b     *r11                  ; Exit
**** **** ****     > runlib.asm
0154               
0156                       copy  "vdp_viewport.asm"         ; VDP viewport functionality
**** **** ****     > vdp_viewport.asm
0001               * FILE......: vdp_viewport.asm
0002               * Purpose...: VDP viewport support module
0003               
0004               ***************************************************************
0005               * SCRDIM - Set (virtual) screen base and dimension
0006               ***************************************************************
0007               *  BL   @SCRDIM
0008               *--------------------------------------------------------------
0009               *  INPUT
0010               *  P0 = PNT base address
0011               *  P1 = Number of columns per row
0012               ********|*****|*********************|**************************
0013 1138 C83B  50 scrdim  mov   *r11+,@wbase          ; VDP destination address
     113A 8328 
0014 113C C83B  50         mov   *r11+,@wcolmn         ; Number of columns per row
     113E 833A 
0015 1140 045B  20         b     *r11                  ; Exit
0016               
0017               
0018               ***************************************************************
0019               * VIEW - Viewport into virtual screen
0020               ***************************************************************
0021               *  BL   @VIEW
0022               *  DATA P0,P1,P2,P3,P4
0023               *--------------------------------------------------------------
0024               *  P0   = Pointer to RAM buffer
0025               *  P1   = Physical screen - upper left corner YX of viewport
0026               *  P2HB = Physical screen - Viewport height
0027               *  P2LB = Physical screen - Viewport width
0028               *  P3   = Virtual screen  - VRAM base address
0029               *  P4   = Virtual screen  - Number of columns
0030               *
0031               *  TMP0 must contain the YX offset in virtual screen
0032               *--------------------------------------------------------------
0033               * Memory usage
0034               * WAUX1 = Virtual screen VRAM base
0035               * WAUX2 = Virtual screen columns per row
0036               * WAUX3 = Virtual screen YX
0037               *
0038               * RAM buffer (offset)
0039               * 01  Physical screen VRAM base
0040               * 23  Physical screen columns per row
0041               * 45  Physical screen YX (viewport upper left corner)
0042               * 67  Height & width of viewport
0043               * 89  Return address
0044               ********|*****|*********************|**************************
0045 1142 C23B  30 view    mov   *r11+,tmp4            ; P0: Get pointer to RAM buffer
0046 1144 C620  46         mov   @wbase,*tmp4          ; RAM 01 - Save physical screen VRAM base
     1146 8328 
0047 1148 CA20  54         mov   @wcolmn,@2(tmp4)      ; RAM 23 - Save physical screen size (columns per row)
     114A 833A 
     114C 0002 
0048 114E CA3B  50         mov   *r11+,@4(tmp4)        ; RAM 45 - P1: Get viewport upper left corner YX
     1150 0004 
0049 1152 C1FB  30         mov   *r11+,tmp3            ;
0050 1154 CA07  38         mov   tmp3,@6(tmp4)         ; RAM 67 - P2: Get viewport height & width
     1156 0006 
0051 1158 C83B  50         mov   *r11+,@waux1          ; P3: Get virtual screen VRAM base address
     115A 833C 
0052 115C C83B  50         mov   *r11+,@waux2          ; P4: Get virtual screen size (columns per row)
     115E 833E 
0053 1160 C804  38         mov   tmp0,@waux3           ; Get upper left corner YX in virtual screen
     1162 8340 
0054 1164 CA0B  38         mov   r11,@8(tmp4)          ; RAM 89 - Store R11 for exit
     1166 0008 
0055 1168 0A12  56         sla   config,1              ; \
0056 116A 0912  56         srl   config,1              ; / Clear CONFIG bits 0
0057 116C 0987  56         srl   tmp3,8                ; Row counter
0058               *--------------------------------------------------------------
0059               *    Set virtual screen dimension and position cursor
0060               *--------------------------------------------------------------
0061 116E C820  54 view1   mov   @waux1,@wbase         ; Set virtual screen base
     1170 833C 
     1172 8328 
0062 1174 C820  54         mov   @waux2,@wcolmn        ; Set virtual screen width
     1176 833E 
     1178 833A 
0063 117A C820  54         mov   @waux3,@wyx           ; Set cursor in virtual screen
     117C 8340 
     117E 832A 
0064               *--------------------------------------------------------------
0065               *    Prepare for copying a single line
0066               *--------------------------------------------------------------
0067 1180 06A0  32 view2   bl    @yx2pnt               ; Get VRAM address in TMP0
     1182 0BAA 
0068 1184 C148  18         mov   tmp4,tmp1             ; RAM buffer + 10
0069 1186 0225  22         ai    tmp1,10               ;
     1188 000A 
0070 118A C1A8  34         mov   @6(tmp4),tmp2         ; \ Get RAM buffer byte 1
     118C 0006 
0071 118E 0246  22         andi  tmp2,>00ff            ; / Clear MSB
     1190 00FF 
0072 1192 28A0  34         xor   @wbit0,config         ; Toggle bit 0
     1194 07FA 
0073 1196 24A0  38         czc   @wbit0,config         ; Bit 0=0 ?
     1198 07FA 
0074 119A 130B  14         jeq   view4                 ; Yes! So copy from RAM to VRAM
0075               *--------------------------------------------------------------
0076               *    Copy line from VRAM to RAM
0077               *--------------------------------------------------------------
0078 119C 06A0  32 view3   bl    @xpyv2m               ; Copy block from VRAM (virtual screen) to RAM
     119E 0C14 
0079 11A0 C818  46         mov   *tmp4,@wbase          ; Set physical screen base
     11A2 8328 
0080 11A4 C828  54         mov   @2(tmp4),@wcolmn      ; Set physical screen columns per row
     11A6 0002 
     11A8 833A 
0081 11AA C828  54         mov   @4(tmp4),@wyx         ; Set cursor in physical screen
     11AC 0004 
     11AE 832A 
0082 11B0 10E7  14         jmp   view2
0083               *--------------------------------------------------------------
0084               *    Copy line from RAM to VRAM
0085               *--------------------------------------------------------------
0086 11B2 06A0  32 view4   bl    @xpym2v               ; Copy block to VRAM
     11B4 0BEE 
0087 11B6 BA20  54         ab    @hb$01,@4(tmp4)       ; Physical screen Y=Y+1
     11B8 07EC 
     11BA 0004 
0088 11BC B820  54         ab    @hb$01,@waux3         ; Virtual screen  Y=Y+1
     11BE 07EC 
     11C0 8340 
0089 11C2 0607  14         dec   tmp3                  ; Update row counter
0090 11C4 16D4  14         jne   view1                 ; Next line unless all rows process
0091               *--------------------------------------------------------------
0092               *    Exit
0093               *--------------------------------------------------------------
0094 11C6 C2E8  34 viewz   mov   @8(tmp4),r11          ; \
     11C8 0008 
0095 11CA 045B  20         b     *r11                  ; / exit
**** **** ****     > runlib.asm
0158               
0160                       copy  "snd_player.asm"           ; Sound player
**** **** ****     > snd_player.asm
0001               * FILE......: snd_player.asm
0002               * Purpose...: Sound player support code
0003               
0004               
0005               ***************************************************************
0006               * MUTE - Mute all sound generators
0007               ***************************************************************
0008               *  BL  @MUTE
0009               *  Mute sound generators and clear sound pointer
0010               *
0011               *  BL  @MUTE2
0012               *  Mute sound generators without clearing sound pointer
0013               ********|*****|*********************|**************************
0014 11CC 04E0  34 mute    clr   @wsdlst               ; Clear sound pointer
     11CE 8334 
0015 11D0 40A0  34 mute2   szc   @wbit13,config        ; Turn off/pause sound player
     11D2 07E0 
0016 11D4 0204  20         li    tmp0,muttab
     11D6 11E6 
0017 11D8 0205  20         li    tmp1,sound            ; Sound generator port >8400
     11DA 8400 
0018 11DC D574  40         movb  *tmp0+,*tmp1          ; Generator 0
0019 11DE D574  40         movb  *tmp0+,*tmp1          ; Generator 1
0020 11E0 D574  40         movb  *tmp0+,*tmp1          ; Generator 2
0021 11E2 D554  38         movb  *tmp0,*tmp1           ; Generator 3
0022 11E4 045B  20         b     *r11
0023 11E6 9FBF     muttab  byte  >9f,>bf,>df,>ff       ; Table for muting all generators
     11E8 DFFF 
0024               
0025               
0026               ***************************************************************
0027               * SDPREP - Prepare for playing sound
0028               ***************************************************************
0029               *  BL   @SDPREP
0030               *  DATA P0,P1
0031               *
0032               *  P0 = Address where tune is stored
0033               *  P1 = Option flags for sound player
0034               *--------------------------------------------------------------
0035               *  REMARKS
0036               *  Use the below equates for P1:
0037               *
0038               *  SDOPT1 => Tune is in CPU memory + loop
0039               *  SDOPT2 => Tune is in CPU memory
0040               *  SDOPT3 => Tune is in VRAM + loop
0041               *  SDOPT4 => Tune is in VRAM
0042               ********|*****|*********************|**************************
0043 11EA C81B  46 sdprep  mov   *r11,@wsdlst          ; Set tune address
     11EC 8334 
0044 11EE C83B  50         mov   *r11+,@wsdtmp         ; Set tune address in temp
     11F0 8336 
0045 11F2 0242  22         andi  config,>fff8          ; Clear bits 13-14-15
     11F4 FFF8 
0046 11F6 E0BB  30         soc   *r11+,config          ; Set options
0047 11F8 D820  54         movb  @hb$01,@r13lb         ; Set initial duration
     11FA 07EC 
     11FC 831B 
0048 11FE 045B  20         b     *r11
0049               
0050               ***************************************************************
0051               * SDPLAY - Sound player for tune in VRAM or CPU memory
0052               ***************************************************************
0053               *  BL  @SDPLAY
0054               *--------------------------------------------------------------
0055               *  REMARKS
0056               *  Set config register bit13=0 to pause player.
0057               *  Set config register bit14=1 to repeat (or play next tune).
0058               ********|*****|*********************|**************************
0059 1200 20A0  38 sdplay  coc   @wbit13,config        ; Play tune ?
     1202 07E0 
0060 1204 1301  14         jeq   sdpla1                ; Yes, play
0061 1206 045B  20         b     *r11
0062               *--------------------------------------------------------------
0063               * Initialisation
0064               *--------------------------------------------------------------
0065 1208 060D  14 sdpla1  dec   r13                   ; duration = duration - 1
0066 120A 9820  54         cb    @r13lb,@hb$00         ; R13LB == 0 ?
     120C 831B 
     120E 07DA 
0067 1210 1301  14         jeq   sdpla3                ; Play next note
0068 1212 045B  20 sdpla2  b     *r11                  ; Note still busy, exit
0069 1214 20A0  38 sdpla3  coc   @wbit15,config        ; Play tune from CPU memory ?
     1216 07DC 
0070 1218 131A  14         jeq   mmplay
0071               *--------------------------------------------------------------
0072               * Play tune from VDP memory
0073               *--------------------------------------------------------------
0074 121A C120  34 vdplay  mov   @wsdtmp,tmp0          ; Get tune address
     121C 8336 
0075 121E 06C4  14         swpb  tmp0
0076 1220 D804  38         movb  tmp0,@vdpa
     1222 8C02 
0077 1224 06C4  14         swpb  tmp0
0078 1226 D804  38         movb  tmp0,@vdpa
     1228 8C02 
0079 122A 04C4  14         clr   tmp0
0080 122C D120  34         movb  @vdpr,tmp0            ; length = 0 (end of tune) ?
     122E 8800 
0081 1230 131E  14         jeq   sdexit                ; Yes. exit
0082 1232 0984  56 vdpla1  srl   tmp0,8                ; Right justify length byte
0083 1234 A804  38         a     tmp0,@wsdtmp          ; Adjust for next table entry
     1236 8336 
0084 1238 D820  54 vdpla2  movb  @vdpr,@>8400          ; Feed byte to sound generator
     123A 8800 
     123C 8400 
0085 123E 0604  14         dec   tmp0
0086 1240 16FB  14         jne   vdpla2
0087 1242 D820  54         movb  @vdpr,@r13lb          ; Set duration counter
     1244 8800 
     1246 831B 
0088 1248 05E0  34 vdpla3  inct  @wsdtmp               ; Adjust for next table entry, honour byte (1) + (n+1)
     124A 8336 
0089 124C 045B  20         b     *r11
0090               *--------------------------------------------------------------
0091               * Play tune from CPU memory
0092               *--------------------------------------------------------------
0093 124E C120  34 mmplay  mov   @wsdtmp,tmp0
     1250 8336 
0094 1252 D174  28         movb  *tmp0+,tmp1           ; length = 0 (end of tune) ?
0095 1254 130C  14         jeq   sdexit                ; Yes, exit
0096 1256 0985  56 mmpla1  srl   tmp1,8                ; Right justify length byte
0097 1258 A805  38         a     tmp1,@wsdtmp          ; Adjust for next table entry
     125A 8336 
0098 125C D834  48 mmpla2  movb  *tmp0+,@>8400         ; Feed byte to sound generator
     125E 8400 
0099 1260 0605  14         dec   tmp1
0100 1262 16FC  14         jne   mmpla2
0101 1264 D814  46         movb  *tmp0,@r13lb          ; Set duration counter
     1266 831B 
0102 1268 05E0  34         inct  @wsdtmp               ; Adjust for next table entry, honour byte (1) + (n+1)
     126A 8336 
0103 126C 045B  20         b     *r11
0104               *--------------------------------------------------------------
0105               * Exit. Check if tune must be looped
0106               *--------------------------------------------------------------
0107 126E 20A0  38 sdexit  coc   @wbit14,config        ; Loop flag set ?
     1270 07DE 
0108 1272 1607  14         jne   sdexi2                ; No, exit
0109 1274 C820  54         mov   @wsdlst,@wsdtmp
     1276 8334 
     1278 8336 
0110 127A D820  54         movb  @hb$01,@r13lb          ; Set initial duration
     127C 07EC 
     127E 831B 
0111 1280 045B  20 sdexi1  b     *r11                  ; Exit
0112 1282 0242  22 sdexi2  andi  config,>fff8          ; Reset music player
     1284 FFF8 
0113 1286 045B  20         b     *r11                  ; Exit
0114               
**** **** ****     > runlib.asm
0162               
0164                       copy  "speech_detect.asm"        ; Detect speech synthesizer
**** **** ****     > speech_detect.asm
0001               * FILE......: speech_detect.asm
0002               * Purpose...: Check if speech synthesizer is connected
0003               
0004               
0005               ***************************************************************
0006               * SPSTAT - Read status register byte from speech synthesizer
0007               ***************************************************************
0008               *  LI  TMP2,@>....
0009               *  B   @SPSTAT
0010               *--------------------------------------------------------------
0011               * REMARKS
0012               * Destroys R11 !
0013               *
0014               * Register usage
0015               * TMP0HB = Status byte read from speech synth
0016               * TMP1   = Temporary use  (scratchpad machine code)
0017               * TMP2   = Return address for this subroutine
0018               * R11    = Return address (scratchpad machine code)
0019               ********|*****|*********************|**************************
0020 1288 0204  20 spstat  li    tmp0,spchrd           ; (R4) = >9000
     128A 9000 
0021 128C C820  54         mov   @spcode,@mcsprd       ; \
     128E 09D6 
     1290 8322 
0022 1292 C820  54         mov   @spcode+2,@mcsprd+2   ; / Load speech read code
     1294 09D8 
     1296 8324 
0023 1298 020B  20         li    r11,spsta1            ; Return to SPSTA1
     129A 12A0 
0024 129C 0460  28         b     @mcsprd               ; Run scratchpad code
     129E 8322 
0025 12A0 C820  54 spsta1  mov   @mccode,@mcsprd       ; \
     12A2 09D0 
     12A4 8322 
0026 12A6 C820  54         mov   @mccode+2,@mcsprd+2   ; / Restore tight loop code
     12A8 09D2 
     12AA 8324 
0027 12AC 0456  20         b     *tmp2                 ; Exit
0028               
0029               
0030               ***************************************************************
0031               * SPCONN - Check if speech synthesizer connected
0032               ***************************************************************
0033               * BL  @SPCONN
0034               *--------------------------------------------------------------
0035               * OUTPUT
0036               * TMP0HB = Byte read from speech synth
0037               *--------------------------------------------------------------
0038               * REMARKS
0039               * See Editor/Assembler manual, section 22.1.6 page 354.
0040               * Calls SPSTAT.
0041               *
0042               * Register usage
0043               * TMP0HB = Byte read from speech synth
0044               * TMP3   = Copy of R11
0045               * R12    = CONFIG register
0046               ********|*****|*********************|**************************
0047 12AE C1CB  18 spconn  mov   r11,tmp3              ; Save R11
0048               *--------------------------------------------------------------
0049               * Setup speech synthesizer memory address >0000
0050               *--------------------------------------------------------------
0051 12B0 0204  20         li    tmp0,>4000            ; Load >40 (speech memory address command)
     12B2 4000 
0052 12B4 0205  20         li    tmp1,5                ; Process 5 nibbles in total
     12B6 0005 
0053 12B8 D804  38 spcon1  movb  tmp0,@spchwt          ; Write nibble >40 (5x)
     12BA 9400 
0054 12BC 0605  14         dec   tmp1
0055 12BE 16FC  14         jne   spcon1
0056               *--------------------------------------------------------------
0057               * Read first byte from speech synthesizer memory address >0000
0058               *--------------------------------------------------------------
0059 12C0 0204  20         li    tmp0,>1000
     12C2 1000 
0060 12C4 D804  38         movb  tmp0,@spchwt          ; Load >10 (speech memory read command)
     12C6 9400 
0061 12C8 1000  14         nop                         ; \
0062 12CA 1000  14         nop                         ; / 12 Microseconds delay
0063 12CC 0206  20         li    tmp2,spcon2
     12CE 12D4 
0064 12D0 0460  28         b     @spstat               ; Read status byte
     12D2 1288 
0065               *--------------------------------------------------------------
0066               * Update status bit 5 in CONFIG register
0067               *--------------------------------------------------------------
0068 12D4 0984  56 spcon2  srl   tmp0,8                ; MSB to LSB
0069 12D6 0284  22         ci    tmp0,>00aa            ; >aa means speech found
     12D8 00AA 
0070 12DA 1603  14         jne   spcon3
0071 12DC E0A0  34         soc   @wbit5,config         ; Set config bit5=1
     12DE 07F0 
0072 12E0 1002  14         jmp   spcon4
0073 12E2 40A0  34 spcon3  szc   @wbit5,config         ; Set config bit5=0
     12E4 07F0 
0074 12E6 0457  20 spcon4  b     *tmp3                 ; Exit
**** **** ****     > runlib.asm
0166               
0168                       copy  "speech_player.asm"        ; Speech synthesizer player
**** **** ****     > speech_player.asm
0001               ***************************************************************
0002               * FILE......: speech_player.asm
0003               * Purpose...: Speech Synthesizer player
0004               
0005               *//////////////////////////////////////////////////////////////
0006               *                 Speech Synthesizer player
0007               *//////////////////////////////////////////////////////////////
0008               
0009               ***************************************************************
0010               * SPPREP - Prepare for playing speech
0011               ***************************************************************
0012               *  BL   @SPPREP
0013               *  DATA P0
0014               *
0015               *  P0 = Address of LPC data for external voice.
0016               ********|*****|*********************|**************************
0017 12E8 C83B  50 spprep  mov   *r11+,@wspeak         ; Set speech address
     12EA 8338 
0018 12EC E0A0  34         soc   @wbit3,config         ; Clear bit 3
     12EE 07F4 
0019 12F0 045B  20         b     *r11
0020               
0021               ***************************************************************
0022               * SPPLAY - Speech player
0023               ***************************************************************
0024               * BL  @SPPLAY
0025               *--------------------------------------------------------------
0026               * Register usage
0027               * TMP3   = Copy of R11
0028               * R12    = CONFIG register
0029               ********|*****|*********************|**************************
0030 12F2 24A0  38 spplay  czc   @wbit3,config         ; Player off ?
     12F4 07F4 
0031 12F6 132F  14         jeq   spplaz                ; Yes, exit
0032 12F8 C1CB  18 sppla1  mov   r11,tmp3              ; Save R11
0033 12FA 20A0  38         coc   @tmp010,config        ; Speech player enabled+busy ?
     12FC 1358 
0034 12FE 1310  14         jeq   spkex3                ; Check FIFO buffer level
0035               *--------------------------------------------------------------
0036               * Speak external: Push LPC data to speech synthesizer
0037               *--------------------------------------------------------------
0038 1300 C120  34 spkext  mov   @wspeak,tmp0
     1302 8338 
0039 1304 D834  48         movb  *tmp0+,@spchwt        ; Send byte to speech synth
     1306 9400 
0040 1308 1000  14         jmp   $+2                   ; Delay
0041 130A 0206  20         li    tmp2,16
     130C 0010 
0042 130E D834  48 spkex1  movb  *tmp0+,@spchwt        ; Send byte to speech synth
     1310 9400 
0043 1312 0606  14         dec   tmp2
0044 1314 16FC  14         jne   spkex1
0045 1316 0262  22         ori   config,>0800          ; bit 4=1 (busy)
     1318 0800 
0046 131A C804  38         mov   tmp0,@wspeak          ; Update LPC pointer
     131C 8338 
0047 131E 101B  14         jmp   spplaz                ; Exit
0048               *--------------------------------------------------------------
0049               * Speak external: Check synth FIFO buffer level
0050               *--------------------------------------------------------------
0051 1320 0206  20 spkex3  li    tmp2,spkex4           ; Set return address for SPSTAT
     1322 1328 
0052 1324 0460  28         b     @spstat               ; Get speech FIFO buffer status
     1326 1288 
0053 1328 2120  38 spkex4  coc   @w$4000,tmp0          ; FIFO BL (buffer low) bit set?
     132A 07F8 
0054 132C 1301  14         jeq   spkex5                ; Yes, refill
0055 132E 1013  14         jmp   spplaz                ; No, exit
0056               *--------------------------------------------------------------
0057               * Speak external: Refill synth with LPC data if FIFO buffer low
0058               *--------------------------------------------------------------
0059 1330 C120  34 spkex5  mov   @wspeak,tmp0
     1332 8338 
0060 1334 0206  20         li    tmp2,8                ; Bytes to send to speech synth
     1336 0008 
0061 1338 D174  28 spkex6  movb  *tmp0+,tmp1
0062 133A D805  38         movb  tmp1,@spchwt          ; Send byte to speech synth
     133C 9400 
0063 133E 0285  22         ci    tmp1,spkoff           ; Speak off marker found ?
     1340 FF00 
0064 1342 1305  14         jeq   spkex8
0065 1344 0606  14         dec   tmp2
0066 1346 16F8  14         jne   spkex6                ; Send next byte
0067 1348 C804  38         mov   tmp0,@wspeak          ; Update LPC pointer
     134A 8338 
0068 134C 1004  14 spkex7  jmp   spplaz                ; Exit
0069               *--------------------------------------------------------------
0070               * Speak external: Done with speaking
0071               *--------------------------------------------------------------
0072 134E 40A0  34 spkex8  szc   @tmp010,config        ; bit 3,4,5=0
     1350 1358 
0073 1352 04E0  34         clr   @wspeak               ; Reset pointer
     1354 8338 
0074 1356 0457  20 spplaz  b     *tmp3                 ; Exit
0075 1358 1800     tmp010  data  >1800                 ; Binary 0001100000000000
0076                                                   ; Bit    0123456789ABCDEF
**** **** ****     > runlib.asm
0170               
0172                       copy  "keyb_virtual.asm"         ; Virtual keyboard scanning
**** **** ****     > keyb_virtual.asm
0001               * FILE......: keyb_virtual.asm
0002               * Purpose...: Virtual keyboard module
0003               
0004               ***************************************************************
0005               * Virtual keyboard equates
0006               ***************************************************************
0007               * bit  0: ALPHA LOCK down             0=no  1=yes
0008               * bit  1: ENTER                       0=no  1=yes
0009               * bit  2: REDO                        0=no  1=yes
0010               * bit  3: BACK                        0=no  1=yes
0011               * bit  4: Pause                       0=no  1=yes
0012               * bit  5: *free*                      0=no  1=yes
0013               * bit  6: P1 Left                     0=no  1=yes
0014               * bit  7: P1 Right                    0=no  1=yes
0015               * bit  8: P1 Up                       0=no  1=yes
0016               * bit  9: P1 Down                     0=no  1=yes
0017               * bit 10: P1 Space / fire / Q         0=no  1=yes
0018               * bit 11: P2 Left                     0=no  1=yes
0019               * bit 12: P2 Right                    0=no  1=yes
0020               * bit 13: P2 Up                       0=no  1=yes
0021               * bit 14: P2 Down                     0=no  1=yes
0022               * bit 15: P2 Space / fire / Q         0=no  1=yes
0023               ***************************************************************
0024      8000     kalpha  equ   >8000                 ; Virtual key alpha lock
0025      4000     kenter  equ   >4000                 ; Virtual key enter
0026      2000     kredo   equ   >2000                 ; Virtual key REDO
0027      1000     kback   equ   >1000                 ; Virtual key BACK
0028      0800     kpause  equ   >0800                 ; Virtual key pause
0029      0400     kfree   equ   >0400                 ; ***NOT USED YET***
0030               *--------------------------------------------------------------
0031               * Keyboard Player 1
0032               *--------------------------------------------------------------
0033      0280     k1uplf  equ   >0280                 ; Virtual key up   + left
0034      0180     k1uprg  equ   >0180                 ; Virtual key up   + right
0035      0240     k1dnlf  equ   >0240                 ; Virtual key down + left
0036      0140     k1dnrg  equ   >0140                 ; Virtual key down + right
0037      0200     k1lf    equ   >0200                 ; Virtual key left
0038      0100     k1rg    equ   >0100                 ; Virtual key right
0039      0080     k1up    equ   >0080                 ; Virtual key up
0040      0040     k1dn    equ   >0040                 ; Virtual key down
0041      0020     k1fire  equ   >0020                 ; Virtual key fire
0042               *--------------------------------------------------------------
0043               * Keyboard Player 2
0044               *--------------------------------------------------------------
0045      0014     k2uplf  equ   >0014                 ; Virtual key up   + left
0046      000C     k2uprg  equ   >000c                 ; Virtual key up   + right
0047      0012     k2dnlf  equ   >0012                 ; Virtual key down + left
0048      000A     k2dnrg  equ   >000a                 ; Virtual key down + right
0049      0010     k2lf    equ   >0010                 ; Virtual key left
0050      0008     k2rg    equ   >0008                 ; Virtual key right
0051      0004     k2up    equ   >0004                 ; Virtual key up
0052      0002     k2dn    equ   >0002                 ; Virtual key down
0053      0001     k2fire  equ   >0001                 ; Virtual key fire
0054                       even
0055               
0056               
0057               
0058               ***************************************************************
0059               * VIRTKB - Read virtual keyboard and joysticks
0060               ***************************************************************
0061               *  BL @VIRTKB
0062               *--------------------------------------------------------------
0063               *  COLUMN     0     1  2  3  4  5    6   7
0064               *         +---------------------------------+------+
0065               *  ROW 7  |   =     .  ,  M  N  /   JS1 JS2 | Fire |
0066               *  ROW 6  | SPACE   L  K  J  H  :;  JS1 JS2 | Left |
0067               *  ROW 5  | ENTER   O  I  U  Y  P   JS1 JS2 | Right|
0068               *  ROW 4  |         9  8  7  6  0   JS1 JS2 | Down |
0069               *  ROW 3  | FCTN    2  3  4  5  1   JS1 JS2 | Up   |
0070               *  ROW 2  | SHIFT   S  D  F  G  A           +------|
0071               *  ROW 1  | CTRL    W  E  R  T  Q                  |
0072               *  ROW 0  |         X  C  V  B  Z                  |
0073               *         +----------------------------------------+
0074               *  See MG smart programmer 1986
0075               *  September/Page 15 and November/Page 6
0076               *  Also see virtual keyboard status for bits to check
0077               *--------------------------------------------------------------
0078               *  Register usage
0079               *  TMP0     Keyboard matrix column to process
0080               *  TMP1MSB  Keyboard matrix 8 bits of 1 column
0081               *  TMP2     Virtual keyboard flags
0082               *  TMP3     Address of entry in mapping table
0083               *  TMP4     Copy of R12 (CONFIG REGISTER)
0084               *  R12      CRU communication
0085               ********|*****|*********************|**************************
0086               virtkb
0087               *       szc   @wbit10,config        ; Reset alpha lock down key
0088 135A 40A0  34         szc   @wbit11,config        ; Reset ANY key
     135C 07E4 
0089 135E C202  18         mov   config,tmp4           ; Save R12 (CONFIG REGISTER)
0090 1360 04C4  14         clr   tmp0                  ; Value in MSB! Start with column 0
0091 1362 04C6  14         clr   tmp2                  ; Erase virtual keyboard flags
0092 1364 0207  20         li    tmp3,kbmap0           ; Start with column 0
     1366 13D6 
0093               *--------------------------------------------------------------
0094               * Check alpha lock key
0095               *-------@-----@---------------------@--------------------------
0096 1368 04CC  14         clr   r12
0097 136A 1E15  20         sbz   >0015                 ; Set P5
0098 136C 1F07  20         tb    7
0099 136E 1302  14         jeq   virtk1
0100 1370 0206  20         li    tmp2,kalpha           ; Alpha lock key down
     1372 8000 
0101               *       soc   @wbit10,config        ; Set alpha lock down key (CONFIG)
0102               *--------------------------------------------------------------
0103               * Scan keyboard matrix
0104               *-------@-----@---------------------@--------------------------
0105 1374 1D15  20 virtk1  sbo   >0015                 ; Reset P5
0106 1376 020C  20         li    r12,>0024             ; Scan full 8x8 keyboard matrix. R12 is used by LDCR
     1378 0024 
0107 137A 30C4  56         ldcr  tmp0,3                ; Set keyboard column with a value from 0-7 (3=3 bits)
0108 137C 020C  20         li    r12,>0006             ; Load CRU base for row. R12 required by STCR
     137E 0006 
0109 1380 0705  14         seto  tmp1                  ; >FFFF
0110 1382 3605  64         stcr  tmp1,8                ; Bring 8 row bits into MSB of TMP1
0111 1384 0545  14         inv   tmp1
0112 1386 1302  14         jeq   virtk2                ; >0000 ?
0113 1388 E220  34         soc   @wbit11,tmp4          ; Set ANY key in copy of CONFIG register
     138A 07E4 
0114               *--------------------------------------------------------------
0115               * Process column
0116               *-------@-----@---------------------@--------------------------
0117 138C 2177  34 virtk2  coc   *tmp3+,tmp1           ; Check bit mask
0118 138E 1601  14         jne   virtk3
0119 1390 E197  26         soc   *tmp3,tmp2            ; Set virtual keyboard flags
0120 1392 05C7  14 virtk3  inct  tmp3
0121 1394 8817  46         c     *tmp3,@kbeoc          ; End-of-column ?
     1396 13E2 
0122 1398 16F9  14         jne   virtk2                ; No, next entry
0123 139A 05C7  14         inct  tmp3
0124               *--------------------------------------------------------------
0125               * Prepare for next column
0126               *-------@-----@---------------------@--------------------------
0127 139C 0284  22 virtk4  ci    tmp0,>0700            ; Column 7 processed ?
     139E 0700 
0128 13A0 1309  14         jeq   virtk6                ; Yes, exit
0129 13A2 0284  22         ci    tmp0,>0200            ; Column 2 processed ?
     13A4 0200 
0130 13A6 1303  14         jeq   virtk5                ; Yes, skip
0131 13A8 0224  22         ai    tmp0,>0100
     13AA 0100 
0132 13AC 10E3  14         jmp   virtk1
0133 13AE 0204  20 virtk5  li    tmp0,>0500            ; Skip columns 3-4
     13B0 0500 
0134 13B2 10E0  14         jmp   virtk1
0135               *--------------------------------------------------------------
0136               * Exit
0137               *-------@-----@---------------------@--------------------------
0138 13B4 C088  18 virtk6  mov   tmp4,config           ; Restore CONFIG register
0139 13B6 C806  38         mov   tmp2,@wvrtkb          ; Save virtual keyboard flags
     13B8 8332 
0140 13BA 1601  14         jne   virtk7
0141 13BC 045B  20         b     *r11                  ; Exit
0142 13BE 0286  22 virtk7  ci    tmp2,>ffff            ; FCTN-QUIT pressed ?
     13C0 FFFF 
0143 13C2 1603  14         jne   virtk8                ; No
0144 13C4 0701  14         seto  r1                    ; Set exit flag
0145 13C6 0460  28         b     @runli1               ; Yes, reset computer
     13C8 1DB4 
0146 13CA 0286  22 virtk8  ci    tmp2,kalpha           ; Only alpha-lock pressed ?
     13CC 8000 
0147 13CE 1602  14         jne   virtk9
0148 13D0 40A0  34         szc   @wbit11,config        ; Yes, so reset ANY key
     13D2 07E4 
0149 13D4 045B  20 virtk9  b     *r11                  ; Exit
0150               *--------------------------------------------------------------
0151               * Mapping table
0152               *-------@-----@---------------------@--------------------------
0153               *                                   ; Bit 01234567
0154 13D6 1100     kbmap0  data  >1100,>ffff           ; >11 00010001  FCTN QUIT
     13D8 FFFF 
0155 13DA 0200             data  >0200,k1fire          ; >02 00000010  spacebar
     13DC 0020 
0156 13DE 0400             data  >0400,kenter          ; >04 00000100  enter
     13E0 4000 
0157 13E2 FFFF     kbeoc   data  >ffff
0158               
0159 13E4 0800     kbmap1  data  >0800,kback           ; >08 00001000  FCTN BACK
     13E6 1000 
0160 13E8 0200             data  >0200,k2rg            ; >02 00000010  L (arrow right)
     13EA 0008 
0161 13EC 0400             data  >0400,k2up            ; >04 00000100  O (arrow up)
     13EE 0004 
0162 13F0 2000             data  >2000,k1lf            ; >20 00100000  S (arrow left)
     13F2 0200 
0163 13F4 8000             data  >8000,k1dn            ; >80 10000000  X (arrow down)
     13F6 0040 
0164 13F8 FFFF             data  >ffff
0165               
0166 13FA 0800     kbmap2  data  >0800,kredo           ; >08 00001000  FCTN REDO
     13FC 2000 
0167 13FE 0100             data  >0100,k2dn            ; >01 00000001  , (arrow down)
     1400 0002 
0168 1402 2000             data  >2000,k1rg            ; >20 00100000  D (arrow right)
     1404 0100 
0169 1406 4000             data  >4000,k1up            ; >80 01000000  E (arrow up)
     1408 0080 
0170 140A 0200             data  >0200,k2lf            ; >02 00000010  K (arrow left)
     140C 0010 
0171 140E FFFF             data  >ffff
0172               
0173 1410 0100     kbcol5  data  >0100,k2fire          ; >01 00000001  / (fire)
     1412 0001 
0174 1414 0800             data  >0800,kpause          ; >08 00001000  P (pause)
     1416 0800 
0175 1418 8000             data  >8000,k1fire          ; >80 01000000  Q (fire)
     141A 0020 
0176 141C FFFF             data  >ffff
0177               
0178 141E 0100     kbmap6  data  >0100,k1fire          ; >01 00000001  joystick 1 FIRE
     1420 0020 
0179 1422 0200             data  >0200,k1lf            ; >02 00000010  joystick 1 left
     1424 0200 
0180 1426 0400             data  >0400,k1rg            ; >04 00000100  joystick 1 right
     1428 0100 
0181 142A 0800             data  >0800,k1dn            ; >08 00001000  joystick 1 down
     142C 0040 
0182 142E 1000             data  >1000,k1up            ; >10 00010000  joystick 1 up
     1430 0080 
0183 1432 FFFF             data  >ffff
0184               
0185 1434 0100     kbmap7  data  >0100,k2fire          ; >01 00000001  joystick 2 FIRE
     1436 0001 
0186 1438 0200             data  >0200,k2lf            ; >02 00000010  joystick 2 left
     143A 0010 
0187 143C 0400             data  >0400,k2rg            ; >04 00000100  joystick 2 right
     143E 0008 
0188 1440 0800             data  >0800,k2dn            ; >08 00001000  joystick 2 down
     1442 0002 
0189 1444 1000             data  >1000,k2up            ; >10 00010000  joystick 2 up
     1446 0004 
0190 1448 FFFF             data  >ffff
**** **** ****     > runlib.asm
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
0016 144A 40A0  34 realkb  szc   @wbit0,config         ; Reset bit 0 in CONFIG register
     144C 07FA 
0017 144E 020C  20         li    r12,>0024
     1450 0024 
0018 1452 020F  20         li    r15,kbsmal            ; Default is KBSMAL table
     1454 14E2 
0019 1456 04C6  14         clr   tmp2
0020 1458 30C6  56         ldcr  tmp2,>0003            ; Lower case by default
0021               *--------------------------------------------------------------
0022               * SHIFT key pressed ?
0023               *--------------------------------------------------------------
0024 145A 04CC  14         clr   r12
0025 145C 1F08  20         tb    >0008                 ; Shift-key ?
0026 145E 1302  14         jeq   realk1                ; No
0027 1460 020F  20         li    r15,kbshft            ; Yes, use KBSHIFT table
     1462 1512 
0028               *--------------------------------------------------------------
0029               * FCTN key pressed ?
0030               *--------------------------------------------------------------
0031 1464 1F07  20 realk1  tb    >0007                 ; FNCTN-key ?
0032 1466 1302  14         jeq   realk2                ; No
0033 1468 020F  20         li    r15,kbfctn            ; Yes, use KBFCTN table
     146A 1542 
0034               *--------------------------------------------------------------
0035               * CTRL key pressed ?
0036               *--------------------------------------------------------------
0037 146C 1F09  20 realk2  tb    >0009                 ; CTRL-key ?
0038 146E 1302  14         jeq   realk3                ; No
0039 1470 020F  20         li    r15,kbctrl            ; Yes, use KBCTRL table
     1472 1572 
0040               *--------------------------------------------------------------
0041               * ALPHA LOCK key down ?
0042               *--------------------------------------------------------------
0043 1474 1E15  20 realk3  sbz   >0015                 ; Set P5
0044 1476 1F07  20         tb    >0007                 ; ALPHA-Lock key ?
0045 1478 1302  14         jeq   realk4                ; No,  CONFIG register bit 0 = 0
0046 147A E0A0  34         soc   @wbit0,config         ; Yes, CONFIG register bit 0 = 1
     147C 07FA 
0047               *--------------------------------------------------------------
0048               * Scan keyboard column
0049               *--------------------------------------------------------------
0050 147E 1D15  20 realk4  sbo   >0015                 ; Reset P5
0051 1480 0206  20         li    tmp2,6                ; Bitcombination for CRU, column counter
     1482 0006 
0052 1484 0606  14 realk5  dec   tmp2
0053 1486 020C  20         li    r12,>24               ; CRU address for P2-P4
     1488 0024 
0054 148A 06C6  14         swpb  tmp2
0055 148C 30C6  56         ldcr  tmp2,3                ; Transfer bit combination
0056 148E 06C6  14         swpb  tmp2
0057 1490 020C  20         li    r12,6                 ; CRU read address
     1492 0006 
0058 1494 3607  64         stcr  tmp3,8                ; Transfer 8 bits into R2HB
0059 1496 0547  14         inv   tmp3                  ;
0060 1498 0247  22         andi  tmp3,>ff00            ; Clear TMP3LB
     149A FF00 
0061               *--------------------------------------------------------------
0062               * Scan keyboard row
0063               *--------------------------------------------------------------
0064 149C 04C5  14         clr   tmp1                  ; Use TMP1 as row counter from now on
0065 149E 0A17  56 realk6  sla   tmp3,1                ; R2 bitcombinations scanned by shifting left.
0066 14A0 1807  14         joc   realk8                ; If no carry after 8 loops, then it means no key
0067 14A2 0585  14 realk7  inc   tmp1                  ; was pressed on that line.
0068 14A4 0285  22         ci    tmp1,8
     14A6 0008 
0069 14A8 1AFA  14         jl    realk6
0070 14AA C186  18         mov   tmp2,tmp2             ; All 6 columns processed ?
0071 14AC 1BEB  14         jh    realk5                ; No, next column
0072 14AE 1016  14         jmp   realkz                ; Yes, exit
0073               *--------------------------------------------------------------
0074               * Check for match in data table
0075               *--------------------------------------------------------------
0076 14B0 C206  18 realk8  mov   tmp2,tmp4
0077 14B2 0A38  56         sla   tmp4,3                ; TMP4 = TMP2 * 8
0078 14B4 A205  18         a     tmp1,tmp4             ; TMP4 = TMP4 + TMP1
0079 14B6 A20F  18         a     r15,tmp4              ; TMP4 = TMP4 + base address of data table (R15)
0080 14B8 D618  38         movb  *tmp4,*tmp4           ; Is the byte on that address = >00 ?
0081 14BA 13F3  14         jeq   realk7                ; Yes, then discard and continue scanning (FCTN, SHIFT, CTRL)
0082               *--------------------------------------------------------------
0083               * Determine ASCII value of key
0084               *--------------------------------------------------------------
0085 14BC D198  26 realk9  movb  *tmp4,tmp2            ; Real keypress. It's safe to reuse TMP2 now
0086 14BE 20A0  38         coc   @wbit0,config         ; ALPHA-Lock key pressed ?
     14C0 07FA 
0087 14C2 1608  14         jne   realka                ; No, continue saving key
0088 14C4 9806  38         cb    tmp2,@kbsmal+42       ; Is ASCII of key pressed < 97 ('a') ?
     14C6 150C 
0089 14C8 1A05  14         jl    realka
0090 14CA 9806  38         cb    tmp2,@kbsmal+40       ; and ASCII of key pressed > 122 ('z') ?
     14CC 150A 
0091 14CE 1B02  14         jh    realka                ; No, continue
0092 14D0 0226  22         ai    tmp2,->2000           ; ASCII = ASCII - 32 (lowercase to uppercase!)
     14D2 E000 
0093 14D4 C806  38 realka  mov   tmp2,@waux1           ; Store ASCII value of key in WAUX1
     14D6 833C 
0094 14D8 E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     14DA 07E4 
0095 14DC 020F  20 realkz  li    r15,vdpw              ; Setup VDP write address again after using R15 as temp storage
     14DE 8C00 
0096 14E0 045B  20         b     *r11                  ; Exit
0097               ********|*****|*********************|**************************
0098 14E2 FF00     kbsmal  data  >ff00,>0000,>ff0d,>203D
     14E4 0000 
     14E6 FF0D 
     14E8 203D 
0099 14EA ....             text  'xws29ol.'
0100 14F2 ....             text  'ced38ik,'
0101 14FA ....             text  'vrf47ujm'
0102 1502 ....             text  'btg56yhn'
0103 150A ....             text  'zqa10p;/'
0104 1512 FF00     kbshft  data  >ff00,>0000,>ff0d,>202B
     1514 0000 
     1516 FF0D 
     1518 202B 
0105 151A ....             text  'XWS@(OL>'
0106 1522 ....             text  'CED#*IK<'
0107 152A ....             text  'VRF$&UJM'
0108 1532 ....             text  'BTG%^YHN'
0109 153A ....             text  'ZQA!)P:-'
0110 1542 FF00     kbfctn  data  >ff00,>0000,>ff0d,>2005
     1544 0000 
     1546 FF0D 
     1548 2005 
0111 154A 0A7E             data  >0a7e,>0804,>0f27,>c2B9
     154C 0804 
     154E 0F27 
     1550 C2B9 
0112 1552 600B             data  >600b,>0907,>063f,>c1B8
     1554 0907 
     1556 063F 
     1558 C1B8 
0113 155A 7F5B             data  >7f5b,>7b02,>015f,>c0C3
     155C 7B02 
     155E 015F 
     1560 C0C3 
0114 1562 BE5D             data  >be5d,>7d0e,>0cc6,>bfC4
     1564 7D0E 
     1566 0CC6 
     1568 BFC4 
0115 156A 5CB9             data  >5cb9,>7c03,>bc22,>bdBA
     156C 7C03 
     156E BC22 
     1570 BDBA 
0116 1572 FF00     kbctrl  data  >ff00,>0000,>ff0d,>209D
     1574 0000 
     1576 FF0D 
     1578 209D 
0117 157A 9897             data  >9897,>93b2,>9f8f,>8c9B
     157C 93B2 
     157E 9F8F 
     1580 8C9B 
0118 1582 8385             data  >8385,>84b3,>9e89,>8b80
     1584 84B3 
     1586 9E89 
     1588 8B80 
0119 158A 9692             data  >9692,>86b4,>b795,>8a8D
     158C 86B4 
     158E B795 
     1590 8A8D 
0120 1592 8294             data  >8294,>87b5,>b698,>888E
     1594 87B5 
     1596 B698 
     1598 888E 
0121 159A 9A91             data  >9a91,>81b1,>b090,>9cBB
     159C 81B1 
     159E B090 
     15A0 9CBB 
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
0023 15A2 C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 15A4 C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     15A6 8340 
0025 15A8 04E0  34         clr   @waux1
     15AA 833C 
0026 15AC 04E0  34         clr   @waux2
     15AE 833E 
0027 15B0 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     15B2 833C 
0028 15B4 C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 15B6 0205  20         li    tmp1,4                ; 4 nibbles
     15B8 0004 
0033 15BA C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 15BC 0246  22         andi  tmp2,>000f            ; Only keep LSN
     15BE 000F 
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 15C0 0286  22         ci    tmp2,>000a
     15C2 000A 
0039 15C4 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 15C6 C21B  26         mov   *r11,tmp4
0045 15C8 0988  56         srl   tmp4,8                ; Right justify
0046 15CA 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     15CC FFF6 
0047 15CE 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 15D0 C21B  26         mov   *r11,tmp4
0054 15D2 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     15D4 00FF 
0055               
0056 15D6 A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 15D8 06C6  14         swpb  tmp2
0058 15DA DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 15DC 0944  56         srl   tmp0,4                ; Next nibble
0060 15DE 0605  14         dec   tmp1
0061 15E0 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 15E2 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     15E4 BFFF 
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 15E6 C160  34         mov   @waux3,tmp1           ; Get pointer
     15E8 8340 
0067 15EA 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 15EC 0585  14         inc   tmp1                  ; Next byte, not word!
0069 15EE C120  34         mov   @waux2,tmp0
     15F0 833E 
0070 15F2 06C4  14         swpb  tmp0
0071 15F4 DD44  32         movb  tmp0,*tmp1+
0072 15F6 06C4  14         swpb  tmp0
0073 15F8 DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 15FA C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     15FC 8340 
0078 15FE D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     1600 07F0 
0079 1602 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 1604 C120  34         mov   @waux1,tmp0
     1606 833C 
0084 1608 06C4  14         swpb  tmp0
0085 160A DD44  32         movb  tmp0,*tmp1+
0086 160C 06C4  14         swpb  tmp0
0087 160E DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 1610 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     1612 07FA 
0092 1614 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 1616 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 1618 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     161A 7FFF 
0098 161C C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     161E 8340 
0099 1620 0460  28         b     @xutst0               ; Display string
     1622 0BD0 
0100 1624 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 1626 C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     1628 832A 
0122 162A 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     162C 8000 
0123 162E 10B9  14         jmp   mkhex                 ; Convert number and display
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
0019 1630 0207  20 mknum   li    tmp3,5                ; Digit counter
     1632 0005 
0020 1634 C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 1636 C155  26         mov   *tmp1,tmp1            ; /
0022 1638 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 163A 0228  22         ai    tmp4,4                ; Get end of buffer
     163C 0004 
0024 163E 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     1640 000A 
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 1642 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 1644 3D06  128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 1646 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 1648 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 164A D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 164C C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for the next digit
0034 164E 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 1650 0607  14         dec   tmp3                  ; Decrease counter
0036 1652 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 1654 0207  20         li    tmp3,4                ; Check first 4 digits
     1656 0004 
0041 1658 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 165A C11B  26         mov   *r11,tmp0
0043 165C 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 165E 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 1660 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 1662 05CB  14 mknum3  inct  r11
0047 1664 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     1666 07FA 
0048 1668 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 166A 045B  20         b     *r11                  ; Exit
0050 166C DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 166E 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 1670 13F8  14         jeq   mknum3                ; Yes, exit
0053 1672 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 1674 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     1676 7FFF 
0058 1678 C10B  18         mov   r11,tmp0
0059 167A 0224  22         ai    tmp0,-4
     167C FFFC 
0060 167E C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 1680 0206  20         li    tmp2,>0500            ; String length = 5
     1682 0500 
0062 1684 0460  28         b     @xutstr               ; Display string
     1686 0BD2 
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
0092 1688 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0093 168A C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0094 168C C1BB  30         mov   *r11+,tmp2            ; Get padding character
0095 168E 06C6  14         swpb  tmp2                  ; LO <-> HI
0096 1690 0207  20         li    tmp3,5                ; Set counter
     1692 0005 
0097                       ;------------------------------------------------------
0098                       ; Scan for padding character from left to right
0099                       ;------------------------------------------------------:
0100               trimnum_scan:
0101 1694 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0102 1696 1604  14         jne   trimnum_setlen        ; No, exit loop
0103 1698 0584  14         inc   tmp0                  ; Next character
0104 169A 0607  14         dec   tmp3                  ; Last digit reached ?
0105 169C 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0106 169E 10FA  14         jmp   trimnum_scan
0107                       ;------------------------------------------------------
0108                       ; Scan completed, set length byte new string
0109                       ;------------------------------------------------------
0110               trimnum_setlen:
0111 16A0 06C7  14         swpb  tmp3                  ; LO <-> HI
0112 16A2 DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0113 16A4 06C7  14         swpb  tmp3                  ; LO <-> HI
0114                       ;------------------------------------------------------
0115                       ; Start filling new string
0116                       ;------------------------------------------------------
0117               trimnum_fill
0118 16A6 DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0119 16A8 0607  14         dec   tmp3                  ; Last character ?
0120 16AA 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0121 16AC 045B  20         b     *r11                  ; Return
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
0138 16AE C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     16B0 832A 
0139 16B2 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     16B4 8000 
0140 16B6 10BC  14         jmp   mknum                 ; Convert number and display
**** **** ****     > runlib.asm
0186               
0188                        copy  "cpu_crc16.asm"           ; CRC-16 checksum calculation
**** **** ****     > cpu_crc16.asm
0001               * FILE......: cpu_crc16.asm
0002               * Purpose...: CPU memory CRC-16 Cyclic Redundancy Checksum
0003               
0004               
0005               ***************************************************************
0006               * CALC_CRC - Calculate 16 bit Cyclic Redundancy Check
0007               ***************************************************************
0008               *  bl   @calc_crc
0009               *  data p0,p1
0010               *--------------------------------------------------------------
0011               *  p0 = Memory start address
0012               *  p1 = Memory end address
0013               *--------------------------------------------------------------
0014               *  bl   @calc_crcx
0015               *
0016               *  tmp0 = Memory start address
0017               *  tmp1 = Memory end address
0018               *--------------------------------------------------------------
0019               *  REMARKS
0020               *  Introduces register equate wcrc (tmp4/r8) which contains the
0021               *  calculated CRC-16 checksum upon exit.
0022               ********|*****|*********************|**************************
0023      0004     wmemory equ   tmp0                  ; Current memory address
0024      0005     wmemend equ   tmp1                  ; Highest memory address to process
0025      0008     wcrc    equ   tmp4                  ; Current CRC
0026               *--------------------------------------------------------------
0027               * Entry point
0028               *--------------------------------------------------------------
0029               calc_crc:
0030 16B8 C13B  30         mov   *r11+,wmemory         ; First memory address
0031 16BA C17B  30         mov   *r11+,wmemend         ; Last memory address
0032               calc_crcx:
0033 16BC 0708  14         seto  wcrc                  ; Starting crc value = 0xffff
0034 16BE 1001  14         jmp   calc_crc2             ; Start with first memory word
0035               *--------------------------------------------------------------
0036               * (1) Next word
0037               *--------------------------------------------------------------
0038               calc_crc1:
0039 16C0 05C4  14         inct  wmemory               ; Next word
0040               *--------------------------------------------------------------
0041               * (2) Process high byte
0042               *--------------------------------------------------------------
0043               calc_crc2:
0044 16C2 C194  26         mov   *wmemory,tmp2         ; Get word from memory
0045 16C4 0986  56         srl   tmp2,8                ; memory word >> 8
0046               
0047 16C6 C1C8  18         mov   wcrc,tmp3
0048 16C8 0987  56         srl   tmp3,8                ; tmp3 = current CRC >> 8
0049               
0050 16CA 29C6  18         xor   tmp2,tmp3             ; XOR current CRC with byte
0051 16CC 0247  22         andi  tmp3,>00ff            ; Only keep LSB as index in lookup table
     16CE 00FF 
0052               
0053 16D0 0A17  56         sla   tmp3,1                ; Offset in lookup table = index * 2
0054 16D2 0A88  56         sla   wcrc,8                ; wcrc << 8
0055 16D4 2A27  34         xor   @crc_table(tmp3),wcrc ; Current CRC = xor "substitution byte" with current CRC
     16D6 16FA 
0056               *--------------------------------------------------------------
0057               * (3) Process low byte
0058               *--------------------------------------------------------------
0059               calc_crc3:
0060 16D8 C194  26         mov   *wmemory,tmp2         ; Get word from memory
0061 16DA 0246  22         andi  tmp2,>00ff            ; Clear MSB
     16DC 00FF 
0062               
0063 16DE C1C8  18         mov   wcrc,tmp3
0064 16E0 0987  56         srl   tmp3,8                ; tmp3 = current CRC >> 8
0065               
0066 16E2 29C6  18         xor   tmp2,tmp3             ; XOR current CRC with byte
0067 16E4 0247  22         andi  tmp3,>00ff            ; Only keep LSB as index in lookup table
     16E6 00FF 
0068               
0069 16E8 0A17  56         sla   tmp3,1                ; Offset in lookup table = index * 2
0070 16EA 0A88  56         sla   wcrc,8                ; wcrc << 8
0071 16EC 2A27  34         xor   @crc_table(tmp3),wcrc ; Current CRC = xor "substitution byte" with current CRC
     16EE 16FA 
0072               *--------------------------------------------------------------
0073               * Memory range done ?
0074               *--------------------------------------------------------------
0075 16F0 8144  18         c     wmemory,wmemend       ; Memory range done ?
0076 16F2 11E6  14         jlt   calc_crc1             ; Next word unless done
0077               *--------------------------------------------------------------
0078               * XOR final result with 0
0079               *--------------------------------------------------------------
0080 16F4 04C7  14         clr   tmp3
0081 16F6 2A07  18         xor   tmp3,wcrc             ; Final CRC
0082               calc_crc.exit:
0083 16F8 045B  20         b     *r11                  ; Return
0084               
0085               
0086               
0087               ***************************************************************
0088               * CRC Lookup Table - 1024 bytes
0089               * http://www.sunshine2k.de/coding/javascript/crc/crc_js.html
0090               *--------------------------------------------------------------
0091               * Polynomial........: 0x1021
0092               * Initial value.....: 0x0
0093               * Final Xor value...: 0x0
0094               ***************************************************************
0095               crc_table
0096 16FA 0000             data  >0000, >1021, >2042, >3063, >4084, >50a5, >60c6, >70e7
     16FC 1021 
     16FE 2042 
     1700 3063 
     1702 4084 
     1704 50A5 
     1706 60C6 
     1708 70E7 
0097 170A 8108             data  >8108, >9129, >a14a, >b16b, >c18c, >d1ad, >e1ce, >f1ef
     170C 9129 
     170E A14A 
     1710 B16B 
     1712 C18C 
     1714 D1AD 
     1716 E1CE 
     1718 F1EF 
0098 171A 1231             data  >1231, >0210, >3273, >2252, >52b5, >4294, >72f7, >62d6
     171C 0210 
     171E 3273 
     1720 2252 
     1722 52B5 
     1724 4294 
     1726 72F7 
     1728 62D6 
0099 172A 9339             data  >9339, >8318, >b37b, >a35a, >d3bd, >c39c, >f3ff, >e3de
     172C 8318 
     172E B37B 
     1730 A35A 
     1732 D3BD 
     1734 C39C 
     1736 F3FF 
     1738 E3DE 
0100 173A 2462             data  >2462, >3443, >0420, >1401, >64e6, >74c7, >44a4, >5485
     173C 3443 
     173E 0420 
     1740 1401 
     1742 64E6 
     1744 74C7 
     1746 44A4 
     1748 5485 
0101 174A A56A             data  >a56a, >b54b, >8528, >9509, >e5ee, >f5cf, >c5ac, >d58d
     174C B54B 
     174E 8528 
     1750 9509 
     1752 E5EE 
     1754 F5CF 
     1756 C5AC 
     1758 D58D 
0102 175A 3653             data  >3653, >2672, >1611, >0630, >76d7, >66f6, >5695, >46b4
     175C 2672 
     175E 1611 
     1760 0630 
     1762 76D7 
     1764 66F6 
     1766 5695 
     1768 46B4 
0103 176A B75B             data  >b75b, >a77a, >9719, >8738, >f7df, >e7fe, >d79d, >c7bc
     176C A77A 
     176E 9719 
     1770 8738 
     1772 F7DF 
     1774 E7FE 
     1776 D79D 
     1778 C7BC 
0104 177A 48C4             data  >48c4, >58e5, >6886, >78a7, >0840, >1861, >2802, >3823
     177C 58E5 
     177E 6886 
     1780 78A7 
     1782 0840 
     1784 1861 
     1786 2802 
     1788 3823 
0105 178A C9CC             data  >c9cc, >d9ed, >e98e, >f9af, >8948, >9969, >a90a, >b92b
     178C D9ED 
     178E E98E 
     1790 F9AF 
     1792 8948 
     1794 9969 
     1796 A90A 
     1798 B92B 
0106 179A 5AF5             data  >5af5, >4ad4, >7ab7, >6a96, >1a71, >0a50, >3a33, >2a12
     179C 4AD4 
     179E 7AB7 
     17A0 6A96 
     17A2 1A71 
     17A4 0A50 
     17A6 3A33 
     17A8 2A12 
0107 17AA DBFD             data  >dbfd, >cbdc, >fbbf, >eb9e, >9b79, >8b58, >bb3b, >ab1a
     17AC CBDC 
     17AE FBBF 
     17B0 EB9E 
     17B2 9B79 
     17B4 8B58 
     17B6 BB3B 
     17B8 AB1A 
0108 17BA 6CA6             data  >6ca6, >7c87, >4ce4, >5cc5, >2c22, >3c03, >0c60, >1c41
     17BC 7C87 
     17BE 4CE4 
     17C0 5CC5 
     17C2 2C22 
     17C4 3C03 
     17C6 0C60 
     17C8 1C41 
0109 17CA EDAE             data  >edae, >fd8f, >cdec, >ddcd, >ad2a, >bd0b, >8d68, >9d49
     17CC FD8F 
     17CE CDEC 
     17D0 DDCD 
     17D2 AD2A 
     17D4 BD0B 
     17D6 8D68 
     17D8 9D49 
0110 17DA 7E97             data  >7e97, >6eb6, >5ed5, >4ef4, >3e13, >2e32, >1e51, >0e70
     17DC 6EB6 
     17DE 5ED5 
     17E0 4EF4 
     17E2 3E13 
     17E4 2E32 
     17E6 1E51 
     17E8 0E70 
0111 17EA FF9F             data  >ff9f, >efbe, >dfdd, >cffc, >bf1b, >af3a, >9f59, >8f78
     17EC EFBE 
     17EE DFDD 
     17F0 CFFC 
     17F2 BF1B 
     17F4 AF3A 
     17F6 9F59 
     17F8 8F78 
0112 17FA 9188             data  >9188, >81a9, >b1ca, >a1eb, >d10c, >c12d, >f14e, >e16f
     17FC 81A9 
     17FE B1CA 
     1800 A1EB 
     1802 D10C 
     1804 C12D 
     1806 F14E 
     1808 E16F 
0113 180A 1080             data  >1080, >00a1, >30c2, >20e3, >5004, >4025, >7046, >6067
     180C 00A1 
     180E 30C2 
     1810 20E3 
     1812 5004 
     1814 4025 
     1816 7046 
     1818 6067 
0114 181A 83B9             data  >83b9, >9398, >a3fb, >b3da, >c33d, >d31c, >e37f, >f35e
     181C 9398 
     181E A3FB 
     1820 B3DA 
     1822 C33D 
     1824 D31C 
     1826 E37F 
     1828 F35E 
0115 182A 02B1             data  >02b1, >1290, >22f3, >32d2, >4235, >5214, >6277, >7256
     182C 1290 
     182E 22F3 
     1830 32D2 
     1832 4235 
     1834 5214 
     1836 6277 
     1838 7256 
0116 183A B5EA             data  >b5ea, >a5cb, >95a8, >8589, >f56e, >e54f, >d52c, >c50d
     183C A5CB 
     183E 95A8 
     1840 8589 
     1842 F56E 
     1844 E54F 
     1846 D52C 
     1848 C50D 
0117 184A 34E2             data  >34e2, >24c3, >14a0, >0481, >7466, >6447, >5424, >4405
     184C 24C3 
     184E 14A0 
     1850 0481 
     1852 7466 
     1854 6447 
     1856 5424 
     1858 4405 
0118 185A A7DB             data  >a7db, >b7fa, >8799, >97b8, >e75f, >f77e, >c71d, >d73c
     185C B7FA 
     185E 8799 
     1860 97B8 
     1862 E75F 
     1864 F77E 
     1866 C71D 
     1868 D73C 
0119 186A 26D3             data  >26d3, >36f2, >0691, >16b0, >6657, >7676, >4615, >5634
     186C 36F2 
     186E 0691 
     1870 16B0 
     1872 6657 
     1874 7676 
     1876 4615 
     1878 5634 
0120 187A D94C             data  >d94c, >c96d, >f90e, >e92f, >99c8, >89e9, >b98a, >a9ab
     187C C96D 
     187E F90E 
     1880 E92F 
     1882 99C8 
     1884 89E9 
     1886 B98A 
     1888 A9AB 
0121 188A 5844             data  >5844, >4865, >7806, >6827, >18c0, >08e1, >3882, >28a3
     188C 4865 
     188E 7806 
     1890 6827 
     1892 18C0 
     1894 08E1 
     1896 3882 
     1898 28A3 
0122 189A CB7D             data  >cb7d, >db5c, >eb3f, >fb1e, >8bf9, >9bd8, >abbb, >bb9a
     189C DB5C 
     189E EB3F 
     18A0 FB1E 
     18A2 8BF9 
     18A4 9BD8 
     18A6 ABBB 
     18A8 BB9A 
0123 18AA 4A75             data  >4a75, >5a54, >6a37, >7a16, >0af1, >1ad0, >2ab3, >3a92
     18AC 5A54 
     18AE 6A37 
     18B0 7A16 
     18B2 0AF1 
     18B4 1AD0 
     18B6 2AB3 
     18B8 3A92 
0124 18BA FD2E             data  >fd2e, >ed0f, >dd6c, >cd4d, >bdaa, >ad8b, >9de8, >8dc9
     18BC ED0F 
     18BE DD6C 
     18C0 CD4D 
     18C2 BDAA 
     18C4 AD8B 
     18C6 9DE8 
     18C8 8DC9 
0125 18CA 7C26             data  >7c26, >6c07, >5c64, >4c45, >3ca2, >2c83, >1ce0, >0cc1
     18CC 6C07 
     18CE 5C64 
     18D0 4C45 
     18D2 3CA2 
     18D4 2C83 
     18D6 1CE0 
     18D8 0CC1 
0126 18DA EF1F             data  >ef1f, >ff3e, >cf5d, >df7c, >af9b, >bfba, >8fd9, >9ff8
     18DC FF3E 
     18DE CF5D 
     18E0 DF7C 
     18E2 AF9B 
     18E4 BFBA 
     18E6 8FD9 
     18E8 9FF8 
0127 18EA 6E17             data  >6e17, >7e36, >4e55, >5e74, >2e93, >3eb2, >0ed1, >1ef0
     18EC 7E36 
     18EE 4E55 
     18F0 5E74 
     18F2 2E93 
     18F4 3EB2 
     18F6 0ED1 
     18F8 1EF0 
**** **** ****     > runlib.asm
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
0074 18FA C13B  30         mov   *r11+,tmp0            ; ROM/RAM source address
0075 18FC C17B  30         mov   *r11+,tmp1            ; RAM target address
0076 18FE C1BB  30         mov   *r11+,tmp2            ; Length of data to encode
0077               xcpu2rle:
0078 1900 0649  14         dect  stack
0079 1902 C64B  30         mov   r11,*stack            ; Save return address
0080               *--------------------------------------------------------------
0081               *   Initialisation
0082               *--------------------------------------------------------------
0083               cup2rle.init:
0084 1904 04C7  14         clr   tmp3                  ; Character buffer (2 chars)
0085 1906 04C8  14         clr   tmp4                  ; Repeat counter
0086 1908 04E0  34         clr   @waux1                ; Length of RLE string
     190A 833C 
0087 190C 04E0  34         clr   @waux2                ; Address of encoding byte
     190E 833E 
0088               *--------------------------------------------------------------
0089               *   (1.1) Scan string
0090               *--------------------------------------------------------------
0091               cpu2rle.scan:
0092 1910 0987  56         srl   tmp3,8                ; Save old character in LSB
0093 1912 D1F4  28         movb  *tmp0+,tmp3           ; Move current character to MSB
0094 1914 91D4  26         cb    *tmp0,tmp3            ; Compare 1st lookahead with current.
0095 1916 1606  14         jne   cpu2rle.scan.nodup    ; No duplicate, move along
0096                       ;------------------------------------------------------
0097                       ; Only check 2nd lookahead if new string fragment
0098                       ;------------------------------------------------------
0099 1918 C208  18         mov   tmp4,tmp4             ; Repeat counter > 0 ?
0100 191A 1515  14         jgt   cpu2rle.scan.dup      ; Duplicate found
0101                       ;------------------------------------------------------
0102                       ; Special handling for new string fragment
0103                       ;------------------------------------------------------
0104 191C 91E4  34         cb    @1(tmp0),tmp3         ; Compare 2nd lookahead with current.
     191E 0001 
0105 1920 1601  14         jne   cpu2rle.scan.nodup    ; Only 1 repeated char, compression is
0106                                                   ; not worth it, so move along
0107               
0108 1922 1311  14         jeq   cpu2rle.scan.dup      ; Duplicate found
0109               *--------------------------------------------------------------
0110               *   (1.2) No duplicate
0111               *--------------------------------------------------------------
0112               cpu2rle.scan.nodup:
0113                       ;------------------------------------------------------
0114                       ; (1.2.1) First flush any pending duplicates
0115                       ;------------------------------------------------------
0116 1924 C208  18         mov   tmp4,tmp4             ; Repeat counter = 0 ?
0117 1926 1302  14         jeq   cpu2rle.scan.nodup.rest
0118               
0119 1928 06A0  32         bl    @cpu2rle.flush.duplicates
     192A 1974 
0120                                                   ; Flush pending duplicates
0121                       ;------------------------------------------------------
0122                       ; (1.2.3) Track address of encoding byte
0123                       ;------------------------------------------------------
0124               cpu2rle.scan.nodup.rest:
0125 192C C820  54         mov   @waux2,@waux2         ; \ Address encoding byte already fetched?
     192E 833E 
     1930 833E 
0126 1932 1605  14         jne   !                     ; / Yes, so don't fetch again!
0127               
0128 1934 C805  38         mov   tmp1,@waux2           ; Fetch address of future encoding byte
     1936 833E 
0129 1938 0585  14         inc   tmp1                  ; Skip encoding byte
0130 193A 05A0  34         inc   @waux1                ; RLE string length += 1 for encoding byte
     193C 833C 
0131                       ;------------------------------------------------------
0132                       ; (1.2.4) Write data byte to output buffer
0133                       ;------------------------------------------------------
0134 193E DD47  32 !       movb  tmp3,*tmp1+           ; Copy data byte character
0135 1940 05A0  34         inc   @waux1                ; RLE string length += 1
     1942 833C 
0136 1944 1008  14         jmp   cpu2rle.scan.next     ; Next character
0137               *--------------------------------------------------------------
0138               *   (1.3) Duplicate
0139               *--------------------------------------------------------------
0140               cpu2rle.scan.dup:
0141                       ;------------------------------------------------------
0142                       ; (1.3.1) First flush any pending non-duplicates
0143                       ;------------------------------------------------------
0144 1946 C820  54         mov   @waux2,@waux2         ; Pending encoding byte address present?
     1948 833E 
     194A 833E 
0145 194C 1302  14         jeq   cpu2rle.scan.dup.rest
0146               
0147 194E 06A0  32         bl    @cpu2rle.flush.encoding_byte
     1950 198E 
0148                                                   ; Set encoding byte before
0149                                                   ; 1st data byte of unique string
0150                       ;------------------------------------------------------
0151                       ; (1.3.3) Now process duplicate character
0152                       ;------------------------------------------------------
0153               cpu2rle.scan.dup.rest:
0154 1952 0588  14         inc   tmp4                  ; Increase repeat counter
0155 1954 1000  14         jmp   cpu2rle.scan.next     ; Scan next character
0156               
0157               *--------------------------------------------------------------
0158               *   (2) Next character
0159               *--------------------------------------------------------------
0160               cpu2rle.scan.next:
0161 1956 0606  14         dec   tmp2
0162 1958 15DB  14         jgt   cpu2rle.scan          ; (2.1) Next compare
0163               
0164               *--------------------------------------------------------------
0165               *   (3) End of string reached
0166               *--------------------------------------------------------------
0167                       ;------------------------------------------------------
0168                       ; (3.1) Flush any pending duplicates
0169                       ;------------------------------------------------------
0170               cpu2rle.eos.check1:
0171 195A C208  18         mov   tmp4,tmp4             ; Repeat counter = 0 ?
0172 195C 1303  14         jeq   cpu2rle.eos.check2
0173               
0174 195E 06A0  32         bl    @cpu2rle.flush.duplicates
     1960 1974 
0175                                                   ; (3.2) Flush pending ...
0176 1962 1006  14         jmp   cpu2rle.exit          ;       duplicates & exit
0177                       ;------------------------------------------------------
0178                       ; (3.3) Flush any pending encoding byte
0179                       ;------------------------------------------------------
0180               cpu2rle.eos.check2:
0181 1964 C820  54         mov   @waux2,@waux2
     1966 833E 
     1968 833E 
0182 196A 1302  14         jeq   cpu2rle.exit          ; No, so exit
0183               
0184 196C 06A0  32         bl    @cpu2rle.flush.encoding_byte
     196E 198E 
0185                                                   ; (3.4) Set encoding byte before
0186                                                   ; 1st data byte of unique string
0187               *--------------------------------------------------------------
0188               *   (4) Exit
0189               *--------------------------------------------------------------
0190               cpu2rle.exit:
0191 1970 0460  28         b     @poprt                ; Return
     1972 09E2 
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
0204 1974 06C7  14         swpb  tmp3                  ; Need the "old" character in buffer
0205               
0206 1976 D207  18         movb  tmp3,tmp4             ; Move character to MSB
0207 1978 06C8  14         swpb  tmp4                  ; Move counter to MSB, character to LSB
0208               
0209 197A 0268  22         ori   tmp4,>8000            ; Set high bit in MSB
     197C 8000 
0210 197E DD48  32         movb  tmp4,*tmp1+           ; \ Write encoding byte and data byte
0211 1980 06C8  14         swpb  tmp4                  ; | Could be on uneven address so using
0212 1982 DD48  32         movb  tmp4,*tmp1+           ; / movb instruction instead of mov
0213 1984 05E0  34         inct  @waux1                ; RLE string length += 2
     1986 833C 
0214                       ;------------------------------------------------------
0215                       ; Exit
0216                       ;------------------------------------------------------
0217               cpu2rle.flush.duplicates.exit:
0218 1988 06C7  14         swpb  tmp3                  ; Back to "current" character in buffer
0219 198A 04C8  14         clr   tmp4                  ; Clear repeat count
0220 198C 045B  20         b     *r11                  ; Return
0221               
0222               
0223               *--------------------------------------------------------------
0224               *   (1.3.2) Set encoding byte before first data byte
0225               *--------------------------------------------------------------
0226               cpu2rle.flush.encoding_byte:
0227 198E 0649  14         dect  stack                 ; Short on registers, save tmp3 on stack
0228 1990 C647  30         mov   tmp3,*stack           ; No need to save tmp4, but reset before exit
0229               
0230 1992 C1C5  18         mov   tmp1,tmp3             ; \ Calculate length of non-repeated
0231 1994 61E0  34         s     @waux2,tmp3           ; | characters
     1996 833E 
0232 1998 0607  14         dec   tmp3                  ; /
0233               
0234 199A 0A87  56         sla   tmp3,8                ; Left align to MSB
0235 199C C220  34         mov   @waux2,tmp4           ; Destination address of encoding byte
     199E 833E 
0236 19A0 D607  30         movb  tmp3,*tmp4            ; Set encoding byte
0237               
0238 19A2 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3 from stack
0239 19A4 04E0  34         clr   @waux2                ; Reset address of encoding byte
     19A6 833E 
0240 19A8 04C8  14         clr   tmp4                  ; Clear before exit
0241 19AA 045B  20         b     *r11                  ; Return
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
0016               *
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
0031 19AC C13B  30         mov   *r11+,tmp0            ; ROM/RAM source address
0032 19AE C17B  30         mov   *r11+,tmp1            ; RAM target address
0033 19B0 C1BB  30         mov   *r11+,tmp2            ; Length of RLE encoded data
0034               xrle2cpu:
0035 19B2 0649  14         dect  stack
0036 19B4 C64B  30         mov   r11,*stack            ; Save return address
0037               *--------------------------------------------------------------
0038               *   Scan RLE control byte
0039               *--------------------------------------------------------------
0040               rle2cpu.scan:
0041 19B6 D1F4  28         movb  *tmp0+,tmp3           ; Get control byte into tmp3
0042 19B8 0606  14         dec   tmp2                  ; Update length
0043 19BA 131E  14         jeq   rle2cpu.exit          ; End of list
0044 19BC 0A17  56         sla   tmp3,1                ; Check bit 0 of control byte
0045 19BE 1809  14         joc   rle2cpu.dump_compressed
0046                                                   ; Yes, next byte is compressed
0047               *--------------------------------------------------------------
0048               *    Dump uncompressed bytes
0049               *--------------------------------------------------------------
0050               rle2cpu.dump_uncompressed:
0051 19C0 0997  56         srl   tmp3,9                ; Use control byte as loop counter
0052 19C2 6187  18         s     tmp3,tmp2             ; Update RLE string length
0053               
0054 19C4 0649  14         dect  stack
0055 19C6 C646  30         mov   tmp2,*stack           ; Push tmp2
0056 19C8 C187  18         mov   tmp3,tmp2             ; Set length for block copy
0057               
0058 19CA 06A0  32         bl    @xpym2m               ; Block copy to destination
     19CC 0C36 
0059                                                   ; \ i  tmp0 = Source address
0060                                                   ; | i  tmp1 = Target address
0061                                                   ; / i  tmp2 = Bytes to copy
0062               
0063 19CE C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0064 19D0 1011  14         jmp   rle2cpu.check_if_more ; Check if more data to decompress
0065               *--------------------------------------------------------------
0066               *    Dump compressed bytes
0067               *--------------------------------------------------------------
0068               rle2cpu.dump_compressed:
0069 19D2 0997  56         srl   tmp3,9                ; Use control byte as counter
0070 19D4 0606  14         dec   tmp2                  ; Update RLE string length
0071               
0072 19D6 0649  14         dect  stack
0073 19D8 C645  30         mov   tmp1,*stack           ; Push tmp1
0074 19DA 0649  14         dect  stack
0075 19DC C646  30         mov   tmp2,*stack           ; Push tmp2
0076 19DE 0649  14         dect  stack
0077 19E0 C647  30         mov   tmp3,*stack           ; Push tmp3
0078               
0079 19E2 C187  18         mov   tmp3,tmp2             ; Set length for block fill
0080 19E4 D174  28         movb  *tmp0+,tmp1           ; Byte to fill (*tmp0+ is why "dec tmp2")
0081 19E6 0985  56         srl   tmp1,8                ; Right align
0082               
0083 19E8 06A0  32         bl    @xfilm                ; Block fill to destination
     19EA 09EC 
0084                                                   ; \ i  tmp0 = Target address
0085                                                   ; | i  tmp1 = Byte to fill
0086                                                   ; / i  tmp2 = Repeat count
0087               
0088 19EC C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0089 19EE C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0090 19F0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0091               
0092 19F2 A147  18         a     tmp3,tmp1             ; Adjust memory target after fill
0093               *--------------------------------------------------------------
0094               *    Check if more data to decompress
0095               *--------------------------------------------------------------
0096               rle2cpu.check_if_more:
0097 19F4 C186  18         mov   tmp2,tmp2             ; Length counter = 0 ?
0098 19F6 16DF  14         jne   rle2cpu.scan          ; Not yet, process next control byte
0099               *--------------------------------------------------------------
0100               *    Exit
0101               *--------------------------------------------------------------
0102               rle2cpu.exit:
0103 19F8 0460  28         b     @poprt                ; Return
     19FA 09E2 
**** **** ****     > runlib.asm
0198               
0200                       copy  "vdp_rle_decompress.asm"   ; VDP RLE decompression support
**** **** ****     > vdp_rle_decompress.asm
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
0025               ********|*****|*********************|**************************
0026 19FC C1BB  30 rle2v   mov   *r11+,tmp2            ; ROM/RAM source address
0027 19FE C13B  30         mov   *r11+,tmp0            ; VDP target address
0028 1A00 C1FB  30         mov   *r11+,tmp3            ; Length of RLE encoded data
0029 1A02 C80B  38         mov   r11,@waux1            ; Save return address
     1A04 833C 
0030 1A06 06A0  32 rle2vx  bl    @vdwa                 ; Setup VDP address from TMP0
     1A08 0A66 
0031 1A0A C106  18         mov   tmp2,tmp0             ; We can safely reuse TMP0 now
0032 1A0C D1B4  28 rle2v0  movb  *tmp0+,tmp2           ; Get control byte into TMP2
0033 1A0E 0607  14         dec   tmp3                  ; Update length
0034 1A10 1314  14         jeq   rle2vz                ; End of list
0035 1A12 0A16  56         sla   tmp2,1                ; Check bit 0 of control byte
0036 1A14 1808  14         joc   rle2v2                ; Yes, next byte is compressed
0037               *--------------------------------------------------------------
0038               *    Dump uncompressed bytes
0039               *--------------------------------------------------------------
0040 1A16 C820  54 rle2v1  mov   @rledat,@mcloop       ; Setup machine code (MOVB *TMP0+,*R15)
     1A18 1A40 
     1A1A 8320 
0041 1A1C 0996  56         srl   tmp2,9                ; Use control byte as counter
0042 1A1E 61C6  18         s     tmp2,tmp3             ; Update length
0043 1A20 06A0  32         bl    @mcloop               ; Write data to VDP
     1A22 8320 
0044 1A24 1008  14         jmp   rle2v3
0045               *--------------------------------------------------------------
0046               *    Dump compressed bytes
0047               *--------------------------------------------------------------
0048 1A26 C820  54 rle2v2  mov   @filzz,@mcloop        ; Setup machine code(MOVB TMP1,*R15)
     1A28 0A64 
     1A2A 8320 
0049 1A2C 0996  56         srl   tmp2,9                ; Use control byte as counter
0050 1A2E 0607  14         dec   tmp3                  ; Update length
0051 1A30 D174  28         movb  *tmp0+,tmp1           ; Byte to fill
0052 1A32 06A0  32         bl    @mcloop               ; Write data to VDP
     1A34 8320 
0053               *--------------------------------------------------------------
0054               *    Check if more data to decompress
0055               *--------------------------------------------------------------
0056 1A36 C1C7  18 rle2v3  mov   tmp3,tmp3             ; Length counter = 0 ?
0057 1A38 16E9  14         jne   rle2v0                ; Not yet, process data
0058               *--------------------------------------------------------------
0059               *    Exit
0060               *--------------------------------------------------------------
0061 1A3A C2E0  34 rle2vz  mov   @waux1,r11
     1A3C 833C 
0062 1A3E 045B  20         b     *r11                  ; Return
0063 1A40 D7F4     rledat  data  >d7f4                 ; MOVB *TMP0+,*R15
**** **** ****     > runlib.asm
0202               
0204                       copy  "rnd_support.asm"          ; Random number generator
**** **** ****     > rnd_support.asm
0001               * FILE......: rnd_support.asm
0002               * Purpose...: Random generators module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                     MISC FUNCTIONS
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * RND - Generate random number
0011               ***************************************************************
0012               *  BL   @RND
0013               *  DATA P0,P1
0014               *--------------------------------------------------------------
0015               *  P0 = Highest random number allowed
0016               *  P1 = Address of random seed
0017               *--------------------------------------------------------------
0018               *  BL   @RNDX
0019               *
0020               *  TMP0 = Highest random number allowed
0021               *  TMP3 = Address of random seed
0022               *--------------------------------------------------------------
0023               *  OUTPUT
0024               *  TMP0 = The generated random number
0025               ********|*****|*********************|**************************
0026 1A42 C13B  30 rnd     mov   *r11+,tmp0            ; Highest number allowed
0027 1A44 C1FB  30         mov   *r11+,tmp3            ; Get address of random seed
0028 1A46 04C5  14 rndx    clr   tmp1
0029 1A48 C197  26         mov   *tmp3,tmp2            ; Get random seed
0030 1A4A 1601  14         jne   rnd1
0031 1A4C 0586  14         inc   tmp2                  ; May not be zero
0032 1A4E 0916  56 rnd1    srl   tmp2,1
0033 1A50 1702  14         jnc   rnd2
0034 1A52 29A0  34         xor   @rnddat,tmp2
     1A54 1A5E 
0035 1A56 C5C6  30 rnd2    mov   tmp2,*tmp3            ; Store new random seed
0036 1A58 3D44  128         div   tmp0,tmp1
0037 1A5A C106  18         mov   tmp2,tmp0
0038 1A5C 045B  20         b     *r11                  ; Exit
0039 1A5E B400     rnddat  data  >0b400                ; The magic number
**** **** ****     > runlib.asm
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
0016               *  Backup scratchpad memory to destination range
0017               *  cpu.scrpad.tgt <--> cpu.scrpad.tgt + >ff.
0018               *
0019               *  Expects current workspace to be in scratchpad memory.
0020               ********|*****|*********************|**************************
0021               cpu.scrpad.backup:
0022 1A60 C800  38         mov   r0,@cpu.scrpad.tgt    ; Save @>8300 (r0)
     1A62 A000 
0023 1A64 C801  38         mov   r1,@cpu.scrpad.tgt+2  ; Save @>8302 (r1)
     1A66 A002 
0024 1A68 C802  38         mov   r2,@cpu.scrpad.tgt+4  ; Save @>8304 (r2)
     1A6A A004 
0025                       ;------------------------------------------------------
0026                       ; Prepare for copy loop
0027                       ;------------------------------------------------------
0028 1A6C 0200  20         li    r0,>8306              ; Scratpad source address
     1A6E 8306 
0029 1A70 0201  20         li    r1,cpu.scrpad.tgt+6   ; RAM target address
     1A72 A006 
0030 1A74 0202  20         li    r2,62                 ; Loop counter
     1A76 003E 
0031                       ;------------------------------------------------------
0032                       ; Copy memory range >8306 - >83ff
0033                       ;------------------------------------------------------
0034               cpu.scrpad.backup.copy:
0035 1A78 CC70  46         mov   *r0+,*r1+
0036 1A7A CC70  46         mov   *r0+,*r1+
0037 1A7C 0642  14         dect  r2
0038 1A7E 16FC  14         jne   cpu.scrpad.backup.copy
0039 1A80 C820  54         mov   @>83fe,@cpu.scrpad.tgt + >fe
     1A82 83FE 
     1A84 A0FE 
0040                                                   ; Copy last word
0041                       ;------------------------------------------------------
0042                       ; Restore register r0 - r2
0043                       ;------------------------------------------------------
0044 1A86 C020  34         mov   @cpu.scrpad.tgt,r0    ; Restore r0
     1A88 A000 
0045 1A8A C060  34         mov   @cpu.scrpad.tgt+2,r1  ; Restore r1
     1A8C A002 
0046 1A8E C0A0  34         mov   @cpu.scrpad.tgt+4,r2  ; Restore r2
     1A90 A004 
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050               cpu.scrpad.backup.exit:
0051 1A92 045B  20         b     *r11                  ; Return to caller
0052               
0053               
0054               ***************************************************************
0055               * cpu.scrpad.restore - Restore scratchpad memory from >2000
0056               ***************************************************************
0057               *  bl   @cpu.scrpad.restore
0058               *--------------------------------------------------------------
0059               *  Register usage
0060               *  r0-r2, but values restored before exit
0061               *--------------------------------------------------------------
0062               *  Restore scratchpad from memory area
0063               *  cpu.scrpad.tgt <--> cpu.scrpad.tgt + >ff.
0064               *  Current workspace can be outside scratchpad when called.
0065               ********|*****|*********************|**************************
0066               cpu.scrpad.restore:
0067                       ;------------------------------------------------------
0068                       ; Restore scratchpad >8300 - >8304
0069                       ;------------------------------------------------------
0070 1A94 C820  54         mov   @cpu.scrpad.tgt,@>8300
     1A96 A000 
     1A98 8300 
0071 1A9A C820  54         mov   @cpu.scrpad.tgt + 2,@>8302
     1A9C A002 
     1A9E 8302 
0072 1AA0 C820  54         mov   @cpu.scrpad.tgt + 4,@>8304
     1AA2 A004 
     1AA4 8304 
0073                       ;------------------------------------------------------
0074                       ; save current r0 - r2 (WS can be outside scratchpad!)
0075                       ;------------------------------------------------------
0076 1AA6 C800  38         mov   r0,@cpu.scrpad.tgt
     1AA8 A000 
0077 1AAA C801  38         mov   r1,@cpu.scrpad.tgt + 2
     1AAC A002 
0078 1AAE C802  38         mov   r2,@cpu.scrpad.tgt + 4
     1AB0 A004 
0079                       ;------------------------------------------------------
0080                       ; Prepare for copy loop, WS
0081                       ;------------------------------------------------------
0082 1AB2 0200  20         li    r0,cpu.scrpad.tgt + 6
     1AB4 A006 
0083 1AB6 0201  20         li    r1,>8306
     1AB8 8306 
0084 1ABA 0202  20         li    r2,62
     1ABC 003E 
0085                       ;------------------------------------------------------
0086                       ; Copy memory range @cpu.scrpad.tgt <-> @cpu.scrpad.tgt + >ff
0087                       ;------------------------------------------------------
0088               cpu.scrpad.restore.copy:
0089 1ABE CC70  46         mov   *r0+,*r1+
0090 1AC0 CC70  46         mov   *r0+,*r1+
0091 1AC2 0642  14         dect  r2
0092 1AC4 16FC  14         jne   cpu.scrpad.restore.copy
0093 1AC6 C820  54         mov   @cpu.scrpad.tgt + > fe,@>83fe
     1AC8 A0FE 
     1ACA 83FE 
0094                                                   ; Copy last word
0095                       ;------------------------------------------------------
0096                       ; Restore register r0 - r2
0097                       ;------------------------------------------------------
0098 1ACC C020  34         mov   @cpu.scrpad.tgt,r0
     1ACE A000 
0099 1AD0 C060  34         mov   @cpu.scrpad.tgt + 2,r1
     1AD2 A002 
0100 1AD4 C0A0  34         mov   @cpu.scrpad.tgt + 4,r2
     1AD6 A004 
0101                       ;------------------------------------------------------
0102                       ; Exit
0103                       ;------------------------------------------------------
0104               cpu.scrpad.restore.exit:
0105 1AD8 045B  20         b     *r11                  ; Return to caller
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
0025 1ADA C17B  30         mov   *r11+,tmp1            ; tmp1 = Memory target address
0026                       ;------------------------------------------------------
0027                       ; Copy scratchpad memory to destination
0028                       ;------------------------------------------------------
0029               xcpu.scrpad.pgout:
0030 1ADC 0204  20         li    tmp0,>8300            ; tmp0 = Memory source address
     1ADE 8300 
0031 1AE0 C1C5  18         mov   tmp1,tmp3             ; tmp3 = copy of tmp1
0032 1AE2 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     1AE4 0080 
0033                       ;------------------------------------------------------
0034                       ; Copy memory
0035                       ;------------------------------------------------------
0036 1AE6 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0037 1AE8 0606  14         dec   tmp2
0038 1AEA 16FD  14         jne   -!                    ; Loop until done
0039                       ;------------------------------------------------------
0040                       ; Switch to new workspace
0041                       ;------------------------------------------------------
0042 1AEC C347  18         mov   tmp3,r13              ; R13=WP   (pop tmp1 from stack)
0043 1AEE 020E  20         li    r14,cpu.scrpad.pgout.after.rtwp
     1AF0 1AF6 
0044                                                   ; R14=PC
0045 1AF2 04CF  14         clr   r15                   ; R15=STATUS
0046                       ;------------------------------------------------------
0047                       ; If we get here, WS was copied to specified
0048                       ; destination.  Also contents of r13,r14,r15
0049                       ; are about to be overwritten by rtwp instruction.
0050                       ;------------------------------------------------------
0051 1AF4 0380  18         rtwp                        ; Activate copied workspace
0052                                                   ; in non-scratchpad memory!
0053               
0054               cpu.scrpad.pgout.after.rtwp:
0055 1AF6 0460  28         b     @cpu.scrpad.restore   ; Restore scratchpad memory from @>2000
     1AF8 1A94 
0056               
0057                       ;------------------------------------------------------
0058                       ; Exit
0059                       ;------------------------------------------------------
0060               cpu.scrpad.pgout.$$:
0061 1AFA 045B  20         b     *r11                  ; Return to caller
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
0078 1AFC C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
0079                       ;------------------------------------------------------
0080                       ; Copy scratchpad memory to destination
0081                       ;------------------------------------------------------
0082               xcpu.scrpad.pgin:
0083 1AFE 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
     1B00 8300 
0084 1B02 0206  20         li    tmp2,128              ; tmp2 = Words to copy
     1B04 0080 
0085                       ;------------------------------------------------------
0086                       ; Copy memory
0087                       ;------------------------------------------------------
0088 1B06 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word
0089 1B08 0606  14         dec   tmp2
0090 1B0A 16FD  14         jne   -!                    ; Loop until done
0091                       ;------------------------------------------------------
0092                       ; Switch workspace to scratchpad memory
0093                       ;------------------------------------------------------
0094 1B0C 02E0  18         lwpi  >8300                 ; Activate copied workspace
     1B0E 8300 
0095                       ;------------------------------------------------------
0096                       ; Exit
0097                       ;------------------------------------------------------
0098               cpu.scrpad.pgin.$$:
0099 1B10 045B  20         b     *r11                  ; Return to caller
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
0037               dsrlnk.dstype equ   dsrlnk.dsrlws + 10
0038                                                   ; dstype is address of R5 of DSRLNK ws
0039      8322     dsrlnk.sav8a  equ   >8322           ; Scratchpad @>8322. Contains >08 or >0a
0040               ********|*****|*********************|**************************
0041 1B12 A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0042 1B14 1B16             data  dsrlnk.init           ; entry point
0043                       ;------------------------------------------------------
0044                       ; DSRLNK entry point
0045                       ;------------------------------------------------------
0046               dsrlnk.init:
0047 1B16 C17E  30         mov   *r14+,r5              ; get pgm type for link
0048 1B18 C805  38         mov   r5,@dsrlnk.sav8a      ; save data following blwp @dsrlnk (8 or >a)
     1B1A 8322 
0049 1B1C 53E0  34         szcb  @hb$20,r15            ; reset equal bit
     1B1E 07F6 
0050 1B20 C020  34         mov   @>8356,r0             ; get ptr to pab
     1B22 8356 
0051 1B24 C240  18         mov   r0,r9                 ; save ptr
0052                       ;------------------------------------------------------
0053                       ; Fetch file descriptor length from PAB
0054                       ;------------------------------------------------------
0055 1B26 0229  22         ai    r9,>fff8              ; adjust r9 to addr PAB flag->(pabaddr+9)-8
     1B28 FFF8 
0056               
0057                       ;---------------------------; Inline VSBR start
0058 1B2A 06C0  14         swpb  r0                    ;
0059 1B2C D800  38         movb  r0,@vdpa              ; send low byte
     1B2E 8C02 
0060 1B30 06C0  14         swpb  r0                    ;
0061 1B32 D800  38         movb  r0,@vdpa              ; send high byte
     1B34 8C02 
0062 1B36 D0E0  34         movb  @vdpr,r3              ; read byte from VDP ram
     1B38 8800 
0063                       ;---------------------------; Inline VSBR end
0064 1B3A 0983  56         srl   r3,8                  ; Move to low byte
0065               
0066                       ;------------------------------------------------------
0067                       ; Fetch file descriptor device name from PAB
0068                       ;------------------------------------------------------
0069 1B3C 0704  14         seto  r4                    ; init counter
0070 1B3E 0202  20         li    r2,dsrlnk.namsto      ; point to 8-byte CPU buffer
     1B40 A420 
0071 1B42 0580  14 !       inc   r0                    ; point to next char of name
0072 1B44 0584  14         inc   r4                    ; incr char counter
0073 1B46 0284  22         ci    r4,>0007              ; see if length more than 7 chars
     1B48 0007 
0074 1B4A 1565  14         jgt   dsrlnk.error.devicename_invalid
0075                                                   ; yes, error
0076 1B4C 80C4  18         c     r4,r3                 ; end of name?
0077 1B4E 130C  14         jeq   dsrlnk.device_name.get_length
0078                                                   ; yes
0079               
0080                       ;---------------------------; Inline VSBR start
0081 1B50 06C0  14         swpb  r0                    ;
0082 1B52 D800  38         movb  r0,@vdpa              ; send low byte
     1B54 8C02 
0083 1B56 06C0  14         swpb  r0                    ;
0084 1B58 D800  38         movb  r0,@vdpa              ; send high byte
     1B5A 8C02 
0085 1B5C D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     1B5E 8800 
0086                       ;---------------------------; Inline VSBR end
0087               
0088                       ;------------------------------------------------------
0089                       ; Look for end of device name, for example "DSK1."
0090                       ;------------------------------------------------------
0091 1B60 DC81  32         movb  r1,*r2+               ; move into buffer
0092 1B62 9801  38         cb    r1,@dsrlnk.period     ; is character a '.'
     1B64 1C26 
0093 1B66 16ED  14         jne   -!                    ; no, loop next char
0094                       ;------------------------------------------------------
0095                       ; Determine device name length
0096                       ;------------------------------------------------------
0097               dsrlnk.device_name.get_length:
0098 1B68 C104  18         mov   r4,r4                 ; Check if length = 0
0099 1B6A 1355  14         jeq   dsrlnk.error.devicename_invalid
0100                                                   ; yes, error
0101 1B6C 04E0  34         clr   @>83d0
     1B6E 83D0 
0102 1B70 C804  38         mov   r4,@>8354             ; save name length for search
     1B72 8354 
0103 1B74 0584  14         inc   r4                    ; adjust for dot
0104 1B76 A804  38         a     r4,@>8356             ; point to position after name
     1B78 8356 
0105                       ;------------------------------------------------------
0106                       ; Prepare for DSR scan >1000 - >1f00
0107                       ;------------------------------------------------------
0108               dsrlnk.dsrscan.start:
0109 1B7A 02E0  18         lwpi  >83e0                 ; Use GPL WS
     1B7C 83E0 
0110 1B7E 04C1  14         clr   r1                    ; version found of dsr
0111 1B80 020C  20         li    r12,>0f00             ; init cru addr
     1B82 0F00 
0112                       ;------------------------------------------------------
0113                       ; Turn off ROM on current card
0114                       ;------------------------------------------------------
0115               dsrlnk.dsrscan.cardoff:
0116 1B84 C30C  18         mov   r12,r12               ; anything to turn off?
0117 1B86 1301  14         jeq   dsrlnk.dsrscan.cardloop
0118                                                   ; no, loop over cards
0119 1B88 1E00  20         sbz   0                     ; yes, turn off
0120                       ;------------------------------------------------------
0121                       ; Loop over cards and look if DSR present
0122                       ;------------------------------------------------------
0123               dsrlnk.dsrscan.cardloop:
0124 1B8A 022C  22         ai    r12,>0100             ; next rom to turn on
     1B8C 0100 
0125 1B8E 04E0  34         clr   @>83d0                ; clear in case we are done
     1B90 83D0 
0126 1B92 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     1B94 2000 
0127 1B96 133D  14         jeq   dsrlnk.error.nodsr_found
0128                                                   ; yes, no matching DSR found
0129 1B98 C80C  38         mov   r12,@>83d0            ; save addr of next cru
     1B9A 83D0 
0130                       ;------------------------------------------------------
0131                       ; Look at card ROM (@>4000 eq 'AA' ?)
0132                       ;------------------------------------------------------
0133 1B9C 1D00  20         sbo   0                     ; turn on rom
0134 1B9E 0202  20         li    r2,>4000              ; start at beginning of rom
     1BA0 4000 
0135 1BA2 9812  46         cb    *r2,@dsrlnk.$aa00     ; check for a valid DSR header
     1BA4 1C22 
0136 1BA6 16EE  14         jne   dsrlnk.dsrscan.cardoff
0137                                                   ; no rom found on card
0138                       ;------------------------------------------------------
0139                       ; Valid DSR ROM found. Now loop over chain/subprograms
0140                       ;------------------------------------------------------
0141                       ; dstype is the address of R5 of the DSRLNK workspace,
0142                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0143                       ; is stored before the DSR ROM is searched.
0144                       ;------------------------------------------------------
0145                       a     @dsrlnk.dstype,r2     ; go to first pointer (byte 8 or 10)
0146 1BA8 1005  14         jmp   dsrlnk.dsrscan.getentry
0147                       ;------------------------------------------------------
0148                       ; Next DSR entry
0149                       ;------------------------------------------------------
0150               dsrlnk.dsrscan.nextentry:
0151 1BAA C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     1BAC 83D2 
0152                                                   ; subprogram
0153               
0154 1BAE 1D00  20         sbo   0                     ; turn rom back on
0155                       ;------------------------------------------------------
0156                       ; Get DSR entry
0157                       ;------------------------------------------------------
0158               dsrlnk.dsrscan.getentry:
0159 1BB0 C092  26         mov   *r2,r2                ; is addr a zero? (end of chain?)
0160 1BB2 13E8  14         jeq   dsrlnk.dsrscan.cardoff
0161                                                   ; yes, no more DSRs or programs to check
0162 1BB4 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     1BB6 83D2 
0163                                                   ; subprogram
0164               
0165 1BB8 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0166                                                   ; DSR/subprogram code
0167               
0168 1BBA C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0169                                                   ; offset 4 (DSR/subprogram name)
0170                       ;------------------------------------------------------
0171                       ; Check file descriptor in DSR
0172                       ;------------------------------------------------------
0173 1BBC 04C5  14         clr   r5                    ; Remove any old stuff
0174 1BBE D160  34         movb  @>8355,r5             ; get length as counter
     1BC0 8355 
0175 1BC2 130D  14         jeq   dsrlnk.dsrscan.call_dsr
0176                                                   ; if zero, do not further check, call DSR
0177                                                   ; program
0178               
0179 1BC4 9C85  32         cb    r5,*r2+               ; see if length matches
0180 1BC6 16F3  14         jne   dsrlnk.dsrscan.nextentry
0181                                                   ; no, length does not match. Go process next
0182                                                   ; DSR entry
0183               
0184 1BC8 0985  56         srl   r5,8                  ; yes, move to low byte
0185 1BCA 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     1BCC A420 
0186 1BCE 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0187                                                   ; DSR ROM
0188 1BD0 16EE  14         jne   dsrlnk.dsrscan.nextentry
0189                                                   ; try next DSR entry if no match
0190 1BD2 0605  14         dec   r5                    ; loop until full length checked
0191 1BD4 16FE  14         jne   -!
0192                       ;------------------------------------------------------
0193                       ; Device name/Subprogram match
0194                       ;------------------------------------------------------
0195               dsrlnk.dsrscan.match:
0196 1BD6 C802  38         mov   r2,@>83d2             ; DSR entry addr must be saved at @>83d2
     1BD8 83D2 
0197               
0198                       ;------------------------------------------------------
0199                       ; Call DSR program in device card
0200                       ;------------------------------------------------------
0201               dsrlnk.dsrscan.call_dsr:
0202 1BDA 0581  14         inc   r1                    ; next version found
0203 1BDC 0699  24         bl    *r9                   ; go run routine
0204                       ;
0205                       ; Depending on IO result the DSR in card ROM does RET
0206                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0207                       ;
0208 1BDE 10E7  14         jmp   dsrlnk.dsrscan.nextentry
0209                                                   ; (1) error return
0210 1BE0 1E00  20         sbz   0                     ; (2) turn off rom if good return
0211 1BE2 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     1BE4 A400 
0212 1BE6 C009  18         mov   r9,r0                 ; point to flag in pab
0213 1BE8 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     1BEA 8322 
0214                                                   ; (8 or >a)
0215 1BEC 0281  22         ci    r1,8                  ; was it 8?
     1BEE 0008 
0216 1BF0 1305  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0217 1BF2 D060  34         movb  @>8350,r1             ; no, we have a data >a.
     1BF4 8350 
0218                                                   ; Get error byte from @>8350
0219 1BF6 100A  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0220               
0221                       ;------------------------------------------------------
0222                       ; Read VDP PAB byte 1 after DSR call completed (status)
0223                       ;------------------------------------------------------
0224               dsrlnk.dsrscan.dsr.8:
0225                       ;---------------------------; Inline VSBR start
0226 1BF8 06C0  14         swpb  r0                    ;
0227 1BFA D800  38         movb  r0,@vdpa              ; send low byte
     1BFC 8C02 
0228 1BFE 06C0  14         swpb  r0                    ;
0229 1C00 D800  38         movb  r0,@vdpa              ; send high byte
     1C02 8C02 
0230 1C04 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     1C06 8800 
0231                       ;---------------------------; Inline VSBR end
0232               
0233                       ;------------------------------------------------------
0234                       ; Return DSR error to caller
0235                       ;------------------------------------------------------
0236               dsrlnk.dsrscan.dsr.a:
0237 1C08 09D1  56         srl   r1,13                 ; just keep error bits
0238 1C0A 1606  14         jne   dsrlnk.error.io_error
0239                                                   ; handle IO error
0240 1C0C 0380  18         rtwp                        ; Return from DSR workspace to caller
0241                                                   ; workspace
0242               
0243                       ;------------------------------------------------------
0244                       ; IO-error handler
0245                       ;------------------------------------------------------
0246               dsrlnk.error.nodsr_found:
0247 1C0E 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     1C10 A400 
0248               dsrlnk.error.devicename_invalid:
0249 1C12 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0250               dsrlnk.error.io_error:
0251 1C14 06C1  14         swpb  r1                    ; put error in hi byte
0252 1C16 D741  30         movb  r1,*r13               ; store error flags in callers r0
0253 1C18 F3E0  34         socb  @hb$20,r15            ; set equal bit to indicate error
     1C1A 07F6 
0254 1C1C 0380  18         rtwp                        ; Return from DSR workspace to caller
0255                                                   ; workspace
0256               
0257               ********************************************************************************
0258               
0259 1C1E AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0260 1C20 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0261                                                   ; a @blwp @dsrlnk
0262 1C22 ....     dsrlnk.period     text  '.'         ; For finding end of device name
0263               
0264                       even
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
0043 1C24 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0044               *--------------------------------------------------------------
0045               * Initialisation
0046               *--------------------------------------------------------------
0047               xfile.open:
0048 1C26 C04B  18         mov   r11,r1                ; Save return address
0049 1C28 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     1C2A A428 
0050 1C2C C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0051 1C2E 04C5  14         clr   tmp1                  ; io.op.open
0052 1C30 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     1C32 0A7C 
0053               file.open_init:
0054 1C34 0220  22         ai    r0,9                  ; Move to file descriptor length
     1C36 0009 
0055 1C38 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     1C3A 8356 
0056               *--------------------------------------------------------------
0057               * Main
0058               *--------------------------------------------------------------
0059               file.open_main:
0060 1C3C 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     1C3E 1B12 
0061 1C40 0008             data  8                     ; Level 2 IO call
0062               *--------------------------------------------------------------
0063               * Exit
0064               *--------------------------------------------------------------
0065               file.open_exit:
0066 1C42 102B  14         jmp   file.record.pab.details
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
0090 1C44 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0091               *--------------------------------------------------------------
0092               * Initialisation
0093               *--------------------------------------------------------------
0094               xfile.close:
0095 1C46 C04B  18         mov   r11,r1                ; Save return address
0096 1C48 C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     1C4A A428 
0097 1C4C C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0098 1C4E 0205  20         li    tmp1,io.op.close      ; io.op.close
     1C50 0001 
0099 1C52 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     1C54 0A7C 
0100               file.close_init:
0101 1C56 0220  22         ai    r0,9                  ; Move to file descriptor length
     1C58 0009 
0102 1C5A C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     1C5C 8356 
0103               *--------------------------------------------------------------
0104               * Main
0105               *--------------------------------------------------------------
0106               file.close_main:
0107 1C5E 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     1C60 1B12 
0108 1C62 0008             data  8                     ;
0109               *--------------------------------------------------------------
0110               * Exit
0111               *--------------------------------------------------------------
0112               file.close_exit:
0113 1C64 101A  14         jmp   file.record.pab.details
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
0139 1C66 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0140               *--------------------------------------------------------------
0141               * Initialisation
0142               *--------------------------------------------------------------
0143               xfile.record.read:
0144 1C68 C04B  18         mov   r11,r1                ; Save return address
0145 1C6A C800  38         mov   r0,@file.pab.ptr      ; Backup of pointer to current VDP PAB
     1C6C A428 
0146 1C6E C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0147 1C70 0205  20         li    tmp1,io.op.read       ; io.op.read
     1C72 0002 
0148 1C74 06A0  32         bl    @xvputb               ; Write file opcode to VDP
     1C76 0A7C 
0149               file.record.read_init:
0150 1C78 0220  22         ai    r0,9                  ; Move to file descriptor length
     1C7A 0009 
0151 1C7C C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     1C7E 8356 
0152               *--------------------------------------------------------------
0153               * Main
0154               *--------------------------------------------------------------
0155               file.record.read_main:
0156 1C80 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     1C82 1B12 
0157 1C84 0008             data  8                     ;
0158               *--------------------------------------------------------------
0159               * Exit
0160               *--------------------------------------------------------------
0161               file.record.read_exit:
0162 1C86 1009  14         jmp   file.record.pab.details
0163                                                   ; Get status and return to caller
0164                                                   ; Status register bits are unaffected
0165               
0166               
0167               
0168               
0169               file.record.write:
0170 1C88 1000  14         nop
0171               
0172               
0173               file.record.seek:
0174 1C8A 1000  14         nop
0175               
0176               
0177               file.image.load:
0178 1C8C 1000  14         nop
0179               
0180               
0181               file.image.save:
0182 1C8E 1000  14         nop
0183               
0184               
0185               file.delete:
0186 1C90 1000  14         nop
0187               
0188               
0189               file.rename:
0190 1C92 1000  14         nop
0191               
0192               
0193               file.status:
0194 1C94 1000  14         nop
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
0211 1C96 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0212                                                   ; Upon DSRLNK return status register EQ bit
0213                                                   ; 1 = No file error
0214                                                   ; 0 = File error occured
0215               *--------------------------------------------------------------
0216               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0217               *--------------------------------------------------------------
0218 1C98 C120  34         mov   @file.pab.ptr,tmp0    ; Get VDP address of current PAB
     1C9A A428 
0219 1C9C 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     1C9E 0005 
0220 1CA0 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     1CA2 0A94 
0221 1CA4 C144  18         mov   tmp0,tmp1             ; Move to destination
0222               *--------------------------------------------------------------
0223               * Get PAB byte 1 from VDP ram into tmp0 (status)
0224               *--------------------------------------------------------------
0225 1CA6 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
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
0249 1CA8 0451  20         b     *r1                   ; Return to caller
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
0020 1CAA 0300  24 tmgr    limi  0                     ; No interrupt processing
     1CAC 0000 
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 1CAE D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     1CB0 8802 
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 1CB2 2360  38         coc   @wbit2,r13            ; C flag on ?
     1CB4 07F6 
0029 1CB6 1604  14         jne   tmgr1a                ; No, so move on
0030 1CB8 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     1CBA 07E2 
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 1CBC 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     1CBE 07FA 
0035 1CC0 1318  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0040 1CC2 20A0  38         coc   @wbit3,config         ; Speech player on ?
     1CC4 07F4 
0041 1CC6 1604  14         jne   tmgr2
0042 1CC8 06A0  32         bl    @sppla1               ; Run speech player
     1CCA 12F8 
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 1CCC 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     1CCE 07EA 
0048 1CD0 1307  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 1CD2 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     1CD4 07E8 
0050 1CD6 1604  14         jne   tmgr3                 ; No, skip to user hook
0051 1CD8 0460  28         b     @kthread              ; Run kernel thread
     1CDA 1D56 
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 1CDC 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     1CDE 07EE 
0056 1CE0 13E8  14         jeq   tmgr1
0057 1CE2 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     1CE4 07EC 
0058 1CE6 16E5  14         jne   tmgr1
0059 1CE8 C120  34         mov   @wtiusr,tmp0
     1CEA 832E 
0060 1CEC 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 1CEE 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     1CF0 1D54 
0065 1CF2 C10A  18         mov   r10,tmp0
0066 1CF4 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     1CF6 00FF 
0067 1CF8 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     1CFA 07F6 
0068 1CFC 1305  14         jeq   tmgr5
0069 1CFE 0284  22         ci    tmp0,60               ; 1 second reached ?
     1D00 003C 
0070 1D02 1004  14         jmp   tmgr6
0071 1D04 0284  22 tmgr5   ci    tmp0,50
     1D06 0032 
0072 1D08 1103  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 1D0A 1003  14         jmp   tmgr8
0074 1D0C 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 1D0E C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     1D10 832C 
0079 1D12 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     1D14 FF00 
0080 1D16 C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 1D18 1318  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 1D1A 05C4  14         inct  tmp0                  ; Second word of slot data
0086 1D1C 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 1D1E C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 1D20 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     1D22 830C 
     1D24 830D 
0089 1D26 160A  14         jne   tmgr10                ; No, get next slot
0090 1D28 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     1D2A FF00 
0091 1D2C C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 1D2E C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     1D30 8330 
0096 1D32 0697  24         bl    *tmp3                 ; Call routine in slot
0097 1D34 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     1D36 8330 
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 1D38 058A  14 tmgr10  inc   r10                   ; Next slot
0102 1D3A 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     1D3C 8315 
     1D3E 8314 
0103 1D40 1506  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 1D42 05C4  14         inct  tmp0                  ; Offset for next slot
0105 1D44 10EA  14         jmp   tmgr9                 ; Process next slot
0106 1D46 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 1D48 10F9  14         jmp   tmgr10                ; Process next slot
0108 1D4A 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     1D4C FF00 
0109 1D4E 10B1  14         jmp   tmgr1
0110 1D50 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
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
0015 1D52 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     1D54 07EA 
0016               *--------------------------------------------------------------
0017               * Run sound player
0018               *--------------------------------------------------------------
0022 1D56 20A0  38         coc   @wbit13,config        ; Sound player on ?
     1D58 07E0 
0023 1D5A 1604  14         jne   kthread_kb
0024 1D5C 06A0  32         bl    @sdpla1               ; Run sound player
     1D5E 1208 
0026               *--------------------------------------------------------------
0027               * Scan virtual keyboard
0028               *--------------------------------------------------------------
0029               kthread_kb
0033 1D60 06A0  32         bl    @virtkb               ; Scan virtual keyboard
     1D62 135A 
0035               *--------------------------------------------------------------
0036               * Scan real keyboard
0037               *--------------------------------------------------------------
0041 1D64 06A0  32         bl    @realkb               ; Scan full keyboard
     1D66 144A 
0043               *--------------------------------------------------------------
0044               kthread_exit
0045 1D68 0460  28         b     @tmgr3                ; Exit
     1D6A 1CE0 
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
0017 1D6C C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     1D6E 832E 
0018 1D70 E0A0  34         soc   @wbit7,config         ; Enable user hook
     1D72 07EC 
0019 1D74 045B  20 mkhoo1  b     *r11                  ; Return
0020      1CB2     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 1D76 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     1D78 832E 
0029 1D7A 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     1D7C FEFF 
0030 1D7E 045B  20         b     *r11                  ; Return
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
0017 1D80 C13B  30 mkslot  mov   *r11+,tmp0
0018 1D82 C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 1D84 C184  18         mov   tmp0,tmp2
0023 1D86 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 1D88 A1A0  34         a     @wtitab,tmp2          ; Add table base
     1D8A 832C 
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 1D8C CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 1D8E 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 1D90 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 1D92 881B  46         c     *r11,@w$ffff          ; End of list ?
     1D94 07FC 
0035 1D96 1303  14         jeq   mkslo1                ; Yes, exit
0036 1D98 10F5  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 1D9A 05CB  14 mkslo1  inct  r11
0041 1D9C 045B  20         b     *r11                  ; Exit
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
0052 1D9E C13B  30 clslot  mov   *r11+,tmp0
0053 1DA0 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 1DA2 A120  34         a     @wtitab,tmp0          ; Add table base
     1DA4 832C 
0055 1DA6 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 1DA8 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 1DAA 045B  20         b     *r11                  ; Exit
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
0255 1DAC 04E0  34 runlib  clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     1DAE 8302 
0257               *--------------------------------------------------------------
0258               * Alternative entry point
0259               *--------------------------------------------------------------
0260 1DB0 0300  24 runli1  limi  0                     ; Turn off interrupts
     1DB2 0000 
0261 1DB4 02E0  18         lwpi  ws1                   ; Activate workspace 1
     1DB6 8300 
0262 1DB8 C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     1DBA 83C0 
0263               *--------------------------------------------------------------
0264               * Clear scratch-pad memory from R4 upwards
0265               *--------------------------------------------------------------
0266 1DBC 0202  20 runli2  li    r2,>8308
     1DBE 8308 
0267 1DC0 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0268 1DC2 0282  22         ci    r2,>8400
     1DC4 8400 
0269 1DC6 16FE  14         jne   runli3
0270               *--------------------------------------------------------------
0271               * Exit to TI-99/4A title screen ?
0272               *--------------------------------------------------------------
0273 1DC8 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     1DCA FFFF 
0274 1DCC 1604  14         jne   runli4                ; No, continue
0275 1DCE 0420  54         blwp  @0                    ; Yes, bye bye
     1DD0 0000 
0276               *--------------------------------------------------------------
0277               * Determine if VDP is PAL or NTSC
0278               *--------------------------------------------------------------
0279 1DD2 C803  38 runli4  mov   r3,@waux1             ; Store random seed
     1DD4 833C 
0280 1DD6 04C1  14         clr   r1                    ; Reset counter
0281 1DD8 0202  20         li    r2,10                 ; We test 10 times
     1DDA 000A 
0282 1DDC C0E0  34 runli5  mov   @vdps,r3
     1DDE 8802 
0283 1DE0 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     1DE2 07FA 
0284 1DE4 1304  14         jeq   runli6
0285 1DE6 0581  14         inc   r1                    ; Increase counter
0286 1DE8 10FB  14         jmp   runli5
0287 1DEA 0602  14 runli6  dec   r2                    ; Next test
0288 1DEC 16F9  14         jne   runli5
0289 1DEE 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     1DF0 1250 
0290 1DF2 1204  14         jle   runli7                ; No, so it must be NTSC
0291 1DF4 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     1DF6 07F6 
0292               *--------------------------------------------------------------
0293               * Copy machine code to scratchpad (prepare tight loop)
0294               *--------------------------------------------------------------
0295 1DF8 0201  20 runli7  li    r1,mccode             ; Machinecode to patch
     1DFA 09D0 
0296 1DFC 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     1DFE 8322 
0297 1E00 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0298 1E02 CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0299 1E04 CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0300               *--------------------------------------------------------------
0301               * Initialize registers, memory, ...
0302               *--------------------------------------------------------------
0303 1E06 04C1  14 runli9  clr   r1
0304 1E08 04C2  14         clr   r2
0305 1E0A 04C3  14         clr   r3
0306 1E0C 0209  20         li    stack,>8400           ; Set stack
     1E0E 8400 
0307 1E10 020F  20         li    r15,vdpw              ; Set VDP write address
     1E12 8C00 
0309 1E14 06A0  32         bl    @mute                 ; Mute sound generators
     1E16 11CC 
0311               *--------------------------------------------------------------
0312               * Setup video memory
0313               *--------------------------------------------------------------
0320 1E18 06A0  32         bl    @filv                 ; Clear 16K VDP memory
     1E1A 0A3E 
0321 1E1C 0000             data  >0000,>00,>3fff
     1E1E 0000 
     1E20 3FFF 
0323 1E22 06A0  32 runlia  bl    @filv
     1E24 0A3E 
0324 1E26 0FC0             data  pctadr,spfclr,16      ; Load color table
     1E28 00F4 
     1E2A 0010 
0325               *--------------------------------------------------------------
0326               * Check if there is a F18A present
0327               *--------------------------------------------------------------
0331 1E2C 06A0  32         bl    @f18unl               ; Unlock the F18A
     1E2E 0F26 
0332 1E30 06A0  32         bl    @f18chk               ; Check if F18A is there
     1E32 0F40 
0333 1E34 06A0  32         bl    @f18lck               ; Lock the F18A again
     1E36 0F36 
0335               *--------------------------------------------------------------
0336               * Check if there is a speech synthesizer attached
0337               *--------------------------------------------------------------
0341 1E38 06A0  32         bl    @spconn
     1E3A 12AE 
0343               *--------------------------------------------------------------
0344               * Load video mode table & font
0345               *--------------------------------------------------------------
0346 1E3C 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     1E3E 0AA8 
0347 1E40 09C6             data  spvmod                ; Equate selected video mode table
0348 1E42 0204  20         li    tmp0,spfont           ; Get font option
     1E44 000C 
0349 1E46 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0350 1E48 1306  14         jeq   runlid                ; Yes, skip it
0351 1E4A 06A0  32         bl    @ldfnt
     1E4C 0B10 
0352 1E4E 1100             data  fntadr,spfont         ; Load specified font
     1E50 000C 
0353               *--------------------------------------------------------------
0354               * Did a system crash occur before runlib was called?
0355               *--------------------------------------------------------------
0356 1E52 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     1E54 4A4A 
0357 1E56 1604  14         jne   runlie                ; No, continue
0358 1E58 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     1E5A 0860 
0359               *--------------------------------------------------------------
0360               * Branch to main program
0361               *--------------------------------------------------------------
0362 1E5C 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     1E5E 0040 
0363 1E60 0460  28         b     @main                 ; Give control to main program
     1E62 1E68 
**** **** ****     > tivi_b1.asm.32332
0017               
0018               *--------------------------------------------------------------
0019               * Video mode configuration
0020               *--------------------------------------------------------------
0021      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0022      0004     spfbck  equ   >04                   ; Screen background color.
0023      09C6     spvmod  equ   tx8030                ; Video mode.   See VIDTAB for details.
0024      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0025      0050     colrow  equ   80                    ; Columns per row
0026      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0027      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0028      1800     sprpdt  equ   >1800                 ; VDP sprite pattern table
0029      2000     sprsat  equ   >2000                 ; VDP sprite attribute table
0030               
0031 1E64 0460  28 main    b    @main.tivi
     1E66 6110 
0032               
0033               
0034                       aorg  >6000
0035                       save  >6000,>7fff           ; Save bank 1
0036                       copy  "header.asm"
**** **** ****     > header.asm
0001               ***************************************************************
0002               *                          TiVi Editor
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2020 // Filip van Vooren
0008               ***************************************************************
0009               * File: tivi.asm                    ; Version 200224-32332
0010               *--------------------------------------------------------------
0011               * TiVi memory layout.
0012               * See file "modules/memory.asm" for further details.
0013               *
0014               * Mem range   Bytes    Hex    Purpose
0015               * =========   =====    ===    ==================================
0016               * 2000-3fff   8192     no     TiVi program code
0017               * 6000-7fff   8192     no     Spectra2 library program code (cartridge space)
0018               * a000-afff   4096     no     Scratchpad/GPL backup, TiVi structures
0019               * b000-bfff   4096     no     Command buffer
0020               * c000-cfff   4096     yes    Main index
0021               * d000-dfff   4096     yes    Shadow SAMS pages index
0022               * e000-efff   4096     yes    Editor buffer 4k
0023               * f000-ffff   4096     yes    Editor buffer 4k
0024               *
0025               * TiVi VDP layout
0026               *
0027               * Mem range   Bytes    Hex    Purpose
0028               * =========   =====   ====    =================================
0029               * 0000-095f    2400   >0960   PNT - Pattern Name Table
0030               * 0960-09af      80   >0050   File record buffer (DIS/VAR 80)
0031               * 0fc0                        PCT - Pattern Color Table
0032               * 1000                        PDT - Pattern Descriptor Table
0033               * 1800                        SPT - Sprite Pattern Table
0034               * 2000                        SAT - Sprite Attribute List
0035               *--------------------------------------------------------------
0036               * Skip unused spectra2 code modules for reduced code size
0037               *--------------------------------------------------------------
0038      0001     skip_grom_cpu_copy        equ  1    ; Skip GROM to CPU copy functions
0039      0001     skip_grom_vram_copy       equ  1    ; Skip GROM to VDP vram copy functions
0040      0001     skip_vdp_vchar            equ  1    ; Skip vchar, xvchar
0041      0001     skip_vdp_boxes            equ  1    ; Skip filbox, putbox
0042      0001     skip_vdp_bitmap           equ  1    ; Skip bitmap functions
0043      0001     skip_vdp_viewport         equ  1    ; Skip viewport functions
0044      0001     skip_cpu_rle_compress     equ  1    ; Skip CPU RLE compression
0045      0001     skip_cpu_rle_decompress   equ  1    ; Skip CPU RLE decompression
0046      0001     skip_vdp_rle_decompress   equ  1    ; Skip VDP RLE decompression
0047      0001     skip_vdp_px2yx_calc       equ  1    ; Skip pixel to YX calculation
0048      0001     skip_sound_player         equ  1    ; Skip inclusion of sound player code
0049      0001     skip_speech_detection     equ  1    ; Skip speech synthesizer detection
0050      0001     skip_speech_player        equ  1    ; Skip inclusion of speech player code
0051      0001     skip_virtual_keyboard     equ  1    ; Skip virtual keyboard scan
0052      0001     skip_random_generator     equ  1    ; Skip random functions
0053      0001     skip_cpu_crc16            equ  1    ; Skip CPU memory CRC-16 calculation
0054               *--------------------------------------------------------------
0055               * SPECTRA2 / TiVi startup options
0056               *--------------------------------------------------------------
0057      0001     debug                    equ  1     ; Turn on spectra2 debugging
0058      0001     startup_backup_scrpad    equ  1     ; Backup scratchpad @>8300:>83ff to @>2000
0059      0001     startup_keep_vdpmemory   equ  1     ; Do not clear VDP vram upon startup
0060      6100     kickstart                equ   >6100   ; Uniform aorg address accross ROM banks
0061      A000     cpu.scrpad.tgt           equ   >a000   ; Destination cpu.scrpad.backup/restore
0062               
0063               *--------------------------------------------------------------
0064               * Scratchpad memory                 @>8300-83ff     (256 bytes)
0065               *--------------------------------------------------------------
0066               ;               equ  >8342          ; >8342-834F **free***
0067      8350     parm1           equ  >8350          ; Function parameter 1
0068      8352     parm2           equ  >8352          ; Function parameter 2
0069      8354     parm3           equ  >8354          ; Function parameter 3
0070      8356     parm4           equ  >8356          ; Function parameter 4
0071      8358     parm5           equ  >8358          ; Function parameter 5
0072      835A     parm6           equ  >835a          ; Function parameter 6
0073      835C     parm7           equ  >835c          ; Function parameter 7
0074      835E     parm8           equ  >835e          ; Function parameter 8
0075      8360     outparm1        equ  >8360          ; Function output parameter 1
0076      8362     outparm2        equ  >8362          ; Function output parameter 2
0077      8364     outparm3        equ  >8364          ; Function output parameter 3
0078      8366     outparm4        equ  >8366          ; Function output parameter 4
0079      8368     outparm5        equ  >8368          ; Function output parameter 5
0080      836A     outparm6        equ  >836a          ; Function output parameter 6
0081      836C     outparm7        equ  >836c          ; Function output parameter 7
0082      836E     outparm8        equ  >836e          ; Function output parameter 8
0083      8370     timers          equ  >8370          ; Timer table
0084      8380     ramsat          equ  >8380          ; Sprite Attribute Table in RAM
0085      8390     rambuf          equ  >8390          ; RAM workbuffer 1
0086               *--------------------------------------------------------------
0087               * Scratchpad backup 1               @>a000-a0ff     (256 bytes)
0088               * Scratchpad backup 2               @>a100-a1ff     (256 bytes)
0089               *--------------------------------------------------------------
0090      A000     scrpad.backup1  equ  >a000          ; Backup GPL layout
0091      A100     scrpad.backup2  equ  >a100          ; Backup spectra2 layout
0092               *--------------------------------------------------------------
0093               * TiVi Editor shared structures     @>a200-a27f     (128 bytes)
0094               *--------------------------------------------------------------
0095      A200     tv.top          equ  >a200          ; Structure begin
0096      A200     tv.sams.2000    equ  tv.top + 0     ; SAMS shadow register memory >2000-2fff
0097      A202     tv.sams.3000    equ  tv.top + 2     ; SAMS shadow register memory >3000-3fff
0098      A204     tv.sams.a000    equ  tv.top + 4     ; SAMS shadow register memory >a000-afff
0099      A206     tv.sams.b000    equ  tv.top + 6     ; SAMS shadow register memory >b000-bfff
0100      A208     tv.sams.c000    equ  tv.top + 8     ; SAMS shadow register memory >c000-cfff
0101      A20A     tv.sams.d000    equ  tv.top + 10    ; SAMS shadow register memory >d000-dfff
0102      A20C     tv.sams.e000    equ  tv.top + 12    ; SAMS shadow register memory >e000-efff
0103      A20E     tv.sams.f000    equ  tv.top + 14    ; SAMS shadow register memory >f000-ffff
0104      A210     tv.act_buffer   equ  tv.top + 16    ; Active editor buffer (0-9)
0105      A212     tv.end          equ  tv.top + 18    ; End of structure
0106               *--------------------------------------------------------------
0107               * Frame buffer structure            @>a280-a2ff     (128 bytes)
0108               *--------------------------------------------------------------
0109      A280     fb.struct       equ  >a280          ; Structure begin
0110      A280     fb.top.ptr      equ  fb.struct      ; Pointer to frame buffer
0111      A282     fb.current      equ  fb.struct + 2  ; Pointer to current pos. in frame buffer
0112      A284     fb.topline      equ  fb.struct + 4  ; Top line in frame buffer (matching
0113                                                   ; line X in editor buffer).
0114      A286     fb.row          equ  fb.struct + 6  ; Current row in frame buffer
0115                                                   ; (offset 0 .. @fb.scrrows)
0116      A288     fb.row.length   equ  fb.struct + 8  ; Length of current row in frame buffer
0117      A28A     fb.row.dirty    equ  fb.struct + 10 ; Current row dirty flag in frame buffer
0118      A28C     fb.column       equ  fb.struct + 12 ; Current column in frame buffer
0119      A28E     fb.colsline     equ  fb.struct + 14 ; Columns per row in frame buffer
0120      A290     fb.curshape     equ  fb.struct + 16 ; Cursor shape & colour
0121      A292     fb.curtoggle    equ  fb.struct + 18 ; Cursor shape toggle
0122      A294     fb.yxsave       equ  fb.struct + 20 ; Copy of WYX
0123      A296     fb.dirty        equ  fb.struct + 22 ; Frame buffer dirty flag
0124      A298     fb.scrrows      equ  fb.struct + 24 ; Rows on physical screen for framebuffer
0125      A29A     fb.scrrows.max  equ  fb.struct + 26 ; Max # of rows on physical screen for fb
0126      A29C     fb.end          equ  fb.struct + 28 ; End of structure
0127               *--------------------------------------------------------------
0128               * Editor buffer structure           @>a300-a3ff     (256 bytes)
0129               *--------------------------------------------------------------
0130      A300     edb.struct        equ  >a300           ; Begin structure
0131      A300     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0132      A302     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0133      A304     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer
0134      A306     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0135      A308     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0136      A30A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0137      A30C     edb.rle           equ  edb.struct + 12 ; RLE compression activated
0138      A30E     edb.filename.ptr  equ  edb.struct + 14 ; Pointer to length-prefixed string
0139                                                      ; with current filename.
0140      A310     edb.sams.page     equ  edb.struct + 16 ; Current SAMS page
0141      A312     edb.end           equ  edb.struct + 18 ; End of structure
0142               *--------------------------------------------------------------
0143               * File handling structures          @>a400-a4ff     (256 bytes)
0144               *--------------------------------------------------------------
0145      A400     tfh.struct      equ  >a400           ; TiVi file handling structures
0146      A400     dsrlnk.dsrlws   equ  tfh.struct      ; Address of dsrlnk workspace 32 bytes
0147      A420     dsrlnk.namsto   equ  tfh.struct + 32 ; 8-byte RAM buffer for storing device name
0148      A428     file.pab.ptr    equ  tfh.struct + 40 ; Pointer to VDP PAB, needed by level 2 FIO
0149      A42A     tfh.pabstat     equ  tfh.struct + 42 ; Copy of VDP PAB status byte
0150      A42C     tfh.ioresult    equ  tfh.struct + 44 ; DSRLNK IO-status after file operation
0151      A42E     tfh.records     equ  tfh.struct + 46 ; File records counter
0152      A430     tfh.reclen      equ  tfh.struct + 48 ; Current record length
0153      A432     tfh.kilobytes   equ  tfh.struct + 50 ; Kilobytes processed (read/written)
0154      A434     tfh.counter     equ  tfh.struct + 52 ; Counter used in TiVi file operations
0155      A436     tfh.fname.ptr   equ  tfh.struct + 54 ; Pointer to device and filename
0156      A438     tfh.sams.page   equ  tfh.struct + 56 ; Current SAMS page during file operation
0157      A43A     tfh.sams.hpage  equ  tfh.struct + 58 ; Highest SAMS page used for file operation
0158      A43C     tfh.callback1   equ  tfh.struct + 60 ; Pointer to callback function 1
0159      A43E     tfh.callback2   equ  tfh.struct + 62 ; Pointer to callback function 2
0160      A440     tfh.callback3   equ  tfh.struct + 64 ; Pointer to callback function 3
0161      A442     tfh.callback4   equ  tfh.struct + 66 ; Pointer to callback function 4
0162      A444     tfh.rleonload   equ  tfh.struct + 68 ; RLE compression needed during file load
0163      A446     tfh.membuffer   equ  tfh.struct + 70 ; 80 bytes file memory buffer
0164      A496     tfh.end         equ  tfh.struct +150 ; End of structure
0165      0960     tfh.vrecbuf     equ  >0960           ; VDP address record buffer
0166      0A60     tfh.vpab        equ  >0a60           ; VDP address PAB
0167               *--------------------------------------------------------------
0168               * Command buffer structure          @>a500-a5ff     (256 bytes)
0169               *--------------------------------------------------------------
0170      A500     cmdb.struct     equ  >a500          ; Command Buffer structure
0171      A500     cmdb.top.ptr    equ  cmdb.struct    ; Pointer to command buffer
0172      A502     cmdb.visible    equ  cmdb.struct+2  ; Command buffer visible? (>ffff = visible)
0173      A504     cmdb.scrrows    equ  cmdb.struct+4  ; Current size of cmdb pane (in rows)
0174      A506     cmdb.default    equ  cmdb.struct+6  ; Default size of cmdb pane (in rows)
0175      A508     cmdb.end        equ  cmdb.struct+8  ; End of structure
0176               *--------------------------------------------------------------
0177               * Free for future use               @>a600-a64f     (80 bytes)
0178               *--------------------------------------------------------------
0179      A600     free.mem2       equ  >a600          ; >b600-b64f    80 bytes
0180               *--------------------------------------------------------------
0181               * Frame buffer                      @>a650-afff    (2480 bytes)
0182               *--------------------------------------------------------------
0183      A650     fb.top          equ  >a650          ; Frame buffer low memory 2400 bytes (80x30)
0184      09B0     fb.size         equ  2480           ; Frame buffer size
0185               *--------------------------------------------------------------
0186               * Command buffer                    @>b000-bfff    (4096 bytes)
0187               *--------------------------------------------------------------
0188      B000     cmdb.top        equ  >b000          ; Top of command buffer
0189      1000     cmdb.size       equ  4096           ; Command buffer size
0190               *--------------------------------------------------------------
0191               * Index                             @>c000-cfff    (4096 bytes)
0192               *--------------------------------------------------------------
0193      C000     idx.top         equ  >c000          ; Top of index
0194      1000     idx.size        equ  4096           ; Index size
0195               *--------------------------------------------------------------
0196               * SAMS shadow pages index           @>d000-dfff    (4096 bytes)
0197               *--------------------------------------------------------------
0198      D000     idx.shadow.top  equ  >d000          ; Top of shadow index
0199      1000     idx.shadow.size equ  4096           ; Shadow index size
0200               *--------------------------------------------------------------
0201               * Editor buffer                     @>e000-efff    (4096 bytes)
0202               *                                   @>f000-ffff    (4096 bytes)
0203               *--------------------------------------------------------------
0204      E000     edb.top         equ  >e000          ; Editor buffer high memory
0205      2000     edb.size        equ  8192           ; Editor buffer size
0206               *--------------------------------------------------------------
**** **** ****     > tivi_b1.asm.32332
0037                       copy  "kickstart.asm"       ; Kickstart code
**** **** ****     > kickstart.asm
0001               * FILE......: kickstart.asm
0002               * Purpose...: Bankswitch routine for starting TiVi
0003               
0004               ***************************************************************
0005               * TiVi Cartridge Header & kickstart ROM bank 0
0006               ***************************************************************
0007               *
0008               *--------------------------------------------------------------
0009               * INPUT
0010               * none
0011               *--------------------------------------------------------------
0012               * OUTPUT
0013               * none
0014               *--------------------------------------------------------------
0015               * Register usage
0016               * r0
0017               ***************************************************************
0018               
0019               *--------------------------------------------------------------
0020               * Cartridge header
0021               *--------------------------------------------------------------
0022 6000 AA01             byte  >aa,1,1,0,0,0
     6002 0100 
     6004 0000 
0023 6006 6010             data  $+10
0024 6008 0000             byte  0,0,0,0,0,0,0,0
     600A 0000 
     600C 0000 
     600E 0000 
0025 6010 0000             data  0                     ; No more items following
0026 6012 6100             data  kickstart
0027               
0029               
0030 6014 1154             byte  17
0031 6015 ....             text  'TIVI 200224-32332'
0032                       even
0033               
0041               
0042                       aorg  kickstart

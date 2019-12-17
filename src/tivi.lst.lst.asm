XAS99 CROSS-ASSEMBLER   VERSION 1.7.0
**** **** ****     > tivi.lst.asm.32418
0001               XAS99 CROSS-ASSEMBLER   VERSION 1.7.0
0002               **** **** ****     > tivi.asm.32205
0003               0001               ***************************************************************
0004               0002               *
0005               0003               *                          TiVi Editor
0006               0004               *
0007               0005               *                (c)2018-2019 // Filip van Vooren
0008               0006               *
0009               0007               ***************************************************************
0010               0008               * File: tivi.asm                    ; Version 191217-32205
0011               0009               *--------------------------------------------------------------
0012               0010               * TI-99/4a Advanced Editor & IDE
0013               0011               *--------------------------------------------------------------
0014               0012               * TiVi memory layout
0015               0013               *
0016               0014               * Mem range   Bytes    Hex   Purpose
0017               0015               * =========   =====   ====   ==================================
0018               0016               * 8300-83ff     256   >100   scrpad spectra2 layout
0019               0017               * 2000-20ff     256   >100   scrpad backup 1: GPL layout
0020               0018               * 2100-21ff     256   >100   scrpad backup 2: paged out spectra2
0021               0019               * 2200-22ff     256   >100   TiVi frame buffer structure
0022               0020               * 2300-23ff     256   >100   TiVi editor buffer structure
0023               0021               * 2400-24ff     256   >100   TiVi file handling structure
0024               0022               * 2500-25ff     256   >100   Free for future use
0025               0023               * 2600-264f      80   >050   Free for future use
0026               0024               * 2650-2faf    2480   >9b0   Frame buffer 80x31
0027               0025               * 2fb0-2fff      80   >050   Free for future use
0028               0026               * 3000-3fff    4096  >1000   Index
0029               0027               * a000-fffb   24574  >5ffe   Editor buffer
0030               0028               *--------------------------------------------------------------
0031               0029               * SAMS 4k pages in transparent mode
0032               0030               *
0033               0031               * Low memory expansion
0034               0032               * 2000-2fff 3000-3fff
0035               0033               *
0036               0034               * High memory expansion
0037               0035               * a000-afff b000-bfff c000-cfff d000-dfff e000-efff f000-ffff
0038               0036               *--------------------------------------------------------------
0039               0037               * TiVi VDP layout
0040               0038               *
0041               0039               * Mem range   Bytes    Hex   Purpose
0042               0040               * =========   =====   ====   ==================================
0043               0041               * 0000-095f    2400    960   PNT - Pattern Name Table
0044               0042               * 0960-09af      80     50   File record buffer (DIS/VAR 80)
0045               0043               * 0fc0                       PCT - Pattern Color Table
0046               0044               * 1000                       PDT - Pattern Descriptor Table
0047               0045               * 1800                       SPT - Sprite Pattern Table
0048               0046               * 2000                       SAT - Sprite Attribute List
0049               0047               *--------------------------------------------------------------
0050               0048               * EQUATES  EQUATES  EQUATES  EQUATES  EQUATES  EQUATES  EQUATES
0051               0049               *--------------------------------------------------------------
0052               0050      0001     debug                   equ  1      ; Turn on spectra2 debugging
0053               0051               *--------------------------------------------------------------
0054               0052               * Skip unused spectra2 code modules for reduced code size
0055               0053               *--------------------------------------------------------------
0056               0054      0001     skip_rom_bankswitch     equ  1      ; Skip ROM bankswitching support
0057               0055      0001     skip_grom_cpu_copy      equ  1      ; Skip GROM to CPU copy functions
0058               0056      0001     skip_grom_vram_copy     equ  1      ; Skip GROM to VDP vram copy functions
0059               0057      0001     skip_vdp_vchar          equ  1      ; Skip vchar, xvchar
0060               0058      0001     skip_vdp_boxes          equ  1      ; Skip filbox, putbox
0061               0059      0001     skip_vdp_bitmap         equ  1      ; Skip bitmap functions
0062               0060      0001     skip_vdp_viewport       equ  1      ; Skip viewport functions
0063               0061      0001     skip_vdp_rle_decompress equ  1      ; Skip RLE decompress to VRAM
0064               0062      0001     skip_vdp_px2yx_calc     equ  1      ; Skip pixel to YX calculation
0065               0063      0001     skip_sound_player       equ  1      ; Skip inclusion of sound player code
0066               0064      0001     skip_speech_detection   equ  1      ; Skip speech synthesizer detection
0067               0065      0001     skip_speech_player      equ  1      ; Skip inclusion of speech player code
0068               0066      0001     skip_virtual_keyboard   equ  1      ; Skip virtual keyboard scan
0069               0067      0001     skip_random_generator   equ  1      ; Skip random functions
0070               0068      0001     skip_cpu_hexsupport     equ  1      ; Skip mkhex, puthex
0071               0069      0001     skip_cpu_crc16          equ  1      ; Skip CPU memory CRC-16 calculation
0072               0070               *--------------------------------------------------------------
0073               0071               * SPECTRA2 startup options
0074               0072               *--------------------------------------------------------------
0075               0073      0001     startup_backup_scrpad   equ  1      ; Backup scratchpad @>8300:>83ff to @>2000
0076               0074      0001     startup_keep_vdpmemory  equ  1      ; Do not clear VDP vram upon startup
0077               0075      00F5     spfclr                  equ  >f5    ; Foreground/Background color for font.
0078               0076      0005     spfbck                  equ  >05    ; Screen background color.
0079               0077               *--------------------------------------------------------------
0080               0078               * Scratchpad memory                 @>8300-83ff     (256 bytes)
0081               0079               *--------------------------------------------------------------
0082               0080               ;               equ  >8342          ; >8342-834F **free***
0083               0081      8350     parm1           equ  >8350          ; Function parameter 1
0084               0082      8352     parm2           equ  >8352          ; Function parameter 2
0085               0083      8354     parm3           equ  >8354          ; Function parameter 3
0086               0084      8356     parm4           equ  >8356          ; Function parameter 4
0087               0085      8358     parm5           equ  >8358          ; Function parameter 5
0088               0086      835A     parm6           equ  >835a          ; Function parameter 6
0089               0087      835C     parm7           equ  >835c          ; Function parameter 7
0090               0088      835E     parm8           equ  >835e          ; Function parameter 8
0091               0089      8360     outparm1        equ  >8360          ; Function output parameter 1
0092               0090      8362     outparm2        equ  >8362          ; Function output parameter 2
0093               0091      8364     outparm3        equ  >8364          ; Function output parameter 3
0094               0092      8366     outparm4        equ  >8366          ; Function output parameter 4
0095               0093      8368     outparm5        equ  >8368          ; Function output parameter 5
0096               0094      836A     outparm6        equ  >836a          ; Function output parameter 6
0097               0095      836C     outparm7        equ  >836c          ; Function output parameter 7
0098               0096      836E     outparm8        equ  >836e          ; Function output parameter 8
0099               0097      8370     timers          equ  >8370          ; Timer table
0100               0098      8380     ramsat          equ  >8380          ; Sprite Attribute Table in RAM
0101               0099      8390     rambuf          equ  >8390          ; RAM workbuffer 1
0102               0100               *--------------------------------------------------------------
0103               0101               * Scratchpad backup 1               @>2000-20ff     (256 bytes)
0104               0102               * Scratchpad backup 2               @>2100-21ff     (256 bytes)
0105               0103               *--------------------------------------------------------------
0106               0104      2000     scrpad.backup1  equ  >2000          ; Backup GPL layout
0107               0105      2100     scrpad.backup2  equ  >2100          ; Backup spectra2 layout
0108               0106               *--------------------------------------------------------------
0109               0107               * Frame buffer structure            @>2200-22ff     (256 bytes)
0110               0108               *--------------------------------------------------------------
0111               0109      2200     fb.top.ptr      equ  >2200          ; Pointer to frame buffer
0112               0110      2202     fb.current      equ  fb.top.ptr+2   ; Pointer to current position in frame buffer
0113               0111      2204     fb.topline      equ  fb.top.ptr+4   ; Top line in frame buffer (matching line X in editor buffer)
0114               0112      2206     fb.row          equ  fb.top.ptr+6   ; Current row in frame buffer (offset 0 .. @fb.screenrows)
0115               0113      2208     fb.row.length   equ  fb.top.ptr+8   ; Length of current row in frame buffer
0116               0114      220A     fb.row.dirty    equ  fb.top.ptr+10  ; Current row dirty flag in frame buffer
0117               0115      220C     fb.column       equ  fb.top.ptr+12  ; Current column in frame buffer
0118               0116      220E     fb.colsline     equ  fb.top.ptr+14  ; Columns per row in frame buffer
0119               0117      2210     fb.curshape     equ  fb.top.ptr+16  ; Cursor shape & colour
0120               0118      2212     fb.curtoggle    equ  fb.top.ptr+18  ; Cursor shape toggle
0121               0119      2214     fb.yxsave       equ  fb.top.ptr+20  ; Copy of WYX
0122               0120      2216     fb.dirty        equ  fb.top.ptr+22  ; Frame buffer dirty flag
0123               0121      2218     fb.screenrows   equ  fb.top.ptr+24  ; Number of rows on physical screen
0124               0122      221A     fb.end          equ  fb.top.ptr+26  ; Free from here on
0125               0123               *--------------------------------------------------------------
0126               0124               * Editor buffer structure           @>2300-23ff     (256 bytes)
0127               0125               *--------------------------------------------------------------
0128               0126      2300     edb.top.ptr     equ  >2300          ; Pointer to editor buffer
0129               0127      2302     edb.index.ptr   equ  edb.top.ptr+2  ; Pointer to index
0130               0128      2304     edb.lines       equ  edb.top.ptr+4  ; Total lines in editor buffer
0131               0129      2306     edb.dirty       equ  edb.top.ptr+6  ; Editor buffer dirty flag (Text changed!)
0132               0130      2308     edb.next_free   equ  edb.top.ptr+8  ; Pointer to next free line
0133               0131      230A     edb.insmode     equ  edb.top.ptr+10 ; Editor insert mode (>0000 overwrite / >ffff insert)
0134               0132      230C     edb.end         equ  edb.top.ptr+12 ; Free from here on
0135               0133               *--------------------------------------------------------------
0136               0134               * File handling structures          @>2400-24ff     (256 bytes)
0137               0135               *--------------------------------------------------------------
0138               0136      2400     tfh.top         equ  >2400          ; TiVi file handling structures
0139               0137      2400     dsrlnk.dsrlws   equ  tfh.top        ; Address of dsrlnk workspace 32 bytes
0140               0138      2420     dsrlnk.namsto   equ  tfh.top + 32   ; 8-byte RAM buffer for storing device name
0141               0139      2428     file.pab.ptr    equ  tfh.top + 40   ; Pointer to VDP PAB, required by level 2 FIO
0142               0140      242A     tfh.pabstat     equ  tfh.top + 42   ; Copy of VDP PAB status byte
0143               0141      242C     tfh.ioresult    equ  tfh.top + 44   ; DSRLNK IO-status after file operation
0144               0142      242E     tfh.records     equ  tfh.top + 46   ; File records counter
0145               0143      2430     tfh.reclen      equ  tfh.top + 48   ; Current record length
0146               0144      2432     tfh.kilobytes   equ  tfh.top + 50   ; Kilobytes processed (read/written)
0147               0145      2434     tfh.counter     equ  tfh.top + 52   ; Internal counter used in TiVi file operations
0148               0146      2436     tfh.membuffer   equ  tfh.top + 54   ; 80 bytes file memory buffer
0149               0147      2486     tfh.end         equ  tfh.top + 134  ; Free from here on
0150               0148      0960     tfh.vrecbuf     equ  >0960          ; Address of record buffer in VDP memory (max 255 bytes)
0151               0149      0A60     tfh.vpab        equ  >0a60          ; Address of PAB in VDP memory
0152               0150               *--------------------------------------------------------------
0153               0151               * Free for future use               @>2500-264f     (336 bytes)
0154               0152               *--------------------------------------------------------------
0155               0153      2500     free.mem1       equ  >2500          ; >2500-25ff   256 bytes
0156               0154      2600     free.mem2       equ  >2600          ; >2600-264f    80 bytes
0157               0155               *--------------------------------------------------------------
0158               0156               * Frame buffer                      @>2650-2fff    (2480 bytes)
0159               0157               * Index buffer                      @>3000-3fff    (4096 bytes)
0160               0158               * Editor buffer                     @>a000-ffff   (24576 bytes)
0161               0159               *--------------------------------------------------------------
0162               0160      2650     fb.top          equ  >2650          ; Frame buffer low memory 2400 bytes (80x30)
0163               0161      3000     idx.top         equ  >3000          ; Top of index
0164               0162      A000     edb.top         equ  >a000          ; Editor buffer high memory
0165               0163               *--------------------------------------------------------------
0166               0164
0167               0165
0168               0166
0169               0167
0170               0168               *--------------------------------------------------------------
0171               0169               * Cartridge header
0172               0170               *--------------------------------------------------------------
0173               0171                       save  >6000,>7fff
0174               0172                       aorg  >6000

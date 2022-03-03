XAS99 CROSS-ASSEMBLER   VERSION 3.1.0
     **** ****     > stevie_b7.asm.16732
0001               ***************************************************************
0002               *                          Stevie
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2022 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b7.asm               ; Version 220303-2012240
0010               *
0011               * Bank 7 "Jonas"
0012               * SAMS and TI Basic support routines
0013               ***************************************************************
0014                       copy  "rom.build.asm"       ; Cartridge build options
     **** ****     > rom.build.asm
0001               * FILE......: rom.build.asm
0002               * Purpose...: Cartridge build options
0003               
0004               *--------------------------------------------------------------
0005               * Skip unused spectra2 code modules for reduced code size
0006               *--------------------------------------------------------------
0007      0001     skip_rom_bankswitch       equ  1       ; Skip support for ROM bankswitching
0008      0001     skip_grom_cpu_copy        equ  1       ; Skip GROM to CPU copy functions
0009      0001     skip_grom_vram_copy       equ  1       ; Skip GROM to VDP vram copy functions
0010      0001     skip_vdp_vchar            equ  1       ; Skip vchar, xvchar
0011      0001     skip_vdp_boxes            equ  1       ; Skip filbox, putbox
0012      0001     skip_vdp_bitmap           equ  1       ; Skip bitmap functions
0013      0001     skip_vdp_viewport         equ  1       ; Skip viewport functions
0014      0001     skip_cpu_rle_compress     equ  1       ; Skip CPU RLE compression
0015      0001     skip_cpu_rle_decompress   equ  1       ; Skip CPU RLE decompression
0016      0001     skip_vdp_rle_decompress   equ  1       ; Skip VDP RLE decompression
0017      0001     skip_vdp_px2yx_calc       equ  1       ; Skip pixel to YX calculation
0018      0001     skip_speech_detection     equ  1       ; Skip speech synthesizer detection
0019      0001     skip_speech_player        equ  1       ; Skip inclusion of speech player code
0020      0001     skip_virtual_keyboard     equ  1       ; Skip virtual keyboard scan
0021      0001     skip_random_generator     equ  1       ; Skip random functions
0022      0001     skip_cpu_crc16            equ  1       ; Skip CPU memory CRC-16 calculation
0023      0001     skip_sams_layout          equ  1       ; Skip SAMS memory layout routine
0024                                                      ; \
0025                                                      ; | The SAMS support module needs to be
0026                                                      ; | embedded in the cartridge space, so
0027                                                      ; / do not load it here.
0028               
0029               *--------------------------------------------------------------
0030               * SPECTRA2 / Stevie startup options
0031               *--------------------------------------------------------------
0032      0001     startup_keep_vdpmemory    equ  1       ; Do not clear VDP vram on start
0033      6038     kickstart.resume          equ  >6038   ; Resume Stevie session
0034      6040     kickstart.code1           equ  >6040   ; Uniform aorg entry addr accross banks
0035      6046     kickstart.code2           equ  >6046   ; Uniform aorg entry addr accross banks
0036      0001     rom0_kscan_on             equ  1       ; Use KSCAN in console ROM#0
0037               
0038               
0039               
0040               *--------------------------------------------------------------
0041               * classic99 and JS99er emulators are mutually exclusive.
0042               * At the time of writing JS99er has full F18a compatibility.
0043               *
0044               * If build target is the JS99er emulator or an F18a equiped TI-99/4a
0045               * then set the 'full_f18a_support' equate to 1.
0046               *
0047               * When targetting the classic99 emulator then set the
0048               * 'full_f18a_support' equate to 0.
0049               * This will build the trimmed down version with 24x80 resolution.
0050               *--------------------------------------------------------------
0051      0000     debug                     equ  0       ; Turn on debugging mode
0052      0000     full_f18a_support         equ  0       ; 30 rows mode with sprites
0053               
0054               
0055               *--------------------------------------------------------------
0056               * JS99er F18a 30x80, no FG99 advanced mode
0057               *--------------------------------------------------------------
0063               
0064               
0065               
0066               *--------------------------------------------------------------
0067               * Classic99 F18a 24x80, no FG99 advanced mode
0068               *--------------------------------------------------------------
0070      0000     device.f18a               equ  0       ; F18a GPU
0071      0001     device.9938               equ  1       ; 9938 GPU
0072      0000     device.fg99.mode.adv      equ  0       ; FG99 advanced mode off
0073      0001     skip_vdp_f18a_support     equ  1       ; Turn off f18a GPU check
0075               
0076               
0077               
0078               *--------------------------------------------------------------
0079               * ROM layout
0080               *--------------------------------------------------------------
0081      7F00     bankx.crash.showbank      equ  >7f00   ; Show ROM bank in CPU crash screen
0082      7FC0     bankx.vectab              equ  >7fc0   ; Start address of vector table
                   < stevie_b7.asm.16732
0015                       copy  "rom.order.asm"       ; ROM bank order "non-inverted"
     **** ****     > rom.order.asm
0001               * FILE......: rom.order.asm
0002               * Purpose...: Equates with CPU write addresses for switching banks
0003               
0004               *--------------------------------------------------------------
0005               * ROM 8K/4K banks. Bank order (non-inverted)
0006               *--------------------------------------------------------------
0007      6000     bank0.rom                 equ  >6000   ; Jill
0008      6002     bank1.rom                 equ  >6002   ; James
0009      6004     bank2.rom                 equ  >6004   ; Jacky
0010      6006     bank3.rom                 equ  >6006   ; John
0011      6008     bank4.rom                 equ  >6008   ; Janine
0012      600A     bank5.rom                 equ  >600a   ; Jumbo
0013      600C     bank6.rom                 equ  >600c   ; Jenifer
0014      600E     bank7.rom                 equ  >600e   ; Jonas
0015               *--------------------------------------------------------------
0016               * RAM 4K banks (Only valid in advanced mode FG99)
0017               *--------------------------------------------------------------
0018      6800     bank0.ram                 equ  >6800   ; Jill
0019      6802     bank1.ram                 equ  >6802   ; James
0020      6804     bank2.ram                 equ  >6804   ; Jacky
0021      6806     bank3.ram                 equ  >6806   ; John
0022      6808     bank4.ram                 equ  >6808   ; Janine
0023      680A     bank5.ram                 equ  >680a   ; Jumbo
0024      680C     bank6.ram                 equ  >680c   ; Jenifer
0025      680E     bank7.ram                 equ  >680e   ; Jonas
                   < stevie_b7.asm.16732
0016                       copy  "equates.asm"         ; Equates Stevie configuration
     **** ****     > equates.asm
0001               * FILE......: equates.asm
0002               * Purpose...: The main equates file for Stevie editor
0003               
0004               
0005               *===============================================================================
0006               * Memory map
0007               * ==========
0008               *
0009               * CARTRIDGE SPACE (6000-7fff)
0010               *
0011               *     Mem range   Bytes    BANK   Purpose
0012               *     =========   =====    ====   ==================================
0013               *     6000-633f               0   Cartridge header
0014               *     6040-7fff               0   SP2 library + Stevie library
0015               *                                 relocated to RAM space
0016               *     ..............................................................
0017               *     6000-633f               1   Cartridge header
0018               *     6040-7fbf               1   Stevie program code
0019               *     7fc0-7fff      64       1   Vector table (32 vectors)
0020               *     ..............................................................
0021               *     6000-633f               2   Cartridge header
0022               *     6040-7fbf               2   Stevie program code
0023               *     7fc0-7fff      64       2   Vector table (32 vectors)
0024               *     ..............................................................
0025               *     6000-633f               3   Cartridge header
0026               *     6040-7fbf               3   Stevie program code
0027               *     7fc0-7fff      64       3   Vector table (32 vectors)
0028               *     ..............................................................
0029               *     6000-633f               4   Cartridge header
0030               *     6040-7fbf               4   Stevie program code
0031               *     7fc0-7fff      64       4   Vector table (32 vectors)
0032               *     ..............................................................
0033               *     6000-633f               5   Cartridge header
0034               *     6040-7fbf               5   Stevie program code
0035               *     7fc0-7fff      64       5   Vector table (32 vectors)
0036               *     ..............................................................
0037               *     6000-633f               6   Cartridge header
0038               *     6040-7fbf               6   Stevie program code
0039               *     7fc0-7fff      64       6   Vector table (32 vectors)
0040               *     ..............................................................
0041               *     6000-633f               7   Cartridge header
0042               *     6040-7fbf               7   SP2 library in cartridge space
0043               *     7fc0-7fff      64       7   Vector table (32 vectors)
0044               *
0045               *
0046               *
0047               * VDP RAM F18a (0000-47ff)
0048               *
0049               *     Mem range   Bytes    Hex    Purpose
0050               *     =========   =====   =====   =================================
0051               *     0000-095f    2400   >0960   PNT: Pattern Name Table
0052               *     0960-09af      80   >0050   FIO: File record buffer (DIS/VAR 80)
0053               *     0fc0-0fff                   PCT: Color Table (not used in 80 cols mode)
0054               *     1000-17ff    2048   >0800   PDT: Pattern Descriptor Table
0055               *     1800-215f    2400   >0960   TAT: Tile Attribute Table
0056               *                                      (Position based colors F18a, 80 colums)
0057               *     2180                        SAT: Sprite Attribute Table
0058               *                                      (Cursor in F18a, 80 cols mode)
0059               *     2800                        SPT: Sprite Pattern Table
0060               *                                      (Cursor in F18a, 80 columns, 2K boundary)
0061               *===============================================================================
0062               
0063               ***************************************************************
0064               *                 Extra opcodes for classic99
0065               ********|*****|*********************|**************************
0066      0110     c99_norm      equ  >0110            ; CPU normal
0067      0111     c99_ovrd      equ  >0111            ; CPU overdrive
0068      0112     c99_smax      equ  >0112            ; System Maximum
0069      0113     c99_brk       equ  >0113            ; Breakpoint
0070      0114     c99_quit      equ  >0114            ; Quit emulator
0071      0120     c99_dbg_r0    equ  >0120            ; Debug printf r0
0072      0121     c99_dbg_r1    equ  >0121            ; Debug printf r1
0073      0122     c99_dbg_r2    equ  >0122            ; Debug printf r2
0074      0123     c99_dbg_r3    equ  >0123            ; Debug printf r3
0075      0124     c99_dbg_r4    equ  >0124            ; Debug printf r4
0076      0125     c99_dbg_r5    equ  >0125            ; Debug printf r5
0077      0126     c99_dbg_r6    equ  >0126            ; Debug printf r6
0078      0127     c99_dbg_r7    equ  >0127            ; Debug printf r7
0079      0128     c99_dbg_r8    equ  >0128            ; Debug printf r8
0080      0199     c99_dbg_r9    equ  >0199            ; Debug printf r9
0081      012A     c99_dbg_ra    equ  >012a            ; Debug printf ra
0082      012B     c99_dbg_rb    equ  >012b            ; Debug printf rb
0083      012C     c99_dbg_rc    equ  >012c            ; Debug printf rc
0084      012D     c99_dbg_rd    equ  >012d            ; Debug printf rd
0085      012E     c99_dbg_re    equ  >012e            ; Debug printf re
0086      012F     c99_dbg_rf    equ  >012f            ; Debug printf rf
0087      0124     c99_dbg_tmp0  equ  c99_dbg_r4       ; Debug printf tmp0
0088      0125     c99_dbg_tmp1  equ  c99_dbg_r5       ; Debug printf tmp1
0089      0126     c99_dbg_tmp2  equ  c99_dbg_r6       ; Debug printf tmp2
0090      0127     c99_dbg_tmp3  equ  c99_dbg_r7       ; Debug printf tmp3
0091      0128     c99_dbg_tmp4  equ  c99_dbg_r8       ; Debug printf tmp4
0092      0199     c99_dbg_stck  equ  c99_dbg_r9       ; Debug printf stack
0093               
0094               
0095               *--------------------------------------------------------------
0096               * Graphics mode selection
0097               *--------------------------------------------------------------
0103               
0104      0017     pane.botrow               equ  23      ; Bottom row on screen
0105               
0107               *--------------------------------------------------------------
0108               * Stevie Dialog / Pane specific equates
0109               *--------------------------------------------------------------
0110      0000     pane.focus.fb             equ  0       ; Editor pane has focus
0111      0001     pane.focus.cmdb           equ  1       ; Command buffer pane has focus
0112               ;-----------------------------------------------------------------
0113               ;   Dialog ID's
0114               ;-----------------------------------------------------------------
0115      000A     id.dialog.load            equ  10      ; "Load file"
0116      000B     id.dialog.save            equ  11      ; "Save file"
0117      000C     id.dialog.saveblock       equ  12      ; "Save block to file"
0118      000D     id.dialog.insert          equ  13      ; "Insert file"
0119      000E     id.dialog.append          equ  14      ; "Append file"
0120      000F     id.dialog.print           equ  15      ; "Print file"
0121      0010     id.dialog.printblock      equ  16      ; "Print block"
0122      0011     id.dialog.clipdev         equ  17      ; "Configure clipboard device"
0123               ;-----------------------------------------------------------------
0124               ;   Dialog ID's >= 100 indicate that command prompt should be
0125               ;   hidden and no characters added to CMDB keyboard buffer.
0126               ;-----------------------------------------------------------------
0127      0064     id.dialog.menu            equ  100     ; "Main Menu"
0128      0065     id.dialog.unsaved         equ  101     ; "Unsaved changes"
0129      0066     id.dialog.block           equ  102     ; "Block move/copy/delete/print/..."
0130      0067     id.dialog.clipboard       equ  103     ; "Copy clipboard to line ..."
0131      0068     id.dialog.help            equ  104     ; "About"
0132      0069     id.dialog.file            equ  105     ; "File"
0133      006A     id.dialog.cartridge       equ  106     ; "Cartridge"
0134      006B     id.dialog.basic           equ  107     ; "TI Basic"
0135      006C     id.dialog.config          equ  108     ; "Configure"
0136               *--------------------------------------------------------------
0137               * Suffix characters for clipboards
0138               *--------------------------------------------------------------
0139      3100     clip1                     equ  >3100   ; '1'
0140      3200     clip2                     equ  >3200   ; '2'
0141      3300     clip3                     equ  >3300   ; '3'
0142      3400     clip4                     equ  >3400   ; '4'
0143      3500     clip5                     equ  >3500   ; '5'
0144               *--------------------------------------------------------------
0145               * Keyboard flags in Stevie
0146               *--------------------------------------------------------------
0147      0001     kbf.kbclear               equ  >0001   ;  Keyboard buffer cleared / @w$0001
0148               
0149               *--------------------------------------------------------------
0150               * File work mode
0151               *--------------------------------------------------------------
0152      0001     id.file.loadfile          equ  1       ; Load file
0153      0002     id.file.insertfile        equ  2       ; Insert file
0154      0003     id.file.appendfile        equ  3       ; Append file
0155      0004     id.file.savefile          equ  4       ; Save file
0156      0005     id.file.saveblock         equ  5       ; Save block to file
0157      0006     id.file.clipblock         equ  6       ; Save block to clipboard
0158      0007     id.file.printfile         equ  7       ; Print file
0159      0008     id.file.printblock        equ  8       ; Print block
0160               *--------------------------------------------------------------
0161               * Stevie core 1 RAM                   @>a000-a0ff   (256 bytes)
0162               *--------------------------------------------------------------
0163      A000     core1.top         equ  >a000           ; Structure begin
0164      A000     magic.str.w1      equ  core1.top + 0   ; Magic string word 1
0165      A002     magic.str.w2      equ  core1.top + 2   ; Magic string word 2
0166      A004     magic.str.w3      equ  core1.top + 4   ; Magic string word 3
0167      A006     parm1             equ  core1.top + 6   ; Function parameter 1
0168      A008     parm2             equ  core1.top + 8   ; Function parameter 2
0169      A00A     parm3             equ  core1.top + 10  ; Function parameter 3
0170      A00C     parm4             equ  core1.top + 12  ; Function parameter 4
0171      A00E     parm5             equ  core1.top + 14  ; Function parameter 5
0172      A010     parm6             equ  core1.top + 16  ; Function parameter 6
0173      A012     parm7             equ  core1.top + 18  ; Function parameter 7
0174      A014     parm8             equ  core1.top + 20  ; Function parameter 8
0175      A016     outparm1          equ  core1.top + 22  ; Function output parameter 1
0176      A018     outparm2          equ  core1.top + 24  ; Function output parameter 2
0177      A01A     outparm3          equ  core1.top + 26  ; Function output parameter 3
0178      A01C     outparm4          equ  core1.top + 28  ; Function output parameter 4
0179      A01E     outparm5          equ  core1.top + 30  ; Function output parameter 5
0180      A020     outparm6          equ  core1.top + 32  ; Function output parameter 6
0181      A022     outparm7          equ  core1.top + 34  ; Function output parameter 7
0182      A024     outparm8          equ  core1.top + 36  ; Function output parameter 8
0183      A026     kbflags           equ  core1.top + 38  ; Keyboard control flags
0184      A028     keycode1          equ  core1.top + 40  ; Current key scanned
0185      A02A     keycode2          equ  core1.top + 42  ; Previous key scanned
0186      A02C     unpacked.string   equ  core1.top + 44  ; 6 char string with unpacked uin16
0187      A032     trmpvector        equ  core1.top + 50  ; Vector trampoline (if p1|tmp1 = >ffff)
0188      A034     core1.free1       equ  core1.top + 52  ; 52-85 **free**
0189      A056     ramsat            equ  core1.top + 86  ; Sprite Attr. Table in RAM (14 bytes)
0190      A064     timers            equ  core1.top + 100 ; Timers (80 bytes)
0191                                 ;--------------------------------------------
0192                                 ; TI Basic related
0193                                 ;--------------------------------------------
0194      A0B4     tib.session       equ  core1.top + 180 ; Current TI-Basic session (1-5)
0195      A0B6     tib.status1       equ  core1.top + 182 ; Status flags TI Basic session 1
0196      A0B8     tib.status2       equ  core1.top + 184 ; Status flags TI Basic session 2
0197      A0BA     tib.status3       equ  core1.top + 186 ; Status flags TI Basic session 3
0198      A0BC     tib.status4       equ  core1.top + 188 ; Status flags TI Basic session 4
0199      A0BE     tib.status5       equ  core1.top + 190 ; Status flags TI Basic session 5
0200      A0C0     tib.hidesid       equ  core1.top + 192 ; Hide TI-Basic session ID
0201      A0C2     tib.stab.ptr      equ  core1.top + 194 ; Pointer to TI-Basic SAMS page table
0202      A0C4     tib.scrpad.ptr    equ  core1.top + 196 ; Pointer to TI-Basic scratchpad in SAMS
0203      A0C6     tib.lnt.top.ptr   equ  core1.top + 198 ; Pointer to top of line number table
0204      A0C8     tib.lnt.bot.ptr   equ  core1.top + 200 ; Pointer to bottom of line number table
0205      A0CA     tib.symt.top.ptr  equ  core1.top + 202 ; Pointer to top of symbol table
0206      A0CC     tib.symt.bot.ptr  equ  core1.top + 204 ; Pointer to bottom of symbol table
0207      A0CE     tib.strs.top.ptr  equ  core1.top + 206 ; Pointer to top of string space
0208      A0D0     tib.strs.bot.ptr  equ  core1.top + 208 ; Pointer to bottom of string space
0209      A0D2     tib.lines         equ  core1.top + 210 ; Number of lines in TI Basic program
0210      A0D4     core1.free2       equ  core1.top + 212 ; **free* up to 235
0211      A0EC     tib.var1          equ  core1.top + 236 ; Temp variable 1
0212      A0EE     tib.var2          equ  core1.top + 238 ; Temp variable 2
0213      A0F0     tib.var3          equ  core1.top + 240 ; Temp variable 3
0214      A0F2     tib.var4          equ  core1.top + 242 ; Temp variable 4
0215      A0F4     tib.var5          equ  core1.top + 244 ; Temp variable 5
0216      A0F6     tib.var6          equ  core1.top + 246 ; Temp variable 6
0217      A0F8     tib.var7          equ  core1.top + 248 ; Temp variable 7
0218      A0FA     tib.var8          equ  core1.top + 250 ; Temp variable 8
0219      A0FC     tib.var9          equ  core1.top + 252 ; Temp variable 9
0220      A0FE     tib.var10         equ  core1.top + 254 ; Temp variable 10
0221      A100     core1.free        equ  core1.top + 256 ; End of structure
0222               *--------------------------------------------------------------
0223               * Stevie core 2 RAM                   @>a100-a1ff   (256 bytes)
0224               *--------------------------------------------------------------
0225      A100     core2.top         equ  >a100           ; Structure begin
0226      A100     rambuf            equ  core2.top       ; RAM workbuffer
0227      A200     core2.free        equ  core2.top + 256 ; End of structure
0228               *--------------------------------------------------------------
0229               * Stevie Editor shared structures     @>a200-a2ff   (256 bytes)
0230               *--------------------------------------------------------------
0231      A200     tv.top            equ  >a200           ; Structure begin
0232      A200     tv.sams.2000      equ  tv.top + 0      ; SAMS page in window >2000-2fff
0233      A202     tv.sams.3000      equ  tv.top + 2      ; SAMS page in window >3000-3fff
0234      A204     tv.sams.a000      equ  tv.top + 4      ; SAMS page in window >a000-afff
0235      A206     tv.sams.b000      equ  tv.top + 6      ; SAMS page in window >b000-bfff
0236      A208     tv.sams.c000      equ  tv.top + 8      ; SAMS page in window >c000-cfff
0237      A20A     tv.sams.d000      equ  tv.top + 10     ; SAMS page in window >d000-dfff
0238      A20C     tv.sams.e000      equ  tv.top + 12     ; SAMS page in window >e000-efff
0239      A20E     tv.sams.f000      equ  tv.top + 14     ; SAMS page in window >f000-ffff
0240      A210     tv.ruler.visible  equ  tv.top + 16     ; Show ruler with tab positions
0241      A212     tv.colorscheme    equ  tv.top + 18     ; Current color scheme (0-xx)
0242      A214     tv.curshape       equ  tv.top + 20     ; Cursor shape and color (sprite)
0243      A216     tv.curcolor       equ  tv.top + 22     ; Cursor color1 + color2 (color scheme)
0244      A218     tv.color          equ  tv.top + 24     ; FG/BG-color framebuffer + status lines
0245      A21A     tv.markcolor      equ  tv.top + 26     ; FG/BG-color marked lines in framebuffer
0246      A21C     tv.busycolor      equ  tv.top + 28     ; FG/BG-color bottom line when busy
0247      A21E     tv.rulercolor     equ  tv.top + 30     ; FG/BG-color ruler line
0248      A220     tv.cmdb.hcolor    equ  tv.top + 32     ; FG/BG-color command buffer header line
0249      A222     tv.pane.focus     equ  tv.top + 34     ; Identify pane that has focus
0250      A224     tv.task.oneshot   equ  tv.top + 36     ; Pointer to one-shot routine
0251      A226     tv.fj.stackpnt    equ  tv.top + 38     ; Pointer to farjump return stack
0252      A228     tv.error.visible  equ  tv.top + 40     ; Error pane visible
0253      A22A     tv.error.rows     equ  tv.top + 42     ; Number of rows in error pane
0254      A22C     tv.sp2.conf       equ  tv.top + 44     ; Backup of SP2 config register
0255      A22C     tv.sp2.stack      equ  tv.top + 44     ; Backup of SP2 stack register
0256      A230     tv.error.msg      equ  tv.top + 48     ; Error message (max. 160 characters)
0257      A2D0     tv.free           equ  tv.top + 208    ; End of structure
0258               *--------------------------------------------------------------
0259               * Frame buffer structure              @>a300-a3ff   (256 bytes)
0260               *--------------------------------------------------------------
0261      A300     fb.struct         equ  >a300           ; Structure begin
0262      A300     fb.top.ptr        equ  fb.struct       ; Pointer to frame buffer
0263      A302     fb.current        equ  fb.struct + 2   ; Pointer to current pos. in frame buffer
0264      A304     fb.topline        equ  fb.struct + 4   ; Top line in frame buffer (matching
0265                                                      ; line X in editor buffer).
0266      A306     fb.row            equ  fb.struct + 6   ; Current row in frame buffer
0267                                                      ; (offset 0 .. @fb.scrrows)
0268      A308     fb.row.length     equ  fb.struct + 8   ; Length of current row in frame buffer
0269      A30A     fb.row.dirty      equ  fb.struct + 10  ; Current row dirty flag in frame buffer
0270      A30C     fb.column         equ  fb.struct + 12  ; Current column (0-79) in frame buffer
0271      A30E     fb.colsline       equ  fb.struct + 14  ; Columns per line in frame buffer
0272      A310     fb.colorize       equ  fb.struct + 16  ; M1/M2 colorize refresh required
0273      A312     fb.curtoggle      equ  fb.struct + 18  ; Cursor shape toggle
0274      A314     fb.yxsave         equ  fb.struct + 20  ; Copy of cursor YX position
0275      A316     fb.dirty          equ  fb.struct + 22  ; Frame buffer dirty flag
0276      A318     fb.status.dirty   equ  fb.struct + 24  ; Status line(s) dirty flag
0277      A31A     fb.scrrows        equ  fb.struct + 26  ; Rows on physical screen for framebuffer
0278      A31C     fb.scrrows.max    equ  fb.struct + 28  ; Max # of rows on physical screen for fb
0279      A31E     fb.ruler.sit      equ  fb.struct + 30  ; 80 char ruler  (no length-prefix!)
0280      A36E     fb.ruler.tat      equ  fb.struct + 110 ; 80 char colors (no length-prefix!)
0281      A3BE     fb.free           equ  fb.struct + 190 ; End of structure
0282               *--------------------------------------------------------------
0283               * File handle structure               @>a400-a4ff   (256 bytes)
0284               *--------------------------------------------------------------
0285      A400     fh.struct         equ  >a400           ; stevie file handling structures
0286               ;***********************************************************************
0287               ; ATTENTION
0288               ; The dsrlnk variables must form a continuous memory block and keep
0289               ; their order!
0290               ;***********************************************************************
0291      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0292      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0293      A428     dsrlnk.sav8a      equ  fh.struct + 40  ; Save parm (8 or A) after "blwp @dsrlnk"
0294      A42A     dsrlnk.savcru     equ  fh.struct + 42  ; CRU address of device in prev. DSR call
0295      A42C     dsrlnk.savent     equ  fh.struct + 44  ; DSR entry addr of prev. DSR call
0296      A42E     dsrlnk.savpab     equ  fh.struct + 46  ; Pointer to Device or Subprogram in PAB
0297      A430     dsrlnk.savver     equ  fh.struct + 48  ; Version used in prev. DSR call
0298      A432     dsrlnk.savlen     equ  fh.struct + 50  ; Length of DSR name of prev. DSR call
0299      A434     dsrlnk.flgptr     equ  fh.struct + 52  ; Pointer to VDP PAB byte 1 (flag byte)
0300      A436     fh.pab.ptr        equ  fh.struct + 54  ; Pointer to VDP PAB, for level 3 FIO
0301      A438     fh.pabstat        equ  fh.struct + 56  ; Copy of VDP PAB status byte
0302      A43A     fh.ioresult       equ  fh.struct + 58  ; DSRLNK IO-status after file operation
0303      A43C     fh.records        equ  fh.struct + 60  ; File records counter
0304      A43E     fh.reclen         equ  fh.struct + 62  ; Current record length
0305      A440     fh.kilobytes      equ  fh.struct + 64  ; Kilobytes processed (read/written)
0306      A442     fh.counter        equ  fh.struct + 66  ; Counter used in stevie file operations
0307      A444     fh.fname.ptr      equ  fh.struct + 68  ; Pointer to device and filename
0308      A446     fh.sams.page      equ  fh.struct + 70  ; Current SAMS page during file operation
0309      A448     fh.sams.hipage    equ  fh.struct + 72  ; Highest SAMS page in file operation
0310      A44A     fh.fopmode        equ  fh.struct + 74  ; FOP mode (File Operation Mode)
0311      A44C     fh.filetype       equ  fh.struct + 76  ; Value for filetype/mode (PAB byte 1)
0312      A44E     fh.offsetopcode   equ  fh.struct + 78  ; Set to >40 for skipping VDP buffer
0313      A450     fh.callback1      equ  fh.struct + 80  ; Pointer to callback function 1
0314      A452     fh.callback2      equ  fh.struct + 82  ; Pointer to callback function 2
0315      A454     fh.callback3      equ  fh.struct + 84  ; Pointer to callback function 3
0316      A456     fh.callback4      equ  fh.struct + 86  ; Pointer to callback function 4
0317      A458     fh.callback5      equ  fh.struct + 88  ; Pointer to callback function 5
0318      A45A     fh.workmode       equ  fh.struct + 90  ; Working mode (used in callbacks)
0319      A45C     fh.kilobytes.prev equ  fh.struct + 92  ; Kilobytes processed (previous)
0320      A45E     fh.line           equ  fh.struct + 94  ; Editor buffer line currently processing
0321      A460     fh.temp1          equ  fh.struct + 96  ; Temporary variable 1
0322      A462     fh.temp2          equ  fh.struct + 98  ; Temporary variable 2
0323      A464     fh.temp3          equ  fh.struct +100  ; Temporary variable 3
0324      A466     fh.membuffer      equ  fh.struct +102  ; 80 bytes file memory buffer
0325      A4B6     fh.free           equ  fh.struct +182  ; End of structure
0326      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0327      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0328               *--------------------------------------------------------------
0329               * Editor buffer structure             @>a500-a5ff   (256 bytes)
0330               *--------------------------------------------------------------
0331      A500     edb.struct        equ  >a500           ; Begin structure
0332      A500     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0333      A502     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0334      A504     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer - 1
0335      A506     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0336      A508     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0337      A50A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0338      A50C     edb.block.m1      equ  edb.struct + 12 ; Block start line marker (>ffff = unset)
0339      A50E     edb.block.m2      equ  edb.struct + 14 ; Block end line marker   (>ffff = unset)
0340      A510     edb.block.var     equ  edb.struct + 16 ; Local var used in block operation
0341      A512     edb.filename.ptr  equ  edb.struct + 18 ; Pointer to length-prefixed string
0342                                                      ; with current filename.
0343      A514     edb.filetype.ptr  equ  edb.struct + 20 ; Pointer to length-prefixed string
0344                                                      ; with current file type.
0345      A516     edb.sams.page     equ  edb.struct + 22 ; Current SAMS page
0346      A518     edb.sams.hipage   equ  edb.struct + 24 ; Highest SAMS page in use
0347      A51A     edb.filename      equ  edb.struct + 26 ; 80 characters inline buffer reserved
0348                                                      ; for filename, but not always used.
0349      A56A     edb.free          equ  edb.struct + 106; End of structure
0350               *--------------------------------------------------------------
0351               * Index structure                     @>a600-a6ff   (256 bytes)
0352               *--------------------------------------------------------------
0353      A600     idx.struct        equ  >a600           ; stevie index structure
0354      A600     idx.sams.page     equ  idx.struct      ; Current SAMS page
0355      A602     idx.sams.lopage   equ  idx.struct + 2  ; Lowest SAMS page
0356      A604     idx.sams.hipage   equ  idx.struct + 4  ; Highest SAMS page
0357      A606     idx.free          equ  idx.struct + 6  ; End of structure
0358               *--------------------------------------------------------------
0359               * Command buffer structure            @>a700-a7ff   (256 bytes)
0360               *--------------------------------------------------------------
0361      A700     cmdb.struct       equ  >a700           ; Command Buffer structure
0362      A700     cmdb.top.ptr      equ  cmdb.struct     ; Pointer to command buffer (history)
0363      A702     cmdb.visible      equ  cmdb.struct + 2 ; Command buffer visible? (>ffff=visible)
0364      A704     cmdb.fb.yxsave    equ  cmdb.struct + 4 ; Copy of FB WYX when entering cmdb pane
0365      A706     cmdb.scrrows      equ  cmdb.struct + 6 ; Current size of CMDB pane (in rows)
0366      A708     cmdb.default      equ  cmdb.struct + 8 ; Default size of CMDB pane (in rows)
0367      A70A     cmdb.cursor       equ  cmdb.struct + 10; Screen YX of cursor in CMDB pane
0368      A70C     cmdb.yxsave       equ  cmdb.struct + 12; Copy of WYX
0369      A70E     cmdb.yxtop        equ  cmdb.struct + 14; YX position of CMDB pane header line
0370      A710     cmdb.yxprompt     equ  cmdb.struct + 16; YX position of command buffer prompt
0371      A712     cmdb.column       equ  cmdb.struct + 18; Current column in command buffer pane
0372      A714     cmdb.length       equ  cmdb.struct + 20; Length of current row in CMDB
0373      A716     cmdb.lines        equ  cmdb.struct + 22; Total lines in CMDB
0374      A718     cmdb.dirty        equ  cmdb.struct + 24; Command buffer dirty (Text changed!)
0375      A71A     cmdb.dialog       equ  cmdb.struct + 26; Dialog identifier
0376      A71C     cmdb.dialog.var   equ  cmdb.struct + 28; Dialog private variable or pointer
0377      A71E     cmdb.panhead      equ  cmdb.struct + 30; Pointer to string pane header
0378      A720     cmdb.paninfo      equ  cmdb.struct + 32; Pointer to string pane info (1st line)
0379      A722     cmdb.panhint      equ  cmdb.struct + 34; Pointer to string pane hint (2nd line)
0380      A724     cmdb.panmarkers   equ  cmdb.struct + 36; Pointer to key marker list  (3rd line)
0381      A726     cmdb.pankeys      equ  cmdb.struct + 38; Pointer to string pane keys (stat line)
0382      A728     cmdb.action.ptr   equ  cmdb.struct + 40; Pointer to function to execute
0383      A72A     cmdb.cmdall       equ  cmdb.struct + 42; Current command including length-byte
0384      A72A     cmdb.cmdlen       equ  cmdb.struct + 42; Length of current command (MSB byte!)
0385      A72B     cmdb.cmd          equ  cmdb.struct + 43; Current command (80 bytes max.)
0386      A77C     cmdb.panhead.buf  equ  cmdb.struct +124; String buffer for pane header
0387      A7AE     cmdb.dflt.fname   equ  cmdb.struct +174; Default for filename
0388      A800     cmdb.free         equ  cmdb.struct +256; End of structure
0389               *--------------------------------------------------------------
0390               * Stevie value stack                  @>a800-a8ff   (256 bytes)
0391               *--------------------------------------------------------------
0392      A900     sp2.stktop        equ  >a900           ; \
0393                                                      ; | The stack grows from high memory
0394                                                      ; | towards low memory.
0395                                                      ; |
0396                                                      ; | Stack leaking is checked in SP2
0397                                                      ; | user hook "edkey.keyscan.hook"
0398                                                      ; /
0399               *--------------------------------------------------------------
0400               * Scratchpad memory work copy         @>ad00-aeff   (256 bytes)
0401               *--------------------------------------------------------------
0402      7E00     cpu.scrpad.src    equ  >7e00           ; \ Dump of OS monitor scratchpad
0403                                                      ; / stored in cartridge ROM bank7.asm
0404               
0405      F000     cpu.scrpad.tgt    equ  >f000           ; \ Fixed memory location used for
0406                                                      ; | scratchpad backup/restore routines.
0407                                                      ; /
0408               
0409      8300     cpu.scrpad1       equ  >8300           ; Stevie primary scratchpad
0410               
0411      AD00     cpu.scrpad2       equ  >ad00           ; Stevie secondary scratchpad, used when
0412                                                      ; calling TI Basic/External programs
0413               
0414               *--------------------------------------------------------------
0415               * Farjump return stack                @>af00-afff   (256 bytes)
0416               *--------------------------------------------------------------
0417      B000     fj.bottom         equ  >b000           ; Return stack for trampoline function
0418                                                      ; Grows downwards from high to low.
0419               *--------------------------------------------------------------
0420               * Index                               @>b000-bfff  (4096 bytes)
0421               *--------------------------------------------------------------
0422      B000     idx.top           equ  >b000           ; Top of index
0423      1000     idx.size          equ  4096            ; Index size
0424               *--------------------------------------------------------------
0425               * Editor buffer                       @>c000-cfff  (4096 bytes)
0426               *--------------------------------------------------------------
0427      C000     edb.top           equ  >c000           ; Editor buffer high memory
0428      1000     edb.size          equ  4096            ; Editor buffer size
0429               *--------------------------------------------------------------
0430               * Frame buffer & uncrunch area        @>d000-dcff  (3584 bytes)
0431               *--------------------------------------------------------------
0432      D000     fb.top            equ  >d000           ; Frame buffer (2400 char)
0433      0960     fb.size           equ  80*30           ; Frame buffer size
0434      D960     fb.uncrunch.area  equ  >d960           ; \ Uncrunched TI Basic statement
0435                                                      ; / >d960->dcff
0436               *--------------------------------------------------------------
0437               * Defaults area                       @>de00-dfff  (3584 bytes)
0438               *--------------------------------------------------------------
0439      DE00     tv.printer.fname  equ  >de00           ; Default printer   (80 char)
0440      DE50     tv.clip.fname     equ  >de50           ; Default clipboard (80 char)
0441               *--------------------------------------------------------------
0442               * Command buffer history              @>e000-efff  (4096 bytes)
0443               *--------------------------------------------------------------
0444      E000     cmdb.top          equ  >e000           ; Top of command history buffer
0445      1000     cmdb.size         equ  4096            ; Command buffer size
0446               *--------------------------------------------------------------
0447               * Heap                                @>f000-ffff  (4096 bytes)
0448               *--------------------------------------------------------------
0449      F000     heap.top          equ  >f000           ; Top of heap
0450               
0451               
0452               *--------------------------------------------------------------
0453               * Stevie specific equates
0454               *--------------------------------------------------------------
0455      0000     fh.fopmode.none           equ  0       ; No file operation in progress
0456      0001     fh.fopmode.readfile       equ  1       ; Read file from disk to memory
0457      0002     fh.fopmode.writefile      equ  2       ; Save file from memory to disk
0458      A028     rom0_kscan_out            equ  keycode1; Where to store value of key pressed
0459               
0460      0050     vdp.fb.toprow.sit         equ  >0050   ; VDP SIT address of 1st Framebuffer row
0461      1850     vdp.fb.toprow.tat         equ  >1850   ; VDP TAT address of 1st Framebuffer row
0462      1DF0     vdp.cmdb.toprow.tat       equ  >1800 + ((pane.botrow - 4) * 80)
0463                                                      ; VDP TAT address of 1st CMDB row
0464      0000     vdp.sit.base              equ  >0000   ; VDP SIT base address
0465      0780     vdp.sit.size              equ  (pane.botrow + 1) * 80
0466                                                      ; VDP SIT size 80 columns, 24/30 rows
0467      1800     vdp.tat.base              equ  >1800   ; VDP TAT base address
0468      9900     tv.colorize.reset         equ  >9900   ; Colorization off
0469      00FE     tv.1timeonly              equ  254     ; One-time only flag indicator
                   < stevie_b7.asm.16732
0017                       copy  "data.keymap.keys.asm"; Equates for keyboard mapping
     **** ****     > data.keymap.keys.asm
0001               * FILE......: data.keymap.keys.asm
0002               * Purpose...: Keyboard mapping
0003               
0004               
0005               *---------------------------------------------------------------
0006               * Keyboard scancodes - Numeric keys
0007               *-------------|---------------------|---------------------------
0008      0030     key.num.0     equ >30               ; 0
0009      0031     key.num.1     equ >31               ; 1
0010      0032     key.num.2     equ >32               ; 2
0011      0033     key.num.3     equ >33               ; 3
0012      0034     key.num.4     equ >34               ; 4
0013      0035     key.num.5     equ >35               ; 5
0014      0036     key.num.6     equ >36               ; 6
0015      0037     key.num.7     equ >37               ; 7
0016      0038     key.num.8     equ >38               ; 8
0017      0039     key.num.9     equ >39               ; 9
0018               *---------------------------------------------------------------
0019               * Keyboard scancodes - Letter keys
0020               *-------------|---------------------|---------------------------
0021      0042     key.uc.b      equ >42               ; B
0022      0043     key.uc.c      equ >43               ; C
0023      0045     key.uc.e      equ >45               ; E
0024      0046     key.uc.f      equ >46               ; F
0025      0048     key.uc.h      equ >48               ; H
0026      0049     key.uc.i      equ >49               ; I
0027      004E     key.uc.n      equ >4e               ; N
0028      0053     key.uc.s      equ >53               ; S
0029      004F     key.uc.o      equ >4f               ; O
0030      0050     key.uc.p      equ >50               ; P
0031      0051     key.uc.q      equ >51               ; Q
0032      00A2     key.lc.b      equ >a2               ; b
0033      00A5     key.lc.e      equ >a5               ; e
0034      00A6     key.lc.f      equ >a6               ; f
0035      00A8     key.lc.h      equ >a8               ; h
0036      006E     key.lc.n      equ >6e               ; n
0037      0073     key.lc.s      equ >73               ; s
0038      006F     key.lc.o      equ >6f               ; o
0039      0070     key.lc.p      equ >70               ; p
0040      0071     key.lc.q      equ >71               ; q
0041               *---------------------------------------------------------------
0042               * Keyboard scancodes - Function keys
0043               *-------------|---------------------|---------------------------
0044      00BC     key.fctn.0    equ >bc               ; fctn + 0
0045      0003     key.fctn.1    equ >03               ; fctn + 1
0046      0004     key.fctn.2    equ >04               ; fctn + 2
0047      0007     key.fctn.3    equ >07               ; fctn + 3
0048      0002     key.fctn.4    equ >02               ; fctn + 4
0049      000E     key.fctn.5    equ >0e               ; fctn + 5
0050      000C     key.fctn.6    equ >0c               ; fctn + 6
0051      0001     key.fctn.7    equ >01               ; fctn + 7
0052      0006     key.fctn.8    equ >06               ; fctn + 8
0053      000F     key.fctn.9    equ >0f               ; fctn + 9
0054      0000     key.fctn.a    equ >00               ; fctn + a
0055      00BE     key.fctn.b    equ >be               ; fctn + b
0056      0000     key.fctn.c    equ >00               ; fctn + c
0057      0009     key.fctn.d    equ >09               ; fctn + d
0058      000B     key.fctn.e    equ >0b               ; fctn + e
0059      0000     key.fctn.f    equ >00               ; fctn + f
0060      0000     key.fctn.g    equ >00               ; fctn + g
0061      00BF     key.fctn.h    equ >bf               ; fctn + h
0062      0000     key.fctn.i    equ >00               ; fctn + i
0063      00C0     key.fctn.j    equ >c0               ; fctn + j
0064      00C1     key.fctn.k    equ >c1               ; fctn + k
0065      00C2     key.fctn.l    equ >c2               ; fctn + l
0066      00C3     key.fctn.m    equ >c3               ; fctn + m
0067      00C4     key.fctn.n    equ >c4               ; fctn + n
0068      0000     key.fctn.o    equ >00               ; fctn + o
0069      0000     key.fctn.p    equ >00               ; fctn + p
0070      00C5     key.fctn.q    equ >c5               ; fctn + q
0071      0000     key.fctn.r    equ >00               ; fctn + r
0072      0008     key.fctn.s    equ >08               ; fctn + s
0073      0000     key.fctn.t    equ >00               ; fctn + t
0074      0000     key.fctn.u    equ >00               ; fctn + u
0075      007F     key.fctn.v    equ >7f               ; fctn + v
0076      007E     key.fctn.w    equ >7e               ; fctn + w
0077      000A     key.fctn.x    equ >0a               ; fctn + x
0078      00C6     key.fctn.y    equ >c6               ; fctn + y
0079      0000     key.fctn.z    equ >00               ; fctn + z
0080               *---------------------------------------------------------------
0081               * Keyboard scancodes - Function keys extra
0082               *---------------------------------------------------------------
0083      00B9     key.fctn.dot    equ >b9             ; fctn + .
0084      00B8     key.fctn.comma  equ >b8             ; fctn + ,
0085      0005     key.fctn.plus   equ >05             ; fctn + +
0086               *---------------------------------------------------------------
0087               * Keyboard scancodes - control keys
0088               *-------------|---------------------|---------------------------
0089      00B0     key.ctrl.0    equ >b0               ; ctrl + 0
0090      00B1     key.ctrl.1    equ >b1               ; ctrl + 1
0091      00B2     key.ctrl.2    equ >b2               ; ctrl + 2
0092      00B3     key.ctrl.3    equ >b3               ; ctrl + 3
0093      00B4     key.ctrl.4    equ >b4               ; ctrl + 4
0094      00B5     key.ctrl.5    equ >b5               ; ctrl + 5
0095      00B6     key.ctrl.6    equ >b6               ; ctrl + 6
0096      00B7     key.ctrl.7    equ >b7               ; ctrl + 7
0097      009E     key.ctrl.8    equ >9e               ; ctrl + 8
0098      009F     key.ctrl.9    equ >9f               ; ctrl + 9
0099      0081     key.ctrl.a    equ >81               ; ctrl + a
0100      0082     key.ctrl.b    equ >82               ; ctrl + b
0101      0083     key.ctrl.c    equ >83               ; ctrl + c
0102      0084     key.ctrl.d    equ >84               ; ctrl + d
0103      0085     key.ctrl.e    equ >85               ; ctrl + e
0104      0086     key.ctrl.f    equ >86               ; ctrl + f
0105      0087     key.ctrl.g    equ >87               ; ctrl + g
0106      0088     key.ctrl.h    equ >88               ; ctrl + h
0107      0089     key.ctrl.i    equ >89               ; ctrl + i
0108      008A     key.ctrl.j    equ >8a               ; ctrl + j
0109      008B     key.ctrl.k    equ >8b               ; ctrl + k
0110      008C     key.ctrl.l    equ >8c               ; ctrl + l
0111      008D     key.ctrl.m    equ >8d               ; ctrl + m
0112      008E     key.ctrl.n    equ >8e               ; ctrl + n
0113      008F     key.ctrl.o    equ >8f               ; ctrl + o
0114      0090     key.ctrl.p    equ >90               ; ctrl + p
0115      0091     key.ctrl.q    equ >91               ; ctrl + q
0116      0092     key.ctrl.r    equ >92               ; ctrl + r
0117      0093     key.ctrl.s    equ >93               ; ctrl + s
0118      0094     key.ctrl.t    equ >94               ; ctrl + t
0119      0095     key.ctrl.u    equ >95               ; ctrl + u
0120      0096     key.ctrl.v    equ >96               ; ctrl + v
0121      0097     key.ctrl.w    equ >97               ; ctrl + w
0122      0098     key.ctrl.x    equ >98               ; ctrl + x
0123      0099     key.ctrl.y    equ >99               ; ctrl + y
0124      009A     key.ctrl.z    equ >9a               ; ctrl + z
0125               *---------------------------------------------------------------
0126               * Keyboard scancodes - control keys extra
0127               *---------------------------------------------------------------
0128      009B     key.ctrl.dot    equ >9b             ; ctrl + .
0129      0080     key.ctrl.comma  equ >80             ; ctrl + ,
0130      009D     key.ctrl.plus   equ >9d             ; ctrl + +
0131      00BB     key.ctrl.slash  equ >bb             ; ctrl + /
0132      00F0     key.ctrl.space  equ >f0             ; ctrl + SPACE
0133               *---------------------------------------------------------------
0134               * Special keys
0135               *---------------------------------------------------------------
0136      000D     key.enter     equ >0d               ; enter
0137      0020     key.space     equ >20               ; space
                   < stevie_b7.asm.16732
0018               
0019               ***************************************************************
0020               * BANK 7
0021               ********|*****|*********************|**************************
0022      600E     bankid  equ   bank7.rom             ; Set bank identifier to current bank
0023                       aorg  >6000
0024                       save  >6000,>8000           ; Save bank
0025                       copy  "rom.header.asm"      ; Include cartridge header
     **** ****     > rom.header.asm
0001               * FILE......: rom.header.asm
0002               * Purpose...: Cartridge header
0003               
0004               *--------------------------------------------------------------
0005               * Cartridge header
0006               ********|*****|*********************|**************************
0007 6000 AA               byte  >aa                   ; 0  Standard header                   >6000
0008 6001   01             byte  >01                   ; 1  Version number
0009 6002 02               byte  >02                   ; 2  Number of programs (optional)     >6002
0010 6003   00             byte  0                     ; 3  Reserved ('R' = adv. mode FG99)
0011               
0012 6004 0000             data  >0000                 ; 4  \ Pointer to power-up list        >6004
0013                                                   ; 5  /
0014               
0015 6006 600C             data  rom.program1          ; 6  \ Pointer to program list         >6006
0016                                                   ; 7  /
0017               
0018 6008 0000             data  >0000                 ; 8  \ Pointer to DSR list             >6008
0019                                                   ; 9  /
0020               
0021 600A 0000             data  >0000                 ; 10 \ Pointer to subprogram list      >600a
0022                                                   ; 11 /
0023               
0024                       ;-----------------------------------------------------------------------
0025                       ; Program list entry
0026                       ;-----------------------------------------------------------------------
0027               rom.program1:
0028 600C 0000             data  >0000                 ; 12 \ Next program list entry         >600c
0029                                                   ; 13 / (no more items following)
0030               
0031 600E 6038             data  kickstart.resume      ; 14 \ Program address                 >600e
0032                                                   ; 15 /
0033               
0051               
0059               
0060 6010 13               byte  19
0061 6011   53             text  'STEVIE 1.3D (24X80)'
     6012 5445     
     6014 5649     
     6016 4520     
     6018 312E     
     601A 3344     
     601C 2028     
     601E 3234     
     6020 5838     
     6022 3029     
0062                       even
0063               
0065               
                   < stevie_b7.asm.16732
0026               
0027               ***************************************************************
0028               * Step 1: Switch to bank 0 (uniform code accross all banks)
0029               ********|*****|*********************|**************************
0030                       aorg  >6038
0031 6038 04E0  34         clr   @bank7.rom            ; Switch to bank 7 "Jonas"
     603A 600E     
0032 603C 0460  28         b     @tib.run.return.mon   ; Resume Stevie session
     603E 6414     
0033               
0034                       aorg  kickstart.code1       ; >6040
0035 6040 04E0  34         clr   @bank0.rom            ; Switch to bank 0 "Jill"
     6042 6000     
0036               ***************************************************************
0037               * Step 2: Satisfy assembler, must know relocated code
0038               ********|*****|*********************|**************************
0039                       aorg  >2000                 ; Relocate to >2000
0040                       copy  "runlib.asm"
     **** ****     > runlib.asm
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
0011               *                      2010-2022 by Filip Van Vooren
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
0027               * skip_sams                 equ  1  ; Skip support for SAMS memory expansion
0028               * skip_sams_layout          equ  1  ; Skip SAMS memory layout routine
0029               *
0030               * == VDP
0031               * skip_textmode             equ  1  ; Skip 40x24 textmode support
0032               * skip_vdp_f18a             equ  1  ; Skip f18a support
0033               * skip_vdp_hchar            equ  1  ; Skip hchar, xchar
0034               * skip_vdp_vchar            equ  1  ; Skip vchar, xvchar
0035               * skip_vdp_boxes            equ  1  ; Skip filbox, putbox
0036               * skip_vdp_hexsupport       equ  1  ; Skip mkhex, puthex
0037               * skip_vdp_bitmap           equ  1  ; Skip bitmap functions
0038               * skip_vdp_intscr           equ  1  ; Skip interrupt+screen on/off
0039               * skip_vdp_viewport         equ  1  ; Skip viewport functions
0040               * skip_vdp_yx2px_calc       equ  1  ; Skip YX to pixel calculation
0041               * skip_vdp_px2yx_calc       equ  1  ; Skip pixel to YX calculation
0042               * skip_vdp_sprites          equ  1  ; Skip sprites support
0043               * skip_vdp_cursor           equ  1  ; Skip cursor support
0044               *
0045               * == Sound & speech
0046               * skip_snd_player           equ  1  ; Skip inclusionm of sound player code
0047               * skip_speech_detection     equ  1  ; Skip speech synthesizer detection
0048               * skip_speech_player        equ  1  ; Skip inclusion of speech player code
0049               *
0050               * == Keyboard
0051               * skip_virtual_keyboard     equ  1  ; Skip virtual keyboard scann
0052               * skip_real_keyboard        equ  1  ; Skip real keyboard scan
0053               * use_rom0_kscan            equ  1  ; Use KSCAN in console ROM#0
0054               *
0055               * == Utilities
0056               * skip_random_generator     equ  1  ; Skip random generator functions
0057               * skip_cpu_rle_compress     equ  1  ; Skip CPU RLE compression
0058               * skip_cpu_rle_decompress   equ  1  ; Skip CPU RLE decompression
0059               * skip_vdp_rle_decompress   equ  1  ; Skip VDP RLE decompression
0060               * skip_cpu_hexsupport       equ  1  ; Skip mkhex, puthex
0061               * skip_cpu_numsupport       equ  1  ; Skip mknum, putnum, trimnum
0062               * skip_cpu_crc16            equ  1  ; Skip CPU memory CRC-16 calculation
0063               * skip_cpu_strings          equ  1  ; Skip string support utilities
0064               
0065               * == Kernel/Multitasking
0066               * skip_timer_alloc          equ  1  ; Skip support for timers allocation
0067               * skip_mem_paging           equ  1  ; Skip support for memory paging
0068               * skip_fio                  equ  1  ; Skip support for file I/O, dsrlnk
0069               *
0070               * == Startup behaviour
0071               * startup_backup_scrpad     equ  1  ; Backup scratchpad @>8300->83ff
0072               *                                   ; to pre-defined backup address
0073               * startup_keep_vdpmemory    equ  1  ; Do not clear VDP vram upon startup
0074               *******************************************************************************
0075               
0076               *//////////////////////////////////////////////////////////////
0077               *                       RUNLIB SETUP
0078               *//////////////////////////////////////////////////////////////
0079               
0080                       copy  "memsetup.equ"             ; runlib scratchpad memory setup
     **** ****     > memsetup.equ
0001               * FILE......: memsetup.equ
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
                   < runlib.asm
0081                       copy  "registers.equ"            ; runlib registers
     **** ****     > registers.equ
0001               * FILE......: registers.equ
0002               * Purpose...: Equates for registers
0003               
0004               ***************************************************************
0005               * Register usage
0006               * R0      **free not used**
0007               * R1      **free not used**
0008               * R2      Config register
0009               * R3      Extended config register
0010               * R4      Temporary register/variable tmp0
0011               * R5      Temporary register/variable tmp1
0012               * R6      Temporary register/variable tmp2
0013               * R7      Temporary register/variable tmp3
0014               * R8      Temporary register/variable tmp4
0015               * R9      Stack pointer
0016               * R10     Highest slot in use + Timer counter
0017               * R11     Subroutine return address
0018               * R12     CRU
0019               * R13     Copy of VDP status byte and counter for sound player
0020               * R14     Copy of VDP register #0 and VDP register #1 bytes
0021               * R15     VDP read/write address
0022               *--------------------------------------------------------------
0023               * Special purpose registers
0024               * R0      shift count
0025               * R12     CRU
0026               * R13     WS     - when using LWPI, BLWP, RTWP
0027               * R14     PC     - when using LWPI, BLWP, RTWP
0028               * R15     STATUS - when using LWPI, BLWP, RTWP
0029               ***************************************************************
0030               * Define registers
0031               ********|*****|*********************|**************************
0032      0000     r0      equ   0
0033      0001     r1      equ   1
0034      0002     r2      equ   2
0035      0003     r3      equ   3
0036      0004     r4      equ   4
0037      0005     r5      equ   5
0038      0006     r6      equ   6
0039      0007     r7      equ   7
0040      0008     r8      equ   8
0041      0009     r9      equ   9
0042      000A     r10     equ   10
0043      000B     r11     equ   11
0044      000C     r12     equ   12
0045      000D     r13     equ   13
0046      000E     r14     equ   14
0047      000F     r15     equ   15
0048               ***************************************************************
0049               * Define register equates
0050               ********|*****|*********************|**************************
0051      0002     config  equ   r2                    ; Config register
0052      0003     xconfig equ   r3                    ; Extended config register
0053      0004     tmp0    equ   r4                    ; Temp register 0
0054      0005     tmp1    equ   r5                    ; Temp register 1
0055      0006     tmp2    equ   r6                    ; Temp register 2
0056      0007     tmp3    equ   r7                    ; Temp register 3
0057      0008     tmp4    equ   r8                    ; Temp register 4
0058      0009     stack   equ   r9                    ; Stack pointer
0059      000E     vdpr01  equ   r14                   ; Copy of VDP#0 and VDP#1 bytes
0060      000F     vdprw   equ   r15                   ; Contains VDP read/write address
0061               ***************************************************************
0062               * Define MSB/LSB equates for registers
0063               ********|*****|*********************|**************************
0064      8300     r0hb    equ   ws1                   ; HI byte R0
0065      8301     r0lb    equ   ws1+1                 ; LO byte R0
0066      8302     r1hb    equ   ws1+2                 ; HI byte R1
0067      8303     r1lb    equ   ws1+3                 ; LO byte R1
0068      8304     r2hb    equ   ws1+4                 ; HI byte R2
0069      8305     r2lb    equ   ws1+5                 ; LO byte R2
0070      8306     r3hb    equ   ws1+6                 ; HI byte R3
0071      8307     r3lb    equ   ws1+7                 ; LO byte R3
0072      8308     r4hb    equ   ws1+8                 ; HI byte R4
0073      8309     r4lb    equ   ws1+9                 ; LO byte R4
0074      830A     r5hb    equ   ws1+10                ; HI byte R5
0075      830B     r5lb    equ   ws1+11                ; LO byte R5
0076      830C     r6hb    equ   ws1+12                ; HI byte R6
0077      830D     r6lb    equ   ws1+13                ; LO byte R6
0078      830E     r7hb    equ   ws1+14                ; HI byte R7
0079      830F     r7lb    equ   ws1+15                ; LO byte R7
0080      8310     r8hb    equ   ws1+16                ; HI byte R8
0081      8311     r8lb    equ   ws1+17                ; LO byte R8
0082      8312     r9hb    equ   ws1+18                ; HI byte R9
0083      8313     r9lb    equ   ws1+19                ; LO byte R9
0084      8314     r10hb   equ   ws1+20                ; HI byte R10
0085      8315     r10lb   equ   ws1+21                ; LO byte R10
0086      8316     r11hb   equ   ws1+22                ; HI byte R11
0087      8317     r11lb   equ   ws1+23                ; LO byte R11
0088      8318     r12hb   equ   ws1+24                ; HI byte R12
0089      8319     r12lb   equ   ws1+25                ; LO byte R12
0090      831A     r13hb   equ   ws1+26                ; HI byte R13
0091      831B     r13lb   equ   ws1+27                ; LO byte R13
0092      831C     r14hb   equ   ws1+28                ; HI byte R14
0093      831D     r14lb   equ   ws1+29                ; LO byte R14
0094      831E     r15hb   equ   ws1+30                ; HI byte R15
0095      831F     r15lb   equ   ws1+31                ; LO byte R15
0096               ********|*****|*********************|**************************
0097      8308     tmp0hb  equ   ws1+8                 ; HI byte R4
0098      8309     tmp0lb  equ   ws1+9                 ; LO byte R4
0099      830A     tmp1hb  equ   ws1+10                ; HI byte R5
0100      830B     tmp1lb  equ   ws1+11                ; LO byte R5
0101      830C     tmp2hb  equ   ws1+12                ; HI byte R6
0102      830D     tmp2lb  equ   ws1+13                ; LO byte R6
0103      830E     tmp3hb  equ   ws1+14                ; HI byte R7
0104      830F     tmp3lb  equ   ws1+15                ; LO byte R7
0105      8310     tmp4hb  equ   ws1+16                ; HI byte R8
0106      8311     tmp4lb  equ   ws1+17                ; LO byte R8
0107               ********|*****|*********************|**************************
0108      8314     btihi   equ   ws1+20                ; Highest slot in use (HI byte R10)
0109      831A     bvdpst  equ   ws1+26                ; Copy of VDP status register (HI byte R13)
0110      831C     vdpr0   equ   ws1+28                ; High byte of R14. Is VDP#0 byte
0111      831D     vdpr1   equ   ws1+29                ; Low byte  of R14. Is VDP#1 byte
0112               ***************************************************************
                   < runlib.asm
0082                       copy  "portaddr.equ"             ; runlib hardware port addresses
     **** ****     > portaddr.equ
0001               * FILE......: portaddr.equ
0002               * Purpose...: Equates for hardware port addresses and vectors
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
0018               
0019      000E     kscan   equ   >000e                 ; Address of KSCAN routine in console ROM 0
                   < runlib.asm
0083                       copy  "param.equ"                ; runlib parameters
     **** ****     > param.equ
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
                   < runlib.asm
0084                       copy  "classic99.equ"            ; classic99 emulator opcodes
     **** ****     > classic99.equ
0001               * FILE......: classic99.equ
0002               * Purpose...: Extra opcodes for the classic99 emulator
0003               
0004               ***************************************************************
0005               *              Extra opcodes for classic99
0006               ********|*****|*********************|**************************
0007      0110     c99_norm      equ  >0110            ; CPU normal
0008      0111     c99_ovrd      equ  >0111            ; CPU overdrive
0009      0112     c99_smax      equ  >0112            ; System Maximum
0010      0113     c99_brk       equ  >0113            ; Breakpoint
0011      0114     c99_quit      equ  >0114            ; Quit emulator
0012               *--------------------------------------------------------------
0013               * Attention:
0014               * Debug opcodes are part of a 3 words instruction!
0015               * See classic99 user manual for details on proper usage.
0016               *--------------------------------------------------------------
0017      0120     c99_dbgr0     equ  >0120            ; debug printf R0
0018      0121     c99_dbgr1     equ  >0121            ; debug printf R1
0019      0122     c99_dbgr2     equ  >0122            ; debug printf R2
0020      0123     c99_dbgr3     equ  >0123            ; debug printf R3
0021      0124     c99_dbgr4     equ  >0124            ; debug printf R4
0022      0125     c99_dbgr5     equ  >0125            ; debug printf R5
0023      0126     c99_dbgr6     equ  >0126            ; debug printf R6
0024      0127     c99_dbgr7     equ  >0127            ; debug printf R7
0025      0128     c99_dbgr8     equ  >0128            ; debug printf R8
0026      0129     c99_dbgr9     equ  >0129            ; debug printf R9
0027      012A     c99_dbgr10    equ  >012a            ; debug printf R10
0028      012B     c99_dbgr11    equ  >012b            ; debug printf R11
0029      012C     c99_dbgr12    equ  >012c            ; debug printf R12
0030      012D     c99_dbgr13    equ  >012d            ; debug printf R13
0031      012E     c99_dbgr14    equ  >012e            ; debug printf R14
0032      012F     c99_dbgr15    equ  >012f            ; debug printf R15
                   < runlib.asm
0085               
0089               
0090                       copy  "cpu_constants.asm"        ; Define constants for word/MSB/LSB
     **** ****     > cpu_constants.asm
0001               * FILE......: cpu_constants.asm
0002               * Purpose...: Constants used by Spectra2 and for own use
0003               
0004               ***************************************************************
0005               *                      Some constants
0006               ********|*****|*********************|**************************
0007               
0008               *--------------------------------------------------------------
0009               * Word values
0010               *--------------------------------------------------------------
0011               ;                                   ;       0123456789ABCDEF
0012 2000 0000     w$0000  data  >0000                 ; >0000 0000000000000000
0013 2002 0001     w$0001  data  >0001                 ; >0001 0000000000000001
0014 2004 0002     w$0002  data  >0002                 ; >0002 0000000000000010
0015 2006 0004     w$0004  data  >0004                 ; >0004 0000000000000100
0016 2008 0008     w$0008  data  >0008                 ; >0008 0000000000001000
0017 200A 0010     w$0010  data  >0010                 ; >0010 0000000000010000
0018 200C 0020     w$0020  data  >0020                 ; >0020 0000000000100000
0019 200E 0040     w$0040  data  >0040                 ; >0040 0000000001000000
0020 2010 0080     w$0080  data  >0080                 ; >0080 0000000010000000
0021 2012 0100     w$0100  data  >0100                 ; >0100 0000000100000000
0022 2014 0200     w$0200  data  >0200                 ; >0200 0000001000000000
0023 2016 0400     w$0400  data  >0400                 ; >0400 0000010000000000
0024 2018 0800     w$0800  data  >0800                 ; >0800 0000100000000000
0025 201A 1000     w$1000  data  >1000                 ; >1000 0001000000000000
0026 201C 2000     w$2000  data  >2000                 ; >2000 0010000000000000
0027 201E 4000     w$4000  data  >4000                 ; >4000 0100000000000000
0028 2020 8000     w$8000  data  >8000                 ; >8000 1000000000000000
0029 2022 FFFF     w$ffff  data  >ffff                 ; >ffff 1111111111111111
0030 2024 D000     w$d000  data  >d000                 ; >d000
0031               *--------------------------------------------------------------
0032               * Byte values - High byte (=MSB) for byte operations
0033               *--------------------------------------------------------------
0034      2000     hb$00   equ   w$0000                ; >0000
0035      2012     hb$01   equ   w$0100                ; >0100
0036      2014     hb$02   equ   w$0200                ; >0200
0037      2016     hb$04   equ   w$0400                ; >0400
0038      2018     hb$08   equ   w$0800                ; >0800
0039      201A     hb$10   equ   w$1000                ; >1000
0040      201C     hb$20   equ   w$2000                ; >2000
0041      201E     hb$40   equ   w$4000                ; >4000
0042      2020     hb$80   equ   w$8000                ; >8000
0043      2024     hb$d0   equ   w$d000                ; >d000
0044               *--------------------------------------------------------------
0045               * Byte values - Low byte (=LSB) for byte operations
0046               *--------------------------------------------------------------
0047      2000     lb$00   equ   w$0000                ; >0000
0048      2002     lb$01   equ   w$0001                ; >0001
0049      2004     lb$02   equ   w$0002                ; >0002
0050      2006     lb$04   equ   w$0004                ; >0004
0051      2008     lb$08   equ   w$0008                ; >0008
0052      200A     lb$10   equ   w$0010                ; >0010
0053      200C     lb$20   equ   w$0020                ; >0020
0054      200E     lb$40   equ   w$0040                ; >0040
0055      2010     lb$80   equ   w$0080                ; >0080
0056               *--------------------------------------------------------------
0057               * Bit values
0058               *--------------------------------------------------------------
0059               ;                                   ;       0123456789ABCDEF
0060      2002     wbit15  equ   w$0001                ; >0001 0000000000000001
0061      2004     wbit14  equ   w$0002                ; >0002 0000000000000010
0062      2006     wbit13  equ   w$0004                ; >0004 0000000000000100
0063      2008     wbit12  equ   w$0008                ; >0008 0000000000001000
0064      200A     wbit11  equ   w$0010                ; >0010 0000000000010000
0065      200C     wbit10  equ   w$0020                ; >0020 0000000000100000
0066      200E     wbit9   equ   w$0040                ; >0040 0000000001000000
0067      2010     wbit8   equ   w$0080                ; >0080 0000000010000000
0068      2012     wbit7   equ   w$0100                ; >0100 0000000100000000
0069      2014     wbit6   equ   w$0200                ; >0200 0000001000000000
0070      2016     wbit5   equ   w$0400                ; >0400 0000010000000000
0071      2018     wbit4   equ   w$0800                ; >0800 0000100000000000
0072      201A     wbit3   equ   w$1000                ; >1000 0001000000000000
0073      201C     wbit2   equ   w$2000                ; >2000 0010000000000000
0074      201E     wbit1   equ   w$4000                ; >4000 0100000000000000
0075      2020     wbit0   equ   w$8000                ; >8000 1000000000000000
                   < runlib.asm
0091                       copy  "config.equ"               ; Equates for bits in config register
     **** ****     > config.equ
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
0026               ********|*****|*********************|**************************
0027      201C     palon   equ   wbit2                 ; bit 2=1   (VDP9918 PAL version)
0028      2012     enusr   equ   wbit7                 ; bit 7=1   (Enable user hook)
0029      200E     enknl   equ   wbit9                 ; bit 9=1   (Enable kernel thread)
0030      200A     anykey  equ   wbit11                ; BIT 11 in the CONFIG register
0031               ***************************************************************
                   < runlib.asm
0092                       copy  "cpu_crash.asm"            ; CPU crash handler
     **** ****     > cpu_crash.asm
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
0038 2026 022B  22         ai    r11,-4                ; Remove opcode offset
     2028 FFFC     
0039               *--------------------------------------------------------------
0040               *    Save registers to high memory
0041               *--------------------------------------------------------------
0042 202A C800  38         mov   r0,@>ffe0
     202C FFE0     
0043 202E C801  38         mov   r1,@>ffe2
     2030 FFE2     
0044 2032 C802  38         mov   r2,@>ffe4
     2034 FFE4     
0045 2036 C803  38         mov   r3,@>ffe6
     2038 FFE6     
0046 203A C804  38         mov   r4,@>ffe8
     203C FFE8     
0047 203E C805  38         mov   r5,@>ffea
     2040 FFEA     
0048 2042 C806  38         mov   r6,@>ffec
     2044 FFEC     
0049 2046 C807  38         mov   r7,@>ffee
     2048 FFEE     
0050 204A C808  38         mov   r8,@>fff0
     204C FFF0     
0051 204E C809  38         mov   r9,@>fff2
     2050 FFF2     
0052 2052 C80A  38         mov   r10,@>fff4
     2054 FFF4     
0053 2056 C80B  38         mov   r11,@>fff6
     2058 FFF6     
0054 205A C80C  38         mov   r12,@>fff8
     205C FFF8     
0055 205E C80D  38         mov   r13,@>fffa
     2060 FFFA     
0056 2062 C80E  38         mov   r14,@>fffc
     2064 FFFC     
0057 2066 C80F  38         mov   r15,@>ffff
     2068 FFFF     
0058 206A 02A0  12         stwp  r0
0059 206C C800  38         mov   r0,@>ffdc
     206E FFDC     
0060 2070 02C0  12         stst  r0
0061 2072 C800  38         mov   r0,@>ffde
     2074 FFDE     
0062               *--------------------------------------------------------------
0063               *    Reset system
0064               *--------------------------------------------------------------
0065               cpu.crash.reset:
0066 2076 02E0  18         lwpi  ws1                   ; Activate workspace 1
     2078 8300     
0067 207A 04E0  34         clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     207C 8302     
0068 207E 0200  20         li    r0,>4a4a              ; Note that a crash occured (Flag = >4a4a)
     2080 4A4A     
0069 2082 0460  28         b     @runli1               ; Initialize system again (VDP, Memory, etc.)
     2084 2EE4     
0070               *--------------------------------------------------------------
0071               *    Show diagnostics after system reset
0072               *--------------------------------------------------------------
0073               cpu.crash.main:
0074                       ;------------------------------------------------------
0075                       ; Load "32x24" video mode & font
0076                       ;------------------------------------------------------
0077 2086 06A0  32         bl    @vidtab               ; Load video mode table into VDP
     2088 230C     
0078 208A 2206                   data graph1           ; \ i  p0 = pointer to video mode table
0079                                                   ; /
0080               
0081 208C 06A0  32         bl    @ldfnt
     208E 2374     
0082 2090 0900                   data >0900,fnopt3     ; Load font (upper & lower case)
     2092 000C     
0083               
0084 2094 06A0  32         bl    @filv
     2096 22A2     
0085 2098 0000                   data >0000,32,32*24   ; Clear screen
     209A 0020     
     209C 0300     
0086               
0087 209E 06A0  32         bl    @filv
     20A0 22A2     
0088 20A2 0380                   data >0380,>f0,32*24  ; Load color table
     20A4 00F0     
     20A6 0300     
0089                       ;------------------------------------------------------
0090                       ; Show crash address
0091                       ;------------------------------------------------------
0092 20A8 06A0  32         bl    @putat                ; Show crash message
     20AA 2456     
0093 20AC 0000                   data >0000,cpu.crash.msg.crashed
     20AE 2192     
0094               
0095 20B0 06A0  32         bl    @puthex               ; Put hex value on screen
     20B2 29B0     
0096 20B4 0015                   byte 0,21             ; \ i  p0 = YX position
0097 20B6 FFF6                   data >fff6            ; | i  p1 = Pointer to 16 bit word
0098 20B8 A100                   data rambuf           ; | i  p2 = Pointer to ram buffer
0099 20BA 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0100                                                   ; /         LSB offset for ASCII digit 0-9
0101                       ;------------------------------------------------------
0102                       ; Show caller address
0103                       ;------------------------------------------------------
0104 20BC 06A0  32         bl    @putat                ; Show caller message
     20BE 2456     
0105 20C0 0100                   data >0100,cpu.crash.msg.caller
     20C2 21A8     
0106               
0107 20C4 06A0  32         bl    @puthex               ; Put hex value on screen
     20C6 29B0     
0108 20C8 0115                   byte 1,21             ; \ i  p0 = YX position
0109 20CA FFCE                   data >ffce            ; | i  p1 = Pointer to 16 bit word
0110 20CC A100                   data rambuf           ; | i  p2 = Pointer to ram buffer
0111 20CE 4130                   byte 65,48            ; | i  p3 = MSB offset for ASCII digit a-f
0112                                                   ; /         LSB offset for ASCII digit 0-9
0113                       ;------------------------------------------------------
0114                       ; Display labels
0115                       ;------------------------------------------------------
0116 20D0 06A0  32         bl    @putat
     20D2 2456     
0117 20D4 0300                   byte 3,0
0118 20D6 21C4                   data cpu.crash.msg.wp
0119 20D8 06A0  32         bl    @putat
     20DA 2456     
0120 20DC 0400                   byte 4,0
0121 20DE 21CA                   data cpu.crash.msg.st
0122 20E0 06A0  32         bl    @putat
     20E2 2456     
0123 20E4 1600                   byte 22,0
0124 20E6 21D0                   data cpu.crash.msg.source
0125 20E8 06A0  32         bl    @putat
     20EA 2456     
0126 20EC 1700                   byte 23,0
0127 20EE 21EC                   data cpu.crash.msg.id
0128                       ;------------------------------------------------------
0129                       ; Show crash registers WP, ST, R0 - R15
0130                       ;------------------------------------------------------
0131 20F0 06A0  32         bl    @at                   ; Put cursor at YX
     20F2 26DA     
0132 20F4 0304                   byte 3,4              ; \ i p0 = YX position
0133                                                   ; /
0134               
0135 20F6 0204  20         li    tmp0,>ffdc            ; Crash registers >ffdc - >ffff
     20F8 FFDC     
0136 20FA 04C6  14         clr   tmp2                  ; Loop counter
0137               
0138               cpu.crash.showreg:
0139 20FC C034  30         mov   *tmp0+,r0             ; Move crash register content to r0
0140               
0141 20FE 0649  14         dect  stack
0142 2100 C644  30         mov   tmp0,*stack           ; Push tmp0
0143 2102 0649  14         dect  stack
0144 2104 C645  30         mov   tmp1,*stack           ; Push tmp1
0145 2106 0649  14         dect  stack
0146 2108 C646  30         mov   tmp2,*stack           ; Push tmp2
0147                       ;------------------------------------------------------
0148                       ; Display crash register number
0149                       ;------------------------------------------------------
0150               cpu.crash.showreg.label:
0151 210A C046  18         mov   tmp2,r1               ; Save register number
0152 210C 0286  22         ci    tmp2,1                ; Skip labels WP/ST?
     210E 0001     
0153 2110 1220  14         jle   cpu.crash.showreg.content
0154                                                   ; Yes, skip
0155               
0156 2112 0641  14         dect  r1                    ; Adjust because of "dummy" WP/ST registers
0157 2114 06A0  32         bl    @mknum
     2116 29BA     
0158 2118 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0159 211A A100                   data rambuf           ; | i  p1 = Pointer to ram buffer
0160 211C 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0161                                                   ; /         LSB offset for ASCII digit 0-9
0162               
0163 211E 06A0  32         bl    @setx                 ; Set cursor X position
     2120 26F0     
0164 2122 0000                   data 0                ; \ i  p0 =  Cursor Y position
0165                                                   ; /
0166               
0167 2124 0204  20         li    tmp0,>0400            ; Set string length-prefix byte
     2126 0400     
0168 2128 D804  38         movb  tmp0,@rambuf          ;
     212A A100     
0169               
0170 212C 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     212E 2432     
0171 2130 A100                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0172                                                   ; /
0173               
0174 2132 06A0  32         bl    @setx                 ; Set cursor X position
     2134 26F0     
0175 2136 0002                   data 2                ; \ i  p0 =  Cursor Y position
0176                                                   ; /
0177               
0178 2138 0281  22         ci    r1,10
     213A 000A     
0179 213C 1102  14         jlt   !
0180 213E 0620  34         dec   @wyx                  ; x=x-1
     2140 832A     
0181               
0182 2142 06A0  32 !       bl    @putstr
     2144 2432     
0183 2146 21BE                   data cpu.crash.msg.r
0184               
0185 2148 06A0  32         bl    @mknum
     214A 29BA     
0186 214C 8302                   data r1hb             ; \ i  p0 = Pointer to 16 bit unsigned word
0187 214E A100                   data rambuf           ; | i  p1 = Pointer to ram buffer
0188 2150 3020                   byte 48,32            ; | i  p2 = MSB offset for ASCII digit a-f
0189                                                   ; /         LSB offset for ASCII digit 0-9
0190                       ;------------------------------------------------------
0191                       ; Display crash register content
0192                       ;------------------------------------------------------
0193               cpu.crash.showreg.content:
0194 2152 06A0  32         bl    @mkhex                ; Convert hex word to string
     2154 292C     
0195 2156 8300                   data r0hb             ; \ i  p0 = Pointer to 16 bit word
0196 2158 A100                   data rambuf           ; | i  p1 = Pointer to ram buffer
0197 215A 4130                   byte 65,48            ; | i  p2 = MSB offset for ASCII digit a-f
0198                                                   ; /         LSB offset for ASCII digit 0-9
0199               
0200 215C 06A0  32         bl    @setx                 ; Set cursor X position
     215E 26F0     
0201 2160 0004                   data 4                ; \ i  p0 =  Cursor Y position
0202                                                   ; /
0203               
0204 2162 06A0  32         bl    @putstr               ; Put '  >'
     2164 2432     
0205 2166 21C0                   data cpu.crash.msg.marker
0206               
0207 2168 06A0  32         bl    @setx                 ; Set cursor X position
     216A 26F0     
0208 216C 0007                   data 7                ; \ i  p0 =  Cursor Y position
0209                                                   ; /
0210               
0211 216E 0204  20         li    tmp0,>0400            ; Set string length-prefix byte
     2170 0400     
0212 2172 D804  38         movb  tmp0,@rambuf          ;
     2174 A100     
0213               
0214 2176 06A0  32         bl    @putstr               ; Put length-byte prefixed string at current YX
     2178 2432     
0215 217A A100                   data rambuf           ; \ i  p0 = Pointer to ram buffer
0216                                                   ; /
0217               
0218 217C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0219 217E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0220 2180 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0221               
0222 2182 06A0  32         bl    @down                 ; y=y+1
     2184 26E0     
0223               
0224 2186 0586  14         inc   tmp2
0225 2188 0286  22         ci    tmp2,17
     218A 0011     
0226 218C 12B7  14         jle   cpu.crash.showreg     ; Show next register
0227                       ;------------------------------------------------------
0228                       ; Kernel takes over
0229                       ;------------------------------------------------------
0230 218E 0460  28         b     @cpu.crash.showbank   ; Expected to be included in
     2190 7F00     
0231               
0232               
0233               cpu.crash.msg.crashed
0234 2192 15               byte  21
0235 2193   53             text  'System crashed near >'
     2194 7973     
     2196 7465     
     2198 6D20     
     219A 6372     
     219C 6173     
     219E 6865     
     21A0 6420     
     21A2 6E65     
     21A4 6172     
     21A6 203E     
0236                       even
0237               
0238               cpu.crash.msg.caller
0239 21A8 15               byte  21
0240 21A9   43             text  'Caller address near >'
     21AA 616C     
     21AC 6C65     
     21AE 7220     
     21B0 6164     
     21B2 6472     
     21B4 6573     
     21B6 7320     
     21B8 6E65     
     21BA 6172     
     21BC 203E     
0241                       even
0242               
0243               cpu.crash.msg.r
0244 21BE 01               byte  1
0245 21BF   52             text  'R'
0246                       even
0247               
0248               cpu.crash.msg.marker
0249 21C0 03               byte  3
0250 21C1   20             text  '  >'
     21C2 203E     
0251                       even
0252               
0253               cpu.crash.msg.wp
0254 21C4 04               byte  4
0255 21C5   2A             text  '**WP'
     21C6 2A57     
     21C8 50       
0256                       even
0257               
0258               cpu.crash.msg.st
0259 21CA 04               byte  4
0260 21CB   2A             text  '**ST'
     21CC 2A53     
     21CE 54       
0261                       even
0262               
0263               cpu.crash.msg.source
0264 21D0 1B               byte  27
0265 21D1   53             text  'Source    stevie_b7.lst.asm'
     21D2 6F75     
     21D4 7263     
     21D6 6520     
     21D8 2020     
     21DA 2073     
     21DC 7465     
     21DE 7669     
     21E0 655F     
     21E2 6237     
     21E4 2E6C     
     21E6 7374     
     21E8 2E61     
     21EA 736D     
0266                       even
0267               
0268               cpu.crash.msg.id
0269 21EC 18               byte  24
0270 21ED   42             text  'Build-ID  220303-2012240'
     21EE 7569     
     21F0 6C64     
     21F2 2D49     
     21F4 4420     
     21F6 2032     
     21F8 3230     
     21FA 3330     
     21FC 332D     
     21FE 3230     
     2200 3132     
     2202 3234     
     2204 30       
0271                       even
0272               
                   < runlib.asm
0093                       copy  "vdp_tables.asm"           ; Data used by runtime library
     **** ****     > vdp_tables.asm
0001               * FILE......: vdp_tables.a99
0002               * Purpose...: Video mode tables
0003               
0004               ***************************************************************
0005               * Graphics mode 1 (32 columns/24 rows)
0006               *--------------------------------------------------------------
0007 2206 00E2     graph1  byte  >00,>e2,>00,>0e,>01,>06,>02,SPFBCK,0,32
     2208 000E     
     220A 0106     
     220C 0204     
     220E 0020     
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
0032 2210 00F2     tx4024  byte  >00,>f2,>00,>0e,>01,>06,>00,SPFCLR,0,40
     2212 000E     
     2214 0106     
     2216 00F4     
     2218 0028     
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
0058 221A 04F0     tx8024  byte  >04,>f0,>00,>3f,>02,>40,>03,SPFCLR,0,80
     221C 003F     
     221E 0240     
     2220 03F4     
     2222 0050     
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
                   < runlib.asm
0094                       copy  "basic_cpu_vdp.asm"        ; Basic CPU & VDP functions
     **** ****     > basic_cpu_vdp.asm
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
0013 2224 0606     mccode  data  >0606                 ; |         dec   r6 (tmp2)
0014 2226 16FD             data  >16fd                 ; |         jne   mcloop
0015 2228 045B             data  >045b                 ; /         b     *r11
0016               *--------------------------------------------------------------
0017               * ; Machine code for reading from the speech synthesizer
0018               * ; The SRC instruction takes 12 uS for execution in scratchpad RAM.
0019               * ; Is required for the 12 uS delay. It destroys R5.
0020               *--------------------------------------------------------------
0021 222A D114     spcode  data  >d114                 ; \         movb  *r4,r4 (tmp0)
0022 222C 0BC5             data  >0bc5                 ; /         src   r5,12  (tmp1)
0023                       even
0024               
0025               
0026               ***************************************************************
0027               * loadmc - Load machine code into scratchpad  >8322 - >8328
0028               ***************************************************************
0029               *  bl  @loadmc
0030               *--------------------------------------------------------------
0031               *  REMARKS
0032               *  Machine instruction in location @>8320 will be set by
0033               *  SP2 copy/fill routine that is called later on.
0034               ********|*****|*********************|**************************
0035               loadmc:
0036 222E 0201  20         li    r1,mccode             ; Machinecode to patch
     2230 2224     
0037 2232 0202  20         li    r2,mcloop+2           ; Scratch-pad reserved for machine code
     2234 8322     
0038 2236 CCB1  46         mov   *r1+,*r2+             ; Copy 1st instruction
0039 2238 CCB1  46         mov   *r1+,*r2+             ; Copy 2nd instruction
0040 223A CCB1  46         mov   *r1+,*r2+             ; Copy 3rd instruction
0041 223C 045B  20         b     *r11                  ; Return to caller
0042               
0043               
0044               *//////////////////////////////////////////////////////////////
0045               *                    STACK SUPPORT FUNCTIONS
0046               *//////////////////////////////////////////////////////////////
0047               
0048               ***************************************************************
0049               * POPR. - Pop registers & return to caller
0050               ***************************************************************
0051               *  B  @POPRG.
0052               *--------------------------------------------------------------
0053               *  REMARKS
0054               *  R11 must be at stack bottom
0055               ********|*****|*********************|**************************
0056 223E C0F9  30 popr3   mov   *stack+,r3
0057 2240 C0B9  30 popr2   mov   *stack+,r2
0058 2242 C079  30 popr1   mov   *stack+,r1
0059 2244 C039  30 popr0   mov   *stack+,r0
0060 2246 C2F9  30 poprt   mov   *stack+,r11
0061 2248 045B  20         b     *r11
0062               
0063               
0064               
0065               *//////////////////////////////////////////////////////////////
0066               *                   MEMORY FILL FUNCTIONS
0067               *//////////////////////////////////////////////////////////////
0068               
0069               ***************************************************************
0070               * FILM - Fill CPU memory with byte
0071               ***************************************************************
0072               *  bl   @film
0073               *  data P0,P1,P2
0074               *--------------------------------------------------------------
0075               *  P0 = Memory start address
0076               *  P1 = Byte to fill
0077               *  P2 = Number of bytes to fill
0078               *--------------------------------------------------------------
0079               *  bl   @xfilm
0080               *
0081               *  TMP0 = Memory start address
0082               *  TMP1 = Byte to fill
0083               *  TMP2 = Number of bytes to fill
0084               ********|*****|*********************|**************************
0085 224A C13B  30 film    mov   *r11+,tmp0            ; Memory start
0086 224C C17B  30         mov   *r11+,tmp1            ; Byte to fill
0087 224E C1BB  30         mov   *r11+,tmp2            ; Repeat count
0088               *--------------------------------------------------------------
0089               * Assert
0090               *--------------------------------------------------------------
0091 2250 C1C6  18 xfilm   mov   tmp2,tmp3             ; Bytes to fill = 0 ?
0092 2252 1604  14         jne   filchk                ; No, continue checking
0093               
0094 2254 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2256 FFCE     
0095 2258 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     225A 2026     
0096               *--------------------------------------------------------------
0097               *       Check: 1 byte fill
0098               *--------------------------------------------------------------
0099 225C D820  54 filchk  movb  @tmp1lb,@tmp1hb       ; Duplicate value
     225E 830B     
     2260 830A     
0100               
0101 2262 0286  22         ci    tmp2,1                ; Bytes to fill = 1 ?
     2264 0001     
0102 2266 1602  14         jne   filchk2
0103 2268 DD05  32         movb  tmp1,*tmp0+
0104 226A 045B  20         b     *r11                  ; Exit
0105               *--------------------------------------------------------------
0106               *       Check: 2 byte fill
0107               *--------------------------------------------------------------
0108 226C 0286  22 filchk2 ci    tmp2,2                ; Byte to fill = 2 ?
     226E 0002     
0109 2270 1603  14         jne   filchk3
0110 2272 DD05  32         movb  tmp1,*tmp0+           ; Deal with possible uneven start address
0111 2274 DD05  32         movb  tmp1,*tmp0+
0112 2276 045B  20         b     *r11                  ; Exit
0113               *--------------------------------------------------------------
0114               *       Check: Handle uneven start address
0115               *--------------------------------------------------------------
0116 2278 C1C4  18 filchk3 mov   tmp0,tmp3
0117 227A 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     227C 0001     
0118 227E 1305  14         jeq   fil16b
0119 2280 DD05  32         movb  tmp1,*tmp0+           ; Copy 1st byte
0120 2282 0606  14         dec   tmp2
0121 2284 0286  22         ci    tmp2,2                ; Do we only have 1 word left?
     2286 0002     
0122 2288 13F1  14         jeq   filchk2               ; Yes, copy word and exit
0123               *--------------------------------------------------------------
0124               *       Fill memory with 16 bit words
0125               *--------------------------------------------------------------
0126 228A C1C6  18 fil16b  mov   tmp2,tmp3
0127 228C 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     228E 0001     
0128 2290 1301  14         jeq   dofill
0129 2292 0606  14         dec   tmp2                  ; Make TMP2 even
0130 2294 CD05  34 dofill  mov   tmp1,*tmp0+
0131 2296 0646  14         dect  tmp2
0132 2298 16FD  14         jne   dofill
0133               *--------------------------------------------------------------
0134               * Fill last byte if ODD
0135               *--------------------------------------------------------------
0136 229A C1C7  18         mov   tmp3,tmp3
0137 229C 1301  14         jeq   fil.exit
0138 229E DD05  32         movb  tmp1,*tmp0+
0139               fil.exit:
0140 22A0 045B  20         b     *r11
0141               
0142               
0143               ***************************************************************
0144               * FILV - Fill VRAM with byte
0145               ***************************************************************
0146               *  BL   @FILV
0147               *  DATA P0,P1,P2
0148               *--------------------------------------------------------------
0149               *  P0 = VDP start address
0150               *  P1 = Byte to fill
0151               *  P2 = Number of bytes to fill
0152               *--------------------------------------------------------------
0153               *  BL   @XFILV
0154               *
0155               *  TMP0 = VDP start address
0156               *  TMP1 = Byte to fill
0157               *  TMP2 = Number of bytes to fill
0158               ********|*****|*********************|**************************
0159 22A2 C13B  30 filv    mov   *r11+,tmp0            ; Memory start
0160 22A4 C17B  30         mov   *r11+,tmp1            ; Byte to fill
0161 22A6 C1BB  30         mov   *r11+,tmp2            ; Repeat count
0162               *--------------------------------------------------------------
0163               *    Setup VDP write address
0164               *--------------------------------------------------------------
0165 22A8 0264  22 xfilv   ori   tmp0,>4000
     22AA 4000     
0166 22AC 06C4  14         swpb  tmp0
0167 22AE D804  38         movb  tmp0,@vdpa
     22B0 8C02     
0168 22B2 06C4  14         swpb  tmp0
0169 22B4 D804  38         movb  tmp0,@vdpa
     22B6 8C02     
0170               *--------------------------------------------------------------
0171               *    Fill bytes in VDP memory
0172               *--------------------------------------------------------------
0173 22B8 020F  20         li    r15,vdpw              ; Set VDP write address
     22BA 8C00     
0174 22BC 06C5  14         swpb  tmp1
0175 22BE C820  54         mov   @filzz,@mcloop        ; Setup move command
     22C0 22C8     
     22C2 8320     
0176 22C4 0460  28         b     @mcloop               ; Write data to VDP
     22C6 8320     
0177               *--------------------------------------------------------------
0181 22C8 D7C5     filzz   data  >d7c5                 ; MOVB TMP1,*R15
0183               
0184               
0185               
0186               *//////////////////////////////////////////////////////////////
0187               *                  VDP LOW LEVEL FUNCTIONS
0188               *//////////////////////////////////////////////////////////////
0189               
0190               ***************************************************************
0191               * VDWA / VDRA - Setup VDP write or read address
0192               ***************************************************************
0193               *  BL   @VDWA
0194               *
0195               *  TMP0 = VDP destination address for write
0196               *--------------------------------------------------------------
0197               *  BL   @VDRA
0198               *
0199               *  TMP0 = VDP source address for read
0200               ********|*****|*********************|**************************
0201 22CA 0264  22 vdwa    ori   tmp0,>4000            ; Prepare VDP address for write
     22CC 4000     
0202 22CE 06C4  14 vdra    swpb  tmp0
0203 22D0 D804  38         movb  tmp0,@vdpa
     22D2 8C02     
0204 22D4 06C4  14         swpb  tmp0
0205 22D6 D804  38         movb  tmp0,@vdpa            ; Set VDP address
     22D8 8C02     
0206 22DA 045B  20         b     *r11                  ; Exit
0207               
0208               ***************************************************************
0209               * VPUTB - VDP put single byte
0210               ***************************************************************
0211               *  BL @VPUTB
0212               *  DATA P0,P1
0213               *--------------------------------------------------------------
0214               *  P0 = VDP target address
0215               *  P1 = Byte to write
0216               ********|*****|*********************|**************************
0217 22DC C13B  30 vputb   mov   *r11+,tmp0            ; Get VDP target address
0218 22DE C17B  30         mov   *r11+,tmp1            ; Get byte to write
0219               *--------------------------------------------------------------
0220               * Set VDP write address
0221               *--------------------------------------------------------------
0222 22E0 0264  22 xvputb  ori   tmp0,>4000            ; Prepare VDP address for write
     22E2 4000     
0223 22E4 06C4  14         swpb  tmp0                  ; \
0224 22E6 D804  38         movb  tmp0,@vdpa            ; | Set VDP write address
     22E8 8C02     
0225 22EA 06C4  14         swpb  tmp0                  ; | inlined @vdwa call
0226 22EC D804  38         movb  tmp0,@vdpa            ; /
     22EE 8C02     
0227               *--------------------------------------------------------------
0228               * Write byte
0229               *--------------------------------------------------------------
0230 22F0 06C5  14         swpb  tmp1                  ; LSB to MSB
0231 22F2 D7C5  30         movb  tmp1,*r15             ; Write byte
0232 22F4 045B  20         b     *r11                  ; Exit
0233               
0234               
0235               ***************************************************************
0236               * VGETB - VDP get single byte
0237               ***************************************************************
0238               *  bl   @vgetb
0239               *  data p0
0240               *--------------------------------------------------------------
0241               *  P0 = VDP source address
0242               *--------------------------------------------------------------
0243               *  bl   @xvgetb
0244               *
0245               *  tmp0 = VDP source address
0246               *--------------------------------------------------------------
0247               *  Output:
0248               *  tmp0 MSB = >00
0249               *  tmp0 LSB = VDP byte read
0250               ********|*****|*********************|**************************
0251 22F6 C13B  30 vgetb   mov   *r11+,tmp0            ; Get VDP source address
0252               *--------------------------------------------------------------
0253               * Set VDP read address
0254               *--------------------------------------------------------------
0255 22F8 06C4  14 xvgetb  swpb  tmp0                  ; \
0256 22FA D804  38         movb  tmp0,@vdpa            ; | Set VDP read address
     22FC 8C02     
0257 22FE 06C4  14         swpb  tmp0                  ; | inlined @vdra call
0258 2300 D804  38         movb  tmp0,@vdpa            ; /
     2302 8C02     
0259               *--------------------------------------------------------------
0260               * Read byte
0261               *--------------------------------------------------------------
0262 2304 D120  34         movb  @vdpr,tmp0            ; Read byte
     2306 8800     
0263 2308 0984  56         srl   tmp0,8                ; Right align
0264 230A 045B  20         b     *r11                  ; Exit
0265               
0266               
0267               ***************************************************************
0268               * VIDTAB - Dump videomode table
0269               ***************************************************************
0270               *  BL   @VIDTAB
0271               *  DATA P0
0272               *--------------------------------------------------------------
0273               *  P0 = Address of video mode table
0274               *--------------------------------------------------------------
0275               *  BL   @XIDTAB
0276               *
0277               *  TMP0 = Address of video mode table
0278               *--------------------------------------------------------------
0279               *  Remarks
0280               *  TMP1 = MSB is the VDP target register
0281               *         LSB is the value to write
0282               ********|*****|*********************|**************************
0283 230C C13B  30 vidtab  mov   *r11+,tmp0            ; Get video mode table
0284 230E C394  26 xidtab  mov   *tmp0,r14             ; Store copy of VDP#0 and #1 in RAM
0285               *--------------------------------------------------------------
0286               * Calculate PNT base address
0287               *--------------------------------------------------------------
0288 2310 C144  18         mov   tmp0,tmp1
0289 2312 05C5  14         inct  tmp1
0290 2314 D155  26         movb  *tmp1,tmp1            ; Get value for VDP#2
0291 2316 0245  22         andi  tmp1,>ff00            ; Only keep MSB
     2318 FF00     
0292 231A 0A25  56         sla   tmp1,2                ; TMP1 *= 400
0293 231C C805  38         mov   tmp1,@wbase           ; Store calculated base
     231E 8328     
0294               *--------------------------------------------------------------
0295               * Dump VDP shadow registers
0296               *--------------------------------------------------------------
0297 2320 0205  20         li    tmp1,>8000            ; Start with VDP register 0
     2322 8000     
0298 2324 0206  20         li    tmp2,8
     2326 0008     
0299 2328 D834  48 vidta1  movb  *tmp0+,@tmp1lb        ; Write value to VDP register
     232A 830B     
0300 232C 06C5  14         swpb  tmp1
0301 232E D805  38         movb  tmp1,@vdpa
     2330 8C02     
0302 2332 06C5  14         swpb  tmp1
0303 2334 D805  38         movb  tmp1,@vdpa
     2336 8C02     
0304 2338 0225  22         ai    tmp1,>0100
     233A 0100     
0305 233C 0606  14         dec   tmp2
0306 233E 16F4  14         jne   vidta1                ; Next register
0307 2340 C814  46         mov   *tmp0,@wcolmn         ; Store # of columns per row
     2342 833A     
0308 2344 045B  20         b     *r11
0309               
0310               
0311               ***************************************************************
0312               * PUTVR  - Put single VDP register
0313               ***************************************************************
0314               *  BL   @PUTVR
0315               *  DATA P0
0316               *--------------------------------------------------------------
0317               *  P0 = MSB is the VDP target register
0318               *       LSB is the value to write
0319               *--------------------------------------------------------------
0320               *  BL   @PUTVRX
0321               *
0322               *  TMP0 = MSB is the VDP target register
0323               *         LSB is the value to write
0324               ********|*****|*********************|**************************
0325 2346 C13B  30 putvr   mov   *r11+,tmp0
0326 2348 0264  22 putvrx  ori   tmp0,>8000
     234A 8000     
0327 234C 06C4  14         swpb  tmp0
0328 234E D804  38         movb  tmp0,@vdpa
     2350 8C02     
0329 2352 06C4  14         swpb  tmp0
0330 2354 D804  38         movb  tmp0,@vdpa
     2356 8C02     
0331 2358 045B  20         b     *r11
0332               
0333               
0334               ***************************************************************
0335               * PUTV01  - Put VDP registers #0 and #1
0336               ***************************************************************
0337               *  BL   @PUTV01
0338               ********|*****|*********************|**************************
0339 235A C20B  18 putv01  mov   r11,tmp4              ; Save R11
0340 235C C10E  18         mov   r14,tmp0
0341 235E 0984  56         srl   tmp0,8
0342 2360 06A0  32         bl    @putvrx               ; Write VR#0
     2362 2348     
0343 2364 0204  20         li    tmp0,>0100
     2366 0100     
0344 2368 D820  54         movb  @r14lb,@tmp0lb
     236A 831D     
     236C 8309     
0345 236E 06A0  32         bl    @putvrx               ; Write VR#1
     2370 2348     
0346 2372 0458  20         b     *tmp4                 ; Exit
0347               
0348               
0349               ***************************************************************
0350               * LDFNT - Load TI-99/4A font from GROM into VDP
0351               ***************************************************************
0352               *  BL   @LDFNT
0353               *  DATA P0,P1
0354               *--------------------------------------------------------------
0355               *  P0 = VDP Target address
0356               *  P1 = Font options
0357               *--------------------------------------------------------------
0358               * Uses registers tmp0-tmp4
0359               ********|*****|*********************|**************************
0360 2374 C20B  18 ldfnt   mov   r11,tmp4              ; Save R11
0361 2376 05CB  14         inct  r11                   ; Get 2nd parameter (font options)
0362 2378 C11B  26         mov   *r11,tmp0             ; Get P0
0363 237A 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     237C 7FFF     
0364 237E 2120  38         coc   @wbit0,tmp0
     2380 2020     
0365 2382 1604  14         jne   ldfnt1
0366 2384 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2386 8000     
0367 2388 0244  22         andi  tmp0,>7fff            ; Parameter value bit 0=0
     238A 7FFF     
0368               *--------------------------------------------------------------
0369               * Read font table address from GROM into tmp1
0370               *--------------------------------------------------------------
0371 238C C124  34 ldfnt1  mov   @tmp006(tmp0),tmp0    ; Load GROM index address into tmp0
     238E 23F6     
0372 2390 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 1 for reading
     2392 9C02     
0373 2394 06C4  14         swpb  tmp0
0374 2396 D804  38         movb  tmp0,@grmwa           ; Setup GROM source byte 2 for reading
     2398 9C02     
0375 239A D160  34         movb  @grmrd,tmp1           ; Read font table address byte 1
     239C 9800     
0376 239E 06C5  14         swpb  tmp1
0377 23A0 D160  34         movb  @grmrd,tmp1           ; Read font table address byte 2
     23A2 9800     
0378 23A4 06C5  14         swpb  tmp1
0379               *--------------------------------------------------------------
0380               * Setup GROM source address from tmp1
0381               *--------------------------------------------------------------
0382 23A6 D805  38         movb  tmp1,@grmwa
     23A8 9C02     
0383 23AA 06C5  14         swpb  tmp1
0384 23AC D805  38         movb  tmp1,@grmwa           ; Setup GROM address for reading
     23AE 9C02     
0385               *--------------------------------------------------------------
0386               * Setup VDP target address
0387               *--------------------------------------------------------------
0388 23B0 C118  26         mov   *tmp4,tmp0            ; Get P1 (VDP destination)
0389 23B2 06A0  32         bl    @vdwa                 ; Setup VDP destination address
     23B4 22CA     
0390 23B6 05C8  14         inct  tmp4                  ; R11=R11+2
0391 23B8 C158  26         mov   *tmp4,tmp1            ; Get font options into TMP1
0392 23BA 0245  22         andi  tmp1,>7fff            ; Parameter value bit 0=0
     23BC 7FFF     
0393 23BE C1A5  34         mov   @tmp006+2(tmp1),tmp2  ; Get number of patterns to copy
     23C0 23F8     
0394 23C2 C165  34         mov   @tmp006+4(tmp1),tmp1  ; 7 or 8 byte pattern ?
     23C4 23FA     
0395               *--------------------------------------------------------------
0396               * Copy from GROM to VRAM
0397               *--------------------------------------------------------------
0398 23C6 0B15  56 ldfnt2  src   tmp1,1                ; Carry set ?
0399 23C8 1812  14         joc   ldfnt4                ; Yes, go insert a >00
0400 23CA D120  34         movb  @grmrd,tmp0
     23CC 9800     
0401               *--------------------------------------------------------------
0402               *   Make font fat
0403               *--------------------------------------------------------------
0404 23CE 20A0  38         coc   @wbit0,config         ; Fat flag set ?
     23D0 2020     
0405 23D2 1603  14         jne   ldfnt3                ; No, so skip
0406 23D4 D1C4  18         movb  tmp0,tmp3
0407 23D6 0917  56         srl   tmp3,1
0408 23D8 E107  18         soc   tmp3,tmp0
0409               *--------------------------------------------------------------
0410               *   Dump byte to VDP and do housekeeping
0411               *--------------------------------------------------------------
0412 23DA D804  38 ldfnt3  movb  tmp0,@vdpw            ; Dump byte to VRAM
     23DC 8C00     
0413 23DE 0606  14         dec   tmp2
0414 23E0 16F2  14         jne   ldfnt2
0415 23E2 05C8  14         inct  tmp4                  ; R11=R11+2
0416 23E4 020F  20         li    r15,vdpw              ; Set VDP write address
     23E6 8C00     
0417 23E8 0242  22         andi  config,>7fff          ; CONFIG register bit 0=0
     23EA 7FFF     
0418 23EC 0458  20         b     *tmp4                 ; Exit
0419 23EE D820  54 ldfnt4  movb  @hb$00,@vdpw          ; Insert byte >00 into VRAM
     23F0 2000     
     23F2 8C00     
0420 23F4 10E8  14         jmp   ldfnt2
0421               *--------------------------------------------------------------
0422               * Fonts pointer table
0423               *--------------------------------------------------------------
0424 23F6 004C     tmp006  data  >004c,64*8,>0000      ; Pointer to TI title screen font
     23F8 0200     
     23FA 0000     
0425 23FC 004E             data  >004e,64*7,>0101      ; Pointer to upper case font
     23FE 01C0     
     2400 0101     
0426 2402 004E             data  >004e,96*7,>0101      ; Pointer to upper & lower case font
     2404 02A0     
     2406 0101     
0427 2408 0050             data  >0050,32*7,>0101      ; Pointer to lower case font
     240A 00E0     
     240C 0101     
0428               
0429               
0430               
0431               ***************************************************************
0432               * YX2PNT - Get VDP PNT address for current YX cursor position
0433               ***************************************************************
0434               *  BL   @YX2PNT
0435               *--------------------------------------------------------------
0436               *  INPUT
0437               *  @WYX = Cursor YX position
0438               *--------------------------------------------------------------
0439               *  OUTPUT
0440               *  TMP0 = VDP address for entry in Pattern Name Table
0441               *--------------------------------------------------------------
0442               *  Register usage
0443               *  TMP0, R14, R15
0444               ********|*****|*********************|**************************
0445 240E C10E  18 yx2pnt  mov   r14,tmp0              ; Save VDP#0 & VDP#1
0446 2410 C3A0  34         mov   @wyx,r14              ; Get YX
     2412 832A     
0447 2414 098E  56         srl   r14,8                 ; Right justify (remove X)
0448 2416 3BA0  72         mpy   @wcolmn,r14           ; pos = Y * (columns per row)
     2418 833A     
0449               *--------------------------------------------------------------
0450               * Do rest of calculation with R15 (16 bit part is there)
0451               * Re-use R14
0452               *--------------------------------------------------------------
0453 241A C3A0  34         mov   @wyx,r14              ; Get YX
     241C 832A     
0454 241E 024E  22         andi  r14,>00ff             ; Remove Y
     2420 00FF     
0455 2422 A3CE  18         a     r14,r15               ; pos = pos + X
0456 2424 A3E0  34         a     @wbase,r15            ; pos = pos + (PNT base address)
     2426 8328     
0457               *--------------------------------------------------------------
0458               * Clean up before exit
0459               *--------------------------------------------------------------
0460 2428 C384  18         mov   tmp0,r14              ; Restore VDP#0 & VDP#1
0461 242A C10F  18         mov   r15,tmp0              ; Return pos in TMP0
0462 242C 020F  20         li    r15,vdpw              ; VDP write address
     242E 8C00     
0463 2430 045B  20         b     *r11
0464               
0465               
0466               
0467               ***************************************************************
0468               * Put length-byte prefixed string at current YX
0469               ***************************************************************
0470               *  BL   @PUTSTR
0471               *  DATA P0
0472               *
0473               *  P0 = Pointer to string
0474               *--------------------------------------------------------------
0475               *  REMARKS
0476               *  First byte of string must contain length
0477               *--------------------------------------------------------------
0478               *  Register usage
0479               *  tmp1, tmp2, tmp3
0480               ********|*****|*********************|**************************
0481 2432 C17B  30 putstr  mov   *r11+,tmp1
0482 2434 D1B5  28 xutst0  movb  *tmp1+,tmp2           ; Get length byte
0483 2436 C1CB  18 xutstr  mov   r11,tmp3
0484 2438 06A0  32         bl    @yx2pnt               ; Get VDP destination address
     243A 240E     
0485 243C C2C7  18         mov   tmp3,r11
0486 243E 0986  56         srl   tmp2,8                ; Right justify length byte
0487               *--------------------------------------------------------------
0488               * Put string
0489               *--------------------------------------------------------------
0490 2440 C186  18         mov   tmp2,tmp2             ; Length = 0 ?
0491 2442 1305  14         jeq   !                     ; Yes, crash and burn
0492               
0493 2444 0286  22         ci    tmp2,255              ; Length > 255 ?
     2446 00FF     
0494 2448 1502  14         jgt   !                     ; Yes, crash and burn
0495               
0496 244A 0460  28         b     @xpym2v               ; Display string
     244C 24A0     
0497               *--------------------------------------------------------------
0498               * Crash handler
0499               *--------------------------------------------------------------
0500 244E C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     2450 FFCE     
0501 2452 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2454 2026     
0502               
0503               
0504               
0505               ***************************************************************
0506               * Put length-byte prefixed string at YX
0507               ***************************************************************
0508               *  BL   @PUTAT
0509               *  DATA P0,P1
0510               *
0511               *  P0 = YX position
0512               *  P1 = Pointer to string
0513               *--------------------------------------------------------------
0514               *  REMARKS
0515               *  First byte of string must contain length
0516               ********|*****|*********************|**************************
0517 2456 C83B  50 putat   mov   *r11+,@wyx            ; Set YX position
     2458 832A     
0518 245A 0460  28         b     @putstr
     245C 2432     
0519               
0520               
0521               ***************************************************************
0522               * putlst
0523               * Loop over string list and display
0524               ***************************************************************
0525               * bl  @putlst
0526               *--------------------------------------------------------------
0527               * INPUT
0528               * @wyx = Cursor position
0529               * tmp1 = Pointer to first length-prefixed string in list
0530               * tmp2 = Number of strings to display
0531               *--------------------------------------------------------------
0532               * OUTPUT
0533               * none
0534               *--------------------------------------------------------------
0535               * Register usage
0536               * tmp0, tmp1, tmp2, tmp3
0537               ********|*****|*********************|**************************
0538               putlst:
0539 245E 0649  14         dect  stack
0540 2460 C64B  30         mov   r11,*stack            ; Save return address
0541 2462 0649  14         dect  stack
0542 2464 C644  30         mov   tmp0,*stack           ; Push tmp0
0543                       ;------------------------------------------------------
0544                       ; Dump strings to VDP
0545                       ;------------------------------------------------------
0546               putlst.loop:
0547 2466 D1D5  26         movb  *tmp1,tmp3            ; Get string length byte
0548 2468 0987  56         srl   tmp3,8                ; Right align
0549               
0550 246A 0649  14         dect  stack
0551 246C C645  30         mov   tmp1,*stack           ; Push tmp1
0552 246E 0649  14         dect  stack
0553 2470 C646  30         mov   tmp2,*stack           ; Push tmp2
0554 2472 0649  14         dect  stack
0555 2474 C647  30         mov   tmp3,*stack           ; Push tmp3
0556               
0557 2476 06A0  32         bl    @xutst0               ; Display string
     2478 2434     
0558                                                   ; \ i  tmp1 = Pointer to string
0559                                                   ; / i  @wyx = Cursor position at
0560               
0561 247A C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0562 247C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0563 247E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0564               
0565 2480 06A0  32         bl    @down                 ; Move cursor down
     2482 26E0     
0566               
0567 2484 A147  18         a     tmp3,tmp1             ; Add string length to pointer
0568 2486 0585  14         inc   tmp1                  ; Consider length byte
0569 2488 2560  38         czc   @w$0001,tmp1          ; Is address even ?
     248A 2002     
0570 248C 1301  14         jeq   !                     ; Yes, skip adjustment
0571 248E 0585  14         inc   tmp1                  ; Make address even
0572 2490 0606  14 !       dec   tmp2
0573 2492 15E9  14         jgt   putlst.loop
0574                       ;------------------------------------------------------
0575                       ; Exit
0576                       ;------------------------------------------------------
0577               putlst.exit:
0578 2494 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0579 2496 C2F9  30         mov   *stack+,r11           ; Pop r11
0580 2498 045B  20         b     *r11                  ; Return
                   < runlib.asm
0095               
0097                       copy  "copy_cpu_vram.asm"        ; CPU to VRAM copy functions
     **** ****     > copy_cpu_vram.asm
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
0020 249A C13B  30 cpym2v  mov   *r11+,tmp0            ; VDP Start address
0021 249C C17B  30         mov   *r11+,tmp1            ; RAM/ROM start address
0022 249E C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Assert
0025               *--------------------------------------------------------------
0026 24A0 C186  18 xpym2v  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0027 24A2 1604  14         jne   !                     ; No, continue
0028               
0029 24A4 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     24A6 FFCE     
0030 24A8 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     24AA 2026     
0031               *--------------------------------------------------------------
0032               *    Setup VDP write address
0033               *--------------------------------------------------------------
0034 24AC 0264  22 !       ori   tmp0,>4000
     24AE 4000     
0035 24B0 06C4  14         swpb  tmp0
0036 24B2 D804  38         movb  tmp0,@vdpa
     24B4 8C02     
0037 24B6 06C4  14         swpb  tmp0
0038 24B8 D804  38         movb  tmp0,@vdpa
     24BA 8C02     
0039               *--------------------------------------------------------------
0040               *    Copy bytes from CPU memory to VRAM
0041               *--------------------------------------------------------------
0042 24BC 020F  20         li    r15,vdpw              ; Set VDP write address
     24BE 8C00     
0043 24C0 C820  54         mov   @tmp008,@mcloop       ; Setup copy command
     24C2 24CA     
     24C4 8320     
0044 24C6 0460  28         b     @mcloop               ; Write data to VDP and return
     24C8 8320     
0045               *--------------------------------------------------------------
0046               * Data
0047               *--------------------------------------------------------------
0048 24CA D7F5     tmp008  data  >d7f5                 ; MOVB *TMP1+,*R15
                   < runlib.asm
0099               
0101                       copy  "copy_vram_cpu.asm"        ; VRAM to CPU copy functions
     **** ****     > copy_vram_cpu.asm
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
0020 24CC C13B  30 cpyv2m  mov   *r11+,tmp0            ; VDP source address
0021 24CE C17B  30         mov   *r11+,tmp1            ; Target address in RAM
0022 24D0 C1BB  30         mov   *r11+,tmp2            ; Bytes to copy
0023               *--------------------------------------------------------------
0024               *    Setup VDP read address
0025               *--------------------------------------------------------------
0026 24D2 06C4  14 xpyv2m  swpb  tmp0
0027 24D4 D804  38         movb  tmp0,@vdpa
     24D6 8C02     
0028 24D8 06C4  14         swpb  tmp0
0029 24DA D804  38         movb  tmp0,@vdpa
     24DC 8C02     
0030               *--------------------------------------------------------------
0031               *    Copy bytes from VDP memory to RAM
0032               *--------------------------------------------------------------
0033 24DE 020F  20         li    r15,vdpr              ; Set VDP read address
     24E0 8800     
0034 24E2 C820  54         mov   @tmp007,@mcloop       ; Setup copy command
     24E4 24EC     
     24E6 8320     
0035 24E8 0460  28         b     @mcloop               ; Read data from VDP
     24EA 8320     
0036 24EC DD5F     tmp007  data  >dd5f                 ; MOVB *R15,*TMP+
                   < runlib.asm
0103               
0105                       copy  "copy_cpu_cpu.asm"         ; CPU to CPU copy functions
     **** ****     > copy_cpu_cpu.asm
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
0024 24EE C13B  30 cpym2m  mov   *r11+,tmp0            ; Memory source address
0025 24F0 C17B  30         mov   *r11+,tmp1            ; Memory target address
0026 24F2 C1BB  30         mov   *r11+,tmp2            ; Number of bytes to copy
0027               *--------------------------------------------------------------
0028               * Do some checks first
0029               *--------------------------------------------------------------
0030 24F4 C186  18 xpym2m  mov   tmp2,tmp2             ; Bytes to copy = 0 ?
0031 24F6 1604  14         jne   cpychk                ; No, continue checking
0032               
0033 24F8 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     24FA FFCE     
0034 24FC 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     24FE 2026     
0035               *--------------------------------------------------------------
0036               *    Check: 1 byte copy
0037               *--------------------------------------------------------------
0038 2500 0286  22 cpychk  ci    tmp2,1                ; Bytes to copy = 1 ?
     2502 0001     
0039 2504 1603  14         jne   cpym0                 ; No, continue checking
0040 2506 DD74  42         movb  *tmp0+,*tmp1+         ; Copy byte
0041 2508 04C6  14         clr   tmp2                  ; Reset counter
0042 250A 045B  20         b     *r11                  ; Return to caller
0043               *--------------------------------------------------------------
0044               *    Check: Uneven address handling
0045               *--------------------------------------------------------------
0046 250C 0242  22 cpym0   andi  config,>7fff          ; Clear CONFIG bit 0
     250E 7FFF     
0047 2510 C1C4  18         mov   tmp0,tmp3
0048 2512 0247  22         andi  tmp3,1
     2514 0001     
0049 2516 1618  14         jne   cpyodd                ; Odd source address handling
0050 2518 C1C5  18 cpym1   mov   tmp1,tmp3
0051 251A 0247  22         andi  tmp3,1
     251C 0001     
0052 251E 1614  14         jne   cpyodd                ; Odd target address handling
0053               *--------------------------------------------------------------
0054               * 8 bit copy
0055               *--------------------------------------------------------------
0056 2520 20A0  38 cpym2   coc   @wbit0,config         ; CONFIG bit 0 set ?
     2522 2020     
0057 2524 1605  14         jne   cpym3
0058 2526 C820  54         mov   @tmp011,@mcloop       ; Setup byte copy command
     2528 254E     
     252A 8320     
0059 252C 0460  28         b     @mcloop               ; Copy memory and exit
     252E 8320     
0060               *--------------------------------------------------------------
0061               * 16 bit copy
0062               *--------------------------------------------------------------
0063 2530 C1C6  18 cpym3   mov   tmp2,tmp3
0064 2532 0247  22         andi  tmp3,1                ; TMP3=1 -> ODD else EVEN
     2534 0001     
0065 2536 1301  14         jeq   cpym4
0066 2538 0606  14         dec   tmp2                  ; Make TMP2 even
0067 253A CD74  46 cpym4   mov   *tmp0+,*tmp1+
0068 253C 0646  14         dect  tmp2
0069 253E 16FD  14         jne   cpym4
0070               *--------------------------------------------------------------
0071               * Copy last byte if ODD
0072               *--------------------------------------------------------------
0073 2540 C1C7  18         mov   tmp3,tmp3
0074 2542 1301  14         jeq   cpymz
0075 2544 D554  38         movb  *tmp0,*tmp1
0076 2546 045B  20 cpymz   b     *r11                  ; Return to caller
0077               *--------------------------------------------------------------
0078               * Handle odd source/target address
0079               *--------------------------------------------------------------
0080 2548 0262  22 cpyodd  ori   config,>8000          ; Set CONFIG bit 0
     254A 8000     
0081 254C 10E9  14         jmp   cpym2
0082 254E DD74     tmp011  data  >dd74                 ; MOVB *TMP0+,*TMP1+
                   < runlib.asm
0107               
0111               
0115               
0117                       copy  "cpu_sams.asm"             ; Support for SAMS memory card
     **** ****     > cpu_sams.asm
0001               * FILE......: cpu_sams.asm
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
0062 2550 C13B  30         mov   *r11+,tmp0            ; Memory address
0063               xsams.page.get:
0064 2552 0649  14         dect  stack
0065 2554 C64B  30         mov   r11,*stack            ; Push return address
0066 2556 0649  14         dect  stack
0067 2558 C640  30         mov   r0,*stack             ; Push r0
0068 255A 0649  14         dect  stack
0069 255C C64C  30         mov   r12,*stack            ; Push r12
0070               *--------------------------------------------------------------
0071               * Determine memory bank
0072               *--------------------------------------------------------------
0073 255E 09C4  56         srl   tmp0,12               ; Reduce address to 4K chunks
0074 2560 0A14  56         sla   tmp0,1                ; Registers are 2 bytes appart
0075               
0076 2562 0224  22         ai    tmp0,>4000            ; Add base address of "DSR" space
     2564 4000     
0077 2566 C804  38         mov   tmp0,@waux2           ; Save address of SAMS register
     2568 833E     
0078               *--------------------------------------------------------------
0079               * Get SAMS page number
0080               *--------------------------------------------------------------
0081 256A 020C  20         li    r12,>1e00             ; SAMS CRU address
     256C 1E00     
0082 256E 04C0  14         clr   r0
0083 2570 1D00  20         sbo   0                     ; Enable access to SAMS registers
0084 2572 D014  26         movb  *tmp0,r0              ; Get SAMS page number
0085 2574 D100  18         movb  r0,tmp0
0086 2576 0984  56         srl   tmp0,8                ; Right align
0087 2578 C804  38         mov   tmp0,@waux1           ; Save SAMS page number
     257A 833C     
0088 257C 1E00  20         sbz   0                     ; Disable access to SAMS registers
0089               *--------------------------------------------------------------
0090               * Exit
0091               *--------------------------------------------------------------
0092               sams.page.get.exit:
0093 257E C339  30         mov   *stack+,r12           ; Pop r12
0094 2580 C039  30         mov   *stack+,r0            ; Pop r0
0095 2582 C2F9  30         mov   *stack+,r11           ; Pop return address
0096 2584 045B  20         b     *r11                  ; Return to caller
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
0131 2586 C13B  30         mov   *r11+,tmp0            ; Get SAMS page
0132 2588 C17B  30         mov   *r11+,tmp1            ; Get memory address
0133               xsams.page.set:
0134 258A 0649  14         dect  stack
0135 258C C64B  30         mov   r11,*stack            ; Push return address
0136 258E 0649  14         dect  stack
0137 2590 C640  30         mov   r0,*stack             ; Push r0
0138 2592 0649  14         dect  stack
0139 2594 C64C  30         mov   r12,*stack            ; Push r12
0140 2596 0649  14         dect  stack
0141 2598 C644  30         mov   tmp0,*stack           ; Push tmp0
0142 259A 0649  14         dect  stack
0143 259C C645  30         mov   tmp1,*stack           ; Push tmp1
0144               *--------------------------------------------------------------
0145               * Determine memory bank
0146               *--------------------------------------------------------------
0147 259E 09C5  56         srl   tmp1,12               ; Reduce address to 4K chunks
0148 25A0 0A15  56         sla   tmp1,1                ; Registers are 2 bytes appart
0149               *--------------------------------------------------------------
0150               * Assert on SAMS page number
0151               *--------------------------------------------------------------
0152 25A2 0284  22         ci    tmp0,255              ; Crash if page > 255
     25A4 00FF     
0153 25A6 150D  14         jgt   !
0154               *--------------------------------------------------------------
0155               * Assert on SAMS register
0156               *--------------------------------------------------------------
0157 25A8 0285  22         ci    tmp1,>1e              ; r@401e   >f000 - >ffff
     25AA 001E     
0158 25AC 150A  14         jgt   !
0159 25AE 0285  22         ci    tmp1,>04              ; r@4004   >2000 - >2fff
     25B0 0004     
0160 25B2 1107  14         jlt   !
0161 25B4 0285  22         ci    tmp1,>12              ; r@4014   >a000 - >ffff
     25B6 0012     
0162 25B8 1508  14         jgt   sams.page.set.switch_page
0163 25BA 0285  22         ci    tmp1,>06              ; r@4006   >3000 - >3fff
     25BC 0006     
0164 25BE 1501  14         jgt   !
0165 25C0 1004  14         jmp   sams.page.set.switch_page
0166                       ;------------------------------------------------------
0167                       ; Crash the system
0168                       ;------------------------------------------------------
0169 25C2 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     25C4 FFCE     
0170 25C6 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     25C8 2026     
0171               *--------------------------------------------------------------
0172               * Switch memory bank to specified SAMS page
0173               *--------------------------------------------------------------
0174               sams.page.set.switch_page
0175 25CA 020C  20         li    r12,>1e00             ; SAMS CRU address
     25CC 1E00     
0176 25CE C004  18         mov   tmp0,r0               ; Must be in r0 for CRU use
0177 25D0 06C0  14         swpb  r0                    ; LSB to MSB
0178 25D2 1D00  20         sbo   0                     ; Enable access to SAMS registers
0179 25D4 D940  38         movb  r0,@>4000(tmp1)       ; Set SAMS bank number
     25D6 4000     
0180 25D8 1E00  20         sbz   0                     ; Disable access to SAMS registers
0181               *--------------------------------------------------------------
0182               * Exit
0183               *--------------------------------------------------------------
0184               sams.page.set.exit:
0185 25DA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0186 25DC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0187 25DE C339  30         mov   *stack+,r12           ; Pop r12
0188 25E0 C039  30         mov   *stack+,r0            ; Pop r0
0189 25E2 C2F9  30         mov   *stack+,r11           ; Pop return address
0190 25E4 045B  20         b     *r11                  ; Return to caller
0191               
0192               
0193               
0194               
0195               ***************************************************************
0196               * sams.mapping.on - Enable SAMS mapping mode
0197               ***************************************************************
0198               *  bl   @sams.mapping.on
0199               *--------------------------------------------------------------
0200               *  Register usage
0201               *  r12
0202               ********|*****|*********************|**************************
0203               sams.mapping.on:
0204 25E6 0649  14         dect  stack
0205 25E8 C64C  30         mov   r12,*stack            ; Push r12
0206 25EA 020C  20         li    r12,>1e00             ; SAMS CRU address
     25EC 1E00     
0207 25EE 1D01  20         sbo   1                     ; Enable SAMS mapper
0208               *--------------------------------------------------------------
0209               * Exit
0210               *--------------------------------------------------------------
0211               sams.mapping.on.exit:
0212 25F0 C339  30         mov   *stack+,r12           ; Pop r12
0213 25F2 045B  20         b     *r11                  ; Return to caller
0214               
0215               
0216               
0217               
0218               ***************************************************************
0219               * sams.mapping.off - Disable SAMS mapping mode
0220               ***************************************************************
0221               * bl  @sams.mapping.off
0222               *--------------------------------------------------------------
0223               * OUTPUT
0224               * none
0225               *--------------------------------------------------------------
0226               * Register usage
0227               * r12
0228               ********|*****|*********************|**************************
0229               sams.mapping.off:
0230 25F4 0649  14         dect  stack
0231 25F6 C64C  30         mov   r12,*stack            ; Push r12
0232 25F8 020C  20         li    r12,>1e00             ; SAMS CRU address
     25FA 1E00     
0233 25FC 1E01  20         sbz   1                     ; Disable SAMS mapper
0234               *--------------------------------------------------------------
0235               * Exit
0236               *--------------------------------------------------------------
0237               sams.mapping.off.exit:
0238 25FE C339  30         mov   *stack+,r12           ; Pop r12
0239 2600 045B  20         b     *r11                  ; Return to caller
0240               
0241               
0242               
0243               
0244               
0245               ***************************************************************
0246               * sams.layout
0247               * Setup SAMS memory banks
0248               ***************************************************************
0249               * bl  @sams.layout
0250               *     data P0
0251               *--------------------------------------------------------------
0252               * INPUT
0253               * P0 = Pointer to SAMS page layout table
0254               *--------------------------------------------------------------
0255               * bl  @xsams.layout
0256               *
0257               * tmp0 = Pointer to SAMS page layout table
0258               *--------------------------------------------------------------
0259               * OUTPUT
0260               * none
0261               *--------------------------------------------------------------
0262               * Register usage
0263               * tmp0, r12
0264               ********|*****|*********************|**************************
0265               
0266               
0267               sams.layout:
0268 2602 C13B  30         mov   *r11+,tmp0            ; Get P0
0269               xsams.layout:
0270 2604 0649  14         dect  stack
0271 2606 C64B  30         mov   r11,*stack            ; Save return address
0272 2608 0649  14         dect  stack
0273 260A C644  30         mov   tmp0,*stack           ; Save tmp0
0274 260C 0649  14         dect  stack
0275 260E C64C  30         mov   r12,*stack            ; Save r12
0276                       ;------------------------------------------------------
0277                       ; Set SAMS registers
0278                       ;------------------------------------------------------
0279 2610 020C  20         li    r12,>1e00             ; SAMS CRU address
     2612 1E00     
0280 2614 1D00  20         sbo   0                     ; Enable access to SAMS registers
0281               
0282 2616 C834  50         mov  *tmp0+,@>4004          ; Set page for >2000 - >2fff
     2618 4004     
0283 261A C834  50         mov  *tmp0+,@>4006          ; Set page for >3000 - >3fff
     261C 4006     
0284 261E C834  50         mov  *tmp0+,@>4014          ; Set page for >a000 - >afff
     2620 4014     
0285 2622 C834  50         mov  *tmp0+,@>4016          ; Set page for >b000 - >bfff
     2624 4016     
0286 2626 C834  50         mov  *tmp0+,@>4018          ; Set page for >c000 - >cfff
     2628 4018     
0287 262A C834  50         mov  *tmp0+,@>401a          ; Set page for >d000 - >dfff
     262C 401A     
0288 262E C834  50         mov  *tmp0+,@>401c          ; Set page for >e000 - >efff
     2630 401C     
0289 2632 C834  50         mov  *tmp0+,@>401e          ; Set page for >f000 - >ffff
     2634 401E     
0290               
0291 2636 1E00  20         sbz   0                     ; Disable access to SAMS registers
0292 2638 1D01  20         sbo   1                     ; Enable SAMS mapper
0293                       ;------------------------------------------------------
0294                       ; Exit
0295                       ;------------------------------------------------------
0296               sams.layout.exit:
0297 263A C339  30         mov   *stack+,r12           ; Pop r12
0298 263C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0299 263E C2F9  30         mov   *stack+,r11           ; Pop r11
0300 2640 045B  20         b     *r11                  ; Return to caller
0301               ***************************************************************
0302               * SAMS standard page layout table
0303               *--------------------------------------------------------------
0304               sams.layout.standard:
0305 2642 0200             data  >0200                 ; >2000-2fff, SAMS page >02
0306 2644 0300             data  >0300                 ; >3000-3fff, SAMS page >03
0307 2646 0A00             data  >0a00                 ; >a000-afff, SAMS page >0a
0308 2648 0B00             data  >0b00                 ; >b000-bfff, SAMS page >0b
0309 264A 0C00             data  >0c00                 ; >c000-cfff, SAMS page >0c
0310 264C 0D00             data  >0d00                 ; >d000-dfff, SAMS page >0d
0311 264E 0E00             data  >0e00                 ; >e000-efff, SAMS page >0e
0312 2650 0F00             data  >0f00                 ; >f000-ffff, SAMS page >0f
0313               
0314               
0315               ***************************************************************
0316               * sams.layout.copy
0317               * Copy SAMS memory layout
0318               ***************************************************************
0319               * bl  @sams.layout.copy
0320               *     data P0
0321               *--------------------------------------------------------------
0322               * P0 = Pointer to 8 words RAM buffer for results
0323               *--------------------------------------------------------------
0324               * OUTPUT
0325               * RAM buffer will have the SAMS page number for each range
0326               * 2000-2fff, 3000-3fff, a000-afff, b000-bfff, ...
0327               *--------------------------------------------------------------
0328               * Register usage
0329               * tmp0, tmp1, tmp2, tmp3
0330               ***************************************************************
0331               sams.layout.copy:
0332 2652 C1FB  30         mov   *r11+,tmp3            ; Get P0
0333               
0334 2654 0649  14         dect  stack
0335 2656 C64B  30         mov   r11,*stack            ; Push return address
0336 2658 0649  14         dect  stack
0337 265A C644  30         mov   tmp0,*stack           ; Push tmp0
0338 265C 0649  14         dect  stack
0339 265E C645  30         mov   tmp1,*stack           ; Push tmp1
0340 2660 0649  14         dect  stack
0341 2662 C646  30         mov   tmp2,*stack           ; Push tmp2
0342 2664 0649  14         dect  stack
0343 2666 C647  30         mov   tmp3,*stack           ; Push tmp3
0344                       ;------------------------------------------------------
0345                       ; Copy SAMS layout
0346                       ;------------------------------------------------------
0347 2668 0205  20         li    tmp1,sams.layout.copy.data
     266A 268A     
0348 266C 0206  20         li    tmp2,8                ; Set loop counter
     266E 0008     
0349                       ;------------------------------------------------------
0350                       ; Set SAMS memory pages
0351                       ;------------------------------------------------------
0352               sams.layout.copy.loop:
0353 2670 C135  30         mov   *tmp1+,tmp0           ; Get memory address
0354 2672 06A0  32         bl    @xsams.page.get       ; \ Get SAMS page
     2674 2552     
0355                                                   ; | i  tmp0   = Memory address
0356                                                   ; / o  @waux1 = SAMS page
0357               
0358 2676 CDE0  50         mov   @waux1,*tmp3+         ; Copy SAMS page number
     2678 833C     
0359               
0360 267A 0606  14         dec   tmp2                  ; Next iteration
0361 267C 16F9  14         jne   sams.layout.copy.loop ; Loop until done
0362                       ;------------------------------------------------------
0363                       ; Exit
0364                       ;------------------------------------------------------
0365               sams.layout.copy.exit:
0366 267E C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0367 2680 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0368 2682 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0369 2684 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0370 2686 C2F9  30         mov   *stack+,r11           ; Pop r11
0371 2688 045B  20         b     *r11                  ; Return to caller
0372               ***************************************************************
0373               * SAMS memory range table
0374               *--------------------------------------------------------------
0375               sams.layout.copy.data:
0376 268A 2000             data  >2000                 ; >2000-2fff
0377 268C 3000             data  >3000                 ; >3000-3fff
0378 268E A000             data  >a000                 ; >a000-afff
0379 2690 B000             data  >b000                 ; >b000-bfff
0380 2692 C000             data  >c000                 ; >c000-cfff
0381 2694 D000             data  >d000                 ; >d000-dfff
0382 2696 E000             data  >e000                 ; >e000-efff
0383 2698 F000             data  >f000                 ; >f000-ffff
                   < runlib.asm
0119               
0123               
0125                       copy  "vdp_intscr.asm"           ; VDP interrupt & screen on/off
     **** ****     > vdp_intscr.asm
0001               * FILE......: vdp_intscr.asm
0002               * Purpose...: VDP interrupt & screen on/off
0003               
0004               ***************************************************************
0005               * SCROFF - Disable screen display
0006               ***************************************************************
0007               *  BL @SCROFF
0008               ********|*****|*********************|**************************
0009 269A 024E  22 scroff  andi  r14,>ffbf             ; VDP#R1 bit 1=0 (Disable screen display)
     269C FFBF     
0010 269E 0460  28         b     @putv01
     26A0 235A     
0011               
0012               ***************************************************************
0013               * SCRON - Disable screen display
0014               ***************************************************************
0015               *  BL @SCRON
0016               ********|*****|*********************|**************************
0017 26A2 026E  22 scron   ori   r14,>0040             ; VDP#R1 bit 1=1 (Enable screen display)
     26A4 0040     
0018 26A6 0460  28         b     @putv01
     26A8 235A     
0019               
0020               ***************************************************************
0021               * INTOFF - Disable VDP interrupt
0022               ***************************************************************
0023               *  BL @INTOFF
0024               ********|*****|*********************|**************************
0025 26AA 024E  22 intoff  andi  r14,>ffdf             ; VDP#R1 bit 2=0 (Disable VDP interrupt)
     26AC FFDF     
0026 26AE 0460  28         b     @putv01
     26B0 235A     
0027               
0028               ***************************************************************
0029               * INTON - Enable VDP interrupt
0030               ***************************************************************
0031               *  BL @INTON
0032               ********|*****|*********************|**************************
0033 26B2 026E  22 inton   ori   r14,>0020             ; VDP#R1 bit 2=1 (Enable VDP interrupt)
     26B4 0020     
0034 26B6 0460  28         b     @putv01
     26B8 235A     
                   < runlib.asm
0127               
0129                       copy  "vdp_sprites.asm"          ; VDP sprites
     **** ****     > vdp_sprites.asm
0001               ***************************************************************
0002               * FILE......: vdp_sprites.asm
0003               * Purpose...: Sprites support
0004               
0005               ***************************************************************
0006               * SMAG1X - Set sprite magnification 1x
0007               ***************************************************************
0008               *  BL @SMAG1X
0009               ********|*****|*********************|**************************
0010 26BA 024E  22 smag1x  andi  r14,>fffe             ; VDP#R1 bit 7=0 (Sprite magnification 1x)
     26BC FFFE     
0011 26BE 0460  28         b     @putv01
     26C0 235A     
0012               
0013               ***************************************************************
0014               * SMAG2X - Set sprite magnification 2x
0015               ***************************************************************
0016               *  BL @SMAG2X
0017               ********|*****|*********************|**************************
0018 26C2 026E  22 smag2x  ori   r14,>0001             ; VDP#R1 bit 7=1 (Sprite magnification 2x)
     26C4 0001     
0019 26C6 0460  28         b     @putv01
     26C8 235A     
0020               
0021               ***************************************************************
0022               * S8X8 - Set sprite size 8x8 bits
0023               ***************************************************************
0024               *  BL @S8X8
0025               ********|*****|*********************|**************************
0026 26CA 024E  22 s8x8    andi  r14,>fffd             ; VDP#R1 bit 6=0 (Sprite size 8x8)
     26CC FFFD     
0027 26CE 0460  28         b     @putv01
     26D0 235A     
0028               
0029               ***************************************************************
0030               * S16X16 - Set sprite size 16x16 bits
0031               ***************************************************************
0032               *  BL @S16X16
0033               ********|*****|*********************|**************************
0034 26D2 026E  22 s16x16  ori   r14,>0002             ; VDP#R1 bit 6=1 (Sprite size 16x16)
     26D4 0002     
0035 26D6 0460  28         b     @putv01
     26D8 235A     
                   < runlib.asm
0131               
0133                       copy  "vdp_cursor.asm"           ; VDP cursor handling
     **** ****     > vdp_cursor.asm
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
0018 26DA C83B  50 at      mov   *r11+,@wyx
     26DC 832A     
0019 26DE 045B  20         b     *r11
0020               
0021               
0022               ***************************************************************
0023               * down - Increase cursor Y position
0024               ***************************************************************
0025               *  bl   @down
0026               ********|*****|*********************|**************************
0027 26E0 B820  54 down    ab    @hb$01,@wyx
     26E2 2012     
     26E4 832A     
0028 26E6 045B  20         b     *r11
0029               
0030               
0031               ***************************************************************
0032               * up - Decrease cursor Y position
0033               ***************************************************************
0034               *  bl   @up
0035               ********|*****|*********************|**************************
0036 26E8 7820  54 up      sb    @hb$01,@wyx
     26EA 2012     
     26EC 832A     
0037 26EE 045B  20         b     *r11
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
0049 26F0 C13B  30 setx    mov   *r11+,tmp0            ; Set cursor X position
0050 26F2 D120  34 xsetx   movb  @wyx,tmp0             ; Overwrite Y position
     26F4 832A     
0051 26F6 C804  38         mov   tmp0,@wyx             ; Save as new YX position
     26F8 832A     
0052 26FA 045B  20         b     *r11
                   < runlib.asm
0135               
0137                       copy  "vdp_yx2px_calc.asm"       ; VDP calculate pixel pos for YX coord
     **** ****     > vdp_yx2px_calc.asm
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
0021 26FC C120  34 yx2px   mov   @wyx,tmp0
     26FE 832A     
0022 2700 C18B  18 yx2pxx  mov   r11,tmp2              ; Save return address
0023 2702 06C4  14         swpb  tmp0                  ; Y<->X
0024 2704 04C5  14         clr   tmp1                  ; Clear before copy
0025 2706 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0026               *--------------------------------------------------------------
0027               * X pixel - Special F18a 80 colums treatment
0028               *--------------------------------------------------------------
0029 2708 20A0  38         coc   @wbit1,config         ; f18a present ?
     270A 201E     
0030 270C 1609  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0031 270E 8820  54         c     @wcolmn,@yx2pxx_c80   ; 80 columns mode enabled ?
     2710 833A     
     2712 273C     
0032 2714 1605  14         jne   yx2pxx_normal         ; No, skip 80 cols handling
0033               
0034 2716 0A15  56         sla   tmp1,1                ; X = X * 2
0035 2718 B144  18         ab    tmp0,tmp1             ; X = X + (original X)
0036 271A 0225  22         ai    tmp1,>0500            ; X = X + 5 (F18a mystery offset)
     271C 0500     
0037 271E 1002  14         jmp   yx2pxx_y_calc
0038               *--------------------------------------------------------------
0039               * X pixel - Normal VDP treatment
0040               *--------------------------------------------------------------
0041               yx2pxx_normal:
0042 2720 D144  18         movb  tmp0,tmp1             ; Copy X to TMP1
0043               *--------------------------------------------------------------
0044 2722 0A35  56         sla   tmp1,3                ; X=X*8
0045               *--------------------------------------------------------------
0046               * Calculate Y pixel position
0047               *--------------------------------------------------------------
0048               yx2pxx_y_calc:
0049 2724 0A34  56         sla   tmp0,3                ; Y=Y*8
0050 2726 D105  18         movb  tmp1,tmp0
0051 2728 06C4  14         swpb  tmp0                  ; X<->Y
0052 272A 20A0  38 yx2pi1  coc   @wbit0,config         ; Skip sprite adjustment ?
     272C 2020     
0053 272E 1305  14         jeq   yx2pi3                ; Yes, exit
0054               *--------------------------------------------------------------
0055               * Adjust for Y sprite location
0056               * See VDP Programmers Guide, Section 9.2.1
0057               *--------------------------------------------------------------
0058 2730 7120  34 yx2pi2  sb    @hb$01,tmp0           ; Adjust Y. Top of screen is at >FF
     2732 2012     
0059 2734 9120  34         cb    @hb$d0,tmp0           ; Y position = >D0 ?
     2736 2024     
0060 2738 13FB  14         jeq   yx2pi2                ; Yes, but that's not allowed, adjust
0061 273A 0456  20 yx2pi3  b     *tmp2                 ; Exit
0062               *--------------------------------------------------------------
0063               * Local constants
0064               *--------------------------------------------------------------
0065               yx2pxx_c80:
0066 273C 0050            data   80
0067               
0068               
                   < runlib.asm
0139               
0143               
0147               
0149                       copy  "vdp_f18a.asm"             ; VDP F18a low-level functions
     **** ****     > vdp_f18a.asm
0001               * FILE......: vdp_f18a.asm
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
0013 273E C20B  18 f18unl  mov   r11,tmp4              ; Save R11
0014 2740 06A0  32         bl    @putvr                ; Write once
     2742 2346     
0015 2744 391C             data  >391c                 ; VR1/57, value 00011100
0016 2746 06A0  32         bl    @putvr                ; Write twice
     2748 2346     
0017 274A 391C             data  >391c                 ; VR1/57, value 00011100
0018 274C 06A0  32         bl    @putvr
     274E 2346     
0019 2750 01E0             data  >01e0                 ; VR1, value 11100000, a sane setting
0020 2752 0458  20         b     *tmp4                 ; Exit
0021               
0022               
0023               ***************************************************************
0024               * f18lck - Lock F18A VDP
0025               ***************************************************************
0026               *  bl   @f18lck
0027               ********|*****|*********************|**************************
0028 2754 C20B  18 f18lck  mov   r11,tmp4              ; Save R11
0029 2756 06A0  32         bl    @putvr                ; VR1/57, value 00000000
     2758 2346     
0030 275A 3900             data  >3900
0031 275C 0458  20         b     *tmp4                 ; Exit
0032               
0033               
0034               ***************************************************************
0035               * f18idl - Put GPU in F18A VDP in idle mode (stop GPU program)
0036               ***************************************************************
0037               *  bl   @f18idl
0038               *--------------------------------------------------------------
0039               *  REMARKS
0040               *  Expects that the f18a is unlocked when calling this function.
0041               ********|*****|*********************|**************************
0042 275E C20B  18 f18idl  mov   r11,tmp4              ; Save R11
0043 2760 06A0  32         bl    @putvr                ; VR56 >38, value 00000000
     2762 2346     
0044 2764 3800             data  >3800                 ; Reset and load PC (GPU idle!)
0045 2766 0458  20         b     *tmp4                 ; Exit
0046               
0047               
0048               
0049               ***************************************************************
0050               * f18chk - Check if F18A VDP present
0051               ***************************************************************
0052               *  bl   @f18chk
0053               *--------------------------------------------------------------
0054               *  REMARKS
0055               *  Expects that the f18a is unlocked when calling this function.
0056               *  Runs GPU code at VDP >3f00
0057               ********|*****|*********************|**************************
0058 2768 C20B  18 f18chk  mov   r11,tmp4              ; Save R11
0059 276A 06A0  32         bl    @cpym2v
     276C 249A     
0060 276E 3F00             data  >3f00,f18chk_gpu,8    ; Copy F18A GPU code to VRAM
     2770 27B2     
     2772 0008     
0061 2774 06A0  32         bl    @putvr
     2776 2346     
0062 2778 363F             data  >363f                 ; Load MSB of GPU PC (>3f) into VR54 (>36)
0063 277A 06A0  32         bl    @putvr
     277C 2346     
0064 277E 3700             data  >3700                 ; Load LSB of GPU PC (>00) into VR55 (>37)
0065                                                   ; GPU code should run now
0066               
0067 2780 06A0  32         bl    @putvr                ; VR56 >38, value 00000000
     2782 2346     
0068 2784 3800             data  >3800                 ; Reset and load PC (GPU idle!)
0069               ***************************************************************
0070               * VDP @>3f00 == 0 ? F18A present : F18a not present
0071               ***************************************************************
0072 2786 0204  20         li    tmp0,>3f00
     2788 3F00     
0073 278A 06A0  32         bl    @vdra                 ; Set VDP read address to >3f00
     278C 22CE     
0074 278E D120  34         movb  @vdpr,tmp0            ; Read MSB byte
     2790 8800     
0075 2792 0984  56         srl   tmp0,8
0076 2794 D120  34         movb  @vdpr,tmp0            ; Read LSB byte
     2796 8800     
0077 2798 C104  18         mov   tmp0,tmp0             ; For comparing with 0
0078 279A 1303  14         jeq   f18chk_yes
0079               f18chk_no:
0080 279C 0242  22         andi  config,>bfff          ; CONFIG Register bit 1=0
     279E BFFF     
0081 27A0 1002  14         jmp   f18chk_exit
0082               f18chk_yes:
0083 27A2 0262  22         ori   config,>4000          ; CONFIG Register bit 1=1
     27A4 4000     
0084               
0085               f18chk_exit:
0086 27A6 06A0  32         bl    @filv                 ; Clear VDP mem >3f00->3f05
     27A8 22A2     
0087 27AA 3F00             data  >3f00,>00,6
     27AC 0000     
     27AE 0006     
0088 27B0 0458  20         b     *tmp4                 ; Exit
0089               ***************************************************************
0090               * GPU code
0091               ********|*****|*********************|**************************
0092               f18chk_gpu
0093 27B2 04E0             data  >04e0                 ; 3f00 \ 04e0  clr @>3f00
0094 27B4 3F00             data  >3f00                 ; 3f02 / 3f00
0095 27B6 0340             data  >0340                 ; 3f04   0340  idle
0096 27B8 10FF             data  >10ff                 ; 3f06   10ff  \ jmp $
0097                                                   ;              | Make classic99 debugger
0098                                                   ;              | happy if break on illegal
0099                                                   ;              / opcode is on.
0100               
0101               ***************************************************************
0102               * f18rst - Reset f18a into standard settings
0103               ***************************************************************
0104               *  bl   @f18rst
0105               *--------------------------------------------------------------
0106               *  REMARKS
0107               *  This is used to leave the F18A mode and revert all settings
0108               *  that could lead to corruption when doing BLWP @0
0109               *
0110               *  Is expected to run while the f18a is unlocked.
0111               *
0112               *  There are some F18a settings that stay on when doing blwp @0
0113               *  and the TI title screen cannot recover from that.
0114               *
0115               *  It is your responsibility to set video mode tables should
0116               *  you want to continue instead of doing blwp @0 after your
0117               *  program cleanup
0118               ********|*****|*********************|**************************
0119 27BA C20B  18 f18rst  mov   r11,tmp4              ; Save R11
0120                       ;------------------------------------------------------
0121                       ; Reset all F18a VDP registers to power-on defaults
0122                       ;------------------------------------------------------
0123 27BC 06A0  32         bl    @putvr
     27BE 2346     
0124 27C0 3280             data  >3280                 ; F18a VR50 (>32), MSB 8=1
0125               
0126 27C2 06A0  32         bl    @putvr                ; VR1/57, value 00000000
     27C4 2346     
0127 27C6 3900             data  >3900                 ; Lock the F18a
0128 27C8 0458  20         b     *tmp4                 ; Exit
0129               
0130               
0131               
0132               ***************************************************************
0133               * f18fwv - Get F18A Firmware Version
0134               ***************************************************************
0135               *  bl   @f18fwv
0136               *--------------------------------------------------------------
0137               *  REMARKS
0138               *  Successfully tested with F18A v1.8, note that this does not
0139               *  work with F18 v1.3 but you shouldn't be using such old F18A
0140               *  firmware to begin with.
0141               *--------------------------------------------------------------
0142               *  TMP0 High nibble = major version
0143               *  TMP0 Low nibble  = minor version
0144               *
0145               *  Example: >0018     F18a Firmware v1.8
0146               ********|*****|*********************|**************************
0147 27CA C20B  18 f18fwv  mov   r11,tmp4              ; Save R11
0148 27CC 20A0  38         coc   @wbit1,config         ; CONFIG bit 1 set ?
     27CE 201E     
0149 27D0 1609  14         jne   f18fw1
0150               ***************************************************************
0151               * Read F18A major/minor version
0152               ***************************************************************
0153 27D2 C120  34         mov   @vdps,tmp0            ; Clear VDP status register
     27D4 8802     
0154 27D6 06A0  32         bl    @putvr                ; Write to VR#15 for setting F18A status
     27D8 2346     
0155 27DA 0F0E             data  >0f0e                 ; register to read (0e=VR#14)
0156 27DC 04C4  14         clr   tmp0
0157 27DE D120  34         movb  @vdps,tmp0
     27E0 8802     
0158 27E2 0984  56         srl   tmp0,8
0159 27E4 0458  20 f18fw1  b     *tmp4                 ; Exit
                   < runlib.asm
0151               
0153                       copy  "vdp_hchar.asm"            ; VDP hchar functions
     **** ****     > vdp_hchar.asm
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
0017 27E6 C83B  50 hchar   mov   *r11+,@wyx            ; Set YX position
     27E8 832A     
0018 27EA D17B  28         movb  *r11+,tmp1
0019 27EC 0985  56 hcharx  srl   tmp1,8                ; Byte to write
0020 27EE D1BB  28         movb  *r11+,tmp2
0021 27F0 0986  56         srl   tmp2,8                ; Repeat count
0022 27F2 C1CB  18         mov   r11,tmp3
0023 27F4 06A0  32         bl    @yx2pnt               ; Get VDP address into TMP0
     27F6 240E     
0024               *--------------------------------------------------------------
0025               *    Draw line
0026               *--------------------------------------------------------------
0027 27F8 020B  20         li    r11,hchar1
     27FA 2800     
0028 27FC 0460  28         b     @xfilv                ; Draw
     27FE 22A8     
0029               *--------------------------------------------------------------
0030               *    Do housekeeping
0031               *--------------------------------------------------------------
0032 2800 8817  46 hchar1  c     *tmp3,@w$ffff         ; End-Of-List marker found ?
     2802 2022     
0033 2804 1302  14         jeq   hchar2                ; Yes, exit
0034 2806 C2C7  18         mov   tmp3,r11
0035 2808 10EE  14         jmp   hchar                 ; Next one
0036 280A 05C7  14 hchar2  inct  tmp3
0037 280C 0457  20         b     *tmp3                 ; Exit
                   < runlib.asm
0155               
0159               
0163               
0167               
0169                       copy  "snd_player.asm"           ; Sound player
     **** ****     > snd_player.asm
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
0014 280E 04E0  34 mute    clr   @wsdlst               ; Clear sound pointer
     2810 8334     
0015 2812 40A0  34 mute2   szc   @wbit13,config        ; Turn off/pause sound player
     2814 2006     
0016 2816 0204  20         li    tmp0,muttab
     2818 2828     
0017 281A 0205  20         li    tmp1,sound            ; Sound generator port >8400
     281C 8400     
0018 281E D574  40         movb  *tmp0+,*tmp1          ; Generator 0
0019 2820 D574  40         movb  *tmp0+,*tmp1          ; Generator 1
0020 2822 D574  40         movb  *tmp0+,*tmp1          ; Generator 2
0021 2824 D554  38         movb  *tmp0,*tmp1           ; Generator 3
0022 2826 045B  20         b     *r11
0023 2828 9FBF     muttab  byte  >9f,>bf,>df,>ff       ; Table for muting all generators
     282A DFFF     
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
0043 282C C81B  46 sdprep  mov   *r11,@wsdlst          ; Set tune address
     282E 8334     
0044 2830 C83B  50         mov   *r11+,@wsdtmp         ; Set tune address in temp
     2832 8336     
0045 2834 0242  22         andi  config,>fff8          ; Clear bits 13-14-15
     2836 FFF8     
0046 2838 E0BB  30         soc   *r11+,config          ; Set options
0047 283A D820  54         movb  @hb$01,@r13lb         ; Set initial duration
     283C 2012     
     283E 831B     
0048 2840 045B  20         b     *r11
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
0059 2842 20A0  38 sdplay  coc   @wbit13,config        ; Play tune ?
     2844 2006     
0060 2846 1301  14         jeq   sdpla1                ; Yes, play
0061 2848 045B  20         b     *r11
0062               *--------------------------------------------------------------
0063               * Initialisation
0064               *--------------------------------------------------------------
0065 284A 060D  14 sdpla1  dec   r13                   ; duration = duration - 1
0066 284C 9820  54         cb    @r13lb,@hb$00         ; R13LB == 0 ?
     284E 831B     
     2850 2000     
0067 2852 1301  14         jeq   sdpla3                ; Play next note
0068 2854 045B  20 sdpla2  b     *r11                  ; Note still busy, exit
0069 2856 20A0  38 sdpla3  coc   @wbit15,config        ; Play tune from CPU memory ?
     2858 2002     
0070 285A 131A  14         jeq   mmplay
0071               *--------------------------------------------------------------
0072               * Play tune from VDP memory
0073               *--------------------------------------------------------------
0074 285C C120  34 vdplay  mov   @wsdtmp,tmp0          ; Get tune address
     285E 8336     
0075 2860 06C4  14         swpb  tmp0
0076 2862 D804  38         movb  tmp0,@vdpa
     2864 8C02     
0077 2866 06C4  14         swpb  tmp0
0078 2868 D804  38         movb  tmp0,@vdpa
     286A 8C02     
0079 286C 04C4  14         clr   tmp0
0080 286E D120  34         movb  @vdpr,tmp0            ; length = 0 (end of tune) ?
     2870 8800     
0081 2872 131E  14         jeq   sdexit                ; Yes. exit
0082 2874 0984  56 vdpla1  srl   tmp0,8                ; Right justify length byte
0083 2876 A804  38         a     tmp0,@wsdtmp          ; Adjust for next table entry
     2878 8336     
0084 287A D820  54 vdpla2  movb  @vdpr,@>8400          ; Feed byte to sound generator
     287C 8800     
     287E 8400     
0085 2880 0604  14         dec   tmp0
0086 2882 16FB  14         jne   vdpla2
0087 2884 D820  54         movb  @vdpr,@r13lb          ; Set duration counter
     2886 8800     
     2888 831B     
0088 288A 05E0  34 vdpla3  inct  @wsdtmp               ; Adjust for next table entry, honour byte (1) + (n+1)
     288C 8336     
0089 288E 045B  20         b     *r11
0090               *--------------------------------------------------------------
0091               * Play tune from CPU memory
0092               *--------------------------------------------------------------
0093 2890 C120  34 mmplay  mov   @wsdtmp,tmp0
     2892 8336     
0094 2894 D174  28         movb  *tmp0+,tmp1           ; length = 0 (end of tune) ?
0095 2896 130C  14         jeq   sdexit                ; Yes, exit
0096 2898 0985  56 mmpla1  srl   tmp1,8                ; Right justify length byte
0097 289A A805  38         a     tmp1,@wsdtmp          ; Adjust for next table entry
     289C 8336     
0098 289E D834  48 mmpla2  movb  *tmp0+,@>8400         ; Feed byte to sound generator
     28A0 8400     
0099 28A2 0605  14         dec   tmp1
0100 28A4 16FC  14         jne   mmpla2
0101 28A6 D814  46         movb  *tmp0,@r13lb          ; Set duration counter
     28A8 831B     
0102 28AA 05E0  34         inct  @wsdtmp               ; Adjust for next table entry, honour byte (1) + (n+1)
     28AC 8336     
0103 28AE 045B  20         b     *r11
0104               *--------------------------------------------------------------
0105               * Exit. Check if tune must be looped
0106               *--------------------------------------------------------------
0107 28B0 20A0  38 sdexit  coc   @wbit14,config        ; Loop flag set ?
     28B2 2004     
0108 28B4 1607  14         jne   sdexi2                ; No, exit
0109 28B6 C820  54         mov   @wsdlst,@wsdtmp
     28B8 8334     
     28BA 8336     
0110 28BC D820  54         movb  @hb$01,@r13lb          ; Set initial duration
     28BE 2012     
     28C0 831B     
0111 28C2 045B  20 sdexi1  b     *r11                  ; Exit
0112 28C4 0242  22 sdexi2  andi  config,>fff8          ; Reset music player
     28C6 FFF8     
0113 28C8 045B  20         b     *r11                  ; Exit
0114               
                   < runlib.asm
0171               
0175               
0179               
0183               
0186                       copy  "keyb_rkscan.asm"          ; Use ROM#0 OS monitor KSCAN
     **** ****     > keyb_rkscan.asm
0001               * FILE......: keyb_rkscan.asm
0002               * Purpose...: Full (real) keyboard support module
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                     KEYBOARD FUNCTIONS
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * RKSCAN - Scan keyboard using ROM#0 OS monitor KSCAN
0010               ***************************************************************
0011               *  BL @RKSCAN
0012               *--------------------------------------------------------------
0013               * Register usage
0014               * none
0015               *--------------------------------------------------------------
0016               * Scratchpad usage by console KSCAN:
0017               *
0018               * >8373  I/O:    LSB of GPL subroutine stack pointer 80 = (>8380)
0019               * >8374  Input:  keyboard scan mode (default=0)
0020               * >8375  Output: ASCII code detected by keyboard scan
0021               * >8376  Output: Joystick Y-status by keyboard scan
0022               * >8377  Output: Joystick X-status by keyboard scan
0023               * >837c  Output: GPL status byte (>20 if key pressed)
0024               * >838a  I/O:    GPL substack
0025               * >838c  I/O:    GPL substack
0026               * >83c6  I/O:    ISRWS R3 Keyboard state and debounce info
0027               * >83c8  I/O:    ISRWS R4 Keyboard state and debounce info
0028               * >83ca  I/O:    ISRWS R5 Keyboard state and debounce info
0029               * >83d4  I/O:    ISRWS R10 Contents of VDP register 01
0030               * >83d6  I/O:    ISRWS R11 Screen timeout counter, blanks when 0000
0031               * >83d8  I/O:    ISRWS R12 (Backup return address old R11 in GPLWS)
0032               * >83f8  output: GPLWS R12 (CRU base address for key scan)
0033               * >83fa  output: GPLWS R13 (GROM/GRAM read data port 9800)
0034               * >83fe  I/O:    GPLWS R15 (VDP write address port 8c02)
0035               ********|*****|*********************|**************************
0036               rkscan:
0037 28CA 0649  14         dect  stack
0038 28CC C64B  30         mov   r11,*stack            ; Push return address
0039 28CE 0649  14         dect  stack
0040 28D0 C644  30         mov   tmp0,*stack           ; Push tmp0
0041                       ;------------------------------------------------------
0042                       ; (1) Check for alpha lock
0043                       ;------------------------------------------------------
0044 28D2 40A0  34         szc   @wbit10,config        ; Reset CONFIG register bit 10=0
     28D4 200C     
0045                                                   ; (alpha lock off)
0046               
0047                       ; See CRU interface and keyboard sections for details
0048                       ; http://www.nouspikel.com/ti99/titechpages.htm
0049               
0050 28D6 04CC  14         clr   r12                   ; Set base address (to bit 0) so
0051                                                   ; following offsets correspond
0052               
0053 28D8 1E15  20         sbz   21                    ; \ Set bit 21 (PIN 5 attached to alpha
0054                                                   ; / lock column) to 0.
0055               
0056 28DA 0BEC  56         src   r12,14                ; Burn some time (r12=0 no problem shifting)
0057               
0058 28DC 1F07  20         tb    7                     ; \ Copy CRU bit 7 into EQ bit
0059                                                   ; | That is CRU INT7*/P15 pin (keyboard row
0060                                                   ; | with keys FCTN, 2,3,4,5,1,
0061                                                   ; / [joy1-up,joy2-up, Alpha Lock])
0062               
0063 28DE 1302  14         jeq   !                     ; No, alpha lock is off
0064               
0065 28E0 E0A0  34         soc   @wbit10,config        ; \ Yes, alpha lock is on.
     28E2 200C     
0066                                                   ; / Set CONFIG register bit 10=1
0067               
0068 28E4 1D15  20 !       sbo   21                    ; \ Reset bit 21 (Pin 5 attached to alpha
0069                                                   ; / lock column) to 1.
0070                       ;------------------------------------------------------
0071                       ; (2) Prepare for OS monitor kscan
0072                       ;------------------------------------------------------
0073 28E6 C820  54         mov   @scrpad.83c6,@>83c6   ; Required for lowercase support
     28E8 2926     
     28EA 83C6     
0074 28EC C820  54         mov   @scrpad.83fa,@>83fa   ; Load GPLWS R13
     28EE 2928     
     28F0 83FA     
0075 28F2 C820  54         mov   @scrpad.83fe,@>83fe   ; Load GPLWS R15
     28F4 292A     
     28F6 83FE     
0076               
0077 28F8 04C4  14         clr   tmp0                  ; \ Keyboard mode in MSB
0078                                                   ; / 00=Scan all of keyboard
0079               
0080 28FA D804  38         movb  tmp0,@>8374           ; Set keyboard mode at @>8374
     28FC 8374     
0081                                                   ; (scan entire keyboard)
0082               
0083 28FE 02E0  18         lwpi  >83e0                 ; Activate GPL workspace
     2900 83E0     
0084               
0085 2902 06A0  32         bl    @kscan                ; Call KSCAN
     2904 000E     
0086 2906 02E0  18         lwpi  ws1                   ; Activate user workspace
     2908 8300     
0087                       ;------------------------------------------------------
0088                       ; (3) Check if key pressed
0089                       ;------------------------------------------------------
0090 290A D120  34         movb  @>837c,tmp0           ; Get flag
     290C 837C     
0091 290E 0A34  56         sla   tmp0,3                ; Flag value is >20
0092 2910 1707  14         jnc   rkscan.exit           ; No key pressed, exit early
0093                       ;------------------------------------------------------
0094                       ; (4) Key detected, store in memory
0095                       ;------------------------------------------------------
0096 2912 D120  34         movb  @>8375,tmp0           ; \ Key pressed is at @>8375
     2914 8375     
0097 2916 0984  56         srl   tmp0,8                ; / Move to LSB
0099 2918 C804  38         mov   tmp0,@rom0_kscan_out  ; Store ASCII value in user location
     291A A028     
0103 291C E0A0  34         soc   @wbit11,config        ; Set ANYKEY flag in CONFIG register
     291E 200A     
0104                       ;------------------------------------------------------
0105                       ; Exit
0106                       ;------------------------------------------------------
0107               rkscan.exit:
0108 2920 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0109 2922 C2F9  30         mov   *stack+,r11           ; Pop r11
0110 2924 045B  20         b     *r11                  ; Return to caller
0111               
0112               
0113 2926 0200     scrpad.83c6   data >0200            ; Required for KSCAN to support lowercase
0114 2928 9800     scrpad.83fa   data >9800
0115               
0116               ; Dummy value for GPLWS R15 (instead of VDP write address port 8c02)
0117               ; We do not want console KSCAN to fiddle with VDP registers while Stevie
0118               ; is running
0119               
0120 292A 83A0     scrpad.83fe   data >83a0            ; 8c02
                   < runlib.asm
0191               
0193                       copy  "cpu_hexsupport.asm"       ; CPU hex numbers support
     **** ****     > cpu_hexsupport.asm
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
0023 292C C13B  30 mkhex   mov   *r11+,tmp0            ; P0: Address of word
0024 292E C83B  50         mov   *r11+,@waux3          ; P1: Pointer to string buffer
     2930 8340     
0025 2932 04E0  34         clr   @waux1
     2934 833C     
0026 2936 04E0  34         clr   @waux2
     2938 833E     
0027 293A 0207  20         li    tmp3,waux1            ; We store results in WAUX1 and WAUX2
     293C 833C     
0028 293E C114  26         mov   *tmp0,tmp0            ; Get word
0029               *--------------------------------------------------------------
0030               *    Convert nibbles to bytes (is in wrong order)
0031               *--------------------------------------------------------------
0032 2940 0205  20         li    tmp1,4                ; 4 nibbles
     2942 0004     
0033 2944 C184  18 mkhex1  mov   tmp0,tmp2             ; Make work copy
0034 2946 0246  22         andi  tmp2,>000f            ; Only keep LSN
     2948 000F     
0035                       ;------------------------------------------------------
0036                       ; Determine offset for ASCII char
0037                       ;------------------------------------------------------
0038 294A 0286  22         ci    tmp2,>000a
     294C 000A     
0039 294E 1105  14         jlt   mkhex1.digit09
0040                       ;------------------------------------------------------
0041                       ; Add ASCII offset for digits A-F
0042                       ;------------------------------------------------------
0043               mkhex1.digitaf:
0044 2950 C21B  26         mov   *r11,tmp4
0045 2952 0988  56         srl   tmp4,8                ; Right justify
0046 2954 0228  22         ai    tmp4,-10              ; Adjust offset for 'A-F'
     2956 FFF6     
0047 2958 1003  14         jmp   mkhex2
0048               
0049               mkhex1.digit09:
0050                       ;------------------------------------------------------
0051                       ; Add ASCII offset for digits 0-9
0052                       ;------------------------------------------------------
0053 295A C21B  26         mov   *r11,tmp4
0054 295C 0248  22         andi  tmp4,>00ff            ; Only keep LSB
     295E 00FF     
0055               
0056 2960 A188  18 mkhex2  a     tmp4,tmp2             ; Add ASCII-offset
0057 2962 06C6  14         swpb  tmp2
0058 2964 DDC6  32         movb  tmp2,*tmp3+           ; Save byte
0059 2966 0944  56         srl   tmp0,4                ; Next nibble
0060 2968 0605  14         dec   tmp1
0061 296A 16EC  14         jne   mkhex1                ; Repeat until all nibbles processed
0062 296C 0242  22         andi  config,>bfff          ; Reset bit 1 in config register
     296E BFFF     
0063               *--------------------------------------------------------------
0064               *    Build first 2 bytes in correct order
0065               *--------------------------------------------------------------
0066 2970 C160  34         mov   @waux3,tmp1           ; Get pointer
     2972 8340     
0067 2974 04D5  26         clr   *tmp1                 ; Set length byte to 0
0068 2976 0585  14         inc   tmp1                  ; Next byte, not word!
0069 2978 C120  34         mov   @waux2,tmp0
     297A 833E     
0070 297C 06C4  14         swpb  tmp0
0071 297E DD44  32         movb  tmp0,*tmp1+
0072 2980 06C4  14         swpb  tmp0
0073 2982 DD44  32         movb  tmp0,*tmp1+
0074               *--------------------------------------------------------------
0075               *    Set length byte
0076               *--------------------------------------------------------------
0077 2984 C120  34         mov   @waux3,tmp0           ; Get start of string buffer
     2986 8340     
0078 2988 D520  46         movb  @hb$04,*tmp0          ; Set lengh byte to 4
     298A 2016     
0079 298C 05CB  14         inct  r11                   ; Skip Parameter P2
0080               *--------------------------------------------------------------
0081               *    Build last 2 bytes in correct order
0082               *--------------------------------------------------------------
0083 298E C120  34         mov   @waux1,tmp0
     2990 833C     
0084 2992 06C4  14         swpb  tmp0
0085 2994 DD44  32         movb  tmp0,*tmp1+
0086 2996 06C4  14         swpb  tmp0
0087 2998 DD44  32         movb  tmp0,*tmp1+
0088               *--------------------------------------------------------------
0089               *    Display hex number ?
0090               *--------------------------------------------------------------
0091 299A 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     299C 2020     
0092 299E 1301  14         jeq   mkhex3                ; Yes, so show at current YX position
0093 29A0 045B  20         b     *r11                  ; Exit
0094               *--------------------------------------------------------------
0095               *  Display hex number on screen at current YX position
0096               *--------------------------------------------------------------
0097 29A2 0242  22 mkhex3  andi  config,>7fff          ; Reset bit 0
     29A4 7FFF     
0098 29A6 C160  34         mov   @waux3,tmp1           ; Get Pointer to string
     29A8 8340     
0099 29AA 0460  28         b     @xutst0               ; Display string
     29AC 2434     
0100 29AE 0610     prefix  data  >0610                 ; Length byte + blank
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
0121 29B0 C83B  50 puthex  mov   *r11+,@wyx            ; Set cursor
     29B2 832A     
0122 29B4 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     29B6 8000     
0123 29B8 10B9  14         jmp   mkhex                 ; Convert number and display
0124               
                   < runlib.asm
0195               
0197                       copy  "cpu_numsupport.asm"       ; CPU unsigned numbers support
     **** ****     > cpu_numsupport.asm
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
0019 29BA 0207  20 mknum   li    tmp3,5                ; Digit counter
     29BC 0005     
0020 29BE C17B  30         mov   *r11+,tmp1            ; \ Get 16 bit unsigned number
0021 29C0 C155  26         mov   *tmp1,tmp1            ; /
0022 29C2 C23B  30         mov   *r11+,tmp4            ; Pointer to string buffer
0023 29C4 0228  22         ai    tmp4,4                ; Get end of buffer
     29C6 0004     
0024 29C8 0206  20         li    tmp2,10               ; Divide by 10 to isolate last digit
     29CA 000A     
0025               *--------------------------------------------------------------
0026               *  Do string conversion
0027               *--------------------------------------------------------------
0028 29CC 04C4  14 mknum1  clr   tmp0                  ; Clear the high word of the dividend
0029 29CE 3D06 128         div   tmp2,tmp0             ; (TMP0:TMP1) / 10 (TMP2)
0030 29D0 06C5  14         swpb  tmp1                  ; Move to high-byte for writing to buffer
0031 29D2 B15B  26         ab    *r11,tmp1             ; Add offset for ASCII digit
0032 29D4 D605  30         movb  tmp1,*tmp4            ; Write remainder to string buffer
0033 29D6 C144  18         mov   tmp0,tmp1             ; Move integer result into R4 for next digit
0034 29D8 0608  14         dec   tmp4                  ; Adjust string pointer for next digit
0035 29DA 0607  14         dec   tmp3                  ; Decrease counter
0036 29DC 16F7  14         jne   mknum1                ; Do next digit
0037               *--------------------------------------------------------------
0038               *  Replace leading 0's with fill character
0039               *--------------------------------------------------------------
0040 29DE 0207  20         li    tmp3,4                ; Check first 4 digits
     29E0 0004     
0041 29E2 0588  14         inc   tmp4                  ; Too far, back to buffer start
0042 29E4 C11B  26         mov   *r11,tmp0
0043 29E6 0A84  56         sla   tmp0,8                ; Only keep fill character in HB
0044 29E8 96D8  38 mknum2  cb    *tmp4,*r11            ; Digit = 0 ?
0045 29EA 1305  14         jeq   mknum4                ; Yes, replace with fill character
0046 29EC 05CB  14 mknum3  inct  r11
0047 29EE 20A0  38         coc   @wbit0,config         ; Check if 'display' bit is set
     29F0 2020     
0048 29F2 1305  14         jeq   mknum5                ; Yes, so show at current YX position
0049 29F4 045B  20         b     *r11                  ; Exit
0050 29F6 DE04  32 mknum4  movb  tmp0,*tmp4+           ; Replace leading 0 with fill character
0051 29F8 0607  14         dec   tmp3                  ; 4th digit processed ?
0052 29FA 13F8  14         jeq   mknum3                ; Yes, exit
0053 29FC 10F5  14         jmp   mknum2                ; No, next one
0054               *--------------------------------------------------------------
0055               *  Display integer on screen at current YX position
0056               *--------------------------------------------------------------
0057 29FE 0242  22 mknum5  andi  config,>7fff          ; Reset bit 0
     2A00 7FFF     
0058 2A02 C10B  18         mov   r11,tmp0
0059 2A04 0224  22         ai    tmp0,-4
     2A06 FFFC     
0060 2A08 C154  26         mov   *tmp0,tmp1            ; Get buffer address
0061 2A0A 0206  20         li    tmp2,>0500            ; String length = 5
     2A0C 0500     
0062 2A0E 0460  28         b     @xutstr               ; Display string
     2A10 2436     
0063               
0064               
0065               
0066               
0067               ***************************************************************
0068               * trimnum - Trim unsigned number string
0069               ***************************************************************
0070               *  bl   @trimnum
0071               *  data p0,p1,p2
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
0083               *               01234|56789A
0084               *  Before...:   XXXXX          length
0085               *  After....:   XXXXY|zY       z=1
0086               *               XXXYY|zYY      z=2
0087               *               XXYYY|zYYY     z=3
0088               *               XYYYY|zYYYY    z=4
0089               *               YYYYY|zYYYYY   z=5
0090               *--------------------------------------------------------------
0091               *  Destroys registers tmp0-tmp3
0092               ********|*****|*********************|**************************
0093               trimnum:
0094 2A12 C13B  30         mov   *r11+,tmp0            ; Get pointer to input string
0095 2A14 C17B  30         mov   *r11+,tmp1            ; Get pointer to output string
0096 2A16 C1BB  30         mov   *r11+,tmp2            ; Get padding character
0097 2A18 06C6  14         swpb  tmp2                  ; LO <-> HI
0098 2A1A 0207  20         li    tmp3,5                ; Set counter
     2A1C 0005     
0099                       ;------------------------------------------------------
0100                       ; Scan for padding character from left to right
0101                       ;------------------------------------------------------:
0102               trimnum_scan:
0103 2A1E 9194  26         cb    *tmp0,tmp2            ; Matches padding character ?
0104 2A20 1604  14         jne   trimnum_setlen        ; No, exit loop
0105 2A22 0584  14         inc   tmp0                  ; Next character
0106 2A24 0607  14         dec   tmp3                  ; Last digit reached ?
0107 2A26 1301  14         jeq   trimnum_setlen        ; yes, exit loop
0108 2A28 10FA  14         jmp   trimnum_scan
0109                       ;------------------------------------------------------
0110                       ; Scan completed, set length byte new string
0111                       ;------------------------------------------------------
0112               trimnum_setlen:
0113 2A2A 06C7  14         swpb  tmp3                  ; LO <-> HI
0114 2A2C DD47  32         movb  tmp3,*tmp1+           ; Update string-length in work buffer
0115 2A2E 06C7  14         swpb  tmp3                  ; LO <-> HI
0116                       ;------------------------------------------------------
0117                       ; Start filling new string
0118                       ;------------------------------------------------------
0119               trimnum_fill:
0120 2A30 DD74  42         movb  *tmp0+,*tmp1+         ; Copy character
0121 2A32 0607  14         dec   tmp3                  ; Last character ?
0122 2A34 16FD  14         jne   trimnum_fill          ; Not yet, repeat
0123 2A36 045B  20         b     *r11                  ; Return
0124               
0125               
0126               
0127               
0128               ***************************************************************
0129               * PUTNUM - Put unsigned number on screen
0130               ***************************************************************
0131               *  BL   @PUTNUM
0132               *  DATA P0,P1,P2,P3
0133               *--------------------------------------------------------------
0134               *  P0   = YX position
0135               *  P1   = Pointer to 16 bit unsigned number
0136               *  P2   = Pointer to 5 byte string buffer
0137               *  P3HB = Offset for ASCII digit
0138               *  P3LB = Character for replacing leading 0's
0139               ********|*****|*********************|**************************
0140 2A38 C83B  50 putnum  mov   *r11+,@wyx            ; Set cursor
     2A3A 832A     
0141 2A3C 0262  22         ori   config,>8000          ; CONFIG register bit 0=1
     2A3E 8000     
0142 2A40 10BC  14         jmp   mknum                 ; Convert number and display
                   < runlib.asm
0199               
0203               
0207               
0211               
0215               
0217                       copy  "cpu_strings.asm"          ; String utilities support
     **** ****     > cpu_strings.asm
0001               * FILE......: cpu_strings.asm
0002               * Purpose...: CPU string manipulation library
0003               
0004               
0005               ***************************************************************
0006               * string.ltrim - Left justify string
0007               ***************************************************************
0008               *  bl   @string.ltrim
0009               *       data p0,p1,p2
0010               *--------------------------------------------------------------
0011               *  P0 = Pointer to length-prefix string
0012               *  P1 = Pointer to RAM work buffer
0013               *  P2 = Fill character
0014               *--------------------------------------------------------------
0015               *  BL   @xstring.ltrim
0016               *
0017               *  TMP0 = Pointer to length-prefix string
0018               *  TMP1 = Pointer to RAM work buffer
0019               *  TMP2 = Fill character
0020               ********|*****|*********************|**************************
0021               string.ltrim:
0022 2A42 0649  14         dect  stack
0023 2A44 C64B  30         mov   r11,*stack            ; Save return address
0024 2A46 0649  14         dect  stack
0025 2A48 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 2A4A 0649  14         dect  stack
0027 2A4C C645  30         mov   tmp1,*stack           ; Push tmp1
0028 2A4E 0649  14         dect  stack
0029 2A50 C646  30         mov   tmp2,*stack           ; Push tmp2
0030 2A52 0649  14         dect  stack
0031 2A54 C647  30         mov   tmp3,*stack           ; Push tmp3
0032                       ;-----------------------------------------------------------------------
0033                       ; Get parameter values
0034                       ;-----------------------------------------------------------------------
0035 2A56 C13B  30         mov   *r11+,tmp0            ; Pointer to length-prefixed string
0036 2A58 C17B  30         mov   *r11+,tmp1            ; RAM work buffer
0037 2A5A C1BB  30         mov   *r11+,tmp2            ; Fill character
0038 2A5C 100A  14         jmp   !
0039                       ;-----------------------------------------------------------------------
0040                       ; Register version
0041                       ;-----------------------------------------------------------------------
0042               xstring.ltrim:
0043 2A5E 0649  14         dect  stack
0044 2A60 C64B  30         mov   r11,*stack            ; Save return address
0045 2A62 0649  14         dect  stack
0046 2A64 C644  30         mov   tmp0,*stack           ; Push tmp0
0047 2A66 0649  14         dect  stack
0048 2A68 C645  30         mov   tmp1,*stack           ; Push tmp1
0049 2A6A 0649  14         dect  stack
0050 2A6C C646  30         mov   tmp2,*stack           ; Push tmp2
0051 2A6E 0649  14         dect  stack
0052 2A70 C647  30         mov   tmp3,*stack           ; Push tmp3
0053                       ;-----------------------------------------------------------------------
0054                       ; Start
0055                       ;-----------------------------------------------------------------------
0056 2A72 C1D4  26 !       mov   *tmp0,tmp3
0057 2A74 06C7  14         swpb  tmp3                  ; LO <-> HI
0058 2A76 0247  22         andi  tmp3,>00ff            ; Discard HI byte tmp2 (only keep length)
     2A78 00FF     
0059 2A7A 0A86  56         sla   tmp2,8                ; LO -> HI fill character
0060                       ;-----------------------------------------------------------------------
0061                       ; Scan string from left to right and compare with fill character
0062                       ;-----------------------------------------------------------------------
0063               string.ltrim.scan:
0064 2A7C 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0065 2A7E 1604  14         jne   string.ltrim.move     ; No, now move string left
0066 2A80 0584  14         inc   tmp0                  ; Next byte
0067 2A82 0607  14         dec   tmp3                  ; Shorten string length
0068 2A84 1301  14         jeq   string.ltrim.move     ; Exit if all characters processed
0069 2A86 10FA  14         jmp   string.ltrim.scan     ; Scan next characer
0070                       ;-----------------------------------------------------------------------
0071                       ; Copy part of string to RAM work buffer (This is the left-justify)
0072                       ;-----------------------------------------------------------------------
0073               string.ltrim.move:
0074 2A88 9194  26         cb    *tmp0,tmp2            ; Do we have a fill character?
0075 2A8A C1C7  18         mov   tmp3,tmp3             ; String length = 0 ?
0076 2A8C 1306  14         jeq   string.ltrim.panic    ; File length assert
0077 2A8E C187  18         mov   tmp3,tmp2
0078 2A90 06C7  14         swpb  tmp3                  ; HI <-> LO
0079 2A92 DD47  32         movb  tmp3,*tmp1+           ; Set new string length byte in RAM workbuf
0080               
0081 2A94 06A0  32         bl    @xpym2m               ; tmp0 = Memory source address
     2A96 24F4     
0082                                                   ; tmp1 = Memory target address
0083                                                   ; tmp2 = Number of bytes to copy
0084 2A98 1004  14         jmp   string.ltrim.exit
0085                       ;-----------------------------------------------------------------------
0086                       ; CPU crash
0087                       ;-----------------------------------------------------------------------
0088               string.ltrim.panic:
0089 2A9A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2A9C FFCE     
0090 2A9E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2AA0 2026     
0091                       ;----------------------------------------------------------------------
0092                       ; Exit
0093                       ;----------------------------------------------------------------------
0094               string.ltrim.exit:
0095 2AA2 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0096 2AA4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0097 2AA6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0098 2AA8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0099 2AAA C2F9  30         mov   *stack+,r11           ; Pop r11
0100 2AAC 045B  20         b     *r11                  ; Return to caller
0101               
0102               
0103               
0104               
0105               ***************************************************************
0106               * string.getlenc - Get length of C-style string
0107               ***************************************************************
0108               *  bl   @string.getlenc
0109               *       data p0,p1
0110               *--------------------------------------------------------------
0111               *  P0 = Pointer to C-style string
0112               *  P1 = String termination character
0113               *--------------------------------------------------------------
0114               *  bl   @xstring.getlenc
0115               *
0116               *  TMP0 = Pointer to C-style string
0117               *  TMP1 = Termination character
0118               *--------------------------------------------------------------
0119               *  OUTPUT:
0120               *  @waux1 = Length of string
0121               ********|*****|*********************|**************************
0122               string.getlenc:
0123 2AAE 0649  14         dect  stack
0124 2AB0 C64B  30         mov   r11,*stack            ; Save return address
0125 2AB2 05D9  26         inct  *stack                ; Skip "data P0"
0126 2AB4 05D9  26         inct  *stack                ; Skip "data P1"
0127 2AB6 0649  14         dect  stack
0128 2AB8 C644  30         mov   tmp0,*stack           ; Push tmp0
0129 2ABA 0649  14         dect  stack
0130 2ABC C645  30         mov   tmp1,*stack           ; Push tmp1
0131 2ABE 0649  14         dect  stack
0132 2AC0 C646  30         mov   tmp2,*stack           ; Push tmp2
0133                       ;-----------------------------------------------------------------------
0134                       ; Get parameter values
0135                       ;-----------------------------------------------------------------------
0136 2AC2 C13B  30         mov   *r11+,tmp0            ; Pointer to C-style string
0137 2AC4 C17B  30         mov   *r11+,tmp1            ; String termination character
0138 2AC6 1008  14         jmp   !
0139                       ;-----------------------------------------------------------------------
0140                       ; Register version
0141                       ;-----------------------------------------------------------------------
0142               xstring.getlenc:
0143 2AC8 0649  14         dect  stack
0144 2ACA C64B  30         mov   r11,*stack            ; Save return address
0145 2ACC 0649  14         dect  stack
0146 2ACE C644  30         mov   tmp0,*stack           ; Push tmp0
0147 2AD0 0649  14         dect  stack
0148 2AD2 C645  30         mov   tmp1,*stack           ; Push tmp1
0149 2AD4 0649  14         dect  stack
0150 2AD6 C646  30         mov   tmp2,*stack           ; Push tmp2
0151                       ;-----------------------------------------------------------------------
0152                       ; Start
0153                       ;-----------------------------------------------------------------------
0154 2AD8 0A85  56 !       sla   tmp1,8                ; LSB to MSB
0155 2ADA 04C6  14         clr   tmp2                  ; Loop counter
0156                       ;-----------------------------------------------------------------------
0157                       ; Scan string for termination character
0158                       ;-----------------------------------------------------------------------
0159               string.getlenc.loop:
0160 2ADC 0586  14         inc   tmp2
0161 2ADE 9174  28         cb    *tmp0+,tmp1           ; Compare character
0162 2AE0 1304  14         jeq   string.getlenc.putlength
0163                       ;-----------------------------------------------------------------------
0164                       ; Assert on string length
0165                       ;-----------------------------------------------------------------------
0166 2AE2 0286  22         ci    tmp2,255
     2AE4 00FF     
0167 2AE6 1505  14         jgt   string.getlenc.panic
0168 2AE8 10F9  14         jmp   string.getlenc.loop
0169                       ;-----------------------------------------------------------------------
0170                       ; Return length
0171                       ;-----------------------------------------------------------------------
0172               string.getlenc.putlength:
0173 2AEA 0606  14         dec   tmp2                  ; One time adjustment
0174 2AEC C806  38         mov   tmp2,@waux1           ; Store length
     2AEE 833C     
0175 2AF0 1004  14         jmp   string.getlenc.exit   ; Exit
0176                       ;-----------------------------------------------------------------------
0177                       ; CPU crash
0178                       ;-----------------------------------------------------------------------
0179               string.getlenc.panic:
0180 2AF2 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2AF4 FFCE     
0181 2AF6 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2AF8 2026     
0182                       ;----------------------------------------------------------------------
0183                       ; Exit
0184                       ;----------------------------------------------------------------------
0185               string.getlenc.exit:
0186 2AFA C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0187 2AFC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0188 2AFE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0189 2B00 C2F9  30         mov   *stack+,r11           ; Pop r11
0190 2B02 045B  20         b     *r11                  ; Return to caller
                   < runlib.asm
0219               
0223               
0225                       copy  "cpu_scrpad_backrest.asm"  ; Scratchpad backup/restore
     **** ****     > cpu_scrpad_backrest.asm
0001               * FILE......: cpu_scrpad_backrest.asm
0002               * Purpose...: Scratchpad memory backup/restore functions
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                Scratchpad memory backup/restore
0006               *//////////////////////////////////////////////////////////////
0007               
0008               ***************************************************************
0009               * cpu.scrpad.backup - Backup 256 bytes of scratchpad >8300 to
0010               *                     predefined memory target @cpu.scrpad.tgt
0011               ***************************************************************
0012               *  bl   @cpu.scrpad.backup
0013               *--------------------------------------------------------------
0014               *  Register usage
0015               *  r0-r2, but values restored before exit
0016               *--------------------------------------------------------------
0017               *  Backup 256 bytes of scratchpad memory >8300 to destination
0018               *  @cpu.scrpad.tgt (+ >ff)
0019               *
0020               *  Expects current workspace to be in scratchpad memory.
0021               ********|*****|*********************|**************************
0022               cpu.scrpad.backup:
0023 2B04 C800  38         mov   r0,@cpu.scrpad.tgt    ; Save @>8300 (r0)
     2B06 F000     
0024 2B08 C801  38         mov   r1,@cpu.scrpad.tgt+2  ; Save @>8302 (r1)
     2B0A F002     
0025 2B0C C802  38         mov   r2,@cpu.scrpad.tgt+4  ; Save @>8304 (r2)
     2B0E F004     
0026                       ;------------------------------------------------------
0027                       ; Prepare for copy loop
0028                       ;------------------------------------------------------
0029 2B10 0200  20         li    r0,>8306              ; Scratchpad source address
     2B12 8306     
0030 2B14 0201  20         li    r1,cpu.scrpad.tgt+6   ; RAM target address
     2B16 F006     
0031 2B18 0202  20         li    r2,62                 ; Loop counter
     2B1A 003E     
0032                       ;------------------------------------------------------
0033                       ; Copy memory range >8306 - >83ff
0034                       ;------------------------------------------------------
0035               cpu.scrpad.backup.copy:
0036 2B1C CC70  46         mov   *r0+,*r1+
0037 2B1E CC70  46         mov   *r0+,*r1+
0038 2B20 0642  14         dect  r2
0039 2B22 16FC  14         jne   cpu.scrpad.backup.copy
0040 2B24 C820  54         mov   @>83fe,@cpu.scrpad.tgt + >fe
     2B26 83FE     
     2B28 F0FE     
0041                                                   ; Copy last word
0042                       ;------------------------------------------------------
0043                       ; Restore register r0 - r2
0044                       ;------------------------------------------------------
0045 2B2A C020  34         mov   @cpu.scrpad.tgt,r0    ; Restore r0
     2B2C F000     
0046 2B2E C060  34         mov   @cpu.scrpad.tgt+2,r1  ; Restore r1
     2B30 F002     
0047 2B32 C0A0  34         mov   @cpu.scrpad.tgt+4,r2  ; Restore r2
     2B34 F004     
0048                       ;------------------------------------------------------
0049                       ; Exit
0050                       ;------------------------------------------------------
0051               cpu.scrpad.backup.exit:
0052 2B36 045B  20         b     *r11                  ; Return to caller
0053               
0054               
0055               ***************************************************************
0056               * cpu.scrpad.restore - Restore 256 bytes of scratchpad from
0057               *                      predefined target @cpu.scrpad.tgt
0058               *                      to destination >8300
0059               ***************************************************************
0060               *  bl   @cpu.scrpad.restore
0061               *--------------------------------------------------------------
0062               *  Register usage
0063               *  r0-r1
0064               *--------------------------------------------------------------
0065               *  Restore scratchpad from memory area @cpu.scrpad.tgt (+ >ff).
0066               *  Current workspace may not be in scratchpad >8300 when called.
0067               *
0068               *  Destroys r0,r1
0069               ********|*****|*********************|**************************
0070               cpu.scrpad.restore:
0071                       ;------------------------------------------------------
0072                       ; Prepare for copy loop, WS
0073                       ;------------------------------------------------------
0074 2B38 0200  20         li    r0,cpu.scrpad.tgt
     2B3A F000     
0075 2B3C 0201  20         li    r1,>8300
     2B3E 8300     
0076                       ;------------------------------------------------------
0077                       ; Copy 256 bytes from @cpu.scrpad.tgt to >8300
0078                       ;------------------------------------------------------
0079               cpu.scrpad.restore.copy:
0080 2B40 CC70  46         mov   *r0+,*r1+
0081 2B42 CC70  46         mov   *r0+,*r1+
0082 2B44 0281  22         ci    r1,>8400
     2B46 8400     
0083 2B48 11FB  14         jlt   cpu.scrpad.restore.copy
0084                       ;------------------------------------------------------
0085                       ; Exit
0086                       ;------------------------------------------------------
0087               cpu.scrpad.restore.exit:
0088 2B4A 045B  20         b     *r11                  ; Return to caller
                   < runlib.asm
0226                       copy  "cpu_scrpad_paging.asm"    ; Scratchpad memory paging
     **** ****     > cpu_scrpad_paging.asm
0001               * FILE......: cpu_scrpad_paging.asm
0002               * Purpose...: CPU memory paging functions
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                     CPU memory paging
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * cpu.scrpad.pgout - Page out 256 bytes of scratchpad at >8300
0011               *                    to CPU memory destination P0 (tmp1)
0012               *                    and replace with 256 bytes of memory from
0013               *                    predefined destination @cpu.scrpad.target
0014               ***************************************************************
0015               *  bl   @cpu.scrpad.pgout
0016               *       DATA p0
0017               *
0018               *  P0 = CPU memory destination
0019               *--------------------------------------------------------------
0020               *  bl   @xcpu.scrpad.pgout
0021               *  tmp1 = CPU memory destination
0022               *--------------------------------------------------------------
0023               *  Register usage
0024               *  tmp3      = Copy of CPU memory destination
0025               *  tmp0-tmp2 = Used as temporary registers
0026               *  @waux1    = Copy of r5 (tmp1)
0027               *--------------------------------------------------------------
0028               *  Remarks
0029               *  Copies 256 bytes from scratchpad to CPU memory destination
0030               *  specified in P0 (tmp1).
0031               *
0032               *  Then switches to the newly copied workspace in P0 (tmp1).
0033               *
0034               *  Finally it copies 256 bytes from @cpu.scrpad.tgt
0035               *  to scratchpad >8300 and activates workspace at >8300
0036               ********|*****|*********************|**************************
0037               cpu.scrpad.pgout:
0038 2B4C C15B  26         mov   *r11,tmp1             ; tmp1 = Memory target address
0039                       ;------------------------------------------------------
0040                       ; Copy registers r0-r7
0041                       ;------------------------------------------------------
0042 2B4E CD40  34         mov   r0,*tmp1+             ; Backup r0
0043 2B50 CD41  34         mov   r1,*tmp1+             ; Backup r1
0044 2B52 CD42  34         mov   r2,*tmp1+             ; Backup r2
0045 2B54 CD43  34         mov   r3,*tmp1+             ; Backup r3
0046 2B56 CD44  34         mov   r4,*tmp1+             ; Backup r4
0047 2B58 CD45  34         mov   r5,*tmp1+             ; Backup r5 (is tmp1, so is bogus)
0048 2B5A CD46  34         mov   r6,*tmp1+             ; Backup r6
0049 2B5C CD47  34         mov   r7,*tmp1+             ; Backup r7
0050                       ;------------------------------------------------------
0051                       ; Copy scratchpad memory to destination
0052                       ;------------------------------------------------------
0053               xcpu.scrpad.pgout:
0054 2B5E 0204  20         li    tmp0,>8310            ; tmp0 = Memory source address
     2B60 8310     
0055                                                   ;        as of register r8
0056 2B62 0206  20         li    tmp2,15               ; tmp2 = 15 iterations
     2B64 000F     
0057                       ;------------------------------------------------------
0058                       ; Copy memory
0059                       ;------------------------------------------------------
0060 2B66 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word 1
0061 2B68 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 2
0062 2B6A CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 3
0063 2B6C CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 4
0064 2B6E CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 5
0065 2B70 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 6
0066 2B72 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 7
0067 2B74 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 8
0068 2B76 0606  14         dec   tmp2
0069 2B78 16F6  14         jne   -!                    ; Loop until done
0070                       ;------------------------------------------------------
0071                       ; Switch to newly copied workspace
0072                       ;------------------------------------------------------
0073 2B7A C37B  30         mov   *r11+,r13             ; R13=WP   (pop tmp1 from stack)
0074 2B7C 020E  20         li    r14,cpu.scrpad.pgout.after.rtwp
     2B7E 2B84     
0075                                                   ; R14=PC
0076 2B80 04CF  14         clr   r15                   ; R15=STATUS
0077                       ;------------------------------------------------------
0078                       ; If we get here, WS was copied to specified
0079                       ; destination.  Also contents of r13,r14,r15
0080                       ; are about to be overwritten by rtwp instruction.
0081                       ;------------------------------------------------------
0082 2B82 0380  18         rtwp                        ; Activate copied workspace
0083                                                   ; in non-scratchpad memory!
0084               
0085               cpu.scrpad.pgout.after.rtwp:
0086 2B84 0460  28         b     @cpu.scrpad.restore   ; Restore scratchpad memory
     2B86 2B38     
0087                                                   ; from @cpu.scrpad.tgt to @>8300
0088                                                   ; and switch workspace to >8300.
0089                       ;------------------------------------------------------
0090                       ; Exit
0091                       ;------------------------------------------------------
0092               cpu.scrpad.pgout.exit:
0093 2B88 045B  20         b     *r11                  ; Return to caller
0094               
0095               
0096               ***************************************************************
0097               * cpu.scrpad.pgin - Page in 256 bytes of scratchpad memory
0098               *                   at >8300 from CPU memory specified in
0099               *                   p0 (tmp0)
0100               ***************************************************************
0101               *  bl   @cpu.scrpad.pgin
0102               *       DATA p0
0103               *
0104               *  P0 = CPU memory source
0105               *--------------------------------------------------------------
0106               *  bl   @memx.scrpad.pgin
0107               *  TMP0 = CPU memory source
0108               *--------------------------------------------------------------
0109               *  Register usage
0110               *  tmp0-tmp2 = Used as temporary registers
0111               *--------------------------------------------------------------
0112               *  Remarks
0113               *  Copies 256 bytes from CPU memory source to scratchpad >8300
0114               *  and activates workspace in scratchpad >8300
0115               *
0116               *  It's expected that the workspace is outside scratchpad >8300
0117               *  when calling this function.
0118               ********|*****|*********************|**************************
0119               cpu.scrpad.pgin:
0120 2B8A C13B  30         mov   *r11+,tmp0            ; tmp0 = Memory source address
0121                       ;------------------------------------------------------
0122                       ; Copy scratchpad memory to destination
0123                       ;------------------------------------------------------
0124               xcpu.scrpad.pgin:
0125 2B8C 0205  20         li    tmp1,>8300            ; tmp1 = Memory destination address
     2B8E 8300     
0126 2B90 0206  20         li    tmp2,16               ; tmp2 = 256/16
     2B92 0010     
0127                       ;------------------------------------------------------
0128                       ; Copy memory
0129                       ;------------------------------------------------------
0130 2B94 CD74  46 !       mov   *tmp0+,*tmp1+         ; Copy word 1
0131 2B96 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 2
0132 2B98 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 3
0133 2B9A CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 4
0134 2B9C CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 5
0135 2B9E CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 6
0136 2BA0 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 7
0137 2BA2 CD74  46         mov   *tmp0+,*tmp1+         ; Copy word 8
0138 2BA4 0606  14         dec   tmp2
0139 2BA6 16F6  14         jne   -!                    ; Loop until done
0140                       ;------------------------------------------------------
0141                       ; Switch workspace to scratchpad memory
0142                       ;------------------------------------------------------
0143 2BA8 02E0  18         lwpi  >8300                 ; Activate copied workspace
     2BAA 8300     
0144                       ;------------------------------------------------------
0145                       ; Exit
0146                       ;------------------------------------------------------
0147               cpu.scrpad.pgin.exit:
0148 2BAC 045B  20         b     *r11                  ; Return to caller
                   < runlib.asm
0228               
0230                       copy  "fio.equ"                  ; File I/O equates
     **** ****     > fio.equ
0001               * FILE......: fio.equ
0002               * Purpose...: Equates for file I/O operations
0003               
0004               ***************************************************************
0005               * File IO operations - Byte 0 in PAB
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
0018               * File & data type - Byte 1 in PAB (Bit 0-4)
0019               ***************************************************************
0020               * Bit position: 4  3  21  0
0021               *               |  |  ||   \
0022               *               |  |  ||    File type
0023               *               |  |  ||    0 = INTERNAL
0024               *               |  |  ||    1 = FIXED
0025               *               |  |  \\
0026               *               |  |   File operation
0027               *               |  |   00 - UPDATE
0028               *               |  |   01 - OUTPUT
0029               *               |  |   10 - INPUT
0030               *               |  |   11 - APPEND
0031               *               |  |
0032               *               |  \
0033               *               |   Data type
0034               *               |   0 = DISPLAY
0035               *               |   1 = INTERNAL
0036               *               |
0037               *               \
0038               *                Record type
0039               *                0 = FIXED
0040               *                1 = VARIABLE
0041               ***************************************************************
0042               ; Bit position           43210
0043               ************************************|**************************
0044      0000     io.seq.upd.dis.fix  equ :00000      ; 00
0045      0001     io.rel.upd.dis.fix  equ :00001      ; 01
0046      0003     io.rel.out.dis.fix  equ :00011      ; 02
0047      0002     io.seq.out.dis.fix  equ :00010      ; 03
0048      0004     io.seq.inp.dis.fix  equ :00100      ; 04
0049      0005     io.rel.inp.dis.fix  equ :00101      ; 05
0050      0006     io.seq.app.dis.fix  equ :00110      ; 06
0051      0007     io.rel.app.dis.fix  equ :00111      ; 07
0052      0008     io.seq.upd.int.fix  equ :01000      ; 08
0053      0009     io.rel.upd.int.fix  equ :01001      ; 09
0054      000A     io.seq.out.int.fix  equ :01010      ; 0A
0055      000B     io.rel.out.int.fix  equ :01011      ; 0B
0056      000C     io.seq.inp.int.fix  equ :01100      ; 0C
0057      000D     io.rel.inp.int.fix  equ :01101      ; 0D
0058      000E     io.seq.app.int.fix  equ :01110      ; 0E
0059      000F     io.rel.app.int.fix  equ :01111      ; 0F
0060      0010     io.seq.upd.dis.var  equ :10000      ; 10
0061      0011     io.rel.upd.dis.var  equ :10001      ; 11
0062      0012     io.seq.out.dis.var  equ :10010      ; 12
0063      0013     io.rel.out.dis.var  equ :10011      ; 13
0064      0014     io.seq.inp.dis.var  equ :10100      ; 14
0065      0015     io.rel.inp.dis.var  equ :10101      ; 15
0066      0016     io.seq.app.dis.var  equ :10110      ; 16
0067      0017     io.rel.app.dis.var  equ :10111      ; 17
0068      0018     io.seq.upd.int.var  equ :11000      ; 18
0069      0019     io.rel.upd.int.var  equ :11001      ; 19
0070      001A     io.seq.out.int.var  equ :11010      ; 1A
0071      001B     io.rel.out.int.var  equ :11011      ; 1B
0072      001C     io.seq.inp.int.var  equ :11100      ; 1C
0073      001D     io.rel.inp.int.var  equ :11101      ; 1D
0074      001E     io.seq.app.int.var  equ :11110      ; 1E
0075      001F     io.rel.app.int.var  equ :11111      ; 1F
0076               ***************************************************************
0077               * File error codes - Byte 1 in PAB (Bits 5-7)
0078               ************************************|**************************
0079      0000     io.err.no_error_occured             equ 0
0080                       ; Error code 0 with condition bit reset, indicates that
0081                       ; no error has occured
0082               
0083      0000     io.err.bad_device_name              equ 0
0084                       ; Device indicated not in system
0085                       ; Error code 0 with condition bit set, indicates a
0086                       ; device not present in system
0087               
0088      0001     io.err.device_write_prottected      equ 1
0089                       ; Device is write protected
0090               
0091      0002     io.err.bad_open_attribute           equ 2
0092                       ; One or more of the OPEN attributes are illegal or do
0093                       ; not match the file's actual characteristics.
0094                       ; This could be:
0095                       ;   * File type
0096                       ;   * Record length
0097                       ;   * I/O mode
0098                       ;   * File organization
0099               
0100      0003     io.err.illegal_operation            equ 3
0101                       ; Either an issued I/O command was not supported, or a
0102                       ; conflict with the OPEN mode has occured
0103               
0104      0004     io.err.out_of_table_buffer_space    equ 4
0105                       ; The amount of space left on the device is insufficient
0106                       ; for the requested operation
0107               
0108      0005     io.err.eof                          equ 5
0109                       ; Attempt to read past end of file.
0110                       ; This error may also be given for non-existing records
0111                       ; in a relative record file
0112               
0113      0006     io.err.device_error                 equ 6
0114                       ; Covers all hard device errors, such as parity and
0115                       ; bad medium errors
0116               
0117      0007     io.err.file_error                   equ 7
0118                       ; Covers all file-related error like: program/data
0119                       ; file mismatch, non-existing file opened for input mode, etc.
                   < runlib.asm
0231                       copy  "fio_dsrlnk.asm"           ; DSRLNK for peripheral communication
     **** ****     > fio_dsrlnk.asm
0001               * FILE......: fio_dsrlnk.asm
0002               * Purpose...: Custom DSRLNK implementation
0003               
0004               *//////////////////////////////////////////////////////////////
0005               *                          DSRLNK
0006               *//////////////////////////////////////////////////////////////
0007               
0008               
0009               ***************************************************************
0010               * dsrlnk - DSRLNK for file I/O in DSR space >1000 - >1F00
0011               ***************************************************************
0012               *  blwp @dsrlnk
0013               *  data p0
0014               *--------------------------------------------------------------
0015               *  Input:
0016               *  P0     = 8 or 10 (a)
0017               *  @>8356 = Pointer to VDP PAB file descriptor length (PAB+9)
0018               *--------------------------------------------------------------
0019               *  Output:
0020               *  r0 LSB = Bits 13-15 from VDP PAB byte 1, right aligned
0021               *--------------------------------------------------------------
0022               *  Remarks:
0023               *
0024               *  You need to specify following equates in main program
0025               *
0026               *  dsrlnk.dsrlws      equ >????     ; Address of dsrlnk workspace
0027               *  dsrlnk.namsto      equ >????     ; 8-byte RAM buffer for storing device name
0028               *
0029               *  Scratchpad memory usage
0030               *  >8322            Parameter (>08) or (>0A) passed to dsrlnk
0031               *  >8356            Pointer to PAB
0032               *  >83D0            CRU address of current device
0033               *  >83D2            DSR entry address
0034               *  >83e0 - >83ff    GPL / DSRLNK workspace
0035               *
0036               *  Credits
0037               *  Originally appeared in Miller Graphics The Smart Programmer.
0038               *  This version based on version of Paolo Bagnaresi.
0039               *
0040               *  The following memory address can be used to directly jump
0041               *  into the DSR in consequtive calls without having to
0042               *  scan the PEB cards again:
0043               *
0044               *  dsrlnk.namsto  -  8-byte RAM buf for holding device name
0045               *  dsrlnk.savcru  -  CRU address of device in prev. DSR call
0046               *  dsrlnk.savent  -  DSR entry addr of prev. DSR call
0047               *  dsrlnk.savpab  -  Pointer to Device or Subprogram in PAB
0048               *  dsrlnk.savver  -  Version used in prev. DSR call
0049               *  dsrlnk.savlen  -  Length of DSR name of prev. DSR call (in MSB)
0050               *  dsrlnk.flgptr  -  Pointer to VDP PAB byte 1 (flag byte)
0051               
0052               *--------------------------------------------------------------
0053      A40A     dsrlnk.dstype equ   dsrlnk.dsrlws + 10
0054                                                   ; dstype is address of R5 of DSRLNK ws.
0055               ********|*****|*********************|**************************
0056 2BAE A400     dsrlnk  data  dsrlnk.dsrlws         ; dsrlnk workspace
0057 2BB0 2BB2             data  dsrlnk.init           ; Entry point
0058                       ;------------------------------------------------------
0059                       ; DSRLNK entry point
0060                       ;------------------------------------------------------
0061               dsrlnk.init:
0062 2BB2 C17E  30         mov   *r14+,r5              ; Get pgm type for link
0063 2BB4 C805  38         mov   r5,@dsrlnk.sav8a      ; Save data following blwp @dsrlnk (8 or >a)
     2BB6 A428     
0064 2BB8 53E0  34         szcb  @hb$20,r15            ; Reset equal bit in status register
     2BBA 201C     
0065 2BBC C020  34         mov   @>8356,r0             ; Get pointer to PAB+9 in VDP
     2BBE 8356     
0066 2BC0 C240  18         mov   r0,r9                 ; Save pointer
0067                       ;------------------------------------------------------
0068                       ; Fetch file descriptor length from PAB
0069                       ;------------------------------------------------------
0070 2BC2 0229  22         ai    r9,>fff8              ; Adjust r9 to addr PAB byte 1
     2BC4 FFF8     
0071                                                   ; FLAG byte->(pabaddr+9)-8
0072 2BC6 C809  38         mov   r9,@dsrlnk.flgptr     ; Save pointer to PAB byte 1
     2BC8 A434     
0073                       ;---------------------------; Inline VSBR start
0074 2BCA 06C0  14         swpb  r0                    ;
0075 2BCC D800  38         movb  r0,@vdpa              ; Send low byte
     2BCE 8C02     
0076 2BD0 06C0  14         swpb  r0                    ;
0077 2BD2 D800  38         movb  r0,@vdpa              ; Send high byte
     2BD4 8C02     
0078 2BD6 D0E0  34         movb  @vdpr,r3              ; Read byte from VDP RAM
     2BD8 8800     
0079                       ;---------------------------; Inline VSBR end
0080 2BDA 0983  56         srl   r3,8                  ; Move to low byte
0081               
0082                       ;------------------------------------------------------
0083                       ; Fetch file descriptor device name from PAB
0084                       ;------------------------------------------------------
0085 2BDC 0704  14         seto  r4                    ; Init counter
0086 2BDE 0202  20         li    r2,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2BE0 A420     
0087 2BE2 0580  14 !       inc   r0                    ; Point to next char of name
0088 2BE4 0584  14         inc   r4                    ; Increment char counter
0089 2BE6 0284  22         ci    r4,>0007              ; Check if length more than 7 chars
     2BE8 0007     
0090 2BEA 1573  14         jgt   dsrlnk.error.devicename_invalid
0091                                                   ; Yes, error
0092 2BEC 80C4  18         c     r4,r3                 ; End of name?
0093 2BEE 130C  14         jeq   dsrlnk.device_name.get_length
0094                                                   ; Yes
0095               
0096                       ;---------------------------; Inline VSBR start
0097 2BF0 06C0  14         swpb  r0                    ;
0098 2BF2 D800  38         movb  r0,@vdpa              ; Send low byte
     2BF4 8C02     
0099 2BF6 06C0  14         swpb  r0                    ;
0100 2BF8 D800  38         movb  r0,@vdpa              ; Send high byte
     2BFA 8C02     
0101 2BFC D060  34         movb  @vdpr,r1              ; Read byte from VDP RAM
     2BFE 8800     
0102                       ;---------------------------; Inline VSBR end
0103               
0104                       ;------------------------------------------------------
0105                       ; Look for end of device name, for example "DSK1."
0106                       ;------------------------------------------------------
0107 2C00 DC81  32         movb  r1,*r2+               ; Move into buffer
0108 2C02 9801  38         cb    r1,@dsrlnk.period     ; Is character a '.'
     2C04 2D1E     
0109 2C06 16ED  14         jne   -!                    ; No, loop next char
0110                       ;------------------------------------------------------
0111                       ; Determine device name length
0112                       ;------------------------------------------------------
0113               dsrlnk.device_name.get_length:
0114 2C08 C104  18         mov   r4,r4                 ; Check if length = 0
0115 2C0A 1363  14         jeq   dsrlnk.error.devicename_invalid
0116                                                   ; Yes, error
0117 2C0C 04E0  34         clr   @>83d0
     2C0E 83D0     
0118 2C10 C804  38         mov   r4,@>8354             ; Save name length for search (length
     2C12 8354     
0119                                                   ; goes to >8355 but overwrites >8354!)
0120 2C14 C804  38         mov   r4,@dsrlnk.savlen     ; Save name length for nextr dsrlnk call
     2C16 A432     
0121               
0122 2C18 0584  14         inc   r4                    ; Adjust for dot
0123 2C1A A804  38         a     r4,@>8356             ; Point to position after name
     2C1C 8356     
0124 2C1E C820  54         mov   @>8356,@dsrlnk.savpab ; Save pointer for next dsrlnk call
     2C20 8356     
     2C22 A42E     
0125                       ;------------------------------------------------------
0126                       ; Prepare for DSR scan >1000 - >1f00
0127                       ;------------------------------------------------------
0128               dsrlnk.dsrscan.start:
0129 2C24 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2C26 83E0     
0130 2C28 04C1  14         clr   r1                    ; Version found of dsr
0131 2C2A 020C  20         li    r12,>0f00             ; Init cru address
     2C2C 0F00     
0132                       ;------------------------------------------------------
0133                       ; Turn off ROM on current card
0134                       ;------------------------------------------------------
0135               dsrlnk.dsrscan.cardoff:
0136 2C2E C30C  18         mov   r12,r12               ; Anything to turn off?
0137 2C30 1301  14         jeq   dsrlnk.dsrscan.cardloop
0138                                                   ; No, loop over cards
0139 2C32 1E00  20         sbz   0                     ; Yes, turn off
0140                       ;------------------------------------------------------
0141                       ; Loop over cards and look if DSR present
0142                       ;------------------------------------------------------
0143               dsrlnk.dsrscan.cardloop:
0144 2C34 022C  22         ai    r12,>0100             ; Next ROM to turn on
     2C36 0100     
0145 2C38 04E0  34         clr   @>83d0                ; Clear in case we are done
     2C3A 83D0     
0146 2C3C 028C  22         ci    r12,>2000             ; Card scan complete? (>1000 to >1F00)
     2C3E 2000     
0147 2C40 1346  14         jeq   dsrlnk.error.nodsr_found
0148                                                   ; Yes, no matching DSR found
0149 2C42 C80C  38         mov   r12,@>83d0            ; Save address of next cru
     2C44 83D0     
0150                       ;------------------------------------------------------
0151                       ; Look at card ROM (@>4000 eq 'AA' ?)
0152                       ;------------------------------------------------------
0153 2C46 1D00  20         sbo   0                     ; Turn on ROM
0154 2C48 0202  20         li    r2,>4000              ; Start at beginning of ROM
     2C4A 4000     
0155 2C4C 9812  46         cb    *r2,@dsrlnk.$aa00     ; Check for a valid DSR header
     2C4E 2D1A     
0156 2C50 16EE  14         jne   dsrlnk.dsrscan.cardoff
0157                                                   ; No ROM found on card
0158                       ;------------------------------------------------------
0159                       ; Valid DSR ROM found. Now loop over chain/subprograms
0160                       ;------------------------------------------------------
0161                       ; dstype is the address of R5 of the DSRLNK workspace,
0162                       ; which is where 8 for a DSR or 10 (>A) for a subprogram
0163                       ; is stored before the DSR ROM is searched.
0164                       ;------------------------------------------------------
0165 2C52 A0A0  34         a     @dsrlnk.dstype,r2     ; Goto first pointer (byte 8 or 10)
     2C54 A40A     
0166 2C56 1003  14         jmp   dsrlnk.dsrscan.getentry
0167                       ;------------------------------------------------------
0168                       ; Next DSR entry
0169                       ;------------------------------------------------------
0170               dsrlnk.dsrscan.nextentry:
0171 2C58 C0A0  34         mov   @>83d2,r2             ; Offset 0 > Fetch link to next DSR or
     2C5A 83D2     
0172                                                   ; subprogram
0173               
0174 2C5C 1D00  20         sbo   0                     ; Turn ROM back on
0175                       ;------------------------------------------------------
0176                       ; Get DSR entry
0177                       ;------------------------------------------------------
0178               dsrlnk.dsrscan.getentry:
0179 2C5E C092  26         mov   *r2,r2                ; Is address a zero? (end of chain?)
0180 2C60 13E6  14         jeq   dsrlnk.dsrscan.cardoff
0181                                                   ; Yes, no more DSRs or programs to check
0182 2C62 C802  38         mov   r2,@>83d2             ; Offset 0 > Store link to next DSR or
     2C64 83D2     
0183                                                   ; subprogram
0184               
0185 2C66 05C2  14         inct  r2                    ; Offset 2 > Has call address of current
0186                                                   ; DSR/subprogram code
0187               
0188 2C68 C272  30         mov   *r2+,r9               ; Store call address in r9. Move r2 to
0189                                                   ; offset 4 (DSR/subprogram name)
0190                       ;------------------------------------------------------
0191                       ; Check file descriptor in DSR
0192                       ;------------------------------------------------------
0193 2C6A 04C5  14         clr   r5                    ; Remove any old stuff
0194 2C6C D160  34         movb  @>8355,r5             ; Get length as counter
     2C6E 8355     
0195 2C70 1309  14         jeq   dsrlnk.dsrscan.call_dsr
0196                                                   ; If zero, do not further check, call DSR
0197                                                   ; program
0198               
0199 2C72 9C85  32         cb    r5,*r2+               ; See if length matches
0200 2C74 16F1  14         jne   dsrlnk.dsrscan.nextentry
0201                                                   ; No, length does not match.
0202                                                   ; Go process next DSR entry
0203               
0204 2C76 0985  56         srl   r5,8                  ; Yes, move to low byte
0205 2C78 0206  20         li    r6,dsrlnk.namsto      ; Point to 8-byte CPU buffer
     2C7A A420     
0206 2C7C 9CB6  42 !       cb    *r6+,*r2+             ; Compare byte in CPU buffer with byte in
0207                                                   ; DSR ROM
0208 2C7E 16EC  14         jne   dsrlnk.dsrscan.nextentry
0209                                                   ; Try next DSR entry if no match
0210 2C80 0605  14         dec   r5                    ; Update loop counter
0211 2C82 16FC  14         jne   -!                    ; Loop until full length checked
0212                       ;------------------------------------------------------
0213                       ; Call DSR program in card/device
0214                       ;------------------------------------------------------
0215               dsrlnk.dsrscan.call_dsr:
0216 2C84 0581  14         inc   r1                    ; Next version found
0217 2C86 C80C  38         mov   r12,@dsrlnk.savcru    ; Save CRU address
     2C88 A42A     
0218 2C8A C809  38         mov   r9,@dsrlnk.savent     ; Save DSR entry address
     2C8C A42C     
0219 2C8E C801  38         mov   r1,@dsrlnk.savver     ; Save DSR Version number
     2C90 A430     
0220               
0221 2C92 020D  20         li    r13,>9800             ; Set GROM base to >9800 to prevent
     2C94 9800     
0222                                                   ; lockup of TI Disk Controller DSR.
0223               
0224 2C96 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2C98 8C02     
0225                                                   ; lockup of TI Disk Controller DSR.
0226               
0227 2C9A 0699  24         bl    *r9                   ; Execute DSR
0228                       ;
0229                       ; Depending on IO result the DSR in card ROM does RET
0230                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0231                       ;
0232 2C9C 10DD  14         jmp   dsrlnk.dsrscan.nextentry
0233                                                   ; (1) error return
0234 2C9E 1E00  20         sbz   0                     ; (2) turn off card/device if good return
0235 2CA0 02E0  18         lwpi  dsrlnk.dsrlws         ; (2) restore workspace
     2CA2 A400     
0236 2CA4 C009  18         mov   r9,r0                 ; Point to flag byte (PAB+1) in VDP PAB
0237                       ;------------------------------------------------------
0238                       ; Returned from DSR
0239                       ;------------------------------------------------------
0240               dsrlnk.dsrscan.return_dsr:
0241 2CA6 C060  34         mov   @dsrlnk.sav8a,r1      ; get back data following blwp @dsrlnk
     2CA8 A428     
0242                                                   ; (8 or >a)
0243 2CAA 0281  22         ci    r1,8                  ; was it 8?
     2CAC 0008     
0244 2CAE 1303  14         jeq   dsrlnk.dsrscan.dsr.8  ; yes, jump: normal dsrlnk
0245 2CB0 D060  34         movb  @>8350,r1             ; no, we have a data >a.
     2CB2 8350     
0246                                                   ; Get error byte from @>8350
0247 2CB4 1008  14         jmp   dsrlnk.dsrscan.dsr.a  ; go and return error byte to the caller
0248               
0249                       ;------------------------------------------------------
0250                       ; Read VDP PAB byte 1 after DSR call completed (status)
0251                       ;------------------------------------------------------
0252               dsrlnk.dsrscan.dsr.8:
0253                       ;---------------------------; Inline VSBR start
0254 2CB6 06C0  14         swpb  r0                    ;
0255 2CB8 D800  38         movb  r0,@vdpa              ; send low byte
     2CBA 8C02     
0256 2CBC 06C0  14         swpb  r0                    ;
0257 2CBE D800  38         movb  r0,@vdpa              ; send high byte
     2CC0 8C02     
0258 2CC2 D060  34         movb  @vdpr,r1              ; read byte from VDP ram
     2CC4 8800     
0259                       ;---------------------------; Inline VSBR end
0260               
0261                       ;------------------------------------------------------
0262                       ; Return DSR error to caller
0263                       ;------------------------------------------------------
0264               dsrlnk.dsrscan.dsr.a:
0265 2CC6 09D1  56         srl   r1,13                 ; just keep error bits
0266 2CC8 1605  14         jne   dsrlnk.error.io_error
0267                                                   ; handle IO error
0268 2CCA 0380  18         rtwp                        ; Return from DSR workspace to caller
0269                                                   ; workspace
0270               
0271                       ;------------------------------------------------------
0272                       ; IO-error handler
0273                       ;------------------------------------------------------
0274               dsrlnk.error.nodsr_found_off:
0275 2CCC 1E00  20         sbz   >00                   ; Turn card off, nomatter what
0276               dsrlnk.error.nodsr_found:
0277 2CCE 02E0  18         lwpi  dsrlnk.dsrlws         ; No DSR found, restore workspace
     2CD0 A400     
0278               dsrlnk.error.devicename_invalid:
0279 2CD2 04C1  14         clr   r1                    ; clear flag for error 0 = bad device name
0280               dsrlnk.error.io_error:
0281 2CD4 06C1  14         swpb  r1                    ; put error in hi byte
0282 2CD6 D741  30         movb  r1,*r13               ; store error flags in callers r0
0283 2CD8 F3E0  34         socb  @hb$20,r15            ; \ Set equal bit in copy of status register
     2CDA 201C     
0284                                                   ; / to indicate error
0285 2CDC 0380  18         rtwp                        ; Return from DSR workspace to caller
0286                                                   ; workspace
0287               
0288               
0289               ***************************************************************
0290               * dsrln.reuse - Reuse previous DSRLNK call for improved speed
0291               ***************************************************************
0292               *  blwp @dsrlnk.reuse
0293               *--------------------------------------------------------------
0294               *  Input:
0295               *  @>8356         = Pointer to VDP PAB file descriptor length byte (PAB+9)
0296               *  @dsrlnk.savcru = CRU address of device in previous DSR call
0297               *  @dsrlnk.savent = DSR entry address of previous DSR call
0298               *  @dsrlnk.savver = Version used in previous DSR call
0299               *  @dsrlnk.pabptr = Pointer to PAB in VDP memory, set in previous DSR call
0300               *--------------------------------------------------------------
0301               *  Output:
0302               *  r0 LSB = Bits 13-15 from VDP PAB byte 1, right aligned
0303               *--------------------------------------------------------------
0304               *  Remarks:
0305               *   Call the same DSR entry again without having to scan through
0306               *   all devices again.
0307               *
0308               *   Expects dsrlnk.savver, @dsrlnk.savent, @dsrlnk.savcru to be
0309               *   set by previous DSRLNK call.
0310               ********|*****|*********************|**************************
0311               dsrlnk.reuse:
0312 2CDE A400             data  dsrlnk.dsrlws         ; dsrlnk workspace
0313 2CE0 2CE2             data  dsrlnk.reuse.init     ; entry point
0314                       ;------------------------------------------------------
0315                       ; DSRLNK entry point
0316                       ;------------------------------------------------------
0317               dsrlnk.reuse.init:
0318 2CE2 02E0  18         lwpi  >83e0                 ; Use GPL WS
     2CE4 83E0     
0319               
0320 2CE6 53E0  34         szcb  @hb$20,r15            ; reset equal bit in status register
     2CE8 201C     
0321                       ;------------------------------------------------------
0322                       ; Restore dsrlnk variables of previous DSR call
0323                       ;------------------------------------------------------
0324 2CEA 020B  20         li    r11,dsrlnk.savcru     ; Get pointer to last used CRU
     2CEC A42A     
0325 2CEE C33B  30         mov   *r11+,r12             ; Get CRU address         < @dsrlnk.savcru
0326 2CF0 C27B  30         mov   *r11+,r9              ; Get DSR entry address   < @dsrlnk.savent
0327 2CF2 C83B  50         mov   *r11+,@>8356          ; \ Get pointer to Device name or
     2CF4 8356     
0328                                                   ; / or subprogram in PAB  < @dsrlnk.savpab
0329 2CF6 C07B  30         mov   *r11+,R1              ; Get DSR Version number  < @dsrlnk.savver
0330 2CF8 C81B  46         mov   *r11,@>8354           ; Get device name length  < @dsrlnk.savlen
     2CFA 8354     
0331                       ;------------------------------------------------------
0332                       ; Call DSR program in card/device
0333                       ;------------------------------------------------------
0334 2CFC 020F  20         li    r15,>8C02             ; Set VDP port address, needed to prevent
     2CFE 8C02     
0335                                                   ; lockup of TI Disk Controller DSR.
0336               
0337 2D00 1D00  20         sbo   >00                   ; Open card/device ROM
0338               
0339 2D02 9820  54         cb    @>4000,@dsrlnk.$aa00  ; Valid identifier found?
     2D04 4000     
     2D06 2D1A     
0340 2D08 16E2  14         jne   dsrlnk.error.nodsr_found
0341                                                   ; No, error code 0 = Bad Device name
0342                                                   ; The above jump may happen only in case of
0343                                                   ; either card hardware malfunction or if
0344                                                   ; there are 2 cards opened at the same time.
0345               
0346 2D0A 0699  24         bl    *r9                   ; Execute DSR
0347                       ;
0348                       ; Depending on IO result the DSR in card ROM does RET
0349                       ; or (INCT R11 + RET), meaning either (1) or (2) get executed.
0350                       ;
0351 2D0C 10DF  14         jmp   dsrlnk.error.nodsr_found_off
0352                                                   ; (1) error return
0353 2D0E 1E00  20         sbz   >00                   ; (2) turn off card ROM if good return
0354                       ;------------------------------------------------------
0355                       ; Now check if any DSR error occured
0356                       ;------------------------------------------------------
0357 2D10 02E0  18         lwpi  dsrlnk.dsrlws         ; Restore workspace
     2D12 A400     
0358 2D14 C020  34         mov   @dsrlnk.flgptr,r0     ; Get pointer to VDP PAB byte 1
     2D16 A434     
0359               
0360 2D18 10C6  14         jmp   dsrlnk.dsrscan.return_dsr
0361                                                   ; Rest is the same as with normal DSRLNK
0362               
0363               
0364               ********************************************************************************
0365               
0366 2D1A AA00     dsrlnk.$aa00      data   >aa00      ; Used for identifying DSR header
0367 2D1C 0008     dsrlnk.$0008      data   >0008      ; 8 is the data that usually follows
0368                                                   ; a @blwp @dsrlnk
0369 2D1E 2E       dsrlnk.period     text  '.'         ; For finding end of device name
0370               
0371                       even
                   < runlib.asm
0232                       copy  "fio_level3.asm"           ; File I/O level 3 support
     **** ****     > fio_level3.asm
0001               * FILE......: fio_level3.asm
0002               * Purpose...: File I/O level 3 support
0003               
0004               
0005               ***************************************************************
0006               * PAB  - Peripheral Access Block
0007               ********|*****|*********************|**************************
0008               ; my_pab:
0009               ;       byte  io.op.open            ;  0    - OPEN
0010               ;       byte  io.seq.inp.dis.var    ;  1    - INPUT, VARIABLE, DISPLAY
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
0029               *       data P0,P1
0030               *--------------------------------------------------------------
0031               *  P0 = Address of PAB in VDP RAM
0032               *  P1 = LSB contains File type/mode
0033               *--------------------------------------------------------------
0034               *  bl   @xfile.open
0035               *
0036               *  R0 = Address of PAB in VDP RAM
0037               *  R1 = LSB contains File type/mode
0038               *--------------------------------------------------------------
0039               *  Output:
0040               *  tmp0     = Copy of VDP PAB byte 1 after operation
0041               *  tmp1 LSB = Copy of VDP PAB byte 5 after operation
0042               *  tmp2 LSB = Copy of status register after operation
0043               ********|*****|*********************|**************************
0044               file.open:
0045 2D20 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0046 2D22 C07B  30         mov   *r11+,r1              ; Get file type/mode
0047               *--------------------------------------------------------------
0048               * Initialisation
0049               *--------------------------------------------------------------
0050               xfile.open:
0051 2D24 0649  14         dect  stack
0052 2D26 C64B  30         mov   r11,*stack            ; Save return address
0053                       ;------------------------------------------------------
0054                       ; Initialisation
0055                       ;------------------------------------------------------
0056 2D28 0204  20         li    tmp0,dsrlnk.savcru
     2D2A A42A     
0057 2D2C 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savcru
0058 2D2E 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savent
0059 2D30 04F4  30         clr   *tmp0+                ; Clear @dsrlnk.savver
0060 2D32 04D4  26         clr   *tmp0                 ; Clear @dsrlnk.pabflg
0061                       ;------------------------------------------------------
0062                       ; Set pointer to VDP disk buffer header
0063                       ;------------------------------------------------------
0064 2D34 0205  20         li    tmp1,>37D7            ; \ VDP Disk buffer header
     2D36 37D7     
0065 2D38 C805  38         mov   tmp1,@>8370           ; | Pointer at Fixed scratchpad
     2D3A 8370     
0066                                                   ; / location
0067 2D3C C801  38         mov   r1,@fh.filetype       ; Set file type/mode
     2D3E A44C     
0068 2D40 04C5  14         clr   tmp1                  ; io.op.open
0069 2D42 101F  14         jmp   _file.record.fop      ; Do file operation
0070               
0071               
0072               
0073               ***************************************************************
0074               * file.close - Close currently open file
0075               ***************************************************************
0076               *  bl   @file.close
0077               *       data P0
0078               *--------------------------------------------------------------
0079               *  P0 = Address of PAB in VDP RAM
0080               *--------------------------------------------------------------
0081               *  bl   @xfile.close
0082               *
0083               *  R0 = Address of PAB in VDP RAM
0084               *--------------------------------------------------------------
0085               *  Output:
0086               *  tmp0 LSB = Copy of VDP PAB byte 1 after operation
0087               *  tmp1 LSB = Copy of VDP PAB byte 5 after operation
0088               *  tmp2 LSB = Copy of status register after operation
0089               ********|*****|*********************|**************************
0090               file.close:
0091 2D44 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0092               *--------------------------------------------------------------
0093               * Initialisation
0094               *--------------------------------------------------------------
0095               xfile.close:
0096 2D46 0649  14         dect  stack
0097 2D48 C64B  30         mov   r11,*stack            ; Save return address
0098 2D4A 0205  20         li    tmp1,io.op.close      ; io.op.close
     2D4C 0001     
0099 2D4E 1019  14         jmp   _file.record.fop      ; Do file operation
0100               
0101               
0102               ***************************************************************
0103               * file.record.read - Read record from file
0104               ***************************************************************
0105               *  bl   @file.record.read
0106               *       data P0
0107               *--------------------------------------------------------------
0108               *  P0 = Address of PAB in VDP RAM (without +9 offset!)
0109               *--------------------------------------------------------------
0110               *  bl   @xfile.record.read
0111               *
0112               *  R0 = Address of PAB in VDP RAM
0113               *--------------------------------------------------------------
0114               *  Output:
0115               *  tmp0     = Copy of VDP PAB byte 1 after operation
0116               *  tmp1 LSB = Copy of VDP PAB byte 5 after operation
0117               *  tmp2 LSB = Copy of status register after operation
0118               ********|*****|*********************|**************************
0119               file.record.read:
0120 2D50 C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0121               *--------------------------------------------------------------
0122               * Initialisation
0123               *--------------------------------------------------------------
0124 2D52 0649  14         dect  stack
0125 2D54 C64B  30         mov   r11,*stack            ; Save return address
0126               
0127 2D56 0205  20         li    tmp1,io.op.read       ; io.op.read
     2D58 0002     
0128 2D5A 1013  14         jmp   _file.record.fop      ; Do file operation
0129               
0130               
0131               
0132               ***************************************************************
0133               * file.record.write - Write record to file
0134               ***************************************************************
0135               *  bl   @file.record.write
0136               *       data P0
0137               *--------------------------------------------------------------
0138               *  P0 = Address of PAB in VDP RAM (without +9 offset!)
0139               *--------------------------------------------------------------
0140               *  bl   @xfile.record.write
0141               *
0142               *  R0 = Address of PAB in VDP RAM
0143               *--------------------------------------------------------------
0144               *  Output:
0145               *  tmp0     = Copy of VDP PAB byte 1 after operation
0146               *  tmp1 LSB = Copy of VDP PAB byte 5 after operation
0147               *  tmp2 LSB = Copy of status register after operation
0148               ********|*****|*********************|**************************
0149               file.record.write:
0150 2D5C C03B  30         mov   *r11+,r0              ; Get file descriptor (P0)
0151               *--------------------------------------------------------------
0152               * Initialisation
0153               *--------------------------------------------------------------
0154 2D5E 0649  14         dect  stack
0155 2D60 C64B  30         mov   r11,*stack            ; Save return address
0156               
0157 2D62 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0158 2D64 0224  22         ai    tmp0,5                ; Position to PAB byte 5
     2D66 0005     
0159               
0160 2D68 C160  34         mov   @fh.reclen,tmp1       ; Get record length
     2D6A A43E     
0161               
0162 2D6C 06A0  32         bl    @xvputb               ; Write character count to PAB
     2D6E 22E0     
0163                                                   ; \ i  tmp0 = VDP target address
0164                                                   ; / i  tmp1 = Byte to write
0165               
0166 2D70 0205  20         li    tmp1,io.op.write      ; io.op.write
     2D72 0003     
0167 2D74 1006  14         jmp   _file.record.fop      ; Do file operation
0168               
0169               
0170               
0171               file.record.seek:
0172 2D76 1000  14         nop
0173               
0174               
0175               file.image.load:
0176 2D78 1000  14         nop
0177               
0178               
0179               file.image.save:
0180 2D7A 1000  14         nop
0181               
0182               
0183               file.delete:
0184 2D7C 1000  14         nop
0185               
0186               
0187               file.rename:
0188 2D7E 1000  14         nop
0189               
0190               
0191               file.status:
0192 2D80 1000  14         nop
0193               
0194               
0195               
0196               ***************************************************************
0197               * _file.record.fop - File operation
0198               ***************************************************************
0199               * Called internally via JMP/B by file operations
0200               *--------------------------------------------------------------
0201               *  Input:
0202               *  r0   = Address of PAB in VDP RAM
0203               *  r1   = File type/mode
0204               *  tmp1 = File operation opcode
0205               *
0206               *  @fh.offsetopcode = >00  Data buffer in VDP RAM
0207               *  @fh.offsetopcode = >40  Data buffer in CPU RAM
0208               *--------------------------------------------------------------
0209               *  Output:
0210               *  tmp0     = Copy of VDP PAB byte 1 after operation
0211               *  tmp1 LSB = Copy of VDP PAB byte 5 after operation
0212               *  tmp2 LSB = Copy of status register after operation
0213               *--------------------------------------------------------------
0214               *  Register usage:
0215               *  r0, r1, tmp0, tmp1, tmp2
0216               *--------------------------------------------------------------
0217               *  Remarks
0218               *  Private, only to be called from inside fio_level3 module
0219               *  via jump or branch instruction.
0220               *
0221               *  Uses @waux1 for backup/restore of memory word @>8322
0222               ********|*****|*********************|**************************
0223               _file.record.fop:
0224                       ;------------------------------------------------------
0225                       ; Write to PAB required?
0226                       ;------------------------------------------------------
0227 2D82 C800  38         mov   r0,@fh.pab.ptr        ; Backup of pointer to current VDP PAB
     2D84 A436     
0228                       ;------------------------------------------------------
0229                       ; Set file opcode in VDP PAB
0230                       ;------------------------------------------------------
0231 2D86 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0232               
0233 2D88 A160  34         a     @fh.offsetopcode,tmp1 ; Inject offset for file I/O opcode
     2D8A A44E     
0234                                                   ; >00 = Data buffer in VDP RAM
0235                                                   ; >40 = Data buffer in CPU RAM
0236               
0237 2D8C 06A0  32         bl    @xvputb               ; Write file I/O opcode to VDP
     2D8E 22E0     
0238                                                   ; \ i  tmp0 = VDP target address
0239                                                   ; / i  tmp1 = Byte to write
0240                       ;------------------------------------------------------
0241                       ; Set file type/mode in VDP PAB
0242                       ;------------------------------------------------------
0243 2D90 C100  18         mov   r0,tmp0               ; VDP write address (PAB byte 0)
0244 2D92 0584  14         inc   tmp0                  ; Next byte in PAB
0245 2D94 C160  34         mov   @fh.filetype,tmp1     ; Get file type/mode
     2D96 A44C     
0246               
0247 2D98 06A0  32         bl    @xvputb               ; Write file type/mode to VDP
     2D9A 22E0     
0248                                                   ; \ i  tmp0 = VDP target address
0249                                                   ; / i  tmp1 = Byte to write
0250                       ;------------------------------------------------------
0251                       ; Prepare for DSRLNK
0252                       ;------------------------------------------------------
0253 2D9C 0220  22 !       ai    r0,9                  ; Move to file descriptor length
     2D9E 0009     
0254 2DA0 C800  38         mov   r0,@>8356             ; Pass file descriptor to DSRLNK
     2DA2 8356     
0255               *--------------------------------------------------------------
0256               * Call DSRLINK for doing file operation
0257               *--------------------------------------------------------------
0258 2DA4 C820  54         mov   @>8322,@waux1         ; Save word at @>8322
     2DA6 8322     
     2DA8 833C     
0259               
0260 2DAA C120  34         mov   @dsrlnk.savcru,tmp0   ; Call optimized or standard version?
     2DAC A42A     
0261 2DAE 1504  14         jgt   _file.record.fop.optimized
0262                                                   ; Optimized version
0263               
0264                       ;------------------------------------------------------
0265                       ; First IO call. Call standard DSRLNK
0266                       ;------------------------------------------------------
0267 2DB0 0420  54         blwp  @dsrlnk               ; Call DSRLNK
     2DB2 2BAE     
0268 2DB4 0008                   data >8               ; \ i  p0 = >8 (DSR)
0269                                                   ; / o  r0 = Copy of VDP PAB byte 1
0270 2DB6 1002  14         jmp  _file.record.fop.pab   ; Return PAB to caller
0271               
0272                       ;------------------------------------------------------
0273                       ; Recurring IO call. Call optimized DSRLNK
0274                       ;------------------------------------------------------
0275               _file.record.fop.optimized:
0276 2DB8 0420  54         blwp  @dsrlnk.reuse         ; Call DSRLNK
     2DBA 2CDE     
0277               
0278               *--------------------------------------------------------------
0279               * Return PAB details to caller
0280               *--------------------------------------------------------------
0281               _file.record.fop.pab:
0282 2DBC 02C6  12         stst  tmp2                  ; Store status register contents in tmp2
0283                                                   ; Upon DSRLNK return status register EQ bit
0284                                                   ; 1 = No file error
0285                                                   ; 0 = File error occured
0286               
0287 2DBE C820  54         mov   @waux1,@>8322         ; Restore word at @>8322
     2DC0 833C     
     2DC2 8322     
0288               *--------------------------------------------------------------
0289               * Get PAB byte 5 from VDP ram into tmp1 (character count)
0290               *--------------------------------------------------------------
0291 2DC4 C120  34         mov   @fh.pab.ptr,tmp0      ; Get VDP address of current PAB
     2DC6 A436     
0292 2DC8 0224  22         ai    tmp0,5                ; Get address of VDP PAB byte 5
     2DCA 0005     
0293 2DCC 06A0  32         bl    @xvgetb               ; VDP read PAB status byte into tmp0
     2DCE 22F8     
0294 2DD0 C144  18         mov   tmp0,tmp1             ; Move to destination
0295               *--------------------------------------------------------------
0296               * Get PAB byte 1 from VDP ram into tmp0 (status)
0297               *--------------------------------------------------------------
0298 2DD2 C100  18         mov   r0,tmp0               ; VDP PAB byte 1 (status)
0299                                                   ; as returned by DSRLNK
0300               *--------------------------------------------------------------
0301               * Exit
0302               *--------------------------------------------------------------
0303               ; If an error occured during the IO operation, then the
0304               ; equal bit in the saved status register (=tmp2) is set to 1.
0305               ;
0306               ; Upon return from this IO call you should basically test with:
0307               ;       coc   @wbit2,tmp2           ; Equal bit set?
0308               ;       jeq   my_file_io_handler    ; Yes, IO error occured
0309               ;
0310               ; Then look for further details in the copy of VDP PAB byte 1
0311               ; in register tmp0, bits 13-15
0312               ;
0313               ;       srl   tmp0,8                ; Right align (only for DSR type >8
0314               ;                                   ; calls, skip for type >A subprograms!)
0315               ;       ci    tmp0,io.err.<code>    ; Check for error pattern
0316               ;       jeq   my_error_handler
0317               *--------------------------------------------------------------
0318               _file.record.fop.exit:
0319 2DD4 C2F9  30         mov   *stack+,r11           ; Pop R11
0320 2DD6 045B  20         b     *r11                  ; Return to caller
                   < runlib.asm
0234               
0235               *//////////////////////////////////////////////////////////////
0236               *                            TIMERS
0237               *//////////////////////////////////////////////////////////////
0238               
0239                       copy  "timers_tmgr.asm"          ; Timers / Thread scheduler
     **** ****     > timers_tmgr.asm
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
0011               *  This is basically the kernel keeping everything together.
0012               *  Do not forget to set BTIHI to highest slot in use.
0013               *
0014               *  Register usage in TMGR8 - TMGR11
0015               *  TMP0  = Pointer to timer table
0016               *  R10LB = Use as slot counter
0017               *  TMP2  = 2nd word of slot data
0018               *  TMP3  = Address of routine to call
0019               ********|*****|*********************|**************************
0020 2DD8 0300  24 tmgr    limi  0                     ; No interrupt processing
     2DDA 0000     
0021               *--------------------------------------------------------------
0022               * Read VDP status register
0023               *--------------------------------------------------------------
0024 2DDC D360  34 tmgr1   movb  @vdps,r13             ; Save copy of VDP status register in R13
     2DDE 8802     
0025               *--------------------------------------------------------------
0026               * Latch sprite collision flag
0027               *--------------------------------------------------------------
0028 2DE0 2360  38         coc   @wbit2,r13            ; C flag on ?
     2DE2 201C     
0029 2DE4 1602  14         jne   tmgr1a                ; No, so move on
0030 2DE6 E0A0  34         soc   @wbit12,config        ; Latch bit 12 in config register
     2DE8 2008     
0031               *--------------------------------------------------------------
0032               * Interrupt flag
0033               *--------------------------------------------------------------
0034 2DEA 2360  38 tmgr1a  coc   @wbit0,r13            ; Interupt flag set ?
     2DEC 2020     
0035 2DEE 1311  14         jeq   tmgr4                 ; Yes, process slots 0..n
0036               *--------------------------------------------------------------
0037               * Run speech player
0038               *--------------------------------------------------------------
0044               *--------------------------------------------------------------
0045               * Run kernel thread
0046               *--------------------------------------------------------------
0047 2DF0 20A0  38 tmgr2   coc   @wbit8,config         ; Kernel thread blocked ?
     2DF2 2010     
0048 2DF4 1305  14         jeq   tmgr3                 ; Yes, skip to user hook
0049 2DF6 20A0  38         coc   @wbit9,config         ; Kernel thread enabled ?
     2DF8 200E     
0050 2DFA 1602  14         jne   tmgr3                 ; No, skip to user hook
0051 2DFC 0460  28         b     @kthread              ; Run kernel thread
     2DFE 2E76     
0052               *--------------------------------------------------------------
0053               * Run user hook
0054               *--------------------------------------------------------------
0055 2E00 20A0  38 tmgr3   coc   @wbit6,config         ; User hook blocked ?
     2E02 2014     
0056 2E04 13EB  14         jeq   tmgr1
0057 2E06 20A0  38         coc   @wbit7,config         ; User hook enabled ?
     2E08 2012     
0058 2E0A 16E8  14         jne   tmgr1
0059 2E0C C120  34         mov   @wtiusr,tmp0
     2E0E 832E     
0060 2E10 0454  20         b     *tmp0                 ; Run user hook
0061               *--------------------------------------------------------------
0062               * Do internal housekeeping
0063               *--------------------------------------------------------------
0064 2E12 40A0  34 tmgr4   szc   @tmdat,config         ; Unblock kernel thread and user hook
     2E14 2E74     
0065 2E16 C10A  18         mov   r10,tmp0
0066 2E18 0244  22         andi  tmp0,>00ff            ; Clear HI byte
     2E1A 00FF     
0067 2E1C 20A0  38         coc   @wbit2,config         ; PAL flag set ?
     2E1E 201C     
0068 2E20 1303  14         jeq   tmgr5
0069 2E22 0284  22         ci    tmp0,60               ; 1 second reached ?
     2E24 003C     
0070 2E26 1002  14         jmp   tmgr6
0071 2E28 0284  22 tmgr5   ci    tmp0,50
     2E2A 0032     
0072 2E2C 1101  14 tmgr6   jlt   tmgr7                 ; No, continue
0073 2E2E 1001  14         jmp   tmgr8
0074 2E30 058A  14 tmgr7   inc   r10                   ; Increase tick counter
0075               *--------------------------------------------------------------
0076               * Loop over slots
0077               *--------------------------------------------------------------
0078 2E32 C120  34 tmgr8   mov   @wtitab,tmp0          ; Pointer to timer table
     2E34 832C     
0079 2E36 024A  22         andi  r10,>ff00             ; Use R10LB as slot counter. Reset.
     2E38 FF00     
0080 2E3A C1D4  26 tmgr9   mov   *tmp0,tmp3            ; Is slot empty ?
0081 2E3C 1316  14         jeq   tmgr11                ; Yes, get next slot
0082               *--------------------------------------------------------------
0083               *  Check if slot should be executed
0084               *--------------------------------------------------------------
0085 2E3E 05C4  14         inct  tmp0                  ; Second word of slot data
0086 2E40 0594  26         inc   *tmp0                 ; Update tick count in slot
0087 2E42 C194  26         mov   *tmp0,tmp2            ; Get second word of slot data
0088 2E44 9820  54         cb    @tmp2hb,@tmp2lb       ; Slot target count = Slot internal counter ?
     2E46 830C     
     2E48 830D     
0089 2E4A 1608  14         jne   tmgr10                ; No, get next slot
0090 2E4C 0246  22         andi  tmp2,>ff00            ; Clear internal counter
     2E4E FF00     
0091 2E50 C506  30         mov   tmp2,*tmp0            ; Update timer table
0092               *--------------------------------------------------------------
0093               *  Run slot, we only need TMP0 to survive
0094               *--------------------------------------------------------------
0095 2E52 C804  38         mov   tmp0,@wtitmp          ; Save TMP0
     2E54 8330     
0096 2E56 0697  24         bl    *tmp3                 ; Call routine in slot
0097 2E58 C120  34 slotok  mov   @wtitmp,tmp0          ; Restore TMP0
     2E5A 8330     
0098               *--------------------------------------------------------------
0099               *  Prepare for next slot
0100               *--------------------------------------------------------------
0101 2E5C 058A  14 tmgr10  inc   r10                   ; Next slot
0102 2E5E 9820  54         cb    @r10lb,@btihi         ; Last slot done ?
     2E60 8315     
     2E62 8314     
0103 2E64 1504  14         jgt   tmgr12                ; yes, Wait for next VDP interrupt
0104 2E66 05C4  14         inct  tmp0                  ; Offset for next slot
0105 2E68 10E8  14         jmp   tmgr9                 ; Process next slot
0106 2E6A 05C4  14 tmgr11  inct  tmp0                  ; Skip 2nd word of slot data
0107 2E6C 10F7  14         jmp   tmgr10                ; Process next slot
0108 2E6E 024A  22 tmgr12  andi  r10,>ff00             ; Use R10LB as tick counter. Reset.
     2E70 FF00     
0109 2E72 10B4  14         jmp   tmgr1
0110 2E74 0280     tmdat   data  >0280                 ; Bit 8 (kernel thread) and bit 6 (user hook)
0111               
                   < runlib.asm
0240                       copy  "timers_kthread.asm"       ; Timers / Kernel thread
     **** ****     > timers_kthread.asm
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
0015 2E76 E0A0  34 kthread soc   @wbit8,config         ; Block kernel thread
     2E78 2010     
0016               *--------------------------------------------------------------
0017               * Run sound player
0018               *--------------------------------------------------------------
0022 2E7A 20A0  38         coc   @wbit13,config        ; Sound player on ?
     2E7C 2006     
0023 2E7E 1602  14         jne   kthread_kb
0024 2E80 06A0  32         bl    @sdpla1               ; Run sound player
     2E82 284A     
0026               *--------------------------------------------------------------
0027               * Scan virtual keyboard
0028               *--------------------------------------------------------------
0029               kthread_kb
0031               *       <<skipped>>
0035               *--------------------------------------------------------------
0036               * Scan real keyboard
0037               *--------------------------------------------------------------
0042 2E84 06A0  32         bl    @rkscan               ; Scan full keyboard with ROM#0 KSCAN
     2E86 28CA     
0047               *--------------------------------------------------------------
0048               kthread_exit
0049 2E88 0460  28         b     @tmgr3                ; Exit
     2E8A 2E00     
                   < runlib.asm
0241                       copy  "timers_hooks.asm"         ; Timers / User hooks
     **** ****     > timers_hooks.asm
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
0017 2E8C C83B  50 mkhook  mov   *r11+,@wtiusr         ; Set user hook address
     2E8E 832E     
0018 2E90 E0A0  34         soc   @wbit7,config         ; Enable user hook
     2E92 2012     
0019 2E94 045B  20 mkhoo1  b     *r11                  ; Return
0020      2DDC     hookok  equ   tmgr1                 ; Exit point for user hook
0021               
0022               
0023               ***************************************************************
0024               * CLHOOK - Clear user hook
0025               ***************************************************************
0026               *  BL    @CLHOOK
0027               ********|*****|*********************|**************************
0028 2E96 04E0  34 clhook  clr   @wtiusr               ; Unset user hook address
     2E98 832E     
0029 2E9A 0242  22         andi  config,>feff          ; Disable user hook (bit 7=0)
     2E9C FEFF     
0030 2E9E 045B  20         b     *r11                  ; Return
                   < runlib.asm
0242               
0244                       copy  "timers_alloc.asm"         ; Timers / Slot calculation
     **** ****     > timers_alloc.asm
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
0017 2EA0 C13B  30 mkslot  mov   *r11+,tmp0
0018 2EA2 C17B  30         mov   *r11+,tmp1
0019               *--------------------------------------------------------------
0020               *  Calculate address of slot
0021               *--------------------------------------------------------------
0022 2EA4 C184  18         mov   tmp0,tmp2
0023 2EA6 0966  56         srl   tmp2,6                ; Right align & TMP2 = TMP2 * 4
0024 2EA8 A1A0  34         a     @wtitab,tmp2          ; Add table base
     2EAA 832C     
0025               *--------------------------------------------------------------
0026               *  Add slot to table
0027               *--------------------------------------------------------------
0028 2EAC CD85  34         mov   tmp1,*tmp2+           ; Store address of subroutine
0029 2EAE 0A84  56         sla   tmp0,8                ; Get rid of slot number
0030 2EB0 C584  30         mov   tmp0,*tmp2            ; Store target count and reset tick count
0031               *--------------------------------------------------------------
0032               *  Check for end of list
0033               *--------------------------------------------------------------
0034 2EB2 881B  46         c     *r11,@w$ffff          ; End of list ?
     2EB4 2022     
0035 2EB6 1301  14         jeq   mkslo1                ; Yes, exit
0036 2EB8 10F3  14         jmp   mkslot                ; Process next entry
0037               *--------------------------------------------------------------
0038               *  Exit
0039               *--------------------------------------------------------------
0040 2EBA 05CB  14 mkslo1  inct  r11
0041 2EBC 045B  20         b     *r11                  ; Exit
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
0052 2EBE C13B  30 clslot  mov   *r11+,tmp0
0053 2EC0 0A24  56 xlslot  sla   tmp0,2                ; TMP0 = TMP0*4
0054 2EC2 A120  34         a     @wtitab,tmp0          ; Add table base
     2EC4 832C     
0055 2EC6 04F4  30         clr   *tmp0+                ; Clear 1st word of slot
0056 2EC8 04D4  26         clr   *tmp0                 ; Clear 2nd word of slot
0057 2ECA 045B  20         b     *r11                  ; Exit
0058               
0059               
0060               ***************************************************************
0061               * RSSLOT - Reset single timer slot loop counter
0062               ***************************************************************
0063               *  BL    @RSSLOT
0064               *  DATA  P0
0065               *--------------------------------------------------------------
0066               *  P0 = Slot number
0067               ********|*****|*********************|**************************
0068 2ECC C13B  30 rsslot  mov   *r11+,tmp0
0069 2ECE 0A24  56         sla   tmp0,2                ; TMP0 = TMP0*4
0070 2ED0 A120  34         a     @wtitab,tmp0          ; Add table base
     2ED2 832C     
0071 2ED4 05C4  14         inct  tmp0                  ; Skip 1st word of slot
0072 2ED6 C154  26         mov   *tmp0,tmp1
0073 2ED8 0245  22         andi  tmp1,>ff00            ; Clear LSB (loop counter)
     2EDA FF00     
0074 2EDC C505  30         mov   tmp1,*tmp0
0075 2EDE 045B  20         b     *r11                  ; Exit
                   < runlib.asm
0246               
0247               
0248               
0249               *//////////////////////////////////////////////////////////////
0250               *                    RUNLIB INITIALISATION
0251               *//////////////////////////////////////////////////////////////
0252               
0253               ***************************************************************
0254               *  RUNLIB - Runtime library initalisation
0255               ***************************************************************
0256               *  B  @RUNLIB
0257               *--------------------------------------------------------------
0258               *  REMARKS
0259               *  if R0 in WS1 equals >4a4a we were called from the system
0260               *  crash handler so we return there after initialisation.
0261               
0262               *  If R1 in WS1 equals >FFFF we return to the TI title screen
0263               *  after clearing scratchpad memory. This has higher priority
0264               *  as crash handler flag R0.
0265               ********|*****|*********************|**************************
0272 2EE0 04E0  34 runlib  clr   @>8302                ; Reset exit flag (R1 in workspace WS1!)
     2EE2 8302     
0274               *--------------------------------------------------------------
0275               * Alternative entry point
0276               *--------------------------------------------------------------
0277 2EE4 0300  24 runli1  limi  0                     ; Turn off interrupts
     2EE6 0000     
0278 2EE8 02E0  18         lwpi  ws1                   ; Activate workspace 1
     2EEA 8300     
0279 2EEC C0E0  34         mov   @>83c0,r3             ; Get random seed from OS monitor
     2EEE 83C0     
0280               *--------------------------------------------------------------
0281               * Clear scratch-pad memory from R4 upwards
0282               *--------------------------------------------------------------
0283 2EF0 0202  20 runli2  li    r2,>8308
     2EF2 8308     
0284 2EF4 04F2  30 runli3  clr   *r2+                  ; Clear scratchpad >8306->83FF
0285 2EF6 0282  22         ci    r2,>8400
     2EF8 8400     
0286 2EFA 16FC  14         jne   runli3
0287               *--------------------------------------------------------------
0288               * Exit to TI-99/4A title screen ?
0289               *--------------------------------------------------------------
0290 2EFC 0281  22 runli3a ci    r1,>ffff              ; Exit flag set ?
     2EFE FFFF     
0291 2F00 1602  14         jne   runli4                ; No, continue
0292 2F02 0420  54         blwp  @0                    ; Yes, bye bye
     2F04 0000     
0293               *--------------------------------------------------------------
0294               * Determine if VDP is PAL or NTSC
0295               *--------------------------------------------------------------
0296 2F06 C803  38 runli4  mov   r3,@waux1             ; Store random seed
     2F08 833C     
0297 2F0A 04C1  14         clr   r1                    ; Reset counter
0298 2F0C 0202  20         li    r2,10                 ; We test 10 times
     2F0E 000A     
0299 2F10 C0E0  34 runli5  mov   @vdps,r3
     2F12 8802     
0300 2F14 20E0  38         coc   @wbit0,r3             ; Interupt flag set ?
     2F16 2020     
0301 2F18 1302  14         jeq   runli6
0302 2F1A 0581  14         inc   r1                    ; Increase counter
0303 2F1C 10F9  14         jmp   runli5
0304 2F1E 0602  14 runli6  dec   r2                    ; Next test
0305 2F20 16F7  14         jne   runli5
0306 2F22 0281  22         ci    r1,>1250              ; Max for NTSC reached ?
     2F24 1250     
0307 2F26 1202  14         jle   runli7                ; No, so it must be NTSC
0308 2F28 0262  22         ori   config,palon          ; Yes, it must be PAL, set flag
     2F2A 201C     
0309               *--------------------------------------------------------------
0310               * Copy machine code to scratchpad (prepare tight loop)
0311               *--------------------------------------------------------------
0312 2F2C 06A0  32 runli7  bl    @loadmc
     2F2E 222E     
0313               *--------------------------------------------------------------
0314               * Initialize registers, memory, ...
0315               *--------------------------------------------------------------
0316 2F30 04C1  14 runli9  clr   r1
0317 2F32 04C2  14         clr   r2
0318 2F34 04C3  14         clr   r3
0319 2F36 0209  20         li    stack,sp2.stktop      ; Set top of stack (grows downwards!)
     2F38 A900     
0320 2F3A 020F  20         li    r15,vdpw              ; Set VDP write address
     2F3C 8C00     
0322 2F3E 06A0  32         bl    @mute                 ; Mute sound generators
     2F40 280E     
0324               *--------------------------------------------------------------
0325               * Setup video memory
0326               *--------------------------------------------------------------
0328 2F42 0280  22         ci    r0,>4a4a              ; Crash flag set?
     2F44 4A4A     
0329 2F46 1605  14         jne   runlia
0330 2F48 06A0  32         bl    @filv                 ; Clear 12K VDP memory instead
     2F4A 22A2     
0331 2F4C 0000             data  >0000,>00,>3000       ; of 16K, so that PABs survive
     2F4E 0000     
     2F50 3000     
0336 2F52 06A0  32 runlia  bl    @filv
     2F54 22A2     
0337 2F56 0FC0             data  pctadr,spfclr,16      ; Load color table
     2F58 00F4     
     2F5A 0010     
0338               *--------------------------------------------------------------
0339               * Check if there is a F18A present
0340               *--------------------------------------------------------------
0342               *       <<skipped>>
0353               *--------------------------------------------------------------
0354               * Check if there is a speech synthesizer attached
0355               *--------------------------------------------------------------
0357               *       <<skipped>>
0361               *--------------------------------------------------------------
0362               * Load video mode table & font
0363               *--------------------------------------------------------------
0364 2F5C 06A0  32 runlic  bl    @vidtab               ; Load video mode table into VDP
     2F5E 230C     
0365 2F60 3664             data  spvmod                ; Equate selected video mode table
0366 2F62 0204  20         li    tmp0,spfont           ; Get font option
     2F64 000C     
0367 2F66 0544  14         inv   tmp0                  ; NOFONT (>FFFF) specified ?
0368 2F68 1304  14         jeq   runlid                ; Yes, skip it
0369 2F6A 06A0  32         bl    @ldfnt
     2F6C 2374     
0370 2F6E 1100             data  fntadr,spfont         ; Load specified font
     2F70 000C     
0371               *--------------------------------------------------------------
0372               * Did a system crash occur before runlib was called?
0373               *--------------------------------------------------------------
0374 2F72 0280  22 runlid  ci    r0,>4a4a              ; Crash flag set?
     2F74 4A4A     
0375 2F76 1602  14         jne   runlie                ; No, continue
0376 2F78 0460  28         b     @cpu.crash.main       ; Yes, back to crash handler
     2F7A 2086     
0377               *--------------------------------------------------------------
0378               * Branch to main program
0379               *--------------------------------------------------------------
0380 2F7C 0262  22 runlie  ori   config,>0040          ; Enable kernel thread (bit 9 on)
     2F7E 0040     
0381 2F80 0460  28         b     @main                 ; Give control to main program
     2F82 6046     
                   < stevie_b7.asm.16732
0041                       copy  "ram.resident.asm"
     **** ****     > ram.resident.asm
0001               * FILE......: ram.resident.asm
0002               * Purpose...: Resident modules in LOW MEMEXP callable from all ROM banks.
0003               
0004                       ;------------------------------------------------------
0005                       ; Low-level modules
0006                       ;------------------------------------------------------
0007                       copy  "rom.farjump.asm"        ; ROM bankswitch trampoline
     **** ****     > rom.farjump.asm
0001               * FILE......: rom.farjump.asm
0002               * Purpose...: Trampoline to routine in other ROM bank
0003               
0004               ***************************************************************
0005               * rom.farjump - Jump to routine in specified bank
0006               ***************************************************************
0007               *  bl   @rom.farjump
0008               *       data p0,p1
0009               *--------------------------------------------------------------
0010               *  p0 = Write address of target ROM bank
0011               *  p1 = Vector address with target address to jump to
0012               *  p2 = Write address of source ROM bank
0013               *--------------------------------------------------------------
0014               *  bl @xrom.farjump
0015               *
0016               *  tmp0 = Write address of target ROM bank
0017               *  tmp1 = Vector address with target address to jump to
0018               *  tmp2 = Write address of source ROM bank
0019               ********|*****|*********************|**************************
0020               rom.farjump:
0021 2F84 C13B  30         mov   *r11+,tmp0            ; P0
0022 2F86 C17B  30         mov   *r11+,tmp1            ; P1
0023 2F88 C1BB  30         mov   *r11+,tmp2            ; P2
0024                       ;------------------------------------------------------
0025                       ; Push registers to value stack (but not r11!)
0026                       ;------------------------------------------------------
0027               xrom.farjump:
0028 2F8A 0649  14         dect  stack
0029 2F8C C644  30         mov   tmp0,*stack           ; Push tmp0
0030 2F8E 0649  14         dect  stack
0031 2F90 C645  30         mov   tmp1,*stack           ; Push tmp1
0032 2F92 0649  14         dect  stack
0033 2F94 C646  30         mov   tmp2,*stack           ; Push tmp2
0034 2F96 0649  14         dect  stack
0035 2F98 C647  30         mov   tmp3,*stack           ; Push tmp3
0036                       ;------------------------------------------------------
0037                       ; Push to farjump return stack
0038                       ;------------------------------------------------------
0039 2F9A 0284  22         ci    tmp0,>6000            ; Invalid bank write address?
     2F9C 6000     
0040 2F9E 1116  14         jlt   rom.farjump.bankswitch.failed1
0041                                                   ; Crash if bogus value in bank write address
0042               
0043 2FA0 C1E0  34         mov   @tv.fj.stackpnt,tmp3  ; Get farjump stack pointer
     2FA2 A226     
0044 2FA4 0647  14         dect  tmp3
0045 2FA6 C5CB  30         mov   r11,*tmp3             ; Push return address to farjump stack
0046 2FA8 0647  14         dect  tmp3
0047 2FAA C5C6  30         mov   tmp2,*tmp3            ; Push source ROM bank to farjump stack
0048 2FAC C807  38         mov   tmp3,@tv.fj.stackpnt  ; Set farjump stack pointer
     2FAE A226     
0049               
0053               
0054                       ;------------------------------------------------------
0055                       ; Bankswitch to target 8K ROM bank
0056                       ;------------------------------------------------------
0057               rom.farjump.bankswitch.target.rom8k:
0058 2FB0 04D4  26         clr   *tmp0                 ; Switch to target ROM bank 8K >6000
0059 2FB2 1004  14         jmp   rom.farjump.bankswitch.tgt.done
0060                       ;------------------------------------------------------
0061                       ; Bankswitch to target 4K ROM / 4K RAM banks (FG99 advanced mode)
0062                       ;------------------------------------------------------
0063               rom.farjump.bankswitch.tgt.advfg99:
0064 2FB4 04D4  26         clr   *tmp0                 ; Switch to target ROM bank 4K >6000
0065 2FB6 0224  22         ai    tmp0,>0800
     2FB8 0800     
0066 2FBA 04D4  26         clr   *tmp0                 ; Switch to target RAM bank 4K >7000
0067                       ;------------------------------------------------------
0068                       ; Bankswitch to target bank(s) completed
0069                       ;------------------------------------------------------
0070               rom.farjump.bankswitch.tgt.done:
0071                       ;------------------------------------------------------
0072                       ; Deref vector from @trmpvector if >ffff
0073                       ;------------------------------------------------------
0074 2FBC 0285  22         ci    tmp1,>ffff
     2FBE FFFF     
0075 2FC0 1602  14         jne   !
0076 2FC2 C160  34         mov   @trmpvector,tmp1
     2FC4 A032     
0077                       ;------------------------------------------------------
0078                       ; Deref value in vector
0079                       ;------------------------------------------------------
0080 2FC6 C115  26 !       mov   *tmp1,tmp0            ; Deref value in vector address
0081 2FC8 1301  14         jeq   rom.farjump.bankswitch.failed1
0082                                                   ; Crash if null-pointer in vector
0083               
0084 2FCA 1004  14         jmp   rom.farjump.bankswitch.call
0085                                                   ; Call function in target bank
0086                       ;------------------------------------------------------
0087                       ; Assert 1 failed before bank-switch
0088                       ;------------------------------------------------------
0089               rom.farjump.bankswitch.failed1:
0090 2FCC C80B  38         mov   r11,@>ffce            ; \ Save caller address
     2FCE FFCE     
0091 2FD0 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     2FD2 2026     
0092                       ;------------------------------------------------------
0093                       ; Call function in target bank
0094                       ;------------------------------------------------------
0095               rom.farjump.bankswitch.call:
0096 2FD4 0694  24         bl    *tmp0                 ; Call function
0097                       ;------------------------------------------------------
0098                       ; Bankswitch back to source bank
0099                       ;------------------------------------------------------
0100               rom.farjump.return:
0101 2FD6 C120  34         mov   @tv.fj.stackpnt,tmp0  ; Get farjump stack pointer
     2FD8 A226     
0102 2FDA C154  26         mov   *tmp0,tmp1            ; Get bank write address of caller
0103 2FDC 1312  14         jeq   rom.farjump.bankswitch.failed2
0104                                                   ; Crash if null-pointer in address
0105               
0106 2FDE 04F4  30         clr   *tmp0+                ; Remove bank write address from
0107                                                   ; farjump stack
0108               
0109 2FE0 C2D4  26         mov   *tmp0,r11             ; Get return addr of caller for return
0110               
0111 2FE2 04F4  30         clr   *tmp0+                ; Remove return address of caller from
0112                                                   ; farjump stack
0113               
0114 2FE4 028B  22         ci    r11,>6000
     2FE6 6000     
0115 2FE8 110C  14         jlt   rom.farjump.bankswitch.failed2
0116 2FEA 028B  22         ci    r11,>7fff
     2FEC 7FFF     
0117 2FEE 1509  14         jgt   rom.farjump.bankswitch.failed2
0118               
0119 2FF0 C804  38         mov   tmp0,@tv.fj.stackpnt  ; Update farjump return stack pointer
     2FF2 A226     
0120               
0124               
0125                       ;------------------------------------------------------
0126                       ; Bankswitch to source 8K ROM bank
0127                       ;------------------------------------------------------
0128               rom.farjump.bankswitch.src.rom8k:
0129 2FF4 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 8K >6000
0130 2FF6 1009  14         jmp   rom.farjump.exit
0131                       ;------------------------------------------------------
0132                       ; Bankswitch to source 4K ROM / 4K RAM banks (FG99 advanced mode)
0133                       ;------------------------------------------------------
0134               rom.farjump.bankswitch.src.advfg99:
0135 2FF8 04D5  26         clr   *tmp1                 ; Switch to source ROM bank 4K >6000
0136 2FFA 0225  22         ai    tmp1,>0800
     2FFC 0800     
0137 2FFE 04D5  26         clr   *tmp1                 ; Switch to source RAM bank 4K >7000
0138 3000 1004  14         jmp   rom.farjump.exit
0139                       ;------------------------------------------------------
0140                       ; Assert 2 failed after bank-switch
0141                       ;------------------------------------------------------
0142               rom.farjump.bankswitch.failed2:
0143 3002 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     3004 FFCE     
0144 3006 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     3008 2026     
0145                       ;-------------------------------------------------------
0146                       ; Exit
0147                       ;-------------------------------------------------------
0148               rom.farjump.exit:
0149 300A C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0150 300C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0151 300E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0152 3010 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0153 3012 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0008                       copy  "fb.asm"                 ; Framebuffer
     **** ****     > fb.asm
0001               * FILE......: fb.asm
0002               * Purpose...: Stevie Editor - Framebuffer module
0003               
0004               ***************************************************************
0005               * fb.init
0006               * Initialize framebuffer
0007               ***************************************************************
0008               *  bl   @fb.init
0009               *--------------------------------------------------------------
0010               *  INPUT
0011               *  none
0012               *--------------------------------------------------------------
0013               *  OUTPUT
0014               *  none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0
0018               ********|*****|*********************|**************************
0019               fb.init:
0020 3014 0649  14         dect  stack
0021 3016 C64B  30         mov   r11,*stack            ; Save return address
0022 3018 0649  14         dect  stack
0023 301A C644  30         mov   tmp0,*stack           ; Push tmp0
0024 301C 0649  14         dect  stack
0025 301E C645  30         mov   tmp1,*stack           ; Push tmp1
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 3020 0204  20         li    tmp0,fb.top
     3022 D000     
0030 3024 C804  38         mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
     3026 A300     
0031 3028 04E0  34         clr   @fb.topline           ; Top line in framebuffer
     302A A304     
0032 302C 04E0  34         clr   @fb.row               ; Current row=0
     302E A306     
0033 3030 04E0  34         clr   @fb.column            ; Current column=0
     3032 A30C     
0034               
0035 3034 0204  20         li    tmp0,colrow
     3036 0050     
0036 3038 C804  38         mov   tmp0,@fb.colsline     ; Columns per row=80
     303A A30E     
0037                       ;------------------------------------------------------
0038                       ; Determine size of rows on screen
0039                       ;------------------------------------------------------
0040 303C C160  34         mov   @tv.ruler.visible,tmp1
     303E A210     
0041 3040 1303  14         jeq   !                     ; Skip if ruler is hidden
0042 3042 0204  20         li    tmp0,pane.botrow-2
     3044 0015     
0043 3046 1002  14         jmp   fb.init.cont
0044 3048 0204  20 !       li    tmp0,pane.botrow-1
     304A 0016     
0045                       ;------------------------------------------------------
0046                       ; Continue initialisation
0047                       ;------------------------------------------------------
0048               fb.init.cont:
0049 304C C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen for fb
     304E A31A     
0050 3050 C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
     3052 A31C     
0051               
0052 3054 04E0  34         clr   @tv.pane.focus        ; Frame buffer has focus!
     3056 A222     
0053 3058 04E0  34         clr   @fb.colorize          ; Don't colorize M1/M2 lines
     305A A310     
0054 305C 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     305E A316     
0055 3060 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     3062 A318     
0056                       ;------------------------------------------------------
0057                       ; Clear frame buffer
0058                       ;------------------------------------------------------
0059 3064 06A0  32         bl    @film
     3066 224A     
0060 3068 D000             data  fb.top,>00,fb.size    ; Clear it all the way
     306A 0000     
     306C 0960     
0061                       ;------------------------------------------------------
0062                       ; Exit
0063                       ;------------------------------------------------------
0064               fb.init.exit:
0065 306E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0066 3070 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0067 3072 C2F9  30         mov   *stack+,r11           ; Pop r11
0068 3074 045B  20         b     *r11                  ; Return to caller
0069               
                   < ram.resident.asm
0009                       copy  "fb.utils.asm"           ; Framebuffer utilities
     **** ****     > fb.utils.asm
0001               * FILE......: fb.utils.asm
0002               * Purpose...: Stevie Editor - Framebuffer utilities
0003               
0004               ***************************************************************
0005               * fb.row2line
0006               * Calculate line in editor buffer
0007               ***************************************************************
0008               * bl @fb.row2line
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @fb.topline = Top line in frame buffer
0012               * @parm1      = Row in frame buffer (offset 0..@fb.scrrows)
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * @outparm1 = Matching line in editor buffer
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0
0019               *--------------------------------------------------------------
0020               * Formula
0021               * outparm1 = @fb.topline + @parm1
0022               ********|*****|*********************|**************************
0023               fb.row2line:
0024 3076 0649  14         dect  stack
0025 3078 C64B  30         mov   r11,*stack            ; Save return address
0026 307A 0649  14         dect  stack
0027 307C C644  30         mov   tmp0,*stack           ; Push tmp0
0028                       ;------------------------------------------------------
0029                       ; Calculate line in editor buffer
0030                       ;------------------------------------------------------
0031 307E C120  34         mov   @parm1,tmp0
     3080 A006     
0032 3082 A120  34         a     @fb.topline,tmp0
     3084 A304     
0033 3086 C804  38         mov   tmp0,@outparm1
     3088 A016     
0034                       ;------------------------------------------------------
0035                       ; Exit
0036                       ;------------------------------------------------------
0037               fb.row2line.exit:
0038 308A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0039 308C C2F9  30         mov   *stack+,r11           ; Pop r11
0040 308E 045B  20         b     *r11                  ; Return to caller
0041               
0042               
0043               
0044               
0045               ***************************************************************
0046               * fb.calc_pointer
0047               * Calculate pointer address in frame buffer
0048               ***************************************************************
0049               * bl @fb.calc_pointer
0050               *--------------------------------------------------------------
0051               * INPUT
0052               * @fb.top       = Address of top row in frame buffer
0053               * @fb.topline   = Top line in frame buffer
0054               * @fb.row       = Current row in frame buffer (offset 0..@fb.scrrows)
0055               * @fb.column    = Current column in frame buffer
0056               * @fb.colsline  = Columns per line in frame buffer
0057               *--------------------------------------------------------------
0058               * OUTPUT
0059               * @fb.current   = Updated pointer
0060               *--------------------------------------------------------------
0061               * Register usage
0062               * tmp0,tmp1
0063               *--------------------------------------------------------------
0064               * Formula
0065               * pointer = row * colsline + column + deref(@fb.top.ptr)
0066               ********|*****|*********************|**************************
0067               fb.calc_pointer:
0068 3090 0649  14         dect  stack
0069 3092 C64B  30         mov   r11,*stack            ; Save return address
0070 3094 0649  14         dect  stack
0071 3096 C644  30         mov   tmp0,*stack           ; Push tmp0
0072 3098 0649  14         dect  stack
0073 309A C645  30         mov   tmp1,*stack           ; Push tmp1
0074                       ;------------------------------------------------------
0075                       ; Calculate pointer
0076                       ;------------------------------------------------------
0077 309C C120  34         mov   @fb.row,tmp0
     309E A306     
0078 30A0 3920  72         mpy   @fb.colsline,tmp0     ; tmp1 = row  * colsline
     30A2 A30E     
0079 30A4 A160  34         a     @fb.column,tmp1       ; tmp1 = tmp1 + column
     30A6 A30C     
0080 30A8 A160  34         a     @fb.top.ptr,tmp1      ; tmp1 = tmp1 + base
     30AA A300     
0081 30AC C805  38         mov   tmp1,@fb.current
     30AE A302     
0082                       ;------------------------------------------------------
0083                       ; Exit
0084                       ;------------------------------------------------------
0085               fb.calc_pointer.exit:
0086 30B0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0087 30B2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0088 30B4 C2F9  30         mov   *stack+,r11           ; Pop r11
0089 30B6 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0010                       copy  "idx.asm"                ; Index management
     **** ****     > idx.asm
0001               * FILE......: idx.asm
0002               * Purpose...: Index management
0003               
0004               ***************************************************************
0005               *  Size of index page is 4K and allows indexing of 2048 lines
0006               *  per page.
0007               *
0008               *  Each index slot (word) has the format:
0009               *    +-----+-----+
0010               *    | MSB | LSB |
0011               *    +-----|-----+   LSB = Pointer offset 00-ff.
0012               *
0013               *  MSB = SAMS Page 40-ff
0014               *        Allows addressing of up to 256 4K SAMS pages (1024 KB)
0015               *
0016               *  LSB = Pointer offset in range 00-ff
0017               *
0018               *        To calculate pointer to line in Editor buffer:
0019               *        Pointer address = edb.top + (LSB * 16)
0020               *
0021               *        Note that the editor buffer itself resides in own 4K memory range
0022               *        starting at edb.top
0023               *
0024               *        All support routines must assure that length-prefixed string in
0025               *        Editor buffer always start on a 16 byte boundary for being
0026               *        accessible via index.
0027               *
0028               *
0029               * The index starts at SAMS page >20 and can allocate up to page >3f
0030               * for a total of 32 pages (128 K). With that up to 65536 lines of text
0031               * can be addressed.
0032               ***************************************************************
0033               
0034               
0035               ***************************************************************
0036               * idx.init
0037               * Initialize index
0038               ***************************************************************
0039               * bl @idx.init
0040               *--------------------------------------------------------------
0041               * INPUT
0042               * none
0043               *--------------------------------------------------------------
0044               * OUTPUT
0045               * none
0046               *--------------------------------------------------------------
0047               * Register usage
0048               * tmp0
0049               ********|*****|*********************|**************************
0050               idx.init:
0051 30B8 0649  14         dect  stack
0052 30BA C64B  30         mov   r11,*stack            ; Save return address
0053 30BC 0649  14         dect  stack
0054 30BE C644  30         mov   tmp0,*stack           ; Push tmp0
0055                       ;------------------------------------------------------
0056                       ; Initialize
0057                       ;------------------------------------------------------
0058 30C0 0204  20         li    tmp0,idx.top
     30C2 B000     
0059 30C4 C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     30C6 A502     
0060               
0061 30C8 C120  34         mov   @tv.sams.b000,tmp0
     30CA A206     
0062 30CC C804  38         mov   tmp0,@idx.sams.page   ; Set current SAMS page
     30CE A600     
0063 30D0 C804  38         mov   tmp0,@idx.sams.lopage ; Set 1st SAMS page
     30D2 A602     
0064                       ;------------------------------------------------------
0065                       ; Clear all index pages
0066                       ;------------------------------------------------------
0067 30D4 0224  22         ai    tmp0,4                ; \ Let's clear all index pages
     30D6 0004     
0068 30D8 C804  38         mov   tmp0,@idx.sams.hipage ; /
     30DA A604     
0069               
0070 30DC 06A0  32         bl    @_idx.sams.mapcolumn.on
     30DE 30FA     
0071                                                   ; Index in continuous memory region
0072               
0073 30E0 06A0  32         bl    @film
     30E2 224A     
0074 30E4 B000                   data idx.top,>00,idx.size * 5
     30E6 0000     
     30E8 5000     
0075                                                   ; Clear index
0076               
0077 30EA 06A0  32         bl    @_idx.sams.mapcolumn.off
     30EC 312E     
0078                                                   ; Restore memory window layout
0079               
0080 30EE C820  54         mov   @idx.sams.lopage,@idx.sams.hipage
     30F0 A602     
     30F2 A604     
0081                                                   ; Reset last SAMS page
0082                       ;------------------------------------------------------
0083                       ; Exit
0084                       ;------------------------------------------------------
0085               idx.init.exit:
0086 30F4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0087 30F6 C2F9  30         mov   *stack+,r11           ; Pop r11
0088 30F8 045B  20         b     *r11                  ; Return to caller
0089               
0090               
0091               ***************************************************************
0092               * bl @_idx.sams.mapcolumn.on
0093               *--------------------------------------------------------------
0094               * Register usage
0095               * tmp0, tmp1, tmp2
0096               *--------------------------------------------------------------
0097               *  Remarks
0098               *  Private, only to be called from inside idx module
0099               ********|*****|*********************|**************************
0100               _idx.sams.mapcolumn.on:
0101 30FA 0649  14         dect  stack
0102 30FC C64B  30         mov   r11,*stack            ; Push return address
0103 30FE 0649  14         dect  stack
0104 3100 C644  30         mov   tmp0,*stack           ; Push tmp0
0105 3102 0649  14         dect  stack
0106 3104 C645  30         mov   tmp1,*stack           ; Push tmp1
0107 3106 0649  14         dect  stack
0108 3108 C646  30         mov   tmp2,*stack           ; Push tmp2
0109               *--------------------------------------------------------------
0110               * Map index pages into memory window  (b000-ffff)
0111               *--------------------------------------------------------------
0112 310A C120  34         mov   @idx.sams.lopage,tmp0 ; Get lowest index page
     310C A602     
0113 310E 0205  20         li    tmp1,idx.top
     3110 B000     
0114 3112 0206  20         li    tmp2,5                ; Set loop counter. all pages of index
     3114 0005     
0115                       ;-------------------------------------------------------
0116                       ; Loop over banks
0117                       ;-------------------------------------------------------
0118 3116 06A0  32 !       bl    @xsams.page.set       ; Set SAMS page
     3118 258A     
0119                                                   ; \ i  tmp0  = SAMS page number
0120                                                   ; / i  tmp1  = Memory address
0121               
0122 311A 0584  14         inc   tmp0                  ; Next SAMS index page
0123 311C 0225  22         ai    tmp1,>1000            ; Next memory region
     311E 1000     
0124 3120 0606  14         dec   tmp2                  ; Update loop counter
0125 3122 15F9  14         jgt   -!                    ; Next iteration
0126               *--------------------------------------------------------------
0127               * Exit
0128               *--------------------------------------------------------------
0129               _idx.sams.mapcolumn.on.exit:
0130 3124 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0131 3126 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0132 3128 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0133 312A C2F9  30         mov   *stack+,r11           ; Pop return address
0134 312C 045B  20         b     *r11                  ; Return to caller
0135               
0136               
0137               ***************************************************************
0138               * _idx.sams.mapcolumn.off
0139               * Restore normal SAMS layout again (single index page)
0140               ***************************************************************
0141               * bl @_idx.sams.mapcolumn.off
0142               *--------------------------------------------------------------
0143               * Register usage
0144               * tmp0, tmp1, tmp2, tmp3
0145               *--------------------------------------------------------------
0146               *  Remarks
0147               *  Private, only to be called from inside idx module
0148               ********|*****|*********************|**************************
0149               _idx.sams.mapcolumn.off:
0150 312E 0649  14         dect  stack
0151 3130 C64B  30         mov   r11,*stack            ; Push return address
0152 3132 0649  14         dect  stack
0153 3134 C644  30         mov   tmp0,*stack           ; Push tmp0
0154 3136 0649  14         dect  stack
0155 3138 C645  30         mov   tmp1,*stack           ; Push tmp1
0156 313A 0649  14         dect  stack
0157 313C C646  30         mov   tmp2,*stack           ; Push tmp2
0158 313E 0649  14         dect  stack
0159 3140 C647  30         mov   tmp3,*stack           ; Push tmp3
0160               *--------------------------------------------------------------
0161               * Map index pages into memory window  (b000-????)
0162               *--------------------------------------------------------------
0163 3142 0205  20         li    tmp1,idx.top
     3144 B000     
0164 3146 0206  20         li    tmp2,5                ; Always 5 pages
     3148 0005     
0165 314A 0207  20         li    tmp3,tv.sams.b000     ; Pointer to fist SAMS page
     314C A206     
0166                       ;-------------------------------------------------------
0167                       ; Loop over table in memory (@tv.sams.b000:@tv.sams.f000)
0168                       ;-------------------------------------------------------
0169 314E C137  30 !       mov   *tmp3+,tmp0           ; Get SAMS page
0170               
0171 3150 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     3152 258A     
0172                                                   ; \ i  tmp0  = SAMS page number
0173                                                   ; / i  tmp1  = Memory address
0174               
0175 3154 0225  22         ai    tmp1,>1000            ; Next memory region
     3156 1000     
0176 3158 0606  14         dec   tmp2                  ; Update loop counter
0177 315A 15F9  14         jgt   -!                    ; Next iteration
0178               *--------------------------------------------------------------
0179               * Exit
0180               *--------------------------------------------------------------
0181               _idx.sams.mapcolumn.off.exit:
0182 315C C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0183 315E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0184 3160 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0185 3162 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0186 3164 C2F9  30         mov   *stack+,r11           ; Pop return address
0187 3166 045B  20         b     *r11                  ; Return to caller
0188               
0189               
0190               
0191               ***************************************************************
0192               * _idx.samspage.get
0193               * Get SAMS page for index
0194               ***************************************************************
0195               * bl @_idx.samspage.get
0196               *--------------------------------------------------------------
0197               * INPUT
0198               * tmp0 = Line number
0199               *--------------------------------------------------------------
0200               * OUTPUT
0201               * @outparm1 = Offset for index entry in index SAMS page
0202               *--------------------------------------------------------------
0203               * Register usage
0204               * tmp0, tmp1, tmp2
0205               *--------------------------------------------------------------
0206               *  Remarks
0207               *  Private, only to be called from inside idx module.
0208               *  Activates SAMS page containing required index slot entry.
0209               ********|*****|*********************|**************************
0210               _idx.samspage.get:
0211 3168 0649  14         dect  stack
0212 316A C64B  30         mov   r11,*stack            ; Save return address
0213 316C 0649  14         dect  stack
0214 316E C644  30         mov   tmp0,*stack           ; Push tmp0
0215 3170 0649  14         dect  stack
0216 3172 C645  30         mov   tmp1,*stack           ; Push tmp1
0217 3174 0649  14         dect  stack
0218 3176 C646  30         mov   tmp2,*stack           ; Push tmp2
0219                       ;------------------------------------------------------
0220                       ; Determine SAMS index page
0221                       ;------------------------------------------------------
0222 3178 C184  18         mov   tmp0,tmp2             ; Line number
0223 317A 04C5  14         clr   tmp1                  ; MSW (tmp1) = 0 / LSW (tmp2) = Line number
0224 317C 0204  20         li    tmp0,2048             ; Index entries in 4K SAMS page
     317E 0800     
0225               
0226 3180 3D44 128         div   tmp0,tmp1             ; \ Divide 32 bit value by 2048
0227                                                   ; | tmp1 = quotient  (SAMS page offset)
0228                                                   ; / tmp2 = remainder
0229               
0230 3182 0A16  56         sla   tmp2,1                ; line number * 2
0231 3184 C806  38         mov   tmp2,@outparm1        ; Offset index entry
     3186 A016     
0232               
0233 3188 A160  34         a     @idx.sams.lopage,tmp1 ; Add SAMS page base
     318A A602     
0234 318C 8805  38         c     tmp1,@idx.sams.page   ; Page already active?
     318E A600     
0235               
0236 3190 130E  14         jeq   _idx.samspage.get.exit
0237                                                   ; Yes, so exit
0238                       ;------------------------------------------------------
0239                       ; Activate SAMS index page
0240                       ;------------------------------------------------------
0241 3192 C805  38         mov   tmp1,@idx.sams.page   ; Set current SAMS page
     3194 A600     
0242 3196 C805  38         mov   tmp1,@tv.sams.b000    ; Also keep SAMS window synced in Stevie
     3198 A206     
0243 319A C105  18         mov   tmp1,tmp0             ; Destination SAMS page
0244               
0245 319C 0205  20         li    tmp1,>b000            ; Memory window for index page
     319E B000     
0246               
0247 31A0 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     31A2 258A     
0248                                                   ; \ i  tmp0 = SAMS page
0249                                                   ; / i  tmp1 = Memory address
0250                       ;------------------------------------------------------
0251                       ; Check if new highest SAMS index page
0252                       ;------------------------------------------------------
0253 31A4 8804  38         c     tmp0,@idx.sams.hipage ; New highest page?
     31A6 A604     
0254 31A8 1202  14         jle   _idx.samspage.get.exit
0255                                                   ; No, exit
0256 31AA C804  38         mov   tmp0,@idx.sams.hipage ; Yes, set highest SAMS index page
     31AC A604     
0257                       ;------------------------------------------------------
0258                       ; Exit
0259                       ;------------------------------------------------------
0260               _idx.samspage.get.exit:
0261 31AE C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0262 31B0 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0263 31B2 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0264 31B4 C2F9  30         mov   *stack+,r11           ; Pop r11
0265 31B6 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0011                       copy  "edb.asm"                ; Editor Buffer
     **** ****     > edb.asm
0001               * FILE......: edb.asm
0002               * Purpose...: Stevie Editor - Editor Buffer module
0003               
0004               ***************************************************************
0005               * edb.init
0006               * Initialize Editor buffer
0007               ***************************************************************
0008               * bl @edb.init
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0
0018               *--------------------------------------------------------------
0019               * Notes
0020               ***************************************************************
0021               edb.init:
0022 31B8 0649  14         dect  stack
0023 31BA C64B  30         mov   r11,*stack            ; Save return address
0024 31BC 0649  14         dect  stack
0025 31BE C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 31C0 0204  20         li    tmp0,edb.top          ; \
     31C2 C000     
0030 31C4 C804  38         mov   tmp0,@edb.top.ptr     ; / Set pointer to top of editor buffer
     31C6 A500     
0031 31C8 C804  38         mov   tmp0,@edb.next_free.ptr
     31CA A508     
0032                                                   ; Set pointer to next free line
0033               
0034 31CC 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     31CE A50A     
0035               
0036 31D0 0204  20         li    tmp0,1
     31D2 0001     
0037 31D4 C804  38         mov   tmp0,@edb.lines       ; Lines=1
     31D6 A504     
0038               
0039 31D8 0720  34         seto  @edb.block.m1         ; Reset block start line
     31DA A50C     
0040 31DC 0720  34         seto  @edb.block.m2         ; Reset block end line
     31DE A50E     
0041               
0042               
0043 31E0 C120  34         mov   @tib.session,tmp0     ; Get TI Basic session
     31E2 A0B4     
0044 31E4 0A14  56         sla   tmp0,1                ; Align to word boundary
0045 31E6 C824  54         mov   @data.filename.ptr(tmp0),@edb.filename.ptr
     31E8 3202     
     31EA A512     
0046               
0047               
0048 31EC 04E0  34         clr   @fh.kilobytes         ; \ Clear kilobytes processed
     31EE A440     
0049 31F0 04E0  34         clr   @fh.kilobytes.prev    ; /
     31F2 A45C     
0050               
0051 31F4 0204  20         li    tmp0,txt.filetype.none
     31F6 39B4     
0052 31F8 C804  38         mov   tmp0,@edb.filetype.ptr
     31FA A514     
0053               
0054               edb.init.exit:
0055                       ;------------------------------------------------------
0056                       ; Exit
0057                       ;------------------------------------------------------
0058 31FC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0059 31FE C2F9  30         mov   *stack+,r11           ; Pop r11
0060 3200 045B  20         b     *r11                  ; Return to caller
0061               
0062               
0063               
0064               data.filename.ptr:
0065 3202 388A             data  txt.newfile,txt.tib1,txt.tib2,txt.tib3,txt.tib4,txt.tib5
     3204 3896     
     3206 38A4     
     3208 38B2     
     320A 38C0     
     320C 38CE     
                   < ram.resident.asm
0012                       copy  "cmdb.asm"               ; Command buffer
     **** ****     > cmdb.asm
0001               * FILE......: cmdb.asm
0002               * Purpose...: Stevie Editor - Command Buffer module
0003               
0004               ***************************************************************
0005               * cmdb.init
0006               * Initialize Command Buffer
0007               ***************************************************************
0008               * bl @cmdb.init
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * none
0018               *--------------------------------------------------------------
0019               * Notes
0020               ********|*****|*********************|**************************
0021               cmdb.init:
0022 320E 0649  14         dect  stack
0023 3210 C64B  30         mov   r11,*stack            ; Save return address
0024 3212 0649  14         dect  stack
0025 3214 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 3216 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     3218 E000     
0030 321A C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     321C A700     
0031               
0032 321E 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     3220 A702     
0033 3222 0204  20         li    tmp0,4
     3224 0004     
0034 3226 C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     3228 A706     
0035 322A C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     322C A708     
0036               
0037 322E 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     3230 A716     
0038 3232 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     3234 A718     
0039 3236 04E0  34         clr   @cmdb.action.ptr      ; Reset action to execute pointer
     3238 A728     
0040                       ;------------------------------------------------------
0041                       ; Clear command buffer
0042                       ;------------------------------------------------------
0043 323A 06A0  32         bl    @film
     323C 224A     
0044 323E E000             data  cmdb.top,>00,cmdb.size
     3240 0000     
     3242 1000     
0045                                                   ; Clear it all the way
0046               cmdb.init.exit:
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050 3244 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0051 3246 C2F9  30         mov   *stack+,r11           ; Pop r11
0052 3248 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0013                       copy  "errpane.asm"            ; Error pane
     **** ****     > errpane.asm
0001               * FILE......: errpane.asm
0002               * Purpose...: Error pane utilities
0003               
0004               ***************************************************************
0005               * errpane.init
0006               * Initialize error pane
0007               ***************************************************************
0008               * bl @errpane.init
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0,tmp1,tmp2
0018               *--------------------------------------------------------------
0019               * Notes
0020               ***************************************************************
0021               errpane.init:
0022 324A 0649  14         dect  stack
0023 324C C64B  30         mov   r11,*stack            ; Save return address
0024 324E 0649  14         dect  stack
0025 3250 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 3252 0649  14         dect  stack
0027 3254 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 3256 0649  14         dect  stack
0029 3258 C646  30         mov   tmp2,*stack           ; Push tmp2
0030                       ;------------------------------------------------------
0031                       ; Initialize
0032                       ;------------------------------------------------------
0033 325A 04E0  34         clr   @tv.error.visible     ; Set to hidden
     325C A228     
0034 325E 0204  20         li    tmp0,3
     3260 0003     
0035 3262 C804  38         mov   tmp0,@tv.error.rows   ; Number of rows in error pane
     3264 A22A     
0036               
0037 3266 06A0  32         bl    @film
     3268 224A     
0038 326A A230                   data tv.error.msg,0,160
     326C 0000     
     326E 00A0     
0039                       ;-------------------------------------------------------
0040                       ; Exit
0041                       ;-------------------------------------------------------
0042               errpane.exit:
0043 3270 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0044 3272 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0045 3274 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0046 3276 C2F9  30         mov   *stack+,r11           ; Pop R11
0047 3278 045B  20         b     *r11                  ; Return to caller
0048               
                   < ram.resident.asm
0014                       copy  "tv.asm"                 ; Main editor configuration
     **** ****     > tv.asm
0001               * FILE......: tv.asm
0002               * Purpose...: Initialize editor
0003               
0004               ***************************************************************
0005               * tv.init
0006               * Initialize editor settings
0007               ***************************************************************
0008               * bl @tv.init
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0
0018               *--------------------------------------------------------------
0019               * Notes
0020               ***************************************************************
0021               tv.init:
0022 327A 0649  14         dect  stack
0023 327C C64B  30         mov   r11,*stack            ; Save return address
0024 327E 0649  14         dect  stack
0025 3280 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 3282 0649  14         dect  stack
0027 3284 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 3286 0649  14         dect  stack
0029 3288 C646  30         mov   tmp2,*stack           ; Push tmp2
0030                       ;------------------------------------------------------
0031                       ; Initialize
0032                       ;------------------------------------------------------
0033 328A 0204  20         li    tmp0,1                ; \ Set default color scheme
     328C 0001     
0034 328E C804  38         mov   tmp0,@tv.colorscheme  ; /
     3290 A212     
0035               
0036 3292 04E0  34         clr   @tv.task.oneshot      ; Reset pointer to oneshot task
     3294 A224     
0037 3296 E0A0  34         soc   @wbit10,config        ; Assume ALPHA LOCK is down
     3298 200C     
0038               
0039 329A 0204  20         li    tmp0,fj.bottom
     329C B000     
0040 329E C804  38         mov   tmp0,@tv.fj.stackpnt  ; Set pointer to farjump return stack
     32A0 A226     
0041                       ;------------------------------------------------------
0042                       ; Set defaults
0043                       ;------------------------------------------------------
0044 32A2 06A0  32         bl    @cpym2m
     32A4 24EE     
0045 32A6 3A8C                   data def.printer.fname,tv.printer.fname,7
     32A8 DE00     
     32AA 0007     
0046               
0047 32AC 06A0  32         bl    @cpym2m
     32AE 24EE     
0048 32B0 3A94                   data def.clip.fname,tv.clip.fname,10
     32B2 DE50     
     32B4 000A     
0049                       ;-------------------------------------------------------
0050                       ; Exit
0051                       ;-------------------------------------------------------
0052               tv.init.exit:
0053 32B6 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0054 32B8 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0055 32BA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0056 32BC C2F9  30         mov   *stack+,r11           ; Pop R11
0057 32BE 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0015                       copy  "tv.quit.asm"            ; Exit Stevie and return to monitor
     **** ****     > tv.quit.asm
0001               * FILE......: tv.quit.asm
0002               * Purpose...: Quit Stevie and return to monitor
0003               
0004               ***************************************************************
0005               * tv.quit
0006               * Quit stevie and return to monitor
0007               ***************************************************************
0008               * b    @tv.quit
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * none
0018               ***************************************************************
0019               tv.quit:
0020                       ;-------------------------------------------------------
0021                       ; Reset/lock F18a
0022                       ;-------------------------------------------------------
0023 32C0 06A0  32         bl    @f18rst               ; Reset and lock the F18A
     32C2 27BA     
0024                       ;-------------------------------------------------------
0025                       ; Load legacy SAMS page layout and exit to monitor
0026                       ;-------------------------------------------------------
0027 32C4 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     32C6 2F84     
0028 32C8 600E                   data bank7.rom        ; | i  p0 = bank address
0029 32CA 7FC0                   data bankx.vectab     ; | i  p1 = Vector with target address
0030 32CC 600E                   data bankid           ; / i  p2 = Source ROM bank for return
0031               
0032                       ; We never return here. We call @mem.sams.set.legacy (vector1) and
0033                       ; in there activate bank 0 in cartridge space and return to monitor.
0034                       ;
0035                       ; Reason for doing so is that @tv.quit is located in
0036                       ; low memory expansion. So switching SAMS banks or turning off the SAMS
0037                       ; mapper results in invalid OPCODE's because the program just isn't
0038                       ; there in low memory expansion anymore.
                   < ram.resident.asm
0016                       copy  "tv.reset.asm"           ; Reset editor (clear buffers)
     **** ****     > tv.reset.asm
0001               * FILE......: tv.reset.asm
0002               * Purpose...: Reset editor (clear buffers)
0003               
0004               
0005               ***************************************************************
0006               * tv.reset
0007               * Reset editor (clear buffers)
0008               ***************************************************************
0009               * bl @tv.reset
0010               *--------------------------------------------------------------
0011               * INPUT
0012               * none
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * r11
0019               *--------------------------------------------------------------
0020               * Notes
0021               ********|*****|*********************|**************************
0022               tv.reset:
0023 32CE 0649  14         dect  stack
0024 32D0 C64B  30         mov   r11,*stack            ; Save return address
0025                       ;------------------------------------------------------
0026                       ; Reset editor
0027                       ;------------------------------------------------------
0028 32D2 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     32D4 320E     
0029 32D6 06A0  32         bl    @edb.init             ; Initialize editor buffer
     32D8 31B8     
0030 32DA 06A0  32         bl    @idx.init             ; Initialize index
     32DC 30B8     
0031 32DE 06A0  32         bl    @fb.init              ; Initialize framebuffer
     32E0 3014     
0032 32E2 06A0  32         bl    @errpane.init         ; Initialize error pane
     32E4 324A     
0033                       ;------------------------------------------------------
0034                       ; Remove markers and shortcuts
0035                       ;------------------------------------------------------
0036 32E6 06A0  32         bl    @hchar
     32E8 27E6     
0037 32EA 0034                   byte 0,52,32,18       ; Remove markers
     32EC 2012     
0038 32EE 1700                   byte pane.botrow,0,32,51
     32F0 2033     
0039 32F2 FFFF                   data eol              ; Remove block shortcuts
0040                       ;-------------------------------------------------------
0041                       ; Exit
0042                       ;-------------------------------------------------------
0043               tv.reset.exit:
0044 32F4 C2F9  30         mov   *stack+,r11           ; Pop R11
0045 32F6 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0017                       copy  "tv.unpack.uint16.asm"   ; Unpack 16bit unsigned integer to string
     **** ****     > tv.unpack.uint16.asm
0001               * FILE......: tv.unpack.uint16.asm
0002               * Purpose...: Unpack 16bit unsigned integer to string
0003               
0004               ***************************************************************
0005               * tv.unpack.uint16
0006               * Unpack 16bit unsigned integer to string
0007               ***************************************************************
0008               * bl @tv.unpack.uint16
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @parm1 = 16bit unsigned integer
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * @unpacked.string = Length-prefixed string with unpacked uint16
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * none
0018               ***************************************************************
0019               tv.unpack.uint16:
0020 32F8 0649  14         dect  stack
0021 32FA C64B  30         mov   r11,*stack            ; Save return address
0022 32FC 0649  14         dect  stack
0023 32FE C644  30         mov   tmp0,*stack           ; Push tmp0
0024                       ;------------------------------------------------------
0025                       ; Initialize
0026                       ;------------------------------------------------------
0027 3300 06A0  32         bl    @mknum                ; Convert unsigned number to string
     3302 29BA     
0028 3304 A006                   data parm1            ; \ i p0  = Pointer to 16bit unsigned number
0029 3306 A100                   data rambuf           ; | i p1  = Pointer to 5 byte string buffer
0030 3308 30                     byte 48               ; | i p2H = Offset for ASCII digit 0
0031 3309   20                   byte 32               ; / i p2L = Char for replacing leading 0's
0032               
0033 330A 0204  20         li    tmp0,unpacked.string
     330C A02C     
0034 330E 04F4  30         clr   *tmp0+                ; Clear string 01
0035 3310 04F4  30         clr   *tmp0+                ; Clear string 23
0036 3312 04F4  30         clr   *tmp0+                ; Clear string 34
0037               
0038 3314 06A0  32         bl    @trimnum              ; Trim unsigned number string
     3316 2A12     
0039 3318 A100                   data rambuf           ; \ i p0  = Pointer to 5 byte string buffer
0040 331A A02C                   data unpacked.string  ; | i p1  = Pointer to output buffer
0041 331C 0020                   data 32               ; / i p2  = Padding char to match against
0042                       ;-------------------------------------------------------
0043                       ; Exit
0044                       ;-------------------------------------------------------
0045               tv.unpack.uint16.exit:
0046 331E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0047 3320 C2F9  30         mov   *stack+,r11           ; Pop r11
0048 3322 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0018                       copy  "tv.pad.string.asm"      ; Pad string to specified length
     **** ****     > tv.pad.string.asm
0001               * FILE......: tv.pad.string.asm
0002               * Purpose...: pad string to specified length
0003               
0004               
0005               ***************************************************************
0006               * tv.pad.string
0007               * pad string to specified length
0008               ***************************************************************
0009               * bl @tv.pad.string
0010               *--------------------------------------------------------------
0011               * INPUT
0012               * @parm1 = Pointer to length-prefixed string
0013               * @parm2 = Requested length
0014               * @parm3 = Fill character
0015               * @parm4 = Pointer to string buffer
0016               *--------------------------------------------------------------
0017               * OUTPUT
0018               * @outparm1 = Pointer to padded string
0019               *--------------------------------------------------------------
0020               * Register usage
0021               * none
0022               ***************************************************************
0023               tv.pad.string:
0024 3324 0649  14         dect  stack
0025 3326 C64B  30         mov   r11,*stack            ; Push return address
0026 3328 0649  14         dect  stack
0027 332A C644  30         mov   tmp0,*stack           ; Push tmp0
0028 332C 0649  14         dect  stack
0029 332E C645  30         mov   tmp1,*stack           ; Push tmp1
0030 3330 0649  14         dect  stack
0031 3332 C646  30         mov   tmp2,*stack           ; Push tmp2
0032 3334 0649  14         dect  stack
0033 3336 C647  30         mov   tmp3,*stack           ; Push tmp3
0034                       ;------------------------------------------------------
0035                       ; Asserts
0036                       ;------------------------------------------------------
0037 3338 C120  34         mov   @parm1,tmp0           ; \ Get string prefix (length-byte)
     333A A006     
0038 333C D194  26         movb  *tmp0,tmp2            ; /
0039 333E 0986  56         srl   tmp2,8                ; Right align
0040 3340 C1C6  18         mov   tmp2,tmp3             ; Make copy of length-byte for later use
0041               
0042 3342 8806  38         c     tmp2,@parm2           ; String length > requested length?
     3344 A008     
0043 3346 1520  14         jgt   tv.pad.string.panic   ; Yes, crash
0044                       ;------------------------------------------------------
0045                       ; Copy string to buffer
0046                       ;------------------------------------------------------
0047 3348 C120  34         mov   @parm1,tmp0           ; Get source address
     334A A006     
0048 334C C160  34         mov   @parm4,tmp1           ; Get destination address
     334E A00C     
0049 3350 0586  14         inc   tmp2                  ; Also include length-byte in copy
0050               
0051 3352 0649  14         dect  stack
0052 3354 C647  30         mov   tmp3,*stack           ; Push tmp3 (get overwritten by xpym2m)
0053               
0054 3356 06A0  32         bl    @xpym2m               ; Copy length-prefix string to buffer
     3358 24F4     
0055                                                   ; \ i  tmp0 = Source CPU memory address
0056                                                   ; | i  tmp1 = Target CPU memory address
0057                                                   ; / i  tmp2 = Number of bytes to copy
0058               
0059 335A C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0060                       ;------------------------------------------------------
0061                       ; Set length of new string
0062                       ;------------------------------------------------------
0063 335C C120  34         mov   @parm2,tmp0           ; Get requested length
     335E A008     
0064 3360 0A84  56         sla   tmp0,8                ; Left align
0065 3362 C160  34         mov   @parm4,tmp1           ; Get pointer to buffer
     3364 A00C     
0066 3366 D544  30         movb  tmp0,*tmp1            ; Set new length of string
0067 3368 A147  18         a     tmp3,tmp1             ; \ Skip to end of string
0068 336A 0585  14         inc   tmp1                  ; /
0069                       ;------------------------------------------------------
0070                       ; Prepare for padding string
0071                       ;------------------------------------------------------
0072 336C C1A0  34         mov   @parm2,tmp2           ; \ Get number of bytes to fill
     336E A008     
0073 3370 6187  18         s     tmp3,tmp2             ; |
0074 3372 0586  14         inc   tmp2                  ; /
0075               
0076 3374 C120  34         mov   @parm3,tmp0           ; Get byte to padd
     3376 A00A     
0077 3378 0A84  56         sla   tmp0,8                ; Left align
0078                       ;------------------------------------------------------
0079                       ; Right-pad string to destination length
0080                       ;------------------------------------------------------
0081               tv.pad.string.loop:
0082 337A DD44  32         movb  tmp0,*tmp1+           ; Pad character
0083 337C 0606  14         dec   tmp2                  ; Update loop counter
0084 337E 15FD  14         jgt   tv.pad.string.loop    ; Next character
0085               
0086 3380 C820  54         mov   @parm4,@outparm1      ; Set pointer to padded string
     3382 A00C     
     3384 A016     
0087 3386 1004  14         jmp   tv.pad.string.exit    ; Exit
0088                       ;-----------------------------------------------------------------------
0089                       ; CPU crash
0090                       ;-----------------------------------------------------------------------
0091               tv.pad.string.panic:
0092 3388 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     338A FFCE     
0093 338C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     338E 2026     
0094                       ;------------------------------------------------------
0095                       ; Exit
0096                       ;------------------------------------------------------
0097               tv.pad.string.exit:
0098 3390 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0099 3392 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0100 3394 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0101 3396 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0102 3398 C2F9  30         mov   *stack+,r11           ; Pop r11
0103 339A 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0019                       ;-----------------------------------------------------------------------
0020                       ; Logic for Index management
0021                       ;-----------------------------------------------------------------------
0022                       copy  "idx.update.asm"         ; Index management - Update entry
     **** ****     > idx.update.asm
0001               * FILE......: idx.update.asm
0002               * Purpose...: Update index entry
0003               
0004               ***************************************************************
0005               * idx.entry.update
0006               * Update index entry - Each entry corresponds to a line
0007               ***************************************************************
0008               * bl @idx.entry.update
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @parm1    = Line number in editor buffer
0012               * @parm2    = Pointer to line in editor buffer
0013               * @parm3    = SAMS page
0014               *--------------------------------------------------------------
0015               * OUTPUT
0016               * @outparm1 = Pointer to updated index entry
0017               *--------------------------------------------------------------
0018               * Register usage
0019               * tmp0,tmp1,tmp2
0020               ********|*****|*********************|**************************
0021               idx.entry.update:
0022 339C 0649  14         dect  stack
0023 339E C64B  30         mov   r11,*stack            ; Save return address
0024 33A0 0649  14         dect  stack
0025 33A2 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 33A4 0649  14         dect  stack
0027 33A6 C645  30         mov   tmp1,*stack           ; Push tmp1
0028                       ;------------------------------------------------------
0029                       ; Get parameters
0030                       ;------------------------------------------------------
0031 33A8 C120  34         mov   @parm1,tmp0           ; Get line number
     33AA A006     
0032 33AC C160  34         mov   @parm2,tmp1           ; Get pointer
     33AE A008     
0033 33B0 1312  14         jeq   idx.entry.update.clear
0034                                                   ; Special handling for "null"-pointer
0035                       ;------------------------------------------------------
0036                       ; Calculate LSB value index slot (pointer offset)
0037                       ;------------------------------------------------------
0038 33B2 0245  22         andi  tmp1,>0fff            ; Remove high-nibble from pointer
     33B4 0FFF     
0039 33B6 0945  56         srl   tmp1,4                ; Get offset (divide by 16)
0040                       ;------------------------------------------------------
0041                       ; Calculate MSB value index slot (SAMS page editor buffer)
0042                       ;------------------------------------------------------
0043 33B8 06E0  34         swpb  @parm3
     33BA A00A     
0044 33BC D160  34         movb  @parm3,tmp1           ; Put SAMS page in MSB
     33BE A00A     
0045 33C0 06E0  34         swpb  @parm3                ; \ Restore original order again,
     33C2 A00A     
0046                                                   ; / important for messing up caller parm3!
0047                       ;------------------------------------------------------
0048                       ; Update index slot
0049                       ;------------------------------------------------------
0050               idx.entry.update.save:
0051 33C4 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     33C6 3168     
0052                                                   ; \ i  tmp0     = Line number
0053                                                   ; / o  outparm1 = Slot offset in SAMS page
0054               
0055 33C8 C120  34         mov   @outparm1,tmp0        ; \ Update index slot
     33CA A016     
0056 33CC C905  38         mov   tmp1,@idx.top(tmp0)   ; /
     33CE B000     
0057 33D0 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     33D2 A016     
0058 33D4 1008  14         jmp   idx.entry.update.exit
0059                       ;------------------------------------------------------
0060                       ; Special handling for "null"-pointer
0061                       ;------------------------------------------------------
0062               idx.entry.update.clear:
0063 33D6 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     33D8 3168     
0064                                                   ; \ i  tmp0     = Line number
0065                                                   ; / o  outparm1 = Slot offset in SAMS page
0066               
0067 33DA C120  34         mov   @outparm1,tmp0        ; \ Clear index slot
     33DC A016     
0068 33DE 04E4  34         clr   @idx.top(tmp0)        ; /
     33E0 B000     
0069 33E2 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     33E4 A016     
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               idx.entry.update.exit:
0074 33E6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0075 33E8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0076 33EA C2F9  30         mov   *stack+,r11           ; Pop r11
0077 33EC 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0023                       copy  "idx.pointer.asm"        ; Index management - Get pointer to line
     **** ****     > idx.pointer.asm
0001               * FILE......: idx.pointer.asm
0002               * Purpose...: Get pointer to line in editor buffer
0003               
0004               ***************************************************************
0005               * idx.pointer.get
0006               * Get pointer to editor buffer line content
0007               ***************************************************************
0008               * bl @idx.pointer.get
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @parm1 = Line number in editor buffer
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * @outparm1 = Pointer to editor buffer line content
0015               * @outparm2 = SAMS page
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0,tmp1,tmp2
0019               ********|*****|*********************|**************************
0020               idx.pointer.get:
0021 33EE 0649  14         dect  stack
0022 33F0 C64B  30         mov   r11,*stack            ; Save return address
0023 33F2 0649  14         dect  stack
0024 33F4 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 33F6 0649  14         dect  stack
0026 33F8 C645  30         mov   tmp1,*stack           ; Push tmp1
0027 33FA 0649  14         dect  stack
0028 33FC C646  30         mov   tmp2,*stack           ; Push tmp2
0029                       ;------------------------------------------------------
0030                       ; Get slot entry
0031                       ;------------------------------------------------------
0032 33FE C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     3400 A006     
0033               
0034 3402 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page with index slot
     3404 3168     
0035                                                   ; \ i  tmp0     = Line number
0036                                                   ; / o  outparm1 = Slot offset in SAMS page
0037               
0038 3406 C120  34         mov   @outparm1,tmp0        ; \ Get slot entry
     3408 A016     
0039 340A C164  34         mov   @idx.top(tmp0),tmp1   ; /
     340C B000     
0040               
0041 340E 130C  14         jeq   idx.pointer.get.parm.null
0042                                                   ; Skip if index slot empty
0043                       ;------------------------------------------------------
0044                       ; Calculate MSB (SAMS page)
0045                       ;------------------------------------------------------
0046 3410 C185  18         mov   tmp1,tmp2             ; \
0047 3412 0986  56         srl   tmp2,8                ; / Right align SAMS page
0048                       ;------------------------------------------------------
0049                       ; Calculate LSB (pointer address)
0050                       ;------------------------------------------------------
0051 3414 0245  22         andi  tmp1,>00ff            ; Get rid of MSB (SAMS page)
     3416 00FF     
0052 3418 0A45  56         sla   tmp1,4                ; Multiply with 16
0053 341A 0225  22         ai    tmp1,edb.top          ; Add editor buffer base address
     341C C000     
0054                       ;------------------------------------------------------
0055                       ; Return parameters
0056                       ;------------------------------------------------------
0057               idx.pointer.get.parm:
0058 341E C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     3420 A016     
0059 3422 C806  38         mov   tmp2,@outparm2        ; Index slot -> SAMS page
     3424 A018     
0060 3426 1004  14         jmp   idx.pointer.get.exit
0061                       ;------------------------------------------------------
0062                       ; Special handling for "null"-pointer
0063                       ;------------------------------------------------------
0064               idx.pointer.get.parm.null:
0065 3428 04E0  34         clr   @outparm1
     342A A016     
0066 342C 04E0  34         clr   @outparm2
     342E A018     
0067                       ;------------------------------------------------------
0068                       ; Exit
0069                       ;------------------------------------------------------
0070               idx.pointer.get.exit:
0071 3430 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0072 3432 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0073 3434 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0074 3436 C2F9  30         mov   *stack+,r11           ; Pop r11
0075 3438 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0024                       copy  "idx.delete.asm"         ; Index management - delete slot
     **** ****     > idx.delete.asm
0001               * FILE......: idx_delete.asm
0002               * Purpose...: Delete index entry
0003               
0004               ***************************************************************
0005               * _idx.entry.delete.reorg
0006               * Reorganize index slot entries
0007               ***************************************************************
0008               * bl @_idx.entry.delete.reorg
0009               *--------------------------------------------------------------
0010               *  Remarks
0011               *  Private, only to be called from idx_entry_delete
0012               ********|*****|*********************|**************************
0013               _idx.entry.delete.reorg:
0014                       ;------------------------------------------------------
0015                       ; Reorganize index entries
0016                       ;------------------------------------------------------
0017 343A 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     343C B000     
0018 343E C144  18         mov   tmp0,tmp1             ; a = current slot
0019 3440 05C5  14         inct  tmp1                  ; b = current slot + 2
0020                       ;------------------------------------------------------
0021                       ; Loop forward until end of index
0022                       ;------------------------------------------------------
0023               _idx.entry.delete.reorg.loop:
0024 3442 CD35  46         mov   *tmp1+,*tmp0+         ; Copy b -> a
0025 3444 0606  14         dec   tmp2                  ; tmp2--
0026 3446 16FD  14         jne   _idx.entry.delete.reorg.loop
0027                                                   ; Loop unless completed
0028 3448 045B  20         b     *r11                  ; Return to caller
0029               
0030               
0031               
0032               ***************************************************************
0033               * idx.entry.delete
0034               * Delete index entry - Close gap created by delete
0035               ***************************************************************
0036               * bl @idx.entry.delete
0037               *--------------------------------------------------------------
0038               * INPUT
0039               * @parm1    = Line number in editor buffer to delete
0040               * @parm2    = Line number of last line to check for reorg
0041               *--------------------------------------------------------------
0042               * Register usage
0043               * tmp0,tmp1,tmp2,tmp3
0044               ********|*****|*********************|**************************
0045               idx.entry.delete:
0046 344A 0649  14         dect  stack
0047 344C C64B  30         mov   r11,*stack            ; Save return address
0048 344E 0649  14         dect  stack
0049 3450 C644  30         mov   tmp0,*stack           ; Push tmp0
0050 3452 0649  14         dect  stack
0051 3454 C645  30         mov   tmp1,*stack           ; Push tmp1
0052 3456 0649  14         dect  stack
0053 3458 C646  30         mov   tmp2,*stack           ; Push tmp2
0054 345A 0649  14         dect  stack
0055 345C C647  30         mov   tmp3,*stack           ; Push tmp3
0056                       ;------------------------------------------------------
0057                       ; Get index slot
0058                       ;------------------------------------------------------
0059 345E C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     3460 A006     
0060               
0061 3462 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     3464 3168     
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; / o  outparm1 = Slot offset in SAMS page
0064               
0065 3466 C120  34         mov   @outparm1,tmp0        ; Index offset
     3468 A016     
0066                       ;------------------------------------------------------
0067                       ; Prepare for index reorg
0068                       ;------------------------------------------------------
0069 346A C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     346C A008     
0070 346E 1303  14         jeq   idx.entry.delete.lastline
0071                                                   ; Exit early if last line = 0
0072               
0073 3470 61A0  34         s     @parm1,tmp2           ; Calculate loop
     3472 A006     
0074 3474 1504  14         jgt   idx.entry.delete.reorg
0075                                                   ; Reorganize if loop counter > 0
0076                       ;------------------------------------------------------
0077                       ; Special treatment for last line
0078                       ;------------------------------------------------------
0079               idx.entry.delete.lastline:
0080 3476 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     3478 B000     
0081 347A 04D4  26         clr   *tmp0                 ; Clear index entry
0082 347C 1012  14         jmp   idx.entry.delete.exit ; Exit early
0083                       ;------------------------------------------------------
0084                       ; Reorganize index entries
0085                       ;------------------------------------------------------
0086               idx.entry.delete.reorg:
0087 347E C1E0  34         mov   @parm2,tmp3           ; Get last line to reorganize
     3480 A008     
0088 3482 0287  22         ci    tmp3,2048
     3484 0800     
0089 3486 120A  14         jle   idx.entry.delete.reorg.simple
0090                                                   ; Do simple reorg only if single
0091                                                   ; SAMS index page, otherwise complex reorg.
0092                       ;------------------------------------------------------
0093                       ; Complex index reorganization (multiple SAMS pages)
0094                       ;------------------------------------------------------
0095               idx.entry.delete.reorg.complex:
0096 3488 06A0  32         bl    @_idx.sams.mapcolumn.on
     348A 30FA     
0097                                                   ; Index in continuous memory region
0098               
0099                       ;-------------------------------------------------------
0100                       ; Recalculate index offset in continuous memory region
0101                       ;-------------------------------------------------------
0102 348C C120  34         mov   @parm1,tmp0           ; Restore line number
     348E A006     
0103 3490 0A14  56         sla   tmp0,1                ; Calculate offset
0104               
0105 3492 06A0  32         bl    @_idx.entry.delete.reorg
     3494 343A     
0106                                                   ; Reorganize index
0107                                                   ; \ i  tmp0 = Index offset
0108                                                   ; / i  tmp2 = Loop count
0109               
0110 3496 06A0  32         bl    @_idx.sams.mapcolumn.off
     3498 312E     
0111                                                   ; Restore memory window layout
0112               
0113 349A 1002  14         jmp   !
0114                       ;------------------------------------------------------
0115                       ; Simple index reorganization
0116                       ;------------------------------------------------------
0117               idx.entry.delete.reorg.simple:
0118 349C 06A0  32         bl    @_idx.entry.delete.reorg
     349E 343A     
0119                       ;------------------------------------------------------
0120                       ; Clear index entry (base + offset already set)
0121                       ;------------------------------------------------------
0122 34A0 04D4  26 !       clr   *tmp0                 ; Clear index entry
0123                       ;------------------------------------------------------
0124                       ; Exit
0125                       ;------------------------------------------------------
0126               idx.entry.delete.exit:
0127 34A2 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0128 34A4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0129 34A6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0130 34A8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0131 34AA C2F9  30         mov   *stack+,r11           ; Pop r11
0132 34AC 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0025                       copy  "idx.insert.asm"         ; Index management - insert slot
     **** ****     > idx.insert.asm
0001               * FILE......: idx.insert.asm
0002               * Purpose...: Insert index entry
0003               
0004               ***************************************************************
0005               * _idx.entry.insert.reorg
0006               * Reorganize index slot entries
0007               ***************************************************************
0008               * bl @_idx.entry.insert.reorg
0009               *--------------------------------------------------------------
0010               *  Remarks
0011               *  Private, only to be called from idx_entry_insert
0012               ********|*****|*********************|**************************
0013               _idx.entry.insert.reorg:
0014                       ;------------------------------------------------------
0015                       ; Assert 1
0016                       ;------------------------------------------------------
0017 34AE 0286  22         ci    tmp2,2048*5           ; Crash if loop counter value is unrealistic
     34B0 2800     
0018                                                   ; Max. 5 SAMS pages, each with 2048 index
0019                                                   ; entries.
0020               
0021 34B2 1204  14         jle   !                     ; Continue if ok
0022                       ;------------------------------------------------------
0023                       ; Crash and burn
0024                       ;------------------------------------------------------
0025               _idx.entry.insert.reorg.crash:
0026 34B4 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     34B6 FFCE     
0027 34B8 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     34BA 2026     
0028                       ;------------------------------------------------------
0029                       ; Reorganize index entries
0030                       ;------------------------------------------------------
0031 34BC 0224  22 !       ai    tmp0,idx.top          ; Add index base to offset
     34BE B000     
0032 34C0 C144  18         mov   tmp0,tmp1             ; a = current slot
0033 34C2 05C5  14         inct  tmp1                  ; b = current slot + 2
0034 34C4 0586  14         inc   tmp2                  ; One time adjustment for current line
0035                       ;------------------------------------------------------
0036                       ; Assert 2
0037                       ;------------------------------------------------------
0038 34C6 C1C6  18         mov   tmp2,tmp3             ; Number of slots to reorganize
0039 34C8 0A17  56         sla   tmp3,1                ; adjust to slot size
0040 34CA 0507  16         neg   tmp3                  ; tmp3 = -tmp3
0041 34CC A1C4  18         a     tmp0,tmp3             ; tmp3 = tmp3 + tmp0
0042 34CE 0287  22         ci    tmp3,idx.top - 4      ; Address before top of index ?
     34D0 AFFC     
0043 34D2 1504  14         jgt   _idx.entry.insert.reorg.loop
0044                                                   ; No, jump to loop start
0045                       ;------------------------------------------------------
0046                       ; Crash and burn
0047                       ;------------------------------------------------------
0048 34D4 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     34D6 FFCE     
0049 34D8 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     34DA 2026     
0050                       ;------------------------------------------------------
0051                       ; Loop backwards from end of index up to insert point
0052                       ;------------------------------------------------------
0053               _idx.entry.insert.reorg.loop:
0054 34DC C554  38         mov   *tmp0,*tmp1           ; Copy a -> b
0055 34DE 0644  14         dect  tmp0                  ; Move pointer up
0056 34E0 0645  14         dect  tmp1                  ; Move pointer up
0057 34E2 0606  14         dec   tmp2                  ; Next index entry
0058 34E4 15FB  14         jgt   _idx.entry.insert.reorg.loop
0059                                                   ; Repeat until done
0060                       ;------------------------------------------------------
0061                       ; Clear index entry at insert point
0062                       ;------------------------------------------------------
0063 34E6 05C4  14         inct  tmp0                  ; \ Clear index entry for line
0064 34E8 04D4  26         clr   *tmp0                 ; / following insert point
0065               
0066 34EA 045B  20         b     *r11                  ; Return to caller
0067               
0068               
0069               
0070               
0071               ***************************************************************
0072               * idx.entry.insert
0073               * Insert index entry
0074               ***************************************************************
0075               * bl @idx.entry.insert
0076               *--------------------------------------------------------------
0077               * INPUT
0078               * @parm1    = Line number in editor buffer to insert
0079               * @parm2    = Line number of last line to check for reorg
0080               *--------------------------------------------------------------
0081               * OUTPUT
0082               * NONE
0083               *--------------------------------------------------------------
0084               * Register usage
0085               * tmp0,tmp2
0086               ********|*****|*********************|**************************
0087               idx.entry.insert:
0088 34EC 0649  14         dect  stack
0089 34EE C64B  30         mov   r11,*stack            ; Save return address
0090 34F0 0649  14         dect  stack
0091 34F2 C644  30         mov   tmp0,*stack           ; Push tmp0
0092 34F4 0649  14         dect  stack
0093 34F6 C645  30         mov   tmp1,*stack           ; Push tmp1
0094 34F8 0649  14         dect  stack
0095 34FA C646  30         mov   tmp2,*stack           ; Push tmp2
0096 34FC 0649  14         dect  stack
0097 34FE C647  30         mov   tmp3,*stack           ; Push tmp3
0098                       ;------------------------------------------------------
0099                       ; Prepare for index reorg
0100                       ;------------------------------------------------------
0101 3500 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     3502 A008     
0102 3504 61A0  34         s     @parm1,tmp2           ; Calculate loop
     3506 A006     
0103 3508 130F  14         jeq   idx.entry.insert.reorg.simple
0104                                                   ; Special treatment if last line
0105                       ;------------------------------------------------------
0106                       ; Reorganize index entries
0107                       ;------------------------------------------------------
0108               idx.entry.insert.reorg:
0109 350A C1E0  34         mov   @parm2,tmp3
     350C A008     
0110 350E 0287  22         ci    tmp3,2048
     3510 0800     
0111 3512 110A  14         jlt   idx.entry.insert.reorg.simple
0112                                                   ; Do simple reorg only if single
0113                                                   ; SAMS index page, otherwise complex reorg.
0114                       ;------------------------------------------------------
0115                       ; Complex index reorganization (multiple SAMS pages)
0116                       ;------------------------------------------------------
0117               idx.entry.insert.reorg.complex:
0118 3514 06A0  32         bl    @_idx.sams.mapcolumn.on
     3516 30FA     
0119                                                   ; Index in continuous memory region
0120                                                   ; b000 - ffff (5 SAMS pages)
0121               
0122 3518 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     351A A008     
0123 351C 0A14  56         sla   tmp0,1                ; tmp0 * 2
0124               
0125 351E 06A0  32         bl    @_idx.entry.insert.reorg
     3520 34AE     
0126                                                   ; Reorganize index
0127                                                   ; \ i  tmp0 = Last line in index
0128                                                   ; / i  tmp2 = Num. of index entries to move
0129               
0130 3522 06A0  32         bl    @_idx.sams.mapcolumn.off
     3524 312E     
0131                                                   ; Restore memory window layout
0132               
0133 3526 1008  14         jmp   idx.entry.insert.exit
0134                       ;------------------------------------------------------
0135                       ; Simple index reorganization
0136                       ;------------------------------------------------------
0137               idx.entry.insert.reorg.simple:
0138 3528 C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     352A A008     
0139               
0140 352C 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     352E 3168     
0141                                                   ; \ i  tmp0     = Line number
0142                                                   ; / o  outparm1 = Slot offset in SAMS page
0143               
0144 3530 C120  34         mov   @outparm1,tmp0        ; Index offset
     3532 A016     
0145               
0146 3534 06A0  32         bl    @_idx.entry.insert.reorg
     3536 34AE     
0147                                                   ; Reorganize index
0148                                                   ; \ i  tmp0 = Last line in index
0149                                                   ; / i  tmp2 = Num. of index entries to move
0150               
0151                       ;------------------------------------------------------
0152                       ; Exit
0153                       ;------------------------------------------------------
0154               idx.entry.insert.exit:
0155 3538 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0156 353A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0157 353C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0158 353E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0159 3540 C2F9  30         mov   *stack+,r11           ; Pop r11
0160 3542 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0026                       ;-----------------------------------------------------------------------
0027                       ; Logic for editor buffer
0028                       ;-----------------------------------------------------------------------
0029                       copy  "edb.line.mappage.asm"   ; Activate edbuf SAMS page for line
     **** ****     > edb.line.mappage.asm
0001               * FILE......: edb.line.mappage.asm
0002               * Purpose...: Editor buffer SAMS setup
0003               
0004               
0005               ***************************************************************
0006               * edb.line.mappage
0007               * Activate editor buffer SAMS page for line
0008               ***************************************************************
0009               * bl  @edb.line.mappage
0010               *
0011               * tmp0 = Line number in editor buffer
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * outparm1 = Pointer to line in editor buffer
0015               * outparm2 = SAMS page
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0, tmp1
0019               ***************************************************************
0020               edb.line.mappage:
0021 3544 0649  14         dect  stack
0022 3546 C64B  30         mov   r11,*stack            ; Push return address
0023 3548 0649  14         dect  stack
0024 354A C644  30         mov   tmp0,*stack           ; Push tmp0
0025 354C 0649  14         dect  stack
0026 354E C645  30         mov   tmp1,*stack           ; Push tmp1
0027                       ;------------------------------------------------------
0028                       ; Assert
0029                       ;------------------------------------------------------
0030 3550 8804  38         c     tmp0,@edb.lines       ; Non-existing line?
     3552 A504     
0031 3554 1204  14         jle   edb.line.mappage.lookup
0032                                                   ; All checks passed, continue
0033                                                   ;--------------------------
0034                                                   ; Assert failed
0035                                                   ;--------------------------
0036 3556 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     3558 FFCE     
0037 355A 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     355C 2026     
0038                       ;------------------------------------------------------
0039                       ; Lookup SAMS page for line in parm1
0040                       ;------------------------------------------------------
0041               edb.line.mappage.lookup:
0042 355E C804  38         mov   tmp0,@parm1           ; Set line number in editor buffer
     3560 A006     
0043               
0044 3562 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     3564 33EE     
0045                                                   ; \ i  parm1    = Line number
0046                                                   ; | o  outparm1 = Pointer to line
0047                                                   ; / o  outparm2 = SAMS page
0048               
0049 3566 C120  34         mov   @outparm2,tmp0        ; SAMS page
     3568 A018     
0050 356A C160  34         mov   @outparm1,tmp1        ; Pointer to line
     356C A016     
0051 356E 130B  14         jeq   edb.line.mappage.exit ; Nothing to page-in if NULL pointer
0052                                                   ; (=empty line)
0053                       ;------------------------------------------------------
0054                       ; Determine if requested SAMS page is already active
0055                       ;------------------------------------------------------
0056 3570 8120  34         c     @tv.sams.c000,tmp0    ; Compare with active page editor buffer
     3572 A208     
0057 3574 1308  14         jeq   edb.line.mappage.exit ; Request page already active, so exit
0058                       ;------------------------------------------------------
0059                       ; Activate requested SAMS page
0060                       ;-----------------------------------------------------
0061 3576 06A0  32         bl    @xsams.page.set       ; Switch SAMS memory page
     3578 258A     
0062                                                   ; \ i  tmp0 = SAMS page
0063                                                   ; / i  tmp1 = Memory address
0064               
0065 357A C820  54         mov   @outparm2,@tv.sams.c000
     357C A018     
     357E A208     
0066                                                   ; Set page in shadow registers
0067               
0068 3580 C820  54         mov   @outparm2,@edb.sams.page
     3582 A018     
     3584 A516     
0069                                                   ; Set current SAMS page
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               edb.line.mappage.exit:
0074 3586 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0075 3588 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0076 358A C2F9  30         mov   *stack+,r11           ; Pop r11
0077 358C 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0030                       copy  "edb.line.getlen.asm"    ; Get line length
     **** ****     > edb.line.getlen.asm
0001               * FILE......: edb.line.getlen.asm
0002               * Purpose...: Get length of specified line in editor buffer
0003               
0004               ***************************************************************
0005               * edb.line.getlength
0006               * Get length of specified line
0007               ***************************************************************
0008               *  bl   @edb.line.getlength
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @parm1 = Line number (base 0)
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * @outparm1 = Length of line
0015               * @outparm2 = SAMS page
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0,tmp1
0019               ********|*****|*********************|**************************
0020               edb.line.getlength:
0021 358E 0649  14         dect  stack
0022 3590 C64B  30         mov   r11,*stack            ; Push return address
0023 3592 0649  14         dect  stack
0024 3594 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 3596 0649  14         dect  stack
0026 3598 C645  30         mov   tmp1,*stack           ; Push tmp1
0027                       ;------------------------------------------------------
0028                       ; Initialisation
0029                       ;------------------------------------------------------
0030 359A 04E0  34         clr   @outparm1             ; Reset length
     359C A016     
0031 359E 04E0  34         clr   @outparm2             ; Reset SAMS bank
     35A0 A018     
0032                       ;------------------------------------------------------
0033                       ; Exit if requested line beyond editor buffer
0034                       ;------------------------------------------------------
0035 35A2 C120  34         mov   @parm1,tmp0           ; \
     35A4 A006     
0036 35A6 0584  14         inc   tmp0                  ; /  base 1
0037               
0038 35A8 8804  38         c     tmp0,@edb.lines       ; Requested line at BOT?
     35AA A504     
0039 35AC 1101  14         jlt   !                     ; No, continue processing
0040 35AE 100F  14         jmp   edb.line.getlength.null
0041                                                   ; Set length 0 and exit early
0042                       ;------------------------------------------------------
0043                       ; Map SAMS page
0044                       ;------------------------------------------------------
0045 35B0 C120  34 !       mov   @parm1,tmp0           ; Get line
     35B2 A006     
0046               
0047 35B4 06A0  32         bl    @edb.line.mappage     ; Activate editor buffer SAMS page for line
     35B6 3544     
0048                                                   ; \ i  tmp0     = Line number
0049                                                   ; | o  outparm1 = Pointer to line
0050                                                   ; / o  outparm2 = SAMS page
0051               
0052 35B8 C120  34         mov   @outparm1,tmp0        ; Store pointer in tmp0
     35BA A016     
0053 35BC 1308  14         jeq   edb.line.getlength.null
0054                                                   ; Set length to 0 if null-pointer
0055                       ;------------------------------------------------------
0056                       ; Process line prefix
0057                       ;------------------------------------------------------
0058 35BE C154  26         mov   *tmp0,tmp1            ; Get length into tmp1
0059 35C0 C805  38         mov   tmp1,@outparm1        ; Save length
     35C2 A016     
0060                       ;------------------------------------------------------
0061                       ; Assert
0062                       ;------------------------------------------------------
0063 35C4 0285  22         ci    tmp1,80               ; Line length <= 80 ?
     35C6 0050     
0064 35C8 1204  14         jle   edb.line.getlength.exit
0065                                                   ; Yes, exit
0066                       ;------------------------------------------------------
0067                       ; Crash the system or limit length to 80
0068                       ;------------------------------------------------------
0073 35CA 0205  20         li    tmp1,80               ; Only process first 80 characters
     35CC 0050     
0075                       ;------------------------------------------------------
0076                       ; Set length to 0 if null-pointer
0077                       ;------------------------------------------------------
0078               edb.line.getlength.null:
0079 35CE 04E0  34         clr   @outparm1             ; Set length to 0, was a null-pointer
     35D0 A016     
0080                       ;------------------------------------------------------
0081                       ; Exit
0082                       ;------------------------------------------------------
0083               edb.line.getlength.exit:
0084 35D2 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0085 35D4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0086 35D6 C2F9  30         mov   *stack+,r11           ; Pop r11
0087 35D8 045B  20         b     *r11                  ; Return to caller
0088               
0089               
0090               
0091               ***************************************************************
0092               * edb.line.getlength2
0093               * Get length of current row (as seen from editor buffer side)
0094               ***************************************************************
0095               *  bl   @edb.line.getlength2
0096               *--------------------------------------------------------------
0097               * INPUT
0098               * @fb.row = Row in frame buffer
0099               *--------------------------------------------------------------
0100               * OUTPUT
0101               * @fb.row.length = Length of row
0102               *--------------------------------------------------------------
0103               * Register usage
0104               * tmp0
0105               ********|*****|*********************|**************************
0106               edb.line.getlength2:
0107 35DA 0649  14         dect  stack
0108 35DC C64B  30         mov   r11,*stack            ; Save return address
0109 35DE 0649  14         dect  stack
0110 35E0 C644  30         mov   tmp0,*stack           ; Push tmp0
0111                       ;------------------------------------------------------
0112                       ; Calculate line in editor buffer
0113                       ;------------------------------------------------------
0114 35E2 C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     35E4 A304     
0115 35E6 A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     35E8 A306     
0116                       ;------------------------------------------------------
0117                       ; Get length
0118                       ;------------------------------------------------------
0119 35EA C804  38         mov   tmp0,@parm1
     35EC A006     
0120 35EE 06A0  32         bl    @edb.line.getlength
     35F0 358E     
0121 35F2 C820  54         mov   @outparm1,@fb.row.length
     35F4 A016     
     35F6 A308     
0122                                                   ; Save row length
0123                       ;------------------------------------------------------
0124                       ; Exit
0125                       ;------------------------------------------------------
0126               edb.line.getlength2.exit:
0127 35F8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0128 35FA C2F9  30         mov   *stack+,r11           ; Pop R11
0129 35FC 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0031                       copy  "edb.hipage.alloc.asm"   ; Check/increase highest SAMS page
     **** ****     > edb.hipage.alloc.asm
0001               * FILE......: edb.hipage.alloc.asm
0002               * Purpose...: Editor buffer utilities
0003               
0004               
0005               ***************************************************************
0006               * edb.hipage.alloc
0007               * Check and increase highest SAMS page of editor buffer
0008               ***************************************************************
0009               *  bl   @edb.hipage.alloc
0010               *--------------------------------------------------------------
0011               * INPUT
0012               * @edb.next_free.ptr = Pointer to next free line
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0,tmp1
0018               ********|*****|*********************|**************************
0019               edb.hipage.alloc:
0020 35FE 0649  14         dect  stack
0021 3600 C64B  30         mov   r11,*stack            ; Save return address
0022 3602 0649  14         dect  stack
0023 3604 C644  30         mov   tmp0,*stack           ; Push tmp0
0024 3606 0649  14         dect  stack
0025 3608 C645  30         mov   tmp1,*stack           ; Push tmp1
0026                       ;------------------------------------------------------
0027                       ; 1a. Check if highest SAMS page needs to be increased
0028                       ;------------------------------------------------------
0029               edb.hipage.alloc.check_setpage:
0030 360A C120  34         mov   @edb.next_free.ptr,tmp0
     360C A508     
0031                                                   ;--------------------------
0032                                                   ; Check for page overflow
0033                                                   ;--------------------------
0034 360E 0244  22         andi  tmp0,>0fff            ; Get rid of highest nibble
     3610 0FFF     
0035 3612 0224  22         ai    tmp0,82               ; Assume line of 80 chars (+2 bytes prefix)
     3614 0052     
0036 3616 0284  22         ci    tmp0,>1000 - 16       ; 4K boundary reached?
     3618 0FF0     
0037 361A 1105  14         jlt   edb.hipage.alloc.setpage
0038                                                   ; Not yet, don't increase SAMS page
0039                       ;------------------------------------------------------
0040                       ; 1b. Increase highest SAMS page (copy-on-write!)
0041                       ;------------------------------------------------------
0042 361C 05A0  34         inc   @edb.sams.hipage      ; Set highest SAMS page
     361E A518     
0043 3620 C820  54         mov   @edb.top.ptr,@edb.next_free.ptr
     3622 A500     
     3624 A508     
0044                                                   ; Start at top of SAMS page again
0045                       ;------------------------------------------------------
0046                       ; 1c. Switch to SAMS page and exit
0047                       ;------------------------------------------------------
0048               edb.hipage.alloc.setpage:
0049 3626 C120  34         mov   @edb.sams.hipage,tmp0
     3628 A518     
0050 362A C160  34         mov   @edb.top.ptr,tmp1
     362C A500     
0051 362E 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     3630 258A     
0052                                                   ; \ i  tmp0 = SAMS page number
0053                                                   ; / i  tmp1 = Memory address
0054               
0055 3632 1004  14         jmp   edb.hipage.alloc.exit
0056                       ;------------------------------------------------------
0057                       ; Check failed, crash CPU!
0058                       ;------------------------------------------------------
0059               edb.hipage.alloc.crash:
0060 3634 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     3636 FFCE     
0061 3638 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     363A 2026     
0062                       ;------------------------------------------------------
0063                       ; Exit
0064                       ;------------------------------------------------------
0065               edb.hipage.alloc.exit:
0066 363C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0067 363E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0068 3640 C2F9  30         mov   *stack+,r11           ; Pop R11
0069 3642 045B  20         b     *r11                  ; Return to caller
                   < ram.resident.asm
0032                       ;-----------------------------------------------------------------------
0033                       ; Utility functions
0034                       ;-----------------------------------------------------------------------
0035                       copy  "pane.topline.clearmsg.asm"
     **** ****     > pane.topline.clearmsg.asm
0001               * FILE......: pane.topline.clearmsg.asm
0002               * Purpose...: One-shot task for clearing overlay message in top line
0003               
0004               
0005               ***************************************************************
0006               * pane.topline.oneshot.clearmsg
0007               * Remove overlay message in top line
0008               ***************************************************************
0009               * Runs as one-shot task in slot 3
0010               *--------------------------------------------------------------
0011               * INPUT
0012               * none
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * none
0019               ********|*****|*********************|**************************
0020               pane.topline.oneshot.clearmsg:
0021 3644 0649  14         dect  stack
0022 3646 C64B  30         mov   r11,*stack            ; Push return address
0023 3648 0649  14         dect  stack
0024 364A C660  46         mov   @wyx,*stack           ; Push cursor position
     364C 832A     
0025                       ;-------------------------------------------------------
0026                       ; Clear message
0027                       ;-------------------------------------------------------
0028 364E 06A0  32         bl    @hchar
     3650 27E6     
0029 3652 0034                   byte 0,52,32,18
     3654 2012     
0030 3656 FFFF                   data EOL              ; Clear message
0031               
0032 3658 04E0  34         clr   @tv.task.oneshot      ; Reset oneshot task
     365A A224     
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036               pane.topline.oneshot.clearmsg.exit:
0037 365C C839  50         mov   *stack+,@wyx          ; Pop cursor position
     365E 832A     
0038 3660 C2F9  30         mov   *stack+,r11           ; Pop R11
0039 3662 045B  20         b     *r11                  ; Return to task
                   < ram.resident.asm
0036                                                      ; Remove overlay messsage in top line
0037                       ;------------------------------------------------------
0038                       ; Program data
0039                       ;------------------------------------------------------
0040                       copy  "data.constants.asm"     ; Constants
     **** ****     > data.constants.asm
0001               * FILE......: data.constants.asm
0002               * Purpose...: Stevie Editor - data segment (constants)
0003               
0004               ***************************************************************
0005               *                      Constants
0006               ********|*****|*********************|**************************
0007               
0008               
0009               ***************************************************************
0010               * Textmode (80 columns, 30 rows) - F18A
0011               *--------------------------------------------------------------
0012               *
0013               * ; VDP#0 Control bits
0014               * ;      bit 6=0: M3 | Graphics 1 mode
0015               * ;      bit 7=0: Disable external VDP input
0016               * ; VDP#1 Control bits
0017               * ;      bit 0=1: 16K selection
0018               * ;      bit 1=1: Enable display
0019               * ;      bit 2=1: Enable VDP interrupt
0020               * ;      bit 3=1: M1 \ TEXT MODE
0021               * ;      bit 4=0: M2 /
0022               * ;      bit 5=0: reserved
0023               * ;      bit 6=0: 8x8 sprites
0024               * ;      bit 7=0: Sprite magnification (1x)
0025               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >960)
0026               * ; VDP#3 PCT (Pattern color table)      at >0FC0  (>3F * >040)
0027               * ; VDP#4 PDT (Pattern descriptor table) at >1000  (>02 * >800)
0028               * ; VDP#5 SAT (sprite attribute list)    at >2180  (>43 * >080)
0029               * ; VDP#6 SPT (Sprite pattern table)     at >2800  (>05 * >800)
0030               * ; VDP#7 Set foreground/background color
0031               ***************************************************************
0032               stevie.80x30:
0033 3664 04F0             byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80
     3666 003F     
     3668 0243     
     366A 05F4     
     366C 0050     
0034               
0035               
0036               ***************************************************************
0037               * TI Basic mode (32 columns/24 rows)
0038               *--------------------------------------------------------------
0039               tibasic.32x24:
0040 366E 00E2             byte  >00,>e2,>00,>0c,>00,>06,>00,>07,0,32
     3670 000C     
     3672 0006     
     3674 0007     
     3676 0020     
0041               *
0042               * ; VDP#0 Control bits
0043               * ;      bit 6=0: M3 | Graphics 1 mode
0044               * ;      bit 7=0: Disable external VDP input
0045               * ; VDP#1 Control bits
0046               * ;      bit 0=1: 16K selection
0047               * ;      bit 1=1: Enable display
0048               * ;      bit 2=1: Enable VDP interrupt
0049               * ;      bit 3=0: M1 \ Graphics 1 mode
0050               * ;      bit 4=0: M2 /
0051               * ;      bit 5=0: reserved
0052               * ;      bit 6=1: 16x16 sprites
0053               * ;      bit 7=0: Sprite magnification (1x)
0054               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >400)
0055               * ; VDP#3 PCT (Pattern color table)      at >0300  (>0C * >040)
0056               * ; VDP#4 PDT (Pattern descriptor table) at >0000  (>00 * >800)
0057               * ; VDP#5 SAT (sprite attribute list)    at >0300  (>06 * >080)
0058               * ; VDP#6 SPT (Sprite pattern table)     at >0000  (>00 * >800)
0059               * ; VDP#7 Set screen background color
0060               
0061               
0062               
0063               ***************************************************************
0064               * TI Basic mode (32 columns/30 rows) - F18A
0065               *--------------------------------------------------------------
0066               tibasic.32x30:
0067 3678 00E2             byte  >00,>e2,>00,>0c,>00,>06,>00,>07,0,32
     367A 000C     
     367C 0006     
     367E 0007     
     3680 0020     
0068               *
0069               * ; VDP#0 Control bits
0070               * ;      bit 6=0: M3 | Graphics 1 mode
0071               * ;      bit 7=0: Disable external VDP input
0072               * ; VDP#1 Control bits
0073               * ;      bit 0=1: 16K selection
0074               * ;      bit 1=1: Enable display
0075               * ;      bit 2=1: Enable VDP interrupt
0076               * ;      bit 3=0: M1 \ Graphics 1 mode
0077               * ;      bit 4=0: M2 /
0078               * ;      bit 5=0: reserved
0079               * ;      bit 6=1: 16x16 sprites
0080               * ;      bit 7=0: Sprite magnification (1x)
0081               * ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >400)
0082               * ; VDP#3 PCT (Pattern color table)      at >0300  (>0C * >040)
0083               * ; VDP#4 PDT (Pattern descriptor table) at >0000  (>00 * >800)
0084               * ; VDP#5 SAT (sprite attribute list)    at >0300  (>06 * >080)
0085               * ; VDP#6 SPT (Sprite pattern table)     at >0000  (>00 * >800)
0086               * ; VDP#7 Set screen background color
0087               * ;
0088               * ; The table by itself is not sufficient for turning on 30 rows
0089               * ; mode. You also need to unlock the F18a and set VR49 (>31) to
0090               * ; value >40.
0091               
0092               
0093               ***************************************************************
0094               * Sprite Attribute Table
0095               *--------------------------------------------------------------
0096               romsat:
0097                                                   ; YX, initial shape and color
0098 3682 0000             data  >0000,>0001           ; Cursor
     3684 0001     
0099 3686 0000             data  >0000,>0101           ; Current line indicator     <
     3688 0101     
0100 368A 0820             data  >0820,>0201           ; Current column indicator   v
     368C 0201     
0101               nosprite:
0102 368E D000             data  >d000                 ; End-of-Sprites list
0103               
0104               
0105               
0106               
0107               ***************************************************************
0108               * Stevie color schemes table
0109               *--------------------------------------------------------------
0110               * Word 1
0111               * A  MSB  high-nibble    Foreground color text line in frame buffer
0112               * B  MSB  low-nibble     Background color text line in frame buffer
0113               * C  LSB  high-nibble    Foreground color top/bottom line
0114               * D  LSB  low-nibble     Background color top/bottom line
0115               *
0116               * Word 2
0117               * E  MSB  high-nibble    Foreground color cmdb pane
0118               * F  MSB  low-nibble     Background color cmdb pane
0119               * G  LSB  high-nibble    Cursor foreground color cmdb pane
0120               * H  LSB  low-nibble     Cursor foreground color frame buffer
0121               *
0122               * Word 3
0123               * I  MSB  high-nibble    Foreground color busy top/bottom line
0124               * J  MSB  low-nibble     Background color busy top/bottom line
0125               * K  LSB  high-nibble    Foreground color marked line in frame buffer
0126               * L  LSB  low-nibble     Background color marked line in frame buffer
0127               *
0128               * Word 4
0129               * M  MSB  high-nibble    Foreground color command buffer header line
0130               * N  MSB  low-nibble     Background color command buffer header line
0131               * O  LSB  high-nibble    Foreground color line+column indicator frame buffer
0132               * P  LSB  low-nibble     Foreground color ruler frame buffer
0133               *
0134               * Colors
0135               * 0  Transparant
0136               * 1  black
0137               * 2  Green
0138               * 3  Light Green
0139               * 4  Blue
0140               * 5  Light Blue
0141               * 6  Dark Red
0142               * 7  Cyan
0143               * 8  Red
0144               * 9  Light Red
0145               * A  Yellow
0146               * B  Light Yellow
0147               * C  Dark Green
0148               * D  Magenta
0149               * E  Grey
0150               * F  White
0151               *--------------------------------------------------------------
0152      000A     tv.colorscheme.entries   equ 10 ; Entries in table
0153               
0154               tv.colorscheme.table:
0155                       ;                             ; #
0156                       ;      ABCD  EFGH  IJKL  MNOP ; -
0157 3690 F417             data  >f417,>f171,>1b1f,>71b1 ; 1  White on blue with cyan touch
     3692 F171     
     3694 1B1F     
     3696 71B1     
0158 3698 A11A             data  >a11a,>f0ff,>1f1a,>f1ff ; 2  Dark yellow on black
     369A F0FF     
     369C 1F1A     
     369E F1FF     
0159 36A0 2112             data  >2112,>f0ff,>1f12,>f1f6 ; 3  Dark green on black
     36A2 F0FF     
     36A4 1F12     
     36A6 F1F6     
0160 36A8 F41F             data  >f41f,>1e11,>1a17,>1e11 ; 4  White on blue
     36AA 1E11     
     36AC 1A17     
     36AE 1E11     
0161 36B0 E11E             data  >e11e,>e1ff,>1f1e,>e1ff ; 5  Grey on black
     36B2 E1FF     
     36B4 1F1E     
     36B6 E1FF     
0162 36B8 1771             data  >1771,>1016,>1b71,>1711 ; 6  Black on cyan
     36BA 1016     
     36BC 1B71     
     36BE 1711     
0163 36C0 1FF1             data  >1ff1,>1011,>f1f1,>1f11 ; 7  Black on white
     36C2 1011     
     36C4 F1F1     
     36C6 1F11     
0164 36C8 1AF1             data  >1af1,>a1ff,>1f1f,>f11f ; 8  Black on dark yellow
     36CA A1FF     
     36CC 1F1F     
     36CE F11F     
0165 36D0 21F0             data  >21f0,>12ff,>1b12,>12ff ; 9  Dark green on black
     36D2 12FF     
     36D4 1B12     
     36D6 12FF     
0166 36D8 F5F1             data  >f5f1,>e1ff,>1b1f,>f131 ; 10 White on light blue
     36DA E1FF     
     36DC 1B1F     
     36DE F131     
0167                       even
0168               
0169               tv.tabs.table:
0170 36E0 0007             byte  0,7,12,25               ; \   Default tab positions as used
     36E2 0C19     
0171 36E4 1E2D             byte  30,45,59,79             ; |   in Editor/Assembler module.
     36E6 3B4F     
0172 36E8 FF00             byte  >ff,0,0,0               ; |
     36EA 0000     
0173 36EC 0000             byte  0,0,0,0                 ; |   Up to 20 positions supported.
     36EE 0000     
0174 36F0 0000             byte  0,0,0,0                 ; /   >ff means end-of-list.
     36F2 0000     
0175                       even
                   < ram.resident.asm
0041                       copy  "data.strings.asm"       ; Strings
     **** ****     > data.strings.asm
0001               * FILE......: data.strings.asm
0002               * Purpose...: Stevie Editor - data segment (strings)
0003               
0004               ***************************************************************
0005               *                       Strings
0006               ***************************************************************
0007               
0008               txt.delim
0009 36F4 01               byte  1
0010 36F5   2C             text  ','
0011                       even
0012               
0013               txt.bottom
0014 36F6 05               byte  5
0015 36F7   20             text  '  BOT'
     36F8 2042     
     36FA 4F54     
0016                       even
0017               
0018               txt.ovrwrite
0019 36FC 03               byte  3
0020 36FD   4F             text  'OVR'
     36FE 5652     
0021                       even
0022               
0023               txt.insert
0024 3700 03               byte  3
0025 3701   49             text  'INS'
     3702 4E53     
0026                       even
0027               
0028               txt.star
0029 3704 01               byte  1
0030 3705   2A             text  '*'
0031                       even
0032               
0033               txt.loading
0034 3706 0A               byte  10
0035 3707   4C             text  'Loading...'
     3708 6F61     
     370A 6469     
     370C 6E67     
     370E 2E2E     
     3710 2E       
0036                       even
0037               
0038               txt.saving
0039 3712 0A               byte  10
0040 3713   53             text  'Saving....'
     3714 6176     
     3716 696E     
     3718 672E     
     371A 2E2E     
     371C 2E       
0041                       even
0042               
0043               txt.printing
0044 371E 12               byte  18
0045 371F   50             text  'Printing file.....'
     3720 7269     
     3722 6E74     
     3724 696E     
     3726 6720     
     3728 6669     
     372A 6C65     
     372C 2E2E     
     372E 2E2E     
     3730 2E       
0046                       even
0047               
0048               txt.block.del
0049 3732 12               byte  18
0050 3733   44             text  'Deleting block....'
     3734 656C     
     3736 6574     
     3738 696E     
     373A 6720     
     373C 626C     
     373E 6F63     
     3740 6B2E     
     3742 2E2E     
     3744 2E       
0051                       even
0052               
0053               txt.block.copy
0054 3746 11               byte  17
0055 3747   43             text  'Copying block....'
     3748 6F70     
     374A 7969     
     374C 6E67     
     374E 2062     
     3750 6C6F     
     3752 636B     
     3754 2E2E     
     3756 2E2E     
0056                       even
0057               
0058               txt.block.move
0059 3758 10               byte  16
0060 3759   4D             text  'Moving block....'
     375A 6F76     
     375C 696E     
     375E 6720     
     3760 626C     
     3762 6F63     
     3764 6B2E     
     3766 2E2E     
     3768 2E       
0061                       even
0062               
0063               txt.block.save
0064 376A 18               byte  24
0065 376B   53             text  'Saving block to file....'
     376C 6176     
     376E 696E     
     3770 6720     
     3772 626C     
     3774 6F63     
     3776 6B20     
     3778 746F     
     377A 2066     
     377C 696C     
     377E 652E     
     3780 2E2E     
     3782 2E       
0066                       even
0067               
0068               txt.block.clip
0069 3784 18               byte  24
0070 3785   43             text  'Copying to clipboard....'
     3786 6F70     
     3788 7969     
     378A 6E67     
     378C 2074     
     378E 6F20     
     3790 636C     
     3792 6970     
     3794 626F     
     3796 6172     
     3798 642E     
     379A 2E2E     
     379C 2E       
0071                       even
0072               
0073               txt.block.print
0074 379E 12               byte  18
0075 379F   50             text  'Printing block....'
     37A0 7269     
     37A2 6E74     
     37A4 696E     
     37A6 6720     
     37A8 626C     
     37AA 6F63     
     37AC 6B2E     
     37AE 2E2E     
     37B0 2E       
0076                       even
0077               
0078               txt.clearmem
0079 37B2 13               byte  19
0080 37B3   43             text  'Clearing memory....'
     37B4 6C65     
     37B6 6172     
     37B8 696E     
     37BA 6720     
     37BC 6D65     
     37BE 6D6F     
     37C0 7279     
     37C2 2E2E     
     37C4 2E2E     
0081                       even
0082               
0083               txt.done.load
0084 37C6 0E               byte  14
0085 37C7   4C             text  'Load completed'
     37C8 6F61     
     37CA 6420     
     37CC 636F     
     37CE 6D70     
     37D0 6C65     
     37D2 7465     
     37D4 64       
0086                       even
0087               
0088               txt.done.insert
0089 37D6 10               byte  16
0090 37D7   49             text  'Insert completed'
     37D8 6E73     
     37DA 6572     
     37DC 7420     
     37DE 636F     
     37E0 6D70     
     37E2 6C65     
     37E4 7465     
     37E6 64       
0091                       even
0092               
0093               txt.done.append
0094 37E8 10               byte  16
0095 37E9   41             text  'Append completed'
     37EA 7070     
     37EC 656E     
     37EE 6420     
     37F0 636F     
     37F2 6D70     
     37F4 6C65     
     37F6 7465     
     37F8 64       
0096                       even
0097               
0098               txt.done.save
0099 37FA 0E               byte  14
0100 37FB   53             text  'Save completed'
     37FC 6176     
     37FE 6520     
     3800 636F     
     3802 6D70     
     3804 6C65     
     3806 7465     
     3808 64       
0101                       even
0102               
0103               txt.done.copy
0104 380A 0E               byte  14
0105 380B   43             text  'Copy completed'
     380C 6F70     
     380E 7920     
     3810 636F     
     3812 6D70     
     3814 6C65     
     3816 7465     
     3818 64       
0106                       even
0107               
0108               txt.done.print
0109 381A 0F               byte  15
0110 381B   50             text  'Print completed'
     381C 7269     
     381E 6E74     
     3820 2063     
     3822 6F6D     
     3824 706C     
     3826 6574     
     3828 6564     
0111                       even
0112               
0113               txt.done.delete
0114 382A 10               byte  16
0115 382B   44             text  'Delete completed'
     382C 656C     
     382E 6574     
     3830 6520     
     3832 636F     
     3834 6D70     
     3836 6C65     
     3838 7465     
     383A 64       
0116                       even
0117               
0118               txt.done.clipboard
0119 383C 0F               byte  15
0120 383D   43             text  'Clipboard saved'
     383E 6C69     
     3840 7062     
     3842 6F61     
     3844 7264     
     3846 2073     
     3848 6176     
     384A 6564     
0121                       even
0122               
0123               txt.done.clipdev
0124 384C 0D               byte  13
0125 384D   43             text  'Clipboard set'
     384E 6C69     
     3850 7062     
     3852 6F61     
     3854 7264     
     3856 2073     
     3858 6574     
0126                       even
0127               
0128               txt.fastmode
0129 385A 08               byte  8
0130 385B   46             text  'Fastmode'
     385C 6173     
     385E 746D     
     3860 6F64     
     3862 65       
0131                       even
0132               
0133               txt.uncrunching
0134 3864 1B               byte  27
0135 3865   45             text  'Expanding TI Basic line....'
     3866 7870     
     3868 616E     
     386A 6469     
     386C 6E67     
     386E 2054     
     3870 4920     
     3872 4261     
     3874 7369     
     3876 6320     
     3878 6C69     
     387A 6E65     
     387C 2E2E     
     387E 2E2E     
0136                       even
0137               
0138               txt.kb
0139 3880 02               byte  2
0140 3881   6B             text  'kb'
     3882 62       
0141                       even
0142               
0143               txt.lines
0144 3884 05               byte  5
0145 3885   4C             text  'Lines'
     3886 696E     
     3888 6573     
0146                       even
0147               
0148               txt.newfile
0149 388A 0A               byte  10
0150 388B   5B             text  '[New file]'
     388C 4E65     
     388E 7720     
     3890 6669     
     3892 6C65     
     3894 5D       
0151                       even
0152               
0153               txt.tib1
0154 3896 0D               byte  13
0155 3897   5B             text  '[TI Basic #1]'
     3898 5449     
     389A 2042     
     389C 6173     
     389E 6963     
     38A0 2023     
     38A2 315D     
0156                       even
0157               
0158               txt.tib2
0159 38A4 0D               byte  13
0160 38A5   5B             text  '[TI Basic #2]'
     38A6 5449     
     38A8 2042     
     38AA 6173     
     38AC 6963     
     38AE 2023     
     38B0 325D     
0161                       even
0162               
0163               txt.tib3
0164 38B2 0D               byte  13
0165 38B3   5B             text  '[TI Basic #3]'
     38B4 5449     
     38B6 2042     
     38B8 6173     
     38BA 6963     
     38BC 2023     
     38BE 335D     
0166                       even
0167               
0168               txt.tib4
0169 38C0 0D               byte  13
0170 38C1   5B             text  '[TI Basic #4]'
     38C2 5449     
     38C4 2042     
     38C6 6173     
     38C8 6963     
     38CA 2023     
     38CC 345D     
0171                       even
0172               
0173               txt.tib5
0174 38CE 0D               byte  13
0175 38CF   5B             text  '[TI Basic #5]'
     38D0 5449     
     38D2 2042     
     38D4 6173     
     38D6 6963     
     38D8 2023     
     38DA 355D     
0176                       even
0177               
0178               txt.filetype.dv80
0179 38DC 04               byte  4
0180 38DD   44             text  'DV80'
     38DE 5638     
     38E0 30       
0181                       even
0182               
0183               txt.m1
0184 38E2 03               byte  3
0185 38E3   4D             text  'M1='
     38E4 313D     
0186                       even
0187               
0188               txt.m2
0189 38E6 03               byte  3
0190 38E7   4D             text  'M2='
     38E8 323D     
0191                       even
0192               
0193               txt.keys.default
0194 38EA 10               byte  16
0195 38EB   46             text  'F9-Menu  ^H-Help'
     38EC 392D     
     38EE 4D65     
     38F0 6E75     
     38F2 2020     
     38F4 5E48     
     38F6 2D48     
     38F8 656C     
     38FA 70       
0196                       even
0197               
0198               txt.keys.defaultb
0199 38FC 1D               byte  29
0200 38FD   46             text  'F9-Menu  ^H-Help  F0-TI Basic'
     38FE 392D     
     3900 4D65     
     3902 6E75     
     3904 2020     
     3906 5E48     
     3908 2D48     
     390A 656C     
     390C 7020     
     390E 2046     
     3910 302D     
     3912 5449     
     3914 2042     
     3916 6173     
     3918 6963     
0201                       even
0202               
0203               txt.keys.block
0204 391A 36               byte  54
0205 391B   46             text  'F9-Back  ^Copy  ^Move  ^Del  ^Save  ^Print  ^[1-5]Clip'
     391C 392D     
     391E 4261     
     3920 636B     
     3922 2020     
     3924 5E43     
     3926 6F70     
     3928 7920     
     392A 205E     
     392C 4D6F     
     392E 7665     
     3930 2020     
     3932 5E44     
     3934 656C     
     3936 2020     
     3938 5E53     
     393A 6176     
     393C 6520     
     393E 205E     
     3940 5072     
     3942 696E     
     3944 7420     
     3946 205E     
     3948 5B31     
     394A 2D35     
     394C 5D43     
     394E 6C69     
     3950 70       
0206                       even
0207               
0208 3952 2E2E     txt.ruler          text    '.........'
     3954 2E2E     
     3956 2E2E     
     3958 2E2E     
     395A 2E       
0209 395B   12                        byte    18
0210 395C 2E2E                        text    '.........'
     395E 2E2E     
     3960 2E2E     
     3962 2E2E     
     3964 2E       
0211 3965   13                        byte    19
0212 3966 2E2E                        text    '.........'
     3968 2E2E     
     396A 2E2E     
     396C 2E2E     
     396E 2E       
0213 396F   14                        byte    20
0214 3970 2E2E                        text    '.........'
     3972 2E2E     
     3974 2E2E     
     3976 2E2E     
     3978 2E       
0215 3979   15                        byte    21
0216 397A 2E2E                        text    '.........'
     397C 2E2E     
     397E 2E2E     
     3980 2E2E     
     3982 2E       
0217 3983   16                        byte    22
0218 3984 2E2E                        text    '.........'
     3986 2E2E     
     3988 2E2E     
     398A 2E2E     
     398C 2E       
0219 398D   17                        byte    23
0220 398E 2E2E                        text    '.........'
     3990 2E2E     
     3992 2E2E     
     3994 2E2E     
     3996 2E       
0221 3997   18                        byte    24
0222 3998 2E2E                        text    '.........'
     399A 2E2E     
     399C 2E2E     
     399E 2E2E     
     39A0 2E       
0223 39A1   19                        byte    25
0224                                  even
0225 39A2 020E     txt.alpha.down     data >020e,>0f00
     39A4 0F00     
0226 39A6 0110     txt.vertline       data >0110
0227 39A8 011C     txt.keymarker      byte 1,28
0228               
0229               txt.ws1
0230 39AA 01               byte  1
0231 39AB   20             text  ' '
0232                       even
0233               
0234               txt.ws2
0235 39AC 02               byte  2
0236 39AD   20             text  '  '
     39AE 20       
0237                       even
0238               
0239               txt.ws3
0240 39B0 03               byte  3
0241 39B1   20             text  '   '
     39B2 2020     
0242                       even
0243               
0244               txt.ws4
0245 39B4 04               byte  4
0246 39B5   20             text  '    '
     39B6 2020     
     39B8 20       
0247                       even
0248               
0249               txt.ws5
0250 39BA 05               byte  5
0251 39BB   20             text  '     '
     39BC 2020     
     39BE 2020     
0252                       even
0253               
0254      39B4     txt.filetype.none  equ txt.ws4
0255               
0256               
0257               ;--------------------------------------------------------------
0258               ; Strings for error line pane
0259               ;--------------------------------------------------------------
0260               txt.ioerr.load
0261 39C0 15               byte  21
0262 39C1   46             text  'Failed loading file: '
     39C2 6169     
     39C4 6C65     
     39C6 6420     
     39C8 6C6F     
     39CA 6164     
     39CC 696E     
     39CE 6720     
     39D0 6669     
     39D2 6C65     
     39D4 3A20     
0263                       even
0264               
0265               txt.ioerr.save
0266 39D6 14               byte  20
0267 39D7   46             text  'Failed saving file: '
     39D8 6169     
     39DA 6C65     
     39DC 6420     
     39DE 7361     
     39E0 7669     
     39E2 6E67     
     39E4 2066     
     39E6 696C     
     39E8 653A     
     39EA 20       
0268                       even
0269               
0270               txt.ioerr.print
0271 39EC 1B               byte  27
0272 39ED   46             text  'Failed printing to device: '
     39EE 6169     
     39F0 6C65     
     39F2 6420     
     39F4 7072     
     39F6 696E     
     39F8 7469     
     39FA 6E67     
     39FC 2074     
     39FE 6F20     
     3A00 6465     
     3A02 7669     
     3A04 6365     
     3A06 3A20     
0273                       even
0274               
0275               txt.io.nofile
0276 3A08 16               byte  22
0277 3A09   4E             text  'No filename specified.'
     3A0A 6F20     
     3A0C 6669     
     3A0E 6C65     
     3A10 6E61     
     3A12 6D65     
     3A14 2073     
     3A16 7065     
     3A18 6369     
     3A1A 6669     
     3A1C 6564     
     3A1E 2E       
0278                       even
0279               
0280               txt.memfull.load
0281 3A20 2D               byte  45
0282 3A21   49             text  'Index full. File too large for editor buffer.'
     3A22 6E64     
     3A24 6578     
     3A26 2066     
     3A28 756C     
     3A2A 6C2E     
     3A2C 2046     
     3A2E 696C     
     3A30 6520     
     3A32 746F     
     3A34 6F20     
     3A36 6C61     
     3A38 7267     
     3A3A 6520     
     3A3C 666F     
     3A3E 7220     
     3A40 6564     
     3A42 6974     
     3A44 6F72     
     3A46 2062     
     3A48 7566     
     3A4A 6665     
     3A4C 722E     
0283                       even
0284               
0285               txt.block.inside
0286 3A4E 2D               byte  45
0287 3A4F   43             text  'Copy/Move target must be outside M1-M2 range.'
     3A50 6F70     
     3A52 792F     
     3A54 4D6F     
     3A56 7665     
     3A58 2074     
     3A5A 6172     
     3A5C 6765     
     3A5E 7420     
     3A60 6D75     
     3A62 7374     
     3A64 2062     
     3A66 6520     
     3A68 6F75     
     3A6A 7473     
     3A6C 6964     
     3A6E 6520     
     3A70 4D31     
     3A72 2D4D     
     3A74 3220     
     3A76 7261     
     3A78 6E67     
     3A7A 652E     
0288                       even
0289               
0290               
0291               ;--------------------------------------------------------------
0292               ; Strings for command buffer
0293               ;--------------------------------------------------------------
0294               txt.cmdb.prompt
0295 3A7C 01               byte  1
0296 3A7D   3E             text  '>'
0297                       even
0298               
0299               txt.colorscheme
0300 3A7E 0D               byte  13
0301 3A7F   43             text  'Color scheme:'
     3A80 6F6C     
     3A82 6F72     
     3A84 2073     
     3A86 6368     
     3A88 656D     
     3A8A 653A     
0302                       even
0303               
                   < ram.resident.asm
0042                       copy  "data.defaults.asm"      ; Default values (devices, ...)
     **** ****     > data.defaults.asm
0001               * FILE......: data.defaults.asm
0002               * Purpose...: Default values for Stevie
0003               
0004               ***************************************************************
0005               *                     Default values
0006               ********|*****|*********************|**************************
0007               def.printer.fname
0008 3A8C 06               byte  6
0009 3A8D   50             text  'PI.PIO'
     3A8E 492E     
     3A90 5049     
     3A92 4F       
0010                       even
0011               
0012               def.clip.fname
0013 3A94 09               byte  9
0014 3A95   44             text  'DSK1.CLIP'
     3A96 534B     
     3A98 312E     
     3A9A 434C     
     3A9C 4950     
0015                       even
0016               
0017               def.clip.fname.b
0018 3A9E 09               byte  9
0019 3A9F   44             text  'DSK2.CLIP'
     3AA0 534B     
     3AA2 322E     
     3AA4 434C     
     3AA6 4950     
0020                       even
0021               
0022               def.clip.fname.c
0023 3AA8 09               byte  9
0024 3AA9   54             text  'TIPI.CLIP'
     3AAA 4950     
     3AAC 492E     
     3AAE 434C     
     3AB0 4950     
0025                       even
0026               
0027               def.devices
0028 3AB2 2F               byte  47
0029 3AB3   2C             text  ',DSK,HDX,IDE,PI.,PIO,TIPI.,RD,SCS,SDD,WDS,RS232'
     3AB4 4453     
     3AB6 4B2C     
     3AB8 4844     
     3ABA 582C     
     3ABC 4944     
     3ABE 452C     
     3AC0 5049     
     3AC2 2E2C     
     3AC4 5049     
     3AC6 4F2C     
     3AC8 5449     
     3ACA 5049     
     3ACC 2E2C     
     3ACE 5244     
     3AD0 2C53     
     3AD2 4353     
     3AD4 2C53     
     3AD6 4444     
     3AD8 2C57     
     3ADA 4453     
     3ADC 2C52     
     3ADE 5332     
     3AE0 3332     
0030                       even
0031               
                   < ram.resident.asm
                   < stevie_b7.asm.16732
0042                       ;------------------------------------------------------
0043                       ; Activate bank 1 and branch to  >6036
0044                       ;------------------------------------------------------
0045 3AE2 04E0  34         clr   @bank1.rom            ; Activate bank 1 "James" ROM
     3AE4 6002     
0046               
0050               
0051 3AE6 0460  28         b     @kickstart.code2      ; Jump to entry routine
     3AE8 6046     
0052               ***************************************************************
0053               * Step 3: Include main editor modules
0054               ********|*****|*********************|**************************
0055               main:
0056                       aorg  kickstart.code2       ; >6046
0057 6046 06A0  32         bl    @cpu.crash            ; Should never get here
     6048 2026     
0058                       ;-----------------------------------------------------------------------
0059                       ; SAMS support routines and utilities
0060                       ;-----------------------------------------------------------------------
0061                       copy  "magic.asm"                ; Magic string handling
     **** ****     > magic.asm
0001               * FILE......: magic.asm
0002               * Purpose...: Handle magic strings
0003               
0004               ***************************************************************
0005               * magic.set
0006               * Set magic string in core memory
0007               ***************************************************************
0008               * bl @magic.set
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * none
0018               *--------------------------------------------------------------
0019               * Set the bytes 'DEAD994ABEEF' in core memory.
0020               * If the sequence is set then Stevie knows its safe to resume
0021               * without initializing.
0022               ********|*****|*********************|**************************
0023               magic.set:
0024 604A 0649  14         dect  stack
0025 604C C64B  30         mov   r11,*stack            ; Save return address
0026                       ;------------------------------------------------------
0027                       ; Set magic string
0028                       ;------------------------------------------------------
0029 604E C820  54         mov   @magic.string+0,@magic.str.w1
     6050 609C     
     6052 A000     
0030 6054 C820  54         mov   @magic.string+2,@magic.str.w2
     6056 609E     
     6058 A002     
0031 605A C820  54         mov   @magic.string+4,@magic.str.w3
     605C 60A0     
     605E A004     
0032                       ;------------------------------------------------------
0033                       ; Exit
0034                       ;------------------------------------------------------
0035               magic.set.exit:
0036 6060 C2F9  30         mov   *stack+,r11           ; Pop r11
0037 6062 045B  20         b     *r11                  ; Return to caller
0038               
0039               
0040               
0041               ***************************************************************
0042               * magic.clear
0043               * Clear magic string in core memory
0044               ***************************************************************
0045               * bl @magic.set
0046               *--------------------------------------------------------------
0047               * INPUT
0048               * none
0049               *--------------------------------------------------------------
0050               * OUTPUT
0051               * none
0052               *--------------------------------------------------------------
0053               * Register usage
0054               * none
0055               *--------------------------------------------------------------
0056               * Clear the bytes 'DEAD994ABEEF' in core memory.
0057               * Indicate it's unsafe to resume Stevie and initialization
0058               * is necessary.
0059               ********|*****|*********************|**************************
0060               magic.clear:
0061 6064 0649  14         dect  stack
0062 6066 C64B  30         mov   r11,*stack            ; Save return address
0063                       ;------------------------------------------------------
0064                       ; Clear magic string
0065                       ;------------------------------------------------------
0066 6068 04E0  34         clr   @magic.str.w1
     606A A000     
0067 606C 04E0  34         clr   @magic.str.w2
     606E A002     
0068 6070 04E0  34         clr   @magic.str.w3
     6072 A004     
0069                       ;------------------------------------------------------
0070                       ; Exit
0071                       ;------------------------------------------------------
0072               magic.clear.exit:
0073 6074 C2F9  30         mov   *stack+,r11           ; Pop r11
0074 6076 045B  20         b     *r11                  ; Return to caller
0075               
0076               
0077               
0078               ***************************************************************
0079               * magic.check
0080               * Check if magic string is set
0081               ***************************************************************
0082               * bl @magic.set
0083               *--------------------------------------------------------------
0084               * INPUT
0085               * none
0086               *--------------------------------------------------------------
0087               * OUTPUT
0088               * r0 = >ffff Magic string set
0089               * r0 = >0000 Magic string not set
0090               *--------------------------------------------------------------
0091               * Register usage
0092               * r0
0093               *--------------------------------------------------------------
0094               * Clear the bytes 'DEAD994ABEEF' in core memory.
0095               * Indicate it's unsafe to resume Stevie and initialization
0096               * is necessary.
0097               ********|*****|*********************|**************************
0098               magic.check:
0099 6078 0649  14         dect  stack
0100 607A C64B  30         mov   r11,*stack            ; Save return address
0101                       ;------------------------------------------------------
0102                       ; Check magic string
0103                       ;------------------------------------------------------
0104 607C 04C0  14         clr   r0                    ; Reset flag
0105               
0106 607E 8820  54         c     @magic.str.w1,@magic.string
     6080 A000     
     6082 609C     
0107 6084 1609  14         jne   magic.check.exit
0108 6086 8820  54         c     @magic.str.w2,@magic.string+2
     6088 A002     
     608A 609E     
0109 608C 1605  14         jne   magic.check.exit
0110 608E 8820  54         c     @magic.str.w3,@magic.string+4
     6090 A004     
     6092 60A0     
0111 6094 1601  14         jne   magic.check.exit
0112               
0113 6096 0700  14         seto  r0                    ; Yes, magic string is set
0114                       ;------------------------------------------------------
0115                       ; Exit
0116                       ;------------------------------------------------------
0117               magic.check.exit:
0118 6098 C2F9  30         mov   *stack+,r11           ; Pop r11
0119 609A 045B  20         b     *r11                  ; Return to caller
0120               
0121               
0122               
0123 609C DEAD     magic.string  byte >de,>ad,>99,>4a,>be,>ef
     609E 994A     
     60A0 BEEF     
0124                                                   ; DEAD 994A BEEF
                   < stevie_b7.asm.16732
0062                       copy  "mem.sams.layout.asm"      ; Setup SAMS banks from cart space
     **** ****     > mem.sams.layout.asm
0001               
0002               ***************************************************************
0003               * _mem.sams.set.banks
0004               * Setup SAMS memory banks
0005               ***************************************************************
0006               * INPUT
0007               * r0
0008               *--------------------------------------------------------------
0009               * OUTPUT
0010               * none
0011               *--------------------------------------------------------------
0012               * Register usage
0013               * r0, r12
0014               *--------------------------------------------------------------
0015               * Remarks
0016               * Setup SAMS standard layout without using any library calls
0017               * or stack. Must run without dependencies.
0018               * This is the same order as when using SAMS transparent mode.
0019               ********|*****|*********************|**************************
0020               _mem.sams.set.banks:
0021                       ;-------------------------------------------------------
0022                       ; Setup SAMS banks using inline code
0023                       ;-------------------------------------------------------
0024 60A2 020C  20         li    r12,>1e00             ; SAMS CRU address
     60A4 1E00     
0025 60A6 1D00  20         sbo   0                     ; Enable access to SAMS registers
0026               
0027 60A8 C830  50         mov   *r0+,@>4004           ; Set page for >2000 - >2fff
     60AA 4004     
0028 60AC C830  50         mov   *r0+,@>4006           ; Set page for >3000 - >3fff
     60AE 4006     
0029 60B0 C830  50         mov   *r0+,@>4014           ; Set page for >a000 - >afff
     60B2 4014     
0030 60B4 C830  50         mov   *r0+,@>4016           ; Set page for >b000 - >bfff
     60B6 4016     
0031 60B8 C830  50         mov   *r0+,@>4018           ; Set page for >c000 - >cfff
     60BA 4018     
0032 60BC C830  50         mov   *r0+,@>401a           ; Set page for >d000 - >dfff
     60BE 401A     
0033 60C0 C830  50         mov   *r0+,@>401c           ; Set page for >e000 - >efff
     60C2 401C     
0034 60C4 C830  50         mov   *r0+,@>401e           ; Set page for >f000 - >ffff
     60C6 401E     
0035               
0036 60C8 1E00  20         sbz   0                     ; Disable access to SAMS registers
0037                       ;------------------------------------------------------
0038                       ; Exit
0039                       ;------------------------------------------------------
0040               mem.sams.set.banks.exit:
0041 60CA 045B  20         b     *r11                  ; Return
0042               
0043               
0044               
0045               
0046               ***************************************************************
0047               * mem.sams.set.legacy
0048               * Setup SAMS memory banks to legacy layout and exit to monitor
0049               ***************************************************************
0050               * INPUT
0051               * none
0052               *--------------------------------------------------------------
0053               * OUTPUT
0054               * none
0055               *--------------------------------------------------------------
0056               * Register usage
0057               * r12
0058               *--------------------------------------------------------------
0059               * Remarks
0060               * Setup SAMS standard layout without using any library calls
0061               * or stack. Must run without dependencies.
0062               * This is the same order as when using SAMS transparent mode.
0063               *
0064               * We never do a normal return from this routine, instead we
0065               * activate bank 0 in the cartridge space and return to monitor.
0066               ********|*****|*********************|**************************
0067               mem.sams.set.legacy:
0068 60CC 020C  20         li    r12,>1e00             ; SAMS CRU address
     60CE 1E00     
0069 60D0 1E01  20         sbz   1                     ; Disable SAMS mapper
0070                                                   ; \ We keep the mapper off while
0071                                                   ; | running TI Basic or other external
0072                                                   ; / programs.
0073                       ;-------------------------------------------------------
0074                       ; Setup SAMS banks using inline code
0075                       ;-------------------------------------------------------
0076 60D2 0200  20         li    r0,mem.sams.layout.legacy
     60D4 6B20     
0077 60D6 06A0  32         bl    @_mem.sams.set.banks  ; Set SAMS banks
     60D8 60A2     
0078                       ;-------------------------------------------------------
0079                       ; Poke exit routine into scratchpad memory
0080                       ;-------------------------------------------------------
0081 60DA C820  54         mov   @mem.sams.set.legacy.code,@>8300
     60DC 60FC     
     60DE 8300     
0082 60E0 C820  54         mov   @mem.sams.set.legacy.code+2,@>8302
     60E2 60FE     
     60E4 8302     
0083 60E6 C820  54         mov   @mem.sams.set.legacy.code+4,@>8304
     60E8 6100     
     60EA 8304     
0084 60EC C820  54         mov   @mem.sams.set.legacy.code+6,@>8306
     60EE 6102     
     60F0 8306     
0085 60F2 C820  54         mov   @mem.sams.set.legacy.code+8,@>8308
     60F4 6104     
     60F6 8308     
0086 60F8 0460  28         b     @>8300                ; Run code. Bye bye.
     60FA 8300     
0087                       ;-------------------------------------------------------
0088                       ; Assembly language code for returning to monitor
0089                       ;-------------------------------------------------------
0090               mem.sams.set.legacy.code:
0091 60FC 04E0             data  >04e0,bank0.rom       ; Activate bank 0
     60FE 6000     
0092 6100 0420             data  >0420,>0000           ; blwp @0
     6102 0000     
0093               
0094               
0095               
0096               ***************************************************************
0097               * mem.sams.set.boot
0098               * Setup SAMS memory banks for stevie startup
0099               ***************************************************************
0100               * INPUT
0101               * none
0102               *--------------------------------------------------------------
0103               * OUTPUT
0104               * none
0105               *--------------------------------------------------------------
0106               * Register usage
0107               * r0, r12
0108               *--------------------------------------------------------------
0109               * Remarks
0110               * Setup SAMS layout for stevie without using any library calls
0111               * or stack. Must run without dependencies.
0112               ********|*****|*********************|**************************
0113               mem.sams.set.boot:
0114                       ;-------------------------------------------------------
0115                       ; Setup SAMS banks using inline code
0116                       ;-------------------------------------------------------
0117 6104 0200  20         li    r0,mem.sams.layout.boot
     6106 6B30     
0118 6108 10CC  14         jmp   _mem.sams.set.banks   ; Set SAMS banks
0119               
0120               
0121               
0122               ***************************************************************
0123               * mem.sams.set.external
0124               * Setup SAMS memory banks for calling external program
0125               ***************************************************************
0126               * INPUT
0127               * none
0128               *--------------------------------------------------------------
0129               * OUTPUT
0130               * none
0131               *--------------------------------------------------------------
0132               * Register usage
0133               * r0, r12
0134               *--------------------------------------------------------------
0135               * Remarks
0136               * Main purpose is for doing a VDP dump of the Stevie screen
0137               * before an external program is called.
0138               *
0139               * It's expected that for the external program itself a separate
0140               * SAMS layout is used, for example TI basic session 1, ...
0141               ********|*****|*********************|**************************
0142               mem.sams.set.external:
0143                       ;-------------------------------------------------------
0144                       ; Setup SAMS banks using inline code
0145                       ;-------------------------------------------------------
0146 610A 0200  20         li    r0,mem.sams.layout.external
     610C 6B40     
0147 610E 10C9  14         jmp   _mem.sams.set.banks   ; Set SAMS banks
0148               
0149               
0150               
0151               
0152               ***************************************************************
0153               * mem.sams.set.basic1
0154               * Setup SAMS memory banks for TI Basic session 1
0155               ***************************************************************
0156               * INPUT
0157               * none
0158               *--------------------------------------------------------------
0159               * OUTPUT
0160               * none
0161               *--------------------------------------------------------------
0162               * Register usage
0163               * tmp0, r12
0164               *--------------------------------------------------------------
0165               * Remarks
0166               * Purpose is to handle backup/restore all the VDP memory
0167               * used by this TI Basic session.
0168               ********|*****|*********************|**************************
0169               mem.sams.set.basic1:
0170                       ;-------------------------------------------------------
0171                       ; Setup SAMS banks using inline code
0172                       ;-------------------------------------------------------
0173 6110 0200  20         li    r0,mem.sams.layout.basic1
     6112 6B50     
0174 6114 10C6  14         jmp   _mem.sams.set.banks   ; Set SAMS banks
0175               
0176               
0177               
0178               ***************************************************************
0179               * mem.sams.set.basic2
0180               * Setup SAMS memory banks for TI Basic session 2
0181               ***************************************************************
0182               * INPUT
0183               * none
0184               *--------------------------------------------------------------
0185               * OUTPUT
0186               * none
0187               *--------------------------------------------------------------
0188               * Register usage
0189               * tmp0, r12
0190               *--------------------------------------------------------------
0191               * Remarks
0192               * Purpose is to handle backup/restore all the VDP memory
0193               * used by this TI Basic session.
0194               ********|*****|*********************|**************************
0195               mem.sams.set.basic2:
0196                       ;-------------------------------------------------------
0197                       ; Setup SAMS banks using inline code
0198                       ;-------------------------------------------------------
0199 6116 0200  20         li    r0,mem.sams.layout.basic2
     6118 6B60     
0200 611A 10C3  14         jmp   _mem.sams.set.banks   ; Set SAMS banks
0201               
0202               
0203               
0204               ***************************************************************
0205               * mem.sams.set.basic3
0206               * Setup SAMS memory banks for TI Basic session 3
0207               ***************************************************************
0208               * INPUT
0209               * none
0210               *--------------------------------------------------------------
0211               * OUTPUT
0212               * none
0213               *--------------------------------------------------------------
0214               * Register usage
0215               * tmp0, r12
0216               *--------------------------------------------------------------
0217               * Remarks
0218               * Purpose is to handle backup/restore all the VDP memory
0219               * used by this TI Basic session.
0220               ********|*****|*********************|**************************
0221               mem.sams.set.basic3:
0222                       ;-------------------------------------------------------
0223                       ; Setup SAMS banks using inline code
0224                       ;-------------------------------------------------------
0225 611C 0200  20         li    r0,mem.sams.layout.basic3
     611E 6B70     
0226 6120 10C0  14         jmp   _mem.sams.set.banks   ; Set SAMS banks
0227               
0228               
0229               ***************************************************************
0230               * mem.sams.set.basic4
0231               * Setup SAMS memory banks for TI Basic session 4
0232               ***************************************************************
0233               * INPUT
0234               * none
0235               *--------------------------------------------------------------
0236               * OUTPUT
0237               * none
0238               *--------------------------------------------------------------
0239               * Register usage
0240               * tmp0, r12
0241               *--------------------------------------------------------------
0242               * Remarks
0243               * Purpose is to handle backup/restore all the VDP memory
0244               * used by this TI Basic session.
0245               ********|*****|*********************|**************************
0246               mem.sams.set.basic4:
0247                       ;-------------------------------------------------------
0248                       ; Setup SAMS banks using inline code
0249                       ;-------------------------------------------------------
0250 6122 0200  20         li    r0,mem.sams.layout.basic4
     6124 6B80     
0251 6126 10BD  14         jmp   _mem.sams.set.banks   ; Set SAMS banks
0252               
0253               
0254               ***************************************************************
0255               * mem.sams.set.basic5
0256               * Setup SAMS memory banks for TI Basic session 5
0257               ***************************************************************
0258               * INPUT
0259               * none
0260               *--------------------------------------------------------------
0261               * OUTPUT
0262               * none
0263               *--------------------------------------------------------------
0264               * Register usage
0265               * tmp0, r12
0266               *--------------------------------------------------------------
0267               * Remarks
0268               * Purpose is to handle backup/restore all the VDP memory
0269               * used by this TI Basic session.
0270               ********|*****|*********************|**************************
0271               mem.sams.set.basic5:
0272                       ;-------------------------------------------------------
0273                       ; Setup SAMS banks using inline code
0274                       ;-------------------------------------------------------
0275 6128 0200  20         li    r0,mem.sams.layout.basic5
     612A 6B90     
0276 612C 10BA  14         jmp   _mem.sams.set.banks   ; Set SAMS banks
0277               
0278               
0279               ***************************************************************
0280               * mem.sams.set.stevie
0281               * Setup SAMS memory banks for stevie
0282               ***************************************************************
0283               * INPUT
0284               * none
0285               *--------------------------------------------------------------
0286               * OUTPUT
0287               * none
0288               *--------------------------------------------------------------
0289               * Register usage
0290               * r0, r12
0291               *--------------------------------------------------------------
0292               * Remarks
0293               * Setup SAMS layout for stevie without using any library calls
0294               * or stack. Must run without dependencies.
0295               *
0296               * Expects @tv.sams.xxxx variables to be set in advance with
0297               * routine "sams.layout.copy".
0298               *
0299               * Also the SAMS bank with the @tv.sams.xxxx variable must already
0300               * be active and may not switch to another bank.
0301               *
0302               * Is used for settings SAMS banks as they were before an
0303               * external program environment was called (e.g. TI Basic).
0304               ********|*****|*********************|**************************
0305               mem.sams.set.stevie:
0306                       ;-------------------------------------------------------
0307                       ; Setup SAMS banks using inline code
0308                       ;-------------------------------------------------------
0309 612E 020C  20         li    r12,>1e00             ; SAMS CRU address
     6130 1E00     
0310 6132 1D00  20         sbo   0                     ; Enable access to SAMS registers
0311               
0312 6134 1D01  20         sbo   1                     ; Enable SAMS mapper
0313                                                   ; \ Mapper must be on while setting SAMS
0314                                                   ; | registers with values in @tv.sams.xxxx
0315                                                   ; | Obviously, this requires the SAMS banks
0316                                                   ; | with the @tv.sams.xxxx variables not
0317                                                   ; / to change.
0318               
0319 6136 C020  34         mov   @tv.sams.2000,r0      ; \
     6138 A200     
0320 613A 06C0  14         swpb  r0                    ; | Set page for >2000 - >2fff
0321 613C C800  38         mov   r0,@>4004             ; /
     613E 4004     
0322               
0323 6140 C020  34         mov   @tv.sams.3000,r0      ; \
     6142 A202     
0324 6144 06C0  14         swpb  r0                    ; | Set page for >3000 - >3fff
0325 6146 C800  38         mov   r0,@>4006             ; /
     6148 4006     
0326               
0327 614A C020  34         mov   @tv.sams.a000,r0      ; \
     614C A204     
0328 614E 06C0  14         swpb  r0                    ; | Set page for >a000 - >afff
0329 6150 C800  38         mov   r0,@>4014             ; /
     6152 4014     
0330               
0331 6154 C020  34         mov   @tv.sams.b000,r0      ; \
     6156 A206     
0332 6158 06C0  14         swpb  r0                    ; | Set page for >b000 - >bfff
0333 615A C800  38         mov   r0,@>4016             ; /
     615C 4016     
0334               
0335 615E C020  34         mov   @tv.sams.c000,r0      ; \
     6160 A208     
0336 6162 06C0  14         swpb  r0                    ; | Set page for >c000 - >cfff
0337 6164 C800  38         mov   r0,@>4018             ; /
     6166 4018     
0338               
0339 6168 C020  34         mov   @tv.sams.d000,r0      ; \
     616A A20A     
0340 616C 06C0  14         swpb  r0                    ; | Set page for >d000 - >dfff
0341 616E C800  38         mov   r0,@>401a             ; /
     6170 401A     
0342               
0343 6172 C020  34         mov   @tv.sams.e000,r0      ; \
     6174 A20C     
0344 6176 06C0  14         swpb  r0                    ; | Set page for >e000 - >efff
0345 6178 C800  38         mov   r0,@>401c             ; /
     617A 401C     
0346               
0347 617C C020  34         mov   @tv.sams.f000,r0      ; \
     617E A20E     
0348 6180 06C0  14         swpb  r0                    ; | Set page for >f000 - >ffff
0349 6182 C800  38         mov   r0,@>401e             ; /
     6184 401E     
0350               
0351 6186 1E00  20         sbz   0                     ; Disable access to SAMS registers
0352 6188 1D01  20         sbo   1                     ; Enable SAMS mapper
0353                       ;------------------------------------------------------
0354                       ; Exit
0355                       ;------------------------------------------------------
0356               mem.sams.set.stevie.exit:
0357 618A 045B  20         b     *r11                  ; Return
                   < stevie_b7.asm.16732
0063                       ;-----------------------------------------------------------------------
0064                       ; TI Basic sessions
0065                       ;-----------------------------------------------------------------------
0066                       copy  "tib.session.asm"          ; Run TI Basic session
     **** ****     > tib.session.asm
0001               * FILE......: tib.session.asm
0002               * Purpose...: Run TI Basic session
0003               
0004               
0005               ***************************************************************
0006               * tib.run
0007               * Run TI Basic session
0008               ***************************************************************
0009               * bl   @tib.run
0010               *--------------------------------------------------------------
0011               * INPUT
0012               * @tib.session = TI Basic session to start/resume
0013               *
0014               * OUTPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * r1 in GPL WS, tmp0, tmp1, tmp2, r12
0019               *--------------------------------------------------------------
0020               * Remarks
0021               * tib.run >> b @0070 (GPL interpreter/TI Basic)
0022               *         >> isr
0023               *         >> tibasic.return
0024               *
0025               * Uses scratchpad memory
0026               * >83b4   Hide Flag/ISR counter for triggering SID display.
0027               * >83b6   TI Basic Session ID
0028               ********|*****|*********************|**************************
0029               tib.run:
0030 618C 0649  14         dect  stack
0031 618E C64B  30         mov   r11,*stack            ; Save return address
0032 6190 0649  14         dect  stack
0033 6192 C644  30         mov   tmp0,*stack           ; Push tmp0
0034 6194 0649  14         dect  stack
0035 6196 C645  30         mov   tmp1,*stack           ; Push tmp1
0036 6198 0649  14         dect  stack
0037 619A C646  30         mov   tmp2,*stack           ; Push tmp2
0038 619C 0649  14         dect  stack
0039 619E C64C  30         mov   r12,*stack            ; Push r12
0040                       ;-------------------------------------------------------
0041                       ; Setup SAMS memory
0042                       ;-------------------------------------------------------
0043 61A0 C802  38         mov   config,@tv.sp2.conf   ; Backup the SP2 config register
     61A2 A22C     
0044               
0045 61A4 06A0  32         bl    @sams.layout.copy     ; Backup Stevie SAMS page layout
     61A6 2652     
0046 61A8 A200                   data tv.sams.2000     ; \ @i = target address of 8 words table
0047                                                   ; /      that contains SAMS layout
0048               
0049 61AA 06A0  32         bl    @scroff               ; Turn off screen
     61AC 269A     
0050               
0051 61AE 06A0  32         bl    @mem.sams.set.external
     61B0 610A     
0052                                                   ; Load SAMS page layout (from cart space)
0053                                                   ; before running external program.
0054               
0055 61B2 06A0  32         bl    @cpyv2m
     61B4 24CC     
0056 61B6 0000                   data >0000,>b000,16384
     61B8 B000     
     61BA 4000     
0057                                                   ; Copy Stevie 16K VDP memory to RAM buffer
0058                                                   ; >b000->efff
0059                       ;-------------------------------------------------------
0060                       ; Put VDP in TI Basic compatible mode (32x24)
0061                       ;-------------------------------------------------------
0062 61BC 06A0  32         bl    @f18rst               ; Reset and lock the F18A
     61BE 27BA     
0063               
0064 61C0 06A0  32         bl    @vidtab               ; Load video mode table into VDP
     61C2 230C     
0065 61C4 366E                   data tibasic.32x24    ; Equate selected video mode table
0066                       ;-------------------------------------------------------
0067                       ; Keep 'Hide SID' flag for later use
0068                       ;-------------------------------------------------------
0069 61C6 C820  54         mov   @tib.hidesid,@>83fc   ; \
     61C8 A0C0     
     61CA 83FC     
0070                                                   ; | Store a copy in the Stevie
0071                                                   ; | scratchpad >83fc for later use in
0072                                                   ; / TI Basic scratchpad.
0073                       ;-------------------------------------------------------
0074                       ; Keep TI Basic session ID for later use
0075                       ;-------------------------------------------------------
0076 61CC C120  34         mov   @tib.session,tmp0     ; \
     61CE A0B4     
0077                                                   ; | Store TI Basic session ID in tmp0.
0078                                                   ; | Througout the subroutine tmp0 will
0079                                                   ; | keep this value, even when SAMS
0080                                                   ; | banks are switched.
0081                                                   ; |
0082 61D0 C804  38         mov   tmp0,@>83fe           ; | Also store a copy in the Stevie
     61D2 83FE     
0083                                                   ; | scratchpad >83fe for later use in
0084                                                   ; / TI Basic scratchpad.
0085                       ;-------------------------------------------------------
0086                       ; Switch for TI Basic session
0087                       ;-------------------------------------------------------
0088 61D4 0284  22         ci    tmp0,1
     61D6 0001     
0089 61D8 1310  14         jeq   tib.run.init.basic1
0090 61DA 0284  22         ci    tmp0,2
     61DC 0002     
0091 61DE 131E  14         jeq   tib.run.init.basic2
0092 61E0 0284  22         ci    tmp0,3
     61E2 0003     
0093 61E4 132C  14         jeq   tib.run.init.basic3
0094 61E6 0284  22         ci    tmp0,4
     61E8 0004     
0095 61EA 1338  14         jeq   tib.run.init.basic4
0096 61EC 0284  22         ci    tmp0,5
     61EE 0005     
0097 61F0 1344  14         jeq   tib.run.init.basic5
0098                       ;-------------------------------------------------------
0099                       ; Assert, should never get here
0100                       ;-------------------------------------------------------
0101 61F2 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     61F4 FFCE     
0102 61F6 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     61F8 2026     
0103                       ;-------------------------------------------------------
0104                       ; New TI Basic session 1
0105                       ;-------------------------------------------------------
0106               tib.run.init.basic1:
0107 61FA C160  34         mov   @tib.status1,tmp1     ; Resume TI Basic session?
     61FC A0B6     
0108 61FE 1302  14         jeq   !                     ; No, new session
0109 6200 0460  28         b     @tib.run.resume.basic1
     6202 631C     
0110               
0111 6204 0265  22 !       ori   tmp1,1                ; \
     6206 0001     
0112 6208 C805  38         mov   tmp1,@tib.status1     ; / Set resume flag for next run
     620A A0B6     
0113               
0114 620C 06A0  32         bl    @mem.sams.set.basic1  ; \ Load SAMS page layout (from cart space)
     620E 6110     
0115                                                   ; / for TI Basic session 1
0116               
0117 6210 06A0  32         bl    @cpym2v
     6212 249A     
0118 6214 06F8                   data >06f8,tibasic.patterns,8
     6216 656C     
     6218 0008     
0119                                                   ; Copy pattern TI-Basic session ID 1
0120               
0121 621A 103E  14         jmp   tib.run.init.rest     ; Continue initialisation
0122                       ;-------------------------------------------------------
0123                       ; New TI Basic session 2
0124                       ;-------------------------------------------------------
0125               tib.run.init.basic2:
0126 621C C160  34         mov   @tib.status2,tmp1     ; Resume TI Basic session?
     621E A0B8     
0127 6220 1302  14         jeq   !                     ; No, new session
0128 6222 0460  28         b     @tib.run.resume.basic2
     6224 632C     
0129               
0130 6226 0265  22 !       ori   tmp1,1                ; \
     6228 0001     
0131 622A C805  38         mov   tmp1,@tib.status2     ; / Set resume flag for next run
     622C A0B8     
0132               
0133 622E 06A0  32         bl    @mem.sams.set.basic2  ; \ Load SAMS page layout (from cart space)
     6230 6116     
0134                                                   ; / for TI Basic session 2
0135               
0136 6232 06A0  32         bl    @cpym2v
     6234 249A     
0137 6236 06F8                   data >06f8,tibasic.patterns+8,8
     6238 6574     
     623A 0008     
0138                                                   ; Copy pattern TI-Basic session ID 2
0139               
0140 623C 102D  14         jmp   tib.run.init.rest     ; Continue initialisation
0141                       ;-------------------------------------------------------
0142                       ; New TI Basic session 3
0143                       ;-------------------------------------------------------
0144               tib.run.init.basic3:
0145 623E C160  34         mov   @tib.status3,tmp1     ; Resume TI Basic session?
     6240 A0BA     
0146 6242 157C  14         jgt   tib.run.resume.basic3 ; yes, do resume
0147               
0148 6244 0265  22         ori   tmp1,1                ; \
     6246 0001     
0149 6248 C805  38         mov   tmp1,@tib.status3     ; / Set resume flag for next run
     624A A0BA     
0150               
0151 624C 06A0  32         bl    @mem.sams.set.basic3  ; \ Load SAMS page layout (from cart space)
     624E 611C     
0152                                                   ; / for TI Basic session 3
0153               
0154 6250 06A0  32         bl    @cpym2v
     6252 249A     
0155 6254 06F8                   data >06f8,tibasic.patterns+16,8
     6256 657C     
     6258 0008     
0156                                                   ; Copy pattern TI-Basic session ID 3
0157               
0158 625A 101E  14         jmp   tib.run.init.rest     ; Continue initialisation
0159                       ;-------------------------------------------------------
0160                       ; New TI Basic session 4
0161                       ;-------------------------------------------------------
0162               tib.run.init.basic4:
0163 625C C160  34         mov   @tib.status4,tmp1     ; Resume TI Basic session?
     625E A0BC     
0164 6260 1575  14         jgt   tib.run.resume.basic4 ; yes, do resume
0165               
0166 6262 0265  22         ori   tmp1,1                ; \
     6264 0001     
0167 6266 C805  38         mov   tmp1,@tib.status4     ; / Set resume flag for next run
     6268 A0BC     
0168               
0169 626A 06A0  32         bl    @mem.sams.set.basic4  ; \ Load SAMS page layout (from cart space)
     626C 6122     
0170                                                   ; / for TI Basic session 4
0171               
0172 626E 06A0  32         bl    @cpym2v
     6270 249A     
0173 6272 06F8                   data >06f8,tibasic.patterns+24,8
     6274 6584     
     6276 0008     
0174                                                   ; Copy pattern TI-Basic session ID 4
0175               
0176 6278 100F  14         jmp   tib.run.init.rest     ; Continue initialisation
0177                       ;-------------------------------------------------------
0178                       ; New TI Basic session 5
0179                       ;-------------------------------------------------------
0180               tib.run.init.basic5:
0181 627A C160  34         mov   @tib.status5,tmp1     ; Resume TI Basic session?
     627C A0BE     
0182 627E 156E  14         jgt   tib.run.resume.basic5 ; yes, do resume
0183               
0184 6280 0265  22         ori   tmp1,1                ; \
     6282 0001     
0185 6284 C805  38         mov   tmp1,@tib.status5     ; / Set resume flag for next run
     6286 A0BE     
0186               
0187 6288 06A0  32         bl    @mem.sams.set.basic5  ; \ Load SAMS page layout (from cart space)
     628A 6128     
0188                                                   ; / for TI Basic session 5
0189               
0190 628C 06A0  32         bl    @cpym2v
     628E 249A     
0191 6290 06F8                   data >06f8,tibasic.patterns+32,8
     6292 658C     
     6294 0008     
0192                                                   ; Copy pattern TI-Basic session ID 5
0193               
0194 6296 1000  14         jmp   tib.run.init.rest     ; Continue initialisation
0195                       ;-------------------------------------------------------
0196                       ; New TI Basic session (part 2)
0197                       ;-------------------------------------------------------
0198               tib.run.init.rest:
0199 6298 06A0  32         bl    @ldfnt
     629A 2374     
0200 629C 0900                   data >0900,fnopt3     ; Load font (upper & lower case)
     629E 000C     
0201               
0202 62A0 06A0  32         bl    @filv
     62A2 22A2     
0203 62A4 0300                   data >0300,>D0,2      ; No sprites
     62A6 00D0     
     62A8 0002     
0204               
0205 62AA 06A0  32         bl    @cpu.scrpad.backup    ; (1) Backup stevie primary scratchpad to
     62AC 2B04     
0206                                                   ;     fixed memory address @cpu.scrpad.tgt
0207               
0208 62AE 06A0  32         bl    @cpym2m
     62B0 24EE     
0209 62B2 F000                   data >f000,cpu.scrpad2,256
     62B4 AD00     
     62B6 0100     
0210                                                   ; (2) Stevie scratchpad dump cannot stay
0211                                                   ;     there, move to final destination.
0212               
0213 62B8 06A0  32         bl    @cpym2m
     62BA 24EE     
0214 62BC 7E00                   data cpu.scrpad.src,cpu.scrpad.tgt,256
     62BE F000     
     62C0 0100     
0215                                                   ; (3) Copy OS monitor scratchpad dump from
0216                                                   ;     cartridge rom to @cpu.scrpad.tgt
0217               
0218 62C2 02E0  18         lwpi  cpu.scrpad2           ; Flip workspace before starting restore
     62C4 AD00     
0219 62C6 06A0  32         bl    @cpu.scrpad.restore   ; Restore scratchpad from @cpu.scrpad.tgt
     62C8 2B38     
0220 62CA 02E0  18         lwpi  cpu.scrpad1           ; Flip workspace to scratchpad again
     62CC 8300     
0221               
0222                       ; ATTENTION
0223                       ; From here on no more access to any of the SP2 or stevie routines.
0224                       ; We're on unknown territory.
0225               
0226 62CE C820  54         mov   @cpu.scrpad2+252,@>83b4
     62D0 ADFC     
     62D2 83B4     
0227                                                   ; \ Store 'Hide SID' flag in TI Basic
0228                                                   ; | scratchpad address >83b4.
0229                                                   ; | Note that >83fc in Stevie scratchpad
0230                                                   ; / has copy of the flag.
0231               
0232 62D4 C820  54         mov   @cpu.scrpad2+254,@>83b6
     62D6 ADFE     
     62D8 83B6     
0233                                                   ; \ Store TI Basic session ID in TI Basic
0234                                                   ; | scratchpad address >83b6.
0235                                                   ; | Note that >83fe in Stevie scratchpad has
0236                                                   ; / a copy of the TI basic session ID.
0237                       ;-------------------------------------------------------
0238                       ; Poke some values
0239                       ;-------------------------------------------------------
0240 62DA C820  54         mov   @tibasic.scrpad.83d4,@>83d4
     62DC 63A4     
     62DE 83D4     
0241 62E0 C820  54         mov   @tibasic.scrpad.83fa,@>83fa
     62E2 63A6     
     62E4 83FA     
0242 62E6 C820  54         mov   @tibasic.scrpad.83fc,@>83fc
     62E8 63A8     
     62EA 83FC     
0243 62EC C820  54         mov   @tibasic.scrpad.83fe,@>83fe
     62EE 63AA     
     62F0 83FE     
0244                       ;-------------------------------------------------------
0245                       ; Register ISR hook in scratch pad
0246                       ;-------------------------------------------------------
0247 62F2 02E0  18         lwpi  cpu.scrpad1           ; Scratchpad in >8300 again
     62F4 8300     
0248 62F6 0201  20         li    r1,isr                ; \
     62F8 63AC     
0249 62FA C801  38         mov   r1,@>83c4             ; | >83c4 = Pointer to start address of ISR
     62FC 83C4     
0250                                                   ; /
0251               
0252 62FE 020C  20         li    r12,>1e00             ; \ Disable SAMS mapper (transparent mode)
     6300 1E00     
0253 6302 1E01  20         sbz   1                     ; /
0254                       ;-------------------------------------------------------
0255                       ; Run TI Basic session in GPL Interpreter
0256                       ;-------------------------------------------------------
0257 6304 02E0  18         lwpi  >83e0
     6306 83E0     
0258 6308 0201  20         li    r1,>216f              ; Entrypoint for GPL TI Basic interpreter
     630A 216F     
0259 630C D801  38         movb  r1,@grmwa             ; \
     630E 9C02     
0260 6310 06C1  14         swpb  r1                    ; | Set GPL address
0261 6312 D801  38         movb  r1,@grmwa             ; /
     6314 9C02     
0262 6316 1000  14         nop
0263 6318 0460  28         b     @>0070                ; Start GPL interpreter
     631A 0070     
0264                       ;-------------------------------------------------------
0265                       ; Resume TI-Basic session 1
0266                       ;-------------------------------------------------------
0267               tib.run.resume.basic1:
0268 631C 06A0  32         bl    @mem.sams.set.basic1  ; \ Load SAMS page layout (from cart space)
     631E 6110     
0269                                                   ; / for TI Basic session 1
0270               
0271 6320 06A0  32         bl    @cpym2m               ; \ Copy TI Basic scratchpad to fixed memory
     6322 24EE     
0272 6324 F100                   data >f100,>f000,256  ; / address @cpu.scrpad.target
     6326 F000     
     6328 0100     
0273               
0274 632A 101F  14         jmp   tib.run.resume.part2  ; Continue resume
0275                       ;-------------------------------------------------------
0276                       ; Resume TI-Basic session 2
0277                       ;-------------------------------------------------------
0278               tib.run.resume.basic2:
0279 632C 06A0  32         bl    @mem.sams.set.basic2  ; \ Load SAMS page layout (from cart space)
     632E 6116     
0280                                                   ; / for TI Basic session 2
0281               
0282 6330 06A0  32         bl    @cpym2m               ; \ Copy TI Basic scratchpad to fixed memory
     6332 24EE     
0283 6334 F200                   data >f200,>f000,256  ; / address @cpu.scrpad.target
     6336 F000     
     6338 0100     
0284               
0285 633A 1017  14         jmp   tib.run.resume.part2  ; Continue resume
0286                       ;-------------------------------------------------------
0287                       ; Resume TI-Basic session 3
0288                       ;-------------------------------------------------------
0289               tib.run.resume.basic3:
0290 633C 06A0  32         bl    @mem.sams.set.basic3  ; \ Load SAMS page layout (from cart space)
     633E 611C     
0291                                                   ; / for TI Basic session 3
0292               
0293 6340 06A0  32         bl    @cpym2m               ; \ Copy TI Basic scratchpad to fixed memory
     6342 24EE     
0294 6344 F300                   data >f300,>f000,256  ; / address @cpu.scrpad.target
     6346 F000     
     6348 0100     
0295               
0296 634A 100F  14         jmp   tib.run.resume.part2  ; Continue resume
0297                       ;-------------------------------------------------------
0298                       ; Resume TI-Basic session 4
0299                       ;-------------------------------------------------------
0300               tib.run.resume.basic4:
0301 634C 06A0  32         bl    @mem.sams.set.basic4  ; \ Load SAMS page layout (from cart space)
     634E 6122     
0302                                                   ; / for TI Basic session 4
0303               
0304 6350 06A0  32         bl    @cpym2m               ; \ Copy TI Basic scratchpad to fixed memory
     6352 24EE     
0305 6354 F400                   data >f400,>f000,256  ; / address @cpu.scrpad.target
     6356 F000     
     6358 0100     
0306               
0307 635A 1007  14         jmp   tib.run.resume.part2  ; Continue resume
0308                       ;-------------------------------------------------------
0309                       ; Resume TI-Basic session 5
0310                       ;-------------------------------------------------------
0311               tib.run.resume.basic5:
0312 635C 06A0  32         bl    @mem.sams.set.basic5  ; \ Load SAMS page layout (from cart space)
     635E 6128     
0313                                                   ; / for TI Basic session 5
0314               
0315 6360 06A0  32         bl    @cpym2m               ; \ Copy TI Basic scratchpad to fixed memory
     6362 24EE     
0316 6364 F500                   data >f500,>f000,256  ; / address @cpu.scrpad.target
     6366 F000     
     6368 0100     
0317                       ;-------------------------------------------------------
0318                       ; Resume TI-Basic session (part 2)
0319                       ;-------------------------------------------------------
0320               tib.run.resume.part2:
0321 636A C1E0  34         mov   @>83fc,r7             ; Get 'Hide SID' flag
     636C 83FC     
0322 636E 1304  14         jeq   tib.run.resume.vdp    ; Flag is reset, skip clearing SID
0323               
0324 6370 0207  20         li    r7,>8080              ; Whitespace (with TI-Basic offset >60)
     6372 8080     
0325 6374 C807  38         mov   r7,@>b01e             ; Clear SID in VDP screen backup
     6376 B01E     
0326                       ;-------------------------------------------------------
0327                       ; Restore VDP memory
0328                       ;-------------------------------------------------------
0329               tib.run.resume.vdp:
0330 6378 06A0  32         bl    @cpym2v
     637A 249A     
0331 637C 0000                   data >0000,>b000,16384
     637E B000     
     6380 4000     
0332                                                   ; Restore TI Basic 16K VDP memory from
0333                                                   ; RAM buffer >b000->efff
0334               
0335                       ;-------------------------------------------------------
0336                       ; Restore scratchpad memory
0337                       ;-------------------------------------------------------
0338               tib.run.resume.scrpad:
0339 6382 02E0  18         lwpi  cpu.scrpad2           ; Flip workspace before starting restore
     6384 AD00     
0340 6386 06A0  32         bl    @cpu.scrpad.restore   ; Restore scratchpad from @cpu.scrpad.tgt
     6388 2B38     
0341 638A 02E0  18         lwpi  cpu.scrpad1           ; Flip workspace to scratchpad again
     638C 8300     
0342               
0343 638E C820  54         mov   @cpu.scrpad2+252,@>83b4
     6390 ADFC     
     6392 83B4     
0344                                                   ; \ Store 'Hide SID' flag in TI Basic
0345                                                   ; | scratchpad address >83b4.
0346                                                   ; | Note that >83fc in Stevie scratchpad
0347                                                   ; / has copy of the flag.
0348               
0349                       ;-------------------------------------------------------
0350                       ; Load legacy SAMS bank layout
0351                       ;-------------------------------------------------------
0352               tibasic.resume.load:
0353 6394 02E0  18         lwpi  cpu.scrpad1           ; Workspace must be in scratchpad again!
     6396 8300     
0354 6398 04CB  14         clr   r11
0355               
0356 639A 020C  20         li    r12,>1e00             ; \ Disable SAMS mapper (transparent mode)
     639C 1E00     
0357 639E 1E01  20         sbz   1                     ; /
0358               
0359                       ; ATTENTION
0360                       ; From here on no more access to any of the SP2 or stevie routines.
0361                       ; We're on unknown territory.
0362               
0363                       ;-------------------------------------------------------
0364                       ; Resume TI Basic interpreter
0365                       ;-------------------------------------------------------
0366 63A0 0460  28         b     @>0ab8                ; Return from interrupt routine.
     63A2 0AB8     
0367                                                   ; See TI Intern page 32 (german)
0368                       ;-------------------------------------------------------
0369                       ; Required values for TI Basic scratchpad
0370                       ;-------------------------------------------------------
0371               tibasic.scrpad.83d4:
0372 63A4 E000             data  >e000
0373               tibasic.scrpad.83fa:
0374 63A6 9800             data  >9800
0375               tibasic.scrpad.83fc:
0376 63A8 0108             data  >0108
0377               tibasic.scrpad.83fe:
0378 63AA 8C02             data  >8c02
0379               
0380               
0381               
0382               
0383               
0384               
0385               ***************************************************************
0386               * isr
0387               * Interrupt Service Routine in TI Basic
0388               ***************************************************************
0389               * Called from console rom at >0ab6
0390               * See TI Intern page 32 (german) for details
0391               *--------------------------------------------------------------
0392               * OUTPUT
0393               * none
0394               *--------------------------------------------------------------
0395               * Register usage
0396               * r7, 12
0397               ********|*****|*********************|**************************
0398               isr:
0399 63AC 0300  24         limi  0                     ; \ Turn off interrupts
     63AE 0000     
0400                                                   ; / Prevent ISR reentry
0401               
0402 63B0 C807  38         mov   r7,@rambuf            ; Backup R7
     63B2 A100     
0403 63B4 C80C  38         mov   r12,@rambuf+2         ; Backup R12
     63B6 A102     
0404                       ;--------------------------------------------------------------
0405                       ; Exit ISR if TI-Basic is busy running a program
0406                       ;--------------------------------------------------------------
0407 63B8 C1E0  34         mov   @>8344,r7             ; Busy running program?
     63BA 8344     
0408 63BC 0287  22         ci    r7,>0100
     63BE 0100     
0409 63C0 1601  14         jne   isr.showid            ; No, TI-Basic is in command line mode.
0410                       ;--------------------------------------------------------------
0411                       ; TI-Basic program running
0412                       ;--------------------------------------------------------------
0413 63C2 1023  14         jmp   isr.exit              ; Exit
0414                       ;--------------------------------------------------------------
0415                       ; Show TI-Basic session ID ?
0416                       ;--------------------------------------------------------------
0417               isr.showid:
0418 63C4 C1E0  34         mov   @>83b4,r7             ; Get counter/Hide flag
     63C6 83B4     
0419 63C8 0287  22         ci    r7,>ffff              ; Hide flag set?
     63CA FFFF     
0420 63CC 1317  14         jeq   isr.hotkey            ; Yes, skip showing session ID
0421 63CE 0287  22         ci    r7,>0010              ; Counter limit reached ?
     63D0 0010     
0422 63D2 1112  14         jlt   isr.counter           ; Not yet, skip showing Session ID
0423 63D4 04E0  34         clr   @>83b4                ; Reset counter
     63D6 83B4     
0424                       ;--------------------------------------------------------------
0425                       ; Setup VDP write address for column 30
0426                       ;--------------------------------------------------------------
0427 63D8 0207  20         li    r7,>401e              ; \
     63DA 401E     
0428 63DC 06C7  14         swpb  r7                    ; | >1c is the VDP column position
0429 63DE D807  38         movb  r7,@vdpa              ; | where bytes should be written
     63E0 8C02     
0430 63E2 06C7  14         swpb  r7                    ; |
0431 63E4 D807  38         movb  r7,@vdpa              ; /
     63E6 8C02     
0432                       ;--------------------------------------------------------------
0433                       ; Dump TI-Basic Session ID to screen
0434                       ;--------------------------------------------------------------
0435 63E8 0207  20         li    r7,>83df              ; Char '#' and char >df
     63EA 83DF     
0436 63EC D807  38         movb  r7,@vdpw              ; Write byte
     63EE 8C00     
0437 63F0 06C7  14         swpb  r7
0438 63F2 D807  38         movb  r7,@vdpw              ; Write byte
     63F4 8C00     
0439 63F6 1002  14         jmp   isr.hotkey
0440                       ;-------------------------------------------------------
0441                       ; Increase counter
0442                       ;-------------------------------------------------------
0443               isr.counter:
0444 63F8 05A0  34         inc   @>83b4                ; Increase counter
     63FA 83B4     
0445                       ;-------------------------------------------------------
0446                       ; Hotkey pressed?
0447                       ;-------------------------------------------------------
0448               isr.hotkey:
0449 63FC C1E0  34         mov   @>8374,r7             ; \ Get keyboard scancode from @>8375
     63FE 8374     
0450 6400 0247  22         andi  r7,>00ff              ; / LSB only
     6402 00FF     
0451 6404 0287  22         ci    r7,>0f                ; Hotkey fctn + '9' pressed?
     6406 000F     
0452 6408 133B  14         jeq   tib.run.return        ; Yes, return to Stevie
0453                       ;-------------------------------------------------------
0454                       ; Return from ISR
0455                       ;-------------------------------------------------------
0456               isr.exit:
0457 640A C320  34         mov   @rambuf+2,r12         ; Restore R12
     640C A102     
0458 640E C1E0  34         mov   @rambuf,r7            ; Restore R7
     6410 A100     
0459 6412 045B  20         b     *r11                  ; Return from ISR
0460               
0461               
0462               ***************************************************************
0463               * tib.run.return.mon
0464               * Return from OS Monitor/TI Basic to Stevie
0465               ***************************************************************
0466               * bl   @tib.run.return.mon
0467               *--------------------------------------------------------------
0468               * OUTPUT
0469               * none
0470               *--------------------------------------------------------------
0471               * Register usage
0472               * r1 in GPL WS, tmp0, tmp1
0473               *--------------------------------------------------------------
0474               * REMARKS
0475               * Called from ISR code
0476               ********|*****|*********************|**************************
0477               tib.run.return.mon:
0478 6414 020C  20         li    r12,>1e00             ; \ Enable SAMS mapper again
     6416 1E00     
0479 6418 1D01  20         sbo   1                     ; | We stil have the SAMS banks layout
0480                                                   ; / mem.sams.layout.external
0481                       ;------------------------------------------------------
0482                       ; Check magic string (inline version, no SP2 present!)
0483                       ;------------------------------------------------------
0484 641A 8820  54         c     @magic.str.w1,@magic.string
     641C A000     
     641E 609C     
0485 6420 1611  14         jne   !
0486 6422 8820  54         c     @magic.str.w2,@magic.string+2
     6424 A002     
     6426 609E     
0487 6428 160D  14         jne   !
0488 642A 8820  54         c     @magic.str.w3,@magic.string+4
     642C A004     
     642E 60A0     
0489 6430 1609  14         jne   !
0490                       ;-------------------------------------------------------
0491                       ; Initialize
0492                       ;-------------------------------------------------------
0493 6432 C120  34         mov   @tib.session,tmp0
     6434 A0B4     
0494 6436 0284  22         ci    tmp0,1
     6438 0001     
0495 643A 1104  14         jlt   !
0496 643C 0284  22         ci    tmp0,5
     643E 0005     
0497 6440 1501  14         jgt   !
0498 6442 1002  14         jmp   tib.run.return.mon.cont
0499                       ;-------------------------------------------------------
0500                       ; Initialize Stevie
0501                       ;-------------------------------------------------------
0502 6444 0460  28 !       b     @kickstart.code1      ; Initialize Stevie
     6446 6040     
0503                       ;-------------------------------------------------------
0504                       ; Resume Stevie
0505                       ;-------------------------------------------------------
0506               tib.run.return.mon.cont:
0507 6448 02E0  18         lwpi  cpu.scrpad2           ; Activate workspace at >ad00 that was
     644A AD00     
0508                                                   ; paged out in tibasic.init
0509               
0510 644C 06A0  32         bl    @cpu.scrpad.pgin      ; \ Page-in scratchpad memory previously
     644E 2B8A     
0511 6450 AD00                   data cpu.scrpad2      ; | stored at >ad00 and set wp at >8300
0512                                                   ; / Destroys registers tmp0-tmp2
0513               
0514 6452 D820  54         movb  @w$ffff,@>8375        ; Reset keycode
     6454 2022     
     6456 8375     
0515               
0516 6458 C0A0  34         mov   @tv.sp2.conf,config   ; Restore the SP2 config register
     645A A22C     
0517               
0518 645C 06A0  32         bl    @mute                 ; Mute sound generators
     645E 280E     
0519 6460 06A0  32         bl    @scroff               ; Turn screen off
     6462 269A     
0520               
0521                       ; Prevent resuming the TI Basic session that lead us here.
0522                       ; Easiest thing to do is to reinitalize the session upon next start.
0523               
0524                       ;-------------------------------------------------------
0525                       ; Assert TI basic sesion ID
0526                       ;-------------------------------------------------------
0527 6464 C120  34         mov   @tib.session,tmp0     ; Get session ID
     6466 A0B4     
0528 6468 1307  14         jeq   !
0529 646A 0284  22         ci    tmp0,5
     646C 0005     
0530 646E 1504  14         jgt   !
0531                       ;-------------------------------------------------------
0532                       ; Reset session resume flag (tibasicX.status)
0533                       ;-------------------------------------------------------
0534 6470 0A14  56         sla   tmp0,1                ; Word align
0535 6472 04E4  34         clr   @tib.session(tmp0)
     6474 A0B4     
0536 6476 1054  14         jmp   tib.run.return.stevie
0537                       ;-------------------------------------------------------
0538                       ; Assert failed
0539                       ;-------------------------------------------------------
0540 6478 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     647A FFCE     
0541 647C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     647E 2026     
0542               
0543               
0544               
0545               ***************************************************************
0546               * tib.run.return
0547               * Return from TI Basic to Stevie
0548               ***************************************************************
0549               * bl   @tib.run.return
0550               *--------------------------------------------------------------
0551               * OUTPUT
0552               * none
0553               *--------------------------------------------------------------
0554               * Register usage
0555               * r1 in GPL WS, tmp0, tmp1
0556               *--------------------------------------------------------------
0557               * REMARKS
0558               * Called from ISR code
0559               ********|*****|*********************|**************************
0560               tib.run.return:
0561 6480 020C  20         li    r12,>1e00             ; \ Enable SAMS mapper again
     6482 1E00     
0562 6484 1D01  20         sbo   1                     ; | We stil have the SAMS banks layout
0563                                                   ; / mem.sams.layout.external
0564               
0565 6486 02E0  18         lwpi  cpu.scrpad2           ; Activate Stevie workspace that got
     6488 AD00     
0566                                                   ; paged-out in tibasic.init
0567               
0568 648A D820  54         movb  @w$ffff,@>8375        ; Reset keycode
     648C 2022     
     648E 8375     
0569                       ;-------------------------------------------------------
0570                       ; Backup scratchpad of TI-Basic session 1
0571                       ;-------------------------------------------------------
0572               tib.run.return.1:
0573 6490 8820  54         c     @tib.session,@w$0001
     6492 A0B4     
     6494 2002     
0574 6496 1606  14         jne   tib.run.return.2      ; Not the current session, check next one.
0575               
0576 6498 06A0  32         bl    @cpym2m
     649A 24EE     
0577 649C 8300                   data >8300,>f100,256  ; Backup TI Basic scratchpad to >f100
     649E F100     
     64A0 0100     
0578                                                   ; @cpu.scrpad.tgt in SAMS bank.
0579 64A2 102C  14         jmp   !                     ; Skip to page-in
0580                       ;-------------------------------------------------------
0581                       ; Backup scratchpad of TI-Basic session 2
0582                       ;-------------------------------------------------------
0583               tib.run.return.2:
0584 64A4 8820  54         c     @tib.session,@w$0002
     64A6 A0B4     
     64A8 2004     
0585 64AA 1606  14         jne   tib.run.return.3      ; Not the current session, check next one.
0586               
0587 64AC 06A0  32         bl    @cpym2m
     64AE 24EE     
0588 64B0 8300                   data >8300,>f200,256  ; Backup TI Basic scratchpad to >f200
     64B2 F200     
     64B4 0100     
0589                                                   ; @cpu.scrpad.tgt in SAMS bank.
0590 64B6 1022  14         jmp   !                     ; Skip to page-in
0591                       ;-------------------------------------------------------
0592                       ; Backup scratchpad of TI-Basic session 3
0593                       ;-------------------------------------------------------
0594               tib.run.return.3:
0595 64B8 8820  54         c     @tib.session,@tibasic.const3
     64BA A0B4     
     64BC 6568     
0596 64BE 1606  14         jne   tib.run.return.4      ; Not the current session, check next one.
0597               
0598 64C0 06A0  32         bl    @cpym2m
     64C2 24EE     
0599 64C4 8300                   data >8300,>f300,256  ; Backup TI Basic scratchpad to >f300
     64C6 F300     
     64C8 0100     
0600                                                   ; @cpu.scrpad.tgt in SAMS bank.
0601 64CA 1018  14         jmp   !                     ; Skip to page-in
0602                       ;-------------------------------------------------------
0603                       ; Backup scratchpad of TI-Basic session 4
0604                       ;-------------------------------------------------------
0605               tib.run.return.4:
0606 64CC 8820  54         c     @tib.session,@w$0004
     64CE A0B4     
     64D0 2006     
0607 64D2 1606  14         jne   tib.run.return.5      ; Not the current session, check next one.
0608               
0609 64D4 06A0  32         bl    @cpym2m
     64D6 24EE     
0610 64D8 8300                   data >8300,>f400,256  ; Backup TI Basic scratchpad to >f400
     64DA F400     
     64DC 0100     
0611                                                   ; @cpu.scrpad.tgt in SAMS bank.
0612 64DE 100E  14         jmp   !                     ; Skip to page-in
0613                       ;-------------------------------------------------------
0614                       ; Backup scratchpad of TI-Basic session 5
0615                       ;-------------------------------------------------------
0616               tib.run.return.5:
0617 64E0 8820  54         c     @tib.session,@tibasic.const5
     64E2 A0B4     
     64E4 656A     
0618 64E6 1606  14         jne   tib.run.return.failed ; Not the current session, abort here
0619               
0620 64E8 06A0  32         bl    @cpym2m
     64EA 24EE     
0621 64EC 8300                   data >8300,>f500,256  ; Backup TI Basic scratchpad to >f500
     64EE F500     
     64F0 0100     
0622                                                   ; @cpu.scrpad.tgt in SAMS bank.
0623 64F2 1004  14         jmp   !                     ; Skip to page-in
0624                       ;-------------------------------------------------------
0625                       ; Asserts failed
0626                       ;-------------------------------------------------------
0627               tib.run.return.failed:
0628 64F4 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     64F6 FFCE     
0629 64F8 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     64FA 2026     
0630                       ;-------------------------------------------------------
0631                       ; Page-in scratchpad memory
0632                       ;-------------------------------------------------------
0633 64FC 06A0  32 !       bl    @cpym2m
     64FE 24EE     
0634 6500 AD00                   data cpu.scrpad2,cpu.scrpad1,256
     6502 8300     
     6504 0100     
0635                                                   ; Restore scratchpad contents
0636               
0637 6506 02E0  18         lwpi  cpu.scrpad1           ; Activate primary scratchpad
     6508 8300     
0638               
0639 650A C0A0  34         mov   @tv.sp2.conf,config   ; Restore the SP2 config register
     650C A22C     
0640               
0641 650E 06A0  32         bl    @mute                 ; Mute sound generators
     6510 280E     
0642                       ;-------------------------------------------------------
0643                       ; Cleanup after return from TI Basic
0644                       ;-------------------------------------------------------
0645 6512 06A0  32         bl    @scroff               ; Turn screen off
     6514 269A     
0646 6516 06A0  32         bl    @cpyv2m
     6518 24CC     
0647 651A 0000                   data >0000,>b000,16384
     651C B000     
     651E 4000     
0648                                                   ; Dump TI Basic 16K VDP memory to ram buffer
0649                                                   ; >b000->efff
0650                       ;-------------------------------------------------------
0651                       ; Restore VDP screen with Stevie content
0652                       ;-------------------------------------------------------
0653               tib.run.return.stevie:
0654 6520 06A0  32         bl    @mem.sams.set.external
     6522 610A     
0655                                                   ; Load SAMS page layout when returning from
0656                                                   ; external program.
0657               
0658 6524 06A0  32         bl    @cpym2v
     6526 249A     
0659 6528 0000                   data >0000,>b000,16384
     652A B000     
     652C 4000     
0660                                                   ; Restore Stevie 16K to VDP from RAM buffer
0661                                                   ; >b000->efff
0662                       ;-------------------------------------------------------
0663                       ; Restore SAMS memory layout for editor buffer and index
0664                       ;-------------------------------------------------------
0665 652E 06A0  32         bl    @mem.sams.set.stevie  ; Setup SAMS memory banks for stevie
     6530 612E     
0666                                                   ; \ For this to work the bank having the
0667                                                   ; | @tv.sams.xxxx variables must already
0668                                                   ; | be active and may not switch to
0669                                                   ; / another bank.
0670                       ;-------------------------------------------------------
0671                       ; Setup F18a 80x30 mode again
0672                       ;-------------------------------------------------------
0673 6532 06A0  32         bl    @f18unl               ; Unlock the F18a
     6534 273E     
0680               
0681 6536 06A0  32         bl    @vidtab               ; Load video mode table into VDP
     6538 230C     
0682 653A 3664                   data stevie.80x30     ; Equate selected video mode table
0683               
0684 653C 06A0  32         bl    @putvr                ; Turn on position based attributes
     653E 2346     
0685 6540 3202                   data >3202            ; F18a VR50 (>32), bit 2
0686               
0687 6542 06A0  32         bl    @putvr                ; Set VDP TAT base address for position
     6544 2346     
0688 6546 0360                   data >0360            ; based attributes (>40 * >60 = >1800)
0689               
0690 6548 04E0  34         clr   @parm1                ; Screen off while reloading color scheme
     654A A006     
0691 654C 04E0  34         clr   @parm2                ; Don't skip colorizing marked lines
     654E A008     
0692 6550 04E0  34         clr   @parm3                ; Colorize all panes
     6552 A00A     
0693               
0694               
0695 6554 06A0  32         bl    @tibasic.buildstr     ; Build session identifier string
     6556 6AFC     
0696               
0697 6558 06A0  32         bl    @pane.action.colorscheme.load
     655A 6AC6     
0698                                                   ; Reload color scheme
0699                                                   ; \ i  @parm1 = Skip screen off if >FFFF
0700                                                   ; | i  @parm2 = Skip colorizing marked lines
0701                                                   ; |             if >FFFF
0702                                                   ; | i  @parm3 = Only colorize CMDB pane
0703                                                   ; /             if >FFFF
0704                       ;------------------------------------------------------
0705                       ; Exit
0706                       ;------------------------------------------------------
0707               tib.run.return.exit:
0708 655C C339  30         mov   *stack+,r12           ; Pop r12
0709 655E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0710 6560 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0711 6562 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0712 6564 C2F9  30         mov   *stack+,r11           ; Pop r11
0713 6566 045B  20         b     *r11                  ; Return
0714               
0715 6568 0003     tibasic.const3  data 3
0716 656A 0005     tibasic.const5  data 5
0717               
0718               tibasic.patterns:
0719 656C 007E             byte  >00,>7E,>E7,>C7,>E7,>E7,>C3,>7E ; 1
     656E E7C7     
     6570 E7E7     
     6572 C37E     
0720 6574 007E             byte  >00,>7E,>C3,>F3,>C3,>CF,>C3,>7E ; 2
     6576 C3F3     
     6578 C3CF     
     657A C37E     
0721 657C 007E             byte  >00,>7E,>C3,>F3,>C3,>F3,>C3,>7E ; 3
     657E C3F3     
     6580 C3F3     
     6582 C37E     
0722 6584 007E             byte  >00,>7E,>D3,>D3,>C3,>F3,>F3,>7E ; 4
     6586 D3D3     
     6588 C3F3     
     658A F37E     
0723 658C 007E             byte  >00,>7E,>C3,>CF,>C3,>F3,>C3,>7E ; 5
     658E C3CF     
     6590 C3F3     
     6592 C37E     
                   < stevie_b7.asm.16732
0067                       ;-----------------------------------------------------------------------
0068                       ; TI Basic program uncruncher
0069                       ;-----------------------------------------------------------------------
0070                       copy  "tib.uncrunch.helper.asm"  ; Helper functions for uncrunching
     **** ****     > tib.uncrunch.helper.asm
0001               * FILE......: tib.uncrunch.helper asm
0002               * Purpose...: Helper functions used for uncrunching
0003               
0004               
0005               ***************************************************************
0006               * _v2sams
0007               * Convert VDP address to SAMS page equivalent and get SAMS page
0008               ***************************************************************
0009               * bl   _v2sams
0010               *--------------------------------------------------------------
0011               * INPUT
0012               * tmp0 = VRAM address in range >0000 - >3fff
0013               *
0014               * OUTPUT
0015               * @tib.var3 = SAMS page ID mapped to VRAM address
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0, tmp1
0019               *--------------------------------------------------------------
0020               * Remarks
0021               * Converts the VDP address to index into SAMS page layout table
0022               * mem.sams.layout.basic(X) and get SAMS page.
0023               *
0024               * Index offset in SAMS page layout table:
0025               * VRAM 0000-0fff = 6   \
0026               * VRAM 1000-1fff = 8   |  Offset of slots with SAMS pages having
0027               * VRAM 2000-2fff = 10  |  the 16K VDP dump of TI basic session.
0028               * VRAM 3000-3fff = 12  /
0029               ********|*****|*********************|**************************
0030               _v2sams:
0031 6594 0649  14         dect  stack
0032 6596 C64B  30         mov   r11,*stack            ; Save return address
0033 6598 0649  14         dect  stack
0034 659A C644  30         mov   tmp0,*stack           ; Push tmp0
0035 659C 0649  14         dect  stack
0036 659E C645  30         mov   tmp1,*stack           ; Push tmp1
0037                       ;------------------------------------------------------
0038                       ; Calculate index in SAMS page table
0039                       ;------------------------------------------------------
0040 65A0 0244  22         andi  tmp0,>f000            ; Only keep high-nibble of MSB
     65A2 F000     
0041               
0042 65A4 09B4  56         srl   tmp0,11               ; Move high-nibble to LSB and multiply by 2
0043 65A6 A120  34         a     @tib.stab.ptr,tmp0    ; Add pointer base address
     65A8 A0C2     
0044               
0045                       ;
0046                       ; In the SAMS page layout table of the TI Basic session, the 16K VDP
0047                       ; memory dump page starts at the 4th word. So need to add fixed offset.
0048                       ;
0049 65AA 0224  22         ai    tmp0,6                ; Add fixed offset
     65AC 0006     
0050 65AE C114  26         mov   *tmp0,tmp0            ; Get SAMS page number
0051                       ;------------------------------------------------------
0052                       ; Check if SAMS page needs to be switched
0053                       ;------------------------------------------------------
0054 65B0 8804  38         c     tmp0,@tib.var3        ; SAMS page has changed?
     65B2 A0F0     
0055 65B4 1307  14         jeq   _v2sams.exit          ; No, exit early
0056               
0057 65B6 C804  38         mov   tmp0,@tib.var3        ; Set new SAMS page
     65B8 A0F0     
0058 65BA 0984  56         srl   tmp0,8                ; MSB to LSB
0059 65BC 0205  20         li    tmp1,>f000            ; Memory address to map to
     65BE F000     
0060               
0061 65C0 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     65C2 258A     
0062                                                   ; \ i  tmp0  = SAMS page number
0063                                                   ; / i  tmp1  = Memory map address
0064                       ;------------------------------------------------------
0065                       ; Exit
0066                       ;------------------------------------------------------
0067               _v2sams.exit:
0068 65C4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0069 65C6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0070 65C8 C2F9  30         mov   *stack+,r11           ; Pop r11
0071 65CA 045B  20         b     *r11                  ; Return
                   < stevie_b7.asm.16732
0071                       copy  "tib.uncrunch.asm"         ; Uncrunch TI Basic program
     **** ****     > tib.uncrunch.asm
0001               * FILE......: tib.uncrunch.prep.asm
0002               * Purpose...: Uncrunch TI Basic program to editor buffer
0003               
0004               
0005               ***************************************************************
0006               * tib.uncrunch
0007               * Uncrunch TI Basic program to editor buffer
0008               ***************************************************************
0009               * bl   @tib.uncrunch
0010               *--------------------------------------------------------------
0011               * INPUT
0012               * @parm1 = TI Basic session to uncrunch (1-5)
0013               *
0014               * OUTPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0, tmp1, tmp2, tmp3, tmp4
0019               ********|*****|*********************|**************************
0020               tib.uncrunch:
0021 65CC 0649  14         dect  stack
0022 65CE C64B  30         mov   r11,*stack            ; Save return address
0023 65D0 0649  14         dect  stack
0024 65D2 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 65D4 0649  14         dect  stack
0026 65D6 C645  30         mov   tmp1,*stack           ; Push tmp1
0027                       ;------------------------------------------------------
0028                       ; Set indicator
0029                       ;------------------------------------------------------
0030 65D8 0649  14         dect  stack
0031 65DA C660  46         mov   @parm1,*stack         ; Push @parm1
     65DC A006     
0032               
0033               
0034 65DE 06A0  32         bl    @fm.newfile
     65E0 6AEA     
0035               
0036 65E2 C820  54         mov   @tv.busycolor,@parm1  ; Get busy color
     65E4 A21C     
     65E6 A006     
0037 65E8 06A0  32         bl    @pane.action.colorscheme.statlines
     65EA 6AD8     
0038                                                   ; Set color combination for status line
0039                                                   ; \ i  @parm1 = Color combination
0040                                                   ; /
0041               
0042 65EC C839  50         mov   *stack+,@parm1        ; Pop @parm1
     65EE A006     
0043               
0044 65F0 06A0  32         bl    @hchar
     65F2 27E6     
0045 65F4 1700                   byte pane.botrow,0,32,55
     65F6 2037     
0046 65F8 FFFF                   data eol              ; Remove shortcuts
0047               
0048 65FA 06A0  32         bl    @putat
     65FC 2456     
0049 65FE 1700                   byte pane.botrow,0
0050 6600 3864                   data txt.uncrunching  ; Show expansion message
0051                       ;------------------------------------------------------
0052                       ; Prepare for uncrunching
0053                       ;------------------------------------------------------
0054 6602 06A0  32         bl    @tib.uncrunch.prepare ; Prepare for uncrunching TI Basic program
     6604 663E     
0055                                                   ; \ i  @parm1 = TI Basic session to uncrunch
0056                                                   ; /
0057                       ;------------------------------------------------------
0058                       ; Uncrunch TI Basic program
0059                       ;------------------------------------------------------
0060 6606 06A0  32         bl    @tib.uncrunch.prg     ; Uncrunch TI Basic program
     6608 66E0     
0061                       ;------------------------------------------------------
0062                       ; Prepare for exit
0063                       ;------------------------------------------------------
0064 660A C120  34         mov   @tv.sams.f000,tmp0    ; Get SAMS page number
     660C A20E     
0065 660E 0205  20         li    tmp1,>f000            ; Map SAMS page to >f000-ffff
     6610 F000     
0066               
0067 6612 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6614 258A     
0068                                                   ; \ i  tmp0  = SAMS page number
0069                                                   ; / i  tmp1  = Memory map address
0070                       ;------------------------------------------------------
0071                       ; Close dialog and refresh frame buffer
0072                       ;------------------------------------------------------
0073 6616 06A0  32         bl    @cmdb.dialog.close    ; Close dialog
     6618 6AA2     
0074               
0075 661A 04E0  34         clr   @parm1                ; Goto line 1
     661C A006     
0076               
0077 661E 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     6620 6AB4     
0078                                                   ; | i  @parm1 = Line to start with
0079                                                   ; /             (becomes @fb.topline)
0080               
0081 6622 04E0  34         clr   @fb.row               ; Frame buffer line 0
     6624 A306     
0082 6626 04E0  34         clr   @fb.column            ; Frame buffer column 0
     6628 A30C     
0083 662A 04E0  34         clr   @wyx                  ; Position VDP cursor
     662C 832A     
0084 662E 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6630 3090     
0085               
0086 6632 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     6634 35DA     
0087                                                   ; | i  @fb.row        = Row in frame buffer
0088                                                   ; / o  @fb.row.length = Length of row
0089                       ;------------------------------------------------------
0090                       ; Exit
0091                       ;------------------------------------------------------
0092               tib.uncrunch.exit:
0093 6636 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0094 6638 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0095 663A C2F9  30         mov   *stack+,r11           ; Pop r11
0096 663C 045B  20         b     *r11                  ; Return
                   < stevie_b7.asm.16732
0072                       copy  "tib.uncrunch.prep.asm"    ; Prepare for uncrunching
     **** ****     > tib.uncrunch.prep.asm
0001               * FILE......: tib.uncrunch.prep.asm
0002               * Purpose...: Uncrunch TI Basic program to editor buffer
0003               
0004               
0005               ***************************************************************
0006               * tib.uncrunch.prepare
0007               * Prepare for uncrunching TI-Basic program
0008               ***************************************************************
0009               * bl   @tib.uncrunch.prepare
0010               *--------------------------------------------------------------
0011               * INPUT
0012               * @parm1 = TI Basic session to uncrunch (1-5)
0013               *
0014               * OUTPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0
0019               *--------------------------------------------------------------
0020               * Remarks
0021               *
0022               * Pointers:
0023               * @tib.scrpad.ptr = Scratchpad address in SAMS page >ff
0024               * @tib.stab.ptr   = SAMS page layout table of TI Basic session
0025               *
0026               * Pointers to tables in VRAM:
0027               * @tib.lnt.top.ptr  = Top of line number table
0028               * @tib.lnt.bot.ptr  = Bottom of line number table
0029               * @tib.symt.top.ptr = Top of symbol table
0030               * @tib.symt.bot.ptr = Bottom of symbol table
0031               * @tib.strs.top.ptr = Top of string space
0032               * @tib.strs.bot.ptr = Bottom of string space
0033               *
0034               * Variables
0035               * @tib.var1  = TI Basic session
0036               * @tib.var2  = Address of SAMS page layout table entry mapped to VRAM address
0037               * @tib.var3  = SAMS page ID mapped to VRAM address
0038               * @tib.lines = Number of lines in TI Basic program
0039               ********|*****|*********************|**************************
0040               tib.uncrunch.prepare:
0041 663E 0649  14         dect  stack
0042 6640 C64B  30         mov   r11,*stack            ; Save return address
0043 6642 0649  14         dect  stack
0044 6644 C644  30         mov   tmp0,*stack           ; Push tmp0
0045                       ;------------------------------------------------------
0046                       ; Initialisation
0047                       ;------------------------------------------------------
0048 6646 04E0  34         clr   @tib.var1             ;
     6648 A0EC     
0049 664A 04E0  34         clr   @tib.var2             ; Clear temporary variables
     664C A0EE     
0050 664E 04E0  34         clr   @tib.var3             ;
     6650 A0F0     
0051 6652 04E0  34         clr   @tib.var4             ;
     6654 A0F2     
0052 6656 04E0  34         clr   @tib.var5             ;
     6658 A0F4     
0053                       ;------------------------------------------------------
0054                       ; (1) Assert on TI basic session
0055                       ;------------------------------------------------------
0056 665A C120  34         mov   @parm1,tmp0           ; Get session to uncrunch
     665C A006     
0057 665E C804  38         mov   tmp0,@tib.var1        ; Make copy
     6660 A0EC     
0058               
0059 6662 0284  22         ci    tmp0,1                ; \
     6664 0001     
0060 6666 1103  14         jlt   !                     ; | Skip to (2) if valid
0061 6668 0284  22         ci    tmp0,5                ; | session ID.
     666A 0005     
0062 666C 1204  14         jle   tib.uncrunch.prepare.2; /
0063                       ;------------------------------------------------------
0064                       ; Assert failed
0065                       ;------------------------------------------------------
0066 666E C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     6670 FFCE     
0067 6672 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6674 2026     
0068                       ;------------------------------------------------------
0069                       ; (2) Get scratchpad of TI Basic session
0070                       ;------------------------------------------------------
0071               tib.uncrunch.prepare.2:
0072 6676 06A0  32         bl    @sams.page.set        ; Set SAMS page
     6678 2586     
0073 667A 00FF                   data >00ff,>f000      ; \ i  p1  = SAMS page number
     667C F000     
0074                                                   ; / i  p2  = Memory map address
0075               
0076                       ; TI Basic session 1 scratchpad >f100
0077                       ; TI Basic session 2 scratchpad >f200
0078                       ; TI Basic session 3 scratchpad >f300
0079                       ; TI Basic session 4 scratchpad >f400
0080                       ; TI Basic session 5 scratchpad >f500
0081               
0082 667E C120  34         mov   @tib.var1,tmp0        ; Get TI Basic session
     6680 A0EC     
0083 6682 0A84  56         sla   tmp0,8                ; Get scratchpad offset (>100->500)
0084 6684 0224  22         ai    tmp0,>f000            ; Add base address
     6686 F000     
0085 6688 C804  38         mov   tmp0,@tib.scrpad.ptr  ; Store pointer to scratchpad in SAMS
     668A A0C4     
0086                       ;------------------------------------------------------
0087                       ; (3) Get relevant pointers stored in scratchpad
0088                       ;------------------------------------------------------
0089 668C C824  54         mov   @>18(tmp0),@tib.strs.top.ptr
     668E 0018     
     6690 A0CE     
0090                                                   ; @>8318 Pointer to top of string space
0091                                                   ; in VRAM
0092               
0093 6692 C824  54         mov   @>1a(tmp0),@tib.strs.bot.ptr
     6694 001A     
     6696 A0D0     
0094                                                   ; @>831a Pointer to bottom of string space
0095                                                   ; in VRAM
0096               
0097 6698 C824  54         mov   @>30(tmp0),@tib.lnt.bot.ptr
     669A 0030     
     669C A0C8     
0098                                                   ; @>8330 Pointer to bottom of line number
0099                                                   ; table in VRAM
0100               
0101 669E C824  54         mov   @>32(tmp0),@tib.lnt.top.ptr
     66A0 0032     
     66A2 A0C6     
0102                                                   ; @>8332 Pointer to top of line number
0103                                                   ; table in VRAM
0104               
0105 66A4 C820  54         mov   @tib.lnt.bot.ptr,@tib.symt.top.ptr
     66A6 A0C8     
     66A8 A0CA     
0106 66AA 0660  34         dect  @tib.symt.top.ptr     ; Pointer to top of symbol table in VRAM.
     66AC A0CA     
0107                                                   ; Table top is just below the bottom of
0108                                                   ; the line number table.
0109               
0110 66AE C824  54         mov   @>3e(tmp0),@tib.symt.bot.ptr
     66B0 003E     
     66B2 A0CC     
0111                                                   ; @>833e Pointer to bottom of symbol table
0112                                                   ; in VRAM
0113                       ;------------------------------------------------------
0114                       ; (4) Calculate number of lines in TI Basic program
0115                       ;------------------------------------------------------
0116 66B4 C120  34         mov   @tib.lnt.top.ptr,tmp0 ; \ Size of line number table entry: 4 bytes
     66B6 A0C6     
0117 66B8 6120  34         s     @tib.lnt.bot.ptr,tmp0 ; /
     66BA A0C8     
0118 66BC 1305  14         jeq   tib.uncrunch.prepare.np
0119               
0120 66BE 0584  14         inc   tmp0                  ; One time offset
0121 66C0 0924  56         srl   tmp0,2                ; tmp0=tmp0/4
0122 66C2 C804  38         mov   tmp0,@tib.lines       ; Save lines
     66C4 A0D2     
0123 66C6 1002  14         jmp   tib.uncrunch.prepare.5
0124                       ;------------------------------------------------------
0125                       ; No program present
0126                       ;------------------------------------------------------
0127               tib.uncrunch.prepare.np:
0128 66C8 04E0  34         clr   @tib.lines            ; No program
     66CA A0D2     
0129                       ;------------------------------------------------------
0130                       ; (5) Get pointer to SAMS page table
0131                       ;------------------------------------------------------
0132               tib.uncrunch.prepare.5:
0133                       ; The data tables of the 5 TI basic sessions form a
0134                       ; uniform region, we calculate the index of the 1st word in the
0135                       ; specified session.
0136 66CC C120  34         mov   @tib.var1,tmp0        ; Get TI Basic session
     66CE A0EC     
0137               
0138 66D0 0A44  56         sla   tmp0,4                ; \ Get index of first word in SAMS page
0139                                                   ; | layout (of following TI Basic session)
0140                                                   ; /
0141               
0142 66D2 0224  22         ai    tmp0,mem.sams.layout.basic - 16
     66D4 6B40     
0143                                                   ; Add base address for specified session
0144               
0145 66D6 C804  38         mov   tmp0,@tib.stab.ptr    ; Save pointer
     66D8 A0C2     
0146                       ;------------------------------------------------------
0147                       ; Exit
0148                       ;------------------------------------------------------
0149               tib.uncrunch.prepare.exit:
0150 66DA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0151 66DC C2F9  30         mov   *stack+,r11           ; Pop r11
0152 66DE 045B  20         b     *r11                  ; Return
                   < stevie_b7.asm.16732
0073                       copy  "tib.uncrunch.prg.asm"     ; Uncrunch tokenized program code
     **** ****     > tib.uncrunch.prg.asm
0001               * FILE......: tib.uncrunch.prg.asm
0002               * Purpose...: Uncrunch tokenized program code
0003               
0004               ***************************************************************
0005               * tib.uncrunch.prg
0006               * Uncrunch tokenized program code
0007               ***************************************************************
0008               * bl   @tibasic.uncrunch.prg
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @parm1 = TI Basic session to uncrunch (1-5)
0012               *
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0, tmp1, tmp2, tmp3, tmp4
0018               *--------------------------------------------------------------
0019               * Remarks
0020               *
0021               * Pointers:
0022               * @tib.scrpad.ptr = Scratchpad address in SAMS page >ff
0023               * @tib.stab.ptr   = SAMS page layout table of TI Basic session
0024               *
0025               * Pointers to tables in VRAM:
0026               * @tib.lnt.top.ptr  = Top of line number table
0027               * @tib.lnt.bot.ptr  = Bottom of line number table
0028               * @tib.symt.top.ptr = Top of symbol table
0029               * @tib.symt.bot.ptr = Bottom of symbol table
0030               * @tib.strs.top.ptr = Top of string space
0031               * @tib.strs.bot.ptr = Bottom of string space
0032               *
0033               * Variables
0034               * @tib.var1  = TI Basic Session
0035               * @tib.var2  = Saved VRAM address
0036               * @tib.var3  = SAMS page ID mapped to VRAM address
0037               * @tib.var4  = Line number in program
0038               * @tib.var5  = Pointer to statement (VRAM)
0039               * @tib.var6  = Current position (addr) in uncrunch area
0040               * @tib.var7  = **free**
0041               * @tib.var8  = Basic statement length in bytes
0042               * @tib.var9  = Target line number in editor buffer
0043               * @tib.lines = Number of lines in TI Basic program
0044               *
0045               * Register usage
0046               * tmp0  = (Mapped) address of line number or statement in VDP
0047               * tmp1  = Token to process
0048               * tmp2  = Statement length
0049               * tmp3  = Lines to process counter
0050               *
0051               * tmp0,tmp1,tmp2 also used as work registers at times
0052               ********|*****|*********************|**************************
0053               tib.uncrunch.prg:
0054 66E0 0649  14         dect  stack
0055 66E2 C64B  30         mov   r11,*stack            ; Save return address
0056 66E4 0649  14         dect  stack
0057 66E6 C644  30         mov   tmp0,*stack           ; Push tmp0
0058 66E8 0649  14         dect  stack
0059 66EA C645  30         mov   tmp1,*stack           ; Push tmp1
0060 66EC 0649  14         dect  stack
0061 66EE C646  30         mov   tmp2,*stack           ; Push tmp2
0062 66F0 0649  14         dect  stack
0063 66F2 C647  30         mov   tmp3,*stack           ; Push tmp3
0064                       ;------------------------------------------------------
0065                       ; Exit early if no TI Basic program
0066                       ;------------------------------------------------------
0067 66F4 8820  54         c     @tib.lnt.top.ptr,@tib.lnt.bot.ptr
     66F6 A0C6     
     66F8 A0C8     
0068                                                   ; Line number table is empty?
0069 66FA 1602  14         jne   !                     ; No, keep on processing
0070 66FC 0460  28         b     @tib.uncrunch.prg.exit
     66FE 682A     
0071                       ;------------------------------------------------------
0072                       ; Initialisation
0073                       ;------------------------------------------------------
0074 6700 C120  34 !       mov   @tib.lnt.top.ptr,tmp0 ; Get top of line number table
     6702 A0C6     
0075 6704 0224  22         ai    tmp0,-3               ; One time adjustment
     6706 FFFD     
0076 6708 C804  38         mov   tmp0,@tib.var2        ; Save VRAM address
     670A A0EE     
0077               
0078 670C 04E0  34         clr   @tib.var9             ; 1st line in editor buffer
     670E A0FC     
0079 6710 C1E0  34         mov   @tib.lines,tmp3       ; Set lines to process counter
     6712 A0D2     
0080                       ;------------------------------------------------------
0081                       ; Loop over program listing
0082                       ;------------------------------------------------------
0083               tib.uncrunch.prg.lnt.loop:
0084 6714 C120  34         mov   @tib.var2,tmp0        ; Get VRAM address
     6716 A0EE     
0085               
0086 6718 0124             data  c99_dbg_tmp0          ; \ Print vram address in tmp0 on classic99
0087 671A 1001             data  >1001                 ; | debugger console.
0088 671C 6836             data  data.printf.vram.lnt  ; /
0089               
0090 671E 06A0  32         bl    @_v2sams              ; Get SAMS page mapped to VRAM address
     6720 6594     
0091                                                   ; \ i  tmp0 = VRAM address
0092                                                   ; |
0093                                                   ; | o  @tib.var3 = SAMS page ID mapped to
0094                                                   ; |    VRAM address.
0095                                                   ; /
0096                       ;------------------------------------------------------
0097                       ; 1. Get line number
0098                       ;------------------------------------------------------
0099 6722 0264  22         ori   tmp0,>f000            ; \ Use mapped address in >f000->ffff window
     6724 F000     
0100                                                   ; | instead of VRAM address.
0101                                                   ; |
0102                                                   ; / Example: >f7b3 maps to >37b3.
0103               
0104 6726 D834  48         movb  *tmp0+,@tib.var4      ; Line number MSB
     6728 A0F2     
0105 672A D834  48         movb  *tmp0+,@tib.var4+1    ; Line number LSB
     672C A0F3     
0106               
0107                       ;------------------------------------------------------
0108                       ; 1a. Get Pointer to statement (VRAM)
0109                       ;------------------------------------------------------
0110 672E D834  48         movb  *tmp0+,@tib.var5      ; Pointer to statement MSB
     6730 A0F4     
0111 6732 D834  48         movb  *tmp0+,@tib.var5+1    ; Pointer to statement LSB
     6734 A0F5     
0112               
0113 6736 A820  54         a     @w$0004,@tib.var2     ; Sync VRAM address with mapped address in
     6738 2006     
     673A A0EE     
0114                                                   ; tmp0 for steps 1 and 1a.
0115                       ;------------------------------------------------------
0116                       ; 2. Put line number in uncrunch area
0117                       ;------------------------------------------------------
0118 673C 0649  14         dect  stack
0119 673E C644  30         mov   tmp0,*stack           ; Push tmp0
0120 6740 0649  14         dect  stack
0121 6742 C645  30         mov   tmp1,*stack           ; Push tmp1
0122 6744 0649  14         dect  stack
0123 6746 C646  30         mov   tmp2,*stack           ; Push tmp2
0124 6748 0649  14         dect  stack
0125 674A C647  30         mov   tmp3,*stack           ; Push tmp3
0126               
0127 674C 06A0  32         bl    @mknum                ; Convert unsigned number to string
     674E 29BA     
0128 6750 A0F2                   data tib.var4         ; \ i  p1    = Source
0129 6752 A100                   data rambuf           ; | i  p2    = Destination
0130 6754 30                     byte 48               ; | i  p3MSB = ASCII offset
0131 6755   20                   byte 32               ; / i  p3LSB = Padding character
0132               
0133 6756 04E0  34         clr   @fb.uncrunch.area     ; \
     6758 D960     
0134 675A 04E0  34         clr   @fb.uncrunch.area+2   ; | Clear length-byte and line number space
     675C D962     
0135 675E 04E0  34         clr   @fb.uncrunch.area+4   ; /
     6760 D964     
0136               
0137 6762 06A0  32         bl    @at
     6764 26DA     
0138 6766 171C                   byte pane.botrow,28   ; Position cursor
0139               
0140 6768 06A0  32         bl    @trimnum              ; Trim line number and move to uncrunch area
     676A 2A12     
0141 676C A100                   data rambuf           ; \ i  p1 = Source
0142 676E D960                   data fb.uncrunch.area ; | i  p2 = Destination
0143 6770 0020                   data 32               ; / i  p3 = Padding character to scan
0144               
0145 6772 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0146 6774 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0147 6776 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0148 6778 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0149                       ;------------------------------------------------------
0150                       ; 2a. Put space character following line number
0151                       ;------------------------------------------------------
0152               
0153                       ; Temporary re-use of tmp0 as work register for operations.
0154               
0155 677A D120  34         movb  @fb.uncrunch.area,tmp0
     677C D960     
0156                                                   ; Get length of trimmed number into MSB
0157 677E 0984  56         srl   tmp0,8                ; Move to LSB
0158 6780 0224  22         ai    tmp0,fb.uncrunch.area+1
     6782 D961     
0159                                                   ; Add base address and length byte
0160               
0161 6784 0205  20         li    tmp1,>2000            ; \ Put white space character (ASCII 32)
     6786 2000     
0162 6788 DD05  32         movb  tmp1,*tmp0+           ; / following line number.
0163 678A C804  38         mov   tmp0,@tib.var6        ; Save position in uncrunch area
     678C A0F6     
0164               
0165 678E B820  54         ab    @w$0100,@fb.uncrunch.area
     6790 2012     
     6792 D960     
0166                                                   ; Increase length-byte in uncrunch area
0167                       ;------------------------------------------------------
0168                       ; 3. Prepare for uncrunching program statement
0169                       ;------------------------------------------------------
0170 6794 C120  34         mov   @tib.var5,tmp0        ; Get pointer to statement
     6796 A0F4     
0171 6798 0604  14         dec   tmp0                  ; Goto statement length prefix
0172               
0173 679A 0124             data  c99_dbg_tmp0          ; \ Print vram address in tmp0 on classic99
0174 679C 1001             data  >1001                 ; | debugger console.
0175 679E 6846             data  data.printf.vram.stmt ; /
0176               
0177 67A0 06A0  32         bl    @_v2sams              ; Get SAMS page mapped to VRAM address
     67A2 6594     
0178                                                   ; \ i  tmp0 = VRAM address
0179                                                   ; |
0180                                                   ; | o  @tib.var3 = SAMS page ID mapped to
0181                                                   ; |    VRAM address.
0182                                                   ; /
0183               
0184 67A4 0264  22         ori   tmp0,>f000            ; \ Use mapped address in >f000->ffff window
     67A6 F000     
0185                                                   ; | instead of VRAM address.
0186                                                   ; |
0187                                                   ; / Example: >f7b3 maps to >37b3.
0188               
0189               
0190 67A8 C160  34         mov   @tib.var4,tmp1
     67AA A0F2     
0191 67AC 0125             data  c99_dbg_tmp1          ; \ Print line number in tmp1 on classic99
0192 67AE 1001             data  >1001                 ; | debugger console.
0193 67B0 6856             data  data.printf.vram.lnum ; /
0194               
0195               
0196 67B2 D174  28         movb  *tmp0+,tmp1           ; \ Get statement length in bytes
0197 67B4 0985  56         srl   tmp1,8                ; / MSB to LSB
0198               
0199 67B6 C805  38         mov   tmp1,@tib.var8        ; Save statement length
     67B8 A0FA     
0200 67BA C185  18         mov   tmp1,tmp2             ; Set statement length in work register
0201                       ;------------------------------------------------------
0202                       ; 4. Uncrunch program statement to uncrunch area
0203                       ;------------------------------------------------------
0204               tib.uncrunch.prg.statement.loop:
0205 67BC D154  26         movb  *tmp0,tmp1            ; Get token into MSB
0206 67BE 0985  56         srl   tmp1,8                ; Move token to LSB
0207 67C0 1320  14         jeq   tib.uncrnch.prg.copy.statement
0208                                                   ; Skip to (5) if termination token >00
0209               
0210 67C2 0285  22         ci    tmp1,>80              ; Is a valid token?
     67C4 0080     
0211 67C6 110D  14         jlt   tib.uncrunch.prg.statement.loop.nontoken
0212                                                   ; Skip decode for non-token
0213               
0214 67C8 C804  38         mov   tmp0,@parm2           ; Mapped position in crunched statement
     67CA A008     
0215 67CC C805  38         mov   tmp1,@parm1           ; Token to process
     67CE A006     
0216               
0217 67D0 06A0  32         bl    @tib.uncrunch.token   ; Decode statement token to uncrunch area
     67D2 6866     
0218                                                   ; \ i  @parm1 = Token to process
0219                                                   ; |
0220                                                   ; | i  @parm2 = Mapped position (addr) in
0221                                                   ; |    crunched statement.
0222                                                   ; |
0223                                                   ; | o  @outparm1 = New position (addr) in
0224                                                   ; |    crunched statement.
0225                                                   ; |
0226                                                   ; | o  @outparm2 = Bytes processed in
0227                                                   ; |    crunched statement.
0228                                                   ; |
0229                                                   ; | o  @tib.var6 = Position (addr) in
0230                                                   ; /    uncrunch area.
0231               
0232 67D4 C120  34         mov   @outparm1,tmp0        ; Forward in crunched statement
     67D6 A016     
0233               
0234 67D8 61A0  34         s     @outparm2,tmp2        ; Update statement length
     67DA A018     
0235 67DC 15EF  14         jgt   tib.uncrunch.prg.statement.loop
0236                                                   ; Process next token(s) unless done
0237               
0238 67DE 1311  14         jeq   tib.uncrnch.prg.copy.statement
0239                                                   ; Continue with (5)
0240               
0241 67E0 110C  14         jlt   tib.uncrnch.prg.statement.loop.panic
0242                                                   ; Assert
0243                       ;------------------------------------------------------
0244                       ; 4a. Non-token without decode
0245                       ;------------------------------------------------------
0246               tib.uncrunch.prg.statement.loop.nontoken:
0247 67E2 C160  34         mov   @tib.var6,tmp1        ; Get position (addr) in uncrunch area
     67E4 A0F6     
0248 67E6 DD74  42         movb  *tmp0+,*tmp1+         ; Copy non-token to uncrunch area
0249               
0250 67E8 C805  38         mov   tmp1,@tib.var6        ; Save position in uncrunch area
     67EA A0F6     
0251 67EC B820  54         ab    @w$0100,@fb.uncrunch.area
     67EE 2012     
     67F0 D960     
0252                                                   ; Increase length-byte in uncrunch area
0253               
0254 67F2 0606  14         dec   tmp2                  ; update statement length
0255 67F4 1102  14         jlt   tib.uncrnch.prg.statement.loop.panic
0256                                                   ; Assert
0257               
0258 67F6 15E2  14         jgt   tib.uncrunch.prg.statement.loop
0259                                                   ; Process next token(s) unless done
0260 67F8 1304  14         jeq   tib.uncrnch.prg.copy.statement
0261                       ;------------------------------------------------------
0262                       ; CPU crash
0263                       ;------------------------------------------------------
0264               tib.uncrnch.prg.statement.loop.panic:
0265 67FA C80B  38         mov   r11,@>ffce            ; \ Save caller address
     67FC FFCE     
0266 67FE 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6800 2026     
0267                       ;------------------------------------------------------
0268                       ; 5. Copy uncrunched statement to editor buffer
0269                       ;------------------------------------------------------
0270               tib.uncrnch.prg.copy.statement:
0271 6802 C820  54         mov   @tib.var9,@parm1      ; Get editor buffer line number to store
     6804 A0FC     
     6806 A006     
0272                                                   ; statement in.
0273               
0274 6808 06A0  32         bl    @tib.uncrunch.line.pack
     680A 6A08     
0275                                                   ; Pack uncrunched line to editor buffer
0276                                                   ; \ i  @fb.uncrunch.area = Pointer to
0277                                                   ; |    buffer having uncrushed statement
0278                                                   ; |
0279                                                   ; | i  @parm1 = Line number in editor buffer
0280                                                   ; /
0281               
0282 680C 05A0  34         inc   @tib.var9             ; Next line
     680E A0FC     
0283 6810 05A0  34         inc   @edb.lines            ; Update Line counter
     6812 A504     
0284                       ;------------------------------------------------------
0285                       ; 6. Next entry in line number table
0286                       ;------------------------------------------------------
0287 6814 0607  14         dec   tmp3                  ; Last line processed?
0288 6816 1305  14         jeq   tib.uncrunch.prg.done ; yes, prepare for exit
0289               
0290 6818 6820  54         s     @w$0008,@tib.var2     ; Next entry in VRAM line number table
     681A 2008     
     681C A0EE     
0291 681E 0460  28         b     @tib.uncrunch.prg.lnt.loop
     6820 6714     
0292                       ;------------------------------------------------------
0293                       ; 7. Finished processing program
0294                       ;------------------------------------------------------
0295               tib.uncrunch.prg.done:
0296 6822 0720  34         seto  @fb.dirty             ; Refresh screen buffer
     6824 A316     
0297 6826 0720  34         seto  @edb.dirty            ; Update screen with editor buffer when done
     6828 A506     
0298                       ;------------------------------------------------------
0299                       ; Exit
0300                       ;------------------------------------------------------
0301               tib.uncrunch.prg.exit:
0302 682A C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0303 682C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0304 682E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0305 6830 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0306 6832 C2F9  30         mov   *stack+,r11           ; Pop r11
0307 6834 045B  20         b     *r11                  ; Return
0308               
0309               
0310               data.printf.vram.lnt:
0311 6836 5652            text   'VRAM LNT >%04X'
     6838 414D     
     683A 204C     
     683C 4E54     
     683E 203E     
     6840 2530     
     6842 3458     
0312 6844 00              byte   0
0313                      even
0314               
0315               data.printf.vram.stmt:
0316 6846 5652            text   'VRAM STM >%04X'
     6848 414D     
     684A 2053     
     684C 544D     
     684E 203E     
     6850 2530     
     6852 3458     
0317 6854 00              byte   0
0318                      even
0319               
0320               data.printf.vram.lnum:
0321 6856 4261            text   'Basic line: %u'
     6858 7369     
     685A 6320     
     685C 6C69     
     685E 6E65     
     6860 3A20     
     6862 2575     
0322 6864 00              byte   0
                   < stevie_b7.asm.16732
0074                       copy  "tib.uncrunch.token.asm"   ; Decode statement token
     **** ****     > tib.uncrunch.token.asm
0001               * FILE......: tib.uncrunch.token.asm
0002               * Purpose...: Decode token to uncrunch area
0003               
0004               
0005               ***************************************************************
0006               * tib.uncrunch.token
0007               * Decode token to uncrunch area
0008               ***************************************************************
0009               * bl   @tib.uncrunch.token
0010               *--------------------------------------------------------------
0011               * INPUT
0012               * @parm1 = Token to process
0013               * @parm2 = Mapped position (addr) in crunched statement
0014               *
0015               * OUTPUT
0016               * @outparm1  = New position (addr) in crunched statement
0017               * @outparm2  = Input bytes processed in crunched statement
0018               * @tib.var6  = Current position (addr) in uncrunch area
0019               *--------------------------------------------------------------
0020               * Register usage
0021               * tmp0, tmp1, tmp2, tmp3, tmp4
0022               *--------------------------------------------------------------
0023               * Remarks
0024               * For TI Basic statement decode see:
0025               * https://www.unige.ch/medecine/nouspikel/ti99/basic.htm#statements
0026               *
0027               * Using @outparm2 for storing the number of input bytes
0028               * processed in crunched statement
0029               *
0030               * Using @tib.var10 for storing the number of decoded output bytes
0031               * generated in uncrunch area.
0032               *
0033               * Variables
0034               * @tib.var6  = Current position (addr) in uncrunch area
0035               * @tib.var9  = Temporary use
0036               * @tib.var10 = Temporary use
0037               ********|*****|*********************|**************************
0038               tib.uncrunch.token:
0039 6866 0649  14         dect  stack
0040 6868 C64B  30         mov   r11,*stack            ; Save return address
0041 686A 0649  14         dect  stack
0042 686C C644  30         mov   tmp0,*stack           ; Push tmp0
0043 686E 0649  14         dect  stack
0044 6870 C645  30         mov   tmp1,*stack           ; Push tmp1
0045 6872 0649  14         dect  stack
0046 6874 C646  30         mov   tmp2,*stack           ; Push tmp2
0047 6876 0649  14         dect  stack
0048 6878 C647  30         mov   tmp3,*stack           ; Push tmp3
0049 687A 0649  14         dect  stack
0050 687C C648  30         mov   tmp4,*stack           ; Push tmp4
0051 687E 0649  14         dect  stack
0052 6880 C660  46         mov   @tib.var9,*stack      ; Push @tib.var.9
     6882 A0FC     
0053 6884 0649  14         dect  stack
0054 6886 C660  46         mov   @tib.var10,*stack     ; Push @tib.var.10
     6888 A0FE     
0055                       ;------------------------------------------------------
0056                       ; Initialisation
0057                       ;------------------------------------------------------
0058 688A C120  34         mov   @parm1,tmp0           ; Get token
     688C A006     
0059 688E C820  54         mov   @parm2,@outparm1      ; Position (addr) in crunched statement
     6890 A008     
     6892 A016     
0060               
0061 6894 04E0  34         clr   @outparm2             ; Set input bytes processed
     6896 A018     
0062 6898 04E0  34         clr   @tib.var10            ; Set output bytes generated (uncrunch area)
     689A A0FE     
0063                       ;------------------------------------------------------
0064                       ; 1. Decide how to process token
0065                       ;------------------------------------------------------
0066 689C 0284  22         ci    tmp0,>c7              ; Quoted string?
     689E 00C7     
0067 68A0 132A  14         jeq   tib.uncrunch.token.quoted
0068               
0069 68A2 0284  22         ci    tmp0,>c8              ; Unquoted string?
     68A4 00C8     
0070 68A6 134D  14         jeq   tib.uncrunch.token.unquoted
0071               
0072 68A8 0284  22         ci    tmp0,>c9              ; line number?
     68AA 00C9     
0073 68AC 136A  14         jeq   tib.uncrunch.token.linenum
0074                       ;------------------------------------------------------
0075                       ; 2. Decode token range >80 - >ff in lookup table
0076                       ;------------------------------------------------------
0077               tib.uncrunch.token.lookup:
0078 68AE 0224  22         ai    tmp0,->0080           ; Token range >80 - >ff
     68B0 FF80     
0079 68B2 0A14  56         sla   tmp0,1                ; Make it a word offset
0080 68B4 C124  34         mov   @tib.tokenindex(tmp0),tmp0
     68B6 6E34     
0081                                                   ; Get pointer to token definition
0082 68B8 0584  14         inc   tmp0                  ; Skip token identifier
0083               
0084 68BA D1B4  28         movb  *tmp0+,tmp2           ; Get length of decoded keyword
0085 68BC 0986  56         srl   tmp2,8                ; MSB to LSB
0086               
0087 68BE C160  34         mov   @tib.var6,tmp1        ; Get current pos (addr) in uncrunch area
     68C0 A0F6     
0088 68C2 A806  38         a     tmp2,@tib.var6        ; Set current pos (addr) in uncrunch area
     68C4 A0F6     
0089               
0090 68C6 05A0  34         inc   @outparm2             ; Set input bytes processed
     68C8 A018     
0091 68CA C806  38         mov   tmp2,@tib.var10       ; Set output bytes generated (uncrunch area)
     68CC A0FE     
0092               
0093 68CE 06A0  32         bl    @xpym2m               ; Copy keyword to uncrunch area
     68D0 24F4     
0094                                                   ; \ i  tmp0 = Source address
0095                                                   ; | i  tmp1 = Destination address
0096                                                   ; / i  tmp2 = Number of bytes to copy
0097               
0098 68D2 C120  34         mov   @parm1,tmp0           ; Get token again
     68D4 A006     
0099 68D6 0284  22         ci    tmp0,>b2              ; Token range with keyword needing blank?
     68D8 00B2     
0100 68DA 1509  14         jgt   !                     ; No, as of >b3 skip to (2b)
0101                       ;------------------------------------------------------
0102                       ; 2a. Write trailing blank after decoded keyword
0103                       ;------------------------------------------------------
0104 68DC 0204  20         li    tmp0,>2000            ; Blank in MSB
     68DE 2000     
0105 68E0 C160  34         mov   @tib.var6,tmp1        ; Get current pos (addr) in uncrunch area
     68E2 A0F6     
0106 68E4 D554  38         movb  *tmp0,*tmp1           ; Write trailing blank
0107 68E6 05A0  34         inc   @tib.var6             ; Set current pos (addr) in uncrunch area
     68E8 A0F6     
0108 68EA 05A0  34         inc   @tib.var10            ; Set output bytes generated (uncrunch area)
     68EC A0FE     
0109                       ;------------------------------------------------------
0110                       ; 2b. Update variables related to crunched statement
0111                       ;------------------------------------------------------
0112 68EE 05A0  34 !       inc   @outparm1             ; New pos (addr) in crunched statement
     68F0 A016     
0113 68F2 0460  28         b     @tib.uncrunch.token.setlen
     68F4 69E8     
0114                       ;------------------------------------------------------
0115                       ; 3. Special handling >c7: Decode quoted string
0116                       ;------------------------------------------------------
0117               tib.uncrunch.token.quoted:
0118 68F6 0204  20         li    tmp0,>2200            ; ASCII " in LSB
     68F8 2200     
0119 68FA C160  34         mov   @tib.var6,tmp1        ; Get current pos (addr) in uncrunch area
     68FC A0F6     
0120 68FE DD44  32         movb  tmp0,*tmp1+           ; Write 1st double quote
0121               
0122 6900 C120  34         mov   @parm2,tmp0           ; Get position (addr) in crunched statement
     6902 A008     
0123 6904 0584  14         inc   tmp0                  ; Skip token
0124 6906 D1B4  28         movb  *tmp0+,tmp2           ; Get length byte following >C7 token
0125 6908 0986  56         srl   tmp2,8                ; MSB to LSB
0126 690A 130B  14         jeq   tib.uncrunch.token.quoted.quote2
0127                                                   ; Skip to (3c) if empty string
0128                       ;------------------------------------------------------
0129                       ; 3b. Copy string to uncrunch area
0130                       ;------------------------------------------------------
0131 690C 0649  14         dect  stack
0132 690E C644  30         mov   tmp0,*stack           ; Push tmp0
0133 6910 0649  14         dect  stack
0134 6912 C645  30         mov   tmp1,*stack           ; Push tmp1
0135 6914 0649  14         dect  stack
0136 6916 C646  30         mov   tmp2,*stack           ; Push tmp2
0137               
0138 6918 06A0  32         bl    @xpym2m               ; Copy string from crunched statement to
     691A 24F4     
0139                                                   ; uncrunch area.
0140                                                   ; \ i  tmp0 = Source address
0141                                                   ; | i  tmp1 = Destination address
0142                                                   ; / i  tmp2 = Number of bytes to copy
0143               
0144 691C C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0145 691E C179  30         mov   *stack+,tmp1          ; Pop tmp1
0146 6920 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0147                       ;------------------------------------------------------
0148                       ; 3c. Write trailing double quote
0149                       ;------------------------------------------------------
0150               tib.uncrunch.token.quoted.quote2:
0151 6922 0204  20         li    tmp0,>2200            ; " in MSB
     6924 2200     
0152 6926 A146  18         a     tmp2,tmp1             ; Forward in uncrunch area
0153 6928 DD44  32         movb  tmp0,*tmp1+           ; Write 2nd double quote
0154 692A C805  38         mov   tmp1,@tib.var6        ; Set current pos (addr) in uncrunch area
     692C A0F6     
0155                       ;------------------------------------------------------
0156                       ; 3d. Update variables related to crunched statement
0157                       ;------------------------------------------------------
0158 692E C106  18         mov   tmp2,tmp0             ; \ Get num of bytes copied to uncrunch area
0159 6930 05C4  14         inct  tmp0                  ; / Count token byte and length byte
0160 6932 C804  38         mov   tmp0,@outparm2        ; Set input bytes processed
     6934 A018     
0161               
0162 6936 C804  38         mov   tmp0,@tib.var10       ; Set output bytes generated (uncrunch area)
     6938 A0FE     
0163                                                   ; Same number as input bytes processed,
0164                                                   ; because quotes match token & length byte.
0165               
0166 693A A820  54         a     @outparm2,@outparm1   ; New position (addr) in crunched statement
     693C A018     
     693E A016     
0167               
0168 6940 1053  14         jmp   tib.uncrunch.token.setlen
0169                       ;------------------------------------------------------
0170                       ; 4. Special handling >c8: Decode unquoted string
0171                       ;------------------------------------------------------
0172               tib.uncrunch.token.unquoted:
0173 6942 C160  34         mov   @tib.var6,tmp1        ; Get current pos (addr) in uncrunch area
     6944 A0F6     
0174 6946 C120  34         mov   @parm2,tmp0           ; Get position (addr) in crunched statement
     6948 A008     
0175 694A 0584  14         inc   tmp0                  ; Skip token
0176 694C D1B4  28         movb  *tmp0+,tmp2           ; Get length byte following >C8 token
0177 694E 0986  56         srl   tmp2,8                ; MSB to LSB
0178               
0179 6950 0649  14         dect  stack
0180 6952 C644  30         mov   tmp0,*stack           ; Push tmp0
0181 6954 0649  14         dect  stack
0182 6956 C645  30         mov   tmp1,*stack           ; Push tmp1
0183 6958 0649  14         dect  stack
0184 695A C646  30         mov   tmp2,*stack           ; Push tmp2
0185               
0186 695C 06A0  32         bl    @xpym2m               ; Copy string from crunched statement to
     695E 24F4     
0187                                                   ; uncrunch area.
0188                                                   ; \ i  tmp0 = Source address
0189                                                   ; | i  tmp1 = Destination address
0190                                                   ; / i  tmp2 = Number of bytes to copy
0191               
0192 6960 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0193 6962 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0194 6964 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0195               
0196 6966 A146  18         a     tmp2,tmp1             ; Forward in uncrunch area
0197 6968 C805  38         mov   tmp1,@tib.var6        ; Set current pos (addr) in uncrunch area
     696A A0F6     
0198                       ;------------------------------------------------------
0199                       ; 4a. Update variables related to crunched statement
0200                       ;------------------------------------------------------
0201 696C C106  18         mov   tmp2,tmp0             ; \ Amount of bytes copied to uncrunch area
0202 696E 05C4  14         inct  tmp0                  ; / Count token byte and length byte
0203 6970 C804  38         mov   tmp0,@outparm2        ; Set input bytes processed
     6972 A018     
0204               
0205 6974 0644  14         dect  tmp0                  ; Don't count token byte and length byte
0206 6976 C804  38         mov   tmp0,@tib.var10       ; Set output bytes generated (uncrunch area)
     6978 A0FE     
0207               
0208 697A A820  54         a     @outparm2,@outparm1   ; New position (addr) in crunched statement
     697C A018     
     697E A016     
0209               
0210 6980 1033  14         jmp   tib.uncrunch.token.setlen
0211                       ;------------------------------------------------------
0212                       ; 5. Special handling >c9: Decode line number
0213                       ;------------------------------------------------------
0214               tib.uncrunch.token.linenum:
0215 6982 C120  34         mov   @parm2,tmp0           ; Get position (addr) in crunched statement
     6984 A008     
0216 6986 0584  14         inc   tmp0                  ; Skip token
0217 6988 C160  34         mov   @tib.var6,tmp1        ; Get current pos (addr) in uncrunch area
     698A A0F6     
0218               
0219 698C D174  28         movb  *tmp0+,tmp1           ; Get MSB of line number into MSB
0220 698E 0985  56         srl   tmp1,8                ; MSB to LSB
0221 6990 D174  28         movb  *tmp0+,tmp1           ; Get LSB of line number into MSB
0222 6992 06C5  14         swpb  tmp1                  ; Put it in the right order
0223 6994 C805  38         mov   tmp1,@tib.var9        ; Put line number word in temporary variable
     6996 A0FC     
0224                       ;------------------------------------------------------
0225                       ; 5a. Convert line number (word) to string
0226                       ;------------------------------------------------------
0227               
0228                       ; mknum destroys tmp0-tmp4
0229                       ; That's why we push/pop up to tmp4 although tmp3-tmp4 not used here.
0230               
0231 6998 06A0  32         bl    @mknum                ; Convert unsigned number to string
     699A 29BA     
0232 699C A0FC                   data  tib.var9        ; \ i  p1    = Source
0233 699E A100                   data  rambuf          ; | i  p2    = Destination
0234 69A0 30                     byte  48              ; | i  p3MSB = ASCII offset
0235 69A1   20                   byte  32              ; / i  p3LSB = Padding character
0236               
0237 69A2 06A0  32         bl    @trimnum              ; Trim number, remove leading spaces
     69A4 2A12     
0238 69A6 A100                   data  rambuf          ; \ i  p1 = Source
0239 69A8 A105                   data  rambuf+5        ; | i  p2 = Destination
0240 69AA 0020                   data  32              ; / i  p3 = Padding character to look for
0241                       ;------------------------------------------------------
0242                       ; 5b. Copy decoded line number to uncrunch area
0243                       ;------------------------------------------------------
0244 69AC 0204  20         li    tmp0,rambuf+6         ; Start of line number string
     69AE A106     
0245 69B0 C160  34         mov   @tib.var6,tmp1        ; Get current pos (addr) in uncrunch area
     69B2 A0F6     
0246               
0247 69B4 D1A0  34         movb  @rambuf+5,tmp2        ; Get string length
     69B6 A105     
0248 69B8 0986  56         srl   tmp2,8                ; MSB to LSB
0249               
0250 69BA C806  38         mov   tmp2,@tib.var10       ; Set output bytes generated
     69BC A0FE     
0251 69BE A820  54         a     @tib.var10,@tib.var6  ; Set current pos (addr) in uncrunch area
     69C0 A0FE     
     69C2 A0F6     
0252               
0253 69C4 0649  14         dect  stack
0254 69C6 C644  30         mov   tmp0,*stack           ; Push tmp0
0255 69C8 0649  14         dect  stack
0256 69CA C645  30         mov   tmp1,*stack           ; Push tmp1
0257 69CC 0649  14         dect  stack
0258 69CE C646  30         mov   tmp2,*stack           ; Push tmp2
0259               
0260 69D0 06A0  32         bl    @xpym2m               ; Copy string from crunched statement to
     69D2 24F4     
0261                                                   ; uncrunch area.
0262                                                   ; \ i  tmp0 = Source address
0263                                                   ; | i  tmp1 = Destination address
0264                                                   ; / i  tmp2 = Number of bytes to copy
0265               
0266 69D4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0267 69D6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0268 69D8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0269                       ;------------------------------------------------------
0270                       ; 5c. Update variables related to crunched statement
0271                       ;------------------------------------------------------
0272 69DA 0204  20         li    tmp0,3                ; Token + line number word
     69DC 0003     
0273 69DE A804  38         a     tmp0,@outparm1        ; New pos (addr) in crunched statement
     69E0 A016     
0274 69E2 C804  38         mov   tmp0,@outparm2        ; Set input bytes processed
     69E4 A018     
0275 69E6 1000  14         jmp   tib.uncrunch.token.setlen
0276                       ;------------------------------------------------------
0277                       ; 6. Update uncrunched statement length byte
0278                       ;------------------------------------------------------
0279               tib.uncrunch.token.setlen:
0280 69E8 C120  34         mov   @tib.var10,tmp0       ; Get output bytes generated
     69EA A0FE     
0281 69EC 0A84  56         sla   tmp0,8                ; LSB to MSB
0282 69EE B804  38         ab    tmp0,@fb.uncrunch.area
     69F0 D960     
0283                                                   ; Update string length-prefix byte
0284                       ;------------------------------------------------------
0285                       ; Exit
0286                       ;------------------------------------------------------
0287               tib.uncrunch.token.exit:
0288 69F2 C839  50         mov   *stack+,@tib.var10    ; Pop @tib.var10
     69F4 A0FE     
0289 69F6 C839  50         mov   *stack+,@tib.var9     ; Pop @tib.var9
     69F8 A0FC     
0290 69FA C239  30         mov   *stack+,tmp4          ; Pop tmp4
0291 69FC C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0292 69FE C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0293 6A00 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0294 6A02 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0295 6A04 C2F9  30         mov   *stack+,r11           ; Pop r11
0296 6A06 045B  20         b     *r11                  ; Return
                   < stevie_b7.asm.16732
0075                       copy  "tib.uncrunch.line.pack.asm"
     **** ****     > tib.uncrunch.line.pack.asm
0001               * FILE......: tib.uncrunch.line.pack
0002               * Purpose...: Pack uncrunched line to editor buffer
0003               
0004               ***************************************************************
0005               * tib.uncrunch.line.pack
0006               * Pack uncrunched statement line to editor buffer
0007               ***************************************************************
0008               *  bl   @tib.uncrunch.line.pack
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @fb.uncrunch  = Pointer to uncrunch area
0012               * @parm1        = Line in editor buffer
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0,tmp1,tmp2,tmp3,tmp4
0018               *--------------------------------------------------------------
0019               * Remarks
0020               * none
0021               ********|*****|*********************|**************************
0022               tib.uncrunch.line.pack:
0023 6A08 0649  14         dect  stack
0024 6A0A C64B  30         mov   r11,*stack            ; Save return address
0025 6A0C 0649  14         dect  stack
0026 6A0E C644  30         mov   tmp0,*stack           ; Push tmp0
0027 6A10 0649  14         dect  stack
0028 6A12 C645  30         mov   tmp1,*stack           ; Push tmp1
0029 6A14 0649  14         dect  stack
0030 6A16 C646  30         mov   tmp2,*stack           ; Push tmp2
0031 6A18 0649  14         dect  stack
0032 6A1A C647  30         mov   tmp3,*stack           ; Push tmp3
0033 6A1C 0649  14         dect  stack
0034 6A1E C648  30         mov   tmp4,*stack           ; Push tmp4
0035                       ;------------------------------------------------------
0036                       ; 1. Prepare scan
0037                       ;------------------------------------------------------
0038 6A20 0205  20         li    tmp1,fb.uncrunch.area ; Get pointer to uncrunch area
     6A22 D960     
0039 6A24 C1E0  34         mov   @parm1,tmp3           ; Editor buffer line
     6A26 A006     
0040               
0041 6A28 D235  28         movb  *tmp1+,tmp4           ; Get length byte
0042 6A2A 0988  56         srl   tmp4,8                ; MSB to LSB
0043               
0044 6A2C 06A0  32         bl    @edb.hipage.alloc     ; Check and increase highest SAMS page
     6A2E 35FE     
0045                                                   ; \ i  @edb.next_free.ptr = Pointer to next
0046                                                   ; /    free line
0047                       ;------------------------------------------------------
0048                       ; 2. Update index
0049                       ;------------------------------------------------------
0050 6A30 C807  38         mov   tmp3,@parm1           ; Set editor buffer line
     6A32 A006     
0051 6A34 C820  54         mov   @edb.next_free.ptr,@parm2
     6A36 A508     
     6A38 A008     
0052                                                   ; Pointer to new line
0053 6A3A C820  54         mov   @edb.sams.hipage,@parm3
     6A3C A518     
     6A3E A00A     
0054                                                   ; SAMS page to use
0055               
0056 6A40 06A0  32         bl    @idx.entry.update     ; Update index
     6A42 339C     
0057                                                   ; \ i  @parm1 = Line number in editor buffer
0058                                                   ; | i  @parm2 = pointer to line in
0059                                                   ; |             editor buffer
0060                                                   ; / i  @parm3 = SAMS page
0061                       ;------------------------------------------------------
0062                       ; 3. Set line prefix in editor buffer
0063                       ;------------------------------------------------------
0064 6A44 0204  20         li    tmp0,fb.uncrunch.area+1
     6A46 D961     
0065                                                   ; Source for memory copy
0066 6A48 C160  34         mov   @edb.next_free.ptr,tmp1
     6A4A A508     
0067                                                   ; Address of line in editor buffer
0068               
0069 6A4C 05E0  34         inct  @edb.next_free.ptr    ; Adjust pointer
     6A4E A508     
0070               
0071 6A50 C188  18         mov   tmp4,tmp2             ; Get line length
0072 6A52 CD46  34         mov   tmp2,*tmp1+           ; Set saved line length as line prefix
0073                       ;------------------------------------------------------
0074                       ; 4. Copy line from uncrunch area to editor buffer
0075                       ;------------------------------------------------------
0076               tib.uncrunch.line.pack.copyline:
0077 6A54 0286  22         ci    tmp2,2
     6A56 0002     
0078 6A58 1603  14         jne   tib.uncrunch.line.pack.copyline.checkbyte
0079 6A5A DD74  42         movb  *tmp0+,*tmp1+         ; \ Copy single word on possible
0080 6A5C DD74  42         movb  *tmp0+,*tmp1+         ; / uneven address
0081 6A5E 1007  14         jmp   tib.uncrunch.line.pack.copyline.align16
0082               
0083               tib.uncrunch.line.pack.copyline.checkbyte:
0084 6A60 0286  22         ci    tmp2,1
     6A62 0001     
0085 6A64 1602  14         jne   tib.uncrunch.line.pack.copyline.block
0086 6A66 D554  38         movb  *tmp0,*tmp1           ; Copy single byte
0087 6A68 1002  14         jmp   tib.uncrunch.line.pack.copyline.align16
0088               
0089               tib.uncrunch.line.pack.copyline.block:
0090 6A6A 06A0  32         bl    @xpym2m               ; Copy memory block
     6A6C 24F4     
0091                                                   ; \ i  tmp0 = source
0092                                                   ; | i  tmp1 = destination, see (1)
0093                                                   ; / i  tmp2 = bytes to copy
0094                       ;------------------------------------------------------
0095                       ; 5. Align pointer to multiple of 16 memory address
0096                       ;------------------------------------------------------
0097               tib.uncrunch.line.pack.copyline.align16:
0098 6A6E A808  38         a     tmp4,@edb.next_free.ptr  ; Add length of line
     6A70 A508     
0099               
0100 6A72 C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     6A74 A508     
0101 6A76 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0102 6A78 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     6A7A 000F     
0103 6A7C A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     6A7E A508     
0104                       ;------------------------------------------------------
0105                       ; 6. Restore SAMS page and prepare for exit
0106                       ;------------------------------------------------------
0107               tib.uncrunch.line.pack.prepexit:
0108 6A80 8820  54         c     @edb.sams.hipage,@edb.sams.page
     6A82 A518     
     6A84 A516     
0109 6A86 1306  14         jeq   tib.uncrunch.line.pack.exit
0110                                                      ; Exit early if SAMS page already mapped
0111               
0112 6A88 C120  34         mov   @edb.sams.page,tmp0
     6A8A A516     
0113 6A8C C160  34         mov   @edb.top.ptr,tmp1
     6A8E A500     
0114 6A90 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     6A92 258A     
0115                                                   ; \ i  tmp0 = SAMS page number
0116                                                   ; / i  tmp1 = Memory address
0117                       ;------------------------------------------------------
0118                       ; Exit
0119                       ;------------------------------------------------------
0120               tib.uncrunch.line.pack.exit:
0121 6A94 C239  30         mov   *stack+,tmp4          ; Pop tmp4
0122 6A96 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0123 6A98 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0124 6A9A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0125 6A9C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0126 6A9E C2F9  30         mov   *stack+,r11           ; Pop R11
0127 6AA0 045B  20         b     *r11                  ; Return to caller
                   < stevie_b7.asm.16732
0076                                                        ; Pack uncrunched line to editor buffer
0077                       ;-----------------------------------------------------------------------
0078                       ; Stubs
0079                       ;-----------------------------------------------------------------------
0080                       copy  "rom.stubs.bank7.asm"      ; Bank specific stubs
     **** ****     > rom.stubs.bank7.asm
0001               * FILE......: rom.stubs.bank7.asm
0002               * Purpose...: Bank 7 stubs for functions in other banks
0003               
0004               
0005               
0006               ***************************************************************
0007               * Stub for "cmdb.dialog.close"
0008               * bank1 vec.18
0009               ********|*****|*********************|**************************
0010               cmdb.dialog.close:
0011 6AA2 0649  14         dect  stack
0012 6AA4 C64B  30         mov   r11,*stack            ; Save return address
0013                       ;------------------------------------------------------
0014                       ; Call function in bank 1
0015                       ;------------------------------------------------------
0016 6AA6 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6AA8 2F84     
0017 6AAA 6002                   data bank1.rom        ; | i  p0 = bank address
0018 6AAC 7FE2                   data vec.18           ; | i  p1 = Vector with target address
0019 6AAE 600E                   data bankid           ; / i  p2 = Source ROM bank for return
0020                       ;------------------------------------------------------
0021                       ; Exit
0022                       ;------------------------------------------------------
0023 6AB0 C2F9  30         mov   *stack+,r11           ; Pop r11
0024 6AB2 045B  20         b     *r11                  ; Return to caller
0025               
0026               
0027               ***************************************************************
0028               * Stub for "fb.refresh"
0029               * bank1 vec.20
0030               ********|*****|*********************|**************************
0031               fb.refresh:
0032 6AB4 0649  14         dect  stack
0033 6AB6 C64B  30         mov   r11,*stack            ; Save return address
0034                       ;------------------------------------------------------
0035                       ; Call function in bank 1
0036                       ;------------------------------------------------------
0037 6AB8 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6ABA 2F84     
0038 6ABC 6002                   data bank1.rom        ; | i  p0 = bank address
0039 6ABE 7FE6                   data vec.20           ; | i  p1 = Vector with target address
0040 6AC0 600E                   data bankid           ; / i  p2 = Source ROM bank for return
0041                       ;------------------------------------------------------
0042                       ; Exit
0043                       ;------------------------------------------------------
0044 6AC2 C2F9  30         mov   *stack+,r11           ; Pop r11
0045 6AC4 045B  20         b     *r11                  ; Return to caller
0046               
0047               
0048               ***************************************************************
0049               * Stub for "pane.action.colorscheme.load"
0050               * bank1 vec.31
0051               ********|*****|*********************|**************************
0052               pane.action.colorscheme.load:
0053 6AC6 0649  14         dect  stack
0054 6AC8 C64B  30         mov   r11,*stack            ; Save return address
0055                       ;------------------------------------------------------
0056                       ; Call function in bank 1
0057                       ;------------------------------------------------------
0058 6ACA 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6ACC 2F84     
0059 6ACE 6002                   data bank1.rom        ; | i  p0 = bank address
0060 6AD0 7FFC                   data vec.31           ; | i  p1 = Vector with target address
0061 6AD2 600E                   data bankid           ; / i  p2 = Source ROM bank for return
0062                       ;------------------------------------------------------
0063                       ; Exit
0064                       ;------------------------------------------------------
0065 6AD4 C2F9  30         mov   *stack+,r11           ; Pop r11
0066 6AD6 045B  20         b     *r11                  ; Return to caller
0067               
0068               
0069               ***************************************************************
0070               * Stub for "pane.action.colorscheme.statline"
0071               * bank1 vec.32
0072               ********|*****|*********************|**************************
0073               pane.action.colorscheme.statlines:
0074 6AD8 0649  14         dect  stack
0075 6ADA C64B  30         mov   r11,*stack            ; Save return address
0076                       ;------------------------------------------------------
0077                       ; Call function in bank 1
0078                       ;------------------------------------------------------
0079 6ADC 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6ADE 2F84     
0080 6AE0 6002                   data bank1.rom        ; | i  p0 = bank address
0081 6AE2 7FFE                   data vec.32           ; | i  p1 = Vector with target address
0082 6AE4 600E                   data bankid           ; / i  p2 = Source ROM bank for return
0083                       ;------------------------------------------------------
0084                       ; Exit
0085                       ;------------------------------------------------------
0086 6AE6 C2F9  30         mov   *stack+,r11           ; Pop r11
0087 6AE8 045B  20         b     *r11                  ; Return to caller
0088               
0089               ***************************************************************
0090               * Stub for "fm.newfile"
0091               * bank2 vec.5
0092               ********|*****|*********************|**************************
0093               fm.newfile:
0094 6AEA 0649  14         dect  stack
0095 6AEC C64B  30         mov   r11,*stack            ; Save return address
0096                       ;------------------------------------------------------
0097                       ; Call function in bank 2
0098                       ;------------------------------------------------------
0099 6AEE 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6AF0 2F84     
0100 6AF2 6004                   data bank2.rom        ; | i  p0 = bank address
0101 6AF4 7FC8                   data vec.5            ; | i  p1 = Vector with target address
0102 6AF6 600E                   data bankid           ; / i  p2 = Source ROM bank for return
0103                       ;------------------------------------------------------
0104                       ; Exit
0105                       ;------------------------------------------------------
0106 6AF8 C2F9  30         mov   *stack+,r11           ; Pop r11
0107 6AFA 045B  20         b     *r11                  ; Return to caller
0108               
0109               
0110               ***************************************************************
0111               * Stub for "tibasic.buildstr"
0112               * bank3 vec.23
0113               ********|*****|*********************|**************************
0114               tibasic.buildstr:
0115 6AFC 0649  14         dect  stack
0116 6AFE C64B  30         mov   r11,*stack            ; Save return address
0117                       ;------------------------------------------------------
0118                       ; Call function in bank 3
0119                       ;------------------------------------------------------
0120 6B00 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6B02 2F84     
0121 6B04 6006                   data bank3.rom        ; | i  p0 = bank address
0122 6B06 7FEC                   data vec.23           ; | i  p1 = Vector with target address
0123 6B08 600E                   data bankid           ; / i  p2 = Source ROM bank for return
0124                       ;------------------------------------------------------
0125                       ; Exit
0126                       ;------------------------------------------------------
0127 6B0A C2F9  30         mov   *stack+,r11           ; Pop r11
0128 6B0C 045B  20         b     *r11                  ; Return to caller
                   < stevie_b7.asm.16732
0081                       copy  "rom.stubs.bankx.asm"      ; Stubs to include in all banks > 0
     **** ****     > rom.stubs.bankx.asm
0001               * FILE......: rom.stubs.bankx.asm
0002               * Purpose...: Stubs to include in all banks > 0
0003               
0004               
0006               ***************************************************************
0007               * Stub for "mem.sams.setup.stevie"
0008               * bank1 vec.1
0009               ********|*****|*********************|**************************
0010               mem.sams.setup.stevie:
0011 6B0E 0649  14         dect  stack
0012 6B10 C64B  30         mov   r11,*stack            ; Save return address
0013                       ;------------------------------------------------------
0014                       ; Call function in bank 1
0015                       ;------------------------------------------------------
0016 6B12 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     6B14 2F84     
0017 6B16 6002                   data bank1.rom        ; | i  p0 = bank address
0018 6B18 7FC0                   data vec.1            ; | i  p1 = Vector with target address
0019 6B1A 600E                   data bankid           ; / i  p2 = Source ROM bank for return
0020                       ;------------------------------------------------------
0021                       ; Exit
0022                       ;------------------------------------------------------
0023 6B1C C2F9  30         mov   *stack+,r11           ; Pop r11
0024 6B1E 045B  20         b     *r11                  ; Return to caller
0026               
0027               
0049               
0050               
0072               
0073               
0095               
0096               
0118               
0119               
0141               
0142               
                   < stevie_b7.asm.16732
0082                       ;-----------------------------------------------------------------------
0083                       ; Program data
0084                       ;-----------------------------------------------------------------------
0085                       copy  "data.sams.layout.asm"     ; SAMS bank layout for multi-purpose
     **** ****     > data.sams.layout.asm
0001               * FILE......: data.sams.layout.asm
0002               * Purpose...: SAMS bank layout for multi-purpose
0003               
0004               
0005               ***************************************************************
0006               * SAMS legacy page layout table (as in SAMS transparent mode)
0007               *--------------------------------------------------------------
0008               mem.sams.layout.legacy:
0009 6B20 0200             data  >0200                 ; >2000-2fff, SAMS page >02
0010 6B22 0300             data  >0300                 ; >3000-3fff, SAMS page >03
0011 6B24 0A00             data  >0a00                 ; >a000-afff, SAMS page >0a
0012 6B26 0B00             data  >0b00                 ; >b000-bfff, SAMS page >0b
0013 6B28 0C00             data  >0c00                 ; >c000-cfff, SAMS page >0c
0014 6B2A 0D00             data  >0d00                 ; >d000-dfff, SAMS page >0d
0015 6B2C 0E00             data  >0e00                 ; >e000-efff, SAMS page >0e
0016 6B2E 0F00             data  >0f00                 ; >f000-ffff, SAMS page >0f
0017               
0018               ***************************************************************
0019               * SAMS page layout table for Stevie boot order
0020               *--------------------------------------------------------------
0021               mem.sams.layout.boot:
0022 6B30 0000             data  >0000                 ; >2000-2fff, SAMS page >00
0023 6B32 0100             data  >0100                 ; >3000-3fff, SAMS page >01
0024 6B34 0400             data  >0400                 ; >a000-afff, SAMS page >04
0025 6B36 2000             data  >2000                 ; >b000-bfff, SAMS page >20
0026                                                   ; \
0027                                                   ; | Index can allocate
0028                                                   ; | pages >20 to >3f.
0029                                                   ; /
0030 6B38 4000             data  >4000                 ; >c000-cfff, SAMS page >40
0031                                                   ; \
0032                                                   ; | Editor buffer can allocate
0033                                                   ; | pages >40 to >ff.
0034                                                   ; /
0035 6B3A 0500             data  >0500                 ; >d000-dfff, SAMS page >05
0036 6B3C 0600             data  >0600                 ; >e000-efff, SAMS page >06
0037 6B3E 0700             data  >0700                 ; >f000-ffff, SAMS page >07
0038               
0039               ***************************************************************
0040               * SAMS page layout table before calling external progam
0041               *--------------------------------------------------------------
0042               mem.sams.layout.external:
0043 6B40 0000             data  >0000                 ; >2000-2fff, SAMS page >00
0044 6B42 0100             data  >0100                 ; >3000-3fff, SAMS page >01
0045 6B44 0400             data  >0400                 ; >a000-afff, SAMS page >04
0046               
0047 6B46 1000             data  >1000                 ; >b000-efff, SAMS page >10
0048 6B48 1100             data  >1100                 ; \
0049 6B4A 1200             data  >1200                 ; | Stevie session
0050 6B4C 1300             data  >1300                 ; | VDP content
0051                                                   ; /
0052 6B4E 0700             data  >0700                 ; >f000-ffff, SAMS page >07
0053               
0054               
0055               ***************************************************************
0056               * SAMS page layout table TI Basic session 1 VRAM
0057               *--------------------------------------------------------------
0058               mem.sams.layout.basic1:
0059 6B50 0000             data  >0000                 ; . >2000-2fff
0060 6B52 0100             data  >0100                 ; . >3000-3fff
0061 6B54 0400             data  >0400                 ; . >a000-afff
0062 6B56 FB00             data  >fb00                 ; \ >b000-efff
0063 6B58 FC00             data  >fc00                 ; |
0064 6B5A FD00             data  >fd00                 ; | 16K VDP dump
0065 6B5C FE00             data  >fe00                 ; /
0066 6B5E FF00             data  >ff00                 ; . >f000-ffff
0067               
0068               
0069               ***************************************************************
0070               * SAMS page layout table TI Basic session 2 VRAM
0071               *--------------------------------------------------------------
0072               mem.sams.layout.basic2:
0073 6B60 0000             data  >0000                 ; . >2000-2fff
0074 6B62 0100             data  >0100                 ; . >3000-3fff
0075 6B64 0400             data  >0400                 ; . >a000-afff
0076 6B66 F700             data  >f700                 ; \ >b000-efff
0077 6B68 F800             data  >f800                 ; |
0078 6B6A F900             data  >f900                 ; | 16K VDP dump
0079 6B6C FA00             data  >fa00                 ; /
0080 6B6E FF00             data  >ff00                 ; . >f000-ffff
0081               
0082               
0083               ***************************************************************
0084               * SAMS page layout table TI Basic session 3 VRAM
0085               *--------------------------------------------------------------
0086               mem.sams.layout.basic3:
0087 6B70 0000             data  >0000                 ; . >2000-2fff
0088 6B72 0100             data  >0100                 ; . >3000-3fff
0089 6B74 0400             data  >0400                 ; . >a000-afff
0090 6B76 F300             data  >f300                 ; \ >b000-efff
0091 6B78 F400             data  >f400                 ; |
0092 6B7A F500             data  >f500                 ; | 16K VDP dump
0093 6B7C F600             data  >f600                 ; /
0094 6B7E FF00             data  >ff00                 ; . >f000-ffff
0095               
0096               
0097               ***************************************************************
0098               * SAMS page layout table TI Basic session 4 VRAM
0099               *--------------------------------------------------------------
0100               mem.sams.layout.basic4:
0101 6B80 0000             data  >0000                 ; . >2000-2fff
0102 6B82 0100             data  >0100                 ; . >3000-3fff
0103 6B84 0400             data  >0400                 ; . >a000-afff
0104 6B86 EF00             data  >ef00                 ; \ >b000-efff
0105 6B88 F000             data  >f000                 ; |
0106 6B8A F100             data  >f100                 ; | 16K VDP dump
0107 6B8C F200             data  >f200                 ; /
0108 6B8E FF00             data  >ff00                 ; . >f000-ffff
0109               
0110               
0111               ***************************************************************
0112               * SAMS page layout table TI Basic session 5 VRAM
0113               *--------------------------------------------------------------
0114               mem.sams.layout.basic5:
0115 6B90 0000             data  >0000                 ; . >2000-2fff
0116 6B92 0100             data  >0100                 ; . >3000-3fff
0117 6B94 0400             data  >0400                 ; . >a000-afff
0118 6B96 EB00             data  >eb00                 ; \ >b000-efff
0119 6B98 EC00             data  >ec00                 ; |
0120 6B9A ED00             data  >ed00                 ; | 16K VDP dump
0121 6B9C EE00             data  >ee00                 ; /
0122 6B9E FF00             data  >ff00                 ; . >f000-ffff
0123               
0124               
0125      6B50     mem.sams.layout.basic  equ mem.sams.layout.basic1
                   < stevie_b7.asm.16732
0086                       copy  "data.tib.tokens.asm"      ; TI Basic tokens
     **** ****     > data.tib.tokens.asm
0001               * FILE......: data.tib.tokens.asm
0002               * Purpose...: TI Basic tokens
0003               
0004               
0005               ***************************************************************
0006               *                      TI Basic tokens
0007               ***************************************************************
0008               
0009               ;-----------------------------------------------------------------------
0010               ; Command tokens
0011               ;-----------------------------------------------------------------------
0012 6BA0 0003     tk.00   byte   >00,3,'R','U','N'
     6BA2 5255     
     6BA4 4E       
0013                       even
0014 6BA6 0103     tk.01   byte   >01,3,'N','E','W'
     6BA8 4E45     
     6BAA 57       
0015                       even
0016 6BAC 0203     tk.02   byte   >02,3,'C','O','N'
     6BAE 434F     
     6BB0 4E       
0017                       even
0018 6BB2 0208     tk.02l  byte   >02,8,'C','O','N','T','I','N','U','E'
     6BB4 434F     
     6BB6 4E54     
     6BB8 494E     
     6BBA 5545     
0019                       even
0020 6BBC 0304     tk.03   byte   >03,4,'L','I','S','T'
     6BBE 4C49     
     6BC0 5354     
0021                       even
0022 6BC2 0403     tk.04   byte   >04,3,'B','Y','E'
     6BC4 4259     
     6BC6 45       
0023                       even
0024 6BC8 0503     tk.05   byte   >05,3,'N','U','M'
     6BCA 4E55     
     6BCC 4D       
0025                       even
0026 6BCE 0506     tk.05l  byte   >05,6,'N','U','M','B','E','R'
     6BD0 4E55     
     6BD2 4D42     
     6BD4 4552     
0027                       even
0028 6BD6 0603     tk.06   byte   >06,3,'O','L','D'
     6BD8 4F4C     
     6BDA 44       
0029                       even
0030 6BDC 0703     tk.07   byte   >07,3,'R','E','S'
     6BDE 5245     
     6BE0 53       
0031                       even
0032 6BE2 070A     tk.07l  byte   >07,10,'R','E','S','E','Q','U','E','N','C','E'
     6BE4 5245     
     6BE6 5345     
     6BE8 5155     
     6BEA 454E     
     6BEC 4345     
0033                       even
0034 6BEE 0804     tk.08   byte   >08,4,'S','A','V','E'
     6BF0 5341     
     6BF2 5645     
0035                       even
0036 6BF4 0904     tk.09   byte   >09,4,'E','D','I','T'
     6BF6 4544     
     6BF8 4954     
0037                       even
0038               ;-----------------------------------------------------------------------
0039               ; Program tokens
0040               ;-----------------------------------------------------------------------
0041 6BFA 8105     tk.81   byte   >81,5,' ','E','L','S','E'
     6BFC 2045     
     6BFE 4C53     
     6C00 45       
0042                       even
0043 6C02 8402     tk.84   byte   >84,2,'I','F'
     6C04 4946     
0044                       even
0045 6C06 8502     tk.85   byte   >85,2,'G','O'
     6C08 474F     
0046                       even
0047 6C0A 8604     tk.86   byte   >86,4,'G','O','T','O'
     6C0C 474F     
     6C0E 544F     
0048                       even
0049 6C10 8705     tk.87   byte   >87,5,'G','O','S','U','B'
     6C12 474F     
     6C14 5355     
     6C16 42       
0050                       even
0051 6C18 8806     tk.88   byte   >88,6,'R','E','T','U','R','N'
     6C1A 5245     
     6C1C 5455     
     6C1E 524E     
0052                       even
0053 6C20 8903     tk.89   byte   >89,3,'D','E','F'
     6C22 4445     
     6C24 46       
0054                       even
0055 6C26 8A03     tk.8a   byte   >8A,3,'D','I','M'
     6C28 4449     
     6C2A 4D       
0056                       even
0057 6C2C 8B03     tk.8b   byte   >8B,3,'E','N','D'
     6C2E 454E     
     6C30 44       
0058                       even
0059 6C32 8C03     tk.8c   byte   >8C,3,'F','O','R'
     6C34 464F     
     6C36 52       
0060                       even
0061 6C38 8D03     tk.8d   byte   >8D,3,'L','E','T'
     6C3A 4C45     
     6C3C 54       
0062                       even
0063 6C3E 8E05     tk.8e   byte   >8E,5,'B','R','E','A','K'
     6C40 4252     
     6C42 4541     
     6C44 4B       
0064                       even
0065 6C46 8F07     tk.8f   byte   >8F,7,'U','N','B','R','E','A','K'
     6C48 554E     
     6C4A 4252     
     6C4C 4541     
     6C4E 4B       
0066                       even
0067 6C50 9005     tk.90   byte   >90,5,'T','R','A','C','E'
     6C52 5452     
     6C54 4143     
     6C56 45       
0068                       even
0069 6C58 9107     tk.91   byte   >91,7,'U','N','T','R','A','C','E'
     6C5A 554E     
     6C5C 5452     
     6C5E 4143     
     6C60 45       
0070                       even
0071 6C62 9205     tk.92   byte   >92,5,'I','N','P','U','T'
     6C64 494E     
     6C66 5055     
     6C68 54       
0072                       even
0073 6C6A 9304     tk.93   byte   >93,4,'D','A','T','A'
     6C6C 4441     
     6C6E 5441     
0074                       even
0075 6C70 9407     tk.94   byte   >94,7,'R','E','S','T','O','R','E'
     6C72 5245     
     6C74 5354     
     6C76 4F52     
     6C78 45       
0076                       even
0077 6C7A 9509     tk.95   byte   >95,9,'R','A','N','D','O','M','I','Z','E'
     6C7C 5241     
     6C7E 4E44     
     6C80 4F4D     
     6C82 495A     
     6C84 45       
0078                       even
0079 6C86 9604     tk.96   byte   >96,4,'N','E','X','T'
     6C88 4E45     
     6C8A 5854     
0080                       even
0081 6C8C 9704     tk.97   byte   >97,4,'R','E','A','D'
     6C8E 5245     
     6C90 4144     
0082                       even
0083 6C92 9804     tk.98   byte   >98,4,'S','T','O','P'
     6C94 5354     
     6C96 4F50     
0084                       even
0085 6C98 9906     tk.99   byte   >99,6,'D','E','L','E','T','E'
     6C9A 4445     
     6C9C 4C45     
     6C9E 5445     
0086                       even
0087 6CA0 9A03     tk.9a   byte   >9A,3,'R','E','M'
     6CA2 5245     
     6CA4 4D       
0088                       even
0089 6CA6 9B02     tk.9b   byte   >9B,2,'O','N'
     6CA8 4F4E     
0090                       even
0091 6CAA 9C05     tk.9c   byte   >9C,5,'P','R','I','N','T'
     6CAC 5052     
     6CAE 494E     
     6CB0 54       
0092                       even
0093 6CB2 9D04     tk.9d   byte   >9D,4,'C','A','L','L'
     6CB4 4341     
     6CB6 4C4C     
0094                       even
0095 6CB8 9E06     tk.9e   byte   >9E,6,'O','P','T','I','O','N'
     6CBA 4F50     
     6CBC 5449     
     6CBE 4F4E     
0096                       even
0097 6CC0 9F04     tk.9f   byte   >9F,4,'O','P','E','N'
     6CC2 4F50     
     6CC4 454E     
0098                       even
0099 6CC6 A005     tk.a0   byte   >A0,5,'C','L','O','S','E'
     6CC8 434C     
     6CCA 4F53     
     6CCC 45       
0100                       even
0101 6CCE A103     tk.a1   byte   >A1,3,'S','U','B'
     6CD0 5355     
     6CD2 42       
0102                       even
0103 6CD4 A207     tk.a2   byte   >A2,7,'D','I','S','P','L','A','Y'
     6CD6 4449     
     6CD8 5350     
     6CDA 4C41     
     6CDC 59       
0104                       even
0105 6CDE B005     tk.b0   byte   >B0,5,' ','T','H','E','N'
     6CE0 2054     
     6CE2 4845     
     6CE4 4E       
0106                       even
0107 6CE6 B103     tk.b1   byte   >B1,3,' ','T','O'
     6CE8 2054     
     6CEA 4F       
0108                       even
0109 6CEC B205     tk.b2   byte   >B2,5,' ','S','T','E','P'
     6CEE 2053     
     6CF0 5445     
     6CF2 50       
0110                       even
0111 6CF4 B301     tk.b3   byte   >B3,1,','
     6CF6 2C       
0112                       even
0113 6CF8 B401     tk.b4   byte   >B4,1,';'
     6CFA 3B       
0114                       even
0115 6CFC B501     tk.b5   byte   >B5,1,':'
     6CFE 3A       
0116                       even
0117 6D00 B601     tk.b6   byte   >B6,1,')'
     6D02 29       
0118                       even
0119 6D04 B701     tk.b7   byte   >B7,1,'('
     6D06 28       
0120                       even
0121 6D08 B801     tk.b8   byte   >B8,1,'&'
     6D0A 26       
0122                       even
0123 6D0C BE01     tk.be   byte   >BE,1,'='
     6D0E 3D       
0124                       even
0125 6D10 BF01     tk.bf   byte   >BF,1,'<'
     6D12 3C       
0126                       even
0127 6D14 C001     tk.c0   byte   >C0,1,'>'
     6D16 3E       
0128                       even
0129 6D18 C101     tk.c1   byte   >C1,1,'+'
     6D1A 2B       
0130                       even
0131 6D1C C201     tk.c2   byte   >C2,1,'-'
     6D1E 2D       
0132                       even
0133 6D20 C301     tk.c3   byte   >C3,1,'*'
     6D22 2A       
0134                       even
0135 6D24 C401     tk.c4   byte   >C4,1,'/'
     6D26 2F       
0136                       even
0137 6D28 C501     tk.c5   byte   >C5,1,'^'
     6D2A 5E       
0138                       even
0139 6D2C C701     tk.c7   byte   >C7,1,34                ; Quote character
     6D2E 22       
0140                       even
0141 6D30 C801     tk.c8   byte   >C8,1,' '
     6D32 20       
0142                       even
0143 6D34 C901     tk.c9   byte   >C9,1,' '
     6D36 20       
0144                       even
0145 6D38 CA03     tk.ca   byte   >CA,3,'E','O','F'
     6D3A 454F     
     6D3C 46       
0146                       even
0147 6D3E CB03     tk.cb   byte   >CB,3,'A','B','S'
     6D40 4142     
     6D42 53       
0148                       even
0149 6D44 CC03     tk.cc   byte   >CC,3,'A','T','N'
     6D46 4154     
     6D48 4E       
0150                       even
0151 6D4A CD03     tk.cd   byte   >CD,3,'C','O','S'
     6D4C 434F     
     6D4E 53       
0152                       even
0153 6D50 CE03     tk.ce   byte   >CE,3,'E','X','P'
     6D52 4558     
     6D54 50       
0154                       even
0155 6D56 CF03     tk.cf   byte   >CF,3,'I','N','T'
     6D58 494E     
     6D5A 54       
0156                       even
0157 6D5C D003     tk.d0   byte   >D0,3,'L','O','G'
     6D5E 4C4F     
     6D60 47       
0158                       even
0159 6D62 D103     tk.d1   byte   >D1,3,'S','G','N'
     6D64 5347     
     6D66 4E       
0160                       even
0161 6D68 D203     tk.d2   byte   >D2,3,'S','I','N'
     6D6A 5349     
     6D6C 4E       
0162                       even
0163 6D6E D303     tk.d3   byte   >D3,3,'S','Q','R'
     6D70 5351     
     6D72 52       
0164                       even
0165 6D74 D403     tk.d4   byte   >D4,3,'T','A','N'
     6D76 5441     
     6D78 4E       
0166                       even
0167 6D7A D503     tk.d5   byte   >D5,3,'L','E','N'
     6D7C 4C45     
     6D7E 4E       
0168                       even
0169 6D80 D604     tk.d6   byte   >D6,4,'C','H','R','$'
     6D82 4348     
     6D84 5224     
0170                       even
0171 6D86 D703     tk.d7   byte   >D7,3,'R','N','D'
     6D88 524E     
     6D8A 44       
0172                       even
0173 6D8C D804     tk.d8   byte   >D8,4,'S','E','G','$'
     6D8E 5345     
     6D90 4724     
0174                       even
0175 6D92 D903     tk.d9   byte   >D9,3,'P','O','S'
     6D94 504F     
     6D96 53       
0176                       even
0177 6D98 DA03     tk.da   byte   >DA,3,'V','A','L'
     6D9A 5641     
     6D9C 4C       
0178                       even
0179 6D9E DB04     tk.db   byte   >DB,4,'S','T','R','$'
     6DA0 5354     
     6DA2 5224     
0180                       even
0181 6DA4 DC03     tk.dc   byte   >DC,3,'A','S','C'
     6DA6 4153     
     6DA8 43       
0182                       even
0183 6DAA DE03     tk.de   byte   >DE,3,'R','E','C'
     6DAC 5245     
     6DAE 43       
0184                       even
0185 6DB0 F104     tk.f1   byte   >F1,4,'B','A','S','E'
     6DB2 4241     
     6DB4 5345     
0186                       even
0187 6DB6 F308     tk.f3   byte   >F3,8,'V','A','R','I','A','B','L','E'
     6DB8 5641     
     6DBA 5249     
     6DBC 4142     
     6DBE 4C45     
0188                       even
0189 6DC0 F408     tk.f4   byte   >F4,8,'R','E','L','A','T','I','V','E'
     6DC2 5245     
     6DC4 4C41     
     6DC6 5449     
     6DC8 5645     
0190                       even
0191 6DCA F508     tk.f5   byte   >F5,8,'I','N','T','E','R','N','A','L'
     6DCC 494E     
     6DCE 5445     
     6DD0 524E     
     6DD2 414C     
0192                       even
0193 6DD4 F60A     tk.f6   byte   >F6,10,'S','E','Q','U','E','N','T','I','A','L'
     6DD6 5345     
     6DD8 5155     
     6DDA 454E     
     6DDC 5449     
     6DDE 414C     
0194                       even
0195 6DE0 F706     tk.f7   byte   >F7,6,'O','U','T','P','U','T'
     6DE2 4F55     
     6DE4 5450     
     6DE6 5554     
0196                       even
0197 6DE8 F806     tk.f8   byte   >F8,6,'U','P','D','A','T','E'
     6DEA 5550     
     6DEC 4441     
     6DEE 5445     
0198                       even
0199 6DF0 F906     tk.f9   byte   >F9,6,'A','P','P','E','N','D'
     6DF2 4150     
     6DF4 5045     
     6DF6 4E44     
0200                       even
0201 6DF8 FA06     tk.fa   byte   >FA,6,'F','I','X','E','D',' '
     6DFA 4649     
     6DFC 5845     
     6DFE 4420     
0202                       even
0203 6E00 FB09     tk.fb   byte   >FB,9,'P','E','R','M','A','N','E','N','T'
     6E02 5045     
     6E04 524D     
     6E06 414E     
     6E08 454E     
     6E0A 54       
0204                       even
0205 6E0C FC03     tk.fc   byte   >FC,3,'T','A','B'
     6E0E 5441     
     6E10 42       
0206                       even
0207 6E12 FD01     tk.fd   byte   >FD,1,'#'
     6E14 23       
0208                       even
0209 6E16 FF01     tk.noop byte   >FF,1,'?'
     6E18 3F       
0210                       even
0211               ;-----------------------------------------------------------------------
0212               ; Token index command mode
0213               ;-----------------------------------------------------------------------
0214 6E1A 6BA0     tki.00  data   tk.00               ; RUN
0215 6E1C 6BA6     tki.01  data   tk.01               ; NEW
0216 6E1E 6BAC     tki.02  data   tk.02               ; CON
0217 6E20 6BB2     tki.02l data   tk.02l              ; CONTINUE
0218 6E22 6BBC     tki.03  data   tk.03               ; LIST
0219 6E24 6BC2     tki.04  data   tk.04               ; BYE
0220 6E26 6BC8     tki.05  data   tk.05               ; NUM
0221 6E28 6BCE     tki.05l data   tk.05l              ; NUMBER
0222 6E2A 6BD6     tki.06  data   tk.06               ; OLD
0223 6E2C 6BDC     tki.07  data   tk.07               ; RES
0224 6E2E 6BE2     tki.07l data   tk.07l              ; RESEQUENCE
0225 6E30 6BEE     tki.08  data   tk.08               ; SAVE
0226 6E32 6BF4     tki.09  data   tk.09               ; EDIT
0227               ;-----------------------------------------------------------------------
0228               ; Token index program statement
0229               ;-----------------------------------------------------------------------
0230 6E34 6E16     tki.80  data   tk.noop             ;
0231 6E36 6BFA     tki.81  data   tk.81               ; ELSE
0232 6E38 6E16     tki.82  data   tk.noop             ;
0233 6E3A 6E16     tki.83  data   tk.noop             ;
0234 6E3C 6C02     tki.84  data   tk.84               ; IF
0235 6E3E 6C06     tki.85  data   tk.85               ; GO
0236 6E40 6C0A     tki.86  data   tk.86               ; GOTO
0237 6E42 6C10     tki.87  data   tk.87               ; GOSUB
0238 6E44 6C18     tki.88  data   tk.88               ; RETURN
0239 6E46 6C20     tki.89  data   tk.89               ; DEF
0240 6E48 6C26     tki.8a  data   tk.8a               ; DIM
0241 6E4A 6C2C     tki.8b  data   tk.8b               ; END
0242 6E4C 6C32     tki.8c  data   tk.8c               ; FOR
0243 6E4E 6C38     tki.8d  data   tk.8d               ; LET
0244 6E50 6C3E     tki.8e  data   tk.8e               ; BREAK
0245 6E52 6C46     tki.8f  data   tk.8f               ; UNBREAK
0246 6E54 6C50     tki.90  data   tk.90               ; TRACE
0247 6E56 6C58     tki.91  data   tk.91               ; UNTRACE
0248 6E58 6C62     tki.92  data   tk.92               ; INPUT
0249 6E5A 6C6A     tki.93  data   tk.93               ; DATA
0250 6E5C 6C70     tki.94  data   tk.94               ; RESTORE
0251 6E5E 6C7A     tki.95  data   tk.95               ; RANDOMIZE
0252 6E60 6C86     tki.96  data   tk.96               ; NEXT
0253 6E62 6C8C     tki.97  data   tk.97               ; READ
0254 6E64 6C92     tki.98  data   tk.98               ; STOP
0255 6E66 6C98     tki.99  data   tk.99               ; DELETE
0256 6E68 6CA0     tki.9a  data   tk.9a               ; REM
0257 6E6A 6CA6     tki.9b  data   tk.9b               ; ON
0258 6E6C 6CAA     tki.9c  data   tk.9c               ; PRINT
0259 6E6E 6CB2     tki.9d  data   tk.9d               ; CALL
0260 6E70 6CB8     tki.9e  data   tk.9e               ; OPTION
0261 6E72 6CC0     tki.9f  data   tk.9f               ; OPEN
0262 6E74 6CC6     tki.a0  data   tk.a0               ; CLOSE
0263 6E76 6CCE     tki.a1  data   tk.a1               ; SUB
0264 6E78 6CD4     tki.a2  data   tk.a2               ; DISPLAY
0265 6E7A 6E16     tki.a3  data   tk.noop             ;
0266 6E7C 6E16     tki.a4  data   tk.noop             ;
0267 6E7E 6E16     tki.a5  data   tk.noop             ;
0268 6E80 6E16     tki.a6  data   tk.noop             ;
0269 6E82 6E16     tki.a7  data   tk.noop             ;
0270 6E84 6E16     tki.a8  data   tk.noop             ;
0271 6E86 6E16     tki.a9  data   tk.noop             ;
0272 6E88 6E16     tki.aa  data   tk.noop             ;
0273 6E8A 6E16     tki.ab  data   tk.noop             ;
0274 6E8C 6E16     tki.ac  data   tk.noop             ;
0275 6E8E 6E16     tki.ad  data   tk.noop             ;
0276 6E90 6E16     tki.ae  data   tk.noop             ;
0277 6E92 6E16     tki.af  data   tk.noop             ;
0278 6E94 6CDE     tki.b0  data   tk.b0               ; THEN
0279 6E96 6CE6     tki.b1  data   tk.b1               ; TO
0280 6E98 6CEC     tki.b2  data   tk.b2               ; STEP
0281 6E9A 6CF4     tki.b3  data   tk.b3               ; ,
0282 6E9C 6CF8     tki.b4  data   tk.b4               ; ;
0283 6E9E 6CFC     tki.b5  data   tk.b5               ; :
0284 6EA0 6D00     tki.b6  data   tk.b6               ; )
0285 6EA2 6D04     tki.b7  data   tk.b7               ; (
0286 6EA4 6D08     tki.b8  data   tk.b8               ; &
0287 6EA6 6E16     tki.b9  data   tk.noop             ;
0288 6EA8 6E16     tki.ba  data   tk.noop             ;
0289 6EAA 6E16     tki.bb  data   tk.noop             ;
0290 6EAC 6E16     tki.bc  data   tk.noop             ;
0291 6EAE 6E16     tki.bd  data   tk.noop             ;
0292 6EB0 6D0C     tki.be  data   tk.be               ; =
0293 6EB2 6D10     tki.bf  data   tk.bf               ; <
0294 6EB4 6D14     tki.c0  data   tk.c0               ; >
0295 6EB6 6D18     tki.c1  data   tk.c1               ; +
0296 6EB8 6D1C     tki.c2  data   tk.c2               ; -
0297 6EBA 6D20     tki.c3  data   tk.c3               ; *
0298 6EBC 6D24     tki.c4  data   tk.c4               ; /
0299 6EBE 6D28     tki.c5  data   tk.c5               ; ^
0300 6EC0 6E16     tki.c6  data   tk.noop             ;
0301 6EC2 6D2C     tki.c7  data   tk.c7               ; Quoted string
0302 6EC4 6D30     tki.c8  data   tk.c8               ; Unquoted string
0303 6EC6 6D34     tki.c9  data   tk.c9               ; Line number
0304 6EC8 6D38     tki.ca  data   tk.ca               ; EOF
0305 6ECA 6D3E     tki.cb  data   tk.cb               ; ABS
0306 6ECC 6D44     tki.cc  data   tk.cc               ; ATN
0307 6ECE 6D4A     tki.cd  data   tk.cd               ; COS
0308 6ED0 6D50     tki.ce  data   tk.ce               ; EXP
0309 6ED2 6D56     tki.cf  data   tk.cf               ; INT
0310 6ED4 6D5C     tki.d0  data   tk.d0               ; LOG
0311 6ED6 6D62     tki.d1  data   tk.d1               ; SGN
0312 6ED8 6D68     tki.d2  data   tk.d2               ; SIN
0313 6EDA 6D6E     tki.d3  data   tk.d3               ; SQR
0314 6EDC 6D74     tki.d4  data   tk.d4               ; TAN
0315 6EDE 6D7A     tki.d5  data   tk.d5               ; LEN
0316 6EE0 6D80     tki.d6  data   tk.d6               ; CHAR$
0317 6EE2 6D86     tki.d7  data   tk.d7               ; RND
0318 6EE4 6D8C     tki.d8  data   tk.d8               ; SEG$
0319 6EE6 6D92     tki.d9  data   tk.d9               ; POS
0320 6EE8 6D98     tki.da  data   tk.da               ; VAL
0321 6EEA 6D9E     tki.db  data   tk.db               ; STR$
0322 6EEC 6DA4     tki.dc  data   tk.dc               ; ASC
0323 6EEE 6E16     tki.dd  data   tk.noop             ;
0324 6EF0 6DAA     tki.de  data   tk.de               ; REC
0325 6EF2 6E16     tki.df  data   tk.noop             ;
0326 6EF4 6E16     tki.e0  data   tk.noop             ;
0327 6EF6 6E16     tki.e1  data   tk.noop             ;
0328 6EF8 6E16     tki.e2  data   tk.noop             ;
0329 6EFA 6E16     tki.e3  data   tk.noop             ;
0330 6EFC 6E16     tki.e4  data   tk.noop             ;
0331 6EFE 6E16     tki.e5  data   tk.noop             ;
0332 6F00 6E16     tki.e6  data   tk.noop             ;
0333 6F02 6E16     tki.e7  data   tk.noop             ;
0334 6F04 6E16     tki.e8  data   tk.noop             ;
0335 6F06 6E16     tki.e9  data   tk.noop             ;
0336 6F08 6E16     tki.ea  data   tk.noop             ;
0337 6F0A 6E16     tki.eb  data   tk.noop             ;
0338 6F0C 6E16     tki.ec  data   tk.noop             ;
0339 6F0E 6E16     tki.ed  data   tk.noop             ;
0340 6F10 6E16     tki.ee  data   tk.noop             ;
0341 6F12 6E16     tki.ef  data   tk.noop             ;
0342 6F14 6E16     tki.f0  data   tk.noop             ;
0343 6F16 6DB0     tki.f1  data   tk.f1               ; BASE
0344 6F18 6E16     tki.f2  data   tk.noop             ;
0345 6F1A 6DB6     tki.f3  data   tk.f3               ; VARIABLE
0346 6F1C 6DC0     tki.f4  data   tk.f4               ; RELATIVE
0347 6F1E 6DCA     tki.f5  data   tk.f5               ; INTERNAL
0348 6F20 6DD4     tki.f6  data   tk.f6               ; SEQUENTIAL
0349 6F22 6DE0     tki.f7  data   tk.f7               ; OUTPUT
0350 6F24 6DE8     tki.f8  data   tk.f8               ; UPDATE
0351 6F26 6DF0     tki.f9  data   tk.f9               ; APPEND
0352 6F28 6DF8     tki.fa  data   tk.fa               ; FIXED
0353 6F2A 6E00     tki.fb  data   tk.fb               ; PERMANENT
0354 6F2C 6E0C     tki.fc  data   tk.fc               ; TAB
0355 6F2E 6E12     tki.fd  data   tk.fd               ; #
0356 6F30 6E16     tki.fe  data   tk.noop             ;
0357 6F32 6E16     tki.ff  data   tk.noop             ; <NOOP>
0358               
0359      6E34     tib.tokenindex equ tki.80
                   < stevie_b7.asm.16732
0087                       ;-----------------------------------------------------------------------
0088                       ; Scratchpad memory dump
0089                       ;-----------------------------------------------------------------------
0090                       aorg >7e00
0091                       copy  "data.scrpad.asm"          ; Required for TI Basic
     **** ****     > data.scrpad.asm
0001               * FILE......: data.scrpad.asm
0002               * Purpose...: Stevie Editor - data segment (scratchpad dump)
0003               
0004               ***************************************************************
0005               *    TI MONITOR scratchpad dump on cartridge menu screen
0006               ***************************************************************
0007               
0008               scrpad.monitor:
0009                       ;-------------------------------------------------------
0010                       ; Scratchpad TI monitor on cartridge selection screen
0011                       ;-------------------------------------------------------
0012 7E00 0000             byte  >00,>00,>21,>4D,>00,>00,>00,>00    ; >8300 - >8307
     7E02 214D     
     7E04 0000     
     7E06 0000     
0013 7E08 0000             byte  >00,>00,>00,>00,>00,>00,>00,>00    ; >8308 - >830f
     7E0A 0000     
     7E0C 0000     
     7E0E 0000     
0014 7E10 0000             byte  >00,>00,>00,>00,>00,>00,>00,>00    ; >8310 - >8317
     7E12 0000     
     7E14 0000     
     7E16 0000     
0015 7E18 0000             byte  >00,>00,>00,>00,>00,>00,>00,>00    ; >8318 - >831f
     7E1A 0000     
     7E1C 0000     
     7E1E 0000     
0016 7E20 0000             byte  >00,>00,>00,>00,>00,>00,>00,>00    ; >8320 - >8327
     7E22 0000     
     7E24 0000     
     7E26 0000     
0017 7E28 0000             byte  >00,>00,>00,>00,>00,>00,>00,>00    ; >8328 - >832f
     7E2A 0000     
     7E2C 0000     
     7E2E 0000     
0018 7E30 0000             byte  >00,>00,>00,>00,>00,>00,>00,>00    ; >8330 - >8337
     7E32 0000     
     7E34 0000     
     7E36 0000     
0019 7E38 0000             byte  >00,>00,>00,>00,>00,>00,>00,>00    ; >8338 - >833f
     7E3A 0000     
     7E3C 0000     
     7E3E 0000     
0020 7E40 0000             byte  >00,>00,>60,>13,>00,>00,>00,>00    ; >8340 - >8347
     7E42 6013     
     7E44 0000     
     7E46 0000     
0021 7E48 0000             byte  >00,>00,>00,>00,>00,>00,>00,>00    ; >8348 - >834f
     7E4A 0000     
     7E4C 0000     
     7E4E 0000     
0022 7E50 0000             byte  >00,>00,>01,>24,>00,>00,>00,>00    ; >8350 - >8357
     7E52 0124     
     7E54 0000     
     7E56 0000     
0023 7E58 311E             byte  >31,>1E,>00,>00,>00,>00,>00,>08    ; >8358 - >835f
     7E5A 0000     
     7E5C 0000     
     7E5E 0008     
0024 7E60 0000             byte  >00,>00,>00,>00,>00,>00,>00,>00    ; >8360 - >8367
     7E62 0000     
     7E64 0000     
     7E66 0000     
0025 7E68 0000             byte  >00,>00,>21,>52,>01,>06,>00,>00    ; >8368 - >836f
     7E6A 2152     
     7E6C 0106     
     7E6E 0000     
0026 7E70 37D7             byte  >37,>D7,>FE,>7E,>00,>FF,>00,>00    ; >8370 - >8377
     7E72 FE7E     
     7E74 00FF     
     7E76 0000     
0027 7E78 52D2             byte  >52,>D2,>00,>E4,>00,>00,>05,>09    ; >8378 - >837f
     7E7A 00E4     
     7E7C 0000     
     7E7E 0509     
0028 7E80 02FA             byte  >02,>FA,>03,>85,>00,>00,>00,>00    ; >8380 - >8387
     7E82 0385     
     7E84 0000     
     7E86 0000     
0029 7E88 0000             byte  >00,>00,>00,>00,>00,>00,>00,>00    ; >8388 - >838f
     7E8A 0000     
     7E8C 0000     
     7E8E 0000     
0030 7E90 0000             byte  >00,>00,>00,>00,>00,>00,>00,>00    ; >8390 - >8397
     7E92 0000     
     7E94 0000     
     7E96 0000     
0031 7E98 0000             byte  >00,>00,>00,>00,>00,>00,>00,>00    ; >8398 - >839f
     7E9A 0000     
     7E9C 0000     
     7E9E 0000     
0032 7EA0 0000             byte  >00,>00,>00,>00,>00,>00,>00,>00    ; >83A0 - >83a7
     7EA2 0000     
     7EA4 0000     
     7EA6 0000     
0033 7EA8 0000             byte  >00,>00,>00,>00,>00,>00,>00,>00    ; >83A8 - >83af
     7EAA 0000     
     7EAC 0000     
     7EAE 0000     
0034 7EB0 0000             byte  >00,>00,>00,>00,>00,>00,>00,>00    ; >83B0 - >83b7
     7EB2 0000     
     7EB4 0000     
     7EB6 0000     
0035 7EB8 0000             byte  >00,>00,>00,>00,>00,>00,>00,>00    ; >83B8 - >83bf
     7EBA 0000     
     7EBC 0000     
     7EBE 0000     
0036 7EC0 5209             byte  >52,>09,>00,>00,>00,>00,>00,>00    ; >83C0 - >83c7
     7EC2 0000     
     7EC4 0000     
     7EC6 0000     
0037 7EC8 FFFF             byte  >FF,>FF,>FF,>00,>04,>84,>00,>00    ; >83C8 - >83cf
     7ECA FF00     
     7ECC 0484     
     7ECE 0000     
0038 7ED0 9804             byte  >98,>04,>E0,>00,>E0,>d5,>0A,>A6    ; >83D0 - >83d7
     7ED2 E000     
     7ED4 E0D5     
     7ED6 0AA6     
0039 7ED8 0070             byte  >00,>70,>83,>E0,>00,>74,>D0,>02    ; >83D8 - >83df
     7EDA 83E0     
     7EDC 0074     
     7EDE D002     
0040 7EE0 FFFF             byte  >FF,>FF,>FF,>FF,>00,>00,>04,>84    ; >83E0 - >83e7
     7EE2 FFFF     
     7EE4 0000     
     7EE6 0484     
0041 7EE8 0080             byte  >00,>80,>00,>00,>00,>00,>00,>00    ; >83E8 - >83ef
     7EEA 0000     
     7EEC 0000     
     7EEE 0000     
0042 7EF0 0000             byte  >00,>00,>00,>06,>05,>20,>04,>80    ; >83F0 - >83f7
     7EF2 0006     
     7EF4 0520     
     7EF6 0480     
0043 7EF8 0006             byte  >00,>06,>98,>00,>01,>08,>8C,>02    ; >83F8 - >83ff
     7EFA 9800     
     7EFC 0108     
     7EFE 8C02     
                   < stevie_b7.asm.16732
0092                       ;-----------------------------------------------------------------------
0093                       ; Bank full check
0094                       ;-----------------------------------------------------------------------
0098                       ;-----------------------------------------------------------------------
0099                       ; Show ROM bank in CPU crash screen
0100                       ;-----------------------------------------------------------------------
0101                       copy "rom.crash.asm"
     **** ****     > rom.crash.asm
0001               * FILE......: rom.crash.asm
0002               * Purpose...: Show ROM bank number on CPU crash
0003               
0004               ***************************************************************
0005               * Show ROM bank number on CPU crash
0006               ********|*****|*********************|**************************
0007               cpu.crash.showbank:
0008                       aorg  bankx.crash.showbank
0009 7F00 06A0  32         bl    @putat
     7F02 2456     
0010 7F04 0314                   byte 3,20
0011 7F06 7F0A                   data cpu.crash.showbank.bankstr
0012 7F08 10FF  14         jmp   $
                   < stevie_b7.asm.16732
0102                       ;-----------------------------------------------------------------------
0103                       ; Vector table
0104                       ;-----------------------------------------------------------------------
0105                       copy  "rom.vectors.bank7.asm"    ; Vector table bank 7
     **** ****     > rom.vectors.bank7.asm
0001               * FILE......: rom.vectors.bank7.asm
0002               * Purpose...: Bank 7 vectors for trampoline function
0003               
0004               *--------------------------------------------------------------
0005               * ROM identification string for CPU crash
0006               *--------------------------------------------------------------
0007               cpu.crash.showbank.bankstr:
0008               
0009 7F0A 05               byte  5
0010 7F0B   52             text  'ROM#7'
     7F0C 4F4D     
     7F0E 2337     
0011                       even
0012               
0013               
0014               *--------------------------------------------------------------
0015               * Vector table for trampoline functions
0016               *--------------------------------------------------------------
0017                       aorg  bankx.vectab
0018               
0019 7FC0 60CC     vec.1   data  mem.sams.set.legacy   ;
0020 7FC2 6104     vec.2   data  mem.sams.set.boot     ;
0021 7FC4 612E     vec.3   data  mem.sams.set.stevie   ;
0022 7FC6 610A     vec.4   data  mem.sams.set.external ;
0023 7FC8 6110     vec.5   data  mem.sams.set.basic1   ;
0024 7FCA 6116     vec.6   data  mem.sams.set.basic2   ;
0025 7FCC 611C     vec.7   data  mem.sams.set.basic3   ;
0026 7FCE 6122     vec.8   data  mem.sams.set.basic4   ;
0027 7FD0 6128     vec.9   data  mem.sams.set.basic5   ;
0028 7FD2 618C     vec.10  data  tib.run               ;
0029 7FD4 65CC     vec.11  data  tib.uncrunch          ;
0030 7FD6 2026     vec.12  data  cpu.crash             ;
0031 7FD8 2026     vec.13  data  cpu.crash             ;
0032 7FDA 2026     vec.14  data  cpu.crash             ;
0033 7FDC 2026     vec.15  data  cpu.crash             ;
0034 7FDE 2026     vec.16  data  cpu.crash             ;
0035 7FE0 2026     vec.17  data  cpu.crash             ;
0036 7FE2 2026     vec.18  data  cpu.crash             ;
0037 7FE4 2026     vec.19  data  cpu.crash             ;
0038 7FE6 604A     vec.20  data  magic.set             ;
0039 7FE8 6064     vec.21  data  magic.clear           ;
0040 7FEA 6078     vec.22  data  magic.check           ;
0041 7FEC 2026     vec.23  data  cpu.crash             ;
0042 7FEE 2026     vec.24  data  cpu.crash             ;
0043 7FF0 2026     vec.25  data  cpu.crash             ;
0044 7FF2 2026     vec.26  data  cpu.crash             ;
0045 7FF4 2026     vec.27  data  cpu.crash             ;
0046 7FF6 2026     vec.28  data  cpu.crash             ;
0047 7FF8 2026     vec.29  data  cpu.crash             ;
0048 7FFA 2026     vec.30  data  cpu.crash             ;
0049 7FFC 2026     vec.31  data  cpu.crash             ;
0050 7FFE 2026     vec.32  data  cpu.crash             ;
                   < stevie_b7.asm.16732
0106               
0107               *--------------------------------------------------------------
0108               * Video mode configuration
0109               *--------------------------------------------------------------
0110      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0111      0004     spfbck  equ   >04                   ; Screen background color.
0112      3664     spvmod  equ   stevie.80x30          ; Video mode.   See VIDTAB for details.
0113      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0114      0050     colrow  equ   80                    ; Columns per row
0115      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0116      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0117      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0118      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table

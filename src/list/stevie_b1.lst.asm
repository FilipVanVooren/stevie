XAS99 CROSS-ASSEMBLER   VERSION 3.1.0
     **** ****     > stevie_b1.asm.33260
0001               ***************************************************************
0002               *                          Stevie
0003               *
0004               *       A 21th century Programming Editor for the 1981
0005               *         Texas Instruments TI-99/4a Home Computer.
0006               *
0007               *              (c)2018-2022 // Filip van Vooren
0008               ***************************************************************
0009               * File: stevie_b1.asm               ; Version 220328-2048340
0010               *
0011               * Bank 1 "James"
0012               * Editor core
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
                   < stevie_b1.asm.33260
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
                   < stevie_b1.asm.33260
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
0200      A0C0     tib.automode      equ  core1.top + 192 ; TI-Basic AutoMode (crunch/uncrunch)
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
0272      A310     fb.vwco           equ  fb.struct + 16  ; View window column offset (0-xxx)
0273      A312     fb.colorize       equ  fb.struct + 18  ; M1/M2 colorize refresh required
0274      A314     fb.curtoggle      equ  fb.struct + 20  ; Cursor shape toggle
0275      A316     fb.yxsave         equ  fb.struct + 22  ; Copy of cursor YX position
0276      A318     fb.dirty          equ  fb.struct + 24  ; Frame buffer dirty flag
0277      A31A     fb.status.dirty   equ  fb.struct + 26  ; Status line(s) dirty flag
0278      A31C     fb.scrrows        equ  fb.struct + 28  ; Rows on physical screen for framebuffer
0279      A31E     fb.scrrows.max    equ  fb.struct + 30  ; Max # of rows on physical screen for fb
0280      A320     fb.ruler.sit      equ  fb.struct + 32  ; 80 char ruler  (no length-prefix!)
0281      A370     fb.ruler.tat      equ  fb.struct + 112 ; 80 char colors (no length-prefix!)
0282      A3C0     fb.free           equ  fb.struct + 192 ; End of structure
0283               *--------------------------------------------------------------
0284               * File handle structure               @>a400-a4ff   (256 bytes)
0285               *--------------------------------------------------------------
0286      A400     fh.struct         equ  >a400           ; stevie file handling structures
0287               ;***********************************************************************
0288               ; ATTENTION
0289               ; The dsrlnk variables must form a continuous memory block and keep
0290               ; their order!
0291               ;***********************************************************************
0292      A400     dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
0293      A420     dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
0294      A428     dsrlnk.sav8a      equ  fh.struct + 40  ; Save parm (8 or A) after "blwp @dsrlnk"
0295      A42A     dsrlnk.savcru     equ  fh.struct + 42  ; CRU address of device in prev. DSR call
0296      A42C     dsrlnk.savent     equ  fh.struct + 44  ; DSR entry addr of prev. DSR call
0297      A42E     dsrlnk.savpab     equ  fh.struct + 46  ; Pointer to Device or Subprogram in PAB
0298      A430     dsrlnk.savver     equ  fh.struct + 48  ; Version used in prev. DSR call
0299      A432     dsrlnk.savlen     equ  fh.struct + 50  ; Length of DSR name of prev. DSR call
0300      A434     dsrlnk.flgptr     equ  fh.struct + 52  ; Pointer to VDP PAB byte 1 (flag byte)
0301      A436     fh.pab.ptr        equ  fh.struct + 54  ; Pointer to VDP PAB, for level 3 FIO
0302      A438     fh.pabstat        equ  fh.struct + 56  ; Copy of VDP PAB status byte
0303      A43A     fh.ioresult       equ  fh.struct + 58  ; DSRLNK IO-status after file operation
0304      A43C     fh.records        equ  fh.struct + 60  ; File records counter
0305      A43E     fh.reclen         equ  fh.struct + 62  ; Current record length
0306      A440     fh.kilobytes      equ  fh.struct + 64  ; Kilobytes processed (read/written)
0307      A442     fh.counter        equ  fh.struct + 66  ; Counter used in stevie file operations
0308      A444     fh.fname.ptr      equ  fh.struct + 68  ; Pointer to device and filename
0309      A446     fh.sams.page      equ  fh.struct + 70  ; Current SAMS page during file operation
0310      A448     fh.sams.hipage    equ  fh.struct + 72  ; Highest SAMS page in file operation
0311      A44A     fh.fopmode        equ  fh.struct + 74  ; FOP mode (File Operation Mode)
0312      A44C     fh.filetype       equ  fh.struct + 76  ; Value for filetype/mode (PAB byte 1)
0313      A44E     fh.offsetopcode   equ  fh.struct + 78  ; Set to >40 for skipping VDP buffer
0314      A450     fh.callback1      equ  fh.struct + 80  ; Pointer to callback function 1
0315      A452     fh.callback2      equ  fh.struct + 82  ; Pointer to callback function 2
0316      A454     fh.callback3      equ  fh.struct + 84  ; Pointer to callback function 3
0317      A456     fh.callback4      equ  fh.struct + 86  ; Pointer to callback function 4
0318      A458     fh.callback5      equ  fh.struct + 88  ; Pointer to callback function 5
0319      A45A     fh.workmode       equ  fh.struct + 90  ; Working mode (used in callbacks)
0320      A45C     fh.kilobytes.prev equ  fh.struct + 92  ; Kilobytes processed (previous)
0321      A45E     fh.line           equ  fh.struct + 94  ; Editor buffer line currently processing
0322      A460     fh.temp1          equ  fh.struct + 96  ; Temporary variable 1
0323      A462     fh.temp2          equ  fh.struct + 98  ; Temporary variable 2
0324      A464     fh.temp3          equ  fh.struct +100  ; Temporary variable 3
0325      A466     fh.membuffer      equ  fh.struct +102  ; 80 bytes file memory buffer
0326      A4B6     fh.free           equ  fh.struct +182  ; End of structure
0327      0960     fh.vrecbuf        equ  >0960           ; VDP address record buffer
0328      0A60     fh.vpab           equ  >0a60           ; VDP address PAB
0329               *--------------------------------------------------------------
0330               * Editor buffer structure             @>a500-a5ff   (256 bytes)
0331               *--------------------------------------------------------------
0332      A500     edb.struct        equ  >a500           ; Begin structure
0333      A500     edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
0334      A502     edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
0335      A504     edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer - 1
0336      A506     edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
0337      A508     edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
0338      A50A     edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
0339      A50C     edb.block.m1      equ  edb.struct + 12 ; Block start line marker (>ffff = unset)
0340      A50E     edb.block.m2      equ  edb.struct + 14 ; Block end line marker   (>ffff = unset)
0341      A510     edb.block.var     equ  edb.struct + 16 ; Local var used in block operation
0342      A512     edb.filename.ptr  equ  edb.struct + 18 ; Pointer to length-prefixed string
0343                                                      ; with current filename.
0344      A514     edb.filetype.ptr  equ  edb.struct + 20 ; Pointer to length-prefixed string
0345                                                      ; with current file type.
0346      A516     edb.sams.page     equ  edb.struct + 22 ; Current SAMS page
0347      A518     edb.sams.hipage   equ  edb.struct + 24 ; Highest SAMS page in use
0348      A51A     edb.filename      equ  edb.struct + 26 ; 80 characters inline buffer reserved
0349                                                      ; for filename, but not always used.
0350      A56A     edb.free          equ  edb.struct + 106; End of structure
0351               *--------------------------------------------------------------
0352               * Index structure                     @>a600-a6ff   (256 bytes)
0353               *--------------------------------------------------------------
0354      A600     idx.struct        equ  >a600           ; stevie index structure
0355      A600     idx.sams.page     equ  idx.struct      ; Current SAMS page
0356      A602     idx.sams.lopage   equ  idx.struct + 2  ; Lowest SAMS page
0357      A604     idx.sams.hipage   equ  idx.struct + 4  ; Highest SAMS page
0358      A606     idx.free          equ  idx.struct + 6  ; End of structure
0359               *--------------------------------------------------------------
0360               * Command buffer structure            @>a700-a7ff   (256 bytes)
0361               *--------------------------------------------------------------
0362      A700     cmdb.struct       equ  >a700           ; Command Buffer structure
0363      A700     cmdb.top.ptr      equ  cmdb.struct     ; Pointer to command buffer (history)
0364      A702     cmdb.visible      equ  cmdb.struct + 2 ; Command buffer visible? (>ffff=visible)
0365      A704     cmdb.fb.yxsave    equ  cmdb.struct + 4 ; Copy of FB WYX when entering cmdb pane
0366      A706     cmdb.scrrows      equ  cmdb.struct + 6 ; Current size of CMDB pane (in rows)
0367      A708     cmdb.default      equ  cmdb.struct + 8 ; Default size of CMDB pane (in rows)
0368      A70A     cmdb.cursor       equ  cmdb.struct + 10; Screen YX of cursor in CMDB pane
0369      A70C     cmdb.yxsave       equ  cmdb.struct + 12; Copy of WYX
0370      A70E     cmdb.yxtop        equ  cmdb.struct + 14; YX position of CMDB pane header line
0371      A710     cmdb.yxprompt     equ  cmdb.struct + 16; YX position of command buffer prompt
0372      A712     cmdb.column       equ  cmdb.struct + 18; Current column in command buffer pane
0373      A714     cmdb.length       equ  cmdb.struct + 20; Length of current row in CMDB
0374      A716     cmdb.lines        equ  cmdb.struct + 22; Total lines in CMDB
0375      A718     cmdb.dirty        equ  cmdb.struct + 24; Command buffer dirty (Text changed!)
0376      A71A     cmdb.dialog       equ  cmdb.struct + 26; Dialog identifier
0377      A71C     cmdb.dialog.var   equ  cmdb.struct + 28; Dialog private variable or pointer
0378      A71E     cmdb.panhead      equ  cmdb.struct + 30; Pointer to string pane header
0379      A720     cmdb.paninfo      equ  cmdb.struct + 32; Pointer to string pane info (1st line)
0380      A722     cmdb.panhint      equ  cmdb.struct + 34; Pointer to string pane hint (2nd line)
0381      A724     cmdb.panmarkers   equ  cmdb.struct + 36; Pointer to key marker list  (3rd line)
0382      A726     cmdb.pankeys      equ  cmdb.struct + 38; Pointer to string pane keys (stat line)
0383      A728     cmdb.action.ptr   equ  cmdb.struct + 40; Pointer to function to execute
0384      A72A     cmdb.cmdall       equ  cmdb.struct + 42; Current command including length-byte
0385      A72A     cmdb.cmdlen       equ  cmdb.struct + 42; Length of current command (MSB byte!)
0386      A72B     cmdb.cmd          equ  cmdb.struct + 43; Current command (80 bytes max.)
0387      A77C     cmdb.panhead.buf  equ  cmdb.struct +124; String buffer for pane header
0388      A7AE     cmdb.dflt.fname   equ  cmdb.struct +174; Default for filename
0389      A800     cmdb.free         equ  cmdb.struct +256; End of structure
0390               *--------------------------------------------------------------
0391               * Stevie value stack                  @>a800-a8ff   (256 bytes)
0392               *--------------------------------------------------------------
0393      A900     sp2.stktop        equ  >a900           ; \
0394                                                      ; | The stack grows from high memory
0395                                                      ; | towards low memory.
0396                                                      ; |
0397                                                      ; | Stack leaking is checked in SP2
0398                                                      ; | user hook "edkey.keyscan.hook"
0399                                                      ; /
0400               *--------------------------------------------------------------
0401               * Scratchpad memory work copy         @>ad00-aeff   (256 bytes)
0402               *--------------------------------------------------------------
0403      7E00     cpu.scrpad.src    equ  >7e00           ; \ Dump of OS monitor scratchpad
0404                                                      ; / stored in cartridge ROM bank7.asm
0405               
0406      F000     cpu.scrpad.tgt    equ  >f000           ; \ Fixed memory location used for
0407                                                      ; | scratchpad backup/restore routines.
0408                                                      ; /
0409               
0410      8300     cpu.scrpad1       equ  >8300           ; Stevie primary scratchpad
0411               
0412      AD00     cpu.scrpad2       equ  >ad00           ; Stevie secondary scratchpad, used when
0413                                                      ; calling TI Basic/External programs
0414               
0415               *--------------------------------------------------------------
0416               * Farjump return stack                @>af00-afff   (256 bytes)
0417               *--------------------------------------------------------------
0418      B000     fj.bottom         equ  >b000           ; Return stack for trampoline function
0419                                                      ; Grows downwards from high to low.
0420               *--------------------------------------------------------------
0421               * Index                               @>b000-bfff  (4096 bytes)
0422               *--------------------------------------------------------------
0423      B000     idx.top           equ  >b000           ; Top of index
0424      1000     idx.size          equ  4096            ; Index size
0425               *--------------------------------------------------------------
0426               * Editor buffer                       @>c000-cfff  (4096 bytes)
0427               *--------------------------------------------------------------
0428      C000     edb.top           equ  >c000           ; Editor buffer high memory
0429      1000     edb.size          equ  4096            ; Editor buffer size
0430               *--------------------------------------------------------------
0431               * Frame buffer & uncrunch area        @>d000-dcff  (3584 bytes)
0432               *--------------------------------------------------------------
0433      D000     fb.top            equ  >d000           ; Frame buffer (2400 char)
0434      0960     fb.size           equ  80*30           ; Frame buffer size
0435      D960     fb.uncrunch.area  equ  >d960           ; \ Uncrunched TI Basic statement
0436                                                      ; / >d960->dcff
0437               *--------------------------------------------------------------
0438               * Defaults area                       @>de00-dfff  (3584 bytes)
0439               *--------------------------------------------------------------
0440      DE00     tv.printer.fname  equ  >de00           ; Default printer   (80 char)
0441      DE50     tv.clip.fname     equ  >de50           ; Default clipboard (80 char)
0442               *--------------------------------------------------------------
0443               * Command buffer history              @>e000-efff  (4096 bytes)
0444               *--------------------------------------------------------------
0445      E000     cmdb.top          equ  >e000           ; Top of command history buffer
0446      1000     cmdb.size         equ  4096            ; Command buffer size
0447               *--------------------------------------------------------------
0448               * Heap                                @>f000-ffff  (4096 bytes)
0449               *--------------------------------------------------------------
0450      F000     heap.top          equ  >f000           ; Top of heap
0451               
0452               
0453               *--------------------------------------------------------------
0454               * Stevie specific equates
0455               *--------------------------------------------------------------
0456      0000     fh.fopmode.none           equ  0       ; No file operation in progress
0457      0001     fh.fopmode.readfile       equ  1       ; Read file from disk to memory
0458      0002     fh.fopmode.writefile      equ  2       ; Save file from memory to disk
0459      A028     rom0_kscan_out            equ  keycode1; Where to store value of key pressed
0460               
0461      0050     vdp.fb.toprow.sit         equ  >0050   ; VDP SIT address of 1st Framebuffer row
0462      1850     vdp.fb.toprow.tat         equ  >1850   ; VDP TAT address of 1st Framebuffer row
0463      1DF0     vdp.cmdb.toprow.tat       equ  >1800 + ((pane.botrow - 4) * 80)
0464                                                      ; VDP TAT address of 1st CMDB row
0465      0000     vdp.sit.base              equ  >0000   ; VDP SIT base address
0466      0780     vdp.sit.size              equ  (pane.botrow + 1) * 80
0467                                                      ; VDP SIT size 80 columns, 24/30 rows
0468      1800     vdp.tat.base              equ  >1800   ; VDP TAT base address
0469      9900     tv.colorize.reset         equ  >9900   ; Colorization off
0470      00FE     tv.1timeonly              equ  254     ; One-time only flag indicator
                   < stevie_b1.asm.33260
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
                   < stevie_b1.asm.33260
0018               
0019               ***************************************************************
0020               * BANK 1
0021               ********|*****|*********************|**************************
0022      6002     bankid  equ   bank1.rom             ; Set bank identifier to current bank
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
0061 6011   53             text  'STEVIE 1.3E (24X80)'
     6012 5445     
     6014 5649     
     6016 4520     
     6018 312E     
     601A 3345     
     601C 2028     
     601E 3234     
     6020 5838     
     6022 3029     
0062                       even
0063               
0065               
                   < stevie_b1.asm.33260
0026               
0027               ***************************************************************
0028               * Step 1: Switch to bank 0 (uniform code accross all banks)
0029               ********|*****|*********************|**************************
0030                       aorg  kickstart.code1       ; >6040
0031 6040 04E0  34         clr   @bank0.rom            ; Switch to bank 0 "Jill"
     6042 6000     
0032               ***************************************************************
0033               * Step 2: Satisfy assembler, must know relocated code
0034               ********|*****|*********************|**************************
0035                       aorg  >2000                 ; Relocate to >2000
0036                       copy  "runlib.asm"
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
0265 21D1   53             text  'Source    stevie_b1.lst.asm'
     21D2 6F75     
     21D4 7263     
     21D6 6520     
     21D8 2020     
     21DA 2073     
     21DC 7465     
     21DE 7669     
     21E0 655F     
     21E2 6231     
     21E4 2E6C     
     21E6 7374     
     21E8 2E61     
     21EA 736D     
0266                       even
0267               
0268               cpu.crash.msg.id
0269 21EC 18               byte  24
0270 21ED   42             text  'Build-ID  220328-2048340'
     21EE 7569     
     21F0 6C64     
     21F2 2D49     
     21F4 4420     
     21F6 2032     
     21F8 3230     
     21FA 3332     
     21FC 382D     
     21FE 3230     
     2200 3438     
     2202 3334     
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
0365 2F60 3650             data  spvmod                ; Equate selected video mode table
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
                   < stevie_b1.asm.33260
0037                       copy  "ram.resident.asm"
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
0037 303C 04E0  34         clr   @fb.vwco              ; Set view window column offset
     303E A310     
0038                       ;------------------------------------------------------
0039                       ; Determine size of rows on screen
0040                       ;------------------------------------------------------
0041 3040 C160  34         mov   @tv.ruler.visible,tmp1
     3042 A210     
0042 3044 1303  14         jeq   !                     ; Skip if ruler is hidden
0043 3046 0204  20         li    tmp0,pane.botrow-2
     3048 0015     
0044 304A 1002  14         jmp   fb.init.cont
0045 304C 0204  20 !       li    tmp0,pane.botrow-1
     304E 0016     
0046                       ;------------------------------------------------------
0047                       ; Continue initialisation
0048                       ;------------------------------------------------------
0049               fb.init.cont:
0050 3050 C804  38         mov   tmp0,@fb.scrrows      ; Physical rows on screen for fb
     3052 A31C     
0051 3054 C804  38         mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb
     3056 A31E     
0052               
0053 3058 04E0  34         clr   @tv.pane.focus        ; Frame buffer has focus!
     305A A222     
0054 305C 04E0  34         clr   @fb.colorize          ; Don't colorize M1/M2 lines
     305E A312     
0055 3060 0720  34         seto  @fb.dirty             ; Set dirty flag (trigger screen update)
     3062 A318     
0056 3064 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     3066 A31A     
0057                       ;------------------------------------------------------
0058                       ; Clear frame buffer
0059                       ;------------------------------------------------------
0060 3068 06A0  32         bl    @film
     306A 224A     
0061 306C D000             data  fb.top,>00,fb.size    ; Clear it all the way
     306E 0000     
     3070 0960     
0062                       ;------------------------------------------------------
0063                       ; Exit
0064                       ;------------------------------------------------------
0065               fb.init.exit:
0066 3072 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0067 3074 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0068 3076 C2F9  30         mov   *stack+,r11           ; Pop r11
0069 3078 045B  20         b     *r11                  ; Return to caller
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
0024 307A 0649  14         dect  stack
0025 307C C64B  30         mov   r11,*stack            ; Save return address
0026 307E 0649  14         dect  stack
0027 3080 C644  30         mov   tmp0,*stack           ; Push tmp0
0028                       ;------------------------------------------------------
0029                       ; Calculate line in editor buffer
0030                       ;------------------------------------------------------
0031 3082 C120  34         mov   @parm1,tmp0
     3084 A006     
0032 3086 A120  34         a     @fb.topline,tmp0
     3088 A304     
0033 308A C804  38         mov   tmp0,@outparm1
     308C A016     
0034                       ;------------------------------------------------------
0035                       ; Exit
0036                       ;------------------------------------------------------
0037               fb.row2line.exit:
0038 308E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0039 3090 C2F9  30         mov   *stack+,r11           ; Pop r11
0040 3092 045B  20         b     *r11                  ; Return to caller
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
0068 3094 0649  14         dect  stack
0069 3096 C64B  30         mov   r11,*stack            ; Save return address
0070 3098 0649  14         dect  stack
0071 309A C644  30         mov   tmp0,*stack           ; Push tmp0
0072 309C 0649  14         dect  stack
0073 309E C645  30         mov   tmp1,*stack           ; Push tmp1
0074                       ;------------------------------------------------------
0075                       ; Calculate pointer
0076                       ;------------------------------------------------------
0077 30A0 C120  34         mov   @fb.row,tmp0
     30A2 A306     
0078 30A4 3920  72         mpy   @fb.colsline,tmp0     ; tmp1 = row  * colsline
     30A6 A30E     
0079 30A8 A160  34         a     @fb.column,tmp1       ; tmp1 = tmp1 + column
     30AA A30C     
0080 30AC A160  34         a     @fb.top.ptr,tmp1      ; tmp1 = tmp1 + base
     30AE A300     
0081 30B0 C805  38         mov   tmp1,@fb.current
     30B2 A302     
0082                       ;------------------------------------------------------
0083                       ; Exit
0084                       ;------------------------------------------------------
0085               fb.calc_pointer.exit:
0086 30B4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0087 30B6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0088 30B8 C2F9  30         mov   *stack+,r11           ; Pop r11
0089 30BA 045B  20         b     *r11                  ; Return to caller
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
0051 30BC 0649  14         dect  stack
0052 30BE C64B  30         mov   r11,*stack            ; Save return address
0053 30C0 0649  14         dect  stack
0054 30C2 C644  30         mov   tmp0,*stack           ; Push tmp0
0055                       ;------------------------------------------------------
0056                       ; Initialize
0057                       ;------------------------------------------------------
0058 30C4 0204  20         li    tmp0,idx.top
     30C6 B000     
0059 30C8 C804  38         mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
     30CA A502     
0060               
0061 30CC C120  34         mov   @tv.sams.b000,tmp0
     30CE A206     
0062 30D0 C804  38         mov   tmp0,@idx.sams.page   ; Set current SAMS page
     30D2 A600     
0063 30D4 C804  38         mov   tmp0,@idx.sams.lopage ; Set 1st SAMS page
     30D6 A602     
0064                       ;------------------------------------------------------
0065                       ; Clear all index pages
0066                       ;------------------------------------------------------
0067 30D8 0224  22         ai    tmp0,4                ; \ Let's clear all index pages
     30DA 0004     
0068 30DC C804  38         mov   tmp0,@idx.sams.hipage ; /
     30DE A604     
0069               
0070 30E0 06A0  32         bl    @_idx.sams.mapcolumn.on
     30E2 30FE     
0071                                                   ; Index in continuous memory region
0072               
0073 30E4 06A0  32         bl    @film
     30E6 224A     
0074 30E8 B000                   data idx.top,>00,idx.size * 5
     30EA 0000     
     30EC 5000     
0075                                                   ; Clear index
0076               
0077 30EE 06A0  32         bl    @_idx.sams.mapcolumn.off
     30F0 3132     
0078                                                   ; Restore memory window layout
0079               
0080 30F2 C820  54         mov   @idx.sams.lopage,@idx.sams.hipage
     30F4 A602     
     30F6 A604     
0081                                                   ; Reset last SAMS page
0082                       ;------------------------------------------------------
0083                       ; Exit
0084                       ;------------------------------------------------------
0085               idx.init.exit:
0086 30F8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0087 30FA C2F9  30         mov   *stack+,r11           ; Pop r11
0088 30FC 045B  20         b     *r11                  ; Return to caller
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
0101 30FE 0649  14         dect  stack
0102 3100 C64B  30         mov   r11,*stack            ; Push return address
0103 3102 0649  14         dect  stack
0104 3104 C644  30         mov   tmp0,*stack           ; Push tmp0
0105 3106 0649  14         dect  stack
0106 3108 C645  30         mov   tmp1,*stack           ; Push tmp1
0107 310A 0649  14         dect  stack
0108 310C C646  30         mov   tmp2,*stack           ; Push tmp2
0109               *--------------------------------------------------------------
0110               * Map index pages into memory window  (b000-ffff)
0111               *--------------------------------------------------------------
0112 310E C120  34         mov   @idx.sams.lopage,tmp0 ; Get lowest index page
     3110 A602     
0113 3112 0205  20         li    tmp1,idx.top
     3114 B000     
0114 3116 0206  20         li    tmp2,5                ; Set loop counter. all pages of index
     3118 0005     
0115                       ;-------------------------------------------------------
0116                       ; Loop over banks
0117                       ;-------------------------------------------------------
0118 311A 06A0  32 !       bl    @xsams.page.set       ; Set SAMS page
     311C 258A     
0119                                                   ; \ i  tmp0  = SAMS page number
0120                                                   ; / i  tmp1  = Memory address
0121               
0122 311E 0584  14         inc   tmp0                  ; Next SAMS index page
0123 3120 0225  22         ai    tmp1,>1000            ; Next memory region
     3122 1000     
0124 3124 0606  14         dec   tmp2                  ; Update loop counter
0125 3126 15F9  14         jgt   -!                    ; Next iteration
0126               *--------------------------------------------------------------
0127               * Exit
0128               *--------------------------------------------------------------
0129               _idx.sams.mapcolumn.on.exit:
0130 3128 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0131 312A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0132 312C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0133 312E C2F9  30         mov   *stack+,r11           ; Pop return address
0134 3130 045B  20         b     *r11                  ; Return to caller
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
0150 3132 0649  14         dect  stack
0151 3134 C64B  30         mov   r11,*stack            ; Push return address
0152 3136 0649  14         dect  stack
0153 3138 C644  30         mov   tmp0,*stack           ; Push tmp0
0154 313A 0649  14         dect  stack
0155 313C C645  30         mov   tmp1,*stack           ; Push tmp1
0156 313E 0649  14         dect  stack
0157 3140 C646  30         mov   tmp2,*stack           ; Push tmp2
0158 3142 0649  14         dect  stack
0159 3144 C647  30         mov   tmp3,*stack           ; Push tmp3
0160               *--------------------------------------------------------------
0161               * Map index pages into memory window  (b000-????)
0162               *--------------------------------------------------------------
0163 3146 0205  20         li    tmp1,idx.top
     3148 B000     
0164 314A 0206  20         li    tmp2,5                ; Always 5 pages
     314C 0005     
0165 314E 0207  20         li    tmp3,tv.sams.b000     ; Pointer to fist SAMS page
     3150 A206     
0166                       ;-------------------------------------------------------
0167                       ; Loop over table in memory (@tv.sams.b000:@tv.sams.f000)
0168                       ;-------------------------------------------------------
0169 3152 C137  30 !       mov   *tmp3+,tmp0           ; Get SAMS page
0170               
0171 3154 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     3156 258A     
0172                                                   ; \ i  tmp0  = SAMS page number
0173                                                   ; / i  tmp1  = Memory address
0174               
0175 3158 0225  22         ai    tmp1,>1000            ; Next memory region
     315A 1000     
0176 315C 0606  14         dec   tmp2                  ; Update loop counter
0177 315E 15F9  14         jgt   -!                    ; Next iteration
0178               *--------------------------------------------------------------
0179               * Exit
0180               *--------------------------------------------------------------
0181               _idx.sams.mapcolumn.off.exit:
0182 3160 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0183 3162 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0184 3164 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0185 3166 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0186 3168 C2F9  30         mov   *stack+,r11           ; Pop return address
0187 316A 045B  20         b     *r11                  ; Return to caller
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
0211 316C 0649  14         dect  stack
0212 316E C64B  30         mov   r11,*stack            ; Save return address
0213 3170 0649  14         dect  stack
0214 3172 C644  30         mov   tmp0,*stack           ; Push tmp0
0215 3174 0649  14         dect  stack
0216 3176 C645  30         mov   tmp1,*stack           ; Push tmp1
0217 3178 0649  14         dect  stack
0218 317A C646  30         mov   tmp2,*stack           ; Push tmp2
0219                       ;------------------------------------------------------
0220                       ; Determine SAMS index page
0221                       ;------------------------------------------------------
0222 317C C184  18         mov   tmp0,tmp2             ; Line number
0223 317E 04C5  14         clr   tmp1                  ; MSW (tmp1) = 0 / LSW (tmp2) = Line number
0224 3180 0204  20         li    tmp0,2048             ; Index entries in 4K SAMS page
     3182 0800     
0225               
0226 3184 3D44 128         div   tmp0,tmp1             ; \ Divide 32 bit value by 2048
0227                                                   ; | tmp1 = quotient  (SAMS page offset)
0228                                                   ; / tmp2 = remainder
0229               
0230 3186 0A16  56         sla   tmp2,1                ; line number * 2
0231 3188 C806  38         mov   tmp2,@outparm1        ; Offset index entry
     318A A016     
0232               
0233 318C A160  34         a     @idx.sams.lopage,tmp1 ; Add SAMS page base
     318E A602     
0234 3190 8805  38         c     tmp1,@idx.sams.page   ; Page already active?
     3192 A600     
0235               
0236 3194 130E  14         jeq   _idx.samspage.get.exit
0237                                                   ; Yes, so exit
0238                       ;------------------------------------------------------
0239                       ; Activate SAMS index page
0240                       ;------------------------------------------------------
0241 3196 C805  38         mov   tmp1,@idx.sams.page   ; Set current SAMS page
     3198 A600     
0242 319A C805  38         mov   tmp1,@tv.sams.b000    ; Also keep SAMS window synced in Stevie
     319C A206     
0243 319E C105  18         mov   tmp1,tmp0             ; Destination SAMS page
0244               
0245 31A0 0205  20         li    tmp1,>b000            ; Memory window for index page
     31A2 B000     
0246               
0247 31A4 06A0  32         bl    @xsams.page.set       ; Switch to SAMS page
     31A6 258A     
0248                                                   ; \ i  tmp0 = SAMS page
0249                                                   ; / i  tmp1 = Memory address
0250                       ;------------------------------------------------------
0251                       ; Check if new highest SAMS index page
0252                       ;------------------------------------------------------
0253 31A8 8804  38         c     tmp0,@idx.sams.hipage ; New highest page?
     31AA A604     
0254 31AC 1202  14         jle   _idx.samspage.get.exit
0255                                                   ; No, exit
0256 31AE C804  38         mov   tmp0,@idx.sams.hipage ; Yes, set highest SAMS index page
     31B0 A604     
0257                       ;------------------------------------------------------
0258                       ; Exit
0259                       ;------------------------------------------------------
0260               _idx.samspage.get.exit:
0261 31B2 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0262 31B4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0263 31B6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0264 31B8 C2F9  30         mov   *stack+,r11           ; Pop r11
0265 31BA 045B  20         b     *r11                  ; Return to caller
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
0022 31BC 0649  14         dect  stack
0023 31BE C64B  30         mov   r11,*stack            ; Save return address
0024 31C0 0649  14         dect  stack
0025 31C2 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 31C4 0204  20         li    tmp0,edb.top          ; \
     31C6 C000     
0030 31C8 C804  38         mov   tmp0,@edb.top.ptr     ; / Set pointer to top of editor buffer
     31CA A500     
0031 31CC C804  38         mov   tmp0,@edb.next_free.ptr
     31CE A508     
0032                                                   ; Set pointer to next free line
0033               
0034 31D0 0720  34         seto  @edb.insmode          ; Turn on insert mode for this editor buffer
     31D2 A50A     
0035               
0036 31D4 0204  20         li    tmp0,1
     31D6 0001     
0037 31D8 C804  38         mov   tmp0,@edb.lines       ; Lines=1
     31DA A504     
0038               
0039 31DC 0720  34         seto  @edb.block.m1         ; Reset block start line
     31DE A50C     
0040 31E0 0720  34         seto  @edb.block.m2         ; Reset block end line
     31E2 A50E     
0041               
0042 31E4 0204  20         li    tmp0,txt.newfile      ; "New file"
     31E6 3882     
0043 31E8 C804  38         mov   tmp0,@edb.filename.ptr
     31EA A512     
0044               
0045 31EC 04E0  34         clr   @fh.kilobytes         ; \ Clear kilobytes processed
     31EE A440     
0046 31F0 04E0  34         clr   @fh.kilobytes.prev    ; /
     31F2 A45C     
0047               
0048 31F4 0204  20         li    tmp0,txt.filetype.none
     31F6 39D8     
0049 31F8 C804  38         mov   tmp0,@edb.filetype.ptr
     31FA A514     
0050               
0051               edb.init.exit:
0052                       ;------------------------------------------------------
0053                       ; Exit
0054                       ;------------------------------------------------------
0055 31FC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0056 31FE C2F9  30         mov   *stack+,r11           ; Pop r11
0057 3200 045B  20         b     *r11                  ; Return to caller
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
0022 3202 0649  14         dect  stack
0023 3204 C64B  30         mov   r11,*stack            ; Save return address
0024 3206 0649  14         dect  stack
0025 3208 C644  30         mov   tmp0,*stack           ; Push tmp0
0026                       ;------------------------------------------------------
0027                       ; Initialize
0028                       ;------------------------------------------------------
0029 320A 0204  20         li    tmp0,cmdb.top         ; \ Set pointer to command buffer
     320C E000     
0030 320E C804  38         mov   tmp0,@cmdb.top.ptr    ; /
     3210 A700     
0031               
0032 3212 04E0  34         clr   @cmdb.visible         ; Hide command buffer
     3214 A702     
0033 3216 0204  20         li    tmp0,4
     3218 0004     
0034 321A C804  38         mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
     321C A706     
0035 321E C804  38         mov   tmp0,@cmdb.default    ; Set default command buffer size
     3220 A708     
0036               
0037 3222 04E0  34         clr   @cmdb.lines           ; Number of lines in cmdb buffer
     3224 A716     
0038 3226 04E0  34         clr   @cmdb.dirty           ; Command buffer is clean
     3228 A718     
0039 322A 04E0  34         clr   @cmdb.action.ptr      ; Reset action to execute pointer
     322C A728     
0040                       ;------------------------------------------------------
0041                       ; Clear command buffer
0042                       ;------------------------------------------------------
0043 322E 06A0  32         bl    @film
     3230 224A     
0044 3232 E000             data  cmdb.top,>00,cmdb.size
     3234 0000     
     3236 1000     
0045                                                   ; Clear it all the way
0046               cmdb.init.exit:
0047                       ;------------------------------------------------------
0048                       ; Exit
0049                       ;------------------------------------------------------
0050 3238 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0051 323A C2F9  30         mov   *stack+,r11           ; Pop r11
0052 323C 045B  20         b     *r11                  ; Return to caller
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
0022 323E 0649  14         dect  stack
0023 3240 C64B  30         mov   r11,*stack            ; Save return address
0024 3242 0649  14         dect  stack
0025 3244 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 3246 0649  14         dect  stack
0027 3248 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 324A 0649  14         dect  stack
0029 324C C646  30         mov   tmp2,*stack           ; Push tmp2
0030                       ;------------------------------------------------------
0031                       ; Initialize
0032                       ;------------------------------------------------------
0033 324E 04E0  34         clr   @tv.error.visible     ; Set to hidden
     3250 A228     
0034 3252 0204  20         li    tmp0,3
     3254 0003     
0035 3256 C804  38         mov   tmp0,@tv.error.rows   ; Number of rows in error pane
     3258 A22A     
0036               
0037 325A 06A0  32         bl    @film
     325C 224A     
0038 325E A230                   data tv.error.msg,0,160
     3260 0000     
     3262 00A0     
0039                       ;-------------------------------------------------------
0040                       ; Exit
0041                       ;-------------------------------------------------------
0042               errpane.exit:
0043 3264 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0044 3266 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0045 3268 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0046 326A C2F9  30         mov   *stack+,r11           ; Pop R11
0047 326C 045B  20         b     *r11                  ; Return to caller
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
0022 326E 0649  14         dect  stack
0023 3270 C64B  30         mov   r11,*stack            ; Save return address
0024 3272 0649  14         dect  stack
0025 3274 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 3276 0649  14         dect  stack
0027 3278 C645  30         mov   tmp1,*stack           ; Push tmp1
0028 327A 0649  14         dect  stack
0029 327C C646  30         mov   tmp2,*stack           ; Push tmp2
0030                       ;------------------------------------------------------
0031                       ; Initialize
0032                       ;------------------------------------------------------
0033 327E 0204  20         li    tmp0,1                ; \ Set default color scheme
     3280 0001     
0034 3282 C804  38         mov   tmp0,@tv.colorscheme  ; /
     3284 A212     
0035               
0036 3286 04E0  34         clr   @tv.task.oneshot      ; Reset pointer to oneshot task
     3288 A224     
0037 328A E0A0  34         soc   @wbit10,config        ; Assume ALPHA LOCK is down
     328C 200C     
0038               
0039 328E 0204  20         li    tmp0,fj.bottom
     3290 B000     
0040 3292 C804  38         mov   tmp0,@tv.fj.stackpnt  ; Set pointer to farjump return stack
     3294 A226     
0041                       ;------------------------------------------------------
0042                       ; Set defaults
0043                       ;------------------------------------------------------
0044 3296 06A0  32         bl    @cpym2m
     3298 24EE     
0045 329A 3AB0                   data def.printer.fname,tv.printer.fname,7
     329C DE00     
     329E 0007     
0046               
0047 32A0 06A0  32         bl    @cpym2m
     32A2 24EE     
0048 32A4 3AB8                   data def.clip.fname,tv.clip.fname,10
     32A6 DE50     
     32A8 000A     
0049                       ;-------------------------------------------------------
0050                       ; Exit
0051                       ;-------------------------------------------------------
0052               tv.init.exit:
0053 32AA C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0054 32AC C179  30         mov   *stack+,tmp1          ; Pop tmp1
0055 32AE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0056 32B0 C2F9  30         mov   *stack+,r11           ; Pop R11
0057 32B2 045B  20         b     *r11                  ; Return to caller
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
0023 32B4 06A0  32         bl    @f18rst               ; Reset and lock the F18A
     32B6 27BA     
0024                       ;-------------------------------------------------------
0025                       ; Load legacy SAMS page layout and exit to monitor
0026                       ;-------------------------------------------------------
0027 32B8 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     32BA 2F84     
0028 32BC 600E                   data bank7.rom        ; | i  p0 = bank address
0029 32BE 7FC0                   data bankx.vectab     ; | i  p1 = Vector with target address
0030 32C0 6002                   data bankid           ; / i  p2 = Source ROM bank for return
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
0023 32C2 0649  14         dect  stack
0024 32C4 C64B  30         mov   r11,*stack            ; Save return address
0025                       ;------------------------------------------------------
0026                       ; Reset editor
0027                       ;------------------------------------------------------
0028 32C6 06A0  32         bl    @cmdb.init            ; Initialize command buffer
     32C8 3202     
0029 32CA 06A0  32         bl    @edb.init             ; Initialize editor buffer
     32CC 31BC     
0030 32CE 06A0  32         bl    @idx.init             ; Initialize index
     32D0 30BC     
0031 32D2 06A0  32         bl    @fb.init              ; Initialize framebuffer
     32D4 3014     
0032 32D6 06A0  32         bl    @errpane.init         ; Initialize error pane
     32D8 323E     
0033                       ;------------------------------------------------------
0034                       ; Remove markers and shortcuts
0035                       ;------------------------------------------------------
0036 32DA 06A0  32         bl    @hchar
     32DC 27E6     
0037 32DE 0034                   byte 0,52,32,18       ; Remove markers
     32E0 2012     
0038 32E2 1700                   byte pane.botrow,0,32,51
     32E4 2033     
0039 32E6 FFFF                   data eol              ; Remove block shortcuts
0040                       ;-------------------------------------------------------
0041                       ; Exit
0042                       ;-------------------------------------------------------
0043               tv.reset.exit:
0044 32E8 C2F9  30         mov   *stack+,r11           ; Pop R11
0045 32EA 045B  20         b     *r11                  ; Return to caller
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
0020 32EC 0649  14         dect  stack
0021 32EE C64B  30         mov   r11,*stack            ; Save return address
0022 32F0 0649  14         dect  stack
0023 32F2 C644  30         mov   tmp0,*stack           ; Push tmp0
0024                       ;------------------------------------------------------
0025                       ; Initialize
0026                       ;------------------------------------------------------
0027 32F4 06A0  32         bl    @mknum                ; Convert unsigned number to string
     32F6 29BA     
0028 32F8 A006                   data parm1            ; \ i p0  = Pointer to 16bit unsigned number
0029 32FA A100                   data rambuf           ; | i p1  = Pointer to 5 byte string buffer
0030 32FC 30                     byte 48               ; | i p2H = Offset for ASCII digit 0
0031 32FD   20                   byte 32               ; / i p2L = Char for replacing leading 0's
0032               
0033 32FE 0204  20         li    tmp0,unpacked.string
     3300 A02C     
0034 3302 04F4  30         clr   *tmp0+                ; Clear string 01
0035 3304 04F4  30         clr   *tmp0+                ; Clear string 23
0036 3306 04F4  30         clr   *tmp0+                ; Clear string 34
0037               
0038 3308 06A0  32         bl    @trimnum              ; Trim unsigned number string
     330A 2A12     
0039 330C A100                   data rambuf           ; \ i p0  = Pointer to 5 byte string buffer
0040 330E A02C                   data unpacked.string  ; | i p1  = Pointer to output buffer
0041 3310 0020                   data 32               ; / i p2  = Padding char to match against
0042                       ;-------------------------------------------------------
0043                       ; Exit
0044                       ;-------------------------------------------------------
0045               tv.unpack.uint16.exit:
0046 3312 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0047 3314 C2F9  30         mov   *stack+,r11           ; Pop r11
0048 3316 045B  20         b     *r11                  ; Return to caller
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
0024 3318 0649  14         dect  stack
0025 331A C64B  30         mov   r11,*stack            ; Push return address
0026 331C 0649  14         dect  stack
0027 331E C644  30         mov   tmp0,*stack           ; Push tmp0
0028 3320 0649  14         dect  stack
0029 3322 C645  30         mov   tmp1,*stack           ; Push tmp1
0030 3324 0649  14         dect  stack
0031 3326 C646  30         mov   tmp2,*stack           ; Push tmp2
0032 3328 0649  14         dect  stack
0033 332A C647  30         mov   tmp3,*stack           ; Push tmp3
0034                       ;------------------------------------------------------
0035                       ; Asserts
0036                       ;------------------------------------------------------
0037 332C C120  34         mov   @parm1,tmp0           ; \ Get string prefix (length-byte)
     332E A006     
0038 3330 D194  26         movb  *tmp0,tmp2            ; /
0039 3332 0986  56         srl   tmp2,8                ; Right align
0040 3334 C1C6  18         mov   tmp2,tmp3             ; Make copy of length-byte for later use
0041               
0042 3336 8806  38         c     tmp2,@parm2           ; String length > requested length?
     3338 A008     
0043 333A 1520  14         jgt   tv.pad.string.panic   ; Yes, crash
0044                       ;------------------------------------------------------
0045                       ; Copy string to buffer
0046                       ;------------------------------------------------------
0047 333C C120  34         mov   @parm1,tmp0           ; Get source address
     333E A006     
0048 3340 C160  34         mov   @parm4,tmp1           ; Get destination address
     3342 A00C     
0049 3344 0586  14         inc   tmp2                  ; Also include length-byte in copy
0050               
0051 3346 0649  14         dect  stack
0052 3348 C647  30         mov   tmp3,*stack           ; Push tmp3 (get overwritten by xpym2m)
0053               
0054 334A 06A0  32         bl    @xpym2m               ; Copy length-prefix string to buffer
     334C 24F4     
0055                                                   ; \ i  tmp0 = Source CPU memory address
0056                                                   ; | i  tmp1 = Target CPU memory address
0057                                                   ; / i  tmp2 = Number of bytes to copy
0058               
0059 334E C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0060                       ;------------------------------------------------------
0061                       ; Set length of new string
0062                       ;------------------------------------------------------
0063 3350 C120  34         mov   @parm2,tmp0           ; Get requested length
     3352 A008     
0064 3354 0A84  56         sla   tmp0,8                ; Left align
0065 3356 C160  34         mov   @parm4,tmp1           ; Get pointer to buffer
     3358 A00C     
0066 335A D544  30         movb  tmp0,*tmp1            ; Set new length of string
0067 335C A147  18         a     tmp3,tmp1             ; \ Skip to end of string
0068 335E 0585  14         inc   tmp1                  ; /
0069                       ;------------------------------------------------------
0070                       ; Prepare for padding string
0071                       ;------------------------------------------------------
0072 3360 C1A0  34         mov   @parm2,tmp2           ; \ Get number of bytes to fill
     3362 A008     
0073 3364 6187  18         s     tmp3,tmp2             ; |
0074 3366 0586  14         inc   tmp2                  ; /
0075               
0076 3368 C120  34         mov   @parm3,tmp0           ; Get byte to padd
     336A A00A     
0077 336C 0A84  56         sla   tmp0,8                ; Left align
0078                       ;------------------------------------------------------
0079                       ; Right-pad string to destination length
0080                       ;------------------------------------------------------
0081               tv.pad.string.loop:
0082 336E DD44  32         movb  tmp0,*tmp1+           ; Pad character
0083 3370 0606  14         dec   tmp2                  ; Update loop counter
0084 3372 15FD  14         jgt   tv.pad.string.loop    ; Next character
0085               
0086 3374 C820  54         mov   @parm4,@outparm1      ; Set pointer to padded string
     3376 A00C     
     3378 A016     
0087 337A 1004  14         jmp   tv.pad.string.exit    ; Exit
0088                       ;-----------------------------------------------------------------------
0089                       ; CPU crash
0090                       ;-----------------------------------------------------------------------
0091               tv.pad.string.panic:
0092 337C C80B  38         mov   r11,@>ffce            ; \ Save caller address
     337E FFCE     
0093 3380 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     3382 2026     
0094                       ;------------------------------------------------------
0095                       ; Exit
0096                       ;------------------------------------------------------
0097               tv.pad.string.exit:
0098 3384 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0099 3386 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0100 3388 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0101 338A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0102 338C C2F9  30         mov   *stack+,r11           ; Pop r11
0103 338E 045B  20         b     *r11                  ; Return to caller
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
0022 3390 0649  14         dect  stack
0023 3392 C64B  30         mov   r11,*stack            ; Save return address
0024 3394 0649  14         dect  stack
0025 3396 C644  30         mov   tmp0,*stack           ; Push tmp0
0026 3398 0649  14         dect  stack
0027 339A C645  30         mov   tmp1,*stack           ; Push tmp1
0028                       ;------------------------------------------------------
0029                       ; Get parameters
0030                       ;------------------------------------------------------
0031 339C C120  34         mov   @parm1,tmp0           ; Get line number
     339E A006     
0032 33A0 C160  34         mov   @parm2,tmp1           ; Get pointer
     33A2 A008     
0033 33A4 1312  14         jeq   idx.entry.update.clear
0034                                                   ; Special handling for "null"-pointer
0035                       ;------------------------------------------------------
0036                       ; Calculate LSB value index slot (pointer offset)
0037                       ;------------------------------------------------------
0038 33A6 0245  22         andi  tmp1,>0fff            ; Remove high-nibble from pointer
     33A8 0FFF     
0039 33AA 0945  56         srl   tmp1,4                ; Get offset (divide by 16)
0040                       ;------------------------------------------------------
0041                       ; Calculate MSB value index slot (SAMS page editor buffer)
0042                       ;------------------------------------------------------
0043 33AC 06E0  34         swpb  @parm3
     33AE A00A     
0044 33B0 D160  34         movb  @parm3,tmp1           ; Put SAMS page in MSB
     33B2 A00A     
0045 33B4 06E0  34         swpb  @parm3                ; \ Restore original order again,
     33B6 A00A     
0046                                                   ; / important for messing up caller parm3!
0047                       ;------------------------------------------------------
0048                       ; Update index slot
0049                       ;------------------------------------------------------
0050               idx.entry.update.save:
0051 33B8 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     33BA 316C     
0052                                                   ; \ i  tmp0     = Line number
0053                                                   ; / o  outparm1 = Slot offset in SAMS page
0054               
0055 33BC C120  34         mov   @outparm1,tmp0        ; \ Update index slot
     33BE A016     
0056 33C0 C905  38         mov   tmp1,@idx.top(tmp0)   ; /
     33C2 B000     
0057 33C4 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     33C6 A016     
0058 33C8 1008  14         jmp   idx.entry.update.exit
0059                       ;------------------------------------------------------
0060                       ; Special handling for "null"-pointer
0061                       ;------------------------------------------------------
0062               idx.entry.update.clear:
0063 33CA 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     33CC 316C     
0064                                                   ; \ i  tmp0     = Line number
0065                                                   ; / o  outparm1 = Slot offset in SAMS page
0066               
0067 33CE C120  34         mov   @outparm1,tmp0        ; \ Clear index slot
     33D0 A016     
0068 33D2 04E4  34         clr   @idx.top(tmp0)        ; /
     33D4 B000     
0069 33D6 C804  38         mov   tmp0,@outparm1        ; Pointer to updated index entry
     33D8 A016     
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               idx.entry.update.exit:
0074 33DA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0075 33DC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0076 33DE C2F9  30         mov   *stack+,r11           ; Pop r11
0077 33E0 045B  20         b     *r11                  ; Return to caller
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
0021 33E2 0649  14         dect  stack
0022 33E4 C64B  30         mov   r11,*stack            ; Save return address
0023 33E6 0649  14         dect  stack
0024 33E8 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 33EA 0649  14         dect  stack
0026 33EC C645  30         mov   tmp1,*stack           ; Push tmp1
0027 33EE 0649  14         dect  stack
0028 33F0 C646  30         mov   tmp2,*stack           ; Push tmp2
0029                       ;------------------------------------------------------
0030                       ; Get slot entry
0031                       ;------------------------------------------------------
0032 33F2 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     33F4 A006     
0033               
0034 33F6 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page with index slot
     33F8 316C     
0035                                                   ; \ i  tmp0     = Line number
0036                                                   ; / o  outparm1 = Slot offset in SAMS page
0037               
0038 33FA C120  34         mov   @outparm1,tmp0        ; \ Get slot entry
     33FC A016     
0039 33FE C164  34         mov   @idx.top(tmp0),tmp1   ; /
     3400 B000     
0040               
0041 3402 130C  14         jeq   idx.pointer.get.parm.null
0042                                                   ; Skip if index slot empty
0043                       ;------------------------------------------------------
0044                       ; Calculate MSB (SAMS page)
0045                       ;------------------------------------------------------
0046 3404 C185  18         mov   tmp1,tmp2             ; \
0047 3406 0986  56         srl   tmp2,8                ; / Right align SAMS page
0048                       ;------------------------------------------------------
0049                       ; Calculate LSB (pointer address)
0050                       ;------------------------------------------------------
0051 3408 0245  22         andi  tmp1,>00ff            ; Get rid of MSB (SAMS page)
     340A 00FF     
0052 340C 0A45  56         sla   tmp1,4                ; Multiply with 16
0053 340E 0225  22         ai    tmp1,edb.top          ; Add editor buffer base address
     3410 C000     
0054                       ;------------------------------------------------------
0055                       ; Return parameters
0056                       ;------------------------------------------------------
0057               idx.pointer.get.parm:
0058 3412 C805  38         mov   tmp1,@outparm1        ; Index slot -> Pointer
     3414 A016     
0059 3416 C806  38         mov   tmp2,@outparm2        ; Index slot -> SAMS page
     3418 A018     
0060 341A 1004  14         jmp   idx.pointer.get.exit
0061                       ;------------------------------------------------------
0062                       ; Special handling for "null"-pointer
0063                       ;------------------------------------------------------
0064               idx.pointer.get.parm.null:
0065 341C 04E0  34         clr   @outparm1
     341E A016     
0066 3420 04E0  34         clr   @outparm2
     3422 A018     
0067                       ;------------------------------------------------------
0068                       ; Exit
0069                       ;------------------------------------------------------
0070               idx.pointer.get.exit:
0071 3424 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0072 3426 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0073 3428 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0074 342A C2F9  30         mov   *stack+,r11           ; Pop r11
0075 342C 045B  20         b     *r11                  ; Return to caller
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
0017 342E 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     3430 B000     
0018 3432 C144  18         mov   tmp0,tmp1             ; a = current slot
0019 3434 05C5  14         inct  tmp1                  ; b = current slot + 2
0020                       ;------------------------------------------------------
0021                       ; Loop forward until end of index
0022                       ;------------------------------------------------------
0023               _idx.entry.delete.reorg.loop:
0024 3436 CD35  46         mov   *tmp1+,*tmp0+         ; Copy b -> a
0025 3438 0606  14         dec   tmp2                  ; tmp2--
0026 343A 16FD  14         jne   _idx.entry.delete.reorg.loop
0027                                                   ; Loop unless completed
0028 343C 045B  20         b     *r11                  ; Return to caller
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
0046 343E 0649  14         dect  stack
0047 3440 C64B  30         mov   r11,*stack            ; Save return address
0048 3442 0649  14         dect  stack
0049 3444 C644  30         mov   tmp0,*stack           ; Push tmp0
0050 3446 0649  14         dect  stack
0051 3448 C645  30         mov   tmp1,*stack           ; Push tmp1
0052 344A 0649  14         dect  stack
0053 344C C646  30         mov   tmp2,*stack           ; Push tmp2
0054 344E 0649  14         dect  stack
0055 3450 C647  30         mov   tmp3,*stack           ; Push tmp3
0056                       ;------------------------------------------------------
0057                       ; Get index slot
0058                       ;------------------------------------------------------
0059 3452 C120  34         mov   @parm1,tmp0           ; Line number in editor buffer
     3454 A006     
0060               
0061 3456 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     3458 316C     
0062                                                   ; \ i  tmp0     = Line number
0063                                                   ; / o  outparm1 = Slot offset in SAMS page
0064               
0065 345A C120  34         mov   @outparm1,tmp0        ; Index offset
     345C A016     
0066                       ;------------------------------------------------------
0067                       ; Prepare for index reorg
0068                       ;------------------------------------------------------
0069 345E C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     3460 A008     
0070 3462 1303  14         jeq   idx.entry.delete.lastline
0071                                                   ; Exit early if last line = 0
0072               
0073 3464 61A0  34         s     @parm1,tmp2           ; Calculate loop
     3466 A006     
0074 3468 1504  14         jgt   idx.entry.delete.reorg
0075                                                   ; Reorganize if loop counter > 0
0076                       ;------------------------------------------------------
0077                       ; Special treatment for last line
0078                       ;------------------------------------------------------
0079               idx.entry.delete.lastline:
0080 346A 0224  22         ai    tmp0,idx.top          ; Add index base to offset
     346C B000     
0081 346E 04D4  26         clr   *tmp0                 ; Clear index entry
0082 3470 1012  14         jmp   idx.entry.delete.exit ; Exit early
0083                       ;------------------------------------------------------
0084                       ; Reorganize index entries
0085                       ;------------------------------------------------------
0086               idx.entry.delete.reorg:
0087 3472 C1E0  34         mov   @parm2,tmp3           ; Get last line to reorganize
     3474 A008     
0088 3476 0287  22         ci    tmp3,2048
     3478 0800     
0089 347A 120A  14         jle   idx.entry.delete.reorg.simple
0090                                                   ; Do simple reorg only if single
0091                                                   ; SAMS index page, otherwise complex reorg.
0092                       ;------------------------------------------------------
0093                       ; Complex index reorganization (multiple SAMS pages)
0094                       ;------------------------------------------------------
0095               idx.entry.delete.reorg.complex:
0096 347C 06A0  32         bl    @_idx.sams.mapcolumn.on
     347E 30FE     
0097                                                   ; Index in continuous memory region
0098               
0099                       ;-------------------------------------------------------
0100                       ; Recalculate index offset in continuous memory region
0101                       ;-------------------------------------------------------
0102 3480 C120  34         mov   @parm1,tmp0           ; Restore line number
     3482 A006     
0103 3484 0A14  56         sla   tmp0,1                ; Calculate offset
0104               
0105 3486 06A0  32         bl    @_idx.entry.delete.reorg
     3488 342E     
0106                                                   ; Reorganize index
0107                                                   ; \ i  tmp0 = Index offset
0108                                                   ; / i  tmp2 = Loop count
0109               
0110 348A 06A0  32         bl    @_idx.sams.mapcolumn.off
     348C 3132     
0111                                                   ; Restore memory window layout
0112               
0113 348E 1002  14         jmp   !
0114                       ;------------------------------------------------------
0115                       ; Simple index reorganization
0116                       ;------------------------------------------------------
0117               idx.entry.delete.reorg.simple:
0118 3490 06A0  32         bl    @_idx.entry.delete.reorg
     3492 342E     
0119                       ;------------------------------------------------------
0120                       ; Clear index entry (base + offset already set)
0121                       ;------------------------------------------------------
0122 3494 04D4  26 !       clr   *tmp0                 ; Clear index entry
0123                       ;------------------------------------------------------
0124                       ; Exit
0125                       ;------------------------------------------------------
0126               idx.entry.delete.exit:
0127 3496 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0128 3498 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0129 349A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0130 349C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0131 349E C2F9  30         mov   *stack+,r11           ; Pop r11
0132 34A0 045B  20         b     *r11                  ; Return to caller
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
0017 34A2 0286  22         ci    tmp2,2048*5           ; Crash if loop counter value is unrealistic
     34A4 2800     
0018                                                   ; Max. 5 SAMS pages, each with 2048 index
0019                                                   ; entries.
0020               
0021 34A6 1204  14         jle   !                     ; Continue if ok
0022                       ;------------------------------------------------------
0023                       ; Crash and burn
0024                       ;------------------------------------------------------
0025               _idx.entry.insert.reorg.crash:
0026 34A8 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     34AA FFCE     
0027 34AC 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     34AE 2026     
0028                       ;------------------------------------------------------
0029                       ; Reorganize index entries
0030                       ;------------------------------------------------------
0031 34B0 0224  22 !       ai    tmp0,idx.top          ; Add index base to offset
     34B2 B000     
0032 34B4 C144  18         mov   tmp0,tmp1             ; a = current slot
0033 34B6 05C5  14         inct  tmp1                  ; b = current slot + 2
0034 34B8 0586  14         inc   tmp2                  ; One time adjustment for current line
0035                       ;------------------------------------------------------
0036                       ; Assert 2
0037                       ;------------------------------------------------------
0038 34BA C1C6  18         mov   tmp2,tmp3             ; Number of slots to reorganize
0039 34BC 0A17  56         sla   tmp3,1                ; adjust to slot size
0040 34BE 0507  16         neg   tmp3                  ; tmp3 = -tmp3
0041 34C0 A1C4  18         a     tmp0,tmp3             ; tmp3 = tmp3 + tmp0
0042 34C2 0287  22         ci    tmp3,idx.top - 4      ; Address before top of index ?
     34C4 AFFC     
0043 34C6 1504  14         jgt   _idx.entry.insert.reorg.loop
0044                                                   ; No, jump to loop start
0045                       ;------------------------------------------------------
0046                       ; Crash and burn
0047                       ;------------------------------------------------------
0048 34C8 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     34CA FFCE     
0049 34CC 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     34CE 2026     
0050                       ;------------------------------------------------------
0051                       ; Loop backwards from end of index up to insert point
0052                       ;------------------------------------------------------
0053               _idx.entry.insert.reorg.loop:
0054 34D0 C554  38         mov   *tmp0,*tmp1           ; Copy a -> b
0055 34D2 0644  14         dect  tmp0                  ; Move pointer up
0056 34D4 0645  14         dect  tmp1                  ; Move pointer up
0057 34D6 0606  14         dec   tmp2                  ; Next index entry
0058 34D8 15FB  14         jgt   _idx.entry.insert.reorg.loop
0059                                                   ; Repeat until done
0060                       ;------------------------------------------------------
0061                       ; Clear index entry at insert point
0062                       ;------------------------------------------------------
0063 34DA 05C4  14         inct  tmp0                  ; \ Clear index entry for line
0064 34DC 04D4  26         clr   *tmp0                 ; / following insert point
0065               
0066 34DE 045B  20         b     *r11                  ; Return to caller
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
0088 34E0 0649  14         dect  stack
0089 34E2 C64B  30         mov   r11,*stack            ; Save return address
0090 34E4 0649  14         dect  stack
0091 34E6 C644  30         mov   tmp0,*stack           ; Push tmp0
0092 34E8 0649  14         dect  stack
0093 34EA C645  30         mov   tmp1,*stack           ; Push tmp1
0094 34EC 0649  14         dect  stack
0095 34EE C646  30         mov   tmp2,*stack           ; Push tmp2
0096 34F0 0649  14         dect  stack
0097 34F2 C647  30         mov   tmp3,*stack           ; Push tmp3
0098                       ;------------------------------------------------------
0099                       ; Prepare for index reorg
0100                       ;------------------------------------------------------
0101 34F4 C1A0  34         mov   @parm2,tmp2           ; Get last line to check
     34F6 A008     
0102 34F8 61A0  34         s     @parm1,tmp2           ; Calculate loop
     34FA A006     
0103 34FC 130F  14         jeq   idx.entry.insert.reorg.simple
0104                                                   ; Special treatment if last line
0105                       ;------------------------------------------------------
0106                       ; Reorganize index entries
0107                       ;------------------------------------------------------
0108               idx.entry.insert.reorg:
0109 34FE C1E0  34         mov   @parm2,tmp3
     3500 A008     
0110 3502 0287  22         ci    tmp3,2048
     3504 0800     
0111 3506 110A  14         jlt   idx.entry.insert.reorg.simple
0112                                                   ; Do simple reorg only if single
0113                                                   ; SAMS index page, otherwise complex reorg.
0114                       ;------------------------------------------------------
0115                       ; Complex index reorganization (multiple SAMS pages)
0116                       ;------------------------------------------------------
0117               idx.entry.insert.reorg.complex:
0118 3508 06A0  32         bl    @_idx.sams.mapcolumn.on
     350A 30FE     
0119                                                   ; Index in continuous memory region
0120                                                   ; b000 - ffff (5 SAMS pages)
0121               
0122 350C C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     350E A008     
0123 3510 0A14  56         sla   tmp0,1                ; tmp0 * 2
0124               
0125 3512 06A0  32         bl    @_idx.entry.insert.reorg
     3514 34A2     
0126                                                   ; Reorganize index
0127                                                   ; \ i  tmp0 = Last line in index
0128                                                   ; / i  tmp2 = Num. of index entries to move
0129               
0130 3516 06A0  32         bl    @_idx.sams.mapcolumn.off
     3518 3132     
0131                                                   ; Restore memory window layout
0132               
0133 351A 1008  14         jmp   idx.entry.insert.exit
0134                       ;------------------------------------------------------
0135                       ; Simple index reorganization
0136                       ;------------------------------------------------------
0137               idx.entry.insert.reorg.simple:
0138 351C C120  34         mov   @parm2,tmp0           ; Last line number in editor buffer
     351E A008     
0139               
0140 3520 06A0  32         bl    @_idx.samspage.get    ; Get SAMS page for index
     3522 316C     
0141                                                   ; \ i  tmp0     = Line number
0142                                                   ; / o  outparm1 = Slot offset in SAMS page
0143               
0144 3524 C120  34         mov   @outparm1,tmp0        ; Index offset
     3526 A016     
0145               
0146 3528 06A0  32         bl    @_idx.entry.insert.reorg
     352A 34A2     
0147                                                   ; Reorganize index
0148                                                   ; \ i  tmp0 = Last line in index
0149                                                   ; / i  tmp2 = Num. of index entries to move
0150               
0151                       ;------------------------------------------------------
0152                       ; Exit
0153                       ;------------------------------------------------------
0154               idx.entry.insert.exit:
0155 352C C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0156 352E C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0157 3530 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0158 3532 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0159 3534 C2F9  30         mov   *stack+,r11           ; Pop r11
0160 3536 045B  20         b     *r11                  ; Return to caller
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
0021 3538 0649  14         dect  stack
0022 353A C64B  30         mov   r11,*stack            ; Push return address
0023 353C 0649  14         dect  stack
0024 353E C644  30         mov   tmp0,*stack           ; Push tmp0
0025 3540 0649  14         dect  stack
0026 3542 C645  30         mov   tmp1,*stack           ; Push tmp1
0027                       ;------------------------------------------------------
0028                       ; Assert
0029                       ;------------------------------------------------------
0030 3544 8804  38         c     tmp0,@edb.lines       ; Non-existing line?
     3546 A504     
0031 3548 1204  14         jle   edb.line.mappage.lookup
0032                                                   ; All checks passed, continue
0033                                                   ;--------------------------
0034                                                   ; Assert failed
0035                                                   ;--------------------------
0036 354A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     354C FFCE     
0037 354E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     3550 2026     
0038                       ;------------------------------------------------------
0039                       ; Lookup SAMS page for line in parm1
0040                       ;------------------------------------------------------
0041               edb.line.mappage.lookup:
0042 3552 C804  38         mov   tmp0,@parm1           ; Set line number in editor buffer
     3554 A006     
0043               
0044 3556 06A0  32         bl    @idx.pointer.get      ; Get pointer to line
     3558 33E2     
0045                                                   ; \ i  parm1    = Line number
0046                                                   ; | o  outparm1 = Pointer to line
0047                                                   ; / o  outparm2 = SAMS page
0048               
0049 355A C120  34         mov   @outparm2,tmp0        ; SAMS page
     355C A018     
0050 355E C160  34         mov   @outparm1,tmp1        ; Pointer to line
     3560 A016     
0051 3562 130B  14         jeq   edb.line.mappage.exit ; Nothing to page-in if NULL pointer
0052                                                   ; (=empty line)
0053                       ;------------------------------------------------------
0054                       ; Determine if requested SAMS page is already active
0055                       ;------------------------------------------------------
0056 3564 8120  34         c     @tv.sams.c000,tmp0    ; Compare with active page editor buffer
     3566 A208     
0057 3568 1308  14         jeq   edb.line.mappage.exit ; Request page already active, so exit
0058                       ;------------------------------------------------------
0059                       ; Activate requested SAMS page
0060                       ;-----------------------------------------------------
0061 356A 06A0  32         bl    @xsams.page.set       ; Switch SAMS memory page
     356C 258A     
0062                                                   ; \ i  tmp0 = SAMS page
0063                                                   ; / i  tmp1 = Memory address
0064               
0065 356E C820  54         mov   @outparm2,@tv.sams.c000
     3570 A018     
     3572 A208     
0066                                                   ; Set page in shadow registers
0067               
0068 3574 C820  54         mov   @outparm2,@edb.sams.page
     3576 A018     
     3578 A516     
0069                                                   ; Set current SAMS page
0070                       ;------------------------------------------------------
0071                       ; Exit
0072                       ;------------------------------------------------------
0073               edb.line.mappage.exit:
0074 357A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0075 357C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0076 357E C2F9  30         mov   *stack+,r11           ; Pop r11
0077 3580 045B  20         b     *r11                  ; Return to caller
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
0021 3582 0649  14         dect  stack
0022 3584 C64B  30         mov   r11,*stack            ; Push return address
0023 3586 0649  14         dect  stack
0024 3588 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 358A 0649  14         dect  stack
0026 358C C645  30         mov   tmp1,*stack           ; Push tmp1
0027                       ;------------------------------------------------------
0028                       ; Initialisation
0029                       ;------------------------------------------------------
0030 358E 04E0  34         clr   @outparm1             ; Reset length
     3590 A016     
0031 3592 04E0  34         clr   @outparm2             ; Reset SAMS bank
     3594 A018     
0032                       ;------------------------------------------------------
0033                       ; Exit if requested line beyond editor buffer
0034                       ;------------------------------------------------------
0035 3596 C120  34         mov   @parm1,tmp0           ; \
     3598 A006     
0036 359A 0584  14         inc   tmp0                  ; /  base 1
0037               
0038 359C 8804  38         c     tmp0,@edb.lines       ; Requested line at BOT?
     359E A504     
0039 35A0 1101  14         jlt   !                     ; No, continue processing
0040 35A2 100B  14         jmp   edb.line.getlength.null
0041                                                   ; Set length 0 and exit early
0042                       ;------------------------------------------------------
0043                       ; Map SAMS page
0044                       ;------------------------------------------------------
0045 35A4 C120  34 !       mov   @parm1,tmp0           ; Get line
     35A6 A006     
0046               
0047 35A8 06A0  32         bl    @edb.line.mappage     ; Activate editor buffer SAMS page for line
     35AA 3538     
0048                                                   ; \ i  tmp0     = Line number
0049                                                   ; | o  outparm1 = Pointer to line
0050                                                   ; / o  outparm2 = SAMS page
0051               
0052 35AC C120  34         mov   @outparm1,tmp0        ; Store pointer in tmp0
     35AE A016     
0053 35B0 1304  14         jeq   edb.line.getlength.null
0054                                                   ; Set length to 0 if null-pointer
0055                       ;------------------------------------------------------
0056                       ; Process line prefix and exit
0057                       ;------------------------------------------------------
0058 35B2 C154  26         mov   *tmp0,tmp1            ; Get length into tmp1
0059 35B4 C805  38         mov   tmp1,@outparm1        ; Save length
     35B6 A016     
0060 35B8 1002  14         jmp   edb.line.getlength.exit
0061                       ;------------------------------------------------------
0062                       ; Set length to 0 if null-pointer
0063                       ;------------------------------------------------------
0064               edb.line.getlength.null:
0065 35BA 04E0  34         clr   @outparm1             ; Set length to 0, was a null-pointer
     35BC A016     
0066                       ;------------------------------------------------------
0067                       ; Exit
0068                       ;------------------------------------------------------
0069               edb.line.getlength.exit:
0070 35BE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0071 35C0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0072 35C2 C2F9  30         mov   *stack+,r11           ; Pop r11
0073 35C4 045B  20         b     *r11                  ; Return to caller
0074               
0075               
0076               
0077               ***************************************************************
0078               * edb.line.getlength2
0079               * Get length of current row (as seen from editor buffer side)
0080               ***************************************************************
0081               *  bl   @edb.line.getlength2
0082               *--------------------------------------------------------------
0083               * INPUT
0084               * @fb.row = Row in frame buffer
0085               *--------------------------------------------------------------
0086               * OUTPUT
0087               * @fb.row.length = Length of row
0088               *--------------------------------------------------------------
0089               * Register usage
0090               * tmp0
0091               ********|*****|*********************|**************************
0092               edb.line.getlength2:
0093 35C6 0649  14         dect  stack
0094 35C8 C64B  30         mov   r11,*stack            ; Save return address
0095 35CA 0649  14         dect  stack
0096 35CC C644  30         mov   tmp0,*stack           ; Push tmp0
0097                       ;------------------------------------------------------
0098                       ; Calculate line in editor buffer
0099                       ;------------------------------------------------------
0100 35CE C120  34         mov   @fb.topline,tmp0      ; Get top line in frame buffer
     35D0 A304     
0101 35D2 A120  34         a     @fb.row,tmp0          ; Get current row in frame buffer
     35D4 A306     
0102                       ;------------------------------------------------------
0103                       ; Get length
0104                       ;------------------------------------------------------
0105 35D6 C804  38         mov   tmp0,@parm1
     35D8 A006     
0106 35DA 06A0  32         bl    @edb.line.getlength
     35DC 3582     
0107 35DE C820  54         mov   @outparm1,@fb.row.length
     35E0 A016     
     35E2 A308     
0108                                                   ; Save row length
0109                       ;------------------------------------------------------
0110                       ; Exit
0111                       ;------------------------------------------------------
0112               edb.line.getlength2.exit:
0113 35E4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0114 35E6 C2F9  30         mov   *stack+,r11           ; Pop R11
0115 35E8 045B  20         b     *r11                  ; Return to caller
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
0020 35EA 0649  14         dect  stack
0021 35EC C64B  30         mov   r11,*stack            ; Save return address
0022 35EE 0649  14         dect  stack
0023 35F0 C644  30         mov   tmp0,*stack           ; Push tmp0
0024 35F2 0649  14         dect  stack
0025 35F4 C645  30         mov   tmp1,*stack           ; Push tmp1
0026                       ;------------------------------------------------------
0027                       ; 1a. Check if highest SAMS page needs to be increased
0028                       ;------------------------------------------------------
0029               edb.hipage.alloc.check_setpage:
0030 35F6 C120  34         mov   @edb.next_free.ptr,tmp0
     35F8 A508     
0031                                                   ;--------------------------
0032                                                   ; Check for page overflow
0033                                                   ;--------------------------
0034 35FA 0244  22         andi  tmp0,>0fff            ; Get rid of highest nibble
     35FC 0FFF     
0035 35FE 0224  22         ai    tmp0,82               ; Assume line of 80 chars (+2 bytes prefix)
     3600 0052     
0036 3602 0284  22         ci    tmp0,>1000 - 16       ; 4K boundary reached?
     3604 0FF0     
0037 3606 1105  14         jlt   edb.hipage.alloc.setpage
0038                                                   ; Not yet, don't increase SAMS page
0039                       ;------------------------------------------------------
0040                       ; 1b. Increase highest SAMS page (copy-on-write!)
0041                       ;------------------------------------------------------
0042 3608 05A0  34         inc   @edb.sams.hipage      ; Set highest SAMS page
     360A A518     
0043 360C C820  54         mov   @edb.top.ptr,@edb.next_free.ptr
     360E A500     
     3610 A508     
0044                                                   ; Start at top of SAMS page again
0045                       ;------------------------------------------------------
0046                       ; 1c. Switch to SAMS page and exit
0047                       ;------------------------------------------------------
0048               edb.hipage.alloc.setpage:
0049 3612 C120  34         mov   @edb.sams.hipage,tmp0
     3614 A518     
0050 3616 C160  34         mov   @edb.top.ptr,tmp1
     3618 A500     
0051 361A 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     361C 258A     
0052                                                   ; \ i  tmp0 = SAMS page number
0053                                                   ; / i  tmp1 = Memory address
0054               
0055 361E 1004  14         jmp   edb.hipage.alloc.exit
0056                       ;------------------------------------------------------
0057                       ; Check failed, crash CPU!
0058                       ;------------------------------------------------------
0059               edb.hipage.alloc.crash:
0060 3620 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     3622 FFCE     
0061 3624 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     3626 2026     
0062                       ;------------------------------------------------------
0063                       ; Exit
0064                       ;------------------------------------------------------
0065               edb.hipage.alloc.exit:
0066 3628 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0067 362A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0068 362C C2F9  30         mov   *stack+,r11           ; Pop R11
0069 362E 045B  20         b     *r11                  ; Return to caller
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
0021 3630 0649  14         dect  stack
0022 3632 C64B  30         mov   r11,*stack            ; Push return address
0023 3634 0649  14         dect  stack
0024 3636 C660  46         mov   @wyx,*stack           ; Push cursor position
     3638 832A     
0025                       ;-------------------------------------------------------
0026                       ; Clear message
0027                       ;-------------------------------------------------------
0028 363A 06A0  32         bl    @hchar
     363C 27E6     
0029 363E 0034                   byte 0,52,32,18
     3640 2012     
0030 3642 FFFF                   data EOL              ; Clear message
0031               
0032 3644 04E0  34         clr   @tv.task.oneshot      ; Reset oneshot task
     3646 A224     
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036               pane.topline.oneshot.clearmsg.exit:
0037 3648 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     364A 832A     
0038 364C C2F9  30         mov   *stack+,r11           ; Pop R11
0039 364E 045B  20         b     *r11                  ; Return to task
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
0033 3650 04F0             byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80
     3652 003F     
     3654 0243     
     3656 05F4     
     3658 0050     
0034               
0035               
0036               ***************************************************************
0037               * TI Basic mode (32 columns/24 rows)
0038               *--------------------------------------------------------------
0039               tibasic.32x24:
0040 365A 00E2             byte  >00,>e2,>00,>0c,>00,>06,>00,>07,0,32
     365C 000C     
     365E 0006     
     3660 0007     
     3662 0020     
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
0067 3664 00E2             byte  >00,>e2,>00,>0c,>00,>06,>00,>07,0,32
     3666 000C     
     3668 0006     
     366A 0007     
     366C 0020     
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
0098 366E 0000             data  >0000,>0001           ; Cursor
     3670 0001     
0099 3672 0000             data  >0000,>0101           ; Current line indicator     <
     3674 0101     
0100 3676 0820             data  >0820,>0201           ; Current column indicator   v
     3678 0201     
0101               nosprite:
0102 367A D000             data  >d000                 ; End-of-Sprites list
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
0157 367C F417             data  >f417,>f171,>1b1f,>71b1 ; 1  White on blue with cyan touch
     367E F171     
     3680 1B1F     
     3682 71B1     
0158 3684 A11A             data  >a11a,>f0ff,>1f1a,>f1ff ; 2  Dark yellow on black
     3686 F0FF     
     3688 1F1A     
     368A F1FF     
0159 368C 2112             data  >2112,>f0ff,>1f12,>f1f6 ; 3  Dark green on black
     368E F0FF     
     3690 1F12     
     3692 F1F6     
0160 3694 F41F             data  >f41f,>1e11,>1a17,>1e11 ; 4  White on blue
     3696 1E11     
     3698 1A17     
     369A 1E11     
0161 369C E11E             data  >e11e,>e1ff,>1f1e,>e1ff ; 5  Grey on black
     369E E1FF     
     36A0 1F1E     
     36A2 E1FF     
0162 36A4 1771             data  >1771,>1016,>1b71,>1711 ; 6  Black on cyan
     36A6 1016     
     36A8 1B71     
     36AA 1711     
0163 36AC 1FF1             data  >1ff1,>1011,>f1f1,>1f11 ; 7  Black on white
     36AE 1011     
     36B0 F1F1     
     36B2 1F11     
0164 36B4 1AF1             data  >1af1,>a1ff,>1f1f,>f11f ; 8  Black on dark yellow
     36B6 A1FF     
     36B8 1F1F     
     36BA F11F     
0165 36BC 21F0             data  >21f0,>12ff,>1b12,>12ff ; 9  Dark green on black
     36BE 12FF     
     36C0 1B12     
     36C2 12FF     
0166 36C4 F5F1             data  >f5f1,>e1ff,>1b1f,>f131 ; 10 White on light blue
     36C6 E1FF     
     36C8 1B1F     
     36CA F131     
0167                       even
0168               
0169               tv.tabs.table:
0170 36CC 0007             byte  0,7,12,25             ; \   Default tab positions as used
     36CE 0C19     
0171 36D0 1E2D             byte  30,45,59,79           ; |   in Editor/Assembler module.
     36D2 3B4F     
0172 36D4 FF00             byte  >ff,0,0,0             ; |
     36D6 0000     
0173 36D8 0000             byte  0,0,0,0               ; |   Up to 20 positions supported.
     36DA 0000     
0174 36DC 0000             byte  0,0,0,0               ; /   >ff means end-of-list.
     36DE 0000     
0175                       even
0176               
0177               
0178               
0179               ***************************************************************
0180               * Constants for numbers 0-10
0181               ********|*****|*********************|**************************
0182      2000     const.0       equ   w$0000          ; 0
0183      2002     const.1       equ   w$0001          ; 1
0184      2004     const.2       equ   w$0002          ; 2
0185 36E0 0003     const.3       data  3               ; 3
0186      2006     const.4       equ   w$0004          ; 4
0187 36E2 0005     const.5       data  5               ; 5
0188 36E4 0006     const.6       data  6               ; 6
0189 36E6 0007     const.7       data  7               ; 7
0190      2008     const.8       equ   w$0008          ; 8
0191 36E8 0009     const.9       data  9               ; 9
0192 36EA 000A     const.10      data  10              ; 10
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
0009 36EC 01               byte  1
0010 36ED   2C             text  ','
0011                       even
0012               
0013               txt.bottom
0014 36EE 05               byte  5
0015 36EF   20             text  '  BOT'
     36F0 2042     
     36F2 4F54     
0016                       even
0017               
0018               txt.ovrwrite
0019 36F4 03               byte  3
0020 36F5   4F             text  'OVR'
     36F6 5652     
0021                       even
0022               
0023               txt.insert
0024 36F8 03               byte  3
0025 36F9   49             text  'INS'
     36FA 4E53     
0026                       even
0027               
0028               txt.star
0029 36FC 01               byte  1
0030 36FD   2A             text  '*'
0031                       even
0032               
0033               txt.loading
0034 36FE 0A               byte  10
0035 36FF   4C             text  'Loading...'
     3700 6F61     
     3702 6469     
     3704 6E67     
     3706 2E2E     
     3708 2E       
0036                       even
0037               
0038               txt.saving
0039 370A 0A               byte  10
0040 370B   53             text  'Saving....'
     370C 6176     
     370E 696E     
     3710 672E     
     3712 2E2E     
     3714 2E       
0041                       even
0042               
0043               txt.printing
0044 3716 12               byte  18
0045 3717   50             text  'Printing file.....'
     3718 7269     
     371A 6E74     
     371C 696E     
     371E 6720     
     3720 6669     
     3722 6C65     
     3724 2E2E     
     3726 2E2E     
     3728 2E       
0046                       even
0047               
0048               txt.block.del
0049 372A 12               byte  18
0050 372B   44             text  'Deleting block....'
     372C 656C     
     372E 6574     
     3730 696E     
     3732 6720     
     3734 626C     
     3736 6F63     
     3738 6B2E     
     373A 2E2E     
     373C 2E       
0051                       even
0052               
0053               txt.block.copy
0054 373E 11               byte  17
0055 373F   43             text  'Copying block....'
     3740 6F70     
     3742 7969     
     3744 6E67     
     3746 2062     
     3748 6C6F     
     374A 636B     
     374C 2E2E     
     374E 2E2E     
0056                       even
0057               
0058               txt.block.move
0059 3750 10               byte  16
0060 3751   4D             text  'Moving block....'
     3752 6F76     
     3754 696E     
     3756 6720     
     3758 626C     
     375A 6F63     
     375C 6B2E     
     375E 2E2E     
     3760 2E       
0061                       even
0062               
0063               txt.block.save
0064 3762 18               byte  24
0065 3763   53             text  'Saving block to file....'
     3764 6176     
     3766 696E     
     3768 6720     
     376A 626C     
     376C 6F63     
     376E 6B20     
     3770 746F     
     3772 2066     
     3774 696C     
     3776 652E     
     3778 2E2E     
     377A 2E       
0066                       even
0067               
0068               txt.block.clip
0069 377C 18               byte  24
0070 377D   43             text  'Copying to clipboard....'
     377E 6F70     
     3780 7969     
     3782 6E67     
     3784 2074     
     3786 6F20     
     3788 636C     
     378A 6970     
     378C 626F     
     378E 6172     
     3790 642E     
     3792 2E2E     
     3794 2E       
0071                       even
0072               
0073               txt.block.print
0074 3796 12               byte  18
0075 3797   50             text  'Printing block....'
     3798 7269     
     379A 6E74     
     379C 696E     
     379E 6720     
     37A0 626C     
     37A2 6F63     
     37A4 6B2E     
     37A6 2E2E     
     37A8 2E       
0076                       even
0077               
0078               txt.clearmem
0079 37AA 13               byte  19
0080 37AB   43             text  'Clearing memory....'
     37AC 6C65     
     37AE 6172     
     37B0 696E     
     37B2 6720     
     37B4 6D65     
     37B6 6D6F     
     37B8 7279     
     37BA 2E2E     
     37BC 2E2E     
0081                       even
0082               
0083               txt.done.load
0084 37BE 0E               byte  14
0085 37BF   4C             text  'Load completed'
     37C0 6F61     
     37C2 6420     
     37C4 636F     
     37C6 6D70     
     37C8 6C65     
     37CA 7465     
     37CC 64       
0086                       even
0087               
0088               txt.done.insert
0089 37CE 10               byte  16
0090 37CF   49             text  'Insert completed'
     37D0 6E73     
     37D2 6572     
     37D4 7420     
     37D6 636F     
     37D8 6D70     
     37DA 6C65     
     37DC 7465     
     37DE 64       
0091                       even
0092               
0093               txt.done.append
0094 37E0 10               byte  16
0095 37E1   41             text  'Append completed'
     37E2 7070     
     37E4 656E     
     37E6 6420     
     37E8 636F     
     37EA 6D70     
     37EC 6C65     
     37EE 7465     
     37F0 64       
0096                       even
0097               
0098               txt.done.save
0099 37F2 0E               byte  14
0100 37F3   53             text  'Save completed'
     37F4 6176     
     37F6 6520     
     37F8 636F     
     37FA 6D70     
     37FC 6C65     
     37FE 7465     
     3800 64       
0101                       even
0102               
0103               txt.done.copy
0104 3802 0E               byte  14
0105 3803   43             text  'Copy completed'
     3804 6F70     
     3806 7920     
     3808 636F     
     380A 6D70     
     380C 6C65     
     380E 7465     
     3810 64       
0106                       even
0107               
0108               txt.done.print
0109 3812 0F               byte  15
0110 3813   50             text  'Print completed'
     3814 7269     
     3816 6E74     
     3818 2063     
     381A 6F6D     
     381C 706C     
     381E 6574     
     3820 6564     
0111                       even
0112               
0113               txt.done.delete
0114 3822 10               byte  16
0115 3823   44             text  'Delete completed'
     3824 656C     
     3826 6574     
     3828 6520     
     382A 636F     
     382C 6D70     
     382E 6C65     
     3830 7465     
     3832 64       
0116                       even
0117               
0118               txt.done.clipboard
0119 3834 0F               byte  15
0120 3835   43             text  'Clipboard saved'
     3836 6C69     
     3838 7062     
     383A 6F61     
     383C 7264     
     383E 2073     
     3840 6176     
     3842 6564     
0121                       even
0122               
0123               txt.done.clipdev
0124 3844 0D               byte  13
0125 3845   43             text  'Clipboard set'
     3846 6C69     
     3848 7062     
     384A 6F61     
     384C 7264     
     384E 2073     
     3850 6574     
0126                       even
0127               
0128               txt.fastmode
0129 3852 08               byte  8
0130 3853   46             text  'Fastmode'
     3854 6173     
     3856 746D     
     3858 6F64     
     385A 65       
0131                       even
0132               
0133               txt.uncrunching
0134 385C 1B               byte  27
0135 385D   45             text  'Expanding TI Basic line....'
     385E 7870     
     3860 616E     
     3862 6469     
     3864 6E67     
     3866 2054     
     3868 4920     
     386A 4261     
     386C 7369     
     386E 6320     
     3870 6C69     
     3872 6E65     
     3874 2E2E     
     3876 2E2E     
0136                       even
0137               
0138               txt.kb
0139 3878 02               byte  2
0140 3879   6B             text  'kb'
     387A 62       
0141                       even
0142               
0143               txt.lines
0144 387C 05               byte  5
0145 387D   4C             text  'Lines'
     387E 696E     
     3880 6573     
0146                       even
0147               
0148               txt.newfile
0149 3882 0A               byte  10
0150 3883   5B             text  '[New file]'
     3884 4E65     
     3886 7720     
     3888 6669     
     388A 6C65     
     388C 5D       
0151                       even
0152               
0153               txt.tib1
0154 388E 0D               byte  13
0155 388F   5B             text  '[TI Basic #1]'
     3890 5449     
     3892 2042     
     3894 6173     
     3896 6963     
     3898 2023     
     389A 315D     
0156                       even
0157               
0158               txt.tib2
0159 389C 0D               byte  13
0160 389D   5B             text  '[TI Basic #2]'
     389E 5449     
     38A0 2042     
     38A2 6173     
     38A4 6963     
     38A6 2023     
     38A8 325D     
0161                       even
0162               
0163               txt.tib3
0164 38AA 0D               byte  13
0165 38AB   5B             text  '[TI Basic #3]'
     38AC 5449     
     38AE 2042     
     38B0 6173     
     38B2 6963     
     38B4 2023     
     38B6 335D     
0166                       even
0167               
0168               txt.tib4
0169 38B8 0D               byte  13
0170 38B9   5B             text  '[TI Basic #4]'
     38BA 5449     
     38BC 2042     
     38BE 6173     
     38C0 6963     
     38C2 2023     
     38C4 345D     
0171                       even
0172               
0173               txt.tib5
0174 38C6 0D               byte  13
0175 38C7   5B             text  '[TI Basic #5]'
     38C8 5449     
     38CA 2042     
     38CC 6173     
     38CE 6963     
     38D0 2023     
     38D2 355D     
0176                       even
0177               
0178               txt.filetype.dv80
0179 38D4 04               byte  4
0180 38D5   44             text  'DV80'
     38D6 5638     
     38D8 30       
0181                       even
0182               
0183               txt.m1
0184 38DA 03               byte  3
0185 38DB   4D             text  'M1='
     38DC 313D     
0186                       even
0187               
0188               txt.m2
0189 38DE 03               byte  3
0190 38DF   4D             text  'M2='
     38E0 323D     
0191                       even
0192               
0193               txt.keys.default
0194 38E2 10               byte  16
0195 38E3   46             text  'F9-Menu  ^H-Help'
     38E4 392D     
     38E6 4D65     
     38E8 6E75     
     38EA 2020     
     38EC 5E48     
     38EE 2D48     
     38F0 656C     
     38F2 70       
0196                       even
0197               
0198               txt.keys.defaultb
0199 38F4 1A               byte  26
0200 38F5   46             text  'F9-Menu  ^H-Help  F0-Basic'
     38F6 392D     
     38F8 4D65     
     38FA 6E75     
     38FC 2020     
     38FE 5E48     
     3900 2D48     
     3902 656C     
     3904 7020     
     3906 2046     
     3908 302D     
     390A 4261     
     390C 7369     
     390E 63       
0201                       even
0202               
0203               txt.keys.block
0204 3910 36               byte  54
0205 3911   46             text  'F9-Back  ^Copy  ^Move  ^Del  ^Save  ^Print  ^[1-5]Clip'
     3912 392D     
     3914 4261     
     3916 636B     
     3918 2020     
     391A 5E43     
     391C 6F70     
     391E 7920     
     3920 205E     
     3922 4D6F     
     3924 7665     
     3926 2020     
     3928 5E44     
     392A 656C     
     392C 2020     
     392E 5E53     
     3930 6176     
     3932 6520     
     3934 205E     
     3936 5072     
     3938 696E     
     393A 7420     
     393C 205E     
     393E 5B31     
     3940 2D35     
     3942 5D43     
     3944 6C69     
     3946 70       
0206                       even
0207               
0208               txt.keys.basic1
0209 3948 2C               byte  44
0210 3949   46             text  'F9-Back  F5-AutoMode  SPACE-Uncrunch program'
     394A 392D     
     394C 4261     
     394E 636B     
     3950 2020     
     3952 4635     
     3954 2D41     
     3956 7574     
     3958 6F4D     
     395A 6F64     
     395C 6520     
     395E 2053     
     3960 5041     
     3962 4345     
     3964 2D55     
     3966 6E63     
     3968 7275     
     396A 6E63     
     396C 6820     
     396E 7072     
     3970 6F67     
     3972 7261     
     3974 6D       
0211                       even
0212               
0213 3976 2E2E     txt.ruler          text    '.........'
     3978 2E2E     
     397A 2E2E     
     397C 2E2E     
     397E 2E       
0214 397F   12                        byte    18
0215 3980 2E2E                        text    '.........'
     3982 2E2E     
     3984 2E2E     
     3986 2E2E     
     3988 2E       
0216 3989   13                        byte    19
0217 398A 2E2E                        text    '.........'
     398C 2E2E     
     398E 2E2E     
     3990 2E2E     
     3992 2E       
0218 3993   14                        byte    20
0219 3994 2E2E                        text    '.........'
     3996 2E2E     
     3998 2E2E     
     399A 2E2E     
     399C 2E       
0220 399D   15                        byte    21
0221 399E 2E2E                        text    '.........'
     39A0 2E2E     
     39A2 2E2E     
     39A4 2E2E     
     39A6 2E       
0222 39A7   16                        byte    22
0223 39A8 2E2E                        text    '.........'
     39AA 2E2E     
     39AC 2E2E     
     39AE 2E2E     
     39B0 2E       
0224 39B1   17                        byte    23
0225 39B2 2E2E                        text    '.........'
     39B4 2E2E     
     39B6 2E2E     
     39B8 2E2E     
     39BA 2E       
0226 39BB   18                        byte    24
0227 39BC 2E2E                        text    '.........'
     39BE 2E2E     
     39C0 2E2E     
     39C2 2E2E     
     39C4 2E       
0228 39C5   19                        byte    25
0229                                  even
0230 39C6 020E     txt.alpha.down     data >020e,>0f00
     39C8 0F00     
0231 39CA 0110     txt.vertline       data >0110
0232 39CC 011C     txt.keymarker      byte 1,28
0233               
0234               txt.ws1
0235 39CE 01               byte  1
0236 39CF   20             text  ' '
0237                       even
0238               
0239               txt.ws2
0240 39D0 02               byte  2
0241 39D1   20             text  '  '
     39D2 20       
0242                       even
0243               
0244               txt.ws3
0245 39D4 03               byte  3
0246 39D5   20             text  '   '
     39D6 2020     
0247                       even
0248               
0249               txt.ws4
0250 39D8 04               byte  4
0251 39D9   20             text  '    '
     39DA 2020     
     39DC 20       
0252                       even
0253               
0254               txt.ws5
0255 39DE 05               byte  5
0256 39DF   20             text  '     '
     39E0 2020     
     39E2 2020     
0257                       even
0258               
0259      39D8     txt.filetype.none  equ txt.ws4
0260               
0261               
0262               ;--------------------------------------------------------------
0263               ; Strings for error line pane
0264               ;--------------------------------------------------------------
0265               txt.ioerr.load
0266 39E4 15               byte  21
0267 39E5   46             text  'Failed loading file: '
     39E6 6169     
     39E8 6C65     
     39EA 6420     
     39EC 6C6F     
     39EE 6164     
     39F0 696E     
     39F2 6720     
     39F4 6669     
     39F6 6C65     
     39F8 3A20     
0268                       even
0269               
0270               txt.ioerr.save
0271 39FA 14               byte  20
0272 39FB   46             text  'Failed saving file: '
     39FC 6169     
     39FE 6C65     
     3A00 6420     
     3A02 7361     
     3A04 7669     
     3A06 6E67     
     3A08 2066     
     3A0A 696C     
     3A0C 653A     
     3A0E 20       
0273                       even
0274               
0275               txt.ioerr.print
0276 3A10 1B               byte  27
0277 3A11   46             text  'Failed printing to device: '
     3A12 6169     
     3A14 6C65     
     3A16 6420     
     3A18 7072     
     3A1A 696E     
     3A1C 7469     
     3A1E 6E67     
     3A20 2074     
     3A22 6F20     
     3A24 6465     
     3A26 7669     
     3A28 6365     
     3A2A 3A20     
0278                       even
0279               
0280               txt.io.nofile
0281 3A2C 16               byte  22
0282 3A2D   4E             text  'No filename specified.'
     3A2E 6F20     
     3A30 6669     
     3A32 6C65     
     3A34 6E61     
     3A36 6D65     
     3A38 2073     
     3A3A 7065     
     3A3C 6369     
     3A3E 6669     
     3A40 6564     
     3A42 2E       
0283                       even
0284               
0285               txt.memfull.load
0286 3A44 2D               byte  45
0287 3A45   49             text  'Index full. File too large for editor buffer.'
     3A46 6E64     
     3A48 6578     
     3A4A 2066     
     3A4C 756C     
     3A4E 6C2E     
     3A50 2046     
     3A52 696C     
     3A54 6520     
     3A56 746F     
     3A58 6F20     
     3A5A 6C61     
     3A5C 7267     
     3A5E 6520     
     3A60 666F     
     3A62 7220     
     3A64 6564     
     3A66 6974     
     3A68 6F72     
     3A6A 2062     
     3A6C 7566     
     3A6E 6665     
     3A70 722E     
0288                       even
0289               
0290               txt.block.inside
0291 3A72 2D               byte  45
0292 3A73   43             text  'Copy/Move target must be outside M1-M2 range.'
     3A74 6F70     
     3A76 792F     
     3A78 4D6F     
     3A7A 7665     
     3A7C 2074     
     3A7E 6172     
     3A80 6765     
     3A82 7420     
     3A84 6D75     
     3A86 7374     
     3A88 2062     
     3A8A 6520     
     3A8C 6F75     
     3A8E 7473     
     3A90 6964     
     3A92 6520     
     3A94 4D31     
     3A96 2D4D     
     3A98 3220     
     3A9A 7261     
     3A9C 6E67     
     3A9E 652E     
0293                       even
0294               
0295               
0296               ;--------------------------------------------------------------
0297               ; Strings for command buffer
0298               ;--------------------------------------------------------------
0299               txt.cmdb.prompt
0300 3AA0 01               byte  1
0301 3AA1   3E             text  '>'
0302                       even
0303               
0304               txt.colorscheme
0305 3AA2 0D               byte  13
0306 3AA3   43             text  'Color scheme:'
     3AA4 6F6C     
     3AA6 6F72     
     3AA8 2073     
     3AAA 6368     
     3AAC 656D     
     3AAE 653A     
0307                       even
0308               
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
0008 3AB0 06               byte  6
0009 3AB1   50             text  'PI.PIO'
     3AB2 492E     
     3AB4 5049     
     3AB6 4F       
0010                       even
0011               
0012               def.clip.fname
0013 3AB8 09               byte  9
0014 3AB9   44             text  'DSK1.CLIP'
     3ABA 534B     
     3ABC 312E     
     3ABE 434C     
     3AC0 4950     
0015                       even
0016               
0017               def.clip.fname.b
0018 3AC2 09               byte  9
0019 3AC3   44             text  'DSK2.CLIP'
     3AC4 534B     
     3AC6 322E     
     3AC8 434C     
     3ACA 4950     
0020                       even
0021               
0022               def.clip.fname.c
0023 3ACC 09               byte  9
0024 3ACD   54             text  'TIPI.CLIP'
     3ACE 4950     
     3AD0 492E     
     3AD2 434C     
     3AD4 4950     
0025                       even
0026               
0027               def.devices
0028 3AD6 2F               byte  47
0029 3AD7   2C             text  ',DSK,HDX,IDE,PI.,PIO,TIPI.,RD,SCS,SDD,WDS,RS232'
     3AD8 4453     
     3ADA 4B2C     
     3ADC 4844     
     3ADE 582C     
     3AE0 4944     
     3AE2 452C     
     3AE4 5049     
     3AE6 2E2C     
     3AE8 5049     
     3AEA 4F2C     
     3AEC 5449     
     3AEE 5049     
     3AF0 2E2C     
     3AF2 5244     
     3AF4 2C53     
     3AF6 4353     
     3AF8 2C53     
     3AFA 4444     
     3AFC 2C57     
     3AFE 4453     
     3B00 2C52     
     3B02 5332     
     3B04 3332     
0030                       even
0031               
                   < ram.resident.asm
                   < stevie_b1.asm.33260
0038                       ;------------------------------------------------------
0039                       ; Activate bank 1 and branch to  >6036
0040                       ;------------------------------------------------------
0041 3B06 04E0  34         clr   @bank1.rom            ; Activate bank 1 "James" ROM
     3B08 6002     
0042               
0046               
0047 3B0A 0460  28         b     @kickstart.code2      ; Jump to entry routine
     3B0C 6046     
0048               ***************************************************************
0049               * Step 3: Include main editor modules
0050               ********|*****|*********************|**************************
0051               main:
0052                       aorg  kickstart.code2       ; >6046
0053 6046 0460  28         b     @main.stevie          ; Start editor
     6048 604A     
0054                       ;-----------------------------------------------------------------------
0055                       ; Include files
0056                       ;-----------------------------------------------------------------------
0057                       copy  "main.asm"                    ; Main file (entrypoint)
     **** ****     > main.asm
0001               * FILE......: main.asm
0002               * Purpose...: Stevie Editor - Main editor module
0003               
0004               ***************************************************************
0005               * main
0006               * Initialize editor
0007               ***************************************************************
0008               * b   @main.stevie
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * -
0018               *--------------------------------------------------------------
0019               * Notes
0020               * Main entry point for stevie editor
0021               ***************************************************************
0022               
0023               
0024               ***************************************************************
0025               * Main
0026               ********|*****|*********************|**************************
0027               main.stevie:
0028 604A 20A0  38         coc   @wbit1,config         ; F18a detected?
     604C 201E     
0029 604E 1301  14         jeq   main.continue
0030 6050 1000  14         nop                         ; Ignore for now if no f18a detected
0031               
0032               main.continue:
0033                       ; data  c99_ovrd            ; classic99: Put CPU in overdrive mode
0034               
0035               
0036                       ;------------------------------------------------------
0037                       ; Setup F18A VDP
0038                       ;------------------------------------------------------
0039 6052 06A0  32         bl    @mute                 ; Turn sound generators off
     6054 280E     
0040 6056 06A0  32         bl    @scroff               ; Turn screen off
     6058 269A     
0041               
0042 605A 06A0  32         bl    @f18unl               ; Unlock the F18a
     605C 273E     
0043               
0050               
0051 605E 06A0  32         bl    @putvr                ; Turn on position based attributes
     6060 2346     
0052 6062 3202                   data >3202            ; F18a VR50 (>32), bit 2
0053               
0054 6064 06A0  32         BL    @putvr                ; Set VDP TAT base address for position
     6066 2346     
0055 6068 0360                   data >0360            ; based attributes (>40 * >60 = >1800)
0056                       ;------------------------------------------------------
0057                       ; Clear screen (VDP SIT)
0058                       ;------------------------------------------------------
0059 606A 06A0  32         bl    @filv
     606C 22A2     
0060 606E 0000                   data >0000,32,vdp.sit.size
     6070 0020     
     6072 0780     
0061                                                   ; Clear screen
0062                       ;------------------------------------------------------
0063                       ; Initialize high memory expansion
0064                       ;------------------------------------------------------
0065 6074 06A0  32         bl    @film
     6076 224A     
0066 6078 A000                   data >a000,00,20000   ; Clear a000-eedf
     607A 0000     
     607C 4E20     
0067                       ;------------------------------------------------------
0068                       ; Setup cursor, screen, etc.
0069                       ;------------------------------------------------------
0070 607E 06A0  32         bl    @smag1x               ; Sprite magnification 1x
     6080 26BA     
0071 6082 06A0  32         bl    @s8x8                 ; Small sprite
     6084 26CA     
0072               
0073 6086 06A0  32         bl    @cpym2m
     6088 24EE     
0074 608A 366E                   data romsat,ramsat,14 ; Load sprite SAT
     608C A056     
     608E 000E     
0075               
0076 6090 C820  54         mov   @romsat+2,@tv.curshape
     6092 3670     
     6094 A214     
0077                                                   ; Save cursor shape & color
0078               
0079 6096 06A0  32         bl    @vdp.patterns.dump    ; Load sprite and character patterns
     6098 7BBA     
0080               *--------------------------------------------------------------
0081               * Initialize
0082               *--------------------------------------------------------------
0083 609A 06A0  32         bl    @mem.sams.setup.stevie
     609C 60F6     
0084                                                   ; Load SAMS pages for stevie
0085               
0086 609E 06A0  32         bl    @tv.init              ; Initialize editor configuration
     60A0 326E     
0087 60A2 06A0  32         bl    @tv.reset             ; Reset editor
     60A4 32C2     
0088                       ;------------------------------------------------------
0089                       ; Load colorscheme amd turn on screen
0090                       ;------------------------------------------------------
0091 60A6 04E0  34         clr   @parm1                ; Screen off while reloading color scheme
     60A8 A006     
0092 60AA 04E0  34         clr   @parm2                ; Don't skip colorizing marked lines
     60AC A008     
0093 60AE 04E0  34         clr   @parm3                ; Colorize all panes
     60B0 A00A     
0094               
0095 60B2 06A0  32         bl    @pane.action.colorscheme.load
     60B4 72FE     
0096                                                   ; Reload color scheme
0097                                                   ; \ i  @parm1 = Skip screen off if >FFFF
0098                                                   ; | i  @parm2 = Skip colorizing marked lines
0099                                                   ; |             if >FFFF
0100                                                   ; | i  @parm3 = Only colorize CMDB pane
0101                                                   ; /             if >FFFF
0102                       ;-------------------------------------------------------
0103                       ; Setup editor tasks
0104                       ;-------------------------------------------------------
0105 60B6 06A0  32         bl    @at
     60B8 26DA     
0106 60BA 0000                   data  >0000           ; Cursor YX position = >0000
0107               
0108 60BC 0204  20         li    tmp0,timers           ; \ Set pointer to timers table
     60BE A064     
0109 60C0 C804  38         mov   tmp0,@wtitab          ; /
     60C2 832C     
0110               
0121               
0122 60C4 06A0  32         bl    @mkslot
     60C6 2EA0     
0123 60C8 0002                   data >0002,task.vdp.panes    ; Task 0 - Draw VDP editor panes
     60CA 7286     
0124 60CC 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle VDP cursor shape
     60CE 71FE     
0125 60D0 0360                   data >0360,task.oneshot      ; Task 3 - One shot task
     60D2 7294     
0126 60D4 FFFF                   data eol
0127               
0129               
0130 60D6 0204  20         li    tmp0,>0300            ; \ Set highest slot to use in MSB.
     60D8 0300     
0131 60DA C804  38         mov   tmp0,@btihi           ; / Tell Task Scheduler
     60DC 8314     
0132                       ;-------------------------------------------------------
0133                       ; Setup keyboard scanning and start kernel/timers
0134                       ;-------------------------------------------------------
0135 60DE 06A0  32         bl    @mkhook
     60E0 2E8C     
0136 60E2 6114                   data edkey.keyscan.hook
0137                                                   ; Setup keyboard scanning hook
0138                       ;-------------------------------------------------------
0139                       ; Initialisation complete
0140                       ;-------------------------------------------------------
0141 60E4 06A0  32         bl    @magic.set            ; Set magic string
     60E6 7C64     
0142               
0143 60E8 0204  20         li    tmp0,>37D7            ; \ Silence classic99 debugger console,
     60EA 37D7     
0144 60EC C804  38         mov   tmp0,@>8370           ; | otherwise message flood with text
     60EE 8370     
0145 60F0 04C4  14         clr   tmp0                  ; / "VDP disk buffer header corrupted at PC"
0146                       ;-------------------------------------------------------
0147                       ; Start kernel
0148                       ;-------------------------------------------------------
0149 60F2 0460  28         b     @tmgr                 ; Run kernel and timers
     60F4 2DD8     
                   < stevie_b1.asm.33260
0058                       ;-----------------------------------------------------------------------
0059                       ; Low-level modules
0060                       ;-----------------------------------------------------------------------
0061                       copy  "mem.sams.setup.asm"          ; SAMS memory setup for Stevie
     **** ****     > mem.sams.setup.asm
0001               * FILE......: mem.sams.setup.asm
0002               * Purpose...: SAMS Memory setup for Stevie
0003               
0004               ***************************************************************
0005               * mem.sams.setup.stevie
0006               * Setup SAMS memory pages for Stevie
0007               ***************************************************************
0008               * bl  @mem.sams.setup.stevie
0009               *--------------------------------------------------------------
0010               * OUTPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * Register usage
0014               * none
0015               ***************************************************************
0016               mem.sams.setup.stevie:
0017 60F6 0649  14         dect  stack
0018 60F8 C64B  30         mov   r11,*stack            ; Save return address
0019                       ;------------------------------------------------------
0020                       ; Set SAMS standard layout
0021                       ;------------------------------------------------------
0022 60FA 06A0  32         bl    @mem.sams.set.boot    ; Set SAMS banks in boot for Stevie
     60FC 7C40     
0023               
0024 60FE 06A0  32         bl    @sams.layout.copy
     6100 2652     
0025 6102 A200                   data tv.sams.2000     ; Copy SAMS bank ID to shadow table.
0026               
0027 6104 C820  54         mov   @tv.sams.c000,@edb.sams.page
     6106 A208     
     6108 A516     
0028 610A C820  54         mov   @edb.sams.page,@edb.sams.hipage
     610C A516     
     610E A518     
0029                                                   ; Track editor buffer SAMS page
0030                       ;------------------------------------------------------
0031                       ; Exit
0032                       ;------------------------------------------------------
0033               mem.sams.setup.stevie.exit:
0034 6110 C2F9  30         mov   *stack+,r11           ; Pop r11
0035 6112 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.33260
0062                       ;-----------------------------------------------------------------------
0063                       ; Keyboard actions
0064                       ;-----------------------------------------------------------------------
0065                       copy  "edkey.key.hook.asm"          ; SP2 user hook: keyboard scanning
     **** ****     > edkey.key.hook.asm
0001               * FILE......: edkey.key.hook.asm
0002               * Purpose...: Keyboard handling (spectra2 user hook)
0003               
0004               
0005               ****************************************************************
0006               * Editor - spectra2 user hook
0007               ****************************************************************
0008               edkey.keyscan.hook:
0009                       ;-------------------------------------------------------
0010                       ; Abort if stack is leaking garbage
0011                       ;-------------------------------------------------------
0012 6114 0289  22         ci    stack,sp2.stktop      ; There shouldn't be anything
     6116 A900     
0013                                                   ; on the stack anymore.
0014               
0015 6118 1304  14         jeq   !                     ; ok, continue
0016                       ;-------------------------------------------------------
0017                       ; Assert failed
0018                       ;-------------------------------------------------------
0019 611A C80B  38         mov   r11,@>ffce            ; \ Save caller address
     611C FFCE     
0020 611E 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6120 2026     
0021                       ;-------------------------------------------------------
0022                       ; Check if key pressed
0023                       ;-------------------------------------------------------
0024 6122 20A0  38 !       coc   @wbit11,config        ; ANYKEY pressed ?
     6124 200A     
0025 6126 160A  14         jne   edkey.keyscan.hook.clear
0026                                                   ; No, clear buffer and exit
0027                       ;------------------------------------------------------
0028                       ; Reset flags
0029                       ;------------------------------------------------------
0030 6128 40A0  34         szc   @wbit11,config        ; Reset ANYKEY
     612A 200A     
0031 612C 4820  54         szc   @w$0001,@kbflags      ; Remove keyboard buffer cleared flag
     612E 2002     
     6130 A026     
0032                       ;------------------------------------------------------
0033                       ; Key pressed
0034                       ;------------------------------------------------------
0035 6132 C820  54         mov   @keycode1,@keycode2   ; Save as previous key
     6134 A028     
     6136 A02A     
0036 6138 0460  28         b     @edkey.key.process    ; Process key
     613A 615C     
0037                       ;------------------------------------------------------
0038                       ; Clear keyboard buffer if no key pressed
0039                       ;------------------------------------------------------
0040               edkey.keyscan.hook.clear:
0041 613C C120  34         mov   @kbflags,tmp0         ; Get keyboard control flags
     613E A026     
0042 6140 2120  38         coc   @w$0001,tmp0          ; Keyboard buffer already cleared?
     6142 2002     
0043 6144 1309  14         jeq   edkey.keyscan.hook.exit
0044                                                   ; Yes, skip to exit
0045               
0046 6146 04E0  34         clr   @keycode1             ; \
     6148 A028     
0047 614A 04E0  34         clr   @keycode2             ; | Clear keyboard buffer and set
     614C A02A     
0048 614E 0264  22         ori   tmp0,kbf.kbclear      ; | keyboard buffer cleared flag
     6150 0001     
0049 6152 C804  38         mov   tmp0,@kbflags         ; /
     6154 A026     
0050                       ;------------------------------------------------------
0051                       ; Keyboard debounce
0052                       ;------------------------------------------------------
0053               edkey.keyscan.hook.debounce:
0054 6156 1000  14         nop                         ; No purpose anymore, but branched to
0055                                                   ; from several subroutines.
0056                                                   ; Needs to be refactored.
0057                       ;------------------------------------------------------
0058                       ; Exit keyboard hook
0059                       ;------------------------------------------------------
0060               edkey.keyscan.hook.exit:
0061 6158 0460  28         b     @hookok               ; Return
     615A 2DDC     
                   < stevie_b1.asm.33260
0066                       copy  "edkey.key.process.asm"       ; Process keyboard actions
     **** ****     > edkey.key.process.asm
0001               * FILE......: edkey.key.process.asm
0002               * Purpose...: Process keyboard key press. Shared code for all panes
0003               
0004               ****************************************************************
0005               * Editor - Process action keys
0006               ****************************************************************
0007               edkey.key.process:
0008 615C C160  34         mov   @keycode1,tmp1        ; Get key pressed
     615E A028     
0009 6160 0A85  56         sla   tmp1,8                ; Move to MSB
0010 6162 0707  14         seto  tmp3                  ; EOL marker
0011                       ;-------------------------------------------------------
0012                       ; (1) Process key depending on pane with focus
0013                       ;-------------------------------------------------------
0014 6164 C1A0  34         mov   @tv.pane.focus,tmp2
     6166 A222     
0015 6168 0286  22         ci    tmp2,pane.focus.fb    ; Framebuffer has focus ?
     616A 0000     
0016 616C 1307  14         jeq   edkey.key.process.special
0017                                                   ; First check special key combinations
0018               
0019 616E 0286  22         ci    tmp2,pane.focus.cmdb  ; Command buffer has focus ?
     6170 0001     
0020 6172 1322  14         jeq   edkey.key.process.loadmap.cmdb
0021                                                   ; Yes, so load CMDB keymap
0022                       ;-------------------------------------------------------
0023                       ; Pane without focus, crash
0024                       ;-------------------------------------------------------
0025 6174 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6176 FFCE     
0026 6178 06A0  32         bl    @cpu.crash            ; / File error occured. Halt system.
     617A 2026     
0027                       ;-------------------------------------------------------
0028                       ; (2) Check special key combination
0029                       ;-------------------------------------------------------
0030               edkey.key.process.special:
0031 617C 0285  22         ci    tmp1,>2000            ; Space key pressed?
     617E 2000     
0032 6180 1618  14         jne   edkey.key.process.loadmap.editor
0033                                                   ; No, continue with normal checks
0034                       ;-------------------------------------------------------
0035                       ; (2a) Look for <ctrl> key
0036                       ;-------------------------------------------------------
0037 6182 0649  14         dect  stack
0038 6184 C644  30         mov   tmp0,*stack           ; Push tmp0
0039 6186 0649  14         dect  stack
0040 6188 C645  30         mov   tmp1,*stack           ; Push tmp1
0041 618A 0649  14         dect  stack
0042 618C C64C  30         mov   r12,*stack            ; Push r12
0043               
0044 618E 04C4  14         clr   tmp0                  ; Keyboard column 0
0045 6190 020C  20         li    r12,>0024             ; CRU address decoder
     6192 0024     
0046 6194 30C4  56         ldcr  tmp0,3                ; Select column
0047 6196 020C  20         li    r12,>0006             ; Address of the first row
     6198 0006     
0048 619A 3605  64         stcr  tmp1,8                ; Read 8 rows
0049 619C 0245  22         andi  tmp1,>4000            ; Test ctrl key
     619E 4000     
0050 61A0 1605  14         jne   edkey.key.process.special.postprocess
0051                                                   ; No ctrl key pressed
0052                       ;-------------------------------------------------------
0053                       ; <ctrl> + space key pressed
0054                       ;-------------------------------------------------------
0055 61A2 C339  30         mov   *stack+,r12           ; Pop r12
0056 61A4 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0057 61A6 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0058 61A8 0460  28         b     @edkey.action.block.mark
     61AA 6872     
0059                                                   ; Set block M1/M2 marker
0060                       ;-------------------------------------------------------
0061                       ; Postprocessing <ctrl> + space check
0062                       ;-------------------------------------------------------
0063               edkey.key.process.special.postprocess:
0064 61AC C339  30         mov   *stack+,r12           ; Pop r12
0065 61AE C179  30         mov   *stack+,tmp1          ; Pop tmp1
0066 61B0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0067                       ;-------------------------------------------------------
0068                       ; (3) Load Editor keyboard map
0069                       ;-------------------------------------------------------
0070               edkey.key.process.loadmap.editor:
0071 61B2 0206  20         li    tmp2,keymap_actions.editor
     61B4 7C9A     
0072 61B6 1002  14         jmp   edkey.key.check.next
0073                       ;-------------------------------------------------------
0074                       ; (4) Load CMDB keyboard map
0075                       ;-------------------------------------------------------
0076               edkey.key.process.loadmap.cmdb:
0077 61B8 0206  20         li    tmp2,keymap_actions.cmdb
     61BA 7D6C     
0078                       ;-------------------------------------------------------
0079                       ; (5) Iterate over keyboard map for matching action key
0080                       ;-------------------------------------------------------
0081               edkey.key.check.next:
0082 61BC 91D6  26         cb    *tmp2,tmp3            ; EOL reached ?
0083 61BE 1328  14         jeq   edkey.key.process.addbuffer
0084                                                   ; Yes, means no action key pressed,
0085                                                   ; so add character to buffer
0086                       ;-------------------------------------------------------
0087                       ; (6) Check for action key match
0088                       ;-------------------------------------------------------
0089 61C0 9585  30         cb    tmp1,*tmp2            ; Action key matched?
0090 61C2 130F  14         jeq   edkey.key.check.scope
0091                                                   ; Yes, check scope
0092                       ;-------------------------------------------------------
0093                       ; If key in range 'a..z' then also check 'A..Z'
0094                       ;-------------------------------------------------------
0095 61C4 0285  22         ci    tmp1,>6100            ; ASCII 97 'a'
     61C6 6100     
0096 61C8 1109  14         jlt   edkey.key.check.next.entry
0097               
0098 61CA 0285  22         ci    tmp1,>7a00            ; ASCII 122 'z'
     61CC 7A00     
0099 61CE 1506  14         jgt   edkey.key.check.next.entry
0100               
0101 61D0 0225  22         ai    tmp1,->2000           ; Make uppercase
     61D2 E000     
0102 61D4 9585  30         cb    tmp1,*tmp2            ; Action key matched?
0103 61D6 1305  14         jeq   edkey.key.check.scope
0104                                                   ; Yes, check scope
0105                       ;-------------------------------------------------------
0106                       ; Key is no action key, keep case for later (buffer)
0107                       ;-------------------------------------------------------
0108 61D8 0225  22         ai    tmp1,>2000            ; Make lowercase
     61DA 2000     
0109               
0110               edkey.key.check.next.entry:
0111 61DC 0226  22         ai    tmp2,4                ; Skip current entry
     61DE 0004     
0112 61E0 10ED  14         jmp   edkey.key.check.next  ; Check next entry
0113                       ;-------------------------------------------------------
0114                       ; (7) Check scope of key
0115                       ;-------------------------------------------------------
0116               edkey.key.check.scope:
0117 61E2 0586  14         inc   tmp2                  ; Move to scope
0118 61E4 9816  46         cb    *tmp2,@tv.pane.focus+1
     61E6 A223     
0119                                                   ; (1) Process key if scope matches pane
0120 61E8 1309  14         jeq   edkey.key.process.action
0121               
0122 61EA 9816  46         cb    *tmp2,@cmdb.dialog+1  ; (2) Process key if scope matches dialog
     61EC A71B     
0123 61EE 1306  14         jeq   edkey.key.process.action
0124                       ;-------------------------------------------------------
0125                       ; (8) Key pressed outside valid scope, ignore action entry
0126                       ;-------------------------------------------------------
0127 61F0 0226  22         ai    tmp2,3                ; Skip current entry
     61F2 0003     
0128 61F4 C160  34         mov   @keycode1,tmp1        ; Restore original case of key
     61F6 A028     
0129 61F8 0A85  56         sla   tmp1,8                ; Move to MSB
0130 61FA 10E0  14         jmp   edkey.key.check.next  ; Process next action entry
0131                       ;-------------------------------------------------------
0132                       ; (9) Trigger keyboard action
0133                       ;-------------------------------------------------------
0134               edkey.key.process.action:
0135 61FC 0586  14         inc   tmp2                  ; Move to action address
0136 61FE C196  26         mov   *tmp2,tmp2            ; Get action address
0137               
0138 6200 0204  20         li    tmp0,id.dialog.unsaved
     6202 0065     
0139 6204 8120  34         c     @cmdb.dialog,tmp0
     6206 A71A     
0140 6208 1302  14         jeq   !                     ; Skip store pointer if in "Unsaved changes"
0141               
0142 620A C806  38         mov   tmp2,@cmdb.action.ptr ; Store action address as pointer
     620C A728     
0143 620E 0456  20 !       b     *tmp2                 ; Process key action
0144                       ;-------------------------------------------------------
0145                       ; (10) Add character to editor or cmdb buffer
0146                       ;-------------------------------------------------------
0147               edkey.key.process.addbuffer:
0148 6210 C120  34         mov   @tv.pane.focus,tmp0   ; Frame buffer has focus?
     6212 A222     
0149 6214 1602  14         jne   !                     ; No, skip frame buffer
0150 6216 0460  28         b     @edkey.action.char    ; Add character to frame buffer
     6218 675C     
0151                       ;-------------------------------------------------------
0152                       ; (11) CMDB buffer
0153                       ;-------------------------------------------------------
0154 621A 0284  22 !       ci    tmp0,pane.focus.cmdb  ; CMDB has focus ?
     621C 0001     
0155 621E 1607  14         jne   edkey.key.process.crash
0156                                                   ; No, crash
0157                       ;-------------------------------------------------------
0158                       ; Don't add character if dialog has ID >= 100
0159                       ;-------------------------------------------------------
0160 6220 C120  34         mov   @cmdb.dialog,tmp0
     6222 A71A     
0161 6224 0284  22         ci    tmp0,99
     6226 0063     
0162 6228 1506  14         jgt   edkey.key.process.exit
0163                       ;-------------------------------------------------------
0164                       ; Add character to CMDB
0165                       ;-------------------------------------------------------
0166 622A 0460  28         b     @edkey.action.cmdb.char
     622C 69D8     
0167                                                   ; Add character to CMDB buffer
0168                       ;-------------------------------------------------------
0169                       ; Crash
0170                       ;-------------------------------------------------------
0171               edkey.key.process.crash:
0172 622E C80B  38         mov   r11,@>ffce            ; \ Save caller address
     6230 FFCE     
0173 6232 06A0  32         bl    @cpu.crash            ; / File error occured. Halt system.
     6234 2026     
0174                       ;-------------------------------------------------------
0175                       ; Exit
0176                       ;-------------------------------------------------------
0177               edkey.key.process.exit:
0178 6236 0460  28         b     @edkey.keyscan.hook.debounce
     6238 6156     
0179                                                   ; Back to editor main
                   < stevie_b1.asm.33260
0067                       ;-----------------------------------------------------------------------
0068                       ; Keyboard actions - Framebuffer (1)
0069                       ;-----------------------------------------------------------------------
0070                       copy  "edkey.fb.mov.leftright.asm"  ; Move left / right / home / end
     **** ****     > edkey.fb.mov.leftright.asm
0001               * FILE......: edkey.fb.mov.leftright.asm
0002               * Purpose...: Actions for movement keys in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor left
0006               *---------------------------------------------------------------
0007               edkey.action.left:
0008 623A C120  34         mov   @fb.column,tmp0
     623C A30C     
0009 623E 1308  14         jeq   !                     ; column=0 ? Skip further processing
0010                       ;-------------------------------------------------------
0011                       ; Update
0012                       ;-------------------------------------------------------
0013 6240 0620  34         dec   @fb.column            ; Column-- in screen buffer
     6242 A30C     
0014 6244 0620  34         dec   @wyx                  ; Column-- VDP cursor
     6246 832A     
0015 6248 0620  34         dec   @fb.current
     624A A302     
0016 624C 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     624E A31A     
0017                       ;-------------------------------------------------------
0018                       ; Exit
0019                       ;-------------------------------------------------------
0020 6250 0460  28 !       b     @edkey.keyscan.hook.debounce
     6252 6156     
0021                                                   ; Back to editor main
0022               
0023               
0024               *---------------------------------------------------------------
0025               * Cursor right
0026               *---------------------------------------------------------------
0027               edkey.action.right:
0028 6254 8820  54         c     @fb.column,@fb.row.length
     6256 A30C     
     6258 A308     
0029 625A 1408  14         jhe   !                     ; column > length line ? Skip processing
0030                       ;-------------------------------------------------------
0031                       ; Update
0032                       ;-------------------------------------------------------
0033 625C 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     625E A30C     
0034 6260 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     6262 832A     
0035 6264 05A0  34         inc   @fb.current
     6266 A302     
0036 6268 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     626A A31A     
0037                       ;-------------------------------------------------------
0038                       ; Exit
0039                       ;-------------------------------------------------------
0040 626C 0460  28 !       b     @edkey.keyscan.hook.debounce
     626E 6156     
0041                                                   ; Back to editor main
0042               
0043               
0044               *---------------------------------------------------------------
0045               * Cursor beginning of line
0046               *---------------------------------------------------------------
0047               edkey.action.home:
0048 6270 06A0  32         bl    @fb.cursor.home       ; Move cursor to beginning of line
     6272 6E8C     
0049                       ;-------------------------------------------------------
0050                       ; Exit
0051                       ;-------------------------------------------------------
0052 6274 0460  28         b     @edkey.keyscan.hook.debounce
     6276 6156     
0053                                                   ; Back to editor main
0054               
0055               
0056               *---------------------------------------------------------------
0057               * Cursor end of line
0058               *---------------------------------------------------------------
0059               edkey.action.end:
0060 6278 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     627A A31A     
0061 627C C120  34         mov   @fb.row.length,tmp0   ; \ Get row length
     627E A308     
0062 6280 0284  22         ci    tmp0,80               ; | Adjust if necessary, normally cursor
     6282 0050     
0063 6284 1102  14         jlt   !                     ; | is right of last character on line,
0064 6286 0204  20         li    tmp0,79               ; / except if 80 characters on line.
     6288 004F     
0065                       ;-------------------------------------------------------
0066                       ; Set cursor X position
0067                       ;-------------------------------------------------------
0068 628A C804  38 !       mov   tmp0,@fb.column       ; Set X position, cursor following char.
     628C A30C     
0069 628E 06A0  32         bl    @xsetx                ; Set VDP cursor column position
     6290 26F2     
0070 6292 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6294 3094     
0071                       ;-------------------------------------------------------
0072                       ; Exit
0073                       ;-------------------------------------------------------
0074 6296 0460  28         b     @edkey.keyscan.hook.debounce
     6298 6156     
0075                                                   ; Back to editor main
                   < stevie_b1.asm.33260
0071                       copy  "edkey.fb.mov.word.asm"       ; Move previous / next word
     **** ****     > edkey.fb.mov.word.asm
0001               * FILE......: edkey.fb.mov.asm
0002               * Purpose...: Actions for moving to words in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor beginning of word or previous word
0006               *---------------------------------------------------------------
0007               edkey.action.pword:
0008 629A 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     629C A31A     
0009 629E C120  34         mov   @fb.column,tmp0
     62A0 A30C     
0010 62A2 1322  14         jeq   !                     ; column=0 ? Skip further processing
0011                       ;-------------------------------------------------------
0012                       ; Prepare 2 char buffer
0013                       ;-------------------------------------------------------
0014 62A4 C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     62A6 A302     
0015 62A8 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0016 62AA 1003  14         jmp   edkey.action.pword_scan_char
0017                       ;-------------------------------------------------------
0018                       ; Scan backwards to first character following space
0019                       ;-------------------------------------------------------
0020               edkey.action.pword_scan
0021 62AC 0605  14         dec   tmp1
0022 62AE 0604  14         dec   tmp0                  ; Column-- in screen buffer
0023 62B0 1315  14         jeq   edkey.action.pword_done
0024                                                   ; Column=0 ? Skip further processing
0025                       ;-------------------------------------------------------
0026                       ; Check character
0027                       ;-------------------------------------------------------
0028               edkey.action.pword_scan_char
0029 62B2 D195  26         movb  *tmp1,tmp2            ; Get character
0030 62B4 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0031 62B6 D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0032 62B8 0986  56         srl   tmp2,8                ; Right justify
0033 62BA 0286  22         ci    tmp2,32               ; Space character found?
     62BC 0020     
0034 62BE 16F6  14         jne   edkey.action.pword_scan
0035                                                   ; No space found, try again
0036                       ;-------------------------------------------------------
0037                       ; Space found, now look closer
0038                       ;-------------------------------------------------------
0039 62C0 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     62C2 2020     
0040 62C4 13F3  14         jeq   edkey.action.pword_scan
0041                                                   ; Yes, so continue scanning
0042 62C6 0287  22         ci    tmp3,>20ff            ; First character is space
     62C8 20FF     
0043 62CA 13F0  14         jeq   edkey.action.pword_scan
0044                       ;-------------------------------------------------------
0045                       ; Check distance travelled
0046                       ;-------------------------------------------------------
0047 62CC C1E0  34         mov   @fb.column,tmp3       ; re-use tmp3
     62CE A30C     
0048 62D0 61C4  18         s     tmp0,tmp3
0049 62D2 0287  22         ci    tmp3,2                ; Did we move at least 2 positions?
     62D4 0002     
0050 62D6 11EA  14         jlt   edkey.action.pword_scan
0051                                                   ; Didn't move enough so keep on scanning
0052                       ;--------------------------------------------------------
0053                       ; Set cursor following space
0054                       ;--------------------------------------------------------
0055 62D8 0585  14         inc   tmp1
0056 62DA 0584  14         inc   tmp0                  ; Column++ in screen buffer
0057                       ;-------------------------------------------------------
0058                       ; Save position and position hardware cursor
0059                       ;-------------------------------------------------------
0060               edkey.action.pword_done:
0061 62DC C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     62DE A30C     
0062 62E0 06A0  32         bl    @xsetx                ; Set VDP cursor X
     62E2 26F2     
0063                       ;-------------------------------------------------------
0064                       ; Exit
0065                       ;-------------------------------------------------------
0066               edkey.action.pword.exit:
0067 62E4 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     62E6 3094     
0068 62E8 0460  28 !       b     @edkey.keyscan.hook.debounce; Back to editor main
     62EA 6156     
0069               
0070               
0071               
0072               *---------------------------------------------------------------
0073               * Cursor next word
0074               *---------------------------------------------------------------
0075               edkey.action.nword:
0076 62EC 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     62EE A31A     
0077 62F0 04C8  14         clr   tmp4                  ; Reset multiple spaces mode
0078 62F2 C120  34         mov   @fb.column,tmp0
     62F4 A30C     
0079 62F6 8804  38         c     tmp0,@fb.row.length
     62F8 A308     
0080 62FA 1426  14         jhe   !                     ; column=last char ? Skip further processing
0081                       ;-------------------------------------------------------
0082                       ; Prepare 2 char buffer
0083                       ;-------------------------------------------------------
0084 62FC C160  34         mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
     62FE A302     
0085 6300 0707  14         seto  tmp3                  ; Fill 2 char buffer with >ffff
0086 6302 1006  14         jmp   edkey.action.nword_scan_char
0087                       ;-------------------------------------------------------
0088                       ; Multiple spaces mode
0089                       ;-------------------------------------------------------
0090               edkey.action.nword_ms:
0091 6304 0708  14         seto  tmp4                  ; Set multiple spaces mode
0092                       ;-------------------------------------------------------
0093                       ; Scan forward to first character following space
0094                       ;-------------------------------------------------------
0095               edkey.action.nword_scan
0096 6306 0585  14         inc   tmp1
0097 6308 0584  14         inc   tmp0                  ; Column++ in screen buffer
0098 630A 8804  38         c     tmp0,@fb.row.length
     630C A308     
0099 630E 1316  14         jeq   edkey.action.nword_done
0100                                                   ; Column=last char ? Skip further processing
0101                       ;-------------------------------------------------------
0102                       ; Check character
0103                       ;-------------------------------------------------------
0104               edkey.action.nword_scan_char
0105 6310 D195  26         movb  *tmp1,tmp2            ; Get character
0106 6312 0987  56         srl   tmp3,8                ; Shift-out old character in buffer
0107 6314 D1C6  18         movb  tmp2,tmp3             ; Shift-in new character in buffer
0108 6316 0986  56         srl   tmp2,8                ; Right justify
0109               
0110 6318 0288  22         ci    tmp4,>ffff            ; Multiple space mode on?
     631A FFFF     
0111 631C 1604  14         jne   edkey.action.nword_scan_char_other
0112                       ;-------------------------------------------------------
0113                       ; Special handling if multiple spaces found
0114                       ;-------------------------------------------------------
0115               edkey.action.nword_scan_char_ms:
0116 631E 0286  22         ci    tmp2,32
     6320 0020     
0117 6322 160C  14         jne   edkey.action.nword_done
0118                                                   ; Exit if non-space found
0119 6324 10F0  14         jmp   edkey.action.nword_scan
0120                       ;-------------------------------------------------------
0121                       ; Normal handling
0122                       ;-------------------------------------------------------
0123               edkey.action.nword_scan_char_other:
0124 6326 0286  22         ci    tmp2,32               ; Space character found?
     6328 0020     
0125 632A 16ED  14         jne   edkey.action.nword_scan
0126                                                   ; No space found, try again
0127                       ;-------------------------------------------------------
0128                       ; Space found, now look closer
0129                       ;-------------------------------------------------------
0130 632C 0287  22         ci    tmp3,>2020            ; current and previous char both spaces?
     632E 2020     
0131 6330 13E9  14         jeq   edkey.action.nword_ms
0132                                                   ; Yes, so continue scanning
0133 6332 0287  22         ci    tmp3,>20ff            ; First characer is space?
     6334 20FF     
0134 6336 13E7  14         jeq   edkey.action.nword_scan
0135                       ;--------------------------------------------------------
0136                       ; Set cursor following space
0137                       ;--------------------------------------------------------
0138 6338 0585  14         inc   tmp1
0139 633A 0584  14         inc   tmp0                  ; Column++ in screen buffer
0140                       ;-------------------------------------------------------
0141                       ; Save position and position hardware cursor
0142                       ;-------------------------------------------------------
0143               edkey.action.nword_done:
0144 633C C804  38         mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
     633E A30C     
0145 6340 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6342 26F2     
0146                       ;-------------------------------------------------------
0147                       ; Exit
0148                       ;-------------------------------------------------------
0149               edkey.action.nword.exit:
0150 6344 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6346 3094     
0151 6348 0460  28 !       b     @edkey.keyscan.hook.debounce; Back to editor main
     634A 6156     
0152               
0153               
                   < stevie_b1.asm.33260
0072                       copy  "edkey.fb.mov.hscroll.asm"    ; Scroll left / right
     **** ****     > edkey.fb.mov.hscroll.asm
0001               * FILE......: edkey.fb.mov.hscroll.asm
0002               * Purpose...: Horizontal scroll current page in editor buffer
0003               
0004               *---------------------------------------------------------------
0005               * Scroll right
0006               *---------------------------------------------------------------
0007               edkey.action.scroll.right:
0008 634C C120  34         mov   @fb.vwco,tmp0
     634E A310     
0009 6350 0284  22         ci    tmp0,240
     6352 00F0     
0010 6354 1102  14         jlt   !
0011               
0012                       ;-------------------------------------------------------
0013                       ; Reset View Window Column Offset
0014                       ;-------------------------------------------------------
0015 6356 04C4  14         clr   tmp0                  ; Reset view window column offset
0016 6358 1002  14         jmp   edkey.action.scroll.right.vwco
0017 635A 0224  22 !       ai    tmp0,20               ; Scroll right
     635C 0014     
0018                       ;-------------------------------------------------------
0019                       ; Set view window column offset
0020                       ;-------------------------------------------------------
0021               edkey.action.scroll.right.vwco:
0022 635E C804  38         mov   tmp0,@fb.vwco         ; Save value
     6360 A310     
0023               
0024 6362 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6364 A31A     
0025 6366 0720  34         seto  @fb.dirty             ; Trigger refresh
     6368 A318     
0026               
0027 636A C820  54         mov   @fb.topline,@parm1
     636C A304     
     636E A006     
0028 6370 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     6372 6F98     
0029                                                   ; | i  @parm1 = Line to start with
0030                                                   ; /             (becomes @fb.topline)
0031                       ;-------------------------------------------------------
0032                       ; Exit
0033                       ;-------------------------------------------------------
0034               edkey.action.scroll.right.exit:
0035 6374 0460  28         b     @edkey.keyscan.hook.debounce
     6376 6156     
0036                                                   ; Back to editor main
                   < stevie_b1.asm.33260
0073                       copy  "edkey.fb.mov.updown.asm"     ; Move line up / down
     **** ****     > edkey.fb.mov.updown.asm
0001               * FILE......: edkey.fb.mov.updown.asm
0002               * Purpose...: Actions for movement keys in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor up
0006               *---------------------------------------------------------------
0007               edkey.action.up:
0008 6378 06A0  32         bl    @fb.cursor.up         ; Move cursor up
     637A 6DB6     
0009                       ;-------------------------------------------------------
0010                       ; Exit
0011                       ;-------------------------------------------------------
0012               edkey.action.up.exit:
0013 637C 0460  28         b     @edkey.keyscan.hook.debounce; Back to editor main
     637E 6156     
0014               
0015               
0016               
0017               *---------------------------------------------------------------
0018               * Cursor down
0019               *---------------------------------------------------------------
0020               edkey.action.down:
0021 6380 06A0  32         bl    @fb.cursor.down       ; Move cursor down
     6382 6E14     
0022                       ;-------------------------------------------------------
0023                       ; Exit
0024                       ;-------------------------------------------------------
0025               edkey.action.down.exit:
0026 6384 0460  28         b     @edkey.keyscan.hook.debounce; Back to editor main
     6386 6156     
                   < stevie_b1.asm.33260
0074                       copy  "edkey.fb.mov.paging.asm"     ; Move page up / down
     **** ****     > edkey.fb.mov.paging.asm
0001               * FILE......: edkey.fb.mov.paging.asm
0002               * Purpose...: Move page up / down in editor buffer
0003               
0004               *---------------------------------------------------------------
0005               * Previous page
0006               *---------------------------------------------------------------
0007               edkey.action.ppage:
0008 6388 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     638A A31A     
0009                       ;-------------------------------------------------------
0010                       ; Crunch current row if dirty
0011                       ;-------------------------------------------------------
0012 638C 8820  54         c     @fb.row.dirty,@w$ffff
     638E A30A     
     6390 2022     
0013 6392 1604  14         jne   edkey.action.ppage.sanity
0014 6394 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6396 704A     
0015 6398 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     639A A30A     
0016                       ;-------------------------------------------------------
0017                       ; Assert
0018                       ;-------------------------------------------------------
0019               edkey.action.ppage.sanity:
0020 639C C120  34         mov   @fb.topline,tmp0      ; Exit if already on line 1
     639E A304     
0021 63A0 130F  14         jeq   edkey.action.ppage.exit
0022                       ;-------------------------------------------------------
0023                       ; Special treatment top page
0024                       ;-------------------------------------------------------
0025 63A2 8804  38         c     tmp0,@fb.scrrows      ; topline > rows on screen?
     63A4 A31C     
0026 63A6 1503  14         jgt   edkey.action.ppage.topline
0027 63A8 04E0  34         clr   @fb.topline           ; topline = 0
     63AA A304     
0028 63AC 1003  14         jmp   edkey.action.ppage.refresh
0029                       ;-------------------------------------------------------
0030                       ; Adjust topline
0031                       ;-------------------------------------------------------
0032               edkey.action.ppage.topline:
0033 63AE 6820  54         s     @fb.scrrows,@fb.topline
     63B0 A31C     
     63B2 A304     
0034                       ;-------------------------------------------------------
0035                       ; Refresh page
0036                       ;-------------------------------------------------------
0037               edkey.action.ppage.refresh:
0038 63B4 C820  54         mov   @fb.topline,@parm1
     63B6 A304     
     63B8 A006     
0039 63BA 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     63BC A312     
0040               
0041 63BE 1078  14         jmp   edkey.goto.fb.toprow  ; \ Position cursor and exit
0042                                                   ; / i  @parm1 = Line in editor buffer
0043                       ;-------------------------------------------------------
0044                       ; Exit
0045                       ;-------------------------------------------------------
0046               edkey.action.ppage.exit:
0047 63C0 0460  28         b     @edkey.keyscan.hook.debounce
     63C2 6156     
0048                                                   ; Back to editor main
0049               
0050               
0051               
0052               
0053               *---------------------------------------------------------------
0054               * Next page
0055               *---------------------------------------------------------------
0056               edkey.action.npage:
0057 63C4 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     63C6 A31A     
0058                       ;-------------------------------------------------------
0059                       ; Crunch current row if dirty
0060                       ;-------------------------------------------------------
0061 63C8 8820  54         c     @fb.row.dirty,@w$ffff
     63CA A30A     
     63CC 2022     
0062 63CE 1604  14         jne   edkey.action.npage.sanity
0063 63D0 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     63D2 704A     
0064 63D4 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     63D6 A30A     
0065                       ;-------------------------------------------------------
0066                       ; Assert
0067                       ;-------------------------------------------------------
0068               edkey.action.npage.sanity:
0069 63D8 C120  34         mov   @fb.topline,tmp0
     63DA A304     
0070 63DC A120  34         a     @fb.scrrows,tmp0
     63DE A31C     
0071 63E0 0584  14         inc   tmp0                  ; Base 1 offset !
0072 63E2 8804  38         c     tmp0,@edb.lines       ; Exit if on last page
     63E4 A504     
0073 63E6 1509  14         jgt   edkey.action.npage.exit
0074                       ;-------------------------------------------------------
0075                       ; Adjust topline
0076                       ;-------------------------------------------------------
0077               edkey.action.npage.topline:
0078 63E8 A820  54         a     @fb.scrrows,@fb.topline
     63EA A31C     
     63EC A304     
0079                       ;-------------------------------------------------------
0080                       ; Refresh page
0081                       ;-------------------------------------------------------
0082               edkey.action.npage.refresh:
0083 63EE C820  54         mov   @fb.topline,@parm1
     63F0 A304     
     63F2 A006     
0084 63F4 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     63F6 A312     
0085               
0086 63F8 105B  14         jmp   edkey.goto.fb.toprow  ; \ Position cursor and exit
0087                                                   ; / i  @parm1 = Line in editor buffer
0088                       ;-------------------------------------------------------
0089                       ; Exit
0090                       ;-------------------------------------------------------
0091               edkey.action.npage.exit:
0092 63FA 0460  28         b     @edkey.keyscan.hook.debounce
     63FC 6156     
0093                                                   ; Back to editor main
                   < stevie_b1.asm.33260
0075                       copy  "edkey.fb.mov.topbot.asm"     ; Move file top / bottom
     **** ****     > edkey.fb.mov.topbot.asm
0001               * FILE......: edkey.fb.mov.topbot.asm
0002               * Purpose...: Move to top / bottom in editor buffer
0003               
0004               *---------------------------------------------------------------
0005               * Goto top of file
0006               *---------------------------------------------------------------
0007               edkey.action.top:
0008                       ;-------------------------------------------------------
0009                       ; Crunch current row if dirty
0010                       ;-------------------------------------------------------
0011 63FE 8820  54         c     @fb.row.dirty,@w$ffff
     6400 A30A     
     6402 2022     
0012 6404 1604  14         jne   edkey.action.top.refresh
0013 6406 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6408 704A     
0014 640A 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     640C A30A     
0015                       ;-------------------------------------------------------
0016                       ; Refresh page
0017                       ;-------------------------------------------------------
0018               edkey.action.top.refresh:
0019 640E 04E0  34         clr   @parm1                ; Set to 1st line in editor buffer
     6410 A006     
0020 6412 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     6414 A312     
0021               
0022 6416 0460  28         b     @edkey.goto.fb.toprow ; \ Position cursor and exit
     6418 64B0     
0023                                                   ; / i  @parm1 = Line in editor buffer
0024               
0025               
0026               *---------------------------------------------------------------
0027               * Goto top of screen
0028               *---------------------------------------------------------------
0029               edkey.action.topscr:
0030                       ;-------------------------------------------------------
0031                       ; Crunch current row if dirty
0032                       ;-------------------------------------------------------
0033 641A 8820  54         c     @fb.row.dirty,@w$ffff
     641C A30A     
     641E 2022     
0034 6420 1604  14         jne   edkey.action.topscr.refresh
0035 6422 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6424 704A     
0036 6426 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6428 A30A     
0037               edkey.action.topscr.refresh:
0038 642A C820  54         mov   @fb.topline,@parm1    ; Set to top line in frame buffer
     642C A304     
     642E A006     
0039 6430 0460  28         b     @edkey.goto.fb.toprow ; \ Position cursor and exit
     6432 64B0     
0040                                                   ; / i  @parm1 = Line in editor buffer
0041               
0042               
0043               
0044               *---------------------------------------------------------------
0045               * Goto bottom of file
0046               *---------------------------------------------------------------
0047               edkey.action.bot:
0048                       ;-------------------------------------------------------
0049                       ; Crunch current row if dirty
0050                       ;-------------------------------------------------------
0051 6434 8820  54         c     @fb.row.dirty,@w$ffff
     6436 A30A     
     6438 2022     
0052 643A 1604  14         jne   edkey.action.bot.refresh
0053 643C 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     643E 704A     
0054 6440 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6442 A30A     
0055                       ;-------------------------------------------------------
0056                       ; Refresh page
0057                       ;-------------------------------------------------------
0058               edkey.action.bot.refresh:
0059 6444 8820  54         c     @edb.lines,@fb.scrrows
     6446 A504     
     6448 A31C     
0060 644A 120A  14         jle   edkey.action.bot.exit ; Skip if whole editor buffer on screen
0061               
0062 644C C120  34         mov   @edb.lines,tmp0
     644E A504     
0063 6450 6120  34         s     @fb.scrrows,tmp0
     6452 A31C     
0064 6454 C804  38         mov   tmp0,@parm1           ; Set to last page in editor buffer
     6456 A006     
0065 6458 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     645A A312     
0066               
0067 645C 0460  28         b     @edkey.goto.fb.toprow ; \ Position cursor and exit
     645E 64B0     
0068                                                   ; / i  @parm1 = Line in editor buffer
0069                       ;-------------------------------------------------------
0070                       ; Exit
0071                       ;-------------------------------------------------------
0072               edkey.action.bot.exit:
0073 6460 0460  28         b     @edkey.keyscan.hook.debounce; Back to editor main
     6462 6156     
0074               
0075               
0076               
0077               *---------------------------------------------------------------
0078               * Goto bottom of screen
0079               *---------------------------------------------------------------
0080               edkey.action.botscr:
0081 6464 0649  14         dect  stack
0082 6466 C644  30         mov   tmp0,*stack           ; Push tmp0
0083                       ;-------------------------------------------------------
0084                       ; Crunch current row if dirty
0085                       ;-------------------------------------------------------
0086 6468 8820  54         c     @fb.row.dirty,@w$ffff
     646A A30A     
     646C 2022     
0087 646E 1604  14         jne   edkey.action.botscr.cursor
0088 6470 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6472 704A     
0089 6474 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6476 A30A     
0090                       ;-------------------------------------------------------
0091                       ; Position cursor
0092                       ;-------------------------------------------------------
0093               edkey.action.botscr.cursor:
0094 6478 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     647A A31A     
0095               
0096 647C 8820  54         c     @fb.scrrows,@edb.lines
     647E A31C     
     6480 A504     
0097 6482 1503  14         jgt   edkey.action.botscr.eof
0098 6484 C120  34         mov   @fb.scrrows,tmp0      ; Get bottom row
     6486 A31C     
0099 6488 1002  14         jmp   !
0100                       ;-------------------------------------------------------
0101                       ; Cursor at EOF
0102                       ;-------------------------------------------------------
0103               edkey.action.botscr.eof:
0104 648A C120  34         mov   @edb.lines,tmp0       ; Get last line in file
     648C A504     
0105                       ;-------------------------------------------------------
0106                       ; Position cursor
0107                       ;-------------------------------------------------------
0108 648E 0604  14 !       dec   tmp0                  ; Base 0
0109 6490 C804  38         mov   tmp0,@fb.row          ; Frame buffer bottom line
     6492 A306     
0110 6494 04E0  34         clr   @fb.column            ; Frame buffer column 0
     6496 A30C     
0111               
0112 6498 C120  34         mov   @fb.row,tmp0          ;
     649A A306     
0113 649C 0A84  56         sla   tmp0,8                ; Position cursor
0114 649E C804  38         mov   tmp0,@wyx             ;
     64A0 832A     
0115               
0116 64A2 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     64A4 3094     
0117               
0118 64A6 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     64A8 35C6     
0119                                                   ; | i  @fb.row        = Row in frame buffer
0120                                                   ; / o  @fb.row.length = Length of row
0121                       ;-------------------------------------------------------
0122                       ; Exit
0123                       ;-------------------------------------------------------
0124               edkey.action.botscr.exit:
0125 64AA C139  30         mov   *stack+,tmp0          ; Pop tmp0
0126 64AC 0460  28         b     @edkey.keyscan.hook.debounce; Back to editor main
     64AE 6156     
                   < stevie_b1.asm.33260
0076                       copy  "edkey.fb.mov.goto.asm"       ; Goto line in editor buffer
     **** ****     > edkey.fb.mov.goto.asm
0001               * FILE......: edkey.fb.mov.goto.asm
0002               * Purpose...: Goto specified line in editor buffer
0003               
0004               ***************************************************************
0005               * edkey.goto.fb.toprow
0006               *
0007               * Position cursor on first row in frame buffer and
0008               * align variables in editor buffer to match with that position.
0009               *
0010               * Internal method that needs to be called via jmp or branch
0011               * instruction.
0012               ***************************************************************
0013               * b    @edkey.goto.fb.toprow
0014               *--------------------------------------------------------------
0015               * INPUT
0016               * @parm1  = Line in editor buffer to display as top row (goto)
0017               *
0018               * Register usage
0019               * none
0020               ********|*****|*********************|**************************
0021               edkey.goto.fb.toprow:
0022 64B0 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     64B2 A31A     
0023               
0024 64B4 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     64B6 6F98     
0025                                                   ; | i  @parm1 = Line to start with
0026                                                   ; /             (becomes @fb.topline)
0027               
0028 64B8 04E0  34         clr   @fb.row               ; Frame buffer line 0
     64BA A306     
0029 64BC 04E0  34         clr   @fb.column            ; Frame buffer column 0
     64BE A30C     
0030 64C0 04E0  34         clr   @wyx                  ; Position VDP cursor
     64C2 832A     
0031 64C4 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     64C6 3094     
0032               
0033 64C8 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     64CA 35C6     
0034                                                   ; | i  @fb.row        = Row in frame buffer
0035                                                   ; / o  @fb.row.length = Length of row
0036               
0037 64CC 0460  28         b     @edkey.keyscan.hook.debounce; Back to editor main
     64CE 6156     
0038               
0039               
0040               *---------------------------------------------------------------
0041               * Goto specified line (@parm1) in editor buffer
0042               *---------------------------------------------------------------
0043               edkey.action.goto:
0044                       ;-------------------------------------------------------
0045                       ; Crunch current row if dirty
0046                       ;-------------------------------------------------------
0047 64D0 8820  54         c     @fb.row.dirty,@w$ffff
     64D2 A30A     
     64D4 2022     
0048 64D6 1609  14         jne   edkey.action.goto.refresh
0049               
0050 64D8 0649  14         dect  stack
0051 64DA C660  46         mov   @parm1,*stack         ; Push parm1
     64DC A006     
0052 64DE 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     64E0 704A     
0053 64E2 C839  50         mov   *stack+,@parm1        ; Pop parm1
     64E4 A006     
0054               
0055 64E6 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     64E8 A30A     
0056                       ;-------------------------------------------------------
0057                       ; Refresh page
0058                       ;-------------------------------------------------------
0059               edkey.action.goto.refresh:
0060 64EA 0720  34         seto  @fb.colorize           ; Colorize M1/M2 marked lines (if present)
     64EC A312     
0061               
0062 64EE 0460  28         b     @edkey.goto.fb.toprow  ; Position cursor and exit
     64F0 64B0     
0063                                                    ; \ i  @parm1 = Line in editor buffer
0064                                                    ; /
                   < stevie_b1.asm.33260
0077                       copy  "edkey.fb.del.asm"            ; Delete characters or lines
     **** ****     > edkey.fb.del.asm
0001               * FILE......: edkey.fb.del.asm
0002               * Purpose...: Delete related actions in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Delete character
0006               *---------------------------------------------------------------
0007               edkey.action.del_char:
0008 64F2 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     64F4 A506     
0009 64F6 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     64F8 3094     
0010                       ;-------------------------------------------------------
0011                       ; Assert 1 - Empty line
0012                       ;-------------------------------------------------------
0013               edkey.action.del_char.sanity1:
0014 64FA C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     64FC A308     
0015 64FE 1336  14         jeq   edkey.action.del_char.exit
0016                                                   ; Exit if empty line
0017               
0018 6500 C120  34         mov   @fb.current,tmp0      ; Get pointer
     6502 A302     
0019                       ;-------------------------------------------------------
0020                       ; Assert 2 - Already at EOL
0021                       ;-------------------------------------------------------
0022               edkey.action.del_char.sanity2:
0023 6504 C1C6  18         mov   tmp2,tmp3             ; \
0024 6506 0607  14         dec   tmp3                  ; / tmp3 = line length - 1
0025 6508 81E0  34         c     @fb.column,tmp3
     650A A30C     
0026 650C 110A  14         jlt   edkey.action.del_char.sanity3
0027               
0028                       ;------------------------------------------------------
0029                       ; At EOL - clear current character
0030                       ;------------------------------------------------------
0031 650E 04C5  14         clr   tmp1                  ; \ Overwrite with character >00
0032 6510 D505  30         movb  tmp1,*tmp0            ; /
0033 6512 C820  54         mov   @fb.column,@fb.row.length
     6514 A30C     
     6516 A308     
0034                                                   ; Row length - 1
0035 6518 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     651A A30A     
0036 651C 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     651E A318     
0037 6520 1025  14         jmp  edkey.action.del_char.exit
0038                       ;-------------------------------------------------------
0039                       ; Assert 3 - Abort if row length > 80
0040                       ;-------------------------------------------------------
0041               edkey.action.del_char.sanity3:
0042 6522 0286  22         ci    tmp2,colrow
     6524 0050     
0043 6526 1204  14         jle   edkey.action.del_char.prep
0044                                                   ; Continue if row length <= 80
0045                       ;-----------------------------------------------------------------------
0046                       ; CPU crash
0047                       ;-----------------------------------------------------------------------
0048 6528 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     652A FFCE     
0049 652C 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     652E 2026     
0050                       ;-------------------------------------------------------
0051                       ; Calculate number of characters to move
0052                       ;-------------------------------------------------------
0053               edkey.action.del_char.prep:
0054 6530 C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0055 6532 61E0  34         s     @fb.column,tmp3
     6534 A30C     
0056 6536 0607  14         dec   tmp3                  ; Remove base 1 offset
0057 6538 A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0058 653A C144  18         mov   tmp0,tmp1
0059 653C 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0060 653E 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     6540 A30C     
0061                       ;-------------------------------------------------------
0062                       ; Setup pointers
0063                       ;-------------------------------------------------------
0064 6542 C120  34         mov   @fb.current,tmp0      ; Get pointer
     6544 A302     
0065 6546 C144  18         mov   tmp0,tmp1             ; \ tmp0 = Current character
0066 6548 0585  14         inc   tmp1                  ; / tmp1 = Next character
0067                       ;-------------------------------------------------------
0068                       ; Loop from current character until end of line
0069                       ;-------------------------------------------------------
0070               edkey.action.del_char.loop:
0071 654A DD35  42         movb  *tmp1+,*tmp0+         ; Overwrite current char with next char
0072 654C 0606  14         dec   tmp2
0073 654E 16FD  14         jne   edkey.action.del_char.loop
0074                       ;-------------------------------------------------------
0075                       ; Special treatment if line 80 characters long
0076                       ;-------------------------------------------------------
0077 6550 0206  20         li    tmp2,colrow
     6552 0050     
0078 6554 81A0  34         c     @fb.row.length,tmp2
     6556 A308     
0079 6558 1603  14         jne   edkey.action.del_char.save
0080 655A 0604  14         dec   tmp0                  ; One time adjustment
0081 655C 04C5  14         clr   tmp1
0082 655E D505  30         movb  tmp1,*tmp0            ; Write >00 character
0083                       ;-------------------------------------------------------
0084                       ; Save variables
0085                       ;-------------------------------------------------------
0086               edkey.action.del_char.save:
0087 6560 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6562 A30A     
0088 6564 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6566 A318     
0089 6568 0620  34         dec   @fb.row.length        ; @fb.row.length--
     656A A308     
0090                       ;-------------------------------------------------------
0091                       ; Exit
0092                       ;-------------------------------------------------------
0093               edkey.action.del_char.exit:
0094 656C 0460  28         b     @edkey.keyscan.hook.debounce; Back to editor main
     656E 6156     
0095               
0096               
0097               *---------------------------------------------------------------
0098               * Delete until end of line
0099               *---------------------------------------------------------------
0100               edkey.action.del_eol:
0101 6570 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6572 A506     
0102 6574 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6576 3094     
0103 6578 C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     657A A308     
0104 657C 1311  14         jeq   edkey.action.del_eol.exit
0105                                                   ; Exit if empty line
0106                       ;-------------------------------------------------------
0107                       ; Prepare for erase operation
0108                       ;-------------------------------------------------------
0109 657E C120  34         mov   @fb.current,tmp0      ; Get pointer
     6580 A302     
0110 6582 C1A0  34         mov   @fb.colsline,tmp2
     6584 A30E     
0111 6586 61A0  34         s     @fb.column,tmp2
     6588 A30C     
0112 658A 04C5  14         clr   tmp1
0113                       ;-------------------------------------------------------
0114                       ; Loop until last column in frame buffer
0115                       ;-------------------------------------------------------
0116               edkey.action.del_eol_loop:
0117 658C DD05  32         movb  tmp1,*tmp0+           ; Overwrite current char with >00
0118 658E 0606  14         dec   tmp2
0119 6590 16FD  14         jne   edkey.action.del_eol_loop
0120                       ;-------------------------------------------------------
0121                       ; Save variables
0122                       ;-------------------------------------------------------
0123 6592 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6594 A30A     
0124 6596 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6598 A318     
0125               
0126 659A C820  54         mov   @fb.column,@fb.row.length
     659C A30C     
     659E A308     
0127                                                   ; Set new row length
0128                       ;-------------------------------------------------------
0129                       ; Exit
0130                       ;-------------------------------------------------------
0131               edkey.action.del_eol.exit:
0132 65A0 0460  28         b     @edkey.keyscan.hook.debounce; Back to editor main
     65A2 6156     
0133               
0134               
0135               *---------------------------------------------------------------
0136               * Delete current line
0137               *---------------------------------------------------------------
0138               edkey.action.del_line:
0139                       ;-------------------------------------------------------
0140                       ; Get current line in editor buffer
0141                       ;-------------------------------------------------------
0142 65A4 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     65A6 3094     
0143 65A8 04E0  34         clr   @fb.row.dirty         ; Discard current line
     65AA A30A     
0144               
0145 65AC C820  54         mov   @fb.topline,@parm1    ; \
     65AE A304     
     65B0 A006     
0146 65B2 A820  54         a     @fb.row,@parm1        ; | Line number to delete (base 1)
     65B4 A306     
     65B6 A006     
0147 65B8 05A0  34         inc   @parm1                ; /
     65BA A006     
0148               
0149                       ;-------------------------------------------------------
0150                       ; Special handling if at BOT (no real line)
0151                       ;-------------------------------------------------------
0152 65BC 8820  54         c     @parm1,@edb.lines     ; At BOT in editor buffer?
     65BE A006     
     65C0 A504     
0153 65C2 1207  14         jle   edkey.action.del_line.doit
0154                                                   ; No, is real line. Continue with delete.
0155               
0156 65C4 C820  54         mov   @fb.topline,@parm1    ; Line to start with (becomes @fb.topline)
     65C6 A304     
     65C8 A006     
0157 65CA 06A0  32         bl    @fb.refresh           ; Refresh frame buffer with EB content
     65CC 6F98     
0158                                                   ; \ i  @parm1 = Line to start with
0159                                                   ; /
0160 65CE 0460  28         b     @edkey.action.up      ; Move cursor one line up
     65D0 6378     
0161                       ;-------------------------------------------------------
0162                       ; Delete line in editor buffer
0163                       ;-------------------------------------------------------
0164               edkey.action.del_line.doit:
0165 65D2 06A0  32         bl    @edb.line.del         ; Delete line in editor buffer
     65D4 7B9E     
0166                                                   ; \ i  @parm1 = Line number to delete
0167                                                   ; /
0168               
0169 65D6 8820  54         c     @parm1,@edb.lines     ; Now at BOT in editor buffer after delete?
     65D8 A006     
     65DA A504     
0170 65DC 1302  14         jeq   edkey.action.del_line.refresh
0171                                                   ; Yes, skip get length. No need for garbage.
0172                       ;-------------------------------------------------------
0173                       ; Get length of current row in frame buffer
0174                       ;-------------------------------------------------------
0175 65DE 06A0  32         bl   @edb.line.getlength2   ; Get length of current row
     65E0 35C6     
0176                                                   ; \ i  @fb.row        = Current row
0177                                                   ; / o  @fb.row.length = Length of row
0178                       ;-------------------------------------------------------
0179                       ; Refresh frame buffer
0180                       ;-------------------------------------------------------
0181               edkey.action.del_line.refresh:
0182 65E2 C820  54         mov   @fb.topline,@parm1    ; Line to start with (becomes @fb.topline)
     65E4 A304     
     65E6 A006     
0183               
0184 65E8 06A0  32         bl    @fb.refresh           ; Refresh frame buffer with EB content
     65EA 6F98     
0185                                                   ; \ i  @parm1 = Line to start with
0186                                                   ; /
0187               
0188 65EC 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     65EE A506     
0189                       ;-------------------------------------------------------
0190                       ; Special treatment if current line was last line
0191                       ;-------------------------------------------------------
0192 65F0 C120  34         mov   @fb.topline,tmp0
     65F2 A304     
0193 65F4 A120  34         a     @fb.row,tmp0
     65F6 A306     
0194               
0195 65F8 8804  38         c     tmp0,@edb.lines       ; Was last line?
     65FA A504     
0196 65FC 1102  14         jlt   edkey.action.del_line.exit
0197               
0198 65FE 0460  28         b     @edkey.action.up      ; Move cursor one line up
     6600 6378     
0199                       ;-------------------------------------------------------
0200                       ; Exit
0201                       ;-------------------------------------------------------
0202               edkey.action.del_line.exit:
0203 6602 0460  28         b     @edkey.action.home    ; Move cursor to home and return
     6604 6270     
                   < stevie_b1.asm.33260
0078                       copy  "edkey.fb.ins.asm"            ; Insert characters or lines
     **** ****     > edkey.fb.ins.asm
0001               * FILE......: edkey.fb.ins.asm
0002               * Purpose...: Insert related actions in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Insert character
0006               *
0007               * @parm1 = high byte has character to insert
0008               *---------------------------------------------------------------
0009               edkey.action.ins_char.ws:
0010 6606 0204  20         li    tmp0,>2000            ; White space
     6608 2000     
0011 660A C804  38         mov   tmp0,@parm1
     660C A006     
0012               edkey.action.ins_char:
0013 660E 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6610 A506     
0014 6612 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6614 3094     
0015                       ;-------------------------------------------------------
0016                       ; Check 1 - Empty line
0017                       ;-------------------------------------------------------
0018               edkey.actions.ins.char.empty_line:
0019 6616 C120  34         mov   @fb.current,tmp0      ; Get pointer
     6618 A302     
0020 661A C1A0  34         mov   @fb.row.length,tmp2   ; Get line length
     661C A308     
0021 661E 1342  14         jeq   edkey.action.ins_char.append
0022                                                   ; Add character in append mode
0023                       ;-------------------------------------------------------
0024                       ; Check 2 - line-wrap if at character 80
0025                       ;-------------------------------------------------------
0026 6620 C160  34         mov   @fb.column,tmp1
     6622 A30C     
0027 6624 0285  22         ci    tmp1,colrow-1         ; At 80th character?
     6626 004F     
0028 6628 1118  14         jlt   !
0029 662A C160  34         mov   @fb.row.length,tmp1
     662C A308     
0030 662E 0285  22         ci    tmp1,colrow
     6630 0050     
0031 6632 1613  14         jne   !
0032                       ;-------------------------------------------------------
0033                       ; Wrap to new line
0034                       ;-------------------------------------------------------
0035 6634 0649  14         dect  Stack
0036 6636 C660  46         mov   @parm1,*stack         ; Save character to add
     6638 A006     
0037               
0038 663A 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     663C A506     
0039 663E 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6640 704A     
0040 6642 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6644 A30A     
0041               
0042 6646 0720  34         seto  @parm1                ; Insert on following line
     6648 A006     
0043 664A 06A0  32         bl    @fb.insert.line       ; Insert empty line
     664C 6EB6     
0044                                                   ; \ i  @parm1 = 0 for insert current line
0045                                                   ; /            >0 for insert following line
0046               
0047 664E 06A0  32         bl    @fb.cursor.down       ; Move cursor down 1 line
     6650 6E14     
0048 6652 04C6  14         clr   tmp2                  ; Clear line length
0049 6654 C839  50         mov   *stack+,@parm1        ; Restore character to add
     6656 A006     
0050 6658 1025  14         jmp   edkey.action.ins_char.append
0051                       ;-------------------------------------------------------
0052                       ; Check 3 - EOL
0053                       ;-------------------------------------------------------
0054 665A 8820  54 !       c     @fb.column,@fb.row.length
     665C A30C     
     665E A308     
0055 6660 1321  14         jeq   edkey.action.ins_char.append
0056                                                   ; Add character in append mode
0057                       ;-------------------------------------------------------
0058                       ; Check 4 - Insert only until line length reaches 80th column
0059                       ;-------------------------------------------------------
0060 6662 C160  34         mov   @fb.row.length,tmp1
     6664 A308     
0061 6666 0285  22         ci    tmp1,colrow
     6668 0050     
0062 666A 1101  14         jlt   edkey.action.ins_char.prep
0063 666C 101D  14         jmp   edkey.action.ins_char.exit
0064                       ;-------------------------------------------------------
0065                       ; Calculate number of characters to move
0066                       ;-------------------------------------------------------
0067               edkey.action.ins_char.prep:
0068 666E C1C6  18         mov   tmp2,tmp3             ; tmp3=line length
0069 6670 61E0  34         s     @fb.column,tmp3
     6672 A30C     
0070 6674 0607  14         dec   tmp3                  ; Remove base 1 offset
0071 6676 A107  18         a     tmp3,tmp0             ; tmp0=Pointer to last char in line
0072 6678 C144  18         mov   tmp0,tmp1
0073 667A 0585  14         inc   tmp1                  ; tmp1=tmp0+1
0074 667C 61A0  34         s     @fb.column,tmp2       ; tmp2=amount of characters to move
     667E A30C     
0075                       ;-------------------------------------------------------
0076                       ; Loop from end of line until current character
0077                       ;-------------------------------------------------------
0078               edkey.action.ins_char.loop:
0079 6680 D554  38         movb  *tmp0,*tmp1           ; Move char to the right
0080 6682 0604  14         dec   tmp0
0081 6684 0605  14         dec   tmp1
0082 6686 0606  14         dec   tmp2
0083 6688 16FB  14         jne   edkey.action.ins_char.loop
0084                       ;-------------------------------------------------------
0085                       ; Insert specified character at current position
0086                       ;-------------------------------------------------------
0087 668A D560  46         movb  @parm1,*tmp1          ; MSB has character to insert
     668C A006     
0088                       ;-------------------------------------------------------
0089                       ; Save variables and exit
0090                       ;-------------------------------------------------------
0091 668E 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6690 A30A     
0092 6692 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6694 A318     
0093 6696 05A0  34         inc   @fb.column
     6698 A30C     
0094 669A 05A0  34         inc   @wyx
     669C 832A     
0095 669E 05A0  34         inc   @fb.row.length        ; @fb.row.length
     66A0 A308     
0096 66A2 1002  14         jmp   edkey.action.ins_char.exit
0097                       ;-------------------------------------------------------
0098                       ; Add character in append mode
0099                       ;-------------------------------------------------------
0100               edkey.action.ins_char.append:
0101 66A4 0460  28         b     @edkey.action.char.overwrite
     66A6 6782     
0102                       ;-------------------------------------------------------
0103                       ; Exit
0104                       ;-------------------------------------------------------
0105               edkey.action.ins_char.exit:
0106 66A8 0460  28         b     @edkey.keyscan.hook.debounce
     66AA 6156     
0107                                                   ; Back to editor main
0108               
0109               
0110               
0111               
0112               *---------------------------------------------------------------
0113               * Insert new line on current line
0114               *---------------------------------------------------------------
0115               edkey.action.ins_line:
0116 66AC 04E0  34         clr   @parm1                ; Insert new line on curren line
     66AE A006     
0117 66B0 06A0  32         bl    @fb.insert.line       ; Insert new line
     66B2 6EB6     
0118                       ;-------------------------------------------------------
0119                       ; Exit
0120                       ;-------------------------------------------------------
0121               edkey.action.ins_line.exit:
0122 66B4 0460  28         b     @edkey.keyscan.hook.debounce
     66B6 6156     
0123                                                   ; Back to editor main
0124               
0125               
0126               *---------------------------------------------------------------
0127               * Insert new line on following line
0128               *---------------------------------------------------------------
0129               edkey.action.ins_line_after:
0130 66B8 0720  34         seto  @parm1                ; Insert new line on following line
     66BA A006     
0131 66BC 06A0  32         bl    @fb.insert.line       ; Insert new line
     66BE 6EB6     
0132                       ;-------------------------------------------------------
0133                       ; Exit
0134                       ;-------------------------------------------------------
0135               edkey.action.ins_line_after.exit:
0136 66C0 0460  28         b     @edkey.keyscan.hook.debounce
     66C2 6156     
0137                                                   ; Back to editor main
                   < stevie_b1.asm.33260
0079                       copy  "edkey.fb.mod.asm"            ; Actions for modifier keys
     **** ****     > edkey.fb.mod.asm
0001               * FILE......: edkey.fb.mod.asm
0002               * Purpose...: Actions for modifier keys in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Enter
0006               *---------------------------------------------------------------
0007               edkey.action.enter:
0008 66C4 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     66C6 A31A     
0009                       ;-------------------------------------------------------
0010                       ; Crunch current line if dirty
0011                       ;-------------------------------------------------------
0012 66C8 8820  54         c     @fb.row.dirty,@w$ffff
     66CA A30A     
     66CC 2022     
0013 66CE 1606  14         jne   edkey.action.enter.newline
0014 66D0 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     66D2 A506     
0015 66D4 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     66D6 704A     
0016 66D8 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     66DA A30A     
0017                       ;-------------------------------------------------------
0018                       ; Insert a new line if insert mode is on
0019                       ;-------------------------------------------------------
0020               edkey.action.enter.newline:
0021 66DC C120  34         mov   @edb.insmode,tmp0     ; Insert mode or overwrite mode?
     66DE A50A     
0022 66E0 1304  14         jeq   edkey.action.enter.upd_counter
0023                                                   ; Overwrite mode, skip insert
0024               
0025 66E2 0720  34         seto  @parm1                ; Insert line on following line
     66E4 A006     
0026 66E6 06A0  32         bl    @fb.insert.line       ; Insert a new line
     66E8 6EB6     
0027                                                   ; \  i  @parm1 = current/following line
0028                                                   ; /
0029                       ;-------------------------------------------------------
0030                       ; Update line counter
0031                       ;-------------------------------------------------------
0032               edkey.action.enter.upd_counter:
0033 66EA C120  34         mov   @fb.topline,tmp0
     66EC A304     
0034 66EE A120  34         a     @fb.row,tmp0
     66F0 A306     
0035 66F2 0584  14         inc   tmp0
0036 66F4 8804  38         c     tmp0,@edb.lines       ; Last line in editor buffer?
     66F6 A504     
0037 66F8 1102  14         jlt   edkey.action.newline  ; No, continue newline
0038 66FA 05A0  34         inc   @edb.lines            ; Total lines++
     66FC A504     
0039                       ;-------------------------------------------------------
0040                       ; Process newline
0041                       ;-------------------------------------------------------
0042               edkey.action.newline:
0043                       ;-------------------------------------------------------
0044                       ; Scroll 1 line if cursor at bottom row of screen
0045                       ;-------------------------------------------------------
0046 66FE C120  34         mov   @fb.scrrows,tmp0
     6700 A31C     
0047 6702 0604  14         dec   tmp0
0048 6704 8120  34         c     @fb.row,tmp0
     6706 A306     
0049 6708 110C  14         jlt   edkey.action.newline.down
0050                       ;-------------------------------------------------------
0051                       ; Scroll
0052                       ;-------------------------------------------------------
0053 670A C120  34         mov   @fb.scrrows,tmp0
     670C A31C     
0054 670E C820  54         mov   @fb.topline,@parm1
     6710 A304     
     6712 A006     
0055 6714 05A0  34         inc   @parm1
     6716 A006     
0056 6718 06A0  32         bl    @fb.refresh
     671A 6F98     
0057 671C 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     671E A312     
0058 6720 1004  14         jmp   edkey.action.newline.rest
0059                       ;-------------------------------------------------------
0060                       ; Move cursor down a row, there are still rows left
0061                       ;-------------------------------------------------------
0062               edkey.action.newline.down:
0063 6722 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     6724 A306     
0064 6726 06A0  32         bl    @down                 ; Row++ VDP cursor
     6728 26E0     
0065                       ;-------------------------------------------------------
0066                       ; Set VDP cursor and save variables
0067                       ;-------------------------------------------------------
0068               edkey.action.newline.rest:
0069 672A 06A0  32         bl    @fb.get.firstnonblank
     672C 6F50     
0070 672E C120  34         mov   @outparm1,tmp0
     6730 A016     
0071 6732 C804  38         mov   tmp0,@fb.column
     6734 A30C     
0072 6736 06A0  32         bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
     6738 26F2     
0073 673A 06A0  32         bl    @edb.line.getlength2  ; Get length of new row length
     673C 35C6     
0074 673E 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6740 3094     
0075 6742 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6744 A318     
0076                       ;-------------------------------------------------------
0077                       ; Exit
0078                       ;-------------------------------------------------------
0079               edkey.action.newline.exit:
0080 6746 0460  28         b     @edkey.keyscan.hook.debounce; Back to editor main
     6748 6156     
0081               
0082               
0083               
0084               
0085               *---------------------------------------------------------------
0086               * Toggle insert/overwrite mode
0087               *---------------------------------------------------------------
0088               edkey.action.ins_onoff:
0089 674A 0649  14         dect  stack
0090 674C C64B  30         mov   r11,*stack            ; Save return address
0091               
0092 674E 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6750 A31A     
0093 6752 0560  34         inv   @edb.insmode          ; Toggle insert/overwrite mode
     6754 A50A     
0094                       ;-------------------------------------------------------
0095                       ; Exit
0096                       ;-------------------------------------------------------
0097               edkey.action.ins_onoff.exit:
0098 6756 C2F9  30         mov   *stack+,r11           ; Pop r11
0099 6758 0460  28         b     @edkey.keyscan.hook.debounce; Back to editor main
     675A 6156     
0100               
0101               
0102               
0103               *---------------------------------------------------------------
0104               * Add character (frame buffer)
0105               *---------------------------------------------------------------
0106               edkey.action.char:
0107 675C 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     675E A31A     
0108                       ;-------------------------------------------------------
0109                       ; Asserts
0110                       ;-------------------------------------------------------
0111 6760 D105  18         movb  tmp1,tmp0             ; Get keycode
0112 6762 0984  56         srl   tmp0,8                ; MSB to LSB
0113               
0114 6764 0284  22         ci    tmp0,32               ; Keycode < ASCII 32 ?
     6766 0020     
0115 6768 112B  14         jlt   edkey.action.char.exit
0116                                                   ; Yes, skip
0117               
0118 676A 0284  22         ci    tmp0,126              ; Keycode > ASCII 126 ?
     676C 007E     
0119 676E 1528  14         jgt   edkey.action.char.exit
0120                                                   ; Yes, skip
0121                       ;-------------------------------------------------------
0122                       ; Setup
0123                       ;-------------------------------------------------------
0124 6770 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6772 A506     
0125 6774 D805  38         movb  tmp1,@parm1           ; Store character for insert
     6776 A006     
0126 6778 C120  34         mov   @edb.insmode,tmp0     ; Insert mode or overwrite mode?
     677A A50A     
0127 677C 1302  14         jeq   edkey.action.char.overwrite
0128                       ;-------------------------------------------------------
0129                       ; Insert mode
0130                       ;-------------------------------------------------------
0131               edkey.action.char.insert:
0132 677E 0460  28         b     @edkey.action.ins_char
     6780 660E     
0133                       ;-------------------------------------------------------
0134                       ; Overwrite mode - Write character
0135                       ;-------------------------------------------------------
0136               edkey.action.char.overwrite:
0137 6782 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6784 3094     
0138 6786 C120  34         mov   @fb.current,tmp0      ; Get pointer
     6788 A302     
0139               
0140 678A D520  46         movb  @parm1,*tmp0          ; Store character in editor buffer
     678C A006     
0141 678E 0720  34         seto  @fb.row.dirty         ; Current row needs to be crunched/packed
     6790 A30A     
0142 6792 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6794 A318     
0143                       ;-------------------------------------------------------
0144                       ; Last column on screen reached?
0145                       ;-------------------------------------------------------
0146 6796 C160  34         mov   @fb.column,tmp1       ; \ Columns are counted from 0 to 79.
     6798 A30C     
0147 679A 0285  22         ci    tmp1,colrow - 1       ; / Last column on screen?
     679C 004F     
0148 679E 1105  14         jlt   edkey.action.char.overwrite.incx
0149                                                   ; No, increase X position
0150               
0151 67A0 0205  20         li    tmp1,colrow           ; \
     67A2 0050     
0152 67A4 C805  38         mov   tmp1,@fb.row.length   ; / Yes, Set row length and exit.
     67A6 A308     
0153 67A8 100B  14         jmp   edkey.action.char.exit
0154                       ;-------------------------------------------------------
0155                       ; Increase column
0156                       ;-------------------------------------------------------
0157               edkey.action.char.overwrite.incx:
0158 67AA 05A0  34         inc   @fb.column            ; Column++ in screen buffer
     67AC A30C     
0159 67AE 05A0  34         inc   @wyx                  ; Column++ VDP cursor
     67B0 832A     
0160                       ;-------------------------------------------------------
0161                       ; Update line length in frame buffer
0162                       ;-------------------------------------------------------
0163 67B2 8820  54         c     @fb.column,@fb.row.length
     67B4 A30C     
     67B6 A308     
0164                                                   ; column < line length ?
0165 67B8 1103  14         jlt   edkey.action.char.exit
0166                                                   ; Yes, don't update row length
0167 67BA C820  54         mov   @fb.column,@fb.row.length
     67BC A30C     
     67BE A308     
0168                                                   ; Set row length
0169                       ;-------------------------------------------------------
0170                       ; Exit
0171                       ;-------------------------------------------------------
0172               edkey.action.char.exit:
0173 67C0 0460  28         b     @edkey.keyscan.hook.debounce; Back to editor main
     67C2 6156     
                   < stevie_b1.asm.33260
0080                       copy  "edkey.fb.ruler.asm"          ; Toggle ruler on/off
     **** ****     > edkey.fb.ruler.asm
0001               * FILE......: edkey.fb.ruler.asm
0002               * Purpose...: Actions to toggle ruler on/off
0003               
0004               *---------------------------------------------------------------
0005               * Toggle ruler on/off
0006               ********|*****|*********************|**************************
0007               edkey.action.toggle.ruler:
0008 67C4 0649  14         dect  stack
0009 67C6 C644  30         mov   tmp0,*stack           ; Push tmp0
0010 67C8 0649  14         dect  stack
0011 67CA C660  46         mov   @wyx,*stack           ; Push cursor YX
     67CC 832A     
0012                       ;-------------------------------------------------------
0013                       ; Toggle ruler visibility
0014                       ;-------------------------------------------------------
0015 67CE C120  34         mov   @tv.ruler.visible,tmp0
     67D0 A210     
0016                                                   ; Ruler currently off?
0017 67D2 1305  14         jeq   edkey.action.toggle.ruler.on
0018                                                   ; Yes, turn it on
0019                       ;-------------------------------------------------------
0020                       ; Turn ruler off
0021                       ;-------------------------------------------------------
0022               edkey.action.toggle.ruler.off:
0023 67D4 0720  34         seto  @fb.dirty             ; Screen refresh necessary
     67D6 A318     
0024 67D8 04E0  34         clr   @tv.ruler.visible     ; Toggle ruler visibility
     67DA A210     
0025 67DC 100C  14         jmp   edkey.action.toggle.ruler.fb
0026                       ;-------------------------------------------------------
0027                       ; Turn ruler on
0028                       ;-------------------------------------------------------
0029               edkey.action.toggle.ruler.on:
0030 67DE C120  34         mov   @fb.scrrows,tmp0      ; \ Check if on last row in
     67E0 A31C     
0031 67E2 0604  14         dec   tmp0                  ; | frame buffer, if yes
0032 67E4 8120  34         c     @fb.row,tmp0          ; | silenty exit without any
     67E6 A306     
0033                                                   ; | action, preventing
0034                                                   ; / overflow on bottom row.
0035 67E8 1308  14         jeq   edkey.action.toggle.ruler.exit
0036               
0037 67EA 0720  34         seto  @fb.dirty             ; Screen refresh necessary
     67EC A318     
0038 67EE 0720  34         seto  @tv.ruler.visible     ; Set ruler visibility
     67F0 A210     
0039 67F2 06A0  32         bl    @fb.ruler.init        ; Setup ruler in RAM
     67F4 7B18     
0040                       ;-------------------------------------------------------
0041                       ; Update framebuffer pane
0042                       ;-------------------------------------------------------
0043               edkey.action.toggle.ruler.fb:
0044 67F6 06A0  32         bl    @pane.cmdb.hide       ; Same actions as when hiding CMDB
     67F8 7A90     
0045                       ;-------------------------------------------------------
0046                       ; Exit
0047                       ;-------------------------------------------------------
0048               edkey.action.toggle.ruler.exit:
0049 67FA C839  50         mov   *stack+,@wyx          ; Pop cursor YX
     67FC 832A     
0050 67FE C139  30         mov   *stack+,tmp0          ; Pop tmp0
0051 6800 0460  28         b     @edkey.keyscan.hook.debounce; Back to editor main
     6802 6156     
                   < stevie_b1.asm.33260
0081                       copy  "edkey.fb.misc.asm"           ; Miscelanneous actions
     **** ****     > edkey.fb.misc.asm
0001               * FILE......: edkey.fb.misc.asm
0002               * Purpose...: Actions for miscelanneous keys in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Quit stevie
0006               *---------------------------------------------------------------
0007               edkey.action.quit:
0008                       ;-------------------------------------------------------
0009                       ; Show dialog "unsaved changes" if editor buffer dirty
0010                       ;-------------------------------------------------------
0011 6804 C120  34         mov   @edb.dirty,tmp0
     6806 A506     
0012 6808 1302  14         jeq   !
0013 680A 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     680C 7A00     
0014                       ;-------------------------------------------------------
0015                       ; Quit Stevie
0016                       ;-------------------------------------------------------
0017 680E 0460  28 !       b     @tv.quit
     6810 32B4     
0018               
0019               
0020               *---------------------------------------------------------------
0021               * Copy code block or open "Insert from clipboard" dialog
0022               *---------------------------------------------------------------
0023               edkey.action.copyblock_or_clipboard:
0024 6812 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     6814 A50C     
     6816 2022     
0025 6818 1302  14         jeq   !
0026 681A 0460  28         b     @edkey.action.block.copy
     681C 6886     
0027                                                   ; Copy code block
0028 681E 0460  28 !       b     @dialog.clipboard     ; Open "Insert from clipboard" dialog
     6820 7A0E     
                   < stevie_b1.asm.33260
0082                       copy  "edkey.fb.file.asm"           ; File related actions
     **** ****     > edkey.fb.file.asm
0001               * FILE......: edkey.fb.fíle.asm
0002               * Purpose...: File related actions in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Load next or previous file based on last char in suffix
0006               *---------------------------------------------------------------
0007               * b   @edkey.action.fb.fname.inc.load
0008               * b   @edkey.action.fb.fname.dec.load
0009               *---------------------------------------------------------------
0010               * INPUT
0011               * @cmdb.cmdlen
0012               *--------------------------------------------------------------
0013               * Register usage
0014               * none
0015               ********|*****|*********************|**************************
0016               edkey.action.fb.fname.dec.load:
0017 6822 0649  14         dect  stack
0018 6824 C644  30         mov   tmp0,*stack           ; Push tmp0
0019                       ;------------------------------------------------------
0020                       ; Adjust filename
0021                       ;------------------------------------------------------
0022 6826 04E0  34         clr   @parm2                ; Decrease ASCII value of char in suffix
     6828 A008     
0023               
0024 682A 0204  20         li    tmp0,edkey.action.fb.fname.dec.load
     682C 6822     
0025 682E C804  38         mov   tmp0,@cmdb.action.ptr ; Set deferred action to run if proceeding
     6830 A728     
0026                                                   ; in "Unsaved changes" dialog
0027               
0028 6832 1008  14         jmp   edkey.action.fb.fname.doit
0029               
0030               
0031               edkey.action.fb.fname.inc.load:
0032 6834 0649  14         dect  stack
0033 6836 C644  30         mov   tmp0,*stack           ; Push tmp0
0034                       ;------------------------------------------------------
0035                       ; Adjust filename
0036                       ;------------------------------------------------------
0037 6838 0720  34         seto  @parm2                ; Increase ASCII value of char in suffix
     683A A008     
0038               
0039 683C 0204  20         li    tmp0,edkey.action.fb.fname.inc.load
     683E 6834     
0040 6840 C804  38         mov   tmp0,@cmdb.action.ptr ; Set deferred action to run if proceeding
     6842 A728     
0041                                                   ; in "Unsaved changes" dialog
0042               
0043                       ;------------------------------------------------------
0044                       ; Process filename
0045                       ;------------------------------------------------------
0046               edkey.action.fb.fname.doit:
0047 6844 C120  34         mov   @edb.filename.ptr,tmp0
     6846 A512     
0048 6848 1311  14         jeq   edkey.action.fb.fname.exit
0049                                                   ; Exit early if new file.
0050               
0051 684A 0284  22         ci    tmp0,txt.newfile
     684C 3882     
0052 684E 130E  14         jeq   edkey.action.fb.fname.exit
0053                                                   ; Exit early if "[New file]"
0054               
0055 6850 C804  38         mov   tmp0,@parm1           ; Set filename
     6852 A006     
0056                       ;------------------------------------------------------
0057                       ; Show dialog "Unsaved changed" if editor buffer dirty
0058                       ;------------------------------------------------------
0059 6854 C120  34         mov   @edb.dirty,tmp0
     6856 A506     
0060 6858 1303  14         jeq   !
0061 685A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0062 685C 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     685E 7A00     
0063                       ;------------------------------------------------------
0064                       ; Update suffix
0065                       ;------------------------------------------------------
0066 6860 06A0  32 !       bl    @fm.browse.fname.suffix
     6862 797A     
0067                                                   ; Filename suffix adjust
0068                                                   ; i  \ parm1 = Pointer to filename
0069                                                   ; i  / parm2 = >FFFF or >0000
0070                       ;------------------------------------------------------
0071                       ; Load file
0072                       ;------------------------------------------------------
0073               edkey.action.fb.fname.doit.loadfile:
0074 6864 06A0  32         bl    @pane.cmdb.hide       ; Hide CMDB pane
     6866 7A90     
0075               
0076 6868 06A0  32         bl    @fm.loadfile          ; Load DV80 file
     686A 793C     
0077                                                   ; \ i  parm1 = Pointer to length-prefixed
0078                                                   ; /            device/filename string
0079               
0080               
0081                       ;------------------------------------------------------
0082                       ; Exit
0083                       ;------------------------------------------------------
0084               edkey.action.fb.fname.exit:
0085 686C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0086 686E 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     6870 63FE     
                   < stevie_b1.asm.33260
0083                       copy  "edkey.fb.block.asm"          ; Actions block move/copy/delete...
     **** ****     > edkey.fb.block.asm
0001               * FILE......: edkey.fb.block.asm
0002               * Purpose...: Mark lines for block operations
0003               
0004               *---------------------------------------------------------------
0005               * Mark line M1 or M2
0006               ********|*****|*********************|**************************
0007               edkey.action.block.mark:
0008 6872 06A0  32         bl    @edb.block.mark       ; Set M1/M2 marker
     6874 7B58     
0009                       ;-------------------------------------------------------
0010                       ; Exit
0011                       ;-------------------------------------------------------
0012 6876 0460  28         b     @edkey.keyscan.hook.debounce; Back to editor main
     6878 6156     
0013               
0014               
0015               *---------------------------------------------------------------
0016               * Reset block markers M1/M2
0017               ********|*****|*********************|**************************
0018               edkey.action.block.reset:
0019 687A 06A0  32         bl    @pane.errline.hide    ; Hide error line if visible
     687C 76F2     
0020 687E 06A0  32         bl    @edb.block.reset      ; Reset block markers M1/M2
     6880 7B80     
0021                       ;-------------------------------------------------------
0022                       ; Exit
0023                       ;-------------------------------------------------------
0024 6882 0460  28         b     @edkey.keyscan.hook.debounce; Back to editor main
     6884 6156     
0025               
0026               
0027               *---------------------------------------------------------------
0028               * Copy code block
0029               ********|*****|*********************|**************************
0030               edkey.action.block.copy:
0031 6886 0649  14         dect  stack
0032 6888 C644  30         mov   tmp0,*stack           ; Push tmp0
0033                       ;-------------------------------------------------------
0034                       ; Exit early if nothing to do
0035                       ;-------------------------------------------------------
0036 688A 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     688C A50E     
     688E 2022     
0037 6890 1315  14         jeq   edkey.action.block.copy.exit
0038                                                   ; Yes, exit early
0039                       ;-------------------------------------------------------
0040                       ; Init
0041                       ;-------------------------------------------------------
0042 6892 C120  34         mov   @wyx,tmp0             ; Get cursor position
     6894 832A     
0043 6896 0244  22         andi  tmp0,>ff00            ; Move cursor home (X=00)
     6898 FF00     
0044 689A C804  38         mov   tmp0,@fb.yxsave       ; Backup cursor position
     689C A316     
0045                       ;-------------------------------------------------------
0046                       ; Copy
0047                       ;-------------------------------------------------------
0048 689E 06A0  32         bl    @pane.errline.hide    ; Hide error line if visible
     68A0 76F2     
0049               
0050 68A2 04E0  34         clr   @parm1                ; Set message to "Copying block..."
     68A4 A006     
0051 68A6 06A0  32         bl    @edb.block.copy       ; Copy code block
     68A8 7B94     
0052                                                   ; \ i  @parm1    = Message flag
0053                                                   ; / o  @outparm1 = >ffff if success
0054               
0055 68AA 8820  54         c     @outparm1,@w$0000     ; Copy skipped?
     68AC A016     
     68AE 2000     
0056 68B0 1305  14         jeq   edkey.action.block.copy.exit
0057                                                   ; If yes, exit early
0058               
0059 68B2 C820  54         mov   @fb.yxsave,@parm1
     68B4 A316     
     68B6 A006     
0060 68B8 06A0  32         bl    @fb.restore           ; Restore frame buffer layout
     68BA 700E     
0061                                                   ; \ i  @parm1 = cursor YX position
0062                                                   ; /
0063                       ;-------------------------------------------------------
0064                       ; Exit
0065                       ;-------------------------------------------------------
0066               edkey.action.block.copy.exit:
0067 68BC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0068 68BE 0460  28         b     @edkey.keyscan.hook.debounce; Back to editor main
     68C0 6156     
0069               
0070               
0071               
0072               
0073               *---------------------------------------------------------------
0074               * Delete code block
0075               ********|*****|*********************|**************************
0076               edkey.action.block.delete:
0077                       ;-------------------------------------------------------
0078                       ; Exit early if nothing to do
0079                       ;-------------------------------------------------------
0080 68C2 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     68C4 A50E     
     68C6 2022     
0081 68C8 130F  14         jeq   edkey.action.block.delete.exit
0082                                                   ; Yes, exit early
0083                       ;-------------------------------------------------------
0084                       ; Delete
0085                       ;-------------------------------------------------------
0086 68CA 06A0  32         bl    @pane.errline.hide    ; Hide error message if visible
     68CC 76F2     
0087               
0088 68CE 04E0  34         clr   @parm1                ; Display message "Deleting block...."
     68D0 A006     
0089 68D2 06A0  32         bl    @edb.block.delete     ; Delete code block
     68D4 7B8A     
0090                                                   ; \ i  @parm1    = Display message Yes/No
0091                                                   ; / o  @outparm1 = >ffff if success
0092                       ;-------------------------------------------------------
0093                       ; Reposition in frame buffer
0094                       ;-------------------------------------------------------
0095 68D6 8820  54         c     @outparm1,@w$0000     ; Delete skipped?
     68D8 A016     
     68DA 2000     
0096 68DC 1305  14         jeq   edkey.action.block.delete.exit
0097                                                   ; If yes, exit early
0098               
0099 68DE C820  54         mov   @fb.topline,@parm1
     68E0 A304     
     68E2 A006     
0100 68E4 0460  28         b     @edkey.goto.fb.toprow ; Position on top row in frame buffer
     68E6 64B0     
0101                                                   ; \ i  @parm1 = Line to display as top row
0102                                                   ; /
0103                       ;-------------------------------------------------------
0104                       ; Exit
0105                       ;-------------------------------------------------------
0106               edkey.action.block.delete.exit:
0107 68E8 0460  28         b     @edkey.keyscan.hook.debounce; Back to editor main
     68EA 6156     
0108               
0109               
0110               *---------------------------------------------------------------
0111               * Move code block
0112               ********|*****|*********************|**************************
0113               edkey.action.block.move:
0114                       ;-------------------------------------------------------
0115                       ; Exit early if nothing to do
0116                       ;-------------------------------------------------------
0117 68EC 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     68EE A50E     
     68F0 2022     
0118 68F2 1313  14         jeq   edkey.action.block.move.exit
0119                                                   ; Yes, exit early
0120                       ;-------------------------------------------------------
0121                       ; Delete
0122                       ;-------------------------------------------------------
0123 68F4 06A0  32         bl    @pane.errline.hide    ; Hide error message if visible
     68F6 76F2     
0124               
0125 68F8 0720  34         seto  @parm1                ; Set message to "Moving block..."
     68FA A006     
0126 68FC 06A0  32         bl    @edb.block.copy       ; Copy code block
     68FE 7B94     
0127                                                   ; \ i  @parm1    = Message flag
0128                                                   ; / o  @outparm1 = >ffff if success
0129               
0130 6900 0720  34         seto  @parm1                ; Don't display delete message
     6902 A006     
0131 6904 06A0  32         bl    @edb.block.delete     ; Delete code block
     6906 7B8A     
0132                                                   ; \ i  @parm1    = Display message Yes/No
0133                                                   ; / o  @outparm1 = >ffff if success
0134                       ;-------------------------------------------------------
0135                       ; Reposition in frame buffer
0136                       ;-------------------------------------------------------
0137 6908 8820  54         c     @outparm1,@w$0000     ; Delete skipped?
     690A A016     
     690C 2000     
0138 690E 13EC  14         jeq   edkey.action.block.delete.exit
0139                                                   ; If yes, exit early
0140               
0141 6910 C820  54         mov   @fb.topline,@parm1
     6912 A304     
     6914 A006     
0142 6916 0460  28         b     @edkey.goto.fb.toprow ; Position on top row in frame buffer
     6918 64B0     
0143                                                   ; \ i  @parm1 = Line to display as top row
0144                                                   ; /
0145                       ;-------------------------------------------------------
0146                       ; Exit
0147                       ;-------------------------------------------------------
0148               edkey.action.block.move.exit:
0149 691A 0460  28         b     @edkey.keyscan.hook.debounce; Back to editor main
     691C 6156     
0150               
0151               
0152               *---------------------------------------------------------------
0153               * Goto marker M1
0154               ********|*****|*********************|**************************
0155               edkey.action.block.goto.m1:
0156 691E 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     6920 A50C     
     6922 2022     
0157 6924 1307  14         jeq   edkey.action.block.goto.m1.exit
0158                                                   ; Yes, exit early
0159                       ;-------------------------------------------------------
0160                       ; Goto marker M1
0161                       ;-------------------------------------------------------
0162 6926 C820  54         mov   @edb.block.m1,@parm1
     6928 A50C     
     692A A006     
0163 692C 0620  34         dec   @parm1                ; Base 0 offset
     692E A006     
0164               
0165 6930 0460  28         b     @edkey.action.goto    ; Goto specified line in editor bufer
     6932 64D0     
0166                                                   ; \ i @parm1 = Target line in EB
0167                                                   ; /
0168                       ;-------------------------------------------------------
0169                       ; Exit
0170                       ;-------------------------------------------------------
0171               edkey.action.block.goto.m1.exit:
0172 6934 0460  28         b     @edkey.keyscan.hook.debounce; Back to editor main
     6936 6156     
                   < stevie_b1.asm.33260
0084                       copy  "edkey.fb.tabs.asm"           ; tab-key related actions
     **** ****     > edkey.fb.tabs.asm
0001               * FILE......: edkey.fb.tabs.asm
0002               * Purpose...: Actions for moving to tab positions in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor on next tab
0006               *---------------------------------------------------------------
0007               edkey.action.fb.tab.next:
0008 6938 0649  14         dect  stack
0009 693A C64B  30         mov   r11,*stack            ; Save return address
0010 693C 06A0  32         bl    @fb.tab.next          ; Jump to next tab position on line
     693E 7B06     
0011                       ;------------------------------------------------------
0012                       ; Exit
0013                       ;------------------------------------------------------
0014               edkey.action.fb.tab.next.exit:
0015 6940 C2F9  30         mov   *stack+,r11           ; Pop r11
0016 6942 0460  28         b     @edkey.keyscan.hook.debounce; Back to editor main
     6944 6156     
                   < stevie_b1.asm.33260
0085                       copy  "edkey.fb.clip.asm"           ; Clipboard actions
     **** ****     > edkey.fb.clip.asm
0001               * FILE......: edkey.fb.clip.asm
0002               * Purpose...: Clipboard File related actions in frame buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Save clipboards
0006               *---------------------------------------------------------------
0007               * b   @edkey.action.fb.clip.save.[1-5]
0008               *---------------------------------------------------------------
0009               * INPUT
0010               * none
0011               *--------------------------------------------------------------
0012               * Register usage
0013               * tmp0
0014               ********|*****|*********************|**************************
0015               edkey.action.fb.clip.save.1:
0016 6946 0204  20         li    tmp0,clip1
     6948 3100     
0017 694A 100B  14         jmp   !
0018               edkey.action.fb.clip.save.2:
0019 694C 0204  20         li    tmp0,clip2
     694E 3200     
0020 6950 1008  14         jmp   !
0021               edkey.action.fb.clip.save.3:
0022 6952 0204  20         li    tmp0,clip3
     6954 3300     
0023 6956 1005  14         jmp   !
0024               edkey.action.fb.clip.save.4:
0025 6958 0204  20         li    tmp0,clip4
     695A 3400     
0026 695C 1002  14         jmp   !
0027               edkey.action.fb.clip.save.5:
0028 695E 0204  20         li    tmp0,clip5
     6960 3500     
0029                       ;-------------------------------------------------------
0030                       ; Save block to clipboard
0031                       ;-------------------------------------------------------
0032 6962 C804  38 !       mov   tmp0,@parm1
     6964 A006     
0033 6966 06A0  32         bl    @edb.block.clip       ; Save block to clipboard
     6968 7B76     
0034                                                   ; \ i  @parm1 = Suffix clipboard filename
0035                                                   ; /
0036                       ;-------------------------------------------------------
0037                       ; Exit
0038                       ;-------------------------------------------------------
0039               edkey.action.fb.clip.save.exit:
0040 696A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0041               
0042 696C C820  54         mov   @fb.topline,@parm1    ; Get topline
     696E A304     
     6970 A006     
0043 6972 0460  28         b     @edkey.goto.fb.toprow ; \ Position cursor and exit
     6974 64B0     
0044                                                   ; / i  @parm1 = Line in editor buffer
                   < stevie_b1.asm.33260
0086                       ;-----------------------------------------------------------------------
0087                       ; Keyboard actions - Command Buffer
0088                       ;-----------------------------------------------------------------------
0089                       copy  "edkey.cmdb.mov.asm"          ; Actions for movement keys
     **** ****     > edkey.cmdb.mov.asm
0001               * FILE......: edkey.cmdb.mov.asm
0002               * Purpose...: Actions for movement keys in command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Cursor left
0006               *---------------------------------------------------------------
0007               edkey.action.cmdb.left:
0008 6976 C120  34         mov   @cmdb.column,tmp0
     6978 A712     
0009 697A 1304  14         jeq   !                     ; column=0 ? Skip further processing
0010                       ;-------------------------------------------------------
0011                       ; Update
0012                       ;-------------------------------------------------------
0013 697C 0620  34         dec   @cmdb.column          ; Column-- in command buffer
     697E A712     
0014 6980 0620  34         dec   @cmdb.cursor          ; Column-- CMDB cursor
     6982 A70A     
0015                       ;-------------------------------------------------------
0016                       ; Exit
0017                       ;-------------------------------------------------------
0018 6984 0460  28 !       b     @edkey.keyscan.hook.debounce; Back to editor main
     6986 6156     
0019               
0020               
0021               *---------------------------------------------------------------
0022               * Cursor right
0023               *---------------------------------------------------------------
0024               edkey.action.cmdb.right:
0025 6988 06A0  32         bl    @cmdb.cmd.getlength
     698A 7AB8     
0026 698C 8820  54         c     @cmdb.column,@outparm1
     698E A712     
     6990 A016     
0027 6992 1404  14         jhe   !                     ; column > length line ? Skip processing
0028                       ;-------------------------------------------------------
0029                       ; Update
0030                       ;-------------------------------------------------------
0031 6994 05A0  34         inc   @cmdb.column          ; Column++ in command buffer
     6996 A712     
0032 6998 05A0  34         inc   @cmdb.cursor          ; Column++ CMDB cursor
     699A A70A     
0033                       ;-------------------------------------------------------
0034                       ; Exit
0035                       ;-------------------------------------------------------
0036 699C 0460  28 !       b     @edkey.keyscan.hook.debounce; Back to editor main
     699E 6156     
0037               
0038               
0039               
0040               *---------------------------------------------------------------
0041               * Cursor beginning of line
0042               *---------------------------------------------------------------
0043               edkey.action.cmdb.home:
0044 69A0 04C4  14         clr   tmp0
0045 69A2 C804  38         mov   tmp0,@cmdb.column      ; First column
     69A4 A712     
0046 69A6 0584  14         inc   tmp0
0047 69A8 D120  34         movb  @cmdb.cursor,tmp0      ; Get CMDB cursor position
     69AA A70A     
0048 69AC C804  38         mov   tmp0,@cmdb.cursor      ; Reposition CMDB cursor
     69AE A70A     
0049               
0050 69B0 0460  28         b     @edkey.keyscan.hook.debounce ; Back to editor main
     69B2 6156     
0051               
0052               *---------------------------------------------------------------
0053               * Cursor end of line
0054               *---------------------------------------------------------------
0055               edkey.action.cmdb.end:
0056 69B4 D120  34         movb  @cmdb.cmdlen,tmp0      ; Get length byte of current command
     69B6 A72A     
0057 69B8 0984  56         srl   tmp0,8                 ; Right justify
0058 69BA C804  38         mov   tmp0,@cmdb.column      ; Save column position
     69BC A712     
0059 69BE 0584  14         inc   tmp0                   ; One time adjustment command prompt
0060 69C0 0224  22         ai    tmp0,>1a00             ; Y=26
     69C2 1A00     
0061 69C4 C804  38         mov   tmp0,@cmdb.cursor      ; Set cursor position
     69C6 A70A     
0062                       ;-------------------------------------------------------
0063                       ; Exit
0064                       ;-------------------------------------------------------
0065 69C8 0460  28         b     @edkey.keyscan.hook.debounce ; Back to editor main
     69CA 6156     
                   < stevie_b1.asm.33260
0090                       copy  "edkey.cmdb.mod.asm"          ; Actions for modifier keys
     **** ****     > edkey.cmdb.mod.asm
0001               * FILE......: edkey.cmdb.mod.asm
0002               * Purpose...: Actions for modifier keys in command buffer pane.
0003               
0004               ***************************************************************
0005               * edkey.action.cmdb.clear
0006               * Clear current command
0007               ***************************************************************
0008               * b  @edkey.action.cmdb.clear
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
0021               edkey.action.cmdb.clear:
0022                       ;-------------------------------------------------------
0023                       ; Clear current command
0024                       ;-------------------------------------------------------
0025 69CC 06A0  32         bl    @cmdb.cmd.clear       ; Clear current command
     69CE 7AAE     
0026 69D0 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
     69D2 A718     
0027                       ;-------------------------------------------------------
0028                       ; Exit
0029                       ;-------------------------------------------------------
0030               edkey.action.cmdb.clear.exit:
0031 69D4 0460  28         b     @edkey.action.cmdb.home
     69D6 69A0     
0032                                                   ; Reposition cursor
0033               
0034               
0035               
0036               
0037               
0038               
0039               ***************************************************************
0040               * edkey.action.cmdb.char
0041               * Add character to command line
0042               ***************************************************************
0043               * b  @edkey.action.cmdb.char
0044               *--------------------------------------------------------------
0045               * INPUT
0046               * tmp1
0047               *--------------------------------------------------------------
0048               * OUTPUT
0049               * none
0050               *--------------------------------------------------------------
0051               * Register usage
0052               * tmp0
0053               *--------------------------------------------------------------
0054               * Notes
0055               ********|*****|*********************|**************************
0056               edkey.action.cmdb.char:
0057 69D8 0649  14         dect  stack
0058 69DA C644  30         mov   tmp0,*stack           ; Push tmp0
0059 69DC 0649  14         dect  stack
0060 69DE C645  30         mov   tmp1,*stack           ; Push tmp1
0061                       ;-------------------------------------------------------
0062                       ; Asserts
0063                       ;-------------------------------------------------------
0064 69E0 C120  34         mov   @keycode1,tmp0        ; Get keycode
     69E2 A028     
0065 69E4 0284  22         ci    tmp0,32               ; Keycode < ASCII 32 ?
     69E6 0020     
0066 69E8 111C  14         jlt   edkey.action.cmdb.char.exit
0067                                                   ; Yes, skip
0068               
0069 69EA 0284  22         ci    tmp0,126              ; Keycode > ASCII 126 ?
     69EC 007E     
0070 69EE 1519  14         jgt   edkey.action.cmdb.char.exit
0071                                                   ; Yes, skip
0072               
0073 69F0 0284  22         ci    tmp0,96               ; ASCII 97 'a'
     69F2 0060     
0074 69F4 1102  14         jlt   !
0075 69F6 0224  22         ai    tmp0,-32              ; Make uppercase
     69F8 FFE0     
0076                       ;-------------------------------------------------------
0077                       ; Add character
0078                       ;-------------------------------------------------------
0079 69FA C144  18 !       mov   tmp0,tmp1             ; \
0080 69FC 0A85  56         sla   tmp1,8                ; / Move keycode to MSB
0081               
0082 69FE 0720  34         seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
     6A00 A718     
0083               
0084 6A02 0204  20         li    tmp0,cmdb.cmd         ; Get beginning of command
     6A04 A72B     
0085 6A06 A120  34         a     @cmdb.column,tmp0     ; Add current column to command
     6A08 A712     
0086 6A0A D505  30         movb  tmp1,*tmp0            ; Add character
0087 6A0C 05A0  34         inc   @cmdb.column          ; Next column
     6A0E A712     
0088 6A10 05A0  34         inc   @cmdb.cursor          ; Next column cursor
     6A12 A70A     
0089               
0090 6A14 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     6A16 7AB8     
0091                                                   ; \ i  @cmdb.cmd = Command string
0092                                                   ; / o  @outparm1 = Length of command
0093                       ;-------------------------------------------------------
0094                       ; Addjust length
0095                       ;-------------------------------------------------------
0096 6A18 C120  34         mov   @outparm1,tmp0
     6A1A A016     
0097 6A1C 0A84  56         sla   tmp0,8               ; Move to MSB
0098 6A1E D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     6A20 A72A     
0099                       ;-------------------------------------------------------
0100                       ; Exit
0101                       ;-------------------------------------------------------
0102               edkey.action.cmdb.char.exit:
0103 6A22 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0104 6A24 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0105 6A26 0460  28         b     @edkey.keyscan.hook.debounce
     6A28 6156     
0106                                                   ; Back to editor main
                   < stevie_b1.asm.33260
0091                       copy  "edkey.cmdb.misc.asm"         ; Miscelanneous actions
     **** ****     > edkey.cmdb.misc.asm
0001               * FILE......: edkey.cmdb.misc.asm
0002               * Purpose...: Actions for miscelanneous keys in command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Show/Hide command buffer pane
0006               ********|*****|*********************|**************************
0007               edkey.action.cmdb.toggle:
0008 6A2A C120  34         mov   @cmdb.visible,tmp0
     6A2C A702     
0009 6A2E 1605  14         jne   edkey.action.cmdb.hide
0010                       ;-------------------------------------------------------
0011                       ; Show pane
0012                       ;-------------------------------------------------------
0013               edkey.action.cmdb.show:
0014 6A30 04E0  34         clr   @cmdb.column          ; Column = 0
     6A32 A712     
0015 6A34 06A0  32         bl    @pane.cmdb.show       ; Show command buffer pane
     6A36 7A86     
0016 6A38 1002  14         jmp   edkey.action.cmdb.toggle.exit
0017                       ;-------------------------------------------------------
0018                       ; Hide pane
0019                       ;-------------------------------------------------------
0020               edkey.action.cmdb.hide:
0021 6A3A 06A0  32         bl    @pane.cmdb.hide       ; Hide command buffer pane
     6A3C 7A90     
0022                       ;-------------------------------------------------------
0023                       ; Exit
0024                       ;-------------------------------------------------------
0025               edkey.action.cmdb.toggle.exit:
0026 6A3E 0460  28         b     @edkey.keyscan.hook.debounce; Back to editor main
     6A40 6156     
0027               
0028               
0029               
0030               
0031               
                   < stevie_b1.asm.33260
0092                       copy  "edkey.cmdb.file.new.asm"     ; New file
     **** ****     > edkey.cmdb.file.new.asm
0001               * FILE......: edkey.cmdb.fíle.new.asm
0002               * Purpose...: New file from command buffer pane
0003               
0004               *---------------------------------------------------------------
0005               * New file
0006               *---------------------------------------------------------------
0007               edkey.action.cmdb.file.new:
0008                       ;-------------------------------------------------------
0009                       ; New file
0010                       ;-------------------------------------------------------
0011 6A42 0649  14         dect  stack
0012 6A44 C64B  30         mov   r11,*stack            ; Save return address
0013 6A46 0649  14         dect  stack
0014 6A48 C644  30         mov   tmp0,*stack           ; Push tmp0
0015                       ;-------------------------------------------------------
0016                       ; Show dialog "Unsaved changes" if editor buffer dirty
0017                       ;-------------------------------------------------------
0018 6A4A C120  34         mov   @edb.dirty,tmp0       ; Editor dirty?
     6A4C A506     
0019 6A4E 1304  14         jeq   !                     ; No, skip "Unsaved changes"
0020               
0021 6A50 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0022 6A52 C2F9  30         mov   *stack+,r11           ; Pop R11
0023 6A54 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     6A56 7A00     
0024                       ;-------------------------------------------------------
0025                       ; Reset editor
0026                       ;-------------------------------------------------------
0027 6A58 06A0  32 !       bl    @pane.cmdb.hide       ; Hide CMDB pane
     6A5A 7A90     
0028 6A5C 06A0  32         bl    @fm.newfile           ; New file in editor
     6A5E 799E     
0029                       ;-------------------------------------------------------
0030                       ; Exit
0031                       ;-------------------------------------------------------
0032               edkey.action.cmdb.file.new.exit:
0033 6A60 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0034 6A62 C2F9  30         mov   *stack+,r11           ; Pop R11
0035 6A64 0460  28         b     @edkey.action.top     ; Goto 1st line in editor buffer
     6A66 63FE     
                   < stevie_b1.asm.33260
0093                       copy  "edkey.cmdb.file.load.asm"    ; Open file
     **** ****     > edkey.cmdb.file.load.asm
0001               * FILE......: edkey.cmdb.fíle.load.asm
0002               * Purpose...: Load file from command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Load file
0006               *---------------------------------------------------------------
0007               edkey.action.cmdb.load:
0008                       ;-------------------------------------------------------
0009                       ; Load file
0010                       ;-------------------------------------------------------
0011 6A68 06A0  32         bl    @pane.cmdb.hide       ; Hide CMDB pane
     6A6A 7A90     
0012               
0013 6A6C 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     6A6E 7AB8     
0014 6A70 C120  34         mov   @outparm1,tmp0        ; Length == 0 ?
     6A72 A016     
0015 6A74 1607  14         jne   !                     ; No, prepare for load
0016                       ;-------------------------------------------------------
0017                       ; No filename specified
0018                       ;-------------------------------------------------------
0019 6A76 0204  20         li    tmp0,txt.io.nofile    ; \
     6A78 3A2C     
0020 6A7A C804  38         mov   tmp0,@parm1           ; / Error message
     6A7C A006     
0021               
0022 6A7E 06A0  32         bl    @error.display        ; Show error message
     6A80 7A72     
0023                                                   ; \ i  @parm1 = Pointer to error message
0024                                                   ; /
0025               
0026 6A82 1012  14         jmp   edkey.action.cmdb.load.exit
0027                       ;-------------------------------------------------------
0028                       ; Get filename
0029                       ;-------------------------------------------------------
0030 6A84 0A84  56 !       sla   tmp0,8               ; LSB to MSB
0031 6A86 D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     6A88 A72A     
0032               
0033 6A8A 06A0  32         bl    @cpym2m
     6A8C 24EE     
0034 6A8E A72A                   data cmdb.cmdlen,heap.top,80
     6A90 F000     
     6A92 0050     
0035                                                   ; Copy filename from command line to buffer
0036                       ;-------------------------------------------------------
0037                       ; Pass filename as parm1
0038                       ;-------------------------------------------------------
0039 6A94 0204  20         li    tmp0,heap.top         ; 1st line in heap
     6A96 F000     
0040 6A98 C804  38         mov   tmp0,@parm1
     6A9A A006     
0041                       ;-------------------------------------------------------
0042                       ; Load file
0043                       ;-------------------------------------------------------
0044               edkey.action.cmdb.load.file:
0045 6A9C 0204  20         li    tmp0,heap.top         ; 1st line in heap
     6A9E F000     
0046 6AA0 C804  38         mov   tmp0,@parm1
     6AA2 A006     
0047               
0048 6AA4 06A0  32         bl    @fm.loadfile          ; Load DV80 file
     6AA6 793C     
0049                                                   ; \ i  parm1 = Pointer to length-prefixed
0050                                                   ; /            device/filename string
0051                       ;-------------------------------------------------------
0052                       ; Exit
0053                       ;-------------------------------------------------------
0054               edkey.action.cmdb.load.exit:
0055 6AA8 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     6AAA 63FE     
                   < stevie_b1.asm.33260
0094                       copy  "edkey.cmdb.file.insert.asm"  ; Insert file
     **** ****     > edkey.cmdb.file.insert.asm
0001               * FILE......: edkey.cmdb.fíle.insert.asm
0002               * Purpose...: Insert file from command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Insert file
0006               *---------------------------------------------------------------
0007               edkey.action.cmdb.insert:
0008 6AAC 0649  14         dect  stack
0009 6AAE C644  30         mov   tmp0,*stack           ; Push tmp0
0010 6AB0 0649  14         dect  stack
0011 6AB2 C660  46         mov   @fb.topline,*stack    ; Push line number of fb top row
     6AB4 A304     
0012                       ;-------------------------------------------------------
0013                       ; Insert file at current line in editor buffer
0014                       ;-------------------------------------------------------
0015 6AB6 06A0  32         bl    @pane.cmdb.hide       ; Hide CMDB pane
     6AB8 7A90     
0016               
0017 6ABA 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     6ABC 7AB8     
0018 6ABE C120  34         mov   @outparm1,tmp0        ; Length == 0 ?
     6AC0 A016     
0019 6AC2 1607  14         jne   !                     ; No, prepare for load
0020                       ;-------------------------------------------------------
0021                       ; No filename specified
0022                       ;-------------------------------------------------------
0023 6AC4 0204  20         li    tmp0,txt.io.nofile    ; \
     6AC6 3A2C     
0024 6AC8 C804  38         mov   tmp0,@parm1           ; / Error message
     6ACA A006     
0025               
0026 6ACC 06A0  32         bl    @error.display        ; Show error message
     6ACE 7A72     
0027                                                   ; \ i  @parm1 = Pointer to error message
0028                                                   ; /
0029               
0030 6AD0 1029  14         jmp   edkey.action.cmdb.insert.exit
0031                       ;-------------------------------------------------------
0032                       ; Get filename
0033                       ;-------------------------------------------------------
0034 6AD2 0A84  56 !       sla   tmp0,8               ; LSB to MSB
0035 6AD4 D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     6AD6 A72A     
0036               
0037 6AD8 06A0  32         bl    @cpym2m
     6ADA 24EE     
0038 6ADC A72A                   data cmdb.cmdall,heap.top,80
     6ADE F000     
     6AE0 0050     
0039                                                   ; Copy filename from command line to buffer
0040                       ;-------------------------------------------------------
0041                       ; Pass filename as parm1
0042                       ;-------------------------------------------------------
0043 6AE2 0204  20         li    tmp0,heap.top         ; 1st line in heap
     6AE4 F000     
0044 6AE6 C804  38         mov   tmp0,@parm1
     6AE8 A006     
0045                       ;-------------------------------------------------------
0046                       ; Insert file at line
0047                       ;-------------------------------------------------------
0048               edkey.action.cmdb.insert.file:
0049                       ;-------------------------------------------------------
0050                       ; Get line
0051                       ;-------------------------------------------------------
0052 6AEA C820  54         mov   @fb.row,@parm1
     6AEC A306     
     6AEE A006     
0053 6AF0 06A0  32         bl    @fb.row2line          ; Row to editor line
     6AF2 307A     
0054                                                   ; \ i @fb.topline = Top line in frame buffer
0055                                                   ; | i @parm1      = Row in frame buffer
0056                                                   ; / o @outparm1   = Matching line in EB
0057               
0058 6AF4 C820  54         mov   @outparm1,@parm2      ; \ Line to insert file at is the editor
     6AF6 A016     
     6AF8 A008     
0059 6AFA 05A0  34         inc   @parm2                ; / line where the cursor is at +1
     6AFC A008     
0060                       ;-------------------------------------------------------
0061                       ; Get device/filename
0062                       ;-------------------------------------------------------
0063 6AFE 0204  20         li    tmp0,heap.top         ; 1st line in heap
     6B00 F000     
0064 6B02 C804  38         mov   tmp0,@parm1
     6B04 A006     
0065                       ;-------------------------------------------------------
0066                       ; Insert file
0067                       ;-------------------------------------------------------
0068 6B06 0204  20         li    tmp0,id.file.insertfile
     6B08 0002     
0069 6B0A C804  38         mov   tmp0,@parm3           ; Set work mode
     6B0C A00A     
0070               
0071 6B0E 06A0  32         bl    @fm.insertfile        ; Insert DV80 file
     6B10 7962     
0072                                                   ; \ i  parm1 = Pointer to length-prefixed
0073                                                   ; |            device/filename string
0074                                                   ; | i  parm2 = Line number to load file at
0075                                                   ; / i  parm3 = Work mode
0076                       ;-------------------------------------------------------
0077                       ; Refresh frame buffer
0078                       ;-------------------------------------------------------
0079 6B12 0720  34         seto  @fb.dirty             ; Refresh frame buffer
     6B14 A318     
0080 6B16 0720  34         seto  @edb.dirty            ; Editor buffer dirty
     6B18 A506     
0081               
0082 6B1A C820  54         mov   @fb.topline,@parm1
     6B1C A304     
     6B1E A006     
0083 6B20 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     6B22 6F98     
0084                                                   ; | i  @parm1 = Line to start with
0085                                                   ; /             (becomes @fb.topline)
0086               
0087                       ;-------------------------------------------------------
0088                       ; Exit
0089                       ;-------------------------------------------------------
0090               edkey.action.cmdb.insert.exit:
0091 6B24 C839  50         mov   *stack+,@parm1        ; Pop top row
     6B26 A006     
0092 6B28 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0093 6B2A 0460  28         b     @edkey.goto.fb.toprow ; \ Position cursor and exit
     6B2C 64B0     
0094                                                   ; / i  @parm1 = Line in editor buffer
                   < stevie_b1.asm.33260
0095                       copy  "edkey.cmdb.file.append.asm"  ; Append file
     **** ****     > edkey.cmdb.file.append.asm
0001               * FILE......: edkey.cmdb.fíle.append.asm
0002               * Purpose...: Append file from command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Append file
0006               *---------------------------------------------------------------
0007               edkey.action.cmdb.append:
0008 6B2E 0649  14         dect  stack
0009 6B30 C644  30         mov   tmp0,*stack           ; Push tmp0
0010 6B32 0649  14         dect  stack
0011 6B34 C660  46         mov   @fb.topline,*stack    ; Push line number of fb top row
     6B36 A304     
0012                       ;-------------------------------------------------------
0013                       ; Append file after last line in editor buffer
0014                       ;-------------------------------------------------------
0015 6B38 06A0  32         bl    @pane.cmdb.hide       ; Hide CMDB pane
     6B3A 7A90     
0016               
0017 6B3C 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     6B3E 7AB8     
0018 6B40 C120  34         mov   @outparm1,tmp0        ; Length == 0 ?
     6B42 A016     
0019 6B44 1607  14         jne   !                     ; No, prepare for load
0020                       ;-------------------------------------------------------
0021                       ; No filename specified
0022                       ;-------------------------------------------------------
0023 6B46 0204  20         li    tmp0,txt.io.nofile    ; \
     6B48 3A2C     
0024 6B4A C804  38         mov   tmp0,@parm1           ; / Error message
     6B4C A006     
0025               
0026 6B4E 06A0  32         bl    @error.display        ; Show error message
     6B50 7A72     
0027                                                   ; \ i  @parm1 = Pointer to error message
0028                                                   ; /
0029               
0030 6B52 1022  14         jmp   edkey.action.cmdb.append.exit
0031                       ;-------------------------------------------------------
0032                       ; Get filename
0033                       ;-------------------------------------------------------
0034 6B54 0A84  56 !       sla   tmp0,8               ; LSB to MSB
0035 6B56 D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     6B58 A72A     
0036               
0037 6B5A 06A0  32         bl    @cpym2m
     6B5C 24EE     
0038 6B5E A72A                   data cmdb.cmdall,heap.top,80
     6B60 F000     
     6B62 0050     
0039                                                   ; Copy filename from command line to buffer
0040                       ;-------------------------------------------------------
0041                       ; Pass filename as parm1
0042                       ;-------------------------------------------------------
0043 6B64 0204  20         li    tmp0,heap.top         ; 1st line in heap
     6B66 F000     
0044 6B68 C804  38         mov   tmp0,@parm1
     6B6A A006     
0045                       ;-------------------------------------------------------
0046                       ; Append file
0047                       ;-------------------------------------------------------
0048               edkey.action.cmdb.append.file:
0049 6B6C C820  54         mov   @edb.lines,@parm2     ; \ Append file after last line in
     6B6E A504     
     6B70 A008     
0050                                                   ; / editor buffer (base 0 offset)
0051                       ;-------------------------------------------------------
0052                       ; Get device/filename
0053                       ;-------------------------------------------------------
0054 6B72 0204  20         li    tmp0,heap.top         ; 1st line in heap
     6B74 F000     
0055 6B76 C804  38         mov   tmp0,@parm1
     6B78 A006     
0056                       ;-------------------------------------------------------
0057                       ; Append file
0058                       ;-------------------------------------------------------
0059 6B7A 0204  20         li    tmp0,id.file.appendfile
     6B7C 0003     
0060 6B7E C804  38         mov   tmp0,@parm3           ; Set work mode
     6B80 A00A     
0061               
0062 6B82 06A0  32         bl    @fm.insertfile        ; Insert DV80 file
     6B84 7962     
0063                                                   ; \ i  parm1 = Pointer to length-prefixed
0064                                                   ; |            device/filename string
0065                                                   ; | i  parm2 = Line number to load file at
0066                                                   ; / i  parm3 = Work mode
0067                       ;-------------------------------------------------------
0068                       ; Refresh frame buffer
0069                       ;-------------------------------------------------------
0070 6B86 0720  34         seto  @fb.dirty             ; Refresh frame buffer
     6B88 A318     
0071 6B8A 0720  34         seto  @edb.dirty            ; Editor buffer dirty
     6B8C A506     
0072               
0073 6B8E C820  54         mov   @fb.topline,@parm1
     6B90 A304     
     6B92 A006     
0074 6B94 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     6B96 6F98     
0075                                                   ; | i  @parm1 = Line to start with
0076                                                   ; /             (becomes @fb.topline)
0077               
0078                       ;-------------------------------------------------------
0079                       ; Exit
0080                       ;-------------------------------------------------------
0081               edkey.action.cmdb.append.exit:
0082 6B98 C839  50         mov   *stack+,@parm1        ; Pop top row
     6B9A A006     
0083 6B9C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0084 6B9E 0460  28         b     @edkey.goto.fb.toprow ; \ Position cursor and exit
     6BA0 64B0     
0085                                                   ; / i  @parm1 = Line in editor buffer
                   < stevie_b1.asm.33260
0096                       copy  "edkey.cmdb.file.clip.asm"    ; Copy clipboard to line
     **** ****     > edkey.cmdb.file.clip.asm
0001               * FILE......: edkey.cmdb.fíle.clip.asm
0002               * Purpose...: Copy clipboard file to line
0003               
0004               *---------------------------------------------------------------
0005               * Copy clipboard file to line
0006               *---------------------------------------------------------------
0007               edkey.action.cmdb.clip.1
0008 6BA2 0204  20         li    tmp0,clip1
     6BA4 3100     
0009 6BA6 100C  14         jmp   edkey.action.cmdb.clip
0010               
0011               edkey.action.cmdb.clip.2
0012 6BA8 0204  20         li    tmp0,clip2
     6BAA 3200     
0013 6BAC 1009  14         jmp   edkey.action.cmdb.clip
0014               
0015               edkey.action.cmdb.clip.3
0016 6BAE 0204  20         li    tmp0,clip3
     6BB0 3300     
0017 6BB2 1006  14         jmp   edkey.action.cmdb.clip
0018               
0019               edkey.action.cmdb.clip.4
0020 6BB4 0204  20         li    tmp0,clip4
     6BB6 3400     
0021 6BB8 1003  14         jmp   edkey.action.cmdb.clip
0022               
0023               edkey.action.cmdb.clip.5
0024 6BBA 0204  20         li    tmp0,clip5
     6BBC 3500     
0025 6BBE 1000  14         jmp   edkey.action.cmdb.clip
0026               
0027               
0028               edkey.action.cmdb.clip:
0029 6BC0 C804  38         mov   tmp0,@parm1           ; Get clipboard suffix 0-9
     6BC2 A006     
0030               
0031 6BC4 06A0  32         bl    @film
     6BC6 224A     
0032 6BC8 A72A                   data cmdb.cmdall,>00,80
     6BCA 0000     
     6BCC 0050     
0033               
0034 6BCE 06A0  32         bl    @cpym2m
     6BD0 24EE     
0035 6BD2 DE50                   data tv.clip.fname,cmdb.cmdall,80
     6BD4 A72A     
     6BD6 0050     
0036                       ;------------------------------------------------------
0037                       ; Append suffix character to clipboard device/filename
0038                       ;------------------------------------------------------
0039 6BD8 C120  34         mov   @tv.clip.fname,tmp0
     6BDA DE50     
0040 6BDC C144  18         mov   tmp0,tmp1
0041 6BDE 0984  56         srl   tmp0,8                ; Get string length
0042 6BE0 0224  22         ai    tmp0,cmdb.cmdall      ; Add base
     6BE2 A72A     
0043 6BE4 0584  14         inc   tmp0                  ; Consider length-prefix byte
0044 6BE6 D520  46         movb  @parm1,*tmp0          ; Append suffix
     6BE8 A006     
0045               
0046 6BEA 0460  28         b     @edkey.action.cmdb.insert
     6BEC 6AAC     
0047                                                   ; Insert file
                   < stevie_b1.asm.33260
0097                       copy  "edkey.cmdb.file.clipdev.asm" ; Configure clipboard device
     **** ****     > edkey.cmdb.file.clipdev.asm
0001               * FILE......: edkey.cmdb.fíle.clipdev.asm
0002               * Purpose...: Configure clipboard device
0003               
0004               *---------------------------------------------------------------
0005               * Configure clipboard device
0006               *---------------------------------------------------------------
0007               edkey.action.cmdb.clipdev.configure:
0008                       ;-------------------------------------------------------
0009                       ; Configure
0010                       ;-------------------------------------------------------
0011 6BEE 06A0  32         bl    @pane.cmdb.hide       ; Hide CMDB pane
     6BF0 7A90     
0012               
0013 6BF2 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     6BF4 7AB8     
0014 6BF6 C120  34         mov   @outparm1,tmp0        ; Length == 0 ?
     6BF8 A016     
0015 6BFA 1607  14         jne   !                     ; No, set clipboard device and filename
0016                       ;-------------------------------------------------------
0017                       ; No filename specified
0018                       ;-------------------------------------------------------
0019 6BFC 0204  20         li    tmp0,txt.io.nofile    ; \
     6BFE 3A2C     
0020 6C00 C804  38         mov   tmp0,@parm1           ; / Error message
     6C02 A006     
0021               
0022 6C04 06A0  32         bl    @error.display        ; Show error message
     6C06 7A72     
0023                                                   ; \ i  @parm1 = Pointer to error message
0024                                                   ; /
0025               
0026 6C08 1018  14         jmp   edkey.action.cmdb.clipdev.configure.exit
0027                       ;-------------------------------------------------------
0028                       ; Set clipboard device and filename
0029                       ;-------------------------------------------------------
0030 6C0A 0A84  56 !       sla   tmp0,8               ; LSB to MSB
0031 6C0C D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     6C0E A72A     
0032               
0033 6C10 06A0  32         bl    @cpym2m
     6C12 24EE     
0034 6C14 A72A                   data cmdb.cmdall,tv.clip.fname,80
     6C16 DE50     
     6C18 0050     
0035                                                   ; Copy filename from command line to buffer
0036               
0037                       ;-------------------------------------------------------
0038                       ; Show message
0039                       ;-------------------------------------------------------
0040               edkey.action.cmdb.clipdev.configure.message:
0041 6C1A 06A0  32         bl    @hchar
     6C1C 27E6     
0042 6C1E 0034                   byte 0,52,32,20
     6C20 2014     
0043 6C22 FFFF                   data EOL              ; Erase any previous message
0044               
0045 6C24 06A0  32         bl    @putat
     6C26 2456     
0046 6C28 0034                   byte 0,52
0047 6C2A 3844                   data txt.done.clipdev
0048                       ;-------------------------------------------------------
0049                       ; Setup one shot task for removing overlay message
0050                       ;-------------------------------------------------------
0051 6C2C 0204  20         li    tmp0,pane.topline.oneshot.clearmsg
     6C2E 3630     
0052 6C30 C804  38         mov   tmp0,@tv.task.oneshot
     6C32 A224     
0053               
0054 6C34 06A0  32         bl    @rsslot               ; \ Reset loop counter slot 3
     6C36 2ECC     
0055 6C38 0003                   data 3                ; / for getting consistent delay
0056                       ;-------------------------------------------------------
0057                       ; Exit
0058                       ;-------------------------------------------------------
0059               edkey.action.cmdb.clipdev.configure.exit:
0060 6C3A 0460  28         b    @edkey.action.top      ; Goto 1st line in editor buffer
     6C3C 63FE     
                   < stevie_b1.asm.33260
0098                       copy  "edkey.cmdb.file.save.asm"    ; Save file
     **** ****     > edkey.cmdb.file.save.asm
0001               * FILE......: edkey.cmdb.fíle.save.asm
0002               * Purpose...: File related actions in command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Save file
0006               *---------------------------------------------------------------
0007               edkey.action.cmdb.save:
0008 6C3E 0649  14         dect  stack
0009 6C40 C644  30         mov   tmp0,*stack           ; Push tmp0
0010 6C42 0649  14         dect  stack
0011 6C44 C660  46         mov   @fb.topline,*stack    ; Push line number of fb top row
     6C46 A304     
0012                       ;-------------------------------------------------------
0013                       ; Save file
0014                       ;-------------------------------------------------------
0015 6C48 06A0  32         bl    @pane.cmdb.hide       ; Hide CMDB pane
     6C4A 7A90     
0016               
0017 6C4C 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     6C4E 7AB8     
0018 6C50 C120  34         mov   @outparm1,tmp0        ; Length == 0 ?
     6C52 A016     
0019 6C54 1607  14         jne   !                     ; No, prepare for save
0020                       ;-------------------------------------------------------
0021                       ; No filename specified
0022                       ;-------------------------------------------------------
0023 6C56 0204  20         li    tmp0,txt.io.nofile    ; \
     6C58 3A2C     
0024 6C5A C804  38         mov   tmp0,@parm1           ; / Error message
     6C5C A006     
0025               
0026 6C5E 06A0  32         bl    @error.display        ; Show error message
     6C60 7A72     
0027                                                   ; \ i  @parm1 = Pointer to error message
0028                                                   ; /
0029               
0030 6C62 1026  14         jmp   edkey.action.cmdb.save.exit
0031                       ;-------------------------------------------------------
0032                       ; Get filename
0033                       ;-------------------------------------------------------
0034 6C64 0A84  56 !       sla   tmp0,8               ; LSB to MSB
0035 6C66 D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     6C68 A72A     
0036               
0037 6C6A 06A0  32         bl    @cpym2m
     6C6C 24EE     
0038 6C6E A72A                   data cmdb.cmdlen,heap.top,80
     6C70 F000     
     6C72 0050     
0039                                                   ; Copy filename from command line to buffer
0040                       ;-------------------------------------------------------
0041                       ; Pass filename as parm1
0042                       ;-------------------------------------------------------
0043 6C74 0204  20         li    tmp0,heap.top         ; 1st line in heap
     6C76 F000     
0044 6C78 C804  38         mov   tmp0,@parm1
     6C7A A006     
0045                       ;-------------------------------------------------------
0046                       ; Save all lines in editor buffer?
0047                       ;-------------------------------------------------------
0048 6C7C 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     6C7E A50E     
     6C80 2022     
0049 6C82 130B  14         jeq   edkey.action.cmdb.save.all
0050                                                   ; Yes, so save all lines in editor buffer
0051                       ;-------------------------------------------------------
0052                       ; Only save code block M1-M2
0053                       ;-------------------------------------------------------
0054 6C84 C820  54         mov   @edb.block.m1,@parm2  ; \ First line to save (base 0)
     6C86 A50C     
     6C88 A008     
0055 6C8A 0620  34         dec   @parm2                ; /
     6C8C A008     
0056               
0057 6C8E C820  54         mov   @edb.block.m2,@parm3  ; Last line to save (base 0) + 1
     6C90 A50E     
     6C92 A00A     
0058               
0059 6C94 0204  20         li    tmp0,id.file.saveblock
     6C96 0005     
0060 6C98 1007  14         jmp   edkey.action.cmdb.save.file
0061                       ;-------------------------------------------------------
0062                       ; Save all lines in editor buffer
0063                       ;-------------------------------------------------------
0064               edkey.action.cmdb.save.all:
0065 6C9A 04E0  34         clr   @parm2                ; First line to save
     6C9C A008     
0066 6C9E C820  54         mov   @edb.lines,@parm3     ; Last line to save
     6CA0 A504     
     6CA2 A00A     
0067               
0068 6CA4 0204  20         li    tmp0,id.file.savefile
     6CA6 0004     
0069                       ;-------------------------------------------------------
0070                       ; Save file
0071                       ;-------------------------------------------------------
0072               edkey.action.cmdb.save.file:
0073 6CA8 C804  38         mov   tmp0,@parm4           ; Set work mode
     6CAA A00C     
0074               
0075 6CAC 06A0  32         bl    @fm.savefile          ; Save DV80 file
     6CAE 798C     
0076                                                   ; \ i  parm1 = Pointer to length-prefixed
0077                                                   ; |            device/filename string
0078                                                   ; | i  parm2 = First line to save (base 0)
0079                                                   ; | i  parm3 = Last line to save  (base 0)
0080                                                   ; | i  parm4 = Work mode
0081                                                   ; /
0082                       ;-------------------------------------------------------
0083                       ; Exit
0084                       ;-------------------------------------------------------
0085               edkey.action.cmdb.save.exit:
0086 6CB0 C839  50         mov   *stack+,@parm1        ; Pop top row
     6CB2 A006     
0087 6CB4 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0088 6CB6 0460  28         b     @edkey.goto.fb.toprow ; \ Position cursor and exit
     6CB8 64B0     
0089                                                   ; / i  @parm1 = Line in editor buffer
                   < stevie_b1.asm.33260
0099                       copy  "edkey.cmdb.file.print.asm"   ; Print file
     **** ****     > edkey.cmdb.file.print.asm
0001               * FILE......: edkey.cmdb.fíle.print.asm
0002               * Purpose...: File related actions in command buffer pane.
0003               
0004               *---------------------------------------------------------------
0005               * Print file
0006               *---------------------------------------------------------------
0007               edkey.action.cmdb.print:
0008 6CBA 0649  14         dect  stack
0009 6CBC C644  30         mov   tmp0,*stack           ; Push tmp0
0010 6CBE 0649  14         dect  stack
0011 6CC0 C660  46         mov   @fb.topline,*stack    ; Push line number of fb top row
     6CC2 A304     
0012                       ;-------------------------------------------------------
0013                       ; Print file
0014                       ;-------------------------------------------------------
0015 6CC4 06A0  32         bl    @pane.cmdb.hide       ; Hide CMDB pane
     6CC6 7A90     
0016               
0017 6CC8 06A0  32         bl    @cmdb.cmd.getlength   ; Get length of current command
     6CCA 7AB8     
0018 6CCC C120  34         mov   @outparm1,tmp0        ; Length == 0 ?
     6CCE A016     
0019 6CD0 1607  14         jne   !                     ; No, prepare for print
0020                       ;-------------------------------------------------------
0021                       ; No filename specified
0022                       ;-------------------------------------------------------
0023 6CD2 0204  20         li    tmp0,txt.io.nofile    ; \
     6CD4 3A2C     
0024 6CD6 C804  38         mov   tmp0,@parm1           ; / Error message
     6CD8 A006     
0025               
0026 6CDA 06A0  32         bl    @error.display        ; Show error message
     6CDC 7A72     
0027                                                   ; \ i  @parm1 = Pointer to error message
0028                                                   ; /
0029               
0030 6CDE 1026  14         jmp   edkey.action.cmdb.print.exit
0031                       ;-------------------------------------------------------
0032                       ; Get filename
0033                       ;-------------------------------------------------------
0034 6CE0 0A84  56 !       sla   tmp0,8               ; LSB to MSB
0035 6CE2 D804  38         movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string
     6CE4 A72A     
0036               
0037 6CE6 06A0  32         bl    @cpym2m
     6CE8 24EE     
0038 6CEA A72A                   data cmdb.cmdlen,heap.top,80
     6CEC F000     
     6CEE 0050     
0039                                                   ; Copy filename from command line to buffer
0040                       ;-------------------------------------------------------
0041                       ; Pass filename as parm1
0042                       ;-------------------------------------------------------
0043 6CF0 0204  20         li    tmp0,heap.top         ; 1st line in heap
     6CF2 F000     
0044 6CF4 C804  38         mov   tmp0,@parm1
     6CF6 A006     
0045                       ;-------------------------------------------------------
0046                       ; Print all lines in editor buffer?
0047                       ;-------------------------------------------------------
0048 6CF8 8820  54         c     @edb.block.m2,@w$ffff ; Marker M2 unset?
     6CFA A50E     
     6CFC 2022     
0049 6CFE 130B  14         jeq   edkey.action.cmdb.print.all
0050                                                   ; Yes, so print all lines in editor buffer
0051                       ;-------------------------------------------------------
0052                       ; Only print code block M1-M2
0053                       ;-------------------------------------------------------
0054 6D00 C820  54         mov   @edb.block.m1,@parm2  ; \ First line to save (base 0)
     6D02 A50C     
     6D04 A008     
0055 6D06 0620  34         dec   @parm2                ; /
     6D08 A008     
0056               
0057 6D0A C820  54         mov   @edb.block.m2,@parm3  ; Last line to save (base 0) + 1
     6D0C A50E     
     6D0E A00A     
0058               
0059 6D10 0204  20         li    tmp0,id.file.printblock
     6D12 0008     
0060 6D14 1007  14         jmp   edkey.action.cmdb.print.file
0061                       ;-------------------------------------------------------
0062                       ; Print all lines in editor buffer
0063                       ;-------------------------------------------------------
0064               edkey.action.cmdb.print.all:
0065 6D16 04E0  34         clr   @parm2                ; First line to save
     6D18 A008     
0066 6D1A C820  54         mov   @edb.lines,@parm3     ; Last line to save
     6D1C A504     
     6D1E A00A     
0067               
0068 6D20 0204  20         li    tmp0,id.file.printfile
     6D22 0007     
0069                       ;-------------------------------------------------------
0070                       ; Print file
0071                       ;-------------------------------------------------------
0072               edkey.action.cmdb.Print.file:
0073 6D24 C804  38         mov   tmp0,@parm4           ; Set work mode
     6D26 A00C     
0074               
0075 6D28 06A0  32         bl    @fm.savefile          ; Save DV80 file
     6D2A 798C     
0076                                                   ; \ i  parm1 = Pointer to length-prefixed
0077                                                   ; |            device/filename string
0078                                                   ; | i  parm2 = First line to save (base 0)
0079                                                   ; | i  parm3 = Last line to save  (base 0)
0080                                                   ; | i  parm4 = Work mode
0081                                                   ; /
0082                       ;-------------------------------------------------------
0083                       ; Exit
0084                       ;-------------------------------------------------------
0085               edkey.action.cmdb.print.exit:
0086 6D2C C839  50         mov   *stack+,@parm1        ; Pop top row
     6D2E A006     
0087 6D30 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0088 6D32 0460  28         b     @edkey.goto.fb.toprow ; \ Position cursor and exit
     6D34 64B0     
0089                                                   ; / i  @parm1 = Line in editor buffer
                   < stevie_b1.asm.33260
0100                       copy  "edkey.cmdb.dialog.asm"       ; Dialog specific actions
     **** ****     > edkey.cmdb.dialog.asm
0001               * FILE......: edkey.cmdb.dialog.asm
0002               * Purpose...: Dialog specific actions in command buffer pane.
0003               
0004               ***************************************************************
0005               * edkey.action.cmdb.proceed
0006               * Proceed with action
0007               ***************************************************************
0008               * b   @edkey.action.cmdb.proceed
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @cmdb.action.ptr = Pointer to keyboard action to perform
0012               *--------------------------------------------------------------
0013               * Register usage
0014               * none
0015               ********|*****|*********************|**************************
0016               edkey.action.cmdb.proceed:
0017                       ;-------------------------------------------------------
0018                       ; Intialisation
0019                       ;-------------------------------------------------------
0020 6D36 04E0  34         clr   @edb.dirty            ; Clear editor buffer dirty flag
     6D38 A506     
0021 6D3A 06A0  32         bl    @pane.cursor.blink    ; Show cursor again
     6D3C 7536     
0022 6D3E 06A0  32         bl    @cmdb.cmd.clear       ; Clear current command
     6D40 7AAE     
0023 6D42 C120  34         mov   @cmdb.action.ptr,tmp0 ; Get pointer to keyboard action
     6D44 A728     
0024                       ;-------------------------------------------------------
0025                       ; Asserts
0026                       ;-------------------------------------------------------
0027 6D46 0284  22         ci    tmp0,>2000
     6D48 2000     
0028 6D4A 1104  14         jlt   !                     ; Invalid address, crash
0029               
0030 6D4C 0284  22         ci    tmp0,>7fff
     6D4E 7FFF     
0031 6D50 1501  14         jgt   !                     ; Invalid address, crash
0032                       ;------------------------------------------------------
0033                       ; All Asserts passed
0034                       ;------------------------------------------------------
0035 6D52 0454  20         b     *tmp0                 ; Execute action
0036                       ;------------------------------------------------------
0037                       ; Asserts failed
0038                       ;------------------------------------------------------
0039 6D54 C80B  38 !       mov   r11,@>ffce            ; \ Save caller address
     6D56 FFCE     
0040 6D58 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     6D5A 2026     
0041                       ;-------------------------------------------------------
0042                       ; Exit
0043                       ;-------------------------------------------------------
0044               edkey.action.cmdb.proceed.exit:
0045 6D5C 0460  28         b     @edkey.keyscan.hook.debounce
     6D5E 6156     
0046                                                   ; Back to editor main
0047               
0048               
0049               
0050               
0051               ***************************************************************
0052               * edkey.action.cmdb.fastmode.toggle
0053               * Toggle fastmode on/off
0054               ***************************************************************
0055               * b   @edkey.action.cmdb.fastmode.toggle
0056               *--------------------------------------------------------------
0057               * INPUT
0058               * none
0059               *--------------------------------------------------------------
0060               * Register usage
0061               * none
0062               ********|*****|*********************|**************************
0063               edkey.action.cmdb.fastmode.toggle:
0064 6D60 06A0  32        bl    @fm.fastmode           ; Toggle fast mode.
     6D62 7AEA     
0065 6D64 0720  34        seto  @cmdb.dirty            ; Command buffer dirty (text changed!)
     6D66 A718     
0066 6D68 0460  28        b     @edkey.keyscan.hook.debounce
     6D6A 6156     
0067                                                   ; Back to editor main
0068               
0069               
0070               ***************************************************************
0071               * edkey.action.cmdb.am.toggle
0072               * Toggle 'AutoMode' on/off
0073               ***************************************************************
0074               * b   @edkey.action.cmdb.am.toggle
0075               *--------------------------------------------------------------
0076               * INPUT
0077               * none
0078               *--------------------------------------------------------------
0079               * Register usage
0080               * none
0081               ********|*****|*********************|**************************
0082               edkey.action.cmdb.am.toggle:
0083 6D6C 06A0  32        bl    @tibasic.am.toggle     ; Toggle AutoMode
     6D6E 7AE0     
0084 6D70 0720  34        seto  @cmdb.dirty            ; Command buffer dirty (text changed!)
     6D72 A718     
0085 6D74 0460  28        b     @edkey.keyscan.hook.debounce
     6D76 6156     
0086                                                   ; Back to editor main
0087               
0088               
0089               
0090               ***************************************************************
0091               * edkey.action.cmdb.preset
0092               * Set command value to preset
0093               ***************************************************************
0094               * b   @edkey.action.cmdb.preset
0095               *--------------------------------------------------------------
0096               * INPUT
0097               * none
0098               *--------------------------------------------------------------
0099               * Register usage
0100               * none
0101               ********|*****|*********************|**************************
0102               edkey.action.cmdb.preset:
0103 6D78 06A0  32        bl    @cmdb.cmd.preset       ; Set preset
     6D7A 7AC2     
0104 6D7C 0460  28        b     @edkey.keyscan.hook.debounce
     6D7E 6156     
0105                                                   ; Back to editor main
0106               
0107               
0108               
0109               ***************************************************************
0110               * dialog.close
0111               * Close dialog "About"
0112               ***************************************************************
0113               * b   @edkey.action.cmdb.close.about
0114               *--------------------------------------------------------------
0115               * OUTPUT
0116               * none
0117               *--------------------------------------------------------------
0118               * Register usage
0119               * none
0120               ********|*****|*********************|**************************
0121               edkey.action.cmdb.close.about:
0122 6D80 04E0  34         clr   @cmdb.dialog.var      ; Reset to Help page 1
     6D82 A71C     
0123                       ;------------------------------------------------------
0124                       ; Erase header line
0125                       ;------------------------------------------------------
0126 6D84 06A0  32         bl    @hchar
     6D86 27E6     
0127 6D88 0000                   byte 0,0,32,80*2
     6D8A 20A0     
0128 6D8C FFFF                   data EOL
0129               
0130 6D8E 06A0  32         bl    @cmdb.dialog.close    ; Close dialog
     6D90 6D9E     
0131                       ;-------------------------------------------------------
0132                       ; Exit
0133                       ;-------------------------------------------------------
0134 6D92 0460  28         b     @edkey.keyscan.hook.debounce
     6D94 6156     
0135                                                   ; Back to editor main
0136               
0137               
0138               
0139               ***************************************************************
0140               * edkey.action.cmdb.close.dialog
0141               * Close dialog
0142               ***************************************************************
0143               * b   @edkey.action.cmdb.close.dialog
0144               *--------------------------------------------------------------
0145               * OUTPUT
0146               * none
0147               *--------------------------------------------------------------
0148               * Register usage
0149               * none
0150               ********|*****|*********************|**************************
0151               edkey.action.cmdb.close.dialog:
0152 6D96 06A0  32         bl    @cmdb.dialog.close    ; Close dialog
     6D98 6D9E     
0153                       ;-------------------------------------------------------
0154                       ; Exit
0155                       ;-------------------------------------------------------
0156               edkey.action.cmdb.close.dialog.exit:
0157 6D9A 0460  28         b     @edkey.keyscan.hook.debounce
     6D9C 6156     
0158                                                   ; Back to editor main
                   < stevie_b1.asm.33260
0101                       copy  "cmdb.dialog.close.asm"       ; Close dialog
     **** ****     > cmdb.dialog.close.asm
0001               * FILE......: cmdb.dialog.close
0002               * Purpose...: Close dialog
0003               
0004               ***************************************************************
0005               * cmdb.dialog.close
0006               * Close dialog
0007               ***************************************************************
0008               * bl   @cmdb.dialog.close
0009               *--------------------------------------------------------------
0010               * OUTPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * Register usage
0014               * none
0015               ********|*****|*********************|**************************
0016               cmdb.dialog.close:
0017 6D9E 0649  14         dect  stack
0018 6DA0 C64B  30         mov   r11,*stack            ; Save return address
0019                       ;------------------------------------------------------
0020                       ; Close dialog
0021                       ;------------------------------------------------------
0022 6DA2 04E0  34         clr   @cmdb.dialog          ; Reset dialog ID
     6DA4 A71A     
0023 6DA6 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     6DA8 7536     
0024 6DAA 06A0  32         bl    @pane.cmdb.hide       ; Hide command buffer pane
     6DAC 7A90     
0025 6DAE 0720  34         seto  @fb.status.dirty      ; Trigger status lines update
     6DB0 A31A     
0026                       ;-------------------------------------------------------
0027                       ; Exit
0028                       ;-------------------------------------------------------
0029               cmdb.dialog.close.exit:
0030 6DB2 C2F9  30         mov   *stack+,r11           ; Pop r11
0031 6DB4 045B  20         b     *r11                  ; Return
                   < stevie_b1.asm.33260
0102                       ;-----------------------------------------------------------------------
0103                       ; Logic for Framebuffer (1)
0104                       ;-----------------------------------------------------------------------
0105                       copy  "fb.cursor.up.asm"            ; Cursor up
     **** ****     > fb.cursor.up.asm
0001               * FILE......: fb.cursor.up.asm
0002               * Purpose...: Move the cursor up 1 line
0003               
0004               
0005               ***************************************************************
0006               * fb.cursor.up
0007               * Logic for moving cursor up 1 line
0008               ***************************************************************
0009               * bl @fb.cursor.up
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
0020               fb.cursor.up
0021 6DB6 0649  14         dect  stack
0022 6DB8 C64B  30         mov   r11,*stack            ; Save return address
0023                       ;-------------------------------------------------------
0024                       ; Crunch current line if dirty
0025                       ;-------------------------------------------------------
0026 6DBA 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6DBC A31A     
0027 6DBE 8820  54         c     @fb.row.dirty,@w$ffff
     6DC0 A30A     
     6DC2 2022     
0028 6DC4 1604  14         jne   fb.cursor.up.cursor
0029 6DC6 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6DC8 704A     
0030 6DCA 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6DCC A30A     
0031                       ;-------------------------------------------------------
0032                       ; Move cursor
0033                       ;-------------------------------------------------------
0034               fb.cursor.up.cursor:
0035 6DCE C120  34         mov   @fb.row,tmp0
     6DD0 A306     
0036 6DD2 150B  14         jgt   fb.cursor.up.cursor_up
0037                                                   ; Move cursor up if fb.row > 0
0038 6DD4 C120  34         mov   @fb.topline,tmp0      ; Do we need to scroll?
     6DD6 A304     
0039 6DD8 130C  14         jeq   fb.cursor.up.set_cursorx
0040                                                   ; At top, only position cursor X
0041                       ;-------------------------------------------------------
0042                       ; Scroll 1 line
0043                       ;-------------------------------------------------------
0044 6DDA 0604  14         dec   tmp0                  ; fb.topline--
0045 6DDC C804  38         mov   tmp0,@parm1           ; Scroll one line up
     6DDE A006     
0046               
0047 6DE0 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     6DE2 6F98     
0048                                                   ; | i  @parm1 = Line to start with
0049                                                   ; /             (becomes @fb.topline)
0050               
0051 6DE4 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     6DE6 A312     
0052 6DE8 1004  14         jmp   fb.cursor.up.set_cursorx
0053                       ;-------------------------------------------------------
0054                       ; Move cursor up
0055                       ;-------------------------------------------------------
0056               fb.cursor.up.cursor_up:
0057 6DEA 0620  34         dec   @fb.row               ; Row-- in screen buffer
     6DEC A306     
0058 6DEE 06A0  32         bl    @up                   ; Row-- VDP cursor
     6DF0 26E8     
0059                       ;-------------------------------------------------------
0060                       ; Check line length and position cursor
0061                       ;-------------------------------------------------------
0062               fb.cursor.up.set_cursorx:
0063 6DF2 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     6DF4 35C6     
0064                                                   ; | i  @fb.row        = Row in frame buffer
0065                                                   ; / o  @fb.row.length = Length of row
0066               
0067 6DF6 8820  54         c     @fb.column,@fb.row.length
     6DF8 A30C     
     6DFA A308     
0068 6DFC 1207  14         jle   fb.cursor.up.exit
0069                       ;-------------------------------------------------------
0070                       ; Adjust cursor column position
0071                       ;-------------------------------------------------------
0072 6DFE C820  54         mov   @fb.row.length,@fb.column
     6E00 A308     
     6E02 A30C     
0073 6E04 C120  34         mov   @fb.column,tmp0
     6E06 A30C     
0074 6E08 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6E0A 26F2     
0075                       ;-------------------------------------------------------
0076                       ; Exit
0077                       ;-------------------------------------------------------
0078               fb.cursor.up.exit:
0079 6E0C 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6E0E 3094     
0080 6E10 C2F9  30         mov   *stack+,r11           ; Pop r11
0081 6E12 045B  20         b     *r11                  ; Return
                   < stevie_b1.asm.33260
0106                       copy  "fb.cursor.down.asm"          ; Cursor down
     **** ****     > fb.cursor.down.asm
0001               * FILE......: fb.cursor.down.asm
0002               * Purpose...: Move the cursor down 1 line
0003               
0004               
0005               ***************************************************************
0006               * fb.cursor.down
0007               * Logic for moving cursor down 1 line
0008               ***************************************************************
0009               * bl @fb.cursor.down
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
0020               fb.cursor.down:
0021 6E14 0649  14         dect  stack
0022 6E16 C64B  30         mov   r11,*stack            ; Save return address
0023                       ;------------------------------------------------------
0024                       ; Last line?
0025                       ;------------------------------------------------------
0026 6E18 8820  54         c     @fb.row,@edb.lines    ; Last line in editor buffer ?
     6E1A A306     
     6E1C A504     
0027 6E1E 1332  14         jeq   fb.cursor.down.exit
0028                                                   ; Yes, skip further processing
0029 6E20 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6E22 A31A     
0030                       ;-------------------------------------------------------
0031                       ; Crunch current row if dirty
0032                       ;-------------------------------------------------------
0033 6E24 8820  54         c     @fb.row.dirty,@w$ffff
     6E26 A30A     
     6E28 2022     
0034 6E2A 1604  14         jne   fb.cursor.down.move
0035 6E2C 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6E2E 704A     
0036 6E30 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6E32 A30A     
0037                       ;-------------------------------------------------------
0038                       ; Move cursor
0039                       ;-------------------------------------------------------
0040               fb.cursor.down.move:
0041                       ;-------------------------------------------------------
0042                       ; EOF reached?
0043                       ;-------------------------------------------------------
0044 6E34 C120  34         mov   @fb.topline,tmp0
     6E36 A304     
0045 6E38 A120  34         a     @fb.row,tmp0
     6E3A A306     
0046 6E3C 8120  34         c     @edb.lines,tmp0       ; fb.topline + fb.row = edb.lines ?
     6E3E A504     
0047 6E40 1314  14         jeq   fb.cursor.down.set_cursorx
0048                                                   ; Yes, only position cursor X
0049                       ;-------------------------------------------------------
0050                       ; Check if scrolling required
0051                       ;-------------------------------------------------------
0052 6E42 C120  34         mov   @fb.scrrows,tmp0
     6E44 A31C     
0053 6E46 0604  14         dec   tmp0
0054 6E48 8120  34         c     @fb.row,tmp0
     6E4A A306     
0055 6E4C 110A  14         jlt   fb.cursor.down.cursor
0056                       ;-------------------------------------------------------
0057                       ; Scroll 1 line
0058                       ;-------------------------------------------------------
0059 6E4E C820  54         mov   @fb.topline,@parm1
     6E50 A304     
     6E52 A006     
0060 6E54 05A0  34         inc   @parm1
     6E56 A006     
0061               
0062 6E58 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     6E5A 6F98     
0063                                                   ; | i  @parm1 = Line to start with
0064                                                   ; /             (becomes @fb.topline)
0065               
0066 6E5C 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     6E5E A312     
0067 6E60 1004  14         jmp   fb.cursor.down.set_cursorx
0068                       ;-------------------------------------------------------
0069                       ; Move cursor down a row, there are still rows left
0070                       ;-------------------------------------------------------
0071               fb.cursor.down.cursor:
0072 6E62 05A0  34         inc   @fb.row               ; Row++ in screen buffer
     6E64 A306     
0073 6E66 06A0  32         bl    @down                 ; Row++ VDP cursor
     6E68 26E0     
0074                       ;-------------------------------------------------------
0075                       ; Check line length and position cursor
0076                       ;-------------------------------------------------------
0077               fb.cursor.down.set_cursorx:
0078 6E6A 06A0  32         bl    @edb.line.getlength2  ; \ Get length current line
     6E6C 35C6     
0079                                                   ; | i  @fb.row        = Row in frame buffer
0080                                                   ; / o  @fb.row.length = Length of row
0081               
0082 6E6E 8820  54         c     @fb.column,@fb.row.length
     6E70 A30C     
     6E72 A308     
0083 6E74 1207  14         jle   fb.cursor.down.exit
0084                                                   ; Exit
0085                       ;-------------------------------------------------------
0086                       ; Adjust cursor column position
0087                       ;-------------------------------------------------------
0088 6E76 C820  54         mov   @fb.row.length,@fb.column
     6E78 A308     
     6E7A A30C     
0089 6E7C C120  34         mov   @fb.column,tmp0
     6E7E A30C     
0090 6E80 06A0  32         bl    @xsetx                ; Set VDP cursor X
     6E82 26F2     
0091                       ;-------------------------------------------------------
0092                       ; Exit
0093                       ;-------------------------------------------------------
0094               fb.cursor.down.exit:
0095 6E84 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6E86 3094     
0096 6E88 C2F9  30         mov   *stack+,r11           ; Pop r11
0097 6E8A 045B  20         b     *r11                  ; Return
                   < stevie_b1.asm.33260
0107                       copy  "fb.cursor.home.asm"          ; Cursor home
     **** ****     > fb.cursor.home.asm
0001               * FILE......: fb.cursor.home.asm
0002               * Purpose...: Move the cursor home
0003               
0004               
0005               ***************************************************************
0006               * fb.cursor.home
0007               * Logic for moving cursor home
0008               ***************************************************************
0009               * bl @fb.cursor.home
0010               *--------------------------------------------------------------
0011               * INPUT
0012               * none
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0
0019               ********|*****|*********************|**************************
0020               fb.cursor.home:
0021 6E8C 0649  14         dect  stack
0022 6E8E C64B  30         mov   r11,*stack            ; Save return address
0023 6E90 0649  14         dect  stack
0024 6E92 C644  30         mov   tmp0,*stack           ; Push tmp0
0025                       ;------------------------------------------------------
0026                       ; Cursor home
0027                       ;------------------------------------------------------
0028 6E94 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6E96 A31A     
0029 6E98 C120  34         mov   @wyx,tmp0
     6E9A 832A     
0030 6E9C 0244  22         andi  tmp0,>ff00            ; Reset cursor X position to 0
     6E9E FF00     
0031 6EA0 C804  38         mov   tmp0,@wyx             ; VDP cursor column=0
     6EA2 832A     
0032 6EA4 04E0  34         clr   @fb.column
     6EA6 A30C     
0033 6EA8 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6EAA 3094     
0034 6EAC 0720  34         seto  @fb.status.dirty      ; Trigger refresh of status lines
     6EAE A31A     
0035                       ;-------------------------------------------------------
0036                       ; Exit
0037                       ;-------------------------------------------------------
0038               fb.cursor.home.exit:
0039 6EB0 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0040 6EB2 C2F9  30         mov   *stack+,r11           ; Pop r11
0041 6EB4 045B  20         b     *r11                  ; Return
                   < stevie_b1.asm.33260
0108                       copy  "fb.insert.line.asm"          ; Insert new line
     **** ****     > fb.insert.line.asm
0001               * FILE......: fb.insert.line.asm
0002               * Purpose...: Insert a new line
0003               
0004               ***************************************************************
0005               * fb.insert.line.asm
0006               * Insert a new line
0007               ***************************************************************
0008               * bl @fb.insert.line
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @parm1 = Insert line on current line or on following line.
0012               *          @parm1  = 0  -> current line
0013               *          @parm1 <> 0  -> following line
0014               *--------------------------------------------------------------
0015               * OUTPUT
0016               * none
0017               *--------------------------------------------------------------
0018               * Register usage
0019               * tmp0, tmp1
0020               ********|*****|*********************|**************************
0021               fb.insert.line:
0022 6EB6 0649  14         dect  stack
0023 6EB8 C64B  30         mov   r11,*stack            ; Save return address
0024 6EBA 0649  14         dect  stack
0025 6EBC C644  30         mov   tmp0,*stack           ; Push tmp0
0026 6EBE 0649  14         dect  stack
0027 6EC0 C645  30         mov   tmp1,*stack           ; Push tmp1
0028                       ;-------------------------------------------------------
0029                       ; Initialisation
0030                       ;-------------------------------------------------------
0031 6EC2 0720  34         seto  @edb.dirty            ; Editor buffer dirty (text changed!)
     6EC4 A506     
0032 6EC6 04C5  14         clr   tmp1                  ; Offset current line
0033 6EC8 C120  34         mov   @parm1,tmp0           ; Insert on current line or following line?
     6ECA A006     
0034 6ECC 1301  14         jeq   !                     ; Current line
0035 6ECE 0585  14         inc   tmp1                  ; Following line
0036                       ;-------------------------------------------------------
0037                       ; Crunch current line if dirty
0038                       ;-------------------------------------------------------
0039 6ED0 8820  54 !       c     @fb.row.dirty,@w$ffff
     6ED2 A30A     
     6ED4 2022     
0040 6ED6 1604  14         jne   fb.insert.line.insert
0041 6ED8 06A0  32         bl    @edb.line.pack.fb     ; Copy line to editor buffer
     6EDA 704A     
0042 6EDC 04E0  34         clr   @fb.row.dirty         ; Current row no longer dirty
     6EDE A30A     
0043                       ;-------------------------------------------------------
0044                       ; Insert entry in index
0045                       ;-------------------------------------------------------
0046               fb.insert.line.insert:
0047 6EE0 06A0  32         bl    @fb.calc_pointer      ; Calculate position in frame buffer
     6EE2 3094     
0048 6EE4 C820  54         mov   @fb.topline,@parm1
     6EE6 A304     
     6EE8 A006     
0049 6EEA A820  54         a     @fb.row,@parm1        ; Line number to insert
     6EEC A306     
     6EEE A006     
0050 6EF0 A805  38         a     tmp1,@parm1           ; Add optional offset (for following line)
     6EF2 A006     
0051 6EF4 C820  54         mov   @edb.lines,@parm2     ; Last line to reorganize
     6EF6 A504     
     6EF8 A008     
0052               
0053 6EFA 06A0  32         bl    @idx.entry.insert     ; Reorganize index
     6EFC 34E0     
0054                                                   ; \ i  parm1 = Line for insert
0055                                                   ; / i  parm2 = Last line to reorg
0056               
0057 6EFE 05A0  34         inc   @edb.lines            ; One line added to editor buffer
     6F00 A504     
0058 6F02 04E0  34         clr   @fb.row.length        ; Current row length = 0
     6F04 A308     
0059                       ;-------------------------------------------------------
0060                       ; Check/Adjust marker M1
0061                       ;-------------------------------------------------------
0062               fb.insert.line.m1:
0063 6F06 8820  54         c     @edb.block.m1,@w$ffff ; Marker M1 unset?
     6F08 A50C     
     6F0A 2022     
0064 6F0C 1308  14         jeq   fb.insert.line.m2
0065                                                   ; Yes, skip to M2 check
0066               
0067 6F0E 8820  54         c     @parm1,@edb.block.m1
     6F10 A006     
     6F12 A50C     
0068 6F14 1504  14         jgt   fb.insert.line.m2
0069 6F16 05A0  34         inc   @edb.block.m1         ; M1++
     6F18 A50C     
0070 6F1A 0720  34         seto  @fb.colorize          ; Set colorize flag
     6F1C A312     
0071                       ;-------------------------------------------------------
0072                       ; Check/Adjust marker M2
0073                       ;-------------------------------------------------------
0074               fb.insert.line.m2:
0075 6F1E 8820  54         c     @edb.block.m2,@w$ffff ; Marker M1 unset?
     6F20 A50E     
     6F22 2022     
0076 6F24 1308  14         jeq   fb.insert.line.refresh
0077                                                   ; Yes, skip to refresh frame buffer
0078               
0079 6F26 8820  54         c     @parm1,@edb.block.m2
     6F28 A006     
     6F2A A50E     
0080 6F2C 1504  14         jgt   fb.insert.line.refresh
0081 6F2E 05A0  34         inc   @edb.block.m2         ; M2++
     6F30 A50E     
0082 6F32 0720  34         seto  @fb.colorize          ; Set colorize flag
     6F34 A312     
0083                       ;-------------------------------------------------------
0084                       ; Refresh frame buffer and physical screen
0085                       ;-------------------------------------------------------
0086               fb.insert.line.refresh:
0087 6F36 C820  54         mov   @fb.topline,@parm1
     6F38 A304     
     6F3A A006     
0088               
0089 6F3C 06A0  32         bl    @fb.refresh           ; \ Refresh frame buffer
     6F3E 6F98     
0090                                                   ; | i  @parm1 = Line to start with
0091                                                   ; /             (becomes @fb.topline)
0092               
0093 6F40 0720  34         seto  @fb.dirty             ; Trigger screen refresh
     6F42 A318     
0094 6F44 06A0  32         bl    @fb.cursor.home       ; Move cursor home
     6F46 6E8C     
0095                       ;-------------------------------------------------------
0096                       ; Exit
0097                       ;-------------------------------------------------------
0098               fb.insert.line.exit:
0099 6F48 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0100 6F4A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0101 6F4C C2F9  30         mov   *stack+,r11           ; Pop r11
0102 6F4E 045B  20         b     *r11                  ; Return
                   < stevie_b1.asm.33260
0109                       copy  "fb.get.firstnonblank.asm"    ; Get column of first non-blank char
     **** ****     > fb.get.firstnonblank.asm
0001               * FILE......: fb.get.firstnonblank.asm
0002               * Purpose...: Get column of first non-blank character
0003               
0004               ***************************************************************
0005               * fb.get.firstnonblank
0006               * Get column of first non-blank character in specified line
0007               ***************************************************************
0008               * bl @fb.get.firstnonblank
0009               *--------------------------------------------------------------
0010               * OUTPUT
0011               * @outparm1 = Column containing first non-blank character
0012               * @outparm2 = Character
0013               ********|*****|*********************|**************************
0014               fb.get.firstnonblank:
0015 6F50 0649  14         dect  stack
0016 6F52 C64B  30         mov   r11,*stack            ; Save return address
0017                       ;------------------------------------------------------
0018                       ; Prepare for scanning
0019                       ;------------------------------------------------------
0020 6F54 04E0  34         clr   @fb.column
     6F56 A30C     
0021 6F58 06A0  32         bl    @fb.calc_pointer
     6F5A 3094     
0022 6F5C 06A0  32         bl    @edb.line.getlength2  ; Get length current line
     6F5E 35C6     
0023 6F60 C1A0  34         mov   @fb.row.length,tmp2   ; Set loop counter
     6F62 A308     
0024 6F64 1313  14         jeq   fb.get.firstnonblank.nomatch
0025                                                   ; Exit if empty line
0026 6F66 C120  34         mov   @fb.current,tmp0      ; Pointer to current char
     6F68 A302     
0027 6F6A 04C5  14         clr   tmp1
0028                       ;------------------------------------------------------
0029                       ; Scan line for non-blank character
0030                       ;------------------------------------------------------
0031               fb.get.firstnonblank.loop:
0032 6F6C D174  28         movb  *tmp0+,tmp1           ; Get character
0033 6F6E 130E  14         jeq   fb.get.firstnonblank.nomatch
0034                                                   ; Exit if empty line
0035 6F70 0285  22         ci    tmp1,>2000            ; Whitespace?
     6F72 2000     
0036 6F74 1503  14         jgt   fb.get.firstnonblank.match
0037 6F76 0606  14         dec   tmp2                  ; Counter--
0038 6F78 16F9  14         jne   fb.get.firstnonblank.loop
0039 6F7A 1008  14         jmp   fb.get.firstnonblank.nomatch
0040                       ;------------------------------------------------------
0041                       ; Non-blank character found
0042                       ;------------------------------------------------------
0043               fb.get.firstnonblank.match:
0044 6F7C 6120  34         s     @fb.current,tmp0      ; Calculate column
     6F7E A302     
0045 6F80 0604  14         dec   tmp0
0046 6F82 C804  38         mov   tmp0,@outparm1        ; Save column
     6F84 A016     
0047 6F86 D805  38         movb  tmp1,@outparm2        ; Save character
     6F88 A018     
0048 6F8A 1004  14         jmp   fb.get.firstnonblank.exit
0049                       ;------------------------------------------------------
0050                       ; No non-blank character found
0051                       ;------------------------------------------------------
0052               fb.get.firstnonblank.nomatch:
0053 6F8C 04E0  34         clr   @outparm1             ; X=0
     6F8E A016     
0054 6F90 04E0  34         clr   @outparm2             ; Null
     6F92 A018     
0055                       ;------------------------------------------------------
0056                       ; Exit
0057                       ;------------------------------------------------------
0058               fb.get.firstnonblank.exit:
0059 6F94 C2F9  30         mov   *stack+,r11           ; Pop r11
0060 6F96 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.33260
0110                       copy  "fb.refresh.asm"              ; Refresh framebuffer
     **** ****     > fb.refresh.asm
0001               * FILE......: fb.refresh.asm
0002               * Purpose...: Refresh frame buffer with editor buffer content
0003               
0004               ***************************************************************
0005               * fb.refresh
0006               * Refresh frame buffer with editor buffer content
0007               ***************************************************************
0008               * bl @fb.refresh
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @parm1 = Line to start with (becomes @fb.topline)
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0,tmp1,tmp2
0018               ********|*****|*********************|**************************
0019               fb.refresh:
0020 6F98 0649  14         dect  stack
0021 6F9A C64B  30         mov   r11,*stack            ; Push return address
0022 6F9C 0649  14         dect  stack
0023 6F9E C644  30         mov   tmp0,*stack           ; Push tmp0
0024 6FA0 0649  14         dect  stack
0025 6FA2 C645  30         mov   tmp1,*stack           ; Push tmp1
0026 6FA4 0649  14         dect  stack
0027 6FA6 C646  30         mov   tmp2,*stack           ; Push tmp2
0028                       ;------------------------------------------------------
0029                       ; Setup starting position in index
0030                       ;------------------------------------------------------
0031 6FA8 C820  54         mov   @parm1,@fb.topline
     6FAA A006     
     6FAC A304     
0032 6FAE 04E0  34         clr   @parm2                ; Target row in frame buffer
     6FB0 A008     
0033                       ;------------------------------------------------------
0034                       ; Check if already at EOF
0035                       ;------------------------------------------------------
0036 6FB2 8820  54         c     @parm1,@edb.lines     ; EOF reached?
     6FB4 A006     
     6FB6 A504     
0037 6FB8 1312  14         jeq   fb.refresh.erase_eob  ; Yes, no need to unpack
0038                       ;------------------------------------------------------
0039                       ; Unpack line to frame buffer
0040                       ;------------------------------------------------------
0041               fb.refresh.unpack_line:
0042 6FBA C820  54         mov   @fb.vwco,@parm3       ; Set view window column offset
     6FBC A310     
     6FBE A00A     
0043               
0044 6FC0 06A0  32         bl    @edb.line.unpack.fb   ; Unpack line from editor buffer
     6FC2 7142     
0045                                                   ; \ i  parm1    = Line to unpack
0046                                                   ; | i  parm2    = Target row in frame buffer
0047                                                   ; | i  parm3    = Column offset
0048                                                   ; / o  outparm1 = Length of line
0049               
0050 6FC4 05A0  34         inc   @parm1                ; Next line in editor buffer
     6FC6 A006     
0051 6FC8 05A0  34         inc   @parm2                ; Next row in frame buffer
     6FCA A008     
0052                       ;------------------------------------------------------
0053                       ; Last row in editor buffer reached ?
0054                       ;------------------------------------------------------
0055 6FCC 8820  54         c     @parm1,@edb.lines     ; BOT reached?
     6FCE A006     
     6FD0 A504     
0056 6FD2 1305  14         jeq   fb.refresh.erase_eob  ; yes, erase until end of frame buffer
0057               
0058 6FD4 8820  54         c     @parm2,@fb.scrrows
     6FD6 A008     
     6FD8 A31C     
0059 6FDA 11EF  14         jlt   fb.refresh.unpack_line
0060                                                   ; No, unpack next line
0061 6FDC 1011  14         jmp   fb.refresh.exit       ; Yes, exit without erasing
0062                       ;------------------------------------------------------
0063                       ; Erase until end of frame buffer
0064                       ;------------------------------------------------------
0065               fb.refresh.erase_eob:
0066 6FDE C120  34         mov   @parm2,tmp0           ; Current row
     6FE0 A008     
0067 6FE2 C160  34         mov   @fb.scrrows,tmp1      ; Rows framebuffer
     6FE4 A31C     
0068 6FE6 6144  18         s     tmp0,tmp1             ; tmp1 = rows framebuffer - current row
0069 6FE8 3960  72         mpy   @fb.colsline,tmp1     ; tmp2 = cols per row * tmp1
     6FEA A30E     
0070               
0071 6FEC C186  18         mov   tmp2,tmp2             ; Already at end of frame buffer?
0072 6FEE 1308  14         jeq   fb.refresh.exit       ; Yes, so exit
0073               
0074 6FF0 3920  72         mpy   @fb.colsline,tmp0     ; cols per row * tmp0 (Result in tmp1!)
     6FF2 A30E     
0075 6FF4 A160  34         a     @fb.top.ptr,tmp1      ; Add framebuffer base
     6FF6 A300     
0076               
0077 6FF8 C105  18         mov   tmp1,tmp0             ; tmp0 = Memory start address
0078 6FFA 04C5  14         clr   tmp1                  ; Clear with >00 character
0079               
0080 6FFC 06A0  32         bl    @xfilm                ; \ Fill memory
     6FFE 2250     
0081                                                   ; | i  tmp0 = Memory start address
0082                                                   ; | i  tmp1 = Byte to fill
0083                                                   ; / i  tmp2 = Number of bytes to fill
0084                       ;------------------------------------------------------
0085                       ; Exit
0086                       ;------------------------------------------------------
0087               fb.refresh.exit:
0088 7000 0720  34         seto  @fb.dirty             ; Refresh screen
     7002 A318     
0089               
0090 7004 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0091 7006 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0092 7008 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0093 700A C2F9  30         mov   *stack+,r11           ; Pop r11
0094 700C 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.33260
0111                       copy  "fb.restore.asm"              ; Restore framebuffer to normal opr.
     **** ****     > fb.restore.asm
0001               * FILE......: fb.restore.asm
0002               * Purpose...: Restore frame buffer to normal operation
0003               
0004               ***************************************************************
0005               * fb.restore
0006               * Restore frame buffer to normal operation (e.g. after command
0007               * has completed)
0008               ***************************************************************
0009               *  bl   @fb.restore
0010               *--------------------------------------------------------------
0011               * INPUT
0012               * @parm1 = cursor YX position
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * NONE
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * NONE
0019               ********|*****|*********************|**************************
0020               fb.restore:
0021 700E 0649  14         dect  stack
0022 7010 C64B  30         mov   r11,*stack            ; Save return address
0023 7012 0649  14         dect  stack
0024 7014 C660  46         mov   @parm1,*stack         ; Push @parm1
     7016 A006     
0025                       ;------------------------------------------------------
0026                       ; Refresh framebuffer
0027                       ;------------------------------------------------------
0028 7018 C820  54         mov   @fb.topline,@parm1
     701A A304     
     701C A006     
0029 701E 06A0  32         bl    @fb.refresh           ; Refresh frame buffer content
     7020 6F98     
0030                                                   ; \ @i  parm1 = Line to start with
0031                       ;------------------------------------------------------
0032                       ; Color marked lines
0033                       ;------------------------------------------------------
0034 7022 0720  34         seto  @parm1                ; Skip Asserts
     7024 A006     
0035 7026 06A0  32         bl    @fb.colorlines        ; Colorize frame buffer content
     7028 7B2A     
0036                                                   ; \ i  @parm1 = Force refresh if >ffff
0037                                                   ; /
0038                       ;------------------------------------------------------
0039                       ; Color status lines
0040                       ;------------------------------------------------------
0041 702A C820  54         mov   @tv.color,@parm1      ; Set normal color
     702C A218     
     702E A006     
0042 7030 06A0  32         bl    @pane.action.colorscheme.statlines
     7032 74FE     
0043                                                   ; Set color combination for status lines
0044                                                   ; \ i  @parm1 = Color combination
0045                                                   ; /
0046                       ;------------------------------------------------------
0047                       ; Update status line and show cursor
0048                       ;------------------------------------------------------
0049 7034 0720  34         seto  @fb.status.dirty      ; Trigger status line update
     7036 A31A     
0050               
0051 7038 06A0  32         bl    @pane.cursor.blink    ; Show cursor
     703A 7536     
0052                       ;------------------------------------------------------
0053                       ; Exit
0054                       ;------------------------------------------------------
0055               fb.restore.exit:
0056 703C C839  50         mov   *stack+,@parm1        ; Pop @parm1
     703E A006     
0057 7040 C820  54         mov   @parm1,@wyx           ; Set cursor position
     7042 A006     
     7044 832A     
0058 7046 C2F9  30         mov   *stack+,r11           ; Pop R11
0059 7048 045B  20         b     *r11                  ; Return
                   < stevie_b1.asm.33260
0112                       ;-----------------------------------------------------------------------
0113                       ; Logic for Editor Buffer
0114                       ;-----------------------------------------------------------------------
0115                       copy  "edb.line.pack.fb.asm"        ; Pack line into editor buffer
     **** ****     > edb.line.pack.fb.asm
0001               * FILE......: edb.line.pack.fb.asm
0002               * Purpose...: Pack current line in framebuffer to editor buffer
0003               
0004               ***************************************************************
0005               * edb.line.pack.fb
0006               * Pack current line in framebuffer
0007               ***************************************************************
0008               *  bl   @edb.line.pack.fb
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @fb.top       = Address of top row in frame buffer
0012               * @fb.row       = Current row in frame buffer
0013               * @fb.column    = Current column in frame buffer
0014               * @fb.colsline  = Columns per line in frame buffer
0015               *--------------------------------------------------------------
0016               * OUTPUT
0017               *--------------------------------------------------------------
0018               * Register usage
0019               * tmp0,tmp1,tmp2,tmp3
0020               *--------------------------------------------------------------
0021               * Memory usage
0022               * rambuf   = Saved @fb.column
0023               * rambuf+2 = Saved beginning of row
0024               * rambuf+4 = Saved length of row
0025               ********|*****|*********************|**************************
0026               edb.line.pack.fb:
0027 704A 0649  14         dect  stack
0028 704C C64B  30         mov   r11,*stack            ; Save return address
0029 704E 0649  14         dect  stack
0030 7050 C644  30         mov   tmp0,*stack           ; Push tmp0
0031 7052 0649  14         dect  stack
0032 7054 C645  30         mov   tmp1,*stack           ; Push tmp1
0033 7056 0649  14         dect  stack
0034 7058 C646  30         mov   tmp2,*stack           ; Push tmp2
0035 705A 0649  14         dect  stack
0036 705C C647  30         mov   tmp3,*stack           ; Push tmp3
0037                       ;------------------------------------------------------
0038                       ; Get values
0039                       ;------------------------------------------------------
0040 705E C820  54         mov   @fb.column,@rambuf    ; Save @fb.column
     7060 A30C     
     7062 A100     
0041 7064 04E0  34         clr   @fb.column
     7066 A30C     
0042 7068 06A0  32         bl    @fb.calc_pointer      ; Beginning of row
     706A 3094     
0043                       ;------------------------------------------------------
0044                       ; Prepare scan
0045                       ;------------------------------------------------------
0046 706C 04C4  14         clr   tmp0                  ; Counter
0047 706E C160  34         mov   @fb.current,tmp1      ; Get position
     7070 A302     
0048 7072 C805  38         mov   tmp1,@rambuf+2        ; Save beginning of row
     7074 A102     
0049 7076 04C7  14         clr   tmp3                  ; Counter for whitespace
0050                       ;------------------------------------------------------
0051                       ; 1. Scan line for >00 byte termination
0052                       ;------------------------------------------------------
0053               edb.line.pack.fb.scan:
0054 7078 D1B5  28         movb  *tmp1+,tmp2           ; Get char
0055 707A 0986  56         srl   tmp2,8                ; Right justify
0056 707C 130D  14         jeq   edb.line.pack.fb.check_setpage
0057                                                   ; Stop scan if >00 found
0058 707E 0584  14         inc   tmp0                  ; Increase string length
0059                       ;------------------------------------------------------
0060                       ; Check for trailing whitespace
0061                       ;------------------------------------------------------
0062 7080 0286  22         ci    tmp2,32               ; Was it a space character?
     7082 0020     
0063 7084 1301  14         jeq   edb.line.pack.fb.check80
0064 7086 C1C4  18         mov   tmp0,tmp3
0065                       ;------------------------------------------------------
0066                       ; Not more than 80 characters
0067                       ;------------------------------------------------------
0068               edb.line.pack.fb.check80:
0069 7088 0284  22         ci    tmp0,colrow
     708A 0050     
0070 708C 1305  14         jeq   edb.line.pack.fb.check_setpage
0071                                                   ; Stop scan if 80 characters processed
0072 708E 10F4  14         jmp   edb.line.pack.fb.scan ; Next character
0073                       ;------------------------------------------------------
0074                       ; Check failed, crash CPU!
0075                       ;------------------------------------------------------
0076               edb.line.pack.fb.crash:
0077 7090 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7092 FFCE     
0078 7094 06A0  32         bl    @cpu.crash            ; / Crash and halt system
     7096 2026     
0079                       ;------------------------------------------------------
0080                       ; Check if highest SAMS page needs to be increased
0081                       ;------------------------------------------------------
0082               edb.line.pack.fb.check_setpage:
0083 7098 8107  18         c     tmp3,tmp0             ; Trailing whitespace in line?
0084 709A 1103  14         jlt   edb.line.pack.fb.rtrim
0085 709C C804  38         mov   tmp0,@rambuf+4        ; Save full length of line
     709E A104     
0086 70A0 100C  14         jmp   !
0087               edb.line.pack.fb.rtrim:
0088                       ;------------------------------------------------------
0089                       ; Remove trailing blanks from line
0090                       ;------------------------------------------------------
0091 70A2 C807  38         mov   tmp3,@rambuf+4        ; Save line length without trailing blanks
     70A4 A104     
0092               
0093 70A6 04C5  14         clr   tmp1                  ; tmp1 = Character to fill (>00)
0094               
0095 70A8 C184  18         mov   tmp0,tmp2             ; \
0096 70AA 6187  18         s     tmp3,tmp2             ; | tmp2 = Repeat count
0097 70AC 0586  14         inc   tmp2                  ; /
0098               
0099 70AE C107  18         mov   tmp3,tmp0             ; \
0100 70B0 A120  34         a     @rambuf+2,tmp0        ; / tmp0 = Start address in CPU memory
     70B2 A102     
0101               
0102               edb.line.pack.fb.rtrim.loop:
0103 70B4 DD05  32         movb  tmp1,*tmp0+
0104 70B6 0606  14         dec   tmp2
0105 70B8 15FD  14         jgt   edb.line.pack.fb.rtrim.loop
0106                       ;------------------------------------------------------
0107                       ; Check and increase highest SAMS page
0108                       ;------------------------------------------------------
0109 70BA 06A0  32 !       bl    @edb.hipage.alloc     ; Check and increase highest SAMS page
     70BC 35EA     
0110                                                   ; \ i  @edb.next_free.ptr = Pointer to next
0111                                                   ; /                         free line
0112                       ;------------------------------------------------------
0113                       ; 2. Prepare for storing line
0114                       ;------------------------------------------------------
0115               edb.line.pack.fb.prepare:
0116 70BE C820  54         mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
     70C0 A304     
     70C2 A006     
0117 70C4 A820  54         a     @fb.row,@parm1        ; /
     70C6 A306     
     70C8 A006     
0118                       ;------------------------------------------------------
0119                       ; 2a. Update index
0120                       ;------------------------------------------------------
0121               edb.line.pack.fb.update_index:
0122 70CA C820  54         mov   @edb.next_free.ptr,@parm2
     70CC A508     
     70CE A008     
0123                                                   ; Pointer to new line
0124 70D0 C820  54         mov   @edb.sams.hipage,@parm3
     70D2 A518     
     70D4 A00A     
0125                                                   ; SAMS page to use
0126               
0127 70D6 06A0  32         bl    @idx.entry.update     ; Update index
     70D8 3390     
0128                                                   ; \ i  parm1 = Line number in editor buffer
0129                                                   ; | i  parm2 = pointer to line in
0130                                                   ; |            editor buffer
0131                                                   ; / i  parm3 = SAMS page
0132                       ;------------------------------------------------------
0133                       ; 3. Set line prefix in editor buffer
0134                       ;------------------------------------------------------
0135 70DA C120  34         mov   @rambuf+2,tmp0        ; Source for memory copy
     70DC A102     
0136 70DE C160  34         mov   @edb.next_free.ptr,tmp1
     70E0 A508     
0137                                                   ; Address of line in editor buffer
0138               
0139 70E2 05E0  34         inct  @edb.next_free.ptr    ; Adjust pointer
     70E4 A508     
0140               
0141 70E6 C1A0  34         mov   @rambuf+4,tmp2        ; Get line length
     70E8 A104     
0142 70EA CD46  34         mov   tmp2,*tmp1+           ; Set line length as line prefix
0143 70EC 1317  14         jeq   edb.line.pack.fb.prepexit
0144                                                   ; Nothing to copy if empty line
0145                       ;------------------------------------------------------
0146                       ; 4. Copy line from framebuffer to editor buffer
0147                       ;------------------------------------------------------
0148               edb.line.pack.fb.copyline:
0149 70EE 0286  22         ci    tmp2,2
     70F0 0002     
0150 70F2 1603  14         jne   edb.line.pack.fb.copyline.checkbyte
0151 70F4 DD74  42         movb  *tmp0+,*tmp1+         ; \ Copy single word on possible
0152 70F6 DD74  42         movb  *tmp0+,*tmp1+         ; / uneven address
0153 70F8 1007  14         jmp   edb.line.pack.fb.copyline.align16
0154               
0155               edb.line.pack.fb.copyline.checkbyte:
0156 70FA 0286  22         ci    tmp2,1
     70FC 0001     
0157 70FE 1602  14         jne   edb.line.pack.fb.copyline.block
0158 7100 D554  38         movb  *tmp0,*tmp1           ; Copy single byte
0159 7102 1002  14         jmp   edb.line.pack.fb.copyline.align16
0160               
0161               edb.line.pack.fb.copyline.block:
0162 7104 06A0  32         bl    @xpym2m               ; Copy memory block
     7106 24F4     
0163                                                   ; \ i  tmp0 = source
0164                                                   ; | i  tmp1 = destination
0165                                                   ; / i  tmp2 = bytes to copy
0166                       ;------------------------------------------------------
0167                       ; 5: Align pointer to multiple of 16 memory address
0168                       ;------------------------------------------------------
0169               edb.line.pack.fb.copyline.align16:
0170 7108 A820  54         a     @rambuf+4,@edb.next_free.ptr
     710A A104     
     710C A508     
0171                                                      ; Add length of line
0172               
0173 710E C120  34         mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
     7110 A508     
0174 7112 0504  16         neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
0175 7114 0244  22         andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
     7116 000F     
0176 7118 A804  38         a     tmp0,@edb.next_free.ptr  ; / Chapter 2
     711A A508     
0177                       ;------------------------------------------------------
0178                       ; 6: Restore SAMS page and prepare for exit
0179                       ;------------------------------------------------------
0180               edb.line.pack.fb.prepexit:
0181 711C C820  54         mov   @rambuf,@fb.column    ; Retrieve @fb.column
     711E A100     
     7120 A30C     
0182               
0183 7122 8820  54         c     @edb.sams.hipage,@edb.sams.page
     7124 A518     
     7126 A516     
0184 7128 1306  14         jeq   edb.line.pack.fb.exit ; Exit early if SAMS page already mapped
0185               
0186 712A C120  34         mov   @edb.sams.page,tmp0
     712C A516     
0187 712E C160  34         mov   @edb.top.ptr,tmp1
     7130 A500     
0188 7132 06A0  32         bl    @xsams.page.set       ; Set SAMS page
     7134 258A     
0189                                                   ; \ i  tmp0 = SAMS page number
0190                                                   ; / i  tmp1 = Memory address
0191                       ;------------------------------------------------------
0192                       ; Exit
0193                       ;------------------------------------------------------
0194               edb.line.pack.fb.exit:
0195 7136 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0196 7138 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0197 713A C179  30         mov   *stack+,tmp1          ; Pop tmp1
0198 713C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0199 713E C2F9  30         mov   *stack+,r11           ; Pop R11
0200 7140 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.33260
0116                       copy  "edb.line.unpack.fb.asm"      ; Unpack line from editor buffer
     **** ****     > edb.line.unpack.fb.asm
0001               * FILE......: edb.line.unpack.fb.asm
0002               * Purpose...: Unpack line from editor buffer to frame buffer
0003               
0004               ***************************************************************
0005               * edb.line.unpack.fb
0006               * Unpack specified line to framebuffer
0007               ***************************************************************
0008               *  bl   @edb.line.unpack.fb
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @parm1 = Line to unpack in editor buffer (base 0)
0012               * @parm2 = Target row in frame buffer
0013               * @parm3 = Column offset (normally supplied by @fb.vwco)
0014               *--------------------------------------------------------------
0015               * OUTPUT
0016               * @outparm1 = Length of unpacked line
0017               *--------------------------------------------------------------
0018               * Register usage
0019               * tmp0,tmp1,tmp2
0020               *--------------------------------------------------------------
0021               * Memory usage
0022               * rambuf    = Saved @parm1 of edb.line.unpack.fb
0023               * rambuf+2  = Saved @parm2 of edb.line.unpack.fb
0024               * rambuf+4  = Saved @parm3 of edb.line.unpack.fb
0025               * rambuf+6  = Source memory address in editor buffer
0026               * rambuf+8  = Destination memory address in frame buffer
0027               * rambuf+10 = Length of line
0028               ********|*****|*********************|**************************
0029               edb.line.unpack.fb:
0030 7142 0649  14         dect  stack
0031 7144 C64B  30         mov   r11,*stack            ; Save return address
0032 7146 0649  14         dect  stack
0033 7148 C644  30         mov   tmp0,*stack           ; Push tmp0
0034 714A 0649  14         dect  stack
0035 714C C645  30         mov   tmp1,*stack           ; Push tmp1
0036 714E 0649  14         dect  stack
0037 7150 C646  30         mov   tmp2,*stack           ; Push tmp2
0038                       ;------------------------------------------------------
0039                       ; Save parameters
0040                       ;------------------------------------------------------
0041 7152 C820  54         mov   @parm1,@rambuf
     7154 A006     
     7156 A100     
0042 7158 C820  54         mov   @parm2,@rambuf+2
     715A A008     
     715C A102     
0043 715E C820  54         mov   @parm3,@rambuf+4
     7160 A00A     
     7162 A104     
0044                       ;------------------------------------------------------
0045                       ; Calculate offset in frame buffer
0046                       ;------------------------------------------------------
0047 7164 C120  34         mov   @fb.colsline,tmp0
     7166 A30E     
0048 7168 3920  72         mpy   @parm2,tmp0           ; Offset is in tmp1!
     716A A008     
0049 716C C1A0  34         mov   @fb.top.ptr,tmp2
     716E A300     
0050 7170 A146  18         a     tmp2,tmp1             ; Add base to offset
0051 7172 C805  38         mov   tmp1,@rambuf+8        ; Destination row in frame buffer
     7174 A108     
0052                       ;------------------------------------------------------
0053                       ; Return empty row if requested line beyond editor buffer
0054                       ;------------------------------------------------------
0055 7176 8820  54         c     @parm1,@edb.lines     ; Requested line at BOT?
     7178 A006     
     717A A504     
0056 717C 1103  14         jlt   !                     ; No, continue processing
0057               
0058 717E 04E0  34         clr   @rambuf+10            ; Set length=0
     7180 A10A     
0059 7182 1013  14         jmp   edb.line.unpack.fb.clear
0060                       ;------------------------------------------------------
0061                       ; Get pointer to line & page-in editor buffer page
0062                       ;------------------------------------------------------
0063 7184 C120  34 !       mov   @parm1,tmp0
     7186 A006     
0064 7188 06A0  32         bl    @edb.line.mappage     ; Activate editor buffer SAMS page for line
     718A 3538     
0065                                                   ; \ i  tmp0     = Line number
0066                                                   ; | o  outparm1 = Pointer to line
0067                                                   ; / o  outparm2 = SAMS page
0068                       ;------------------------------------------------------
0069                       ; Handle empty line
0070                       ;------------------------------------------------------
0071 718C C120  34         mov   @outparm1,tmp0        ; Get pointer to line
     718E A016     
0072 7190 1603  14         jne   edb.line.unpack.fb.getlen
0073                                                   ; Continue if pointer is set
0074               
0075 7192 04E0  34         clr   @rambuf+10            ; Set length=0
     7194 A10A     
0076 7196 1009  14         jmp   edb.line.unpack.fb.clear
0077                       ;------------------------------------------------------
0078                       ; Get line length
0079                       ;------------------------------------------------------
0080               edb.line.unpack.fb.getlen:
0081 7198 C174  30         mov   *tmp0+,tmp1           ; Get line length
0082 719A C804  38         mov   tmp0,@rambuf+6        ; Source memory address for block copy
     719C A106     
0083 719E C805  38         mov   tmp1,@rambuf+10       ; Save line length
     71A0 A10A     
0084                       ;------------------------------------------------------
0085                       ; Assert on line length
0086                       ;------------------------------------------------------
0087 71A2 0285  22         ci    tmp1,80               ; \ Continue if length <= 80
     71A4 0050     
0088                                                   ; /
0089 71A6 1201  14         jle   edb.line.unpack.fb.clear
0090 71A8 1010  14         jmp   edb.line.unpack.fb.prepare
0091                                                   ; Length > 80 so don't erase
0092                       ;------------------------------------------------------
0093                       ; Erase chars from last column until column 80
0094                       ;------------------------------------------------------
0095               edb.line.unpack.fb.clear:
0096 71AA C120  34         mov   @rambuf+8,tmp0        ; \ Start of row in frame buffer
     71AC A108     
0097 71AE A120  34         a     @rambuf+10,tmp0       ; | Skip until end of row in frame buffer
     71B0 A10A     
0098 71B2 6120  34         s     @rambuf+4,tmp0        ; / honouring column offset (see @fb.vwco)
     71B4 A104     
0099               
0100 71B6 04C5  14         clr   tmp1                  ; Fill with >00
0101 71B8 C1A0  34         mov   @fb.colsline,tmp2
     71BA A30E     
0102 71BC 61A0  34         s     @rambuf+10,tmp2       ; \ Calculate number of bytes to clear
     71BE A10A     
0103 71C0 A1A0  34         a     @rambuf+4,tmp2        ; / honouring column offset (see @fb.vwco)
     71C2 A104     
0104 71C4 0586  14         inc   tmp2
0105               
0106 71C6 06A0  32         bl    @xfilm                ; Fill CPU memory
     71C8 2250     
0107                                                   ; \ i  tmp0 = Target address
0108                                                   ; | i  tmp1 = Byte to fill
0109                                                   ; / i  tmp2 = Repeat count
0110                       ;------------------------------------------------------
0111                       ; Prepare for unpacking data
0112                       ;------------------------------------------------------
0113               edb.line.unpack.fb.prepare:
0114 71CA C1A0  34         mov   @rambuf+10,tmp2       ; Line length
     71CC A10A     
0115 71CE C806  38         mov   tmp2,@outparm1        ; Store in output parameter
     71D0 A016     
0116 71D2 1310  14         jeq   edb.line.unpack.fb.exit
0117                                                   ; Exit if length = 0
0118               
0119 71D4 C120  34         mov   @rambuf+6,tmp0        ; Pointer to line in editor buffer
     71D6 A106     
0120 71D8 A120  34         a     @rambuf+4,tmp0        ; Add column offset (see @fb.vwco)
     71DA A104     
0121 71DC C160  34         mov   @rambuf+8,tmp1        ; Pointer to row in frame buffer
     71DE A108     
0122 71E0 61A0  34         s     @rambuf+4,tmp2        ; Subtract @fb.vwco from line length
     71E2 A104     
0123                       ;------------------------------------------------------
0124                       ; Assert on line length
0125                       ;------------------------------------------------------
0126 71E4 1307  14         jeq   edb.line.unpack.fb.exit
0127                                                   ; Exit if line length = 0
0128               
0129 71E6 0286  22         ci    tmp2,80               ; Check line length
     71E8 0050     
0130 71EA 1202  14         jle   edb.line.unpack.fb.copy
0131 71EC 0206  20         li    tmp2,80               ; Only process first 80 characters
     71EE 0050     
0132                       ;------------------------------------------------------
0133                       ; Copy memory block
0134                       ;------------------------------------------------------
0135               edb.line.unpack.fb.copy:
0136 71F0 06A0  32         bl    @xpym2m               ; Copy line to frame buffer
     71F2 24F4     
0137                                                   ; \ i  tmp0 = Source address
0138                                                   ; | i  tmp1 = Target address
0139                                                   ; / i  tmp2 = Bytes to copy
0140                       ;------------------------------------------------------
0141                       ; Exit
0142                       ;------------------------------------------------------
0143               edb.line.unpack.fb.exit:
0144 71F4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0145 71F6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0146 71F8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0147 71FA C2F9  30         mov   *stack+,r11           ; Pop r11
0148 71FC 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.33260
0117                       ;-----------------------------------------------------------------------
0118                       ; Background tasks
0119                       ;-----------------------------------------------------------------------
0124                       copy  "task.vdp.cursor.char.asm"    ; Set cursor shape in VDP (blink)
     **** ****     > task.vdp.cursor.char.asm
0001               * FILE......: task.vdp.cursor.char.asm
0002               * Purpose...: VDP cursor shape (character version)
0003               
0004               ***************************************************************
0005               * Task - Update cursor shape (blink)
0006               ********|*****|*********************|**************************
0007               task.vdp.cursor:
0008 71FE 0649  14         dect  stack
0009 7200 C64B  30         mov   r11,*stack            ; Save return address
0010 7202 0649  14         dect  stack
0011 7204 C644  30         mov   tmp0,*stack           ; Push tmp0
0012 7206 0649  14         dect  stack
0013 7208 C645  30         mov   tmp1,*stack           ; Push tmp1
0014 720A 0649  14         dect  stack
0015 720C C646  30         mov   tmp2,*stack           ; Push tmp2
0016 720E 0649  14         dect  stack
0017 7210 C660  46         mov   @wyx,*stack           ; Push cursor position
     7212 832A     
0018                       ;------------------------------------------------------
0019                       ; Get pane with focus
0020                       ;------------------------------------------------------
0021 7214 C120  34         mov   @tv.pane.focus,tmp0   ; Get pane with focus
     7216 A222     
0022               
0023 7218 0284  22         ci    tmp0,pane.focus.fb
     721A 0000     
0024 721C 1310  14         jeq   task.vdp.cursor.fb    ; Frame buffer has focus
0025               
0026 721E 0284  22         ci    tmp0,pane.focus.cmdb
     7220 0001     
0027 7222 1304  14         jeq   task.vdp.cursor.cmdb  ; CMDB buffer has focus
0028                       ;------------------------------------------------------
0029                       ; Assert failed. Invalid value
0030                       ;------------------------------------------------------
0031 7224 C80B  38         mov   r11,@>ffce            ; \ Save caller address
     7226 FFCE     
0032 7228 06A0  32         bl    @cpu.crash            ; / Halt system.
     722A 2026     
0033                       ;------------------------------------------------------
0034                       ; CMDB buffer has focus, position CMDB cursor
0035                       ;------------------------------------------------------
0036               task.vdp.cursor.cmdb:
0037 722C C820  54         mov   @cmdb.cursor,@wyx     ; Position cursor in CMDB pane
     722E A70A     
     7230 832A     
0038 7232 0560  34         inv   @fb.curtoggle         ; Flip cursor shape flag
     7234 A314     
0039 7236 1319  14         jeq   task.vdp.cursor.dump  ; Show CMDB cursor
0040                       ;------------------------------------------------------
0041                       ; Hide CMDB cursor
0042                       ;------------------------------------------------------
0043               task.vdp.cursor.cmdb.hide:
0044 7238 0720  34         seto  @cmdb.dirty
     723A A718     
0045 723C 101C  14         jmp   task.vdp.cursor.exit
0046                       ;------------------------------------------------------
0047                       ; Frame buffer has focus, position FB cursor
0048                       ;------------------------------------------------------
0049               task.vdp.cursor.fb:
0050 723E 0560  34         inv   @fb.curtoggle         ; Flip cursor shape flag
     7240 A314     
0051 7242 1303  14         jeq   task.vdp.cursor.fb.visible
0052                                                   ; Show FB cursor
0053                       ;------------------------------------------------------
0054                       ; Hide FB cursor
0055                       ;------------------------------------------------------
0056 7244 0720  34         seto  @fb.dirty             ; Trigger refresh
     7246 A318     
0057 7248 1016  14         jmp   task.vdp.cursor.exit
0058                       ;------------------------------------------------------
0059                       ; Show FB cursor
0060                       ;------------------------------------------------------
0061               task.vdp.cursor.fb.visible:
0062 724A C120  34         mov   @tv.ruler.visible,tmp0
     724C A210     
0063 724E 1307  14         jeq   task.vdp.cursor.fb.visible.noruler
0064                       ;------------------------------------------------------
0065                       ; Cursor position adjustment, ruler visible
0066                       ;------------------------------------------------------
0067 7250 C120  34         mov   @wyx,tmp0             ; Get cursor YX
     7252 832A     
0068 7254 0224  22         ai    tmp0,>0200            ; Topline + ruler adjustment
     7256 0200     
0069 7258 C804  38         mov   tmp0,@wyx             ; Save cursor YX
     725A 832A     
0070 725C 1006  14         jmp   task.vdp.cursor.dump
0071                       ;------------------------------------------------------
0072                       ; Cursor position adjustment, ruler hidden
0073                       ;------------------------------------------------------
0074               task.vdp.cursor.fb.visible.noruler:
0075 725E C120  34         mov   @wyx,tmp0             ; Get cursor YX
     7260 832A     
0076 7262 0224  22         ai    tmp0,>0100            ; Topline adjustment
     7264 0100     
0077 7266 C804  38         mov   tmp0,@wyx             ; Save cursor YX
     7268 832A     
0078                       ;------------------------------------------------------
0079                       ; Dump cursor to VDP
0080                       ;------------------------------------------------------
0081               task.vdp.cursor.dump:
0082 726A 06A0  32         bl    @yx2pnt               ; Calculate VDP address from @WYX
     726C 240E     
0083                                                   ; \ i  @wyx = Cursor position
0084                                                   ; / o  tmp0 = VDP address
0085               
0086 726E 0205  20         li    tmp1,26               ; Cursor character
     7270 001A     
0087               
0088 7272 06A0  32         bl    @xvputb               ; VDP put single byte
     7274 22E0     
0089                                                   ; \ i  tmp0 = VDP write address
0090                                                   ; / i  tmp1 = Byte to write
0091                       ;------------------------------------------------------
0092                       ; Exit
0093                       ;------------------------------------------------------
0094               task.vdp.cursor.exit:
0095 7276 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     7278 832A     
0096 727A C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0097 727C C179  30         mov   *stack+,tmp1          ; Pop tmp1
0098 727E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0099 7280 C2F9  30         mov   *stack+,r11           ; Pop r11
0100 7282 0460  28         b     @slotok               ; Exit task
     7284 2E58     
                   < stevie_b1.asm.33260
0126               
0127                       copy  "task.vdp.panes.asm"          ; Draw editor panes in VDP
     **** ****     > task.vdp.panes.asm
0001               * FILE......: task.vdp.panes.asm
0002               * Purpose...: Stevie Editor - VDP draw editor panes
0003               
0004               ***************************************************************
0005               * Task - VDP draw editor panes (frame buffer, CMDB, status line)
0006               ********|*****|*********************|**************************
0007               task.vdp.panes:
0008 7286 0649  14         dect  stack
0009 7288 C64B  30         mov   r11,*stack            ; Save return address
0010                       ;------------------------------------------------------
0011                       ; Dump panes to VDP memory
0012                       ;------------------------------------------------------
0013 728A 06A0  32         bl    @pane.vdpdump
     728C 787A     
0014                       ;------------------------------------------------------
0015                       ; Exit task
0016                       ;------------------------------------------------------
0017               task.vdp.panes.exit:
0018 728E C2F9  30         mov   *stack+,r11           ; Pop r11
0019 7290 0460  28         b     @slotok
     7292 2E58     
                   < stevie_b1.asm.33260
0128                       copy  "task.oneshot.asm"            ; Run "one shot" task
     **** ****     > task.oneshot.asm
0001               * FILE......: task.oneshot.asm
0002               * Purpose...: Trigger one-shot task
0003               
0004               ***************************************************************
0005               * Task - One-shot
0006               ***************************************************************
0007               
0008               task.oneshot:
0009 7294 C120  34         mov   @tv.task.oneshot,tmp0  ; Get pointer to one-shot task
     7296 A224     
0010 7298 1301  14         jeq   task.oneshot.exit
0011               
0012 729A 0694  24         bl    *tmp0                  ; Execute one-shot task
0013                       ;------------------------------------------------------
0014                       ; Exit
0015                       ;------------------------------------------------------
0016               task.oneshot.exit:
0017 729C 0460  28         b     @slotok                ; Exit task
     729E 2E58     
                   < stevie_b1.asm.33260
0129                       ;-----------------------------------------------------------------------
0130                       ; Screen pane utilities
0131                       ;-----------------------------------------------------------------------
0132                       copy  "pane.utils.colorscheme.asm"  ; Colorscheme handling in panes
     **** ****     > pane.utils.colorscheme.asm
0001               
0002               
0003               
0004               * FILE......: pane.utils.colorscheme.asm
0005               * Purpose...: Stevie Editor - Color scheme for panes
0006               
0007               ***************************************************************
0008               * pane.action.colorscheme.cycle
0009               * Cycle through available color scheme
0010               ***************************************************************
0011               * bl  @pane.action.colorscheme.cycle
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * tmp0
0018               ********|*****|*********************|**************************
0019               pane.action.colorscheme.cycle:
0020 72A0 0649  14         dect  stack
0021 72A2 C64B  30         mov   r11,*stack            ; Push return address
0022 72A4 0649  14         dect  stack
0023 72A6 C644  30         mov   tmp0,*stack           ; Push tmp0
0024               
0025 72A8 C120  34         mov   @tv.colorscheme,tmp0  ; Load color scheme index
     72AA A212     
0026 72AC 0284  22         ci    tmp0,tv.colorscheme.entries
     72AE 000A     
0027                                                   ; Last entry reached?
0028 72B0 1103  14         jlt   !
0029 72B2 0204  20         li    tmp0,1                ; Reset color scheme index
     72B4 0001     
0030 72B6 1001  14         jmp   pane.action.colorscheme.switch
0031 72B8 0584  14 !       inc   tmp0
0032                       ;-------------------------------------------------------
0033                       ; Switch to new color scheme
0034                       ;-------------------------------------------------------
0035               pane.action.colorscheme.switch:
0036 72BA C804  38         mov   tmp0,@tv.colorscheme  ; Save index of color scheme
     72BC A212     
0037               
0038 72BE 06A0  32         bl    @pane.action.colorscheme.load
     72C0 72FE     
0039                                                   ; Load current color scheme
0040                       ;-------------------------------------------------------
0041                       ; Show current color palette message
0042                       ;-------------------------------------------------------
0043 72C2 C820  54         mov   @wyx,@waux1           ; Save cursor YX position
     72C4 832A     
     72C6 833C     
0044               
0045 72C8 06A0  32         bl    @putnum
     72CA 2A38     
0046 72CC 003E                   byte 0,62
0047 72CE A212                   data tv.colorscheme,rambuf,>3020
     72D0 A100     
     72D2 3020     
0048               
0049 72D4 06A0  32         bl    @putat
     72D6 2456     
0050 72D8 0034                   byte 0,52
0051 72DA 3AA2                   data txt.colorscheme  ; Show color palette message
0052               
0053 72DC C820  54         mov   @waux1,@wyx           ; Restore cursor YX position
     72DE 833C     
     72E0 832A     
0054                       ;-------------------------------------------------------
0055                       ; Delay
0056                       ;-------------------------------------------------------
0057 72E2 0204  20         li    tmp0,12000
     72E4 2EE0     
0058 72E6 0604  14 !       dec   tmp0
0059 72E8 16FE  14         jne   -!
0060                       ;-------------------------------------------------------
0061                       ; Setup one shot task for removing message
0062                       ;-------------------------------------------------------
0063 72EA 0204  20         li    tmp0,pane.topline.oneshot.clearmsg
     72EC 3630     
0064 72EE C804  38         mov   tmp0,@tv.task.oneshot
     72F0 A224     
0065               
0066 72F2 06A0  32         bl    @rsslot               ; \ Reset loop counter slot 3
     72F4 2ECC     
0067 72F6 0003                   data 3                ; / for getting consistent delay
0068                       ;-------------------------------------------------------
0069                       ; Exit
0070                       ;-------------------------------------------------------
0071               pane.action.colorscheme.cycle.exit:
0072 72F8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0073 72FA C2F9  30         mov   *stack+,r11           ; Pop R11
0074 72FC 045B  20         b     *r11                  ; Return to caller
0075               
0076               
0077               
0078               ***************************************************************
0079               * pane.action.colorscheme.load
0080               * Load color scheme
0081               ***************************************************************
0082               * bl  @pane.action.colorscheme.load
0083               *--------------------------------------------------------------
0084               * INPUT
0085               * @tv.colorscheme = Index into color scheme table
0086               * @parm1          = Skip screen off if >FFFF
0087               * @parm2          = Skip colorizing marked lines if >FFFF
0088               * @parm3          = Only colorize CMDB pane if >FFFF
0089               *--------------------------------------------------------------
0090               * OUTPUT
0091               * none
0092               *--------------------------------------------------------------
0093               * Register usage
0094               * tmp0,tmp1,tmp2,tmp3,tmp4
0095               ********|*****|*********************|**************************
0096               pane.action.colorscheme.load:
0097 72FE 0649  14         dect  stack
0098 7300 C64B  30         mov   r11,*stack            ; Save return address
0099 7302 0649  14         dect  stack
0100 7304 C644  30         mov   tmp0,*stack           ; Push tmp0
0101 7306 0649  14         dect  stack
0102 7308 C645  30         mov   tmp1,*stack           ; Push tmp1
0103 730A 0649  14         dect  stack
0104 730C C646  30         mov   tmp2,*stack           ; Push tmp2
0105 730E 0649  14         dect  stack
0106 7310 C647  30         mov   tmp3,*stack           ; Push tmp3
0107 7312 0649  14         dect  stack
0108 7314 C648  30         mov   tmp4,*stack           ; Push tmp4
0109 7316 0649  14         dect  stack
0110 7318 C660  46         mov   @parm1,*stack         ; Push parm1
     731A A006     
0111 731C 0649  14         dect  stack
0112 731E C660  46         mov   @parm2,*stack         ; Push parm2
     7320 A008     
0113 7322 0649  14         dect  stack
0114 7324 C660  46         mov   @parm3,*stack         ; Push parm3
     7326 A00A     
0115                       ;-------------------------------------------------------
0116                       ; Turn screen off
0117                       ;-------------------------------------------------------
0118 7328 C120  34         mov   @parm1,tmp0
     732A A006     
0119 732C 0284  22         ci    tmp0,>ffff            ; Skip flag set?
     732E FFFF     
0120 7330 1302  14         jeq   !                     ; Yes, so skip screen off
0121 7332 06A0  32         bl    @scroff               ; Turn screen off
     7334 269A     
0122                       ;-------------------------------------------------------
0123                       ; Get FG/BG colors framebuffer text
0124                       ;-------------------------------------------------------
0125 7336 C120  34 !       mov   @tv.colorscheme,tmp0  ; Get color scheme index
     7338 A212     
0126 733A 0604  14         dec   tmp0                  ; Internally work with base 0
0127               
0128 733C 0A34  56         sla   tmp0,3                ; Offset into color scheme data table
0129 733E 0224  22         ai    tmp0,tv.colorscheme.table
     7340 367C     
0130                                                   ; Add base for color scheme data table
0131 7342 C1F4  30         mov   *tmp0+,tmp3           ; Get colors ABCD
0132 7344 C807  38         mov   tmp3,@tv.color        ; Save colors ABCD
     7346 A218     
0133                       ;-------------------------------------------------------
0134                       ; Get and save cursor color
0135                       ;-------------------------------------------------------
0136 7348 C214  26         mov   *tmp0,tmp4            ; Get colors EFGH
0137 734A 0248  22         andi  tmp4,>00ff            ; Only keep LSB (GH)
     734C 00FF     
0138 734E C808  38         mov   tmp4,@tv.curcolor     ; Save cursor color
     7350 A216     
0139                       ;-------------------------------------------------------
0140                       ; Get FG/BG colors framebuffer marked text & CMDB pane
0141                       ;-------------------------------------------------------
0142 7352 C234  30         mov   *tmp0+,tmp4           ; Get colors EFGH again
0143 7354 0248  22         andi  tmp4,>ff00            ; Only keep MSB (EF)
     7356 FF00     
0144 7358 0988  56         srl   tmp4,8                ; MSB to LSB
0145               
0146 735A C174  30         mov   *tmp0+,tmp1           ; Get colors IJKL
0147 735C C185  18         mov   tmp1,tmp2             ; \ Right align IJ and
0148 735E 0986  56         srl   tmp2,8                ; | save to @tv.busycolor
0149 7360 C806  38         mov   tmp2,@tv.busycolor    ; /
     7362 A21C     
0150               
0151 7364 0245  22         andi  tmp1,>00ff            ; | save KL to @tv.markcolor
     7366 00FF     
0152 7368 C805  38         mov   tmp1,@tv.markcolor    ; /
     736A A21A     
0153               
0154 736C C154  26         mov   *tmp0,tmp1            ; Get colors MNOP
0155 736E 0985  56         srl   tmp1,8                ; \ Right align MN and
0156 7370 C805  38         mov   tmp1,@tv.cmdb.hcolor  ; / save to @tv.cmdb.hcolor
     7372 A220     
0157                       ;-------------------------------------------------------
0158                       ; Check if only CMDB needs to be colorized
0159                       ;-------------------------------------------------------
0160 7374 8820  54         c     @parm3,@w$ffff        ; Only colorize CMDB pane ?
     7376 A00A     
     7378 2022     
0161 737A 133E  14         jeq   pane.action.colorscheme.cmdbpane
0162                                                   ; Yes, shortcut jump to CMDB pane
0163                       ;-------------------------------------------------------
0164                       ; Get FG color for ruler
0165                       ;-------------------------------------------------------
0166 737C C154  26         mov   *tmp0,tmp1            ; Get colors MNOP
0167 737E 0245  22         andi  tmp1,>000f            ; Only keep P
     7380 000F     
0168 7382 0A45  56         sla   tmp1,4                ; Make it a FG/BG combination
0169 7384 C805  38         mov   tmp1,@tv.rulercolor   ; Save to @tv.rulercolor
     7386 A21E     
0170                       ;-------------------------------------------------------
0171                       ; Write sprite color of line and column indicators to SAT
0172                       ;-------------------------------------------------------
0173 7388 C154  26         mov   *tmp0,tmp1            ; Get colors MNOP
0174 738A 0245  22         andi  tmp1,>00f0            ; Only keep O
     738C 00F0     
0175 738E 0A45  56         sla   tmp1,4                ; Move O to MSB
0176 7390 D805  38         movb  tmp1,@ramsat+7        ; Line indicator FG color to SAT
     7392 A05D     
0177 7394 D805  38         movb  tmp1,@ramsat+11       ; Column indicator FG color to SAT
     7396 A061     
0178                       ;-------------------------------------------------------
0179                       ; Dump colors to VDP register 7 (text mode)
0180                       ;-------------------------------------------------------
0181 7398 C147  18         mov   tmp3,tmp1             ; Get work copy
0182 739A 0985  56         srl   tmp1,8                ; MSB to LSB (frame buffer colors)
0183 739C 0265  22         ori   tmp1,>0700
     739E 0700     
0184 73A0 C105  18         mov   tmp1,tmp0
0185 73A2 06A0  32         bl    @putvrx               ; Write VDP register
     73A4 2348     
0186                       ;-------------------------------------------------------
0187                       ; Dump colors for frame buffer pane (TAT)
0188                       ;-------------------------------------------------------
0189 73A6 C120  34         mov   @tv.ruler.visible,tmp0
     73A8 A210     
0190 73AA 130A  14         jeq   pane.action.colorscheme.fbdump.noruler
0191               
0192 73AC C120  34         mov   @cmdb.dialog,tmp0
     73AE A71A     
0193 73B0 0284  22         ci    tmp0,id.dialog.help   ; Help dialog active?
     73B2 0068     
0194 73B4 1305  14         jeq   pane.action.colorscheme.fbdump.noruler
0195                                                   ; Yes, skip ruler
0196                       ;-------------------------------------------------------
0197                       ; Ruler visible on screen (TAT)
0198                       ;-------------------------------------------------------
0199 73B6 0204  20         li    tmp0,vdp.fb.toprow.tat+80
     73B8 18A0     
0200                                                   ; VDP start address (frame buffer area)
0201               
0202 73BA 0206  20         li    tmp2,(pane.botrow-2)*80
     73BC 0690     
0203                                                   ; Number of bytes to fill
0204 73BE 1004  14         jmp   pane.action.colorscheme.checkcmdb
0205               
0206               pane.action.colorscheme.fbdump.noruler:
0207                       ;-------------------------------------------------------
0208                       ; No ruler visible on screen (TAT)
0209                       ;-------------------------------------------------------
0210 73C0 0204  20         li    tmp0,vdp.fb.toprow.tat
     73C2 1850     
0211                                                   ; VDP start address (frame buffer area)
0212 73C4 0206  20         li    tmp2,(pane.botrow-1)*80
     73C6 06E0     
0213                                                   ; Number of bytes to fill
0214                       ;-------------------------------------------------------
0215                       ; Adjust bottom of frame buffer if CMDB visible
0216                       ;-------------------------------------------------------
0217               pane.action.colorscheme.checkcmdb:
0218 73C8 C820  54         mov   @cmdb.visible,@cmdb.visible
     73CA A702     
     73CC A702     
0219 73CE 1302  14         jeq   pane.action.colorscheme.fbdump
0220                                                   ; Not visible, skip adjustment
0221 73D0 0226  22         ai    tmp2,-320             ; CMDB adjustment
     73D2 FEC0     
0222                       ;-------------------------------------------------------
0223                       ; Dump colors to VDP (TAT)
0224                       ;-------------------------------------------------------
0225               pane.action.colorscheme.fbdump:
0226 73D4 C147  18         mov   tmp3,tmp1             ; Get work copy of colors ABCD
0227 73D6 0985  56         srl   tmp1,8                ; MSB to LSB (frame buffer colors)
0228               
0229 73D8 06A0  32         bl    @xfilv                ; Fill colors
     73DA 22A8     
0230                                                   ; i \  tmp0 = start address
0231                                                   ; i |  tmp1 = byte to fill
0232                                                   ; i /  tmp2 = number of bytes to fill
0233                       ;-------------------------------------------------------
0234                       ; Colorize marked lines
0235                       ;-------------------------------------------------------
0236 73DC C120  34         mov   @cmdb.dialog,tmp0
     73DE A71A     
0237 73E0 0284  22         ci    tmp0,id.dialog.help   ; Help dialog active?
     73E2 0068     
0238 73E4 1309  14         jeq   pane.action.colorscheme.cmdbpane
0239                                                   ; Yes, skip marked lines
0240               
0241 73E6 C120  34         mov   @parm2,tmp0
     73E8 A008     
0242 73EA 0284  22         ci    tmp0,>ffff            ; Skip colorize flag is on?
     73EC FFFF     
0243 73EE 1304  14         jeq   pane.action.colorscheme.cmdbpane
0244               
0245 73F0 0720  34         seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
     73F2 A312     
0246 73F4 06A0  32         bl    @fb.colorlines
     73F6 7B2A     
0247                       ;-------------------------------------------------------
0248                       ; Dump colors for CMDB header line (TAT)
0249                       ;-------------------------------------------------------
0250               pane.action.colorscheme.cmdbpane:
0251 73F8 C120  34         mov   @cmdb.visible,tmp0
     73FA A702     
0252 73FC 1330  14         jeq   pane.action.colorscheme.errpane
0253                                                   ; Skip if CMDB pane is hidden
0254               
0255 73FE 0204  20         li    tmp0,vdp.cmdb.toprow.tat
     7400 1DF0     
0256                                                   ; VDP start address (CMDB top line)
0257               
0258 7402 C160  34         mov   @tv.cmdb.hcolor,tmp1  ; set color for header line
     7404 A220     
0259 7406 0206  20         li    tmp2,1*67             ; Number of bytes to fill
     7408 0043     
0260 740A 06A0  32         bl    @xfilv                ; Fill colors
     740C 22A8     
0261                                                   ; i \  tmp0 = start address
0262                                                   ; i |  tmp1 = byte to fill
0263                                                   ; i /  tmp2 = number of bytes to fill
0264                       ;-------------------------------------------------------
0265                       ; Dump colors for CMDB Stevie logo (TAT)
0266                       ;-------------------------------------------------------
0267 740E 0204  20         li    tmp0,vdp.cmdb.toprow.tat+67
     7410 1E33     
0268 7412 C160  34         mov   @tv.cmdb.hcolor,tmp1  ;
     7414 A220     
0269 7416 D160  34         movb  @tv.cmdb.hcolor+1,tmp1
     7418 A221     
0270                                                   ; Copy same value into MSB
0271 741A 0945  56         srl   tmp1,4                ;
0272 741C 0245  22         andi  tmp1,>00ff            ; Only keep LSB
     741E 00FF     
0273               
0274 7420 0206  20         li    tmp2,13               ; Number of bytes to fill
     7422 000D     
0275 7424 06A0  32         bl    @xfilv                ; Fill colors
     7426 22A8     
0276                                                   ; i \  tmp0 = start address
0277                                                   ; i |  tmp1 = byte to fill
0278                                                   ; i /  tmp2 = number of bytes to fill
0279                       ;-------------------------------------------------------
0280                       ; Dump colors for CMDB pane content (TAT)
0281                       ;-------------------------------------------------------
0282 7428 0204  20         li    tmp0,vdp.cmdb.toprow.tat + 80
     742A 1E40     
0283                                                   ; VDP start address (CMDB top line + 1)
0284 742C C148  18         mov   tmp4,tmp1             ; Get work copy fg/bg color
0285 742E 0206  20         li    tmp2,1*80             ; Number of bytes to fill
     7430 0050     
0286 7432 06A0  32         bl    @xfilv                ; Fill colors
     7434 22A8     
0287                                                   ; i \  tmp0 = start address
0288                                                   ; i |  tmp1 = byte to fill
0289                                                   ; i /  tmp2 = number of bytes to fill
0290               
0291 7436 0204  20         li    tmp0,vdp.cmdb.toprow.tat + 160
     7438 1E90     
0292                                                   ; VDP start address (CMDB top line + 2)
0293 743A C160  34         mov   @tv.cmdb.hcolor,tmp1  ; Same color as header line
     743C A220     
0294 743E 0206  20         li    tmp2,1*80             ; Number of bytes to fill
     7440 0050     
0295 7442 06A0  32         bl    @xfilv                ; Fill colors
     7444 22A8     
0296                                                   ; i \  tmp0 = start address
0297                                                   ; i |  tmp1 = byte to fill
0298                                                   ; i /  tmp2 = number of bytes to fill
0299               
0300 7446 0204  20         li    tmp0,vdp.cmdb.toprow.tat + 240
     7448 1EE0     
0301                                                   ; VDP start address (CMDB top line + 3)
0302 744A C148  18         mov   tmp4,tmp1             ; Get work copy fg/bg color
0303 744C 0206  20         li    tmp2,1*80             ; Number of bytes to fill
     744E 0050     
0304 7450 06A0  32         bl    @xfilv                ; Fill colors
     7452 22A8     
0305                                                   ; i \  tmp0 = start address
0306                                                   ; i |  tmp1 = byte to fill
0307                                                   ; i /  tmp2 = number of bytes to fill
0308                       ;-------------------------------------------------------
0309                       ; Exit early if only CMDB needed to be colorized
0310                       ;-------------------------------------------------------
0311 7454 C120  34         mov   @parm3,tmp0
     7456 A00A     
0312 7458 0284  22         ci    tmp0,>ffff            ; Only colorize CMDB pane ?
     745A FFFF     
0313 745C 1336  14         jeq   pane.action.colorscheme.cursorcolor.cmdb
0314                                                   ; Yes, shortcut to CMDB cursor color
0315                       ;-------------------------------------------------------
0316                       ; Dump colors for error pane (TAT)
0317                       ;-------------------------------------------------------
0318               pane.action.colorscheme.errpane:
0319 745E C120  34         mov   @tv.error.visible,tmp0
     7460 A228     
0320 7462 1306  14         jeq   pane.action.colorscheme.statline
0321                                                   ; Skip if error pane is hidden
0322               
0323 7464 0205  20         li    tmp1,>00f6            ; White on dark red
     7466 00F6     
0324 7468 C805  38         mov   tmp1,@parm1           ; Pass color combination
     746A A006     
0325               
0326 746C 06A0  32         bl    @pane.errline.drawcolor
     746E 765E     
0327                                                   ; Draw color on rows in error pane
0328                                                   ; \ i  @tv.error.rows = Number of rows
0329                                                   ; / i  @parm1         = Color combination
0330                       ;-------------------------------------------------------
0331                       ; Dump colors for top line and bottom line (TAT)
0332                       ;-------------------------------------------------------
0333               pane.action.colorscheme.statline:
0334 7470 C160  34         mov   @tv.color,tmp1
     7472 A218     
0335 7474 0245  22         andi  tmp1,>00ff            ; Only keep LSB (status line colors)
     7476 00FF     
0336 7478 C805  38         mov   tmp1,@parm1           ; Set color combination
     747A A006     
0337               
0338               
0339 747C 04E0  34         clr   @parm2                ; Top row on screen
     747E A008     
0340 7480 06A0  32         bl    @colors.line.set      ; Load color combination for line
     7482 7552     
0341                                                   ; \ i  @parm1 = Color combination
0342                                                   ; / i  @parm2 = Row on physical screen
0343               
0344 7484 0205  20         li    tmp1,pane.botrow
     7486 0017     
0345 7488 C805  38         mov   tmp1,@parm2           ; Bottom row on screen
     748A A008     
0346 748C 06A0  32         bl    @colors.line.set      ; Load color combination for line
     748E 7552     
0347                                                   ; \ i  @parm1 = Color combination
0348                                                   ; / i  @parm2 = Row on physical screen
0349                       ;-------------------------------------------------------
0350                       ; Dump color for hearts in TI Basic dialog (TAT)
0351                       ;-------------------------------------------------------
0352 7490 C160  34         mov   @cmdb.dialog,tmp1
     7492 A71A     
0353 7494 0285  22         ci    tmp1,id.dialog.basic  ; TI Basic dialog active?
     7496 006B     
0354 7498 1602  14         jne   pane.action.colorscheme.ruler
0355               
0356 749A 06A0  32         bl    @tibasic.hearts.tat   ; Dump colors for hearts
     749C 7AD6     
0357                       ;-------------------------------------------------------
0358                       ; Dump colors for ruler if visible (TAT)
0359                       ;-------------------------------------------------------
0360               pane.action.colorscheme.ruler:
0361 749E C160  34         mov   @cmdb.dialog,tmp1
     74A0 A71A     
0362 74A2 0285  22         ci    tmp1,id.dialog.help   ; Help dialog active?
     74A4 0068     
0363 74A6 130A  14         jeq   pane.action.colorscheme.cursorcolor
0364                                                   ; Yes, skip ruler
0365               
0366 74A8 C160  34         mov   @tv.ruler.visible,tmp1
     74AA A210     
0367 74AC 1307  14         jeq   pane.action.colorscheme.cursorcolor
0368               
0369 74AE 06A0  32         bl    @fb.ruler.init        ; Setup ruler with tab-positions in memory
     74B0 7B18     
0370 74B2 06A0  32         bl    @cpym2v
     74B4 249A     
0371 74B6 1850                   data vdp.fb.toprow.tat
0372 74B8 A370                   data fb.ruler.tat
0373 74BA 0050                   data 80               ; Show ruler colors
0374                       ;-------------------------------------------------------
0375                       ; Dump cursor FG color to sprite table (SAT)
0376                       ;-------------------------------------------------------
0377               pane.action.colorscheme.cursorcolor:
0378 74BC C220  34         mov   @tv.curcolor,tmp4     ; Get cursor color
     74BE A216     
0379               
0380 74C0 C120  34         mov   @tv.pane.focus,tmp0   ; Get pane with focus
     74C2 A222     
0381 74C4 0284  22         ci    tmp0,pane.focus.fb    ; Frame buffer has focus?
     74C6 0000     
0382 74C8 1304  14         jeq   pane.action.colorscheme.cursorcolor.fb
0383                                                   ; Yes, set cursor color
0384               
0385               pane.action.colorscheme.cursorcolor.cmdb:
0386 74CA 0248  22         andi  tmp4,>f0              ; Only keep high-nibble -> Word 2 (G)
     74CC 00F0     
0387 74CE 0A48  56         sla   tmp4,4                ; Move to MSB
0388 74D0 1003  14         jmp   !
0389               
0390               pane.action.colorscheme.cursorcolor.fb:
0391 74D2 0248  22         andi  tmp4,>0f              ; Only keep low-nibble -> Word 2 (H)
     74D4 000F     
0392 74D6 0A88  56         sla   tmp4,8                ; Move to MSB
0393               
0394 74D8 D808  38 !       movb  tmp4,@ramsat+3        ; Update FG color in sprite table (SAT)
     74DA A059     
0395 74DC D808  38         movb  tmp4,@tv.curshape+1   ; Save cursor color
     74DE A215     
0396                       ;-------------------------------------------------------
0397                       ; Exit
0398                       ;-------------------------------------------------------
0399               pane.action.colorscheme.load.exit:
0400 74E0 06A0  32         bl    @scron                ; Turn screen on
     74E2 26A2     
0401 74E4 C839  50         mov   *stack+,@parm3        ; Pop @parm3
     74E6 A00A     
0402 74E8 C839  50         mov   *stack+,@parm2        ; Pop @parm2
     74EA A008     
0403 74EC C839  50         mov   *stack+,@parm1        ; Pop @parm1
     74EE A006     
0404 74F0 C239  30         mov   *stack+,tmp4          ; Pop tmp4
0405 74F2 C1F9  30         mov   *stack+,tmp3          ; Pop tmp3
0406 74F4 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0407 74F6 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0408 74F8 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0409 74FA C2F9  30         mov   *stack+,r11           ; Pop R11
0410 74FC 045B  20         b     *r11                  ; Return to caller
0411               
0412               
0413               
0414               ***************************************************************
0415               * pane.action.colorscheme.statline
0416               * Set color combination for bottom status line
0417               ***************************************************************
0418               * bl @pane.action.colorscheme.statlines
0419               *--------------------------------------------------------------
0420               * INPUT
0421               * @parm1 = Color combination to set
0422               *--------------------------------------------------------------
0423               * OUTPUT
0424               * none
0425               *--------------------------------------------------------------
0426               * Register usage
0427               * tmp0, tmp1, tmp2
0428               ********|*****|*********************|**************************
0429               pane.action.colorscheme.statlines:
0430 74FE 0649  14         dect  stack
0431 7500 C64B  30         mov   r11,*stack            ; Save return address
0432 7502 0649  14         dect  stack
0433 7504 C644  30         mov   tmp0,*stack           ; Push tmp0
0434                       ;------------------------------------------------------
0435                       ; Bottom line
0436                       ;------------------------------------------------------
0437 7506 0204  20         li    tmp0,pane.botrow
     7508 0017     
0438 750A C804  38         mov   tmp0,@parm2           ; Last row on screen
     750C A008     
0439 750E 06A0  32         bl    @colors.line.set      ; Load color combination for line
     7510 7552     
0440                                                   ; \ i  @parm1 = Color combination
0441                                                   ; / i  @parm2 = Row on physical screen
0442                       ;------------------------------------------------------
0443                       ; Exit
0444                       ;------------------------------------------------------
0445               pane.action.colorscheme.statlines.exit:
0446 7512 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0447 7514 C2F9  30         mov   *stack+,r11           ; Pop R11
0448 7516 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.33260
0133                       copy  "pane.cursor.asm"             ; Cursor utility functions
     **** ****     > pane.cursor.asm
0001               * FILE......: pane.cursor.asm
0002               * Purpose...: Cursor utility functions for panes
0003               
0004               ***************************************************************
0005               * pane.cursor.hide
0006               * Hide cursor
0007               ***************************************************************
0008               * bl  @pane.cursor.hide
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * OUTPUT
0014               * none
0015               *--------------------------------------------------------------
0016               * Register usage
0017               * none
0018               ********|*****|*********************|**************************
0019               pane.cursor.hide:
0020 7518 0649  14         dect  stack
0021 751A C64B  30         mov   r11,*stack            ; Save return address
0022                       ;-------------------------------------------------------
0023                       ; Hide cursor
0024                       ;-------------------------------------------------------
0025 751C 06A0  32         bl    @filv                 ; Clear sprite SAT in VDP RAM
     751E 22A2     
0026 7520 2180                   data sprsat,>00,8     ; \ i  p0 = VDP destination
     7522 0000     
     7524 0008     
0027                                                   ; | i  p1 = Byte to write
0028                                                   ; / i  p2 = Number of bytes to write
0029               
0030 7526 06A0  32         bl    @clslot
     7528 2EBE     
0031 752A 0001                   data 1                ; Terminate task.vdp.copy.sat
0032               
0033 752C 06A0  32         bl    @clslot
     752E 2EBE     
0034 7530 0002                   data 2                ; Terminate task.vdp.cursor
0035                       ;-------------------------------------------------------
0036                       ; Exit
0037                       ;-------------------------------------------------------
0038               pane.cursor.hide.exit:
0039 7532 C2F9  30         mov   *stack+,r11           ; Pop R11
0040 7534 045B  20         b     *r11                  ; Return to caller
0041               
0042               
0043               
0044               ***************************************************************
0045               * pane.cursor.blink
0046               * Blink cursor
0047               ***************************************************************
0048               * bl  @pane.cursor.blink
0049               *--------------------------------------------------------------
0050               * INPUT
0051               * none
0052               *--------------------------------------------------------------
0053               * OUTPUT
0054               * none
0055               *--------------------------------------------------------------
0056               * Register usage
0057               * none
0058               ********|*****|*********************|**************************
0059               pane.cursor.blink:
0060 7536 0649  14         dect  stack
0061 7538 C64B  30         mov   r11,*stack            ; Save return address
0062                       ;-------------------------------------------------------
0063                       ; Hide cursor
0064                       ;-------------------------------------------------------
0065 753A 06A0  32         bl    @filv                 ; Clear sprite SAT in VDP RAM
     753C 22A2     
0066 753E 2180                   data sprsat,>00,4     ; \ i  p0 = VDP destination
     7540 0000     
     7542 0004     
0067                                                   ; | i  p1 = Byte to write
0068                                                   ; / i  p2 = Number of bytes to write
0069               
0078               
0079 7544 06A0  32         bl    @mkslot
     7546 2EA0     
0080 7548 020F                   data >020f,task.vdp.cursor   ; Task 2 - Toggle cursor shape
     754A 71FE     
0081 754C FFFF                   data eol
0082               
0084               
0085                       ;-------------------------------------------------------
0086                       ; Exit
0087                       ;-------------------------------------------------------
0088               pane.cursor.blink.exit:
0089 754E C2F9  30         mov   *stack+,r11           ; Pop R11
0090 7550 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.33260
0134                       ;-----------------------------------------------------------------------
0135                       ; Screen panes
0136                       ;-----------------------------------------------------------------------
0137                       copy  "colors.line.set.asm"         ; Set color combination for line
     **** ****     > colors.line.set.asm
0001               * FILE......: colors.line.set
0002               * Purpose...: Set color combination for line
0003               
0004               ***************************************************************
0005               * colors.line.set
0006               * Set color combination for line in VDP TAT
0007               ***************************************************************
0008               * bl  @colors.line.set
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @parm1 = Foreground / Background color
0012               * @parm2 = Row on physical screen
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0,tmp1,tmp2
0019               ********|*****|*********************|**************************
0020               colors.line.set:
0021 7552 0649  14         dect  stack
0022 7554 C64B  30         mov   r11,*stack            ; Save return address
0023 7556 0649  14         dect  stack
0024 7558 C644  30         mov   tmp0,*stack           ; Push tmp0
0025 755A 0649  14         dect  stack
0026 755C C645  30         mov   tmp1,*stack           ; Push tmp1
0027 755E 0649  14         dect  stack
0028 7560 C646  30         mov   tmp2,*stack           ; Push tmp2
0029 7562 0649  14         dect  stack
0030 7564 C660  46         mov   @parm1,*stack         ; Push parm1
     7566 A006     
0031 7568 0649  14         dect  stack
0032 756A C660  46         mov   @parm2,*stack         ; Push parm2
     756C A008     
0033                       ;-------------------------------------------------------
0034                       ; Dump colors for line in TAT
0035                       ;-------------------------------------------------------
0036 756E C120  34         mov   @parm2,tmp0           ; Get target line
     7570 A008     
0037 7572 0205  20         li    tmp1,colrow           ; Columns per row (spectra2)
     7574 0050     
0038 7576 3944  56         mpy   tmp0,tmp1             ; Calculate VDP address (results in tmp2!)
0039               
0040 7578 C106  18         mov   tmp2,tmp0             ; Set VDP start address
0041 757A 0224  22         ai    tmp0,vdp.tat.base     ; Add TAT base address
     757C 1800     
0042 757E C160  34         mov   @parm1,tmp1           ; Get foreground/background color
     7580 A006     
0043 7582 0206  20         li    tmp2,80               ; Number of bytes to fill
     7584 0050     
0044               
0045 7586 06A0  32         bl    @xfilv                ; Fill colors
     7588 22A8     
0046                                                   ; i \  tmp0 = start address
0047                                                   ; i |  tmp1 = byte to fill
0048                                                   ; i /  tmp2 = number of bytes to fill
0049                       ;-------------------------------------------------------
0050                       ; Exit
0051                       ;-------------------------------------------------------
0052               colors.line.set.exit:
0053 758A C839  50         mov   *stack+,@parm2        ; Pop @parm2
     758C A008     
0054 758E C839  50         mov   *stack+,@parm1        ; Pop @parm1
     7590 A006     
0055 7592 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0056 7594 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0057 7596 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0058 7598 C2F9  30         mov   *stack+,r11           ; Pop R11
0059 759A 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.33260
0138                       copy  "pane.topline.asm"            ; Top line
     **** ****     > pane.topline.asm
0001               * FILE......: pane.topline.asm
0002               * Purpose...: Pane "status top line"
0003               
0004               ***************************************************************
0005               * pane.topline
0006               * Draw top line
0007               ***************************************************************
0008               * bl  @pane.topline
0009               *--------------------------------------------------------------
0010               * OUTPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * Register usage
0014               * tmp0
0015               ********|*****|*********************|**************************
0016               pane.topline:
0017 759C 0649  14         dect  stack
0018 759E C64B  30         mov   r11,*stack            ; Save return address
0019 75A0 0649  14         dect  stack
0020 75A2 C644  30         mov   tmp0,*stack           ; Push tmp0
0021 75A4 0649  14         dect  stack
0022 75A6 C660  46         mov   @wyx,*stack           ; Push cursor position
     75A8 832A     
0023                       ;------------------------------------------------------
0024                       ; Show current file
0025                       ;------------------------------------------------------
0026               pane.topline.file:
0027 75AA 06A0  32         bl    @at
     75AC 26DA     
0028 75AE 0000                   byte 0,0              ; y=0, x=0
0029               
0030 75B0 C820  54         mov   @edb.filename.ptr,@parm1
     75B2 A512     
     75B4 A006     
0031                                                   ; Get string to display
0032 75B6 0204  20         li    tmp0,47
     75B8 002F     
0033 75BA C804  38         mov   tmp0,@parm2           ; Set requested length
     75BC A008     
0034 75BE 0204  20         li    tmp0,32
     75C0 0020     
0035 75C2 C804  38         mov   tmp0,@parm3           ; Set character to fill
     75C4 A00A     
0036 75C6 0204  20         li    tmp0,rambuf
     75C8 A100     
0037 75CA C804  38         mov   tmp0,@parm4           ; Set pointer to buffer for output string
     75CC A00C     
0038               
0039               
0040 75CE 06A0  32         bl    @tv.pad.string        ; Pad string to specified length
     75D0 3318     
0041                                                   ; \ i  @parm1 = Pointer to string
0042                                                   ; | i  @parm2 = Requested length
0043                                                   ; | i  @parm3 = Fill characgter
0044                                                   ; | i  @parm4 = Pointer to buffer with
0045                                                   ; /             output string
0046               
0047 75D2 C160  34         mov   @outparm1,tmp1        ; \ Display padded filename
     75D4 A016     
0048 75D6 06A0  32         bl    @xutst0               ; /
     75D8 2434     
0049                       ;------------------------------------------------------
0050                       ; Show if text was changed in editor buffer
0051                       ;------------------------------------------------------
0052               pane.topline.show_dirty:
0053 75DA C120  34         mov   @edb.dirty,tmp0
     75DC A506     
0054 75DE 1305  14         jeq   pane.topline.nochange
0055                       ;------------------------------------------------------
0056                       ; Show "*"
0057                       ;------------------------------------------------------
0058 75E0 06A0  32         bl    @putat
     75E2 2456     
0059 75E4 004F                   byte 0,79             ; y=0, x=79
0060 75E6 36FC                   data txt.star
0061 75E8 1004  14         jmp   pane.topline.showmarkers
0062                       ;------------------------------------------------------
0063                       ; Show " "
0064                       ;------------------------------------------------------
0065               pane.topline.nochange:
0066 75EA 06A0  32         bl    @putat
     75EC 2456     
0067 75EE 004F                   byte 0,79             ; y=0, x=79
0068 75F0 39CE                   data txt.ws1          ; Single white space
0069                       ;------------------------------------------------------
0070                       ; Check if M1/M2 markers need to be shown
0071                       ;------------------------------------------------------
0072               pane.topline.showmarkers:
0073 75F2 C120  34         mov   @edb.block.m1,tmp0    ; \
     75F4 A50C     
0074 75F6 0284  22         ci    tmp0,>ffff            ; | Exit early if M1 unset (>ffff)
     75F8 FFFF     
0075 75FA 132C  14         jeq   pane.topline.exit     ; /
0076               
0077 75FC C120  34         mov   @tv.task.oneshot,tmp0 ; \
     75FE A224     
0078 7600 0284  22         ci    tmp0,pane.topline.oneshot.clearmsg
     7602 3630     
0079                                                   ; | Exit early if overlay message visible
0080 7604 1327  14         jeq   pane.topline.exit     ; /
0081                       ;------------------------------------------------------
0082                       ; Show M1 marker
0083                       ;------------------------------------------------------
0084 7606 06A0  32         bl    @putat
     7608 2456     
0085 760A 0034                   byte 0,52
0086 760C 38DA                   data txt.m1           ; Show M1 marker message
0087               
0088 760E C820  54         mov   @edb.block.m1,@parm1
     7610 A50C     
     7612 A006     
0089 7614 06A0  32         bl    @tv.unpack.uint16     ; Unpack 16 bit unsigned integer to string
     7616 32EC     
0090                                                   ; \ i @parm1           = uint16
0091                                                   ; / o @unpacked.string = Output string
0092               
0093 7618 0204  20         li    tmp0,>0500
     761A 0500     
0094 761C D804  38         movb  tmp0,@unpacked.string ; Set string length to 5 (padding)
     761E A02C     
0095               
0096 7620 06A0  32         bl    @putat
     7622 2456     
0097 7624 0037                   byte 0,55
0098 7626 A02C                   data unpacked.string  ; Show M1 value
0099                       ;------------------------------------------------------
0100                       ; Show M2 marker
0101                       ;------------------------------------------------------
0102 7628 C120  34         mov   @edb.block.m2,tmp0    ; \
     762A A50E     
0103 762C 0284  22         ci    tmp0,>ffff            ; | Exit early if M2 unset (>ffff)
     762E FFFF     
0104 7630 1311  14         jeq   pane.topline.exit     ; /
0105               
0106 7632 06A0  32         bl    @putat
     7634 2456     
0107 7636 003E                   byte 0,62
0108 7638 38DE                   data txt.m2           ; Show M2 marker message
0109               
0110 763A C820  54         mov   @edb.block.m2,@parm1
     763C A50E     
     763E A006     
0111 7640 06A0  32         bl    @tv.unpack.uint16     ; Unpack 16 bit unsigned integer to string
     7642 32EC     
0112                                                   ; \ i @parm1           = uint16
0113                                                   ; / o @unpacked.string = Output string
0114               
0115 7644 0204  20         li    tmp0,>0500
     7646 0500     
0116 7648 D804  38         movb  tmp0,@unpacked.string ; Set string length to 5 (padding)
     764A A02C     
0117               
0118 764C 06A0  32         bl    @putat
     764E 2456     
0119 7650 0041                   byte 0,65
0120 7652 A02C                   data unpacked.string  ; Show M2 value
0121                       ;------------------------------------------------------
0122                       ; Exit
0123                       ;------------------------------------------------------
0124               pane.topline.exit:
0125 7654 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     7656 832A     
0126 7658 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0127 765A C2F9  30         mov   *stack+,r11           ; Pop r11
0128 765C 045B  20         b     *r11                  ; Return
                   < stevie_b1.asm.33260
0139                       copy  "pane.errline.asm"            ; Error line
     **** ****     > pane.errline.asm
0001               * FILE......: pane.errline.asm
0002               * Purpose...: Utilities for error lines
0003               
0004               ***************************************************************
0005               * pane.errline.drawcolor
0006               * Draw color on rows in error pane
0007               ***************************************************************
0008               * bl @pane.errline.drawcolor
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @tv.error.rows = Number of rows in error pane
0012               * @parm1         = Color combination
0013               *--------------------------------------------------------------
0014               * OUTPUT
0015               * none
0016               *--------------------------------------------------------------
0017               * Register usage
0018               * tmp0,tmp1,tmp2
0019               *--------------------------------------------------------------
0020               * Notes
0021               ********|*****|*********************|**************************
0022               pane.errline.drawcolor:
0023 765E 0649  14         dect  stack
0024 7660 C64B  30         mov   r11,*stack            ; Save return address
0025 7662 0649  14         dect  stack
0026 7664 C644  30         mov   tmp0,*stack           ; Push tmp0
0027 7666 0649  14         dect  stack
0028 7668 C645  30         mov   tmp1,*stack           ; Push tmp1
0029 766A 0649  14         dect  stack
0030 766C C646  30         mov   tmp2,*stack           ; Push tmp2
0031                       ;-------------------------------------------------------
0032                       ; Determine 1st row in error pane
0033                       ;-------------------------------------------------------
0034 766E 0204  20         li    tmp0,pane.botrow      ; Get rows on screen
     7670 0017     
0035 7672 C144  18         mov   tmp0,tmp1             ; \ Get first row in error pane
0036 7674 6160  34         s     @tv.error.rows,tmp1   ; /
     7676 A22A     
0037                       ;-------------------------------------------------------
0038                       ; Dump colors for row
0039                       ;-------------------------------------------------------
0040               pane.errline.drawcolor.loop:
0041 7678 C805  38         mov   tmp1,@parm2           ; Row on physical screen
     767A A008     
0042               
0043 767C 06A0  32         bl    @colors.line.set      ; Load color combination for line
     767E 7552     
0044                                                   ; \ i  @parm1 = Color combination
0045                                                   ; / i  @parm2 = Row on physical screen
0046               
0047 7680 0585  14         inc   tmp1                  ; Next row
0048 7682 8105  18         c     tmp1,tmp0             ; Last row reached?
0049 7684 11F9  14         jlt   pane.errline.drawcolor.loop
0050                                                   ; Not yet, next iteration
0051                       ;-------------------------------------------------------
0052                       ; Exit
0053                       ;-------------------------------------------------------
0054               pane.errline.drawcolor.exit:
0055 7686 C1B9  30         mov   *stack+,tmp2          ; Pop tmp2
0056 7688 C179  30         mov   *stack+,tmp1          ; Pop tmp1
0057 768A C139  30         mov   *stack+,tmp0          ; Pop tmp0
0058 768C C2F9  30         mov   *stack+,r11           ; Pop R11
0059 768E 045B  20         b     *r11                  ; Return to caller
0060               
0061               
0062               
0063               
0064               ***************************************************************
0065               * pane.errline.show
0066               * Show command buffer pane
0067               ***************************************************************
0068               * bl @pane.errline.show
0069               *--------------------------------------------------------------
0070               * INPUT
0071               * @tv.error.msg = Error message to display
0072               *--------------------------------------------------------------
0073               * OUTPUT
0074               * none
0075               *--------------------------------------------------------------
0076               * Register usage
0077               * tmp0,tmp1
0078               *--------------------------------------------------------------
0079               * Notes
0080               ********|*****|*********************|**************************
0081               pane.errline.show:
0082 7690 0649  14         dect  stack
0083 7692 C64B  30         mov   r11,*stack            ; Save return address
0084 7694 0649  14         dect  stack
0085 7696 C644  30         mov   tmp0,*stack           ; Push tmp0
0086 7698 0649  14         dect  stack
0087 769A C645  30         mov   tmp1,*stack           ; Push tmp1
0088               
0089 769C 0205  20         li    tmp1,>00f6            ; White on dark red
     769E 00F6     
0090 76A0 C805  38         mov   tmp1,@parm1
     76A2 A006     
0091               
0092 76A4 06A0  32         bl    @pane.errline.drawcolor
     76A6 765E     
0093                                                   ; Draw color on rows in error pane
0094                                                   ; \ i  @tv.error.rows = Number of rows
0095                                                   ; / i  @parm1         = Color combination
0096                       ;------------------------------------------------------
0097                       ; Pad error message up to 160 characters
0098                       ;------------------------------------------------------
0099 76A8 0204  20         li    tmp0,tv.error.msg
     76AA A230     
0100 76AC C804  38         mov   tmp0,@parm1           ; Get pointer to string
     76AE A006     
0101               
0102 76B0 0204  20         li    tmp0,240
     76B2 00F0     
0103 76B4 C804  38         mov   tmp0,@parm2           ; Set requested length
     76B6 A008     
0104               
0105 76B8 0204  20         li    tmp0,32
     76BA 0020     
0106 76BC C804  38         mov   tmp0,@parm3           ; Set character to fill
     76BE A00A     
0107               
0108 76C0 0204  20         li    tmp0,rambuf
     76C2 A100     
0109 76C4 C804  38         mov   tmp0,@parm4           ; Set pointer to buffer for output string
     76C6 A00C     
0110               
0111 76C8 06A0  32         bl    @tv.pad.string        ; Pad string to specified length
     76CA 3318     
0112                                                   ; \ i  @parm1 = Pointer to string
0113                                                   ; | i  @parm2 = Requested length
0114                                                   ; | i  @parm3 = Fill character
0115                                                   ; | i  @parm4 = Pointer to buffer with
0116                                                   ; /             output string
0117                       ;------------------------------------------------------
0118                       ; Show error message
0119                       ;------------------------------------------------------
0120 76CC 06A0  32         bl    @at
     76CE 26DA     
0121 76D0 1400                   byte pane.botrow-3,0  ; Set cursor
0122               
0123 76D2 C160  34         mov   @outparm1,tmp1        ; \ Display error message
     76D4 A016     
0124 76D6 06A0  32         bl    @xutst0               ; /
     76D8 2434     
0125               
0126 76DA C120  34         mov   @fb.scrrows.max,tmp0  ; \
     76DC A31E     
0127 76DE 6120  34         s     @tv.error.rows,tmp0   ; | Adjust number of rows in frame buffer
     76E0 A22A     
0128 76E2 C804  38         mov   tmp0,@fb.scrrows      ; /
     76E4 A31C     
0129               
0130 76E6 0720  34         seto  @tv.error.visible     ; Error line is visible
     76E8 A228     
0131                       ;------------------------------------------------------
0132                       ; Exit
0133                       ;------------------------------------------------------
0134               pane.errline.show.exit:
0135 76EA C179  30         mov   *stack+,tmp1          ; Pop tmp1
0136 76EC C139  30         mov   *stack+,tmp0          ; Pop tmp0
0137 76EE C2F9  30         mov   *stack+,r11           ; Pop r11
0138 76F0 045B  20         b     *r11                  ; Return to caller
0139               
0140               
0141               
0142               ***************************************************************
0143               * pane.errline.hide
0144               * Hide error line
0145               ***************************************************************
0146               * bl @pane.errline.hide
0147               *--------------------------------------------------------------
0148               * INPUT
0149               * none
0150               *--------------------------------------------------------------
0151               * OUTPUT
0152               * none
0153               *--------------------------------------------------------------
0154               * Register usage
0155               * none
0156               *--------------------------------------------------------------
0157               * Hiding the error line passes pane focus to frame buffer.
0158               ********|*****|*********************|**************************
0159               pane.errline.hide:
0160 76F2 0649  14         dect  stack
0161 76F4 C64B  30         mov   r11,*stack            ; Save return address
0162 76F6 0649  14         dect  stack
0163 76F8 C644  30         mov   tmp0,*stack           ; Push tmp0
0164                       ;------------------------------------------------------
0165                       ; Get color combination
0166                       ;------------------------------------------------------
0167 76FA 06A0  32         bl    @errpane.init         ; Clear error line string in RAM
     76FC 323E     
0168               
0169 76FE C120  34         mov   @cmdb.visible,tmp0
     7700 A702     
0170 7702 1303  14         jeq   pane.errline.hide.fbcolor
0171                       ;------------------------------------------------------
0172                       ; CMDB pane color
0173                       ;------------------------------------------------------
0174 7704 C120  34         mov   @tv.cmdb.hcolor,tmp0  ; Get colors of CMDB header line
     7706 A220     
0175 7708 1003  14         jmp   !
0176                       ;------------------------------------------------------
0177                       ; Frame buffer color
0178                       ;------------------------------------------------------
0179               pane.errline.hide.fbcolor:
0180 770A C120  34         mov   @tv.color,tmp0        ; Get colors
     770C A218     
0181 770E 0984  56         srl   tmp0,8                ; Get rid of status line colors
0182                       ;------------------------------------------------------
0183                       ; Dump colors
0184                       ;------------------------------------------------------
0185 7710 C804  38 !       mov   tmp0,@parm1           ; set foreground/background color
     7712 A006     
0186               
0187 7714 06A0  32         bl    @pane.errline.drawcolor
     7716 765E     
0188                                                   ; Draw color on rows in error pane
0189                                                   ; \ i  @tv.error.rows = Number of rows
0190                                                   ; / i  @parm1         = Color combination
0191               
0192 7718 04E0  34         clr   @tv.error.visible     ; Error line no longer visible
     771A A228     
0193 771C C820  54         mov   @fb.scrrows.max,@fb.scrrows
     771E A31E     
     7720 A31C     
0194                                                   ; Set frame buffer to full size again
0195                       ;------------------------------------------------------
0196                       ; Exit
0197                       ;------------------------------------------------------
0198               pane.errline.hide.exit:
0199 7722 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0200 7724 C2F9  30         mov   *stack+,r11           ; Pop r11
0201 7726 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.33260
0140                       copy  "pane.botline.asm"            ; Bottom line
     **** ****     > pane.botline.asm
0001               * FILE......: pane.botline.asm
0002               * Purpose...: Pane "status bottom line"
0003               
0004               ***************************************************************
0005               * pane.botline
0006               * Draw Stevie bottom line
0007               ***************************************************************
0008               * bl  @pane.botline
0009               *--------------------------------------------------------------
0010               * OUTPUT
0011               * none
0012               *--------------------------------------------------------------
0013               * Register usage
0014               * tmp0
0015               ********|*****|*********************|**************************
0016               pane.botline:
0017 7728 0649  14         dect  stack
0018 772A C64B  30         mov   r11,*stack            ; Save return address
0019 772C 0649  14         dect  stack
0020 772E C644  30         mov   tmp0,*stack           ; Push tmp0
0021 7730 0649  14         dect  stack
0022 7732 C660  46         mov   @wyx,*stack           ; Push cursor position
     7734 832A     
0023                       ;------------------------------------------------------
0024                       ; Show block shortcuts if set
0025                       ;------------------------------------------------------
0026 7736 C120  34         mov   @edb.block.m2,tmp0    ; \
     7738 A50E     
0027 773A 0584  14         inc   tmp0                  ; | Skip if M2 unset (>ffff)
0028                                                   ; /
0029 773C 1305  14         jeq   pane.botline.show_keys
0030               
0031 773E 06A0  32         bl    @putat
     7740 2456     
0032 7742 1700                   byte pane.botrow,0
0033 7744 3910                   data txt.keys.block   ; Show block shortcuts
0034               
0035 7746 100B  14         jmp   pane.botline.show_mode
0036                       ;------------------------------------------------------
0037                       ; Show default message
0038                       ;------------------------------------------------------
0039               pane.botline.show_keys:
0040 7748 C120  34         mov   @tib.session,tmp0     ; Active TI Basic session?
     774A A0B4     
0041 774C 1304  14         jeq   !
0042               
0043 774E 06A0  32         bl    @putat
     7750 2456     
0044 7752 1700                   byte pane.botrow,0
0045 7754 38F4                   data txt.keys.defaultb
0046                                                   ; Show defaults TI Basic
0047                       ;------------------------------------------------------
0048                       ; Show default keys
0049                       ;------------------------------------------------------
0050 7756 06A0  32 !       bl    @putat
     7758 2456     
0051 775A 1700                   byte pane.botrow,0
0052 775C 38E2                   data txt.keys.default ; Show default keys
0053                       ;------------------------------------------------------
0054                       ; Show text editing mode
0055                       ;------------------------------------------------------
0056               pane.botline.show_mode:
0057 775E C120  34         mov   @edb.insmode,tmp0
     7760 A50A     
0058 7762 1605  14         jne   pane.botline.show_mode.insert
0059                       ;------------------------------------------------------
0060                       ; Overwrite mode
0061                       ;------------------------------------------------------
0062 7764 06A0  32         bl    @putat
     7766 2456     
0063 7768 1737                   byte  pane.botrow,55
0064 776A 36F4                   data  txt.ovrwrite
0065 776C 1004  14         jmp   pane.botline.show_linecol
0066                       ;------------------------------------------------------
0067                       ; Insert mode
0068                       ;------------------------------------------------------
0069               pane.botline.show_mode.insert:
0070 776E 06A0  32         bl    @putat
     7770 2456     
0071 7772 1737                   byte  pane.botrow,55
0072 7774 36F8                   data  txt.insert
0073                       ;------------------------------------------------------
0074                       ; Show "line,column"
0075                       ;------------------------------------------------------
0076               pane.botline.show_linecol:
0077 7776 C820  54         mov   @fb.row,@parm1
     7778 A306     
     777A A006     
0078 777C 06A0  32         bl    @fb.row2line          ; Row to editor line
     777E 307A     
0079                                                   ; \ i @fb.topline = Top line in frame buffer
0080                                                   ; | i @parm1      = Row in frame buffer
0081                                                   ; / o @outparm1   = Matching line in EB
0082               
0083 7780 05A0  34         inc   @outparm1             ; Add base 1
     7782 A016     
0084                       ;------------------------------------------------------
0085                       ; Show line
0086                       ;------------------------------------------------------
0087 7784 06A0  32         bl    @putnum
     7786 2A38     
0088 7788 173B                   byte  pane.botrow,59  ; YX
0089 778A A016                   data  outparm1,rambuf
     778C A100     
0090 778E 30                     byte  48              ; ASCII offset
0091 778F   20                   byte  32              ; Padding character
0092                       ;------------------------------------------------------
0093                       ; Show comma
0094                       ;------------------------------------------------------
0095 7790 06A0  32         bl    @putat
     7792 2456     
0096 7794 1740                   byte  pane.botrow,64
0097 7796 36EC                   data  txt.delim
0098                       ;------------------------------------------------------
0099                       ; Show column
0100                       ;------------------------------------------------------
0101 7798 06A0  32         bl    @film
     779A 224A     
0102 779C A105                   data rambuf+5,32,12   ; Clear work buffer with space character
     779E 0020     
     77A0 000C     
0103               
0104 77A2 C120  34         mov   @fb.column,tmp0       ; Get column
     77A4 A30C     
0105 77A6 A120  34         a     @fb.vwco,tmp0         ; Add view window column offset
     77A8 A310     
0106 77AA 0584  14         inc   tmp0                  ; Offset 1
0107 77AC C804  38         mov   tmp0,@waux1           ; Save in temporary
     77AE 833C     
0108               
0109 77B0 06A0  32         bl    @mknum                ; Convert unsigned number to string
     77B2 29BA     
0110 77B4 833C                   data  waux1,rambuf
     77B6 A100     
0111 77B8 30                     byte  48              ; ASCII offset
0112 77B9   20                   byte  32              ; Fill character
0113               
0114 77BA 06A0  32         bl    @trimnum              ; Trim number to the left
     77BC 2A12     
0115 77BE A100                   data  rambuf,rambuf+5,32
     77C0 A105     
     77C2 0020     
0116               
0117 77C4 0204  20         li    tmp0,>0600            ; "Fix" number length to clear junk chars
     77C6 0600     
0118 77C8 D804  38         movb  tmp0,@rambuf+5        ; Set length byte
     77CA A105     
0119               
0120                       ;------------------------------------------------------
0121                       ; Decide if row length is to be shown
0122                       ;------------------------------------------------------
0123 77CC C120  34         mov   @fb.column,tmp0       ; \ Base 1 for comparison
     77CE A30C     
0124 77D0 A120  34         a     @fb.vwco,tmp0         ; | Add view window column offset
     77D2 A310     
0125 77D4 0584  14         inc   tmp0                  ; /
0126 77D6 8804  38         c     tmp0,@fb.row.length   ; Check if cursor on last column on row
     77D8 A308     
0127 77DA 1101  14         jlt   pane.botline.show_linecol.linelen
0128 77DC 102E  14         jmp   pane.botline.show_linecol.colstring
0129                                                   ; Yes, skip showing row length
0130                       ;------------------------------------------------------
0131                       ; Add ',' delimiter and length of line to string
0132                       ;------------------------------------------------------
0133               pane.botline.show_linecol.linelen:
0134 77DE C120  34         mov   @fb.column,tmp0       ; \
     77E0 A30C     
0135 77E2 A120  34         a     @fb.vwco,tmp0         ; | Add view window column offset
     77E4 A310     
0136 77E6 0205  20         li    tmp1,rambuf+7         ; | Determine column position for '/' char
     77E8 A107     
0137 77EA 0284  22         ci    tmp0,9                ; | based on number of digits in cursor X
     77EC 0009     
0138 77EE 1101  14         jlt   !                     ; | column.
0139 77F0 0585  14         inc   tmp1                  ; /
0140               
0141 77F2 0204  20 !       li    tmp0,>2f00            ; \ ASCII '/'
     77F4 2F00     
0142 77F6 DD44  32         movb  tmp0,*tmp1+           ; / Add delimiter to string
0143               
0144 77F8 C805  38         mov   tmp1,@waux1           ; Backup position in ram buffer
     77FA 833C     
0145               
0146 77FC 06A0  32         bl    @mknum
     77FE 29BA     
0147 7800 A308                   data  fb.row.length,rambuf
     7802 A100     
0148 7804 30                     byte  48              ; ASCII offset
0149 7805   20                   byte  32              ; Padding character
0150               
0151 7806 C160  34         mov   @waux1,tmp1           ; Restore position in ram buffer
     7808 833C     
0152               
0153 780A C120  34         mov   @fb.row.length,tmp0   ; \ Get length of line
     780C A308     
0154 780E 0284  22         ci    tmp0,10               ; /
     7810 000A     
0155 7812 110C  14         jlt   pane.botline.show_line.1digit
0156                       ;------------------------------------------------------
0157                       ; Assert
0158                       ;------------------------------------------------------
0159 7814 0284  22         ci    tmp0,99
     7816 0063     
0160 7818 1205  14         jle   pane.botline.show_line.2digits
0161                       ;------------------------------------------------------
0162                       ; Show length of line (3 digits)
0163                       ;------------------------------------------------------
0164               pane.botline.show_line.3digits:
0165 781A 0204  20         li    tmp0,rambuf+2
     781C A102     
0166 781E DD74  42         movb  *tmp0+,*tmp1+         ; 1st digit row length
0167 7820 DD74  42         movb  *tmp0+,*tmp1+         ; 2nd digit row length
0168 7822 1006  14         jmp   pane.botline.show_line.rest
0169                       ;------------------------------------------------------
0170                       ; Show length of line (2 digits)
0171                       ;------------------------------------------------------
0172               pane.botline.show_line.2digits:
0173 7824 0204  20         li    tmp0,rambuf+3
     7826 A103     
0174 7828 DD74  42         movb  *tmp0+,*tmp1+         ; 1st digit row length
0175 782A 1002  14         jmp   pane.botline.show_line.rest
0176                       ;------------------------------------------------------
0177                       ; Show length of line (1 digit)
0178                       ;------------------------------------------------------
0179               pane.botline.show_line.1digit:
0180 782C 0204  20         li    tmp0,rambuf+4
     782E A104     
0181               pane.botline.show_line.rest:
0182 7830 DD74  42         movb  *tmp0+,*tmp1+         ; 1st/Next digit row length
0183 7832 DD60  48         movb  @rambuf+0,*tmp1+      ; Append a whitespace character
     7834 A100     
0184 7836 DD60  48         movb  @rambuf+0,*tmp1+      ; Append a whitespace character
     7838 A100     
0185                       ;------------------------------------------------------
0186                       ; Show column string
0187                       ;------------------------------------------------------
0188               pane.botline.show_linecol.colstring:
0189 783A 06A0  32         bl    @putat
     783C 2456     
0190 783E 1741                   byte pane.botrow,65
0191 7840 A105                   data rambuf+5         ; Show string
0192                       ;------------------------------------------------------
0193                       ; Show lines in buffer unless on last line in file
0194                       ;------------------------------------------------------
0195 7842 C820  54         mov   @fb.row,@parm1
     7844 A306     
     7846 A006     
0196 7848 06A0  32         bl    @fb.row2line
     784A 307A     
0197 784C 8820  54         c     @edb.lines,@outparm1
     784E A504     
     7850 A016     
0198 7852 1605  14         jne   pane.botline.show_lines_in_buffer
0199               
0200 7854 06A0  32         bl    @putat
     7856 2456     
0201 7858 1748                   byte pane.botrow,72
0202 785A 36EE                   data txt.bottom
0203               
0204 785C 1009  14         jmp   pane.botline.exit
0205                       ;------------------------------------------------------
0206                       ; Show lines in buffer
0207                       ;------------------------------------------------------
0208               pane.botline.show_lines_in_buffer:
0209 785E C820  54         mov   @edb.lines,@waux1
     7860 A504     
     7862 833C     
0210               
0211 7864 06A0  32         bl    @putnum
     7866 2A38     
0212 7868 1748                   byte pane.botrow,72   ; YX
0213 786A 833C                   data waux1,rambuf
     786C A100     
0214 786E 30                     byte 48
0215 786F   20                   byte 32
0216                       ;------------------------------------------------------
0217                       ; Exit
0218                       ;------------------------------------------------------
0219               pane.botline.exit:
0220 7870 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     7872 832A     
0221 7874 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0222 7876 C2F9  30         mov   *stack+,r11           ; Pop r11
0223 7878 045B  20         b     *r11                  ; Return
                   < stevie_b1.asm.33260
0141                       copy  "pane.vdpdump.asm"            ; Dump panes to VDP memory
     **** ****     > pane.vdpdump.asm
0001               * FILE......: pane.vdpdump.asm
0002               * Purpose...: Dump all panes to VDP
0003               
0004               ***************************************************************
0005               * pane.vdpdump
0006               * Dump all panes to VDP
0007               ***************************************************************
0008               * bl @pane.vdpdump
0009               *--------------------------------------------------------------
0010               * INPUT
0011               * @fb.dirty         = Refresh frame buffer if set
0012               * @fb.status.dirty  = Refresh top/bottom status lines if set
0013               * @fb.colorize      = Colorize range M1/M2 if set
0014               * @cmdb.dirty       = Refresh command buffer pane if set
0015               * @tv.ruler.visible = Show ruler below top status line if set
0016               *--------------------------------------------------------------
0017               * OUTPUT
0018               * none
0019               *--------------------------------------------------------------
0020               * Register usage
0021               * tmp0,tmp1,tmp2
0022               ********|*****|*********************|**************************
0023               pane.vdpdump:
0024 787A 0649  14         dect  stack
0025 787C C64B  30         mov   r11,*stack            ; Save return address
0026 787E 0649  14         dect  stack
0027 7880 C644  30         mov   tmp0,*stack           ; Push tmp0
0028 7882 0649  14         dect  stack
0029 7884 C660  46         mov   @wyx,*stack           ; Push cursor position
     7886 832A     
0030                       ;------------------------------------------------------
0031                       ; ALPHA-Lock key down?
0032                       ;------------------------------------------------------
0033               pane.vdpdump.alpha_lock:
0034 7888 20A0  38         coc   @wbit10,config
     788A 200C     
0035 788C 1305  14         jeq   pane.vdpdump.alpha_lock.down
0036                       ;------------------------------------------------------
0037                       ; AlPHA-Lock is up
0038                       ;------------------------------------------------------
0039 788E 06A0  32         bl    @putat
     7890 2456     
0040 7892 174E                   byte pane.botrow,78
0041 7894 39D8                   data txt.ws4
0042 7896 1004  14         jmp   pane.vdpdump.cmdb.check
0043                       ;------------------------------------------------------
0044                       ; AlPHA-Lock is down
0045                       ;------------------------------------------------------
0046               pane.vdpdump.alpha_lock.down:
0047 7898 06A0  32         bl    @putat
     789A 2456     
0048 789C 174E                   byte pane.botrow,78
0049 789E 39C6                   data txt.alpha.down
0050                       ;------------------------------------------------------
0051                       ; Command buffer visible ?
0052                       ;------------------------------------------------------
0053               pane.vdpdump.cmdb.check
0054 78A0 C120  34         mov   @cmdb.visible,tmp0    ; CMDB pane visible ?
     78A2 A702     
0055 78A4 1324  14         jeq   !                     ; No, skip CMDB pane
0056                       ;-------------------------------------------------------
0057                       ; Draw command buffer pane if dirty
0058                       ;-------------------------------------------------------
0059               pane.vdpdump.cmdb.draw:
0060 78A6 C120  34         mov   @cmdb.dirty,tmp0      ; Command buffer dirty?
     78A8 A718     
0061 78AA 1343  14         jeq   pane.vdpdump.exit     ; No, skip update
0062                       ;-------------------------------------------------------
0063                       ; "one-time only" flag set?
0064                       ;-------------------------------------------------------
0065 78AC 0284  22         ci    tmp0,tv.1timeonly
     78AE 00FE     
0066 78B0 1619  14         jne   pane.vdpdump.cmdb.draw.content
0067                                                   ; No, skip CMDB colorization
0068                       ;-------------------------------------------------------
0069                       ; Colorize the CMDB pane
0070                       ;-------------------------------------------------------
0071               pane.vdpdump.cmdb.draw.colorscheme:
0072 78B2 0649  14         dect  stack
0073 78B4 C660  46         mov   @parm1,*stack         ; Push @parm1
     78B6 A006     
0074 78B8 0649  14         dect  stack
0075 78BA C660  46         mov   @parm2,*stack         ; Push @parm2
     78BC A008     
0076 78BE 0649  14         dect  stack
0077 78C0 C660  46         mov   @parm3,*stack         ; Push @parm3
     78C2 A00A     
0078               
0079 78C4 0720  34         seto  @parm1                ; Do not turn screen off
     78C6 A006     
0080 78C8 0720  34         seto  @parm2                ; Skip colorzing marked lines
     78CA A008     
0081 78CC 0720  34         seto  @parm3                ; Only colorize CMDB pane
     78CE A00A     
0082               
0083 78D0 06A0  32         bl    @pane.action.colorscheme.load
     78D2 72FE     
0084                                                   ; Reload color scheme
0085                                                   ; \ i  @parm1 = Skip screen off if >FFFF
0086                                                   ; | i  @parm2 = Skip colorizing marked lines
0087                                                   ; |             if >FFFF
0088                                                   ; | i  @parm3 = Only colorize CMDB pane
0089                                                   ; /             if >FFFF
0090               
0091 78D4 C839  50         mov   *stack+,@parm3        ; Pop @parm3
     78D6 A00A     
0092 78D8 C839  50         mov   *stack+,@parm2        ; Pop @parm2
     78DA A008     
0093 78DC C839  50         mov   *stack+,@parm1        ; Pop @parm1
     78DE A006     
0094               
0095 78E0 0720  34         seto  @cmdb.dirty           ; Remove special "one-time only" flag
     78E2 A718     
0096                       ;-------------------------------------------------------
0097                       ; Show content in CMDB pane
0098                       ;-------------------------------------------------------
0099               pane.vdpdump.cmdb.draw.content:
0100 78E4 06A0  32         bl    @pane.cmdb.draw       ; Draw CMDB pane
     78E6 7A9A     
0101 78E8 04E0  34         clr   @cmdb.dirty           ; Reset CMDB dirty flag
     78EA A718     
0102 78EC 1022  14         jmp   pane.vdpdump.exit     ; Exit early
0103                       ;-------------------------------------------------------
0104                       ; Check if frame buffer dirty
0105                       ;-------------------------------------------------------
0106 78EE C120  34 !       mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
     78F0 A318     
0107 78F2 130E  14         jeq   pane.vdpdump.statlines
0108                                                   ; No, skip update
0109 78F4 C820  54         mov   @fb.scrrows,@parm1    ; Number of lines to dump
     78F6 A31C     
     78F8 A006     
0110               
0111               pane.vdpdump.dump:
0112 78FA 06A0  32         bl    @fb.vdpdump           ; Dump frame buffer to VDP SIT
     78FC 7B3C     
0113                                                   ; \ i  @parm1 = number of lines to dump
0114                                                   ; /
0115                       ;------------------------------------------------------
0116                       ; Color the lines in the framebuffer (TAT)
0117                       ;------------------------------------------------------
0118 78FE C120  34         mov   @fb.colorize,tmp0     ; Check if colorization necessary
     7900 A312     
0119 7902 1302  14         jeq   pane.vdpdump.dumped   ; Skip if flag reset
0120               
0121 7904 06A0  32         bl    @fb.colorlines        ; Colorize lines M1/M2
     7906 7B2A     
0122                       ;-------------------------------------------------------
0123                       ; Finished with frame buffer
0124                       ;-------------------------------------------------------
0125               pane.vdpdump.dumped:
0126 7908 04E0  34         clr   @fb.dirty             ; Reset framebuffer dirty flag
     790A A318     
0127 790C 0720  34         seto  @fb.status.dirty      ; Do trigger status lines update
     790E A31A     
0128                       ;-------------------------------------------------------
0129                       ; Refresh top and bottom line
0130                       ;-------------------------------------------------------
0131               pane.vdpdump.statlines:
0132 7910 C120  34         mov   @fb.status.dirty,tmp0 ; Are status lines dirty?
     7912 A31A     
0133 7914 130E  14         jeq   pane.vdpdump.exit     ; No, skip update
0134               
0135 7916 06A0  32         bl    @pane.topline         ; Draw top line
     7918 759C     
0136 791A 06A0  32         bl    @pane.botline         ; Draw bottom line
     791C 7728     
0137 791E 04E0  34         clr   @fb.status.dirty      ; Reset status lines dirty flag
     7920 A31A     
0138                       ;------------------------------------------------------
0139                       ; Show ruler with tab positions
0140                       ;------------------------------------------------------
0141 7922 C120  34         mov   @tv.ruler.visible,tmp0
     7924 A210     
0142                                                   ; Should ruler be visible?
0143 7926 1305  14         jeq   pane.vdpdump.exit     ; No, so exit
0144               
0145 7928 06A0  32         bl    @cpym2v
     792A 249A     
0146 792C 0050                   data vdp.fb.toprow.sit
0147 792E A320                   data fb.ruler.sit
0148 7930 0050                   data 80               ; Show ruler
0149                       ;------------------------------------------------------
0150                       ; Exit task
0151                       ;------------------------------------------------------
0152               pane.vdpdump.exit:
0153 7932 C839  50         mov   *stack+,@wyx          ; Pop cursor position
     7934 832A     
0154 7936 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0155 7938 C2F9  30         mov   *stack+,r11           ; Pop r11
0156 793A 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.33260
0142                       ;-----------------------------------------------------------------------
0143                       ; Stubs
0144                       ;-----------------------------------------------------------------------
0145                       copy  "rom.stubs.bank1.asm"         ; Bank specific stubs
     **** ****     > rom.stubs.bank1.asm
0001               * FILE......: rom.stubs.bank1.asm
0002               * Purpose...: Bank 1 stubs for functions in other banks
0003               
0004               ***************************************************************
0005               * Stub for "fm.loadfile"
0006               * bank2 vec.1
0007               ********|*****|*********************|**************************
0008               fm.loadfile:
0009 793C 0649  14         dect  stack
0010 793E C64B  30         mov   r11,*stack            ; Save return address
0011 7940 0649  14         dect  stack
0012 7942 C644  30         mov   tmp0,*stack           ; Push tmp0
0013                       ;------------------------------------------------------
0014                       ; Call function in bank 2
0015                       ;------------------------------------------------------
0016 7944 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7946 2F84     
0017 7948 6004                   data bank2.rom        ; | i  p0 = bank address
0018 794A 7FC0                   data vec.1            ; | i  p1 = Vector with target address
0019 794C 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0020                       ;------------------------------------------------------
0021                       ; Show "Unsaved changes" dialog if editor buffer dirty
0022                       ;------------------------------------------------------
0023 794E C120  34         mov   @outparm1,tmp0
     7950 A016     
0024 7952 1304  14         jeq   fm.loadfile.exit
0025               
0026 7954 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0027 7956 C2F9  30         mov   *stack+,r11           ; Pop r11
0028 7958 0460  28         b     @dialog.unsaved       ; Show dialog and exit
     795A 7A00     
0029                       ;------------------------------------------------------
0030                       ; Exit
0031                       ;------------------------------------------------------
0032               fm.loadfile.exit:
0033 795C C139  30         mov   *stack+,tmp0          ; Pop tmp0
0034 795E C2F9  30         mov   *stack+,r11           ; Pop r11
0035 7960 045B  20         b     *r11                  ; Return to caller
0036               
0037               
0038               ***************************************************************
0039               * Stub for "fm.insertfile"
0040               * bank2 vec.2
0041               ********|*****|*********************|**************************
0042               fm.insertfile:
0043 7962 0649  14         dect  stack
0044 7964 C64B  30         mov   r11,*stack            ; Save return address
0045 7966 0649  14         dect  stack
0046 7968 C644  30         mov   tmp0,*stack           ; Push tmp0
0047                       ;------------------------------------------------------
0048                       ; Call function in bank 2
0049                       ;------------------------------------------------------
0050 796A 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     796C 2F84     
0051 796E 6004                   data bank2.rom        ; | i  p0 = bank address
0052 7970 7FC2                   data vec.2            ; | i  p1 = Vector with target address
0053 7972 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0054                       ;------------------------------------------------------
0055                       ; Exit
0056                       ;------------------------------------------------------
0057               fm.insertfile.exit:
0058 7974 C139  30         mov   *stack+,tmp0          ; Pop tmp0
0059 7976 C2F9  30         mov   *stack+,r11           ; Pop r11
0060 7978 045B  20         b     *r11                  ; Return to caller
0061               
0062               
0063               **************************************************************
0064               * Stub for "fm.browse.fname.suffix"
0065               * bank2 vec.3
0066               ********|*****|*********************|**************************
0067               fm.browse.fname.suffix:
0068 797A 0649  14         dect  stack
0069 797C C64B  30         mov   r11,*stack            ; Save return address
0070                       ;------------------------------------------------------
0071                       ; Call function in bank 2
0072                       ;------------------------------------------------------
0073 797E 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7980 2F84     
0074 7982 6004                   data bank2.rom        ; | i  p0 = bank address
0075 7984 7FC4                   data vec.3            ; | i  p1 = Vector with target address
0076 7986 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0077                       ;------------------------------------------------------
0078                       ; Exit
0079                       ;------------------------------------------------------
0080 7988 C2F9  30         mov   *stack+,r11           ; Pop r11
0081 798A 045B  20         b     *r11                  ; Return to caller
0082               
0083               
0084               ***************************************************************
0085               * Stub for "fm.savefile"
0086               * bank2 vec.4
0087               ********|*****|*********************|**************************
0088               fm.savefile:
0089 798C 0649  14         dect  stack
0090 798E C64B  30         mov   r11,*stack            ; Save return address
0091                       ;------------------------------------------------------
0092                       ; Call function in bank 2
0093                       ;------------------------------------------------------
0094 7990 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7992 2F84     
0095 7994 6004                   data bank2.rom        ; | i  p0 = bank address
0096 7996 7FC6                   data vec.4            ; | i  p1 = Vector with target address
0097 7998 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0098                       ;------------------------------------------------------
0099                       ; Exit
0100                       ;------------------------------------------------------
0101 799A C2F9  30         mov   *stack+,r11           ; Pop r11
0102 799C 045B  20         b     *r11                  ; Return to caller
0103               
0104               
0105               ***************************************************************
0106               * Stub for "fm.newfile"
0107               * bank2 vec.5
0108               ********|*****|*********************|**************************
0109               fm.newfile:
0110 799E 0649  14         dect  stack
0111 79A0 C64B  30         mov   r11,*stack            ; Save return address
0112                       ;------------------------------------------------------
0113                       ; Call function in bank 2
0114                       ;------------------------------------------------------
0115 79A2 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     79A4 2F84     
0116 79A6 6004                   data bank2.rom        ; | i  p0 = bank address
0117 79A8 7FC8                   data vec.5            ; | i  p1 = Vector with target address
0118 79AA 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0119                       ;------------------------------------------------------
0120                       ; Exit
0121                       ;------------------------------------------------------
0122 79AC C2F9  30         mov   *stack+,r11           ; Pop r11
0123 79AE 045B  20         b     *r11                  ; Return to caller
0124               
0125               
0126               ***************************************************************
0127               * Stub for dialog "Help"
0128               * bank3 vec.1
0129               ********|*****|*********************|**************************
0130               dialog.help.next:
0131 79B0 8820  54         c     @w$0008,@cmdb.dialog.var
     79B2 2008     
     79B4 A71C     
0132 79B6 1304  14         jeq   !
0133 79B8 A820  54         a     @w$0008,@cmdb.dialog.var
     79BA 2008     
     79BC A71C     
0134 79BE 1002  14         jmp   dialog.help
0135 79C0 04E0  34 !       clr   @cmdb.dialog.var
     79C2 A71C     
0136               dialog.help:
0137 79C4 C820  54         mov   @dialog.help.vector,@trmpvector
     79C6 79CC     
     79C8 A032     
0138 79CA 104A  14         jmp   _trampoline.bank3     ; Show dialog
0139               dialog.help.vector:
0140 79CC 7FC0             data  vec.1
0141               
0142               
0143               ***************************************************************
0144               * Stub for dialog "Load file"
0145               * bank3 vec.2
0146               ********|*****|*********************|**************************
0147               dialog.load:
0148 79CE C820  54         mov   @dialog.load.vector,@trmpvector
     79D0 79D6     
     79D2 A032     
0149 79D4 1045  14         jmp   _trampoline.bank3     ; Show dialog
0150               dialog.load.vector:
0151 79D6 7FC2             data  vec.2
0152               
0153               
0154               ***************************************************************
0155               * Stub for dialog "Save file"
0156               * bank3 vec.3
0157               ********|*****|*********************|**************************
0158               dialog.save:
0159 79D8 C820  54         mov   @dialog.save.vector,@trmpvector
     79DA 79E0     
     79DC A032     
0160 79DE 1040  14         jmp   _trampoline.bank3     ; Show dialog
0161               dialog.save.vector:
0162 79E0 7FC4             data  vec.3
0163               
0164               
0165               ***************************************************************
0166               * Stub for dialog "Insert file at line"
0167               * bank3 vec.4
0168               ********|*****|*********************|**************************
0169               dialog.insert:
0170 79E2 C820  54         mov   @dialog.insert.vector,@trmpvector
     79E4 79EA     
     79E6 A032     
0171 79E8 103B  14         jmp   _trampoline.bank3     ; Show dialog
0172               dialog.insert.vector:
0173 79EA 7FC6             data  vec.4
0174               
0175               
0176               ***************************************************************
0177               * Stub for dialog "Print file"
0178               * bank3 vec.5
0179               ********|*****|*********************|**************************
0180               dialog.print:
0181 79EC C820  54         mov   @dialog.print.vector,@trmpvector
     79EE 79F4     
     79F0 A032     
0182 79F2 1036  14         jmp   _trampoline.bank3    ; Show dialog
0183               dialog.print.vector:
0184 79F4 7FC8             data  vec.5
0185               
0186               
0187               ***************************************************************
0188               * Stub for dialog "File"
0189               * bank3 vec.6
0190               ********|*****|*********************|**************************
0191               dialog.file:
0192 79F6 C820  54         mov   @dialog.file.vector,@trmpvector
     79F8 79FE     
     79FA A032     
0193 79FC 1031  14         jmp   _trampoline.bank3     ; Show dialog
0194               dialog.file.vector:
0195 79FE 7FCA             data  vec.6
0196               
0197               
0198               ***************************************************************
0199               * Stub for dialog "Unsaved Changes"
0200               * bank3 vec.7
0201               ********|*****|*********************|**************************
0202               dialog.unsaved:
0203 7A00 04E0  34         clr   @cmdb.panmarkers      ; No key markers
     7A02 A724     
0204 7A04 C820  54         mov   @dialog.unsaved.vector,@trmpvector
     7A06 7A0C     
     7A08 A032     
0205 7A0A 102A  14         jmp   _trampoline.bank3     ; Show dialog
0206               dialog.unsaved.vector:
0207 7A0C 7FCC             data  vec.7
0208               
0209               
0210               ***************************************************************
0211               * Stub for dialog "Copy clipboard to line ..."
0212               * bank3 vec.8
0213               ********|*****|*********************|**************************
0214               dialog.clipboard:
0215 7A0E C820  54         mov   @dialog.clipboard.vector,@trmpvector
     7A10 7A16     
     7A12 A032     
0216 7A14 1025  14         jmp   _trampoline.bank3     ; Show dialog
0217               dialog.clipboard.vector:
0218 7A16 7FCE             data  vec.8
0219               
0220               
0221               ***************************************************************
0222               * Stub for dialog "Configure clipboard device"
0223               * bank3 vec.9
0224               ********|*****|*********************|**************************
0225               dialog.clipdev:
0226 7A18 C820  54         mov   @dialog.clipdev.vector,@trmpvector
     7A1A 7A20     
     7A1C A032     
0227 7A1E 1020  14         jmp   _trampoline.bank3     ; Show dialog
0228               dialog.clipdev.vector:
0229 7A20 7FD0             data  vec.9
0230               
0231               
0232               ***************************************************************
0233               * Stub for dialog "Configure"
0234               * bank3 vec.10
0235               ********|*****|*********************|**************************
0236               dialog.config:
0237 7A22 C820  54         mov   @dialog.config.vector,@trmpvector
     7A24 7A2A     
     7A26 A032     
0238 7A28 101B  14         jmp   _trampoline.bank3     ; Show dialog
0239               dialog.config.vector:
0240 7A2A 7FD2             data  vec.10
0241               
0242               
0243               ***************************************************************
0244               * Stub for dialog "Append file"
0245               * bank3 vec.11
0246               ********|*****|*********************|**************************
0247               dialog.append:
0248 7A2C C820  54         mov   @dialog.append.vector,@trmpvector
     7A2E 7A34     
     7A30 A032     
0249 7A32 1016  14         jmp   _trampoline.bank3     ; Show dialog
0250               dialog.append.vector:
0251 7A34 7FD4             data  vec.11
0252               
0253               
0254               ***************************************************************
0255               * Stub for dialog "Cartridge"
0256               * bank3 vec.12
0257               ********|*****|*********************|**************************
0258               dialog.cartridge:
0259 7A36 C820  54         mov   @dialog.cartridge.vector,@trmpvector
     7A38 7A3E     
     7A3A A032     
0260 7A3C 1011  14         jmp   _trampoline.bank3     ; Show dialog
0261               dialog.cartridge.vector:
0262 7A3E 7FD6             data  vec.12
0263               
0264               
0265               ***************************************************************
0266               * Stub for dialog "Basic"
0267               * bank3 vec.13
0268               ********|*****|*********************|**************************
0269               dialog.basic:
0270 7A40 C820  54         mov   @dialog.basic.vector,@trmpvector
     7A42 7A48     
     7A44 A032     
0271 7A46 100C  14         jmp   _trampoline.bank3     ; Show dialog
0272               dialog.basic.vector:
0273 7A48 7FD8             data  vec.13
0274               
0275               
0276               ***************************************************************
0277               * Stub for dialog "Main Menu"
0278               * bank3 vec.30
0279               ********|*****|*********************|**************************
0280               dialog.menu:
0281                       ;------------------------------------------------------
0282                       ; Check if block mode is active
0283                       ;------------------------------------------------------
0284 7A4A C120  34         mov   @edb.block.m2,tmp0    ; \
     7A4C A50E     
0285 7A4E 0584  14         inc   tmp0                  ; | Skip if M2 unset (>ffff)
0286                                                   ; /
0287 7A50 1302  14         jeq   !                     : Block mode inactive, show dialog
0288                       ;------------------------------------------------------
0289                       ; Special treatment for block mode
0290                       ;------------------------------------------------------
0291 7A52 0460  28         b     @edkey.action.block.reset
     7A54 687A     
0292                                                   ; Reset block mode
0293                       ;------------------------------------------------------
0294                       ; Show dialog
0295                       ;------------------------------------------------------
0296 7A56 C820  54 !       mov   @dialog.menu.vector,@trmpvector
     7A58 7A5E     
     7A5A A032     
0297 7A5C 1001  14         jmp   _trampoline.bank3     ; Show dialog
0298               dialog.menu.vector:
0299 7A5E 7FFA             data  vec.30
0300               
0301               
0302               
0303               ***************************************************************
0304               * Trampoline 1 (bank 3, dialog)
0305               ********|*****|*********************|**************************
0306               _trampoline.bank3:
0307 7A60 06A0  32         bl    @pane.cursor.hide     ; Hide cursor
     7A62 7518     
0308                       ;------------------------------------------------------
0309                       ; Call routine in specified bank
0310                       ;------------------------------------------------------
0311 7A64 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7A66 2F84     
0312 7A68 6006                   data bank3.rom        ; | i  p0 = bank address
0313 7A6A FFFF                   data >ffff            ; | i  p1 = Vector with target address
0314                                                   ; |         (deref @trmpvector)
0315 7A6C 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0316                       ;------------------------------------------------------
0317                       ; Exit
0318                       ;------------------------------------------------------
0319 7A6E 0460  28         b     @edkey.action.cmdb.show
     7A70 6A30     
0320                                                   ; Show dialog in CMDB pane
0321               
0322               
0323               ***************************************************************
0324               * Stub for "error.display"
0325               * bank3 vec.18
0326               ********|*****|*********************|**************************
0327               error.display:
0328 7A72 C820  54         mov   @error.display.vector,@trmpvector
     7A74 7A7A     
     7A76 A032     
0329 7A78 103D  14         jmp   _trampoline.bank3.ret ; Longjump
0330               error.display.vector:
0331 7A7A 7FE2             data  vec.18
0332               
0333               
0334               ***************************************************************
0335               * Stub for "pane.show_hintx"
0336               * bank3 vec.19
0337               ********|*****|*********************|**************************
0338               pane.show_hintx:
0339 7A7C C820  54         mov   @pane.show_hintx.vector,@trmpvector
     7A7E 7A84     
     7A80 A032     
0340 7A82 1038  14         jmp   _trampoline.bank3.ret ; Longjump
0341               pane.show_hintx.vector:
0342 7A84 7FE4             data  vec.19
0343               
0344               
0345               ***************************************************************
0346               * Stub for "pane.cmdb.show"
0347               * bank3 vec.20
0348               ********|*****|*********************|**************************
0349               pane.cmdb.show:
0350 7A86 C820  54         mov   @pane.cmdb.show.vector,@trmpvector
     7A88 7A8E     
     7A8A A032     
0351 7A8C 1033  14         jmp   _trampoline.bank3.ret ; Longjump
0352               pane.cmdb.show.vector:
0353 7A8E 7FE6             data  vec.20
0354               
0355               
0356               ***************************************************************
0357               * Stub for "pane.cmdb.hide"
0358               * bank3 vec.21
0359               ********|*****|*********************|**************************
0360               pane.cmdb.hide:
0361 7A90 C820  54         mov   @pane.cmdb.hide.vector,@trmpvector
     7A92 7A98     
     7A94 A032     
0362 7A96 102E  14         jmp   _trampoline.bank3.ret ; Longjump
0363               pane.cmdb.hide.vector:
0364 7A98 7FE8             data  vec.21
0365               
0366               
0367               ***************************************************************
0368               * Stub for "pane.cmdb.draw"
0369               * bank3 vec.22
0370               ********|*****|*********************|**************************
0371               pane.cmdb.draw:
0372 7A9A C820  54         mov   @pane.cmdb.draw.vector,@trmpvector
     7A9C 7AA2     
     7A9E A032     
0373 7AA0 1029  14         jmp   _trampoline.bank3.ret ; Longjump
0374               pane.cmdb.draw.vector:
0375 7AA2 7FEA             data  vec.22
0376               
0377               
0378               ***************************************************************
0379               * Stub for "cmdb.refresh"
0380               * bank3 vec.24
0381               ********|*****|*********************|**************************
0382               cmdb.refresh:
0383 7AA4 C820  54         mov   @cmdb.refresh.vector,@trmpvector
     7AA6 7AAC     
     7AA8 A032     
0384 7AAA 1024  14         jmp   _trampoline.bank3.ret ; Longjump
0385               cmdb.refresh.vector:
0386 7AAC 7FEE             data  vec.24
0387               
0388               
0389               ***************************************************************
0390               * Stub for "cmdb.cmd.clear"
0391               * bank3 vec.25
0392               ********|*****|*********************|**************************
0393               cmdb.cmd.clear:
0394 7AAE C820  54         mov   @cmdb.cmd.clear.vector,@trmpvector
     7AB0 7AB6     
     7AB2 A032     
0395 7AB4 101F  14         jmp   _trampoline.bank3.ret ; Longjump
0396               cmdb.cmd.clear.vector:
0397 7AB6 7FF0             data  vec.25
0398               
0399               
0400               ***************************************************************
0401               * Stub for "cmdb.cmdb.getlength"
0402               * bank3 vec.26
0403               ********|*****|*********************|**************************
0404               cmdb.cmd.getlength:
0405 7AB8 C820  54         mov   @cmdb.cmd.getlength.vector,@trmpvector
     7ABA 7AC0     
     7ABC A032     
0406 7ABE 101A  14         jmp   _trampoline.bank3.ret ; Longjump
0407               cmdb.cmd.getlength.vector:
0408 7AC0 7FF2             data  vec.26
0409               
0410               
0411               ***************************************************************
0412               * Stub for "cmdb.cmdb.preset"
0413               * bank3 vec.27
0414               ********|*****|*********************|**************************
0415               cmdb.cmd.preset:
0416 7AC2 C820  54         mov   @cmdb.cmd.preset.vector,@trmpvector
     7AC4 7ACA     
     7AC6 A032     
0417 7AC8 1015  14         jmp   _trampoline.bank3.ret ; Longjump
0418               cmdb.cmd.preset.vector:
0419 7ACA 7FF4             data  vec.27
0420               
0421               
0422               ***************************************************************
0423               * Stub for "cmdb.cmdb.set"
0424               * bank3 vec.28
0425               ********|*****|*********************|**************************
0426               cmdb.cmd.set:
0427 7ACC C820  54         mov   @cmdb.cmd.set.vector,@trmpvector
     7ACE 7AD4     
     7AD0 A032     
0428 7AD2 1010  14         jmp   _trampoline.bank3.ret ; Longjump
0429               cmdb.cmd.set.vector:
0430 7AD4 7FF6             data  vec.28
0431               
0432               
0433               
0434               ***************************************************************
0435               * Stub for "tibasic.hearts.tat"
0436               * bank3 vec.29
0437               ********|*****|*********************|**************************
0438               tibasic.hearts.tat:
0439 7AD6 C820  54         mov   @tibasic.hearts.tat.vector,@trmpvector
     7AD8 7ADE     
     7ADA A032     
0440 7ADC 100B  14         jmp   _trampoline.bank3.ret ; Longjump
0441               tibasic.hearts.tat.vector:
0442 7ADE 7FF8             data  vec.29
0443               
0444               
0445               
0446               **************************************************************
0447               * Stub for "tibasic.am.toggle"
0448               * bank3 vec.31
0449               ********|*****|*********************|**************************
0450               tibasic.am.toggle:
0451 7AE0 C820  54         mov   @tibasic.am.toggle.vector,@trmpvector
     7AE2 7AE8     
     7AE4 A032     
0452 7AE6 1006  14         jmp   _trampoline.bank3.ret ; Longjump
0453               tibasic.am.toggle.vector:
0454 7AE8 7FFC             data  vec.31
0455               
0456               
0457               **************************************************************
0458               * Stub for "fm.fastmode"
0459               * bank3 vec.32
0460               ********|*****|*********************|**************************
0461               fm.fastmode:
0462 7AEA C820  54         mov   @fm.fastmode.vector,@trmpvector
     7AEC 7AF2     
     7AEE A032     
0463 7AF0 1001  14         jmp   _trampoline.bank3.ret ; Longjump
0464               fm.fastmode.vector:
0465 7AF2 7FFE             data  vec.32
0466               
0467               
0468               
0469               
0470               ***************************************************************
0471               * Trampoline bank 3 with return
0472               ********|*****|*********************|**************************
0473               _trampoline.bank3.ret:
0474 7AF4 0649  14         dect  stack
0475 7AF6 C64B  30         mov   r11,*stack            ; Save return address
0476                       ;------------------------------------------------------
0477                       ; Call routine in specified bank
0478                       ;------------------------------------------------------
0479 7AF8 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7AFA 2F84     
0480 7AFC 6006                   data bank3.rom        ; | i  p0 = bank address
0481 7AFE FFFF                   data >ffff            ; | i  p1 = Vector with target address
0482                                                   ; |         (deref @trmpvector)
0483 7B00 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0484                       ;------------------------------------------------------
0485                       ; Exit
0486                       ;------------------------------------------------------
0487 7B02 C2F9  30         mov   *stack+,r11           ; Pop r11
0488 7B04 045B  20         b     *r11                  ; Return to caller
0489               
0490               
0491               
0492               ***************************************************************
0493               * Stub for "fb.tab.next"
0494               * bank4 vec.1
0495               ********|*****|*********************|**************************
0496               fb.tab.next:
0497 7B06 0649  14         dect  stack
0498 7B08 C64B  30         mov   r11,*stack            ; Save return address
0499                       ;------------------------------------------------------
0500                       ; Put cursor on next tab position
0501                       ;------------------------------------------------------
0502 7B0A 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7B0C 2F84     
0503 7B0E 6008                   data bank4.rom        ; | i  p0 = bank address
0504 7B10 7FC0                   data vec.1            ; | i  p1 = Vector with target address
0505 7B12 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0506                       ;------------------------------------------------------
0507                       ; Exit
0508                       ;------------------------------------------------------
0509 7B14 C2F9  30         mov   *stack+,r11           ; Pop r11
0510 7B16 045B  20         b     *r11                  ; Return to caller
0511               
0512               
0513               ***************************************************************
0514               * Stub for "fb.ruler.init"
0515               * bank4 vec.2
0516               ********|*****|*********************|**************************
0517               fb.ruler.init:
0518 7B18 0649  14         dect  stack
0519 7B1A C64B  30         mov   r11,*stack            ; Save return address
0520                       ;------------------------------------------------------
0521                       ; Setup ruler in memory
0522                       ;------------------------------------------------------
0523 7B1C 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7B1E 2F84     
0524 7B20 6008                   data bank4.rom        ; | i  p0 = bank address
0525 7B22 7FC2                   data vec.2            ; | i  p1 = Vector with target address
0526 7B24 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0527                       ;------------------------------------------------------
0528                       ; Exit
0529                       ;------------------------------------------------------
0530 7B26 C2F9  30         mov   *stack+,r11           ; Pop r11
0531 7B28 045B  20         b     *r11                  ; Return to caller
0532               
0533               
0534               ***************************************************************
0535               * Stub for "fb.colorlines"
0536               * bank4 vec.3
0537               ********|*****|*********************|**************************
0538               fb.colorlines:
0539 7B2A 0649  14         dect  stack
0540 7B2C C64B  30         mov   r11,*stack            ; Save return address
0541                       ;------------------------------------------------------
0542                       ; Colorize frame buffer content
0543                       ;------------------------------------------------------
0544 7B2E 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7B30 2F84     
0545 7B32 6008                   data bank4.rom        ; | i  p0 = bank address
0546 7B34 7FC4                   data vec.3            ; | i  p1 = Vector with target address
0547 7B36 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0548                       ;------------------------------------------------------
0549                       ; Exit
0550                       ;------------------------------------------------------
0551 7B38 C2F9  30         mov   *stack+,r11           ; Pop r11
0552 7B3A 045B  20         b     *r11                  ; Return to caller
0553               
0554               
0555               ***************************************************************
0556               * Stub for "fb.vdpdump"
0557               * bank4 vec.4
0558               ********|*****|*********************|**************************
0559               fb.vdpdump:
0560 7B3C 0649  14         dect  stack
0561 7B3E C64B  30         mov   r11,*stack            ; Save return address
0562                       ;------------------------------------------------------
0563                       ; Colorize frame buffer content
0564                       ;------------------------------------------------------
0565 7B40 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7B42 2F84     
0566 7B44 6008                   data bank4.rom        ; | i  p0 = bank address
0567 7B46 7FC6                   data vec.4            ; | i  p1 = Vector with target address
0568 7B48 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0569                       ;------------------------------------------------------
0570                       ; Exit
0571                       ;------------------------------------------------------
0572 7B4A C2F9  30         mov   *stack+,r11           ; Pop r11
0573 7B4C 045B  20         b     *r11                  ; Return to caller
0574               
0575               
0576               
0577               **************************************************************
0578               * Stub for "edb.clear.sams"
0579               * bank5 vec.1
0580               ********|*****|*********************|**************************
0581               edb.clear.sams:
0582 7B4E C820  54         mov   @edb.clear.sams.vector,@trmpvector
     7B50 7B56     
     7B52 A032     
0583 7B54 1029  14         jmp   _trampoline.bank5.ret ; Longjump
0584               edb.clear.sams.vector:
0585 7B56 7FC0             data  vec.1
0586               
0587               
0588               **************************************************************
0589               * Stub for "edb.block.mark"
0590               * bank5 vec.3
0591               ********|*****|*********************|**************************
0592               edb.block.mark:
0593 7B58 C820  54         mov   @edb.block.mark.vector,@trmpvector
     7B5A 7B60     
     7B5C A032     
0594 7B5E 1024  14         jmp   _trampoline.bank5.ret ; Longjump
0595               edb.block.mark.vector:
0596 7B60 7FC4             data  vec.3
0597               
0598               
0599               **************************************************************
0600               * Stub for "edb.block.mark.m1"
0601               * bank5 vec.4
0602               ********|*****|*********************|**************************
0603               edb.block.mark.m1:
0604 7B62 C820  54         mov   @edb.block.mark.m1.vector,@trmpvector
     7B64 7B6A     
     7B66 A032     
0605 7B68 101F  14         jmp   _trampoline.bank5.ret ; Longjump
0606               edb.block.mark.m1.vector:
0607 7B6A 7FC6             data  vec.4
0608               
0609               
0610               **************************************************************
0611               * Stub for "edb.block.mark.m2"
0612               * bank5 vec.5
0613               ********|*****|*********************|**************************
0614               edb.block.mark.m2:
0615 7B6C C820  54         mov   @edb.block.mark.m2.vector,@trmpvector
     7B6E 7B74     
     7B70 A032     
0616 7B72 101A  14         jmp   _trampoline.bank5.ret ; Longjump
0617               edb.block.mark.m2.vector:
0618 7B74 7FC8             data  vec.5
0619               
0620               
0621               **************************************************************
0622               * Stub for "edb.block.clip"
0623               * bank5 vec.6
0624               ********|*****|*********************|**************************
0625               edb.block.clip:
0626 7B76 C820  54         mov   @edb.block.clip.vector,@trmpvector
     7B78 7B7E     
     7B7A A032     
0627 7B7C 1015  14         jmp   _trampoline.bank5.ret ; Longjump
0628               edb.block.clip.vector:
0629 7B7E 7FCA             data  vec.6
0630               
0631               
0632               **************************************************************
0633               * Stub for "edb.block.reset"
0634               * bank5 vec.7
0635               ********|*****|*********************|**************************
0636               edb.block.reset:
0637 7B80 C820  54         mov   @edb.block.reset.vector,@trmpvector
     7B82 7B88     
     7B84 A032     
0638 7B86 1010  14         jmp   _trampoline.bank5.ret ; Longjump
0639               edb.block.reset.vector:
0640 7B88 7FCC             data  vec.7
0641               
0642               
0643               **************************************************************
0644               * Stub for "edb.block.delete"
0645               * bank5 vec.8
0646               ********|*****|*********************|**************************
0647               edb.block.delete:
0648 7B8A C820  54         mov   @edb.block.delete.vector,@trmpvector
     7B8C 7B92     
     7B8E A032     
0649 7B90 100B  14         jmp   _trampoline.bank5.ret ; Longjump
0650               edb.block.delete.vector:
0651 7B92 7FCE             data  vec.8
0652               
0653               
0654               **************************************************************
0655               * Stub for "edb.block.copy"
0656               * bank5 vec.9
0657               ********|*****|*********************|**************************
0658               edb.block.copy:
0659 7B94 C820  54         mov   @edb.block.copy.vector,@trmpvector
     7B96 7B9C     
     7B98 A032     
0660 7B9A 1006  14         jmp   _trampoline.bank5.ret ; Longjump
0661               edb.block.copy.vector:
0662 7B9C 7FD0             data  vec.9
0663               
0664               
0665               **************************************************************
0666               * Stub for "edb.line.del"
0667               * bank5 vec.10
0668               ********|*****|*********************|**************************
0669               edb.line.del:
0670 7B9E C820  54         mov   @edb.line.del.vector,@trmpvector
     7BA0 7BA6     
     7BA2 A032     
0671 7BA4 1001  14         jmp   _trampoline.bank5.ret ; Longjump
0672               edb.line.del.vector:
0673 7BA6 7FD2             data  vec.10
0674               
0675               
0676               
0677               ***************************************************************
0678               * Trampoline bank 5 with return
0679               ********|*****|*********************|**************************
0680               _trampoline.bank5.ret:
0681 7BA8 0649  14         dect  stack
0682 7BAA C64B  30         mov   r11,*stack            ; Save return address
0683                       ;------------------------------------------------------
0684                       ; Call routine in specified bank
0685                       ;------------------------------------------------------
0686 7BAC 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7BAE 2F84     
0687 7BB0 600A                   data bank5.rom        ; | i  p0 = bank address
0688 7BB2 FFFF                   data >ffff            ; | i  p1 = Vector with target address
0689                                                   ; |         (deref @trmpvector)
0690 7BB4 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0691                       ;------------------------------------------------------
0692                       ; Exit
0693                       ;------------------------------------------------------
0694 7BB6 C2F9  30         mov   *stack+,r11           ; Pop r11
0695 7BB8 045B  20         b     *r11                  ; Return to caller
0696               
0697               
0698               ***************************************************************
0699               * Stub for "vdp.patterns.dump"
0700               * bank6 vec.1
0701               ********|*****|*********************|**************************
0702               vdp.patterns.dump:
0703 7BBA 0649  14         dect  stack
0704 7BBC C64B  30         mov   r11,*stack            ; Save return address
0705                       ;------------------------------------------------------
0706                       ; Dump VDP patterns
0707                       ;------------------------------------------------------
0708 7BBE 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7BC0 2F84     
0709 7BC2 600C                   data bank6.rom        ; | i  p0 = bank address
0710 7BC4 7FC0                   data vec.1            ; | i  p1 = Vector with target address
0711 7BC6 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0712                       ;------------------------------------------------------
0713                       ; Exit
0714                       ;------------------------------------------------------
0715 7BC8 C2F9  30         mov   *stack+,r11           ; Pop r11
0716 7BCA 045B  20         b     *r11                  ; Return to caller
0717               
0718               
0719               
0720               ***************************************************************
0721               * Stub for "tibasic"
0722               * bank7 vec.10
0723               ********|*****|*********************|**************************
0724               tibasic1:
0725 7BCC C820  54         mov   @const.1,@tib.session
     7BCE 2002     
     7BD0 A0B4     
0726 7BD2 100F  14         jmp   tibasic
0727               tibasic2:
0728 7BD4 C820  54         mov   @const.2,@tib.session
     7BD6 2004     
     7BD8 A0B4     
0729 7BDA 100B  14         jmp   tibasic
0730               tibasic3:
0731 7BDC C820  54         mov   @const.3,@tib.session
     7BDE 36E0     
     7BE0 A0B4     
0732 7BE2 1007  14         jmp   tibasic
0733               tibasic4:
0734 7BE4 C820  54         mov   @const.4,@tib.session
     7BE6 2006     
     7BE8 A0B4     
0735 7BEA 1003  14         jmp   tibasic
0736               tibasic5:
0737 7BEC C820  54         mov   @const.5,@tib.session
     7BEE 36E2     
     7BF0 A0B4     
0738               tibasic:
0739 7BF2 0649  14         dect  stack
0740 7BF4 C64B  30         mov   r11,*stack            ; Save return address
0741 7BF6 0649  14         dect  stack
0742 7BF8 C644  30         mov   tmp0,*stack           ; Push tmp0
0743                       ;------------------------------------------------------
0744                       ; Run TI Basic session
0745                       ;------------------------------------------------------
0746 7BFA 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7BFC 2F84     
0747 7BFE 600E                   data bank7.rom        ; | i  p0 = bank address
0748 7C00 7FD2                   data vec.10           ; | i  p1 = Vector with target address
0749 7C02 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0750               
0751 7C04 C120  34         mov   @tib.automode,tmp0    ; AutoMode flag set?
     7C06 A0C0     
0752 7C08 1302  14         jeq   tibasic.exit          ; No, skip uncrunching
0753               
0754 7C0A 06A0  32         bl    @tibasic.uncrunch     ; Uncrunch TI Basic program
     7C0C 7C14     
0755                       ;------------------------------------------------------
0756                       ; Exit
0757                       ;------------------------------------------------------
0758               tibasic.exit:
0759 7C0E C139  30         mov   *stack+,tmp0          ; Pop tmp0
0760 7C10 C2F9  30         mov   *stack+,r11           ; Pop r11
0761 7C12 045B  20         b     *r11                  ; Return to caller
0762               
0763               
0764               
0765               ***************************************************************
0766               * Stub for "tibasic.uncrunch"
0767               * bank7 vec.11
0768               ********|*****|*********************|**************************
0769               tibasic.uncrunch:
0770 7C14 0649  14         dect  stack
0771 7C16 C64B  30         mov   r11,*stack            ; Save return address
0772                       ;------------------------------------------------------
0773                       ; Uncrunch TI basic program
0774                       ;------------------------------------------------------
0775 7C18 C820  54         mov   @tib.session,@parm1   ; Get current session
     7C1A A0B4     
     7C1C A006     
0776 7C1E 1305  14         jeq   tibasic.uncrunch.exit ; Exit early if no session
0777               
0778 7C20 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7C22 2F84     
0779 7C24 600E                   data bank7.rom        ; | i  p0 = bank address
0780 7C26 7FD4                   data vec.11           ; | i  p1 = Vector with target address
0781 7C28 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0782                       ;------------------------------------------------------
0783                       ; Exit
0784                       ;------------------------------------------------------
0785               tibasic.uncrunch.exit:
0786 7C2A C2F9  30         mov   *stack+,r11           ; Pop r11
0787 7C2C 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.33260
0146                       copy  "rom.stubs.bankx.asm"         ; Stubs to include in all banks > 0
     **** ****     > rom.stubs.bankx.asm
0001               * FILE......: rom.stubs.bankx.asm
0002               * Purpose...: Stubs to include in all banks > 0
0003               
0004               
0026               
0027               
0029               ***************************************************************
0030               * Stub for "mem.sams.set.legacy"
0031               * bank7 vec.1
0032               ********|*****|*********************|**************************
0033               mem.sams.set.legacy:
0034 7C2E 0649  14         dect  stack
0035 7C30 C64B  30         mov   r11,*stack            ; Save return address
0036                       ;------------------------------------------------------
0037                       ; Dump VDP patterns
0038                       ;------------------------------------------------------
0039 7C32 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7C34 2F84     
0040 7C36 600E                   data bank7.rom        ; | i  p0 = bank address
0041 7C38 7FC0                   data vec.1            ; | i  p1 = Vector with target address
0042 7C3A 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0043                       ;------------------------------------------------------
0044                       ; Exit
0045                       ;------------------------------------------------------
0046 7C3C C2F9  30         mov   *stack+,r11           ; Pop r11
0047 7C3E 045B  20         b     *r11                  ; Return to caller
0049               
0050               
0052               ***************************************************************
0053               * Stub for "mem.sams.set.boot"
0054               * bank7 vec.2
0055               ********|*****|*********************|**************************
0056               mem.sams.set.boot:
0057 7C40 0649  14         dect  stack
0058 7C42 C64B  30         mov   r11,*stack            ; Save return address
0059                       ;------------------------------------------------------
0060                       ; Dump VDP patterns
0061                       ;------------------------------------------------------
0062 7C44 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7C46 2F84     
0063 7C48 600E                   data bank7.rom        ; | i  p0 = bank address
0064 7C4A 7FC2                   data vec.2            ; | i  p1 = Vector with target address
0065 7C4C 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0066                       ;------------------------------------------------------
0067                       ; Exit
0068                       ;------------------------------------------------------
0069 7C4E C2F9  30         mov   *stack+,r11           ; Pop r11
0070 7C50 045B  20         b     *r11                  ; Return to caller
0072               
0073               
0075               ***************************************************************
0076               * Stub for "mem.sams.set.stevie"
0077               * bank7 vec.3
0078               ********|*****|*********************|**************************
0079               mem.sams.set.stevie:
0080 7C52 0649  14         dect  stack
0081 7C54 C64B  30         mov   r11,*stack            ; Save return address
0082                       ;------------------------------------------------------
0083                       ; Dump VDP patterns
0084                       ;------------------------------------------------------
0085 7C56 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7C58 2F84     
0086 7C5A 600E                   data bank7.rom        ; | i  p0 = bank address
0087 7C5C 7FC4                   data vec.3            ; | i  p1 = Vector with target address
0088 7C5E 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0089                       ;------------------------------------------------------
0090                       ; Exit
0091                       ;------------------------------------------------------
0092 7C60 C2F9  30         mov   *stack+,r11           ; Pop r11
0093 7C62 045B  20         b     *r11                  ; Return to caller
0095               
0096               
0098               ***************************************************************
0099               * Stub for "magic.set"
0100               * bank7 vec.20
0101               ********|*****|*********************|**************************
0102               magic.set:
0103 7C64 0649  14         dect  stack
0104 7C66 C64B  30         mov   r11,*stack            ; Save return address
0105                       ;------------------------------------------------------
0106                       ; Dump VDP patterns
0107                       ;------------------------------------------------------
0108 7C68 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7C6A 2F84     
0109 7C6C 600E                   data bank7.rom        ; | i  p0 = bank address
0110 7C6E 7FE6                   data vec.20           ; | i  p1 = Vector with target address
0111 7C70 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0112                       ;------------------------------------------------------
0113                       ; Exit
0114                       ;------------------------------------------------------
0115 7C72 C2F9  30         mov   *stack+,r11           ; Pop r11
0116 7C74 045B  20         b     *r11                  ; Return to caller
0118               
0119               
0121               ***************************************************************
0122               * Stub for "magic.clear"
0123               * bank7 vec.21
0124               ********|*****|*********************|**************************
0125               magic.clear:
0126 7C76 0649  14         dect  stack
0127 7C78 C64B  30         mov   r11,*stack            ; Save return address
0128                       ;------------------------------------------------------
0129                       ; Dump VDP patterns
0130                       ;------------------------------------------------------
0131 7C7A 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7C7C 2F84     
0132 7C7E 600E                   data bank7.rom        ; | i  p0 = bank address
0133 7C80 7FE8                   data vec.21           ; | i  p1 = Vector with target address
0134 7C82 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0135                       ;------------------------------------------------------
0136                       ; Exit
0137                       ;------------------------------------------------------
0138 7C84 C2F9  30         mov   *stack+,r11           ; Pop r11
0139 7C86 045B  20         b     *r11                  ; Return to caller
0141               
0142               
0144               ***************************************************************
0145               * Stub for "magic.check"
0146               * bank7 vec.22
0147               ********|*****|*********************|**************************
0148               magic.check:
0149 7C88 0649  14         dect  stack
0150 7C8A C64B  30         mov   r11,*stack            ; Save return address
0151                       ;------------------------------------------------------
0152                       ; Dump VDP patterns
0153                       ;------------------------------------------------------
0154 7C8C 06A0  32         bl    @rom.farjump          ; \ Trampoline jump to bank
     7C8E 2F84     
0155 7C90 600E                   data bank7.rom        ; | i  p0 = bank address
0156 7C92 7FEA                   data vec.22           ; | i  p1 = Vector with target address
0157 7C94 6002                   data bankid           ; / i  p2 = Source ROM bank for return
0158                       ;------------------------------------------------------
0159                       ; Exit
0160                       ;------------------------------------------------------
0161 7C96 C2F9  30         mov   *stack+,r11           ; Pop r11
0162 7C98 045B  20         b     *r11                  ; Return to caller
                   < stevie_b1.asm.33260
0147                       ;-----------------------------------------------------------------------
0148                       ; Program data
0149                       ;-----------------------------------------------------------------------
0150                       copy  "data.keymap.actions.asm"     ; Keyboard actions
     **** ****     > data.keymap.actions.asm
0001               * FILE......: data.keymap.actions.asm
0002               * Purpose...: Keyboard actions
0003               
0004               *---------------------------------------------------------------
0005               * Action keys mapping table: Editor
0006               *---------------------------------------------------------------
0007               keymap_actions.editor:
0008                       ;-------------------------------------------------------
0009                       ; Movement keys
0010                       ;-------------------------------------------------------
0011 7C9A 0D00             byte  key.enter, pane.focus.fb
0012 7C9C 66C4             data  edkey.action.enter
0013               
0014 7C9E 0800             byte  key.fctn.s, pane.focus.fb
0015 7CA0 623A             data  edkey.action.left
0016               
0017 7CA2 0900             byte  key.fctn.d, pane.focus.fb
0018 7CA4 6254             data  edkey.action.right
0019               
0020 7CA6 0B00             byte  key.fctn.e, pane.focus.fb
0021 7CA8 6378             data  edkey.action.up
0022               
0023 7CAA 0A00             byte  key.fctn.x, pane.focus.fb
0024 7CAC 6380             data  edkey.action.down
0025               
0026 7CAE BF00             byte  key.fctn.h, pane.focus.fb
0027 7CB0 6270             data  edkey.action.home
0028               
0029 7CB2 C000             byte  key.fctn.j, pane.focus.fb
0030 7CB4 629A             data  edkey.action.pword
0031               
0032 7CB6 C100             byte  key.fctn.k, pane.focus.fb
0033 7CB8 62EC             data  edkey.action.nword
0034               
0035 7CBA C200             byte  key.fctn.l, pane.focus.fb
0036 7CBC 6278             data  edkey.action.end
0037               
0038 7CBE 0C00             byte  key.fctn.6, pane.focus.fb
0039 7CC0 6388             data  edkey.action.ppage
0040               
0041 7CC2 0200             byte  key.fctn.4, pane.focus.fb
0042 7CC4 63C4             data  edkey.action.npage
0043               
0044 7CC6 0E00             byte  key.fctn.5, pane.focus.fb
0045 7CC8 634C             data  edkey.action.scroll.right
0046               
0047 7CCA 8500             byte  key.ctrl.e, pane.focus.fb
0048 7CCC 6388             data  edkey.action.ppage
0049               
0050 7CCE 9800             byte  key.ctrl.x, pane.focus.fb
0051 7CD0 63C4             data  edkey.action.npage
0052               
0053 7CD2 7F00             byte  key.fctn.v, pane.focus.fb
0054 7CD4 641A             data  edkey.action.topscr
0055               
0056 7CD6 BE00             byte  key.fctn.b, pane.focus.fb
0057 7CD8 6464             data  edkey.action.botscr
0058               
0059 7CDA 9600             byte  key.ctrl.v, pane.focus.fb
0060 7CDC 63FE             data  edkey.action.top
0061               
0062 7CDE 8200             byte  key.ctrl.b, pane.focus.fb
0063 7CE0 6434             data  edkey.action.bot
0064                       ;-------------------------------------------------------
0065                       ; Modifier keys - Delete
0066                       ;-------------------------------------------------------
0067 7CE2 0300             byte  key.fctn.1, pane.focus.fb
0068 7CE4 64F2             data  edkey.action.del_char
0069               
0070 7CE6 0700             byte  key.fctn.3, pane.focus.fb
0071 7CE8 65A4             data  edkey.action.del_line
0072               
0073 7CEA 8C00             byte  key.ctrl.l, pane.focus.fb
0074 7CEC 6570             data  edkey.action.del_eol
0075                       ;-------------------------------------------------------
0076                       ; Modifier keys - Insert
0077                       ;-------------------------------------------------------
0078 7CEE 0400             byte  key.fctn.2, pane.focus.fb
0079 7CF0 6606             data  edkey.action.ins_char.ws
0080               
0081 7CF2 B900             byte  key.fctn.dot, pane.focus.fb
0082 7CF4 674A             data  edkey.action.ins_onoff
0083               
0084 7CF6 0100             byte  key.fctn.7, pane.focus.fb
0085 7CF8 6938             data  edkey.action.fb.tab.next
0086               
0087 7CFA 9400             byte  key.ctrl.t, pane.focus.fb
0088 7CFC 6938             data  edkey.action.fb.tab.next
0089               
0090 7CFE 0600             byte  key.fctn.8, pane.focus.fb
0091 7D00 66AC             data  edkey.action.ins_line
0092                       ;-------------------------------------------------------
0093                       ; Block marking/modifier
0094                       ;-------------------------------------------------------
0095 7D02 F000             byte  key.ctrl.space, pane.focus.fb
0096 7D04 6872             data  edkey.action.block.mark
0097               
0098 7D06 8300             byte  key.ctrl.c, pane.focus.fb
0099 7D08 6812             data  edkey.action.copyblock_or_clipboard
0100               
0101 7D0A 8400             byte  key.ctrl.d, pane.focus.fb
0102 7D0C 68C2             data  edkey.action.block.delete
0103               
0104 7D0E 8D00             byte  key.ctrl.m, pane.focus.fb
0105 7D10 68EC             data  edkey.action.block.move
0106               
0107 7D12 8700             byte  key.ctrl.g, pane.focus.fb
0108 7D14 691E             data  edkey.action.block.goto.m1
0109                       ;-------------------------------------------------------
0110                       ; Clipboards
0111                       ;-------------------------------------------------------
0112 7D16 B100             byte  key.ctrl.1, pane.focus.fb
0113 7D18 6946             data  edkey.action.fb.clip.save.1
0114               
0115 7D1A B200             byte  key.ctrl.2, pane.focus.fb
0116 7D1C 694C             data  edkey.action.fb.clip.save.2
0117               
0118 7D1E B300             byte  key.ctrl.3, pane.focus.fb
0119 7D20 6952             data  edkey.action.fb.clip.save.3
0120               
0121 7D22 B400             byte  key.ctrl.4, pane.focus.fb
0122 7D24 6958             data  edkey.action.fb.clip.save.4
0123               
0124 7D26 B500             byte  key.ctrl.5, pane.focus.fb
0125 7D28 695E             data  edkey.action.fb.clip.save.5
0126                       ;-------------------------------------------------------
0127                       ; Other action keys
0128                       ;-------------------------------------------------------
0129 7D2A 0500             byte  key.fctn.plus, pane.focus.fb
0130 7D2C 6804             data  edkey.action.quit
0131               
0132 7D2E 9100             byte  key.ctrl.q, pane.focus.fb
0133 7D30 6804             data  edkey.action.quit
0134               
0135 7D32 9500             byte  key.ctrl.u, pane.focus.fb
0136 7D34 67C4             data  edkey.action.toggle.ruler
0137               
0138 7D36 9A00             byte  key.ctrl.z, pane.focus.fb
0139 7D38 72A0             data  pane.action.colorscheme.cycle
0140               
0141 7D3A 8000             byte  key.ctrl.comma, pane.focus.fb
0142 7D3C 6822             data  edkey.action.fb.fname.dec.load
0143               
0144 7D3E 9B00             byte  key.ctrl.dot, pane.focus.fb
0145 7D40 6834             data  edkey.action.fb.fname.inc.load
0146               
0147 7D42 BB00             byte  key.ctrl.slash, pane.focus.fb
0148 7D44 7A40             data  dialog.basic
0149               
0150 7D46 BC00             byte  key.fctn.0, pane.focus.fb
0151 7D48 7A40             data  dialog.basic
0152                       ;-------------------------------------------------------
0153                       ; Dialog keys
0154                       ;-------------------------------------------------------
0155 7D4A 8100             byte  key.ctrl.a, pane.focus.fb
0156 7D4C 7A2C             data  dialog.append
0157               
0158 7D4E 8800             byte  key.ctrl.h, pane.focus.fb
0159 7D50 79C4             data  dialog.help
0160               
0161 7D52 8600             byte  key.ctrl.f, pane.focus.fb
0162 7D54 79F6             data  dialog.file
0163               
0164 7D56 8900             byte  key.ctrl.i, pane.focus.fb
0165 7D58 79E2             data  dialog.insert
0166               
0167 7D5A 9300             byte  key.ctrl.s, pane.focus.fb
0168 7D5C 79D8             data  dialog.save
0169               
0170 7D5E 8F00             byte  key.ctrl.o, pane.focus.fb
0171 7D60 79CE             data  dialog.load
0172               
0173 7D62 9000             byte  key.ctrl.p, pane.focus.fb
0174 7D64 79EC             data  dialog.print
0175               
0176                       ;
0177                       ; FCTN-9 has multiple purposes, if block mode is on it
0178                       ; resets the block, otherwise show dialog "Main Menu".
0179                       ;
0180 7D66 0F00             byte  key.fctn.9, pane.focus.fb
0181 7D68 7A4A             data  dialog.menu
0182                       ;-------------------------------------------------------
0183                       ; End of list
0184                       ;-------------------------------------------------------
0185 7D6A FFFF             data  EOL                           ; EOL
0186               
0187               
0188               
0189               *---------------------------------------------------------------
0190               * Action keys mapping table: Command Buffer (CMDB)
0191               *---------------------------------------------------------------
0192               keymap_actions.cmdb:
0193                       ;-------------------------------------------------------
0194                       ; Dialog: Main Menu
0195                       ;-------------------------------------------------------
0196 7D6C 4664             byte  key.uc.f, id.dialog.menu
0197 7D6E 79F6             data  dialog.file
0198               
0199 7D70 4364             byte  key.uc.c, id.dialog.menu
0200 7D72 7A36             data  dialog.cartridge
0201               
0202 7D74 4864             byte  key.uc.h, id.dialog.menu
0203 7D76 79C4             data  dialog.help
0204               
0205 7D78 5164             byte  key.uc.q, id.dialog.menu
0206 7D7A 6804             data  edkey.action.quit
0207                       ;-------------------------------------------------------
0208                       ; Dialog: File
0209                       ;-------------------------------------------------------
0210 7D7C 4E69             byte  key.uc.n, id.dialog.file
0211 7D7E 6A42             data  edkey.action.cmdb.file.new
0212               
0213 7D80 5369             byte  key.uc.s, id.dialog.file
0214 7D82 79D8             data  dialog.save
0215               
0216 7D84 4F69             byte  key.uc.o, id.dialog.file
0217 7D86 79CE             data  dialog.load
0218               
0219 7D88 5069             byte  key.uc.p, id.dialog.file
0220 7D8A 79EC             data  dialog.print
0221               
0222 7D8C 4369             byte  key.uc.c, id.dialog.file
0223 7D8E 7A22             data  dialog.config
0224                       ;-------------------------------------------------------
0225                       ; Dialog: Open file
0226                       ;-------------------------------------------------------
0227 7D90 0E0A             byte  key.fctn.5, id.dialog.load
0228 7D92 6D60             data  edkey.action.cmdb.fastmode.toggle
0229               
0230 7D94 0D0A             byte  key.enter, id.dialog.load
0231 7D96 6A68             data  edkey.action.cmdb.load
0232                       ;-------------------------------------------------------
0233                       ; Dialog: Insert file at line ...
0234                       ;-------------------------------------------------------
0235 7D98 0E0D             byte  key.fctn.5, id.dialog.insert
0236 7D9A 6D60             data  edkey.action.cmdb.fastmode.toggle
0237               
0238 7D9C 0D0D             byte  key.enter, id.dialog.insert
0239 7D9E 6AAC             data  edkey.action.cmdb.insert
0240                       ;-------------------------------------------------------
0241                       ; Dialog: Append file
0242                       ;-------------------------------------------------------
0243 7DA0 0E0E             byte  key.fctn.5, id.dialog.append
0244 7DA2 6D60             data  edkey.action.cmdb.fastmode.toggle
0245               
0246 7DA4 0D0E             byte  key.enter, id.dialog.append
0247 7DA6 6B2E             data  edkey.action.cmdb.append
0248                       ;-------------------------------------------------------
0249                       ; Dialog: Copy clipboard to line ...
0250                       ;-------------------------------------------------------
0251 7DA8 0E67             byte  key.fctn.5, id.dialog.clipboard
0252 7DAA 6D60             data  edkey.action.cmdb.fastmode.toggle
0253               
0254 7DAC 0167             byte  key.fctn.7, id.dialog.clipboard
0255 7DAE 7A18             data  dialog.clipdev
0256               
0257 7DB0 3167             byte  key.num.1, id.dialog.clipboard
0258 7DB2 6BA2             data  edkey.action.cmdb.clip.1
0259               
0260 7DB4 3267             byte  key.num.2, id.dialog.clipboard
0261 7DB6 6BA8             data  edkey.action.cmdb.clip.2
0262               
0263 7DB8 3367             byte  key.num.3, id.dialog.clipboard
0264 7DBA 6BAE             data  edkey.action.cmdb.clip.3
0265               
0266 7DBC 3467             byte  key.num.4, id.dialog.clipboard
0267 7DBE 6BB4             data  edkey.action.cmdb.clip.4
0268               
0269 7DC0 3567             byte  key.num.5, id.dialog.clipboard
0270 7DC2 6BBA             data  edkey.action.cmdb.clip.5
0271                       ;-------------------------------------------------------
0272                       ; Dialog: Configure clipboard device
0273                       ;-------------------------------------------------------
0274 7DC4 0D11             byte  key.enter, id.dialog.clipdev
0275 7DC6 6BEE             data  edkey.action.cmdb.clipdev.configure
0276                       ;-------------------------------------------------------
0277                       ; Dialog: Configure
0278                       ;-------------------------------------------------------
0279 7DC8 436C             byte  key.uc.c, id.dialog.config
0280 7DCA 7A18             data  dialog.clipdev
0281                       ;-------------------------------------------------------
0282                       ; Dialog: Save file
0283                       ;-------------------------------------------------------
0284 7DCC 0D0B             byte  key.enter, id.dialog.save
0285 7DCE 6C3E             data  edkey.action.cmdb.save
0286               
0287 7DD0 0D0C             byte  key.enter, id.dialog.saveblock
0288 7DD2 6C3E             data  edkey.action.cmdb.save
0289                       ;-------------------------------------------------------
0290                       ; Dialog: Print file
0291                       ;-------------------------------------------------------
0292 7DD4 0D0F             byte  key.enter, id.dialog.print
0293 7DD6 6CBA             data  edkey.action.cmdb.print
0294               
0295 7DD8 0D10             byte  key.enter, id.dialog.printblock
0296 7DDA 6CBA             data  edkey.action.cmdb.print
0297                       ;-------------------------------------------------------
0298                       ; Dialog: Unsaved changes
0299                       ;-------------------------------------------------------
0300 7DDC 0C65             byte  key.fctn.6, id.dialog.unsaved
0301 7DDE 6D36             data  edkey.action.cmdb.proceed
0302               
0303 7DE0 2065             byte  key.space, id.dialog.unsaved
0304 7DE2 6D36             data  edkey.action.cmdb.proceed
0305               
0306 7DE4 0D65             byte  key.enter, id.dialog.unsaved
0307 7DE6 79D8             data  dialog.save
0308                       ;-------------------------------------------------------
0309                       ; Dialog: Cartridge
0310                       ;-------------------------------------------------------
0311 7DE8 426A             byte  key.uc.b, id.dialog.cartridge
0312 7DEA 7A40             data  dialog.basic
0313                       ;-------------------------------------------------------
0314                       ; Dialog: Basic
0315                       ;-------------------------------------------------------
0316 7DEC 316B             byte  key.num.1, id.dialog.basic
0317 7DEE 7BCC             data  tibasic1
0318               
0319 7DF0 326B             byte  key.num.2, id.dialog.basic
0320 7DF2 7BD4             data  tibasic2
0321               
0322 7DF4 336B             byte  key.num.3, id.dialog.basic
0323 7DF6 7BDC             data  tibasic3
0324               
0325 7DF8 346B             byte  key.num.4, id.dialog.basic
0326 7DFA 7BE4             data  tibasic4
0327               
0328 7DFC 356B             byte  key.num.5, id.dialog.basic
0329 7DFE 7BEC             data  tibasic5
0330               
0331 7E00 0E6B             byte  key.fctn.5, id.dialog.basic
0332 7E02 6D6C             data  edkey.action.cmdb.am.toggle
0333               
0334 7E04 206B             byte  key.space, id.dialog.basic
0335 7E06 7C14             data  tibasic.uncrunch
0336                       ;-------------------------------------------------------
0337                       ; Dialog: Help
0338                       ;-------------------------------------------------------
0339 7E08 2068             byte  key.space, id.dialog.help
0340 7E0A 79B0             data  dialog.help.next
0341               
0342 7E0C 0F68             byte  key.fctn.9, id.dialog.help
0343 7E0E 6D80             data  edkey.action.cmdb.close.about
0344               
0345 7E10 0D68             byte  key.enter, id.dialog.help
0346 7E12 6D80             data  edkey.action.cmdb.close.about
0347                       ;-------------------------------------------------------
0348                       ; Movement keys
0349                       ;-------------------------------------------------------
0350 7E14 0801             byte  key.fctn.s, pane.focus.cmdb
0351 7E16 6976             data  edkey.action.cmdb.left
0352               
0353 7E18 0901             byte  key.fctn.d, pane.focus.cmdb
0354 7E1A 6988             data  edkey.action.cmdb.right
0355               
0356 7E1C BF01             byte  key.fctn.h, pane.focus.cmdb
0357 7E1E 69A0             data  edkey.action.cmdb.home
0358               
0359 7E20 C201             byte  key.fctn.l, pane.focus.cmdb
0360 7E22 69B4             data  edkey.action.cmdb.end
0361                       ;-------------------------------------------------------
0362                       ; Modifier keys
0363                       ;-------------------------------------------------------
0364 7E24 0701             byte  key.fctn.3, pane.focus.cmdb
0365 7E26 69CC             data  edkey.action.cmdb.clear
0366                       ;-------------------------------------------------------
0367                       ; Other action keys
0368                       ;-------------------------------------------------------
0369 7E28 0F01             byte  key.fctn.9, pane.focus.cmdb
0370 7E2A 6D96             data  edkey.action.cmdb.close.dialog
0371               
0372 7E2C 0501             byte  key.fctn.plus, pane.focus.cmdb
0373 7E2E 6804             data  edkey.action.quit
0374               
0375 7E30 8101             byte  key.ctrl.a, pane.focus.cmdb
0376 7E32 6D78             data  edkey.action.cmdb.preset
0377               
0378 7E34 8201             byte  key.ctrl.b, pane.focus.cmdb
0379 7E36 6D78             data  edkey.action.cmdb.preset
0380               
0381 7E38 8301             byte  key.ctrl.c, pane.focus.cmdb
0382 7E3A 6D78             data  edkey.action.cmdb.preset
0383               
0384 7E3C 9A01             byte  key.ctrl.z, pane.focus.cmdb
0385 7E3E 72A0             data  pane.action.colorscheme.cycle
0386                       ;------------------------------------------------------
0387                       ; End of list
0388                       ;-------------------------------------------------------
0389 7E40 FFFF             data  EOL                           ; EOL
                   < stevie_b1.asm.33260
0151                       ;-----------------------------------------------------------------------
0152                       ; Bank full check
0153                       ;-----------------------------------------------------------------------
0157                       ;-----------------------------------------------------------------------
0158                       ; Show ROM bank in CPU crash screen
0159                       ;-----------------------------------------------------------------------
0160                       copy "rom.crash.asm"
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
                   < stevie_b1.asm.33260
0161                       ;-----------------------------------------------------------------------
0162                       ; Vector table
0163                       ;-----------------------------------------------------------------------
0164                       copy  "rom.vectors.bank1.asm"
     **** ****     > rom.vectors.bank1.asm
0001               * FILE......: rom.vectors.bank1.asm
0002               * Purpose...: Bank 1 vectors for trampoline function
0003               
0004               *--------------------------------------------------------------
0005               * ROM identification string for CPU crash
0006               *--------------------------------------------------------------
0007               cpu.crash.showbank.bankstr:
0008               
0009 7F0A 05               byte  5
0010 7F0B   52             text  'ROM#1'
     7F0C 4F4D     
     7F0E 2331     
0011                       even
0012               
0013               
0014               *--------------------------------------------------------------
0015               * Vector table for trampoline functions
0016               *--------------------------------------------------------------
0017                       aorg  bankx.vectab
0018               
0019 7FC0 60F6     vec.1   data  mem.sams.setup.stevie ;
0020 7FC2 2026     vec.2   data  cpu.crash             ;
0021 7FC4 2026     vec.3   data  cpu.crash             ;
0022 7FC6 2026     vec.4   data  cpu.crash             ;
0023 7FC8 2026     vec.5   data  cpu.crash             ;
0024 7FCA 2026     vec.6   data  cpu.crash             ;
0025 7FCC 2026     vec.7   data  cpu.crash             ;
0026 7FCE 2026     vec.8   data  cpu.crash             ;
0027 7FD0 2026     vec.9   data  cpu.crash             ;
0028 7FD2 704A     vec.10  data  edb.line.pack.fb      ;
0029 7FD4 7142     vec.11  data  edb.line.unpack.fb    ;
0030 7FD6 7B4E     vec.12  data  edb.clear.sams        ;
0031 7FD8 2026     vec.13  data  cpu.crash             ;
0032 7FDA 2026     vec.14  data  cpu.crash             ;
0033 7FDC 6A30     vec.15  data  edkey.action.cmdb.show
0034 7FDE 2026     vec.16  data  cpu.crash             ;
0035 7FE0 2026     vec.17  data  cpu.crash             ;
0036 7FE2 6D9E     vec.18  data  cmdb.dialog.close     ;
0037 7FE4 7AAE     vec.19  data  cmdb.cmd.clear        ;
0038 7FE6 6F98     vec.20  data  fb.refresh            ;
0039 7FE8 7B3C     vec.21  data  fb.vdpdump            ;
0040 7FEA 307A     vec.22  data  fb.row2line           ;
0041 7FEC 2026     vec.23  data  cpu.crash             ;
0042 7FEE 2026     vec.24  data  cpu.crash             ;
0043 7FF0 2026     vec.25  data  cpu.crash             ;
0044 7FF2 2026     vec.26  data  cpu.crash             ;
0045 7FF4 76F2     vec.27  data  pane.errline.hide     ;
0046 7FF6 7536     vec.28  data  pane.cursor.blink     ;
0047 7FF8 7518     vec.29  data  pane.cursor.hide      ;
0048 7FFA 7690     vec.30  data  pane.errline.show     ;
0049 7FFC 72FE     vec.31  data  pane.action.colorscheme.load
0050 7FFE 74FE     vec.32  data  pane.action.colorscheme.statlines
                   < stevie_b1.asm.33260
0165                                                   ; Vector table bank 1
0166               *--------------------------------------------------------------
0167               * Video mode configuration
0168               *--------------------------------------------------------------
0169      00F4     spfclr  equ   >f4                   ; Foreground/Background color for font.
0170      0004     spfbck  equ   >04                   ; Screen background color.
0171      3650     spvmod  equ   stevie.80x30          ; Video mode.   See VIDTAB for details.
0172      000C     spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
0173      0050     colrow  equ   80                    ; Columns per row
0174      0FC0     pctadr  equ   >0fc0                 ; VDP color table base
0175      1100     fntadr  equ   >1100                 ; VDP font start address (in PDT range)
0176      2180     sprsat  equ   >2180                 ; VDP sprite attribute table
0177      2800     sprpdt  equ   >2800                 ; VDP sprite pattern table

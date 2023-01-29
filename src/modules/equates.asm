* FILE......: equates.asm
* Purpose...: The main equates file for Stevie editor


*===============================================================================
* Memory map
* ==========
*
* CARTRIDGE SPACE (6000-7fff)
*
*     Mem range   Bytes    BANK   Purpose
*     =========   =====    ====   ==================================
*     6000-633f               0   Cartridge header
*     6040-7fff               0   SP2 library + Stevie library
*                                 relocated to RAM space
*     ..............................................................
*     6000-633f               1   Cartridge header
*     6040-7fbf               1   Stevie program code
*     7fc0-7fff      64       1   Vector table (32 vectors)
*     ..............................................................
*     6000-633f               2   Cartridge header
*     6040-7fbf               2   Stevie program code
*     7fc0-7fff      64       2   Vector table (32 vectors)
*     ..............................................................
*     6000-633f               3   Cartridge header
*     6040-7fbf               3   Stevie program code
*     7fc0-7fff      64       3   Vector table (32 vectors)
*     ..............................................................
*     6000-633f               4   Cartridge header
*     6040-7fbf               4   Stevie program code
*     7fc0-7fff      64       4   Vector table (32 vectors)
*     ..............................................................
*     6000-633f               5   Cartridge header
*     6040-7fbf               5   Stevie program code
*     7fc0-7fff      64       5   Vector table (32 vectors)
*     ..............................................................
*     6000-633f               6   Cartridge header
*     6040-7fbf               6   Stevie program code
*     7fc0-7fff      64       6   Vector table (32 vectors)
*     ..............................................................
*     6000-633f               7   Cartridge header
*     6040-7fbf               7   SP2 library in cartridge space
*     7fc0-7fff      64       7   Vector table (32 vectors)
*===============================================================================



*--------------------------------------------------------------
* Stevie Dialog / Pane specific equates
*--------------------------------------------------------------
pane.focus.fb             equ  0       ; Editor pane has focus
pane.focus.cmdb           equ  1       ; Command buffer pane has focus
;-----------------------------------------------------------------
;   Dialog ID's
;-----------------------------------------------------------------
id.dialog.load            equ  10      ; "Load file"
id.dialog.save            equ  11      ; "Save file"
id.dialog.saveblock       equ  12      ; "Save block to file"
id.dialog.insert          equ  13      ; "Insert file"
id.dialog.append          equ  14      ; "Append file"
id.dialog.print           equ  15      ; "Print file"
id.dialog.printblock      equ  16      ; "Print block"
id.dialog.cfg.clip        equ  17      ; "Configure clipboard"
id.dialog.goto            equ  19      ; "Goto"
;-----------------------------------------------------------------
;   Dialog ID's >= 100 indicate that command prompt should be
;   hidden and no characters added to CMDB keyboard buffer.
;-----------------------------------------------------------------
id.dialog.menu            equ  100     ; "Main Menu"
id.dialog.unsaved         equ  101     ; "Unsaved changes"
id.dialog.block           equ  102     ; "Block move/copy/delete/print/..."
id.dialog.clipboard       equ  103     ; "Copy clipboard to line ..."
id.dialog.help            equ  104     ; "About"
id.dialog.file            equ  105     ; "File"
id.dialog.cartridge       equ  106     ; "Cartridge"
id.dialog.basic           equ  107     ; "TI Basic"
id.dialog.cfg             equ  108     ; "Configure"
id.dialog.editor          equ  109     ; "Configure editor"
id.dialog.font            equ  110     ; "Configure font"
id.dialog.shortcuts       equ  111     ; "Shortcuts"
*--------------------------------------------------------------
* Suffix characters for clipboards
*--------------------------------------------------------------
clip1                     equ  >3100   ; '1'
clip2                     equ  >3200   ; '2'
clip3                     equ  >3300   ; '3'
clip4                     equ  >3400   ; '4'
clip5                     equ  >3500   ; '5'
*--------------------------------------------------------------
* Keyboard flags in Stevie
*--------------------------------------------------------------
kbf.kbclear               equ  >0001   ;  Keyboard buffer cleared / @w$0001
*--------------------------------------------------------------
* File work mode
*--------------------------------------------------------------
id.file.loadfile          equ  1       ; Load file
id.file.insertfile        equ  2       ; Insert file
id.file.appendfile        equ  3       ; Append file
id.file.savefile          equ  4       ; Save file
id.file.saveblock         equ  5       ; Save block to file
id.file.clipblock         equ  6       ; Save block to clipboard
id.file.printfile         equ  7       ; Print file
id.file.printblock        equ  8       ; Print block
*--------------------------------------------------------------
* Special file indicator
*--------------------------------------------------------------
id.special.normal         equ  0       ; Normal file
id.special.mastcat        equ  1       ; Master catalog
id.special.readonly       equ  2       ; Read-only file
*--------------------------------------------------------------
* Stevie core 1 RAM                   @>a000-a0ff   (256 bytes)
*--------------------------------------------------------------
core1.top         equ  >a000           ; Structure begin
magic.str.w1      equ  core1.top + 0   ; Magic string word 1
magic.str.w2      equ  core1.top + 2   ; Magic string word 2
magic.str.w3      equ  core1.top + 4   ; Magic string word 3
parm1             equ  core1.top + 6   ; Function parameter 1
parm2             equ  core1.top + 8   ; Function parameter 2
parm3             equ  core1.top + 10  ; Function parameter 3
parm4             equ  core1.top + 12  ; Function parameter 4
parm5             equ  core1.top + 14  ; Function parameter 5
parm6             equ  core1.top + 16  ; Function parameter 6
parm7             equ  core1.top + 18  ; Function parameter 7
parm8             equ  core1.top + 20  ; Function parameter 8
parm9             equ  core1.top + 22  ; Function parameter 9
outparm1          equ  core1.top + 24  ; Function output parameter 1
outparm2          equ  core1.top + 26  ; Function output parameter 2
outparm3          equ  core1.top + 28  ; Function output parameter 3
outparm4          equ  core1.top + 30  ; Function output parameter 4
outparm5          equ  core1.top + 32  ; Function output parameter 5
outparm6          equ  core1.top + 34  ; Function output parameter 6
outparm7          equ  core1.top + 36  ; Function output parameter 7
kbflags           equ  core1.top + 38  ; Keyboard control flags
keycode1          equ  core1.top + 40  ; Current key scanned
keycode2          equ  core1.top + 42  ; Previous key scanned
uint16.unpacked   equ  core1.top + 44  ; Unpacked uint16 (len-prefixed string)
uint16.packed     equ  core1.top + 50  ; Packed uint16 (2 bytes)
trmpvector        equ  core1.top + 52  ; Vector trampoline (if p1|tmp1 = >ffff)
core1.free1       equ  core1.top + 54  ; 54-85 **free**
ramsat            equ  core1.top + 86  ; Sprite Attr. Table in RAM (14 bytes)
timers            equ  core1.top + 100 ; Timers (80 bytes)
                  ;--------------------------------------------
                  ; TI Basic related
                  ;--------------------------------------------
tib.session       equ  core1.top + 180 ; Current TI-Basic session (1-5)
tib.status1       equ  core1.top + 182 ; Status flags TI Basic session 1
tib.status2       equ  core1.top + 184 ; Status flags TI Basic session 2
tib.status3       equ  core1.top + 186 ; Status flags TI Basic session 3
tib.status4       equ  core1.top + 188 ; Status flags TI Basic session 4
tib.status5       equ  core1.top + 190 ; Status flags TI Basic session 5
tib.autounpk      equ  core1.top + 192 ; TI-Basic AutoUnpack (uncrunch)
tib.stab.ptr      equ  core1.top + 194 ; Pointer to TI-Basic SAMS page table
tib.scrpad.ptr    equ  core1.top + 196 ; Pointer to TI-Basic scratchpad in SAMS
tib.lnt.top.ptr   equ  core1.top + 198 ; Pointer to top of line number table
tib.lnt.bot.ptr   equ  core1.top + 200 ; Pointer to bottom of line number table
tib.symt.top.ptr  equ  core1.top + 202 ; Pointer to top of symbol table
tib.symt.bot.ptr  equ  core1.top + 204 ; Pointer to bottom of symbol table
tib.strs.top.ptr  equ  core1.top + 206 ; Pointer to top of string space
tib.strs.bot.ptr  equ  core1.top + 208 ; Pointer to bottom of string space
tib.lines         equ  core1.top + 210 ; Number of lines in TI Basic program
core1.free2       equ  core1.top + 212 ; **free* up to 233
tib.samstab.ptr   equ  core1.top + 234 ; Pointer to active SAMS mem layout table
tib.var1          equ  core1.top + 236 ; Temp variable 1
tib.var2          equ  core1.top + 238 ; Temp variable 2
tib.var3          equ  core1.top + 240 ; Temp variable 3
tib.var4          equ  core1.top + 242 ; Temp variable 4
tib.var5          equ  core1.top + 244 ; Temp variable 5
tib.var6          equ  core1.top + 246 ; Temp variable 6
tib.var7          equ  core1.top + 248 ; Temp variable 7
tib.var8          equ  core1.top + 250 ; Temp variable 8
tib.var9          equ  core1.top + 252 ; Temp variable 9
tib.var10         equ  core1.top + 254 ; Temp variable 10
core1.free        equ  core1.top + 256 ; End of structure
*--------------------------------------------------------------
* Stevie core 2 RAM                   @>a100-a1ff   (256 bytes)
*--------------------------------------------------------------
core2.top         equ  >a100           ; Structure begin
rambuf            equ  core2.top       ; RAM workbuffer
core2.free        equ  core2.top + 256 ; End of structure
*--------------------------------------------------------------
* Stevie Editor shared structures     @>a200-a2ff   (256 bytes)
*--------------------------------------------------------------
tv.top            equ  >a200           ; Structure begin
tv.sams.2000      equ  tv.top + 0      ; SAMS page in window >2000-2fff
tv.sams.3000      equ  tv.top + 2      ; SAMS page in window >3000-3fff
tv.sams.a000      equ  tv.top + 4      ; SAMS page in window >a000-afff
tv.sams.b000      equ  tv.top + 6      ; SAMS page in window >b000-bfff
tv.sams.c000      equ  tv.top + 8      ; SAMS page in window >c000-cfff
tv.sams.d000      equ  tv.top + 10     ; SAMS page in window >d000-dfff
tv.sams.e000      equ  tv.top + 12     ; SAMS page in window >e000-efff
tv.sams.f000      equ  tv.top + 14     ; SAMS page in window >f000-ffff
tv.ruler.visible  equ  tv.top + 16     ; Show ruler with tab positions
tv.colorscheme    equ  tv.top + 18     ; Current color scheme (0-xx)
tv.curshape       equ  tv.top + 20     ; Cursor shape and color (sprite)
tv.curcolor       equ  tv.top + 22     ; Cursor color1 + color2 (color scheme)
tv.color          equ  tv.top + 24     ; FG/BG-color framebuffer + status lines
tv.markcolor      equ  tv.top + 26     ; FG/BG-color marked lines in framebuffer
tv.busycolor      equ  tv.top + 28     ; FG/BG-color bottom line when busy
tv.rulercolor     equ  tv.top + 30     ; FG/BG-color ruler line
tv.cmdb.hcolor    equ  tv.top + 32     ; FG/BG-color command buffer header line
tv.font.ptr       equ  tv.top + 34     ; Pointer to font (in ROM bank 6 or RAM)
tv.pane.focus     equ  tv.top + 36     ; Identify pane that has focus
tv.task.oneshot   equ  tv.top + 38     ; Pointer to one-shot routine
tv.fj.stackpnt    equ  tv.top + 40     ; Pointer to farjump return stack
tv.error.visible  equ  tv.top + 42     ; Error pane visible
tv.error.rows     equ  tv.top + 44     ; Number of rows in error pane
tv.sp2.conf       equ  tv.top + 46     ; Backup of SP2 config register
tv.sp2.stack      equ  tv.top + 48     ; Backup of SP2 stack register
tv.fg99.img.ptr   equ  tv.top + 50     ; Pointer to Final GROM cartridge to load
tv.error.msg      equ  tv.top + 52     ; Error message (max. 160 characters)
tv.free           equ  tv.top + 212    ; End of structure
*--------------------------------------------------------------
* Frame buffer structure              @>a300-a3ff   (256 bytes)
*--------------------------------------------------------------
fb.struct         equ  >a300           ; Structure begin
fb.top.ptr        equ  fb.struct       ; Pointer to frame buffer
fb.current        equ  fb.struct + 2   ; Pointer to current pos. in frame buffer
fb.topline        equ  fb.struct + 4   ; Top line in frame buffer (matching
                                       ; line X in editor buffer).
fb.row            equ  fb.struct + 6   ; Current row in frame buffer
                                       ; (offset 0 .. @fb.scrrows)
fb.row.length     equ  fb.struct + 8   ; Length of current row in frame buffer
fb.row.dirty      equ  fb.struct + 10  ; Current row dirty flag in frame buffer
fb.column         equ  fb.struct + 12  ; Current column (0-79) in frame buffer
fb.colsline       equ  fb.struct + 14  ; Columns per line in frame buffer
fb.vwco           equ  fb.struct + 16  ; View window column offset (0-xxx)
fb.colorize       equ  fb.struct + 18  ; M1/M2 colorize refresh required
fb.curtoggle      equ  fb.struct + 20  ; Cursor shape toggle
fb.yxsave         equ  fb.struct + 22  ; Copy of cursor YX position
fb.dirty          equ  fb.struct + 24  ; Frame buffer dirty flag
fb.status.dirty   equ  fb.struct + 26  ; Status line(s) dirty flag
fb.scrrows        equ  fb.struct + 28  ; Rows on physical screen for framebuffer
fb.scrrows.max    equ  fb.struct + 30  ; Max # of rows on physical screen for fb
fb.ruler.sit      equ  fb.struct + 32  ; 80 char ruler  (no length-prefix!)
fb.ruler.tat      equ  fb.struct + 112 ; 80 char colors (no length-prefix!)
fb.free           equ  fb.struct + 192 ; End of structure
*--------------------------------------------------------------
* File handle structure               @>a400-a4ff   (256 bytes)
*--------------------------------------------------------------
fh.struct         equ  >a400           ; stevie file handling structures
;*******************************************************************************
; ATTENTION: dsrlnk vars must form a continuous memory block & keep their order!
;*******************************************************************************
dsrlnk.dsrlws     equ  fh.struct       ; Address of dsrlnk workspace 32 bytes
dsrlnk.namsto     equ  fh.struct + 32  ; 8-byte RAM buf for holding device name
dsrlnk.sav8a      equ  fh.struct + 40  ; Save parm (8 or A) after "blwp @dsrlnk"
dsrlnk.savcru     equ  fh.struct + 42  ; CRU address of device in prev. DSR call
dsrlnk.savent     equ  fh.struct + 44  ; DSR entry addr of prev. DSR call
dsrlnk.savpab     equ  fh.struct + 46  ; Pointer to Device or Subprogram in PAB
dsrlnk.savver     equ  fh.struct + 48  ; Version used in prev. DSR call
dsrlnk.savlen     equ  fh.struct + 50  ; Length of DSR name of prev. DSR call
dsrlnk.flgptr     equ  fh.struct + 52  ; Pointer to VDP PAB byte 1 (flag byte)
fh.pab.ptr        equ  fh.struct + 54  ; Pointer to VDP PAB, for level 3 FIO
fh.pabstat        equ  fh.struct + 56  ; Copy of VDP PAB status byte
fh.ioresult       equ  fh.struct + 58  ; DSRLNK IO-status after file operation
fh.records        equ  fh.struct + 60  ; File records counter
fh.reclen         equ  fh.struct + 62  ; Current record length
fh.kilobytes      equ  fh.struct + 64  ; Kilobytes processed (read/written)
fh.counter        equ  fh.struct + 66  ; Counter used in stevie file operations
fh.fname.ptr      equ  fh.struct + 68  ; Pointer to device and filename
fh.sams.page      equ  fh.struct + 70  ; Current SAMS page during file operation
fh.sams.hipage    equ  fh.struct + 72  ; Highest SAMS page in file operation
fh.fopmode        equ  fh.struct + 74  ; FOP mode (File Operation Mode)
fh.filetype       equ  fh.struct + 76  ; Value for filetype/mode (PAB byte 1)
fh.offsetopcode   equ  fh.struct + 78  ; Set to >40 for skipping VDP buffer
fh.callback1      equ  fh.struct + 80  ; Pointer to callback function 1
fh.callback2      equ  fh.struct + 82  ; Pointer to callback function 2
fh.callback3      equ  fh.struct + 84  ; Pointer to callback function 3
fh.callback4      equ  fh.struct + 86  ; Pointer to callback function 4
fh.callback5      equ  fh.struct + 88  ; Pointer to callback function 5
fh.workmode       equ  fh.struct + 90  ; Working mode (used in callbacks)
fh.kilobytes.prev equ  fh.struct + 92  ; Kilobytes processed (previous)
fh.line           equ  fh.struct + 94  ; Editor buffer line currently processing
fh.temp1          equ  fh.struct + 96  ; Temporary variable 1
fh.temp2          equ  fh.struct + 98  ; Temporary variable 2
fh.temp3          equ  fh.struct +100  ; Temporary variable 3
fh.pabtpl.ptr     equ  fh.struct +102  ; Pointer to PAB template in ROM/RAM
fh.membuffer      equ  fh.struct +104  ; 80 bytes file memory buffer
fh.free           equ  fh.struct +184  ; End of structure
*--------------------------------------------------------------
* File handle structure for generic   @>a400-a4ff   (256 bytes)
* Overload file handle structure
*--------------------------------------------------------------
fh.ftype.init     equ  fh.struct + 90  ; File type/mode (becomes fh.filetype)
fh.ram.ptr        equ  fh.struct + 92  ; RAM destination address

*--------------------------------------------------------------
* Editor buffer structure             @>a500-a5ff   (256 bytes)
*--------------------------------------------------------------
edb.struct        equ  >a500           ; Begin structure
edb.top.ptr       equ  edb.struct      ; Pointer to editor buffer
edb.index.ptr     equ  edb.struct + 2  ; Pointer to index
edb.lines         equ  edb.struct + 4  ; Total lines in editor buffer - 1
edb.dirty         equ  edb.struct + 6  ; Editor buffer dirty (Text changed!)
edb.next_free.ptr equ  edb.struct + 8  ; Pointer to next free line
edb.insmode       equ  edb.struct + 10 ; Insert mode (>ffff = insert)
edb.autoinsert    equ  edb.struct + 12 ; Auto-insert on ENTER flag (>ffff = on)
edb.block.m1      equ  edb.struct + 14 ; Block start line marker (>ffff = unset)
edb.block.m2      equ  edb.struct + 16 ; Block end line marker   (>ffff = unset)
edb.block.var     equ  edb.struct + 18 ; Local var used in block operation
edb.filename.ptr  equ  edb.struct + 20 ; Pointer to length-prefixed string
                                       ; with current filename.
edb.filetype.ptr  equ  edb.struct + 22 ; Pointer to length-prefixed string
                                       ; with current file type.
edb.sams.page     equ  edb.struct + 24 ; Current SAMS page
edb.sams.hipage   equ  edb.struct + 26 ; Highest SAMS page in use
edb.bk.fb.topline equ  edb.struct + 28 ; Backup of @fb.topline before opening
                                       ; other file from special file.
edb.bk.fb.row     equ  edb.struct + 30 ; Backup of @fb.row before opening
                                       ; other file from special file.
edb.special.file  equ  edb.struct + 32 ; Special file in editor buffer                                    
edb.filename      equ  edb.struct + 34 ; 80 characters inline buffer reserved
                                       ; for filename, but not always used.
edb.free          equ  edb.struct + 114; End of structure
*--------------------------------------------------------------
* Index structure                     @>a600-a6ff   (256 bytes)
*--------------------------------------------------------------
idx.struct        equ  >a600           ; stevie index structure
idx.sams.page     equ  idx.struct      ; Current SAMS page
idx.sams.lopage   equ  idx.struct + 2  ; Lowest SAMS page
idx.sams.hipage   equ  idx.struct + 4  ; Highest SAMS page
idx.free          equ  idx.struct + 6  ; End of structure
*--------------------------------------------------------------
* Command buffer structure            @>a700-a7ff   (256 bytes)
*--------------------------------------------------------------
cmdb.struct       equ  >a700           ; Command Buffer structure
cmdb.top.ptr      equ  cmdb.struct     ; Pointer to command buffer (history)
cmdb.visible      equ  cmdb.struct + 2 ; Command buffer visible? (>ffff=visible)
cmdb.fb.yxsave    equ  cmdb.struct + 4 ; Copy of FB WYX when entering cmdb pane
cmdb.scrrows      equ  cmdb.struct + 6 ; Current size of CMDB pane (in rows)
cmdb.default      equ  cmdb.struct + 8 ; Default size of CMDB pane (in rows)
cmdb.cursor       equ  cmdb.struct + 10; Screen YX of cursor in CMDB pane
cmdb.yxsave       equ  cmdb.struct + 12; Copy of WYX
cmdb.vdptop       equ  cmdb.struct + 14; VDP address CMDB pane header line (TAT)
cmdb.yxtop        equ  cmdb.struct + 16; YX position CMDB pane header line
cmdb.yxprompt     equ  cmdb.struct + 18; YX position of command buffer prompt
cmdb.column       equ  cmdb.struct + 20; Current column in command buffer pane
cmdb.length       equ  cmdb.struct + 22; Length of current row in CMDB
cmdb.lines        equ  cmdb.struct + 24; Total lines in CMDB
cmdb.dirty        equ  cmdb.struct + 26; Command buffer dirty (Text changed!)
cmdb.dialog       equ  cmdb.struct + 28; Dialog identifier
cmdb.dialog.var   equ  cmdb.struct + 30; Dialog private variable or pointer
cmdb.panhead      equ  cmdb.struct + 32; Pointer to string pane header
cmdb.paninfo      equ  cmdb.struct + 34; Pointer to string pane info (1st line)
cmdb.panhint      equ  cmdb.struct + 36; Pointer to string pane hint (2nd line)
cmdb.panhint2     equ  cmdb.struct + 38; Pointer to string pane hint (extra)
cmdb.panmarkers   equ  cmdb.struct + 40; Pointer to key marker list  (3rd line)
cmdb.pankeys      equ  cmdb.struct + 42; Pointer to string pane keys (stat line)
cmdb.action.ptr   equ  cmdb.struct + 44; Pointer to function to execute
cmdb.cmdall       equ  cmdb.struct + 46; Current command including length-byte
cmdb.cmdlen       equ  cmdb.struct + 46; Length of current command (MSB byte!)
cmdb.cmd          equ  cmdb.struct + 47; Current command (80 bytes max.)
cmdb.panhead.buf  equ  cmdb.struct +128; String buffer for pane header
cmdb.dflt.fname   equ  cmdb.struct +178; Default for filename
cmdb.free         equ  cmdb.struct +256; End of structure
*--------------------------------------------------------------
* Stevie value stack                  @>a800-a8ff   (256 bytes)
*--------------------------------------------------------------
sp2.stktop        equ  >a900           ; \
                                       ; | The stack grows from high memory
                                       ; | towards low memory.
                                       ; |
                                       ; | Stack leaking is checked in SP2
                                       ; | user hook "edkey.keyscan.hook"
                                       ; /
*--------------------------------------------------------------
* Scratchpad memory work copy         @>ad00-aeff   (256 bytes)
*--------------------------------------------------------------
cpu.scrpad.src    equ  >7e00           ; \ Dump of OS monitor scratchpad
                                       ; / stored in cartridge ROM bank7.asm

cpu.scrpad.tgt    equ  >f000           ; \ Fixed memory location used for
                                       ; | scratchpad backup/restore routines.
                                       ; /

cpu.scrpad1       equ  >8300           ; Stevie primary scratchpad

cpu.scrpad2       equ  >ad00           ; Stevie secondary scratchpad, used when
                                       ; calling TI Basic/External programs
*--------------------------------------------------------------
* Farjump return stack                @>af00-afff   (256 bytes)
*--------------------------------------------------------------
fj.bottom         equ  >b000           ; Return stack for trampoline function
                                       ; Grows downwards from high to low.
*--------------------------------------------------------------
* Index                               @>b000-bfff  (4096 bytes)
*--------------------------------------------------------------
idx.top           equ  >b000           ; Top of index
idx.size          equ  4096            ; Index size
*--------------------------------------------------------------
* Editor buffer                       @>c000-cfff  (4096 bytes)
*--------------------------------------------------------------
edb.top           equ  >c000           ; Editor buffer high memory
edb.size          equ  4096            ; Editor buffer size
*--------------------------------------------------------------
* Frame buffer & uncrunch area        @>d000-dcff  (3584 bytes)
*--------------------------------------------------------------
fb.top            equ  >d000           ; Frame buffer (2400 char)
fb.size           equ  80*48           ; Frame buffer size
fb.uncrunch.area  equ  >d960           ; \ Uncrunched TI Basic statement
                                       ; / >d960->dcff
*--------------------------------------------------------------
* Defaults area                       @>de00-dfff  (3584 bytes)
*--------------------------------------------------------------
tv.printer.fname  equ  >de00           ; Default printer   (80 char)
tv.clip.fname     equ  >de50           ; Default clipboard (80 char)
*--------------------------------------------------------------
* Command buffer history              @>e000-efff  (4096 bytes)
*--------------------------------------------------------------
cmdb.top          equ  >e000           ; Top of command history buffer
cmdb.size         equ  4096            ; Command buffer size
*--------------------------------------------------------------
* Heap                                @>f000-ffff  (4096 bytes)
*--------------------------------------------------------------
heap.top          equ  >f000           ; Top of heap


*--------------------------------------------------------------
* Stevie specific equates
*--------------------------------------------------------------
fh.fopmode.none           equ  0       ; No file operation in progress
fh.fopmode.readfile       equ  1       ; Read file from disk to memory
fh.fopmode.writefile      equ  2       ; Save file from memory to disk
cmdb.rows                 equ  5       ; Number of rows in CMDB pane
rom0_kscan_out            equ  keycode1; Where to store value of key pressed

tv.colorize.reset         equ  >9900   ; Colorization off
tv.1timeonly              equ  254     ; One-time only flag indicator

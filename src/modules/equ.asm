* FILE......: equ.asm
* Purpose...: The main equates file for Stevie editor


*===============================================================================
* Memory map
* ==========
*
* CARTRIDGE SPACE (6000-7fff)
*
*     Mem range   Bytes    BANK   Purpose
*     =========   =====    ====   ==================================
*     6000-603f      64       0   Cartridge header
*     6040-7fff    8128       0   SP2 library + Stevie library
*                                 relocated to RAM space
*     ..............................................................
*     6000-603f      64     1-7   Cartridge header
*     6040-7fef    7744     1-7   Stevie program code
*     7f00-7fff     384     1-7   Vector table (32 vectors)
*===============================================================================

;-------------------------------------------------------------------------------
; Stevie specific equates
;-------------------------------------------------------------------------------
fh.fopmode.none           equ  0        ; No file operation in progress
fh.fopmode.readfile       equ  1        ; Read file from disk to memory
fh.fopmode.writefile      equ  2        ; Save file from memory to disk
fh.ea5.vdpbuf             equ  >0000    ; VRAM address for storing EA5 chunk
cmdb.rows                 equ  6        ; Number of rows in CMDB pane
tv.colorize.reset         equ  >9900    ; Colorization off
tv.1timeonly              equ  254      ; One-time only flag indicator
tv.sams.maxpage           equ  256      ; Max SAMS pages supported
;-------------------------------------------------------------------------------
; Stevie Dialog / Pane specific equates
;-------------------------------------------------------------------------------
pane.focus.fb             equ  0       ; Editor pane has focus
pane.focus.cmdb           equ  1       ; Command buffer pane has focus
tv.colorscheme.entries    equ 12       ; Entries in colorscheme table
;-------------------------------------------------------------------------------
;   Dialog ID's
;-------------------------------------------------------------------------------
id.dialog.open            equ  10      ; "Open file"
id.dialog.insert          equ  11      ; "Insert file"
id.dialog.append          equ  12      ; "Append file"
id.dialog.delete          equ  13      ; "Delete file"
id.dialog.opt.clip        equ  20      ; "Configure clipboard"
id.dialog.cat             equ  25      ; "Catalog"
id.dialog.run             equ  30      ; "Run program file"
;-------------------------------------------------------------------------------
;   Dialog ID's > 30 means file catalog is unsupported
;-------------------------------------------------------------------------------
id.dialog.save            equ  40      ; "Save file"
id.dialog.saveblock       equ  41      ; "Save block to file"
id.dialog.print           equ  50      ; "Print file"
id.dialog.printblock      equ  60      ; "Print block"
id.dialog.goto            equ  70      ; "Goto"
id.dialog.find            equ  80      ; "Find"
id.dialog.cart.fg99       equ  90      ; "FinalGROM 99 Cartridge"
;-------------------------------------------------------------------------------
;   Dialog ID's >= 100 indicate that command prompt should be
;   hidden and no characters added to CMDB keyboard buffer.
;-------------------------------------------------------------------------------
id.dialog.menu            equ  100     ; "Main Menu"
id.dialog.unsaved         equ  101     ; "Unsaved changes"
id.dialog.block           equ  102     ; "Block move/copy/delete/print/..."
id.dialog.clipboard       equ  103     ; "Copy clipboard to line ..."
id.dialog.help            equ  104     ; "About"
id.dialog.file            equ  105     ; "File"
id.dialog.cart.type       equ  106     ; "Cartridge Type"
id.dialog.basic           equ  107     ; "TI Basic"
id.dialog.opt             equ  108     ; "Configure"
id.dialog.editor          equ  109     ; "Configure editor"
id.dialog.font            equ  110     ; "Configure font"
id.dialog.shortcuts       equ  111     ; "Shortcuts"
id.dialog.find.browse     equ  120     ; "Find - Search results"
;-------------------------------------------------------------------------------
; Suffix characters for clipboards
;-------------------------------------------------------------------------------
clip1                     equ  >3100   ; '1'
clip2                     equ  >3200   ; '2'
clip3                     equ  >3300   ; '3'
clip4                     equ  >3400   ; '4'
clip5                     equ  >3500   ; '5'
;-------------------------------------------------------------------------------
; Keyboard flags in Stevie
;-------------------------------------------------------------------------------
kbf.kbclear               equ  >0001   ;  Keyboard buffer cleared / @w$0001
;-------------------------------------------------------------------------------
; File work mode
;-------------------------------------------------------------------------------
id.file.loadfile          equ  1       ; Load file
id.file.insertfile        equ  2       ; Insert file
id.file.appendfile        equ  3       ; Append file
id.file.savefile          equ  4       ; Save file
id.file.saveblock         equ  5       ; Save block to file
id.file.clipblock         equ  6       ; Save block to clipboard
id.file.printfile         equ  7       ; Print file
id.file.printblock        equ  8       ; Print block
id.file.interrupt         equ  >ffff   ; File operation interrupted
;-------------------------------------------------------------------------------
; Special file indicator
;-------------------------------------------------------------------------------
id.special.normal         equ  0       ; Normal file
id.special.readonly       equ  2       ; Read-only file
id.special.basic          equ  3       ; TI Basic program
;-------------------------------------------------------------------------------
; Stevie core 1 RAM                    @>a000-a0ff                   (256 bytes)
;-------------------------------------------------------------------------------
core1.top         equ  >a000           ; Structure begin
free1             equ  core1.top + 0   ; **free**
free2             equ  core1.top + 2   ; **free**
free3             equ  core1.top + 4   ; **free**
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
core1.free1       equ  core1.top + 54  ; 54-99 **free**
timers            equ  core1.top + 100 ; Timers (80 bytes)
rom0_kscan_out    equ  keycode1        ; Where to store value of key pressed
;------------------------------------------------------------------------------
; TI Basic session management         
;------------------------------------------------------------------------------
tib.session       equ  core1.top + 180 ; Current TI-Basic session (1-5)
tib.status1       equ  core1.top + 182 ; Status flags TI Basic session 1
tib.status2       equ  core1.top + 184 ; Status flags TI Basic session 2
tib.status3       equ  core1.top + 186 ; Status flags TI Basic session 3
tib.free1         equ  core1.top + 188 ; **free**
tib.free2         equ  core1.top + 190 ; **free**
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
tib.free3         equ  core1.top + 212 ; **free* up to 233
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
;-------------------------------------------------------------------------------
; Stevie core 2 RAM                    @>a100-a1ff                   (256 bytes)
;-------------------------------------------------------------------------------
core2.top         equ  >a100           ; Structure begin
rambuf            equ  core2.top       ; RAM workbuffer
core2.free        equ  core2.top + 256 ; End of structure
;-------------------------------------------------------------------------------
; Stevie Editor shared structures      @>a200-a2ff                   (256 bytes)
;-------------------------------------------------------------------------------
tv.struct         equ  >a200           ; Structure begin
tv.sams.3000      equ  tv.struct + 2   ; SAMS page in window >3000-3fff
tv.sams.2000      equ  tv.struct + 0   ; SAMS page in window >2000-2fff
tv.sams.a000      equ  tv.struct + 4   ; SAMS page in window >a000-afff
tv.sams.b000      equ  tv.struct + 6   ; SAMS page in window >b000-bfff
tv.sams.c000      equ  tv.struct + 8   ; SAMS page in window >c000-cfff
tv.sams.d000      equ  tv.struct + 10  ; SAMS page in window >d000-dfff
tv.sams.e000      equ  tv.struct + 12  ; SAMS page in window >e000-efff
tv.sams.f000      equ  tv.struct + 14  ; SAMS page in window >f000-ffff
tv.ruler.visible  equ  tv.struct + 16  ; Show ruler with tab positions
tv.colorscheme    equ  tv.struct + 18  ; Current color scheme (0-xx)
tv.curshape       equ  tv.struct + 20  ; Cursor shape and color (sprite)
tv.curcolor       equ  tv.struct + 22  ; Cursor color1 + color2 (color scheme)
tv.color          equ  tv.struct + 24  ; FG/BG-color framebuffer
tv.topcolor       equ  tv.struct + 26  ; FG/BG-color top status line
tv.botcolor       equ  tv.struct + 28  ; FG/BG-color bottom status line
tv.markcolor      equ  tv.struct + 30  ; FG/BG-color marked lines in framebuffer
tv.busycolor      equ  tv.struct + 32  ; FG/BG-color bottom line when busy
tv.rulercolor     equ  tv.struct + 34  ; FG/BG-color ruler line
tv.cmdb.color     equ  tv.struct + 36  ; FG/BG-color cmdb lines
tv.cmdb.hcolor    equ  tv.struct + 38  ; FG/BG-color cmdb header line
tv.font.ptr       equ  tv.struct + 40  ; Pointer to font (in ROM bank 6 or RAM)
tv.pane.focus     equ  tv.struct + 42  ; Identify pane that has focus
tv.task.oneshot   equ  tv.struct + 44  ; Pointer to one-shot routine
tv.fj.stackpnt    equ  tv.struct + 46  ; Pointer to farjump return stack
tv.error.visible  equ  tv.struct + 48  ; Error pane visible
tv.error.rows     equ  tv.struct + 50  ; Number of rows in error pane
tv.sp2.conf       equ  tv.struct + 52  ; Backup of SP2 config register
tv.sp2.stack      equ  tv.struct + 54  ; Backup of SP2 stack register
tv.fg99.img.ptr   equ  tv.struct + 56  ; Pointer to Final GROM cartridge to load
tv.specmsg.ptr    equ  tv.struct + 58  ; Pointer to special message above botrow
tv.lineterm       equ  tv.struct + 60  ; Default line termination character(s)
tv.show.linelen   equ  tv.struct + 62  ; Show line length in status line
tv.error.msg      equ  tv.struct + 64  ; Error message (max 80 bytes)
tv.devpath        equ  tv.struct + 144 ; Device path (max 80 bytes)
tv.free           equ  tv.struct + 224 ; End of structure
;-------------------------------------------------------------------------------
; Frame buffer structure               @>a300-a3ff                   (256 bytes)
;-------------------------------------------------------------------------------
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
fb.curtoggle      equ  fb.struct + 20  ; Cursor shape toggle (00=on <>00=off)
fb.prevcursor     equ  fb.struct + 22  ; Previous cursor position
fb.yxsave         equ  fb.struct + 24  ; Copy of cursor YX for toggling fb/cmdb
fb.dirty          equ  fb.struct + 26  ; Frame buffer dirty flag
fb.status.dirty   equ  fb.struct + 28  ; Status line(s) dirty flag
fb.scrrows        equ  fb.struct + 30  ; Rows on physical screen for framebuffer
fb.scrrows.max    equ  fb.struct + 32  ; Max # of rows on physical screen for fb
fb.ruler.sit      equ  fb.struct + 34  ; 80 char ruler  (no length-prefix!)
fb.ruler.tat      equ  fb.struct + 114 ; 80 char colors (no length-prefix!)
fb.free           equ  fb.struct + 194 ; End of structure
;-------------------------------------------------------------------------------
; File handle structure                @>a400-a4ff                   (256 bytes)
;-------------------------------------------------------------------------------
fh.struct         equ  >a400           ; stevie file handling structures
;*******************************************************************************
; ATTENTION: dsrlnk vars must form a continuous memory block & keep their order!
;*******************************************************************************
dsrlnk.dsrlws     equ  fh.struct       ; dsrlnk workspace 32 bytes
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
fh.records        equ  fh.struct + 60  ; \ File records counter
fh.segments       equ  fh.struct + 60  ; / Program image segments counter
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
fh.temp3          equ  fh.struct + 100 ; Temporary variable 3
fh.pabtpl.ptr     equ  fh.struct + 102 ; Pointer to PAB template in ROM/RAM
fh.dir.rec.ptr    equ  fh.struct + 104 ; Pointer to directory record
fh.circbreaker    equ  fh.struct + 106 ; Circuit breaker. Halt file operation
fh.ea5.nextflag   equ  fh.struct + 108 ; Next EA5 image chunk needed
fh.ea5.vdpsrc     equ  fh.struct + 110 ; VDP source address of EA5 image chunk
fh.ea5.ramtgt     equ  fh.struct + 112 ; RAM target address for EA5 image chunk
fh.ea5.size       equ  fh.struct + 114 ; Size of EA5 image chunk
fh.ea5.startaddr  equ  fh.struct + 116 ; EA5 program start address
fh.membuffer      equ  fh.struct + 118 ; 80 bytes file memory buffer
fh.free           equ  fh.struct + 198 ; **free** up to 256
;-------------------------------------------------------------------------------
; File handle structure for generic    @>a400-a4ff                   (256 bytes)
; Overloads file handle structure!
;-------------------------------------------------------------------------------
fh.ftype.init     equ  fh.struct + 90  ; File type/mode (becomes fh.filetype)
fh.ram.ptr        equ  fh.struct + 92  ; RAM destination address
;-------------------------------------------------------------------------------
; Editor buffer structure              @>a500-a5ff                   (256 bytes)
;-------------------------------------------------------------------------------
edb.struct        equ  >a500            ; Begin structure
edb.top.ptr       equ  edb.struct       ; Pointer to editor buffer
edb.index.ptr     equ  edb.struct + 2   ; Pointer to index
edb.lines         equ  edb.struct + 4   ; Total lines in editor buffer - 1
edb.dirty         equ  edb.struct + 6   ; Editor buffer dirty (Text changed!)
edb.next_free.ptr equ  edb.struct + 8   ; Pointer to next free line
edb.insmode       equ  edb.struct + 10  ; Insert mode (>ffff=insert)
edb.autoinsert    equ  edb.struct + 12  ; Auto-insert on ENTER flag (>ffff=on)
edb.block.m1      equ  edb.struct + 14  ; Block start line marker (>ffff=unset)
edb.block.m2      equ  edb.struct + 16  ; Block end line marker (>ffff=unset)
edb.block.var     equ  edb.struct + 18  ; Local var used in block operation
edb.filename.ptr  equ  edb.struct + 20  ; Pointer to length-prefixed string
                                        ; with current filename.
edb.filetype.ptr  equ  edb.struct + 22  ; Pointer to length-prefixed string
                                        ; with current file type.
edb.sams.page     equ  edb.struct + 24  ; Current SAMS page
edb.sams.lopage   equ  edb.struct + 26  ; Lowest SAMS page in use
edb.sams.hipage   equ  edb.struct + 28  ; Highest SAMS page in use
edb.bk.fb.topline equ  edb.struct + 30  ; Backup of @fb.topline before opening
                                        ; other file from special file.
edb.bk.fb.row     equ  edb.struct + 32  ; Backup of @fb.row before opening
                                        ; other file from special file.
edb.special.file  equ  edb.struct + 34  ; Special file in editor buffer
edb.lineterm      equ  edb.struct + 36  ; Line termination character
                                        ; MSB: Mode on (>ff) or off (>00)
                                        ; LSB: Line termination character                                    
edb.filename      equ  edb.struct + 38  ; 80 characters inline buffer reserved
                                        ; for filename, but not always used.
edb.srch.str      equ  edb.struct + 118 ; 80 characters search string buffer
edb.srch.strlen   equ  edb.struct + 198 ; Length of search string
edb.srch.startln  equ  edb.struct + 200 ; Start line in editor buffer for search
edb.srch.endln    equ  edb.struct + 202 ; End line in editor buffer for search
edb.srch.worklen  equ  edb.struct + 204 ; Length of unpacked line in work buffer
edb.srch.matches  equ  edb.struct + 206 ; Number of search matches
edb.srch.curmatch equ  edb.struct + 208 ; Current index entry in search matches
edb.srch.row.ptr  equ  edb.struct + 210 ; Pointer entry in rows search index
edb.srch.col.ptr  equ  edb.struct + 212 ; Pointer entry in cols search index
edb.srch.offset   equ  edb.struct + 214 ; Offset into current row index entry
edb.srch.matchcol equ  edb.struct + 216 ; Column of search match in current row
edb.locked        equ  edb.struct + 218 ; Editor locked flag (>ffff=locked)
edb.free          equ  edb.struct + 220 ; End of structure
;-------------------------------------------------------------------------------
; Index structure                      @>a600-a6ff                   (256 bytes)
;-------------------------------------------------------------------------------
idx.struct        equ  >a600           ; stevie index structure
idx.sams.page     equ  idx.struct      ; Current SAMS page
idx.sams.lopage   equ  idx.struct + 2  ; Lowest SAMS page
idx.sams.hipage   equ  idx.struct + 4  ; Highest SAMS page
idx.free          equ  idx.struct + 6  ; End of structure
;-------------------------------------------------------------------------------
; Command buffer structure             @>a700-a7ff                   (256 bytes)
;-------------------------------------------------------------------------------
cmdb.struct       equ  >a700             ; Command Buffer structure
cmdb.top.ptr      equ  cmdb.struct       ; Pointer to command buffer (history)
cmdb.visible      equ  cmdb.struct + 2   ; Command buffer visible? (>ffff=yes)
cmdb.fb.yxsave    equ  cmdb.struct + 4   ; Copy of FB WYX if entering cmdb pane
cmdb.scrrows      equ  cmdb.struct + 6   ; Current size of CMDB pane (in rows)
cmdb.default      equ  cmdb.struct + 8   ; Default size of CMDB pane (in rows)
cmdb.cursor       equ  cmdb.struct + 10  ; Screen YX of cursor in CMDB pane
cmdb.yxsave       equ  cmdb.struct + 12  ; Copy of WYX
cmdb.free1        equ  cmdb.struct + 14  ; **free**
cmdb.prevcursor   equ  cmdb.struct + 16  ; Previous cursor position
cmdb.vdptop       equ  cmdb.struct + 18  ; VDP addr CMDB pane header line (TAT)
cmdb.yxtop        equ  cmdb.struct + 20  ; YX pos CMDB pane header line
cmdb.yxprompt     equ  cmdb.struct + 22  ; YX pos of command buffer prompt
cmdb.column       equ  cmdb.struct + 24  ; Current column in command buffer pane
cmdb.length       equ  cmdb.struct + 26  ; Length of current row in CMDB
cmdb.lines        equ  cmdb.struct + 28  ; Total lines in CMDB
cmdb.dirty        equ  cmdb.struct + 30  ; Command buffer dirty (Text changed!)
cmdb.dialog       equ  cmdb.struct + 32  ; Dialog identifier
cmdb.dialog.var   equ  cmdb.struct + 34  ; Dialog private variable or pointer
cmdb.panhead      equ  cmdb.struct + 36  ; Pointer string pane header
cmdb.paninfo      equ  cmdb.struct + 38  ; Pointer string pane info (1st line)
cmdb.panhint      equ  cmdb.struct + 40  ; Pointer string pane hint (2nd line)
cmdb.panhint2     equ  cmdb.struct + 42  ; Pointer string pane hint (extra)
cmdb.panmarkers   equ  cmdb.struct + 44  ; Pointer key marker list  (3rd line)
cmdb.pankeys      equ  cmdb.struct + 46  ; Pointer string pane keys (stat line)
cmdb.action.ptr   equ  cmdb.struct + 48  ; Pointer function to execute
cmdb.cmdall       equ  cmdb.struct + 50  ; Current command including length-byte
cmdb.cmdlen       equ  cmdb.struct + 50  ; Length of current command (MSB byte!)
cmdb.cmd          equ  cmdb.struct + 51  ; Current command (80 bytes max.)
cmdb.panhead.buf  equ  cmdb.struct + 132 ; String buffer for pane header
cmdb.dflt.fname   equ  cmdb.struct + 182 ; Default for filename
cmdb.free         equ  cmdb.struct + 256 ; End of structure
;-------------------------------------------------------------------------------
; Stevie value stack                   @>a800-a8ff                   (256 bytes)
;-------------------------------------------------------------------------------
sp2.stktop        equ  >a900           ; \
                                       ; | The stack grows from high memory
                                       ; | towards low memory.
                                       ; |
                                       ; | Stack leaking is checked in SP2
                                       ; | user hook "edkey.keyscan.hook"
                                       ; /
;-------------------------------------------------------------------------------
; FREE                                 @>a900-adff                  (1280 bytes)
;------------------------------------------------------------------------------- 
free.a900         equ  >a900           ; **free** 256
free.aa00         equ  >aa00           ; **free** 256
free.ab00         equ  >ab00           ; **free** 256
free.ac00         equ  >ac00           ; **free** 256
free.ad00         equ  >ad00           ; **free** 256
;-------------------------------------------------------------------------------
; Scratchpad memory work copy          @>ae00-aeff                   (256 bytes)
;-------------------------------------------------------------------------------
cpu.scrpad2       equ  >ae00           ; Stevie secondary scratchpad, used when
                                       ; calling TI Basic/External programs

cpu.scrpad1       equ  >8300           ; Stevie primary scratchpad

cpu.scrpad.src    equ  >7e00           ; \ Dump of OS monitor scratchpad
                                       ; / stored in cartridge ROM bank7.asm

cpu.scrpad.tgt    equ  >f000           ; \ Fixed memory location used for
                                       ; | scratchpad backup/restore routines.
                                       ; /                                   
;-------------------------------------------------------------------------------
; Farjump return stack                 @>af00-afff                   (256 bytes)
;-------------------------------------------------------------------------------
fj.bottom         equ  >b000           ; Return stack for trampoline function
                                       ; Grows downwards from high to low.
;-------------------------------------------------------------------------------
; Index                                @>b000-bfff                  (4096 bytes)
;-------------------------------------------------------------------------------
idx.top           equ  >b000           ; Top of index
idx.size          equ  4096            ; Index size
;-------------------------------------------------------------------------------
; Editor buffer                        @>c000-cfff                  (4096 bytes)
;-------------------------------------------------------------------------------
edb.top           equ  >c000           ; Editor buffer high memory
edb.size          equ  4096            ; Editor buffer size
;-------------------------------------------------------------------------------
; Frame buffer & uncrunch area         @>d000-e21f                  (4640 bytes)
;-------------------------------------------------------------------------------
fb.top            equ  >d000           ; Frame buffer (4640)
fb.size           equ  80*60           ; Frame buffer size
fb.uncrunch.area  equ  >d960           ; \ Uncrunched TI Basic statement
                                       ; / >d960->dcff
;-------------------------------------------------------------------------------
; Directory/File catalog               @>e220-f094                  (3700 bytes)
;-------------------------------------------------------------------------------
cat.top           equ  >e220           ; Top of file catalog
cat.filecount     equ  cat.top         ; Total files in catalog
cat.fpicker.idx   equ  cat.top + 2     ; Index in catalog (1st entry on page)
cat.hilit.colrow  equ  cat.top + 4     ; File picker column, row offset
cat.hilit.colrow2 equ  cat.top + 6     ; File picker previous column, row offset
cat.nofilespage   equ  cat.top + 8     ; Number of files per page
cat.nofilescol    equ  cat.top + 10    ; Number of files per column
cat.currentpage   equ  cat.top + 12    ; Current page
cat.totalpages    equ  cat.top + 14    ; Total number of pages
cat.previouspage  equ  cat.top + 16    ; Previous page
cat.shortcut.idx  equ  cat.top + 18    ; Index in catalog(current entry on page)
cat.norowscol     equ  cat.top + 20    ; Number of rows per column
cat.fullfname     equ  cat.top + 22    ; Device & filename string (80)
;-------------------------------------------------------------------------------
; Directory/File catalog pointers and numbers
;-------------------------------------------------------------------------------
cat.var1          equ  cat.top + 102   ; Temp variable 1
cat.var2          equ  cat.top + 104   ; Temp variable 2
cat.var3          equ  cat.top + 106   ; Temp variable 3
cat.var4          equ  cat.top + 108   ; Temp variable 4
cat.var5          equ  cat.top + 110   ; Temp variable 5
cat.var6          equ  cat.top + 112   ; Temp variable 6
cat.var7          equ  cat.top + 114   ; Temp variable 7
cat.var8          equ  cat.top + 116   ; Temp variable 8
cat.ptrlist       equ  cat.top + 118   ; Pointer list to filenames (254=127*2)
cat.ftlist        equ  cat.top + 372   ; Filetype list (128)
cat.fslist        equ  cat.top + 500   ; Filesize size (256)
cat.rslist        equ  cat.top + 756   ; Record size list (128)
cat.barpos        equ  cat.top + 884   ; Color bar YX position (backup)
cat.barcol        equ  cat.top + 886   ; Color bar column 0-2
cat.volsize       equ  cat.top + 888   ; Volume size
cat.volused       equ  cat.top + 890   ; Volume used
cat.volfree       equ  cat.top + 892   ; Volume free
;-------------------------------------------------------------------------------
; Directory/File catalog strings (always length byte included)
;-------------------------------------------------------------------------------
cat.volname       equ  cat.top + 894   ; Volume name (12)
cat.typelist      equ  cat.top + 906   ; Filetype string list (762=127*6)
cat.sizelist      equ  cat.top + 1668  ; Filesize string list (508=127*4)
cat.fnlist        equ  cat.top + 2176  ; Filename string list (1524=127*12) 
cat.size          equ  3700            ; Catalog total size
;-------------------------------------------------------------------------------
; Search results index for rows        @>f100-f4ff                  (1024 bytes)
;-------------------------------------------------------------------------------
edb.srch.idx.rtop   equ  >f100         ; Search match index for rows
edb.srch.idx.rsize  equ  1024          ; Size of search match index for rows
;-------------------------------------------------------------------------------
; Search results index for columns     @>f500-f6ff                   (512 bytes)
;-------------------------------------------------------------------------------
edb.srch.idx.ctop   equ  >f500         ; Search match index for columns
edb.srch.idx.csize  equ  512           ; Size of search match index for columns
;-------------------------------------------------------------------------------
; Heap & Strings area                  @>f700-f8ff                   (512 bytes)
;-------------------------------------------------------------------------------
heap.top          equ  >f700           ; Current filename        (80)
ram.msg1          equ  heap.top + 80   ; txt.hint.memstat        (80)
ram.msg2          equ  heap.top + 160  ; txt.hint.lineterm       (80)
tv.printer.fname  equ  heap.top + 240  ; Default printer         (80)
tv.clip.fname     equ  heap.top + 320  ; Default clipboard       (80)
tv.cat.fname      equ  heap.top + 400  ; Default catalog device  (80)
heap.free         equ  heap.top + 480  ; **free** up to >f8ff
;-------------------------------------------------------------------------------
; Command buffer                       ; @>f900-f9ff                 (256 bytes)
;-------------------------------------------------------------------------------
cmdb.top          equ  >f900           ; Top of command history buffer
cmdb.size         equ  256             ; Command buffer size  
;-------------------------------------------------------------------------------
; FREE                                 ; @>fa00-ffff                (1536 bytes)
;-------------------------------------------------------------------------------
free.size         equ  1536            ; Free space size

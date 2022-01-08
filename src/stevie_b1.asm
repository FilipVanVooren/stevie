***************************************************************
*                          Stevie
*
*       A 21th century Programming Editor for the 1981
*         Texas Instruments TI-99/4a Home Computer.
*
*              (c)2018-2022 // Filip van Vooren
***************************************************************
* File: stevie_b1.asm               ; Version %%build_date%%
*
* Bank 1 "James"
* Editor core
***************************************************************
        copy  "rom.build.asm"       ; Cartridge build options        
        copy  "rom.order.asm"       ; ROM bank order "non-inverted"        
        copy  "equates.asm"         ; Equates Stevie configuration
        copy  "data.keymap.keys.asm"; Equates for keyboard mapping        

***************************************************************
* BANK 1
********|*****|*********************|**************************
bankid  equ   bank1.rom             ; Set bank identifier to current bank
        aorg  >6000
        save  >6000,>8000           ; Save bank
        copy  "rom.header.asm"      ; Include cartridge header

***************************************************************
* Step 1: Switch to bank 0 (uniform code accross all banks)
********|*****|*********************|**************************
        aorg  kickstart.code1       ; >6040
        clr   @bank0.rom            ; Switch to bank 0 "Jill"
***************************************************************
* Step 2: Satisfy assembler, must know relocated code
********|*****|*********************|**************************
        aorg  >2000                 ; Relocate to >2000
        copy  "runlib.asm"
        copy  "ram.resident.asm"        
        ;------------------------------------------------------
        ; Activate bank 1 and branch to  >6036
        ;------------------------------------------------------
        clr   @bank1.rom            ; Activate bank 1 "James" ROM

        .ifeq device.fg99.mode.adv,1
        clr   @bank1.ram            ; Activate bank 1 "James" RAM
        .endif

        b     @kickstart.code2      ; Jump to entry routine
***************************************************************
* Step 3: Include main editor modules
********|*****|*********************|**************************
main:   
        aorg  kickstart.code2       ; >6046
        b     @main.stevie          ; Start editor 
        ;-----------------------------------------------------------------------
        ; Include files
        ;-----------------------------------------------------------------------
        copy  "main.asm"                    ; Main file (entrypoint)
        ;-----------------------------------------------------------------------
        ; Low-level modules
        ;-----------------------------------------------------------------------
        copy  "mem.sams.setup.asm"          ; SAMS memory setup for Stevie
        ;-----------------------------------------------------------------------
        ; Keyboard actions
        ;-----------------------------------------------------------------------
        copy  "edkey.key.hook.asm"          ; SP2 user hook: keyboard scanning
        copy  "edkey.key.process.asm"       ; Process keyboard actions
        ;-----------------------------------------------------------------------
        ; Keyboard actions - Framebuffer (1)             
        ;-----------------------------------------------------------------------
        copy  "edkey.fb.mov.leftright.asm"  ; Move left / right / home / end
        copy  "edkey.fb.mov.word.asm"       ; Move previous / next word
        copy  "edkey.fb.mov.updown.asm"     ; Move line up / down        
        copy  "edkey.fb.mov.paging.asm"     ; Move page up / down
        copy  "edkey.fb.mov.topbot.asm"     ; Move file top / bottom
        copy  "edkey.fb.mov.goto.asm"       ; Goto line in editor buffer
        copy  "edkey.fb.del.asm"            ; Delete characters or lines
        copy  "edkey.fb.ins.asm"            ; Insert characters or lines
        copy  "edkey.fb.mod.asm"            ; Actions for modifier keys                
        copy  "edkey.fb.ruler.asm"          ; Toggle ruler on/off
        copy  "edkey.fb.misc.asm"           ; Miscelanneous actions        
        copy  "edkey.fb.file.asm"           ; File related actions
        copy  "edkey.fb.block.asm"          ; Actions block move/copy/delete...
        copy  "edkey.fb.tabs.asm"           ; tab-key related actions
        copy  "edkey.fb.clip.asm"           ; Clipboard actions
        ;-----------------------------------------------------------------------
        ; Keyboard actions - Command Buffer    
        ;-----------------------------------------------------------------------
        copy  "edkey.cmdb.mov.asm"          ; Actions for movement keys 
        copy  "edkey.cmdb.mod.asm"          ; Actions for modifier keys
        copy  "edkey.cmdb.misc.asm"         ; Miscelanneous actions
        copy  "edkey.cmdb.file.new.asm"     ; New file
        copy  "edkey.cmdb.file.load.asm"    ; Open file
        copy  "edkey.cmdb.file.insert.asm"  ; Insert file
        copy  "edkey.cmdb.file.append.asm"  ; Append file        
        copy  "edkey.cmdb.file.clip.asm"    ; Copy clipboard to line
        copy  "edkey.cmdb.file.clipdev.asm" ; Configure clipboard device
        copy  "edkey.cmdb.file.save.asm"    ; Save file
        copy  "edkey.cmdb.file.print.asm"   ; Print file        
        copy  "edkey.cmdb.dialog.asm"       ; Dialog specific actions
        ;-----------------------------------------------------------------------
        ; Logic for Framebuffer (1)
        ;-----------------------------------------------------------------------        
        copy  "fb.utils.asm"                ; Framebuffer utilities
        copy  "fb.cursor.up.asm"            ; Cursor up
        copy  "fb.cursor.down.asm"          ; Cursor down
        copy  "fb.cursor.home.asm"          ; Cursor home
        copy  "fb.insert.line.asm"          ; Insert new line
        copy  "fb.get.firstnonblank.asm"    ; Get column of first non-blank char
        copy  "fb.refresh.asm"              ; Refresh framebuffer
        copy  "fb.restore.asm"              ; Restore framebuffer to normal opr.
        ;-----------------------------------------------------------------------
        ; Logic for Editor Buffer
        ;-----------------------------------------------------------------------
        copy  "edb.line.pack.fb.asm"        ; Pack line into editor buffer
        copy  "edb.line.unpack.fb.asm"      ; Unpack line from editor buffer
        ;-----------------------------------------------------------------------
        ; Background tasks
        ;-----------------------------------------------------------------------
    .ifeq device.f18a,1
        copy  "task.vdp.cursor.sat.asm"     ; Copy cursor SAT to VDP
        copy  "task.vdp.cursor.sprite.asm"  ; Set cursor shape in VDP (blink)
    .else 
        copy  "task.vdp.cursor.char.asm"    ; Set cursor shape in VDP (blink)    
    .endif

        copy  "task.vdp.panes.asm"          ; Draw editor panes in VDP
        copy  "task.oneshot.asm"            ; Run "one shot" task
        ;-----------------------------------------------------------------------
        ; Screen pane utilities
        ;-----------------------------------------------------------------------
        copy  "pane.utils.colorscheme.asm"  ; Colorscheme handling in panes 
        copy  "pane.cursor.asm"             ; Cursor utility functions        
        ;-----------------------------------------------------------------------
        ; Screen panes
        ;-----------------------------------------------------------------------   
        copy  "colors.line.set.asm"         ; Set color combination for line
        copy  "pane.topline.asm"            ; Top line
        copy  "pane.errline.asm"            ; Error line
        copy  "pane.botline.asm"            ; Bottom line
        copy  "pane.vdpdump.asm"            ; Dump panes to VDP memory
        ;-----------------------------------------------------------------------
        ; Stubs
        ;-----------------------------------------------------------------------
        copy  "rom.stubs.bank1.asm"         ; Bank specific stubs
        copy  "rom.stubs.bankx.asm"         ; Stubs to include in all banks > 0
        ;-----------------------------------------------------------------------
        ; Program data
        ;----------------------------------------------------------------------- 
        copy  "data.keymap.actions.asm"     ; Keyboard actions
        ;-----------------------------------------------------------------------
        ; Bank full check
        ;----------------------------------------------------------------------- 
        .ifgt $, >7faf
              .error 'Aborted. Bank 1 cartridge program too large!'
        .endif
        ;-----------------------------------------------------------------------
        ; Show ROM bank in CPU crash screen
        ;-----------------------------------------------------------------------         
cpu.crash.showbank:
        aorg  >7fb0
        bl    @putat
              byte 3,20
              data cpu.crash.showbank.bankstr
        jmp   $
cpu.crash.showbank.bankstr:
        #string 'ROM#1'
        ;-----------------------------------------------------------------------
        ; Vector table
        ;----------------------------------------------------------------------- 
        aorg  bankx.vectab
        copy  "rom.vectors.bank1.asm"      
                                    ; Vector table bank 1
*--------------------------------------------------------------
* Video mode configuration
*--------------------------------------------------------------
spfclr  equ   >f4                   ; Foreground/Background color for font.
spfbck  equ   >04                   ; Screen background color.
spvmod  equ   stevie.80x30          ; Video mode.   See VIDTAB for details.
spfont  equ   fnopt3                ; Font to load. See LDFONT for details.
colrow  equ   80                    ; Columns per row
pctadr  equ   >0fc0                 ; VDP color table base
fntadr  equ   >1100                 ; VDP font start address (in PDT range)
sprsat  equ   >2180                 ; VDP sprite attribute table
sprpdt  equ   >2800                 ; VDP sprite pattern table
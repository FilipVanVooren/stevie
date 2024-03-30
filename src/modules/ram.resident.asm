* FILE......: ram.resident.asm
* Purpose...: Resident modules in LOW MEMEXP RAM callable from all ROM banks.

  ; Watch out! Avoid relying on calling code stored in the cartridge ROM area.
  ; It's easier to directly do farjmp call, and this is what we do.
  ; Especially for the spectra2 tasks.

        ;------------------------------------------------------
        ; Low-level modules
        ;------------------------------------------------------
        copy  "rom.farjump.asm"      ; ROM bankswitch trampoline
        copy  "fb.asm"               ; Framebuffer
        copy  "fb.row2line.asm"      ; Calculate line in editor buffer
        copy  "fb.calc.pointer.asm"  ; Calculate pointer address frame buffer
        copy  "fb.calc.scrrows.asm"  ; Calculate number of rows frame buffer
        copy  "idx.asm"              ; Index management
        copy  "edb.asm"              ; Editor Buffer
        copy  "cmdb.asm"             ; Command buffer
        copy  "errpane.asm"          ; Error pane
        copy  "tv.asm"               ; Main editor configuration
        copy  "tv.quit.asm"          ; Exit Stevie and return to monitor
        copy  "tv.uint16.pack.asm"   ; Pack string to 16bit unsigned integer
        copy  "tv.uint16.unpack.asm" ; Unpack 16bit unsigned integer to string
        copy  "tv.pad.string.asm"    ; Pad string to specified length
        ;-----------------------------------------------------------------------
        ; Logic for Index management
        ;-----------------------------------------------------------------------
        copy  "idx.update.asm"       ; Index management - Update entry
        copy  "idx.pointer.asm"      ; Index management - Get pointer to line
        copy  "idx.delete.asm"       ; Index management - delete slot
        copy  "idx.insert.asm"       ; Index management - insert slot
        ;-----------------------------------------------------------------------
        ; Logic for editor buffer
        ;-----------------------------------------------------------------------
        copy  "edb.line.mappage.asm"    ; Activate edbuf SAMS page for line
        copy  "edb.line.getlength.asm"  ; Get line length
        copy  "edb.line.getlength2.asm" ; Get length of current row
        copy  "edb.hipage.alloc.asm"    ; Check/increase highest SAMS page
        ;-----------------------------------------------------------------------
        ; Utility functions
        ;-----------------------------------------------------------------------
        copy  "pane.topline.clearmsg.asm" ; Remove overlay msg in top line
        copy  "fg99.run.asm"              ; Run FinalGROM cartridge image                                       
        ;-----------------------------------------------------------------------
        ; Background tasks
        ;-----------------------------------------------------------------------
        .ifeq spritecursor,1
        
        copy  "task.vdp.cursor.sat.asm"     ; Copy cursor SAT to VDP
        copy  "task.vdp.cursor.sprite.asm"  ; Set cursor shape in VDP (blink)

        .else

        copy  "task.vdp.cursor.char.asm"    ; Set cursor shape in VDP (blink)

        .endif
    
        copy  "task.oneshot.asm"            ; Run "one shot" task                                       
        ;------------------------------------------------------
        ; Program data
        ;------------------------------------------------------
        even
        copy  "data.constants.asm"          ; Constants
        copy  "data.strings.asm"            ; Strings
        copy  "data.defaults.asm"           ; Default values (devices, ...)
        copy  "data.fg99.carts.asm"         ; Cartridge images

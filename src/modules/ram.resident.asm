* FILE......: ram.resident.asm
* Purpose...: Resident modules in LOW MEMEXP callable from all ROM banks.

        ;------------------------------------------------------
        ; Low-level modules
        ;------------------------------------------------------
        copy  "rom.farjump.asm"        ; ROM bankswitch trampoline
        copy  "fb.asm"                 ; Framebuffer
        copy  "idx.asm"                ; Index management
        copy  "edb.asm"                ; Editor Buffer
        copy  "cmdb.asm"               ; Command buffer
        copy  "errpane.asm"            ; Error pane
        copy  "tv.asm"                 ; Main editor configuration
        copy  "tv.quit.asm"            ; Exit Stevie and return to monitor
        copy  "tv.reset.asm"           ; Reset editor (clear buffers)
        copy  "tv.unpack.uint16.asm"   ; Unpack 16bit unsigned integer to string
        copy  "tv.pad.string.asm"      ; Pad string to specified length
        ;-----------------------------------------------------------------------
        ; Logic for Index management
        ;-----------------------------------------------------------------------
        copy  "idx.update.asm"         ; Index management - Update entry
        copy  "idx.pointer.asm"        ; Index management - Get pointer to line
        copy  "idx.delete.asm"         ; Index management - delete slot
        copy  "idx.insert.asm"         ; Index management - insert slot
        ;-----------------------------------------------------------------------
        ; Logic for editor buffer
        ;-----------------------------------------------------------------------
        copy  "edb.line.mappage.asm"   ; Activate edbuf SAMS page for line
        copy  "edb.line.getlen.asm"    ; Get line length
        copy  "edb.hipage.alloc.asm"   ; Check/increase highest SAMS page
        ;-----------------------------------------------------------------------
        ; Utility functions
        ;-----------------------------------------------------------------------
        copy  "pane.topline.clearmsg.asm"
                                       ; Remove overlay messsage in top line
        ;------------------------------------------------------
        ; Program data
        ;------------------------------------------------------
        copy  "data.constants.asm"     ; Constants
        copy  "data.strings.asm"       ; Strings
        copy  "data.defaults.asm"      ; Default values (devices, ...)

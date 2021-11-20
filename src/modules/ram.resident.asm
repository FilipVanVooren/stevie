* FILE......: ram.resident.asm
* Purpose...: Resident modules in LOW MEMEXP callable from all ROM banks.
 
        ;------------------------------------------------------
        ; Resident Stevie modules
        ;------------------------------------------------------
        copy  "rom.farjump.asm"        ; ROM bankswitch trampoline 
        copy  "fb.asm"                 ; Framebuffer      
        copy  "idx.asm"                ; Index management           
        copy  "edb.asm"                ; Editor Buffer   
        copy  "cmdb.asm"               ; Command buffer            
        copy  "errline.asm"            ; Error line
        copy  "tv.asm"                 ; Main editor configuration        
        copy  "tv.utils.asm"           ; General purpose utility functions
        copy  "mem.asm"                ; Memory Management (SAMS)
        copy  "pane.topline.clearmsg.asm"
                                       ; Remove overlay messsage in top line
        ;------------------------------------------------------
        ; Program data
        ;------------------------------------------------------
        copy  "data.constants.asm"     ; Constants
        copy  "data.strings.asm"       ; Strings
        copy  "data.defaults.asm"      ; Default values (devices, ...)

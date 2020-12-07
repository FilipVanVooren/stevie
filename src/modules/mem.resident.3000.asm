* FILE......: mem.resident.3000.asm
* Purpose...: Resident Stevie modules. Needs to be include in all banks.
 
        ;------------------------------------------------------
        ; Resident Stevie modules >3000 - >3fff
        ;------------------------------------------------------
        copy  "rom.farjump.asm"     ; ROM bankswitch trampoline 
        copy  "fb.asm"              ; Framebuffer      
        copy  "idx.asm"             ; Index management           
        copy  "edb.asm"             ; Editor Buffer        
        copy  "cmdb.asm"            ; Command buffer            
        copy  "errline.asm"         ; Error line
        copy  "tv.asm"              ; Main editor configuration        
        copy  "tv.utils.asm"        ; General purpose utility functions
        copy  "data.constants.asm"  ; Data Constants
        copy  "data.strings.asm"    ; Data segment - Strings
        copy  "data.keymap.asm"     ; Data segment - Keyboard mapping    
        ;------------------------------------------------------
        ; End of File marker
        ;------------------------------------------------------        
        data  >dead,>beef,>dead,>beef
        .print "***** PC resident stevie modules @ >3000 - ", $, "(dec)"

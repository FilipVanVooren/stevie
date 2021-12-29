* FILE......: tv.quit.asm
* Purpose...: Quit Stevie and return to monitor

***************************************************************
* tv.quit
* Quit stevie and return to monitor
***************************************************************
* b    @tv.quit
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* none
***************************************************************
tv.quit:
        ;-------------------------------------------------------
        ; Reset/lock F18a
        ;-------------------------------------------------------
        bl    @f18rst               ; Reset and lock the F18A
        ;-------------------------------------------------------
        ; Load legacy SAMS page layout and exit to monitor
        ;-------------------------------------------------------        
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank7.rom        ; | i  p0 = bank address
              data bankx.vectab     ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return 

        ; We never return here. We call @mem.sams.set.legacy (vector1) and
        ; in there activate bank 0 in cartridge space and return to monitor.
        ;
        ; Reason for doing so is that @tv.quit is located in 
        ; low memory expansion. So switching SAMS banks or turning off the SAMS
        ; mapper results in invalid OPCODE's because the program just isn't
        ; there in low memory expansion anymore.
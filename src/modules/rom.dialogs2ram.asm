* FILE......: rom.dialogs2ram.asm
* Purpose...: Copy dialogs data from cartridge rom to ram

***************************************************************
* rom.dialog2ram
* Copy dialogs data from cartridge rom to ram
***************************************************************
* bl @rom.dialog2ram
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
*--------------------------------------------------------------
* Notes
* Dialog data resides in SAMS Bank #2 (>b000) and #3 (>c000)
********|*****|*********************|**************************
rom.dialogs2ram:
        .pushregs 2                 ; Push return address and registers on stack
        ;-------------------------------------------------------
        ; Set SAMS pages that has dialogs data
        ;-------------------------------------------------------        
        bl    @mem.sams.dialogs.on  ; Turn on SAMS pages #2 (>b000) and #3 (>c000) 
        ;-------------------------------------------------------
        ; Copy dialogs
        ;-------------------------------------------------------
        bl    @cpym2m               ; Copy dialogs data to >b000
              data dialogs,>b000,enddial-dialogs
        ;------------------------------------------------------
        ; Restore current SAMS pages
        ;------------------------------------------------------
        bl    @mem.sams.dialogs.off ; Turn off SAMS pages #2 (>b000) and #3 (>c000)                                                                     
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
rom.dialogs2ram.exit:
        .popregs 2                  ; Pop registers and return to caller

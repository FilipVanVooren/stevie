* FILE......: rom.crash.asm
* Purpose...: Show ROM bank number on CPU crash

***************************************************************
* Show ROM bank number on CPU crash
********|*****|*********************|**************************
cpu.crash.showbank:
        aorg  bankx.crash.showbank
        bl    @putat
              byte 3,20
              data cpu.crash.showbank.bankstr
        jmp   $
* FILE......: rom.header.asm
* Purpose...: Cartridge header

*--------------------------------------------------------------
* Cartridge header
********|*****|*********************|**************************
        byte  >aa,1,1,0,0,0
        data  $+10
        byte  0,0,0,0,0,0,0,0
        data  0                     ; No more items following
        data  kickstart.code1

        .ifdef debug
              #string 'STEVIE 1.1B'
        .else
              #string 'STEVIE 1.1B'
        .endif

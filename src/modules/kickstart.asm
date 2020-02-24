* FILE......: kickstart.asm
* Purpose...: Bankswitch routine for starting TiVi

***************************************************************
* kickstart
* Kickstart ROM bank 0
***************************************************************
* 
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* r0
***************************************************************

*--------------------------------------------------------------
* Cartridge header
*--------------------------------------------------------------
        byte  >aa,1,1,0,0,0
        data  $+10
        byte  0,0,0,0,0,0,0,0
        data  0                     ; No more items following
        data  kickstart

        .ifdef debug
              #string 'TIVI %%build_date%%'
        .else
              #string 'TIVI'
        .endif

        aorg  kickstart
        clr   @>6002                ; Switch to bank 0

        bl    @cpym2m
              data >6000,>2000,8192
                                    ; Copy 8K bank to low memory expansion

        b     @runlib        
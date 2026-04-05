* FILE......: cart.fg99.mgr.asm
* Purpose...: Controller for running FinalGROM 99 cartridge image

***************************************************************
* cart.fg99.mgr
* Run FinalGROM cartridge image
***************************************************************
* bl   @cart.fg99.mgr
*--------------------------------------------------------------
* INPUT
* @cmdb.cmdall = Cartridge image name
*
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
*--------------------------------------------------------------
* Remarks
********|*****|*********************|**************************
cart.fg99.mgr:
        .pushregs 2                 ; Push registers and return address on stack
        ;-------------------------------------------------------        
        ; Exit early if no image name specified
        ;-------------------------------------------------------
        bl    @cmdb.cmd.getlength   ; Get length of current command
        mov   @outparm1,tmp0        ; Length == 0 ?
        jeq   cart.fg99.mgr.exit    ; Yes, exit early        
        ;-------------------------------------------------------        
        ; Setup cartridge image
        ;-------------------------------------------------------       
        bl    @cpym2m                 ; Copy cartridge template to RAM
              data fg99.cart.template ; \ Source
              data rambuf             ; | Destination
              data 20                 ; / Length (bytes)

        li    tmp0,cmdb.cmd         ; Cartridge image name (no length prefix)
        li    tmp1,rambuf + 8       ; Poke filename into template
        mov   @outparm1,tmp2        ; Get length of cartridge image name

        bl    @xpym2m               ; Copy memory block
                                    ; \ i  tmp0 = source
                                    ; | i  tmp1 = destination
                                    ; / i  tmp2 = bytes to copy    
        ;------------------------------------------------------
        ; Run FinalGROM cartridge image
        ;------------------------------------------------------
        li    tmp0,rambuf           ; \
        mov   tmp0,@tv.fg99.img.ptr ; / Set pointer to cartridge structure

        bl    @cart.fg99.run        ; Run FinalGROM cartridge
                                    ; \ i @tv.fg99.img.ptr = Pointer to image
                                    ; /
*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
cart.fg99.mgr.exit:
        .popregs 2                  ; Pop registers and return to caller

*--------------------------------------------------------------
* Cartridge template
*--------------------------------------------------------------
fg99.cart.template:
       byte   >99                   ; \
       text   'OKFG99'              ; | Send this to reload
       byte   >99                   ; / 
       byte   >00, >00, >00, >00    ; \ File to load (8 chars, pad with >00)
       byte   >00, >00, >00, >00    ; /
       data   >0000                 ; >0000 for GROM/mixed, >FFFF for ROM only
       data   >0000                 ; Start address
       even        

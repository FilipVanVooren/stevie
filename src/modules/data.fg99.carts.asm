* FILE......: data.fg99.carts.asm
* Purpose...: FinalGROM cartridge images

***************************************************************
*                   Cartridge images
***************************************************************

*--------------------------------------------------------------
* Cartridge 'Force Command'
*--------------------------------------------------------------
fg99.cart.fcmd:
       byte   >99                   ; \
       text   'OKFG99'              ; | Send this to reload
       byte   >99                   ; / 
       text   "FCMDG"               ; \ File to load (8 chars, pad with >00)
       byte   >00, >00, >00         ; /
       data   >0000                 ; >0000 for GROM/mixed, >FFFF for ROM only
       data   >0000                 ; Start address
       even

*--------------------------------------------------------------
* Cartridge 'TI Extended Basic'
*--------------------------------------------------------------
fg99.cart.xb:
       byte   >99                   ; \
       text   'OKFG99'              ; | Send this to reload
       byte   >99                   ; / 
       text   "XB29GEMC"            ; \ File to load (8 chars, pad with >00)
                                    ; /
       data   >0000                 ; >0000 for GROM/mixed, >FFFF for ROM only
       data   >0000                 ; Start address
       even

*--------------------------------------------------------------
* Cartridge 'Extended Basic GEM'
*--------------------------------------------------------------
fg99.cart.xbgem:
       byte   >99                   ; \
       text   'OKFG99'              ; | Send this to reload
       byte   >99                   ; / 
       text   "XB29GEMC"            ; \ File to load (8 chars, pad with >00)
                                    ; /
       data   >0000                 ; >0000 for GROM/mixed, >FFFF for ROM only
       data   >0000                 ; Start address
       even       

*--------------------------------------------------------------
* Cartridge 'Rich Extended Basic'
*--------------------------------------------------------------
fg99.cart.rxb:
       byte   >99                   ; \
       text   'OKFG99'              ; | Send this to reload
       byte   >99                   ; / 
       text   "RXBG"                ; \ File to load (8 chars, pad with >00)
       byte   >00, >00, >00, >00    ; /
       data   >0000                 ; >0000 for GROM/mixed, >FFFF for ROM only
       data   >0000                 ; Start address
       even       

*--------------------------------------------------------------
* Index
*--------------------------------------------------------------
fg99.carts.index:
       data fg99.cart.fcmd          ; 0: Force Command
       data fg99.cart.xb            ; 1: TI Extended Basic
       data fg99.cart.xbgem         ; 2: Extended Basic GEM
       data fg99.cart.rxb           ; 3: Rich Extended Basic
    
* FILE......: data.fg99.carts.asm
* Purpose...: FinalGROM cartridge images

***************************************************************
*                   Cartridge images
***************************************************************
       even
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
* Cartridge 'Extended Basic GEM'
*--------------------------------------------------------------
fg99.cart.xbgem:
       byte   >99                   ; \
       text   'OKFG99'              ; | Send this to reload
       byte   >99                   ; / 
       text   "XB29GEMG"            ; \ File to load (8 chars, pad with >00)
       ;                            ; /
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
* Cartridge 'fbForth'
*--------------------------------------------------------------
fg99.cart.fbforth:
       byte   >99                   ; \
       text   'OKFG99'              ; | Send this to reload
       byte   >99                   ; / 
       text   "FBFORTHC"            ; \ File to load (8 chars, pad with >00)
       ;                            ; /
       data   >0000                 ; >0000 for GROM/mixed, >FFFF for ROM only
       data   >0000                 ; Start address
       even       

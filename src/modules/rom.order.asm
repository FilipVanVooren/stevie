* FILE......: rom.order.asm
* Purpose...: Equates with CPU write addresses for switching banks

*--------------------------------------------------------------
* ROM 8K/4K banks. Bank order (non-inverted)
*--------------------------------------------------------------
bank0.rom                 equ  >6000   ; Jill
bank1.rom                 equ  >6002   ; James
bank2.rom                 equ  >6004   ; Jacky
bank3.rom                 equ  >6006   ; John
bank4.rom                 equ  >6008   ; Janine
bank5.rom                 equ  >600a   ; Jumbo
bank6.rom                 equ  >600c   ; Jenifer
bank7.rom                 equ  >600e   ; Jonas
bank8.rom                 equ  >6010   ; Q
bank9.rom                 equ  >6012   ; free
banka.rom                 equ  >6014   ; free
bankb.rom                 equ  >6016   ; free
bankc.rom                 equ  >6018   ; free
bankd.rom                 equ  >601a   ; free
banke.rom                 equ  >601c   ; free
bankf.rom                 equ  >601e   ; free
*--------------------------------------------------------------
* RAM 4K banks (Only valid in advanced mode FG99)
*--------------------------------------------------------------
bank0.ram                 equ  >6800   ; Jill
bank1.ram                 equ  >6802   ; James
bank2.ram                 equ  >6804   ; Jacky
bank3.ram                 equ  >6806   ; John
bank4.ram                 equ  >6808   ; Janine
bank5.ram                 equ  >680a   ; Jumbo
bank6.ram                 equ  >680c   ; Jenifer
bank7.ram                 equ  >680e   ; Jonas
bank8.ram                 equ  >6810   ; Q
bank9.ram                 equ  >6812   ; free
banka.ram                 equ  >6814   ; free
bankb.ram                 equ  >6816   ; free
bankc.ram                 equ  >6818   ; free
bankd.ram                 equ  >681a   ; free
banke.ram                 equ  >681c   ; free
bankf.ram                 equ  >681e   ; free

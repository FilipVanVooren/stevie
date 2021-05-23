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
*--------------------------------------------------------------
* RAM 4K banks (Only valid in advance mode FG99)
*--------------------------------------------------------------
bank0.ram                 equ  >6800   ; Jill
bank1.ram                 equ  >6802   ; James
bank2.ram                 equ  >6804   ; Jacky
bank3.ram                 equ  >6806   ; John
bank4.ram                 equ  >6808   ; Janine
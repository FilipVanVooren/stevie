* FILE......: rom.order.asm
* Purpose...: Equates with CPU write addresses for switching banks

*--------------------------------------------------------------
* Bank order (non-inverted)
*--------------------------------------------------------------
bank0                     equ  >6000   ; Jill
bank1                     equ  >6002   ; James
bank2                     equ  >6004   ; Jacky
bank3                     equ  >6006   ; John
bank4                     equ  >6008   ; Janine

bank0.ram                 equ  >6800   ; Jill
bank1.ram                 equ  >6802   ; James
bank2.ram                 equ  >6804   ; Jacky
bank3.ram                 equ  >6806   ; John
bank4.ram                 equ  >6808   ; Janine
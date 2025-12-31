* FILE......: equ.vdp.asm
* Purpose...: VDP configuration (F18a, 9938, ...)

***************************** F18a 24x80 ***************************************
  .ifeq vdpmode, 2480
    copy 'equ.f18a.2480.asm'        ; Sprite cursor/rulers 
  .endif

***************************** F18a 24x80 ***************************************
  .ifeq vdpmode, 2481
    copy 'equ.f18a.2481.asm'        ; Character cursor
  .endif

***************************** F18a 30x80 ***************************************
  .ifeq vdpmode, 3080
    copy 'equ.f18a.3080.asm'        ; Sprite cursor/rulers
  .endif

***************************** F18a 30x80 ***************************************
  .ifeq vdpmode, 3081
    copy 'equ.f18a.3081.asm'        ; Character cursor
  .endif

**************************** PICO9918 48x80 ************************************
  .ifeq vdpmode, 4881
    copy 'equ.pico9918.4881.asm'    ; Character cursor
  .endif

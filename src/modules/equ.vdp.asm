* FILE......: equ.vdp.asm
* Purpose...: VDP configuration (F18a, PICO9918, 9938, ...)

***************************** F18a/PICO9918 24x80 ******************************
  .ifeq vdpmode, 2480
    copy 'equ.vdp.2480.asm' ; Character cursor
  .endif

***************************** F18a/PICO9918 30x80 ******************************
  .ifeq vdpmode, 3080
    copy 'equ.vdp.3080.asm' ; Character cursor
  .endif

******************************* PICO9918 48x80 *********************************
  .ifeq vdpmode, 4880
    copy 'equ.vdp.4880.asm' ; Character cursor
  .endif

******************************* PICO9918 60x80 *********************************
  .ifeq vdpmode, 6080
    copy 'equ.vdp.6080.asm' ; Character cursor
  .endif

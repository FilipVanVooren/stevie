* FILE......: equates.f18a.asm
* Purpose...: F18a VDP configuration

***************************** F18a 24x80 ***************************************
  .ifeq vdpmode, 2480
    copy 'equates.f18a.24x80.asm' 
  .endif

***************************** F18a 30x80 ***************************************
  .ifeq vdpmode, 3080
    copy 'equates.f18a.30x80.asm' 
  .endif

***************************** F18a 60x80 ***************************************
  .ifeq vdpmode, 6080
    copy 'equates.f18a.60x80.asm' 
  .endif

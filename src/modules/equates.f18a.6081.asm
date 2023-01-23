* FILE......: equates.f18a.6080.asm
* Purpose...: F18a 60x80 mode (js99er emulation only)

  .ifeq vdpmode, 6081

*===============================================================================
* VDP RAM F18a (0000-47ff)
*
*     Mem range   Bytes    Hex    Purpose
*     =========   =====   =====   =================================
*     0000-12bf    4800   >12c0   PNT: Pattern Name Table

*     0fc0-0fff       0           PCT: Color Table (not used in 80 cols mode)
*     0fc0-0fff       0           SAT: Sprite Attribute Table
*                                      (not used in Stevie f18a 60 rows mode)
*
*     1800-2abf    4800   >12c0   TAT: Tile Attribute Table
*                                      (Position based colors F18a, 80 colums)
*
*     3000-33ff    1024   >0400   PDT: Pattern Descriptor Table
*
*     3800            0           SPT: Sprite Pattern Table
*                                      (not used in Stevie f18a 60 rows mode)
*
*     3800-384f      80   >0050   FIO: File record buffer (DIS/VAR 80)
*     3900-39ff     255   >0100   FIO: PAB buffer for file descriptor/name
*===============================================================================

*--------------------------------------------------------------
* Video mode configuration (stevie) - Graphics mode 30x80
*--------------------------------------------------------------
vdp.fb.toprow.sit         equ  >0050   ; VDP SIT address of 1st Framebuffer row
vdp.fb.toprow.tat         equ  >1850   ; VDP TAT address of 1st Framebuffer row
vdp.sit.base              equ  >0000   ; VDP SIT base address
vdp.sit.size              equ  60*80   ; VDP SIT size 80 columns, 60 rows
vdp.tat.base              equ  >1800   ; VDP TAT base address
vdp.tat.size              equ  60*80   ; VDP TAT size 80 columns, 60 rows
vdp.pdt.base              equ  >3000   ; VDP PDT base address

*--------------------------------------------------------------
* Video mode configuration (stevie)
*--------------------------------------------------------------
pane.botrow               equ  59      ; Bottom row on screen
colrow                    equ  80      ; Columns per row
fh.vrecbuf                equ  >3800   ; VDP address record buffer
fh.vpab                   equ  >3900   ; VDP address PAB
device.f18a               equ  1       ; F18a on
spritecursor              equ  0       ; Use sprites for cursor and ruler

*--------------------------------------------------------------
* Video mode configuration (spectra2)
*--------------------------------------------------------------
spfclr  equ   >f4                   ; Foreground/Background color for font.
spfbck  equ   >04                   ; Screen background color.
spvmod  equ   bankx.vdptab+10       ; Video mode.   See VIDTAB for details.
spfont  equ   0                     ; Font to load. See LDFONT for details.
colrow  equ   80                    ; Columns per row
pctadr  equ   >0fc0                 ; VDP color table base, not used in 80 cols
fntadr  equ   >3100                 ; VDP font start address (in PDT range)
sprsat  equ   >3a00                 ; VDP sprite attribute table
sprpdt  equ   >3800                 ; VDP sprite pattern table

  .endif

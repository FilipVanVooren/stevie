* FILE......: equates.f18a.3081.asm
* Purpose...: F18a 30x80 mode (no sprite support)

  .ifeq vdpmode, 3081

*===============================================================================
* VDP RAM F18a (0000-47ff)
*
*     Mem range   Bytes    Hex    Purpose
*     =========   =====   =====   =================================
*     0000-095f    2400   >0960   PNT: Pattern Name Table
*     0960-09af      80   >0050   FIO: File record buffer (DIS/VAR 80)
*     0fc0-0fff                   PCT: Color Table (not used in 80 cols mode)
*     1000-17ff    2048   >0800   PDT: Pattern Descriptor Table
*     1800-215f    2400   >0960   TAT: Tile Attribute Table
*                                      (Position based colors F18a, 80 colums)
*     2180                        SAT: Sprite Attribute Table
*                                      (Cursor in F18a, 80 cols mode)
*     2800                        SPT: Sprite Pattern Table
*                                      (Cursor in F18a, 80 columns, 2K boundary)
*===============================================================================

*--------------------------------------------------------------
* Video mode configuration (stevie) - Graphics mode 30x80
*--------------------------------------------------------------
vdp.fb.toprow.sit         equ  >0050   ; VDP SIT address of 1st Framebuffer row
vdp.fb.toprow.tat         equ  >1850   ; VDP TAT address of 1st Framebuffer row
vdp.sit.base              equ  >0000   ; VDP SIT base address
vdp.sit.size              equ  30*80   ; VDP SIT size 80 columns, 30 rows
vdp.tat.base              equ  >1800   ; VDP TAT base address

*--------------------------------------------------------------
* Video mode configuration (stevie)
*--------------------------------------------------------------
pane.botrow               equ  29      ; Bottom row on screen
colrow                    equ  80      ; Columns per row
device.f18a               equ  1       ; F18a GPU
spritecursor              equ  0       ; Use char for cursor


*--------------------------------------------------------------
* Video mode configuration (spectra2)
*--------------------------------------------------------------
spfclr  equ   >f4                   ; Foreground/Background color for font.
spfbck  equ   >04                   ; Screen background color.
spvmod  equ   bankx.vdptab          ; Video mode.   See VIDTAB for details.
spfont  equ   0                     ; Font to load. See LDFONT for details.

pctadr  equ   >0fc0                 ; VDP color table base
fntadr  equ   >1100                 ; VDP font start address (in PDT range)
sprsat  equ   >2180                 ; VDP sprite attribute table
sprpdt  equ   >2800                 ; VDP sprite pattern table

  .else

     .error 'VDP mode pragmas not correctly set!'

  .endif

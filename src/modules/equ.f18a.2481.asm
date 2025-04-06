* FILE......: equ.f18a.2481.chr.asm
* Purpose...: F18a 24x80 mode (no sprite support)

  .ifeq vdpmode, 2481

*--------------------------------------------------------------
* Video mode configuration (stevie) - Graphics mode 24x80
*--------------------------------------------------------------
vdp.sit.base              equ  >0000   ; VDP SIT base address
vdp.sit.size              equ  24*80   ; VDP SIT size 80 columns, 24 rows
vdp.tat.base              equ  >0980   ; VDP TAT base address
vdp.tat.size              equ  24*80   ; VDP TAT size 80 columns, 60 rows
vdp.pdt.base              equ  >1800   ; VDP PDT base address

vdp.fb.toprow.sit         equ  vdp.sit.base + >50   ; VDP SIT 1st Framebuf row
vdp.fb.toprow.tat         equ  vdp.tat.base + >50   ; VDP TAT 1st Framebuf row

*--------------------------------------------------------------
* Video mode configuration (stevie)
*--------------------------------------------------------------
pane.botrow               equ  23      ; Bottom row on screen
colrow                    equ  80      ; Columns per row
device.f18a               equ  1       ; F18a on
spritecursor              equ  0       ; Use chars for cursor

*--------------------------------------------------------------
* VDP memory setup for file handling
*--------------------------------------------------------------
fh.vrecbuf                equ  >2000   ; VDP address record buffer
fh.filebuf                equ  >2000   ; VDP address binary file buffer
fh.vpab                   equ  >1400   ; VDP address PAB

*--------------------------------------------------------------
* Video mode configuration (spectra2)
*--------------------------------------------------------------
spfclr  equ   >f4                   ; Foreground/Background color for font.
spfbck  equ   >04                   ; Screen background color.
spvmod  equ   bankx.vdptab          ; Video mode.   See VIDTAB for details.
spfont  equ   >0c                   ; Font to load. See LDFONT for details.
pctadr  equ   >0fc0                 ; VDP color table base
fntadr  equ   vdp.pdt.base + >100   ; VDP font start address (in PDT range)
sprsat  equ   >1300                 ; VDP sprite attribute table
sprpdt  equ   >1800                 ; VDP sprite pattern table

  .endif

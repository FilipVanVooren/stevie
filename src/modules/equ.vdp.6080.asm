* FILE......: equ.vdp.6080.asm
* Purpose...: PICO9918 60x80 mode

  .ifeq vdpmode, 6080

*--------------------------------------------------------------
* Video mode configuration (stevie) - Graphics mode 48x80
*--------------------------------------------------------------
vdp.sit.base              equ  >0000   ; VDP SIT base address
vdp.sit.size              equ  60*80   ; VDP SIT size 80 columns, 48 rows
vdp.tat.base              equ  >12c0   ; VDP TAT base address
vdp.tat.size              equ  60*80   ; VDP TAT size 80 columns, 60 rows
vdp.pdt.base              equ  >2800   ; VDP PDT base address

vdp.fb.toprow.sit         equ  vdp.sit.base + >50   ; VDP SIT 1st Framebuf row
vdp.fb.toprow.tat         equ  vdp.tat.base + >50   ; VDP TAT 1st Framebuf row

*--------------------------------------------------------------
* Video mode configuration (stevie)
*--------------------------------------------------------------
pane.botrow               equ  59      ; Bottom row on screen
colrow                    equ  80      ; Columns per row
device.f18a               equ  1       ; F18a/PICO9918 on

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
pctadr  equ   >12c0                 ; VDP color table base
fntadr  equ   vdp.pdt.base + >100   ; VDP font start address (in PDT range)
sprsat  equ   >2580                 ; VDP sprite attribute table
sprpdt  equ   >2800                 ; VDP sprite pattern table

  .endif

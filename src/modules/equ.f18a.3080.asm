* FILE......: equ.f18a.3080.asm
* Purpose...: F18a 30x80 mode (with sprite cursor/rulers)

  .ifeq vdpmode, 3080

*--------------------------------------------------------------
* Video mode configuration (stevie) - Graphics mode 30x80
*--------------------------------------------------------------
vdp.sit.base              equ  >0000   ; VDP SIT base address
vdp.sit.size              equ  30*80   ; VDP SIT size 80 columns, 30 rows
vdp.tat.base              equ  >0980   ; VDP TAT base address
vdp.tat.size              equ  30*80   ; VDP TAT size 80 columns, 30 rows
vdp.pdt.base              equ  >3800   ; VDP PDT base address

vdp.fb.toprow.sit         equ  vdp.sit.base + >50   ; VDP SIT 1st Framebuf row
vdp.fb.toprow.tat         equ  vdp.tat.base + >50   ; VDP TAT 1st Framebuf row

*--------------------------------------------------------------
* Video mode configuration (stevie)
*--------------------------------------------------------------
pane.botrow               equ  29      ; Bottom row on screen
colrow                    equ  80      ; Columns per row
device.f18a               equ  1       ; F18a on
spritecursor              equ  1       ; Use sprites for cursor and ruler

*--------------------------------------------------------------
* VDP memory setup for file handling
*--------------------------------------------------------------
fh.vrecbuf                equ  >12e0   ; VDP address record buffer
fh.filebuf                equ  >12e0   ; VDP address binary file buffer
fh.vpab                   equ  >0960   ; VDP address PAB

*--------------------------------------------------------------
* Video mode configuration (spectra2)
*--------------------------------------------------------------
spfclr  equ   >f4                   ; Foreground/Background color for font.
spfbck  equ   >04                   ; Screen background color.
spvmod  equ   bankx.vdptab          ; Video mode.   See VIDTAB for details.
spfont  equ   0                     ; Font to load. See LDFONT for details.
pctadr  equ   >0fc0                 ; \ VDP color table base. 
                                    ; / Not used in F18a 80 columns mode
fntadr  equ   vdp.pdt.base + >100   ; VDP font start address (in PDT range)
sprsat  equ   >3480                 ; VDP sprite attribute table
sprpdt  equ   >3800                 ; VDP sprite pattern table

  .endif

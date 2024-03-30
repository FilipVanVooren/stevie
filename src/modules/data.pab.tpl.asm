* FILE......: data.pab.tpl.asm
* Purpose...: PAB templates for accessing files


***************************************************************
* PAB for accessing catalog file
********|*****|*********************|**************************
        even                        ; Must always start on even address!!
fh.file.pab.header.cat:
        byte  io.op.open            ;  0    - OPEN
        byte  io.rel.inp.int.fix    ;  1    - INPUT, RELATIVE, INTERNAL, FIXED
        data  fh.vrecbuf            ;  2-3  - Record buffer in VDP memory
        byte  00                    ;  4    - Record length (unset, DSR control)
        byte  00                    ;  5    - Character count
        data  >0000                 ;  6-7  - Seek record (only for fixed recs)
        byte  >00                   ;  8    - Screen offset (cassette DSR only)
        ;------------------------------------------------------
        ; Filename descriptor part (variable length)
        ;------------------------------------------------------        
        ; byte  12                  ;  9    - File descriptor length
        ; text 'DSK3.XBEADOC'       ; 10-.. - File descriptor 
                                    ;         (Device + '.' + File name)       


***************************************************************
* PAB for accessing DV/80 file
********|*****|*********************|**************************
        even                        ; Must always start on even address!!
fh.file.pab.header:
        byte  io.op.open            ;  0    - OPEN
        byte  io.seq.inp.dis.var    ;  1    - INPUT, VARIABLE, DISPLAY
        data  fh.vrecbuf            ;  2-3  - Record buffer in VDP memory
        byte  80                    ;  4    - Record length (80 chars max)
        byte  00                    ;  5    - Character count
        data  >0000                 ;  6-7  - Seek record (only for fixed recs)
        byte  >00                   ;  8    - Screen offset (cassette DSR only)
        ;------------------------------------------------------
        ; File descriptor part (variable length)
        ;------------------------------------------------------        
        ; byte  64                  ;  9    - File descriptor length
        ; text 'DSK3.XBEADOC'       ; 10-.. - File descriptor 
                                    ;         (Device + '.' + File name)          


***************************************************************
* PAB for loading binary image
********|*****|*********************|**************************
        even                        ; Must always start on even address!!
fh.file.pab.header.binimage:
        byte  io.op.load            ;  0    - LOAD BINARY
        byte  00                    ;  1    - Not used
        data  >1380                 ;  2-3  - Buffer location in VDP memory
        data  >0000                 ;  4-5  - Not used in load operation
        data  8448                  ;  6-7  - Maximum number of bytes to load
        byte  00                    ;  8    - Not used
        ;------------------------------------------------------
        ; File descriptor part (variable length)
        ;------------------------------------------------------        
        ; byte  64                  ;  9    - File descriptor length
        ; text 'DSK3.XBEADOC'       ; 10-.. - File descriptor 
                                    ;         (Device + '.' + File name)          

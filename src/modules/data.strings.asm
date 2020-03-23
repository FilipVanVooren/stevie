* FILE......: data.strings.asm
* Purpose...: TiVi Editor - data segment (strings)

***************************************************************
*                       Strings
***************************************************************
txt.delim          #string ','
txt.marker         #string '*EOF*'
txt.bottom         #string '  BOT'
txt.ovrwrite       #string 'OVR'
txt.insert         #string 'INS'
txt.star           #string '*'
txt.loading        #string 'Loading...'
txt.kb             #string 'kb'
txt.rle            #string 'RLE'
txt.lines          #string 'Lines'
txt.ioerr          #string '> I/O error occured. Could not load file:'
txt.bufnum         #string '#1'
txt.newfile        #string '[New file]'


txt.cmdb.cmdb       #string 'Command Buffer '
txt.cmdb.catalog    #string 'File catalog '


txt.filetype.dv80  #string 'DIS/VAR80 '
txt.filetype.none  #string '          '

txt.tivi     byte    24
             byte    4
             text    'TiVi beta %%build_date%%'
             byte    5
             even

fdname0      #string 'DSK1.INVADERS'
fdname1      #string 'DSK1.SPEECHDOCS'
fdname2      #string 'DSK1.XBEADOC'
fdname3      #string 'DSK3.XBEADOC'
fdname4      #string 'DSK3.C99MAN1'
fdname5      #string 'DSK3.C99MAN2'
fdname6      #string 'DSK3.C99MAN3'
fdname7      #string 'DSK3.C99SPECS'
fdname8      #string 'DSK3.RANDOM#C'
fdname9      #string 'DSK1.INVADERS'


*---------------------------------------------------------------
* Keyboard labels - Function keys
*---------------------------------------------------------------
txt.fctn.0     #string 'fctn + 0'
txt.fctn.1     #string 'fctn + 1'
txt.fctn.2     #string 'fctn + 2'
txt.fctn.3     #string 'fctn + 3'
txt.fctn.4     #string 'fctn + 4'
txt.fctn.5     #string 'fctn + 5'
txt.fctn.6     #string 'fctn + 6'
txt.fctn.7     #string 'fctn + 7'
txt.fctn.8     #string 'fctn + 8'
txt.fctn.9     #string 'fctn + 9'
txt.fctn.a     #string 'fctn + a'
txt.fctn.b     #string 'fctn + b'
txt.fctn.c     #string 'fctn + c'
txt.fctn.d     #string 'fctn + d'
txt.fctn.e     #string 'fctn + e'
txt.fctn.f     #string 'fctn + f'
txt.fctn.g     #string 'fctn + g'
txt.fctn.h     #string 'fctn + h'
txt.fctn.i     #string 'fctn + i'
txt.fctn.j     #string 'fctn + j'
txt.fctn.k     #string 'fctn + k'
txt.fctn.l     #string 'fctn + l'
txt.fctn.m     #string 'fctn + m'
txt.fctn.n     #string 'fctn + n'
txt.fctn.o     #string 'fctn + o'
txt.fctn.p     #string 'fctn + p'
txt.fctn.q     #string 'fctn + q'
txt.fctn.r     #string 'fctn + r'
txt.fctn.s     #string 'fctn + s'
txt.fctn.t     #string 'fctn + t'
txt.fctn.u     #string 'fctn + u'
txt.fctn.v     #string 'fctn + v'
txt.fctn.w     #string 'fctn + w'
txt.fctn.x     #string 'fctn + x'
txt.fctn.y     #string 'fctn + y'
txt.fctn.z     #string 'fctn + z'
*---------------------------------------------------------------
* Keyboard labels - Function keys extra
*---------------------------------------------------------------
txt.fctn.dot   #string 'fctn + .'
txt.fctn.plus  #string 'fctn + +'
*---------------------------------------------------------------
* Keyboard labels - Control keys
*---------------------------------------------------------------
txt.ctrl.0     #string 'ctrl + 0'
txt.ctrl.1     #string 'ctrl + 1'
txt.ctrl.2     #string 'ctrl + 2'
txt.ctrl.3     #string 'ctrl + 3'
txt.ctrl.4     #string 'ctrl + 4'
txt.ctrl.5     #string 'ctrl + 5'
txt.ctrl.6     #string 'ctrl + 6'
txt.ctrl.7     #string 'ctrl + 7'
txt.ctrl.8     #string 'ctrl + 8'
txt.ctrl.9     #string 'ctrl + 9'
txt.ctrl.a     #string 'ctrl + a'
txt.ctrl.b     #string 'ctrl + b'
txt.ctrl.c     #string 'ctrl + c'
txt.ctrl.d     #string 'ctrl + d'
txt.ctrl.e     #string 'ctrl + e'
txt.ctrl.f     #string 'ctrl + f'
txt.ctrl.g     #string 'ctrl + g'
txt.ctrl.h     #string 'ctrl + h'
txt.ctrl.i     #string 'ctrl + i'
txt.ctrl.j     #string 'ctrl + j'
txt.ctrl.k     #string 'ctrl + k'
txt.ctrl.l     #string 'ctrl + l'
txt.ctrl.m     #string 'ctrl + m'
txt.ctrl.n     #string 'ctrl + n'
txt.ctrl.o     #string 'ctrl + o'
txt.ctrl.p     #string 'ctrl + p'
txt.ctrl.q     #string 'ctrl + q'
txt.ctrl.r     #string 'ctrl + r'
txt.ctrl.s     #string 'ctrl + s'
txt.ctrl.t     #string 'ctrl + t'
txt.ctrl.u     #string 'ctrl + u'
txt.ctrl.v     #string 'ctrl + v'
txt.ctrl.w     #string 'ctrl + w'
txt.ctrl.x     #string 'ctrl + x'
txt.ctrl.y     #string 'ctrl + y'
txt.ctrl.z     #string 'ctrl + z'
*---------------------------------------------------------------
* Keyboard labels - control keys extra
*---------------------------------------------------------------
txt.ctrl.plus  #string 'ctrl + +'
*---------------------------------------------------------------
* Special keys
*---------------------------------------------------------------
txt.enter      #string 'enter'
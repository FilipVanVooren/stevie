* FILE......: data.keymap.asm
* Purpose...: Stevie Editor - data segment (keyboard mapping)

*---------------------------------------------------------------
* Keyboard scancodes - Function keys
*-------------|---------------------|---------------------------
key.fctn.0    equ >0000             ; fctn + 0
key.fctn.1    equ >0300             ; fctn + 1
key.fctn.2    equ >0400             ; fctn + 2
key.fctn.3    equ >0700             ; fctn + 3
key.fctn.4    equ >0000             ; fctn + 4
key.fctn.5    equ >0e00             ; fctn + 5
key.fctn.6    equ >0000             ; fctn + 6
key.fctn.7    equ >0000             ; fctn + 7
key.fctn.8    equ >0000             ; fctn + 8
key.fctn.9    equ >0f00             ; fctn + 9
key.fctn.a    equ >0000             ; fctn + a
key.fctn.b    equ >0000             ; fctn + b
key.fctn.c    equ >0000             ; fctn + c
key.fctn.d    equ >0900             ; fctn + d
key.fctn.e    equ >0b00             ; fctn + e
key.fctn.f    equ >0000             ; fctn + f
key.fctn.g    equ >0000             ; fctn + g
key.fctn.h    equ >0000             ; fctn + h
key.fctn.i    equ >0000             ; fctn + i
key.fctn.j    equ >0000             ; fctn + j
key.fctn.k    equ >0000             ; fctn + k
key.fctn.l    equ >0000             ; fctn + l
key.fctn.m    equ >0000             ; fctn + m
key.fctn.n    equ >0000             ; fctn + n
key.fctn.o    equ >0000             ; fctn + o
key.fctn.p    equ >0000             ; fctn + p
key.fctn.q    equ >0000             ; fctn + q
key.fctn.r    equ >0000             ; fctn + r
key.fctn.s    equ >0800             ; fctn + s
key.fctn.t    equ >0000             ; fctn + t
key.fctn.u    equ >0000             ; fctn + u
key.fctn.v    equ >0000             ; fctn + v
key.fctn.w    equ >0000             ; fctn + w
key.fctn.x    equ >0a00             ; fctn + x
key.fctn.y    equ >0000             ; fctn + y
key.fctn.z    equ >0000             ; fctn + z
*---------------------------------------------------------------
* Keyboard scancodes - Function keys extra
*---------------------------------------------------------------
key.fctn.dot    equ >b900           ; fctn + .
key.fctn.comma  equ >b800           ; fctn + ,
key.fctn.plus   equ >0500           ; fctn + +
*---------------------------------------------------------------
* Keyboard scancodes - control keys
*-------------|---------------------|---------------------------
key.ctrl.0    equ >b000             ; ctrl + 0
key.ctrl.1    equ >b100             ; ctrl + 1
key.ctrl.2    equ >b200             ; ctrl + 2
key.ctrl.3    equ >b300             ; ctrl + 3
key.ctrl.4    equ >b400             ; ctrl + 4
key.ctrl.5    equ >b500             ; ctrl + 5
key.ctrl.6    equ >b600             ; ctrl + 6
key.ctrl.7    equ >b700             ; ctrl + 7
key.ctrl.8    equ >9e00             ; ctrl + 8
key.ctrl.9    equ >9f00             ; ctrl + 9
key.ctrl.a    equ >8100             ; ctrl + a
key.ctrl.b    equ >8200             ; ctrl + b
key.ctrl.c    equ >0000             ; ctrl + c
key.ctrl.d    equ >8400             ; ctrl + d
key.ctrl.e    equ >8500             ; ctrl + e
key.ctrl.f    equ >8600             ; ctrl + f
key.ctrl.g    equ >0000             ; ctrl + g
key.ctrl.h    equ >0000             ; ctrl + h
key.ctrl.i    equ >0000             ; ctrl + i
key.ctrl.j    equ >0000             ; ctrl + j
key.ctrl.k    equ >0000             ; ctrl + k
key.ctrl.l    equ >8c00             ; ctrl + l
key.ctrl.m    equ >0000             ; ctrl + m
key.ctrl.n    equ >0000             ; ctrl + n
key.ctrl.o    equ >0000             ; ctrl + o
key.ctrl.p    equ >0000             ; ctrl + p
key.ctrl.q    equ >0000             ; ctrl + q
key.ctrl.r    equ >0000             ; ctrl + r
key.ctrl.s    equ >9300             ; ctrl + s
key.ctrl.t    equ >9400             ; ctrl + t
key.ctrl.u    equ >0000             ; ctrl + u
key.ctrl.v    equ >0000             ; ctrl + v
key.ctrl.w    equ >0000             ; ctrl + w
key.ctrl.x    equ >9800             ; ctrl + x
key.ctrl.y    equ >0000             ; ctrl + y
key.ctrl.z    equ >9a00             ; ctrl + z
*---------------------------------------------------------------
* Keyboard scancodes - control keys extra
*---------------------------------------------------------------
key.ctrl.dot    equ >9b00           ; ctrl + .
key.ctrl.comma  equ >8000           ; ctrl + ,
key.ctrl.plus   equ >9d00           ; ctrl + +
*---------------------------------------------------------------
* Special keys
*---------------------------------------------------------------
key.enter     equ >0d00             ; enter



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

txt.ctrl.dot   #string 'ctrl + .'
txt.ctrl.comma #string 'ctrl + ,'
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




*---------------------------------------------------------------
* Action keys mapping table: Editor 
*---------------------------------------------------------------
keymap_actions.editor:
        ;-------------------------------------------------------
        ; Movement keys
        ;-------------------------------------------------------
        data  key.enter, txt.enter, edkey.action.enter
        data  key.fctn.s, txt.fctn.s, edkey.action.left
        data  key.fctn.d, txt.fctn.d, edkey.action.right
        data  key.fctn.e, txt.fctn.e, edkey.action.up
        data  key.fctn.x, txt.fctn.x, edkey.action.down
        data  key.ctrl.a, txt.ctrl.a, edkey.action.home
        data  key.ctrl.f, txt.ctrl.f, edkey.action.end   
        data  key.ctrl.s, txt.ctrl.s, edkey.action.pword
        data  key.ctrl.d, txt.ctrl.d, edkey.action.nword
        data  key.ctrl.e, txt.ctrl.e, edkey.action.ppage
        data  key.ctrl.x, txt.ctrl.x, edkey.action.npage
        data  key.ctrl.t, txt.ctrl.t, edkey.action.top
        data  key.ctrl.b, txt.ctrl.b, edkey.action.bot
        ;-------------------------------------------------------
        ; Modifier keys - Delete
        ;-------------------------------------------------------
        data  key.fctn.1, txt.fctn.1, edkey.action.del_char
        data  key.ctrl.k, txt.ctrl.k, edkey.action.del_eol
        data  key.fctn.3, txt.fctn.3, edkey.action.del_line
        ;-------------------------------------------------------
        ; Modifier keys - Insert
        ;-------------------------------------------------------
        data  key.fctn.2, txt.fctn.2, edkey.action.ins_char.ws
        data  key.fctn.dot, txt.fctn.dot, edkey.action.ins_onoff
        data  key.fctn.5, txt.fctn.5, edkey.action.ins_line
        ;-------------------------------------------------------
        ; Other action keys
        ;-------------------------------------------------------
        data  key.fctn.plus, txt.fctn.plus, edkey.action.quit
        data  key.ctrl.z, txt.ctrl.z, pane.action.colorscheme.cycle
        ;-------------------------------------------------------
        ; Editor/File buffer keys
        ;-------------------------------------------------------
        data  key.ctrl.0, txt.ctrl.0, edkey.action.fb.buffer0
        data  key.ctrl.1, txt.ctrl.1, edkey.action.fb.buffer1
        data  key.ctrl.2, txt.ctrl.2, edkey.action.fb.buffer2
        data  key.ctrl.3, txt.ctrl.3, edkey.action.fb.buffer3
        data  key.ctrl.4, txt.ctrl.4, edkey.action.fb.buffer4
        data  key.ctrl.5, txt.ctrl.5, edkey.action.fb.buffer5
        data  key.ctrl.6, txt.ctrl.6, edkey.action.fb.buffer6
        data  key.ctrl.7, txt.ctrl.7, edkey.action.fb.buffer7
        data  key.ctrl.8, txt.ctrl.8, edkey.action.fb.buffer8
        data  key.ctrl.9, txt.ctrl.9, edkey.action.fb.buffer9
        ;-------------------------------------------------------
        ; Dialog keys
        ;-------------------------------------------------------
        data  key.ctrl.comma, txt.ctrl.comma, edkey.action.fb.fname.dec.load
        data  key.ctrl.dot, txt.ctrl.dot, edkey.action.fb.fname.inc.load
        data  key.ctrl.l, txt.ctrl.l, dialog.loaddv80        
        ;-------------------------------------------------------
        ; End of list
        ;-------------------------------------------------------
        data  EOL                           ; EOL




*---------------------------------------------------------------
* Action keys mapping table: Command Buffer (CMDB)
*---------------------------------------------------------------
keymap_actions.cmdb:
        ;-------------------------------------------------------
        ; Movement keys
        ;-------------------------------------------------------        
        data  key.fctn.s, txt.fctn.s, edkey.action.cmdb.left
        data  key.fctn.d, txt.fctn.d, edkey.action.cmdb.right
        data  key.ctrl.a, txt.ctrl.a, edkey.action.cmdb.home
        data  key.ctrl.f, txt.ctrl.f, edkey.action.cmdb.end
        ;-------------------------------------------------------
        ; Modified keys
        ;-------------------------------------------------------
        data  key.fctn.3, txt.fctn.3, edkey.action.cmdb.clear
        data  key.enter, txt.enter, edkey.action.cmdb.loadfile
        ;-------------------------------------------------------
        ; Other action keys
        ;-------------------------------------------------------
        data  key.fctn.plus, txt.fctn.plus, edkey.action.quit
        data  key.ctrl.z, txt.ctrl.z, pane.action.colorscheme.cycle
        ;-------------------------------------------------------
        ; File load dialog
        ;-------------------------------------------------------
        data  key.ctrl.comma, txt.ctrl.comma, fm.browse.fname.suffix.dec
        data  key.ctrl.dot, txt.ctrl.dot, fm.browse.fname.suffix.inc
        ;-------------------------------------------------------
        ; Dialog keys
        ;-------------------------------------------------------
        data  key.fctn.9, txt.fctn.9, edkey.action.cmdb.hide
        ;-------------------------------------------------------
        ; End of list
        ;-------------------------------------------------------
        data  EOL                           ; EOL
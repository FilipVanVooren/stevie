* FILE......: data.keymap.keys.asm
* Purpose...: Keyboard mapping


*---------------------------------------------------------------
* Keyboard scancodes - Letter keys
*-------------|---------------------|---------------------------
key.uc.n      equ >4e00             ; N
key.uc.s      equ >5300             ; S
key.uc.o      equ >4f00             ; O
key.uc.q      equ >5100             ; Q
key.lc.n      equ >6e00             ; n
key.lc.s      equ >7300             ; s
key.lc.o      equ >6f00             ; o
key.lc.q      equ >7100             ; q


*---------------------------------------------------------------
* Keyboard scancodes - Function keys
*-------------|---------------------|---------------------------
key.fctn.0    equ >bc00             ; fctn + 0
key.fctn.1    equ >0300             ; fctn + 1
key.fctn.2    equ >0400             ; fctn + 2
key.fctn.3    equ >0700             ; fctn + 3
key.fctn.4    equ >0200             ; fctn + 4
key.fctn.5    equ >0e00             ; fctn + 5
key.fctn.6    equ >0c00             ; fctn + 6
key.fctn.7    equ >0100             ; fctn + 7
key.fctn.8    equ >0600             ; fctn + 8
key.fctn.9    equ >0f00             ; fctn + 9
key.fctn.a    equ >0000             ; fctn + a
key.fctn.b    equ >be00             ; fctn + b
key.fctn.c    equ >0000             ; fctn + c
key.fctn.d    equ >0900             ; fctn + d
key.fctn.e    equ >0b00             ; fctn + e
key.fctn.f    equ >0000             ; fctn + f
key.fctn.g    equ >0000             ; fctn + g
key.fctn.h    equ >bf00             ; fctn + h
key.fctn.i    equ >0000             ; fctn + i
key.fctn.j    equ >c000             ; fctn + j
key.fctn.k    equ >c100             ; fctn + k
key.fctn.l    equ >c200             ; fctn + l
key.fctn.m    equ >c300             ; fctn + m
key.fctn.n    equ >c400             ; fctn + n
key.fctn.o    equ >0000             ; fctn + o
key.fctn.p    equ >0000             ; fctn + p
key.fctn.q    equ >c500             ; fctn + q
key.fctn.r    equ >0000             ; fctn + r
key.fctn.s    equ >0800             ; fctn + s
key.fctn.t    equ >0000             ; fctn + t
key.fctn.u    equ >0000             ; fctn + u
key.fctn.v    equ >7f00             ; fctn + v
key.fctn.w    equ >7e00             ; fctn + w
key.fctn.x    equ >0a00             ; fctn + x
key.fctn.y    equ >c600             ; fctn + y
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
key.ctrl.c    equ >8300             ; ctrl + c
key.ctrl.d    equ >8400             ; ctrl + d
key.ctrl.e    equ >8500             ; ctrl + e
key.ctrl.f    equ >8600             ; ctrl + f
key.ctrl.g    equ >8700             ; ctrl + g
key.ctrl.h    equ >8800             ; ctrl + h
key.ctrl.i    equ >8900             ; ctrl + i
key.ctrl.j    equ >8a00             ; ctrl + j
key.ctrl.k    equ >8b00             ; ctrl + k
key.ctrl.l    equ >8c00             ; ctrl + l
key.ctrl.m    equ >8d00             ; ctrl + m
key.ctrl.n    equ >8e00             ; ctrl + n
key.ctrl.o    equ >8f00             ; ctrl + o
key.ctrl.p    equ >9000             ; ctrl + p
key.ctrl.q    equ >9100             ; ctrl + q
key.ctrl.r    equ >9200             ; ctrl + r
key.ctrl.s    equ >9300             ; ctrl + s
key.ctrl.t    equ >9400             ; ctrl + t
key.ctrl.u    equ >9500             ; ctrl + u
key.ctrl.v    equ >9600             ; ctrl + v
key.ctrl.w    equ >9700             ; ctrl + w
key.ctrl.x    equ >9800             ; ctrl + x
key.ctrl.y    equ >9900             ; ctrl + y
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
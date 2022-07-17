* FILE......: data.keymap.keys.asm
* Purpose...: Keyboard mapping


*---------------------------------------------------------------
* Keyboard scancodes - Numeric keys
*-------------|---------------------|---------------------------
key.num.0     equ >30               ; 0
key.num.1     equ >31               ; 1
key.num.2     equ >32               ; 2
key.num.3     equ >33               ; 3
key.num.4     equ >34               ; 4
key.num.5     equ >35               ; 5
key.num.6     equ >36               ; 6
key.num.7     equ >37               ; 7
key.num.8     equ >38               ; 8
key.num.9     equ >39               ; 9
*---------------------------------------------------------------
* Keyboard scancodes - Letter keys
*-------------|---------------------|---------------------------
key.uc.a      equ >41               ; A
key.uc.b      equ >42               ; B
key.uc.c      equ >43               ; C
key.uc.e      equ >45               ; E
key.uc.f      equ >46               ; F
key.uc.h      equ >48               ; H
key.uc.i      equ >49               ; I
key.uc.m      equ >4d               ; M
key.uc.n      equ >4e               ; N
key.uc.r      equ >52               ; R
key.uc.s      equ >53               ; S
key.uc.o      equ >4f               ; O
key.uc.p      equ >50               ; P
key.uc.q      equ >51               ; Q
key.lc.b      equ >a2               ; b
key.lc.e      equ >a5               ; e
key.lc.f      equ >a6               ; f
key.lc.h      equ >a8               ; h
key.lc.n      equ >6e               ; n
key.lc.s      equ >73               ; s
key.lc.o      equ >6f               ; o
key.lc.p      equ >70               ; p
key.lc.q      equ >71               ; q
*---------------------------------------------------------------
* Keyboard scancodes - Function keys
*-------------|---------------------|---------------------------
key.fctn.0    equ >bc               ; fctn + 0
key.fctn.1    equ >03               ; fctn + 1
key.fctn.2    equ >04               ; fctn + 2
key.fctn.3    equ >07               ; fctn + 3
key.fctn.4    equ >02               ; fctn + 4
key.fctn.5    equ >0e               ; fctn + 5
key.fctn.6    equ >0c               ; fctn + 6
key.fctn.7    equ >01               ; fctn + 7
key.fctn.8    equ >06               ; fctn + 8
key.fctn.9    equ >0f               ; fctn + 9
key.fctn.a    equ >00               ; fctn + a
key.fctn.b    equ >be               ; fctn + b
key.fctn.c    equ >00               ; fctn + c
key.fctn.d    equ >09               ; fctn + d
key.fctn.e    equ >0b               ; fctn + e
key.fctn.f    equ >00               ; fctn + f
key.fctn.g    equ >00               ; fctn + g
key.fctn.h    equ >bf               ; fctn + h
key.fctn.i    equ >00               ; fctn + i
key.fctn.j    equ >c0               ; fctn + j
key.fctn.k    equ >c1               ; fctn + k
key.fctn.l    equ >c2               ; fctn + l
key.fctn.m    equ >c3               ; fctn + m
key.fctn.n    equ >c4               ; fctn + n
key.fctn.o    equ >00               ; fctn + o
key.fctn.p    equ >00               ; fctn + p
key.fctn.q    equ >c5               ; fctn + q
key.fctn.r    equ >00               ; fctn + r
key.fctn.s    equ >08               ; fctn + s
key.fctn.t    equ >00               ; fctn + t
key.fctn.u    equ >00               ; fctn + u
key.fctn.v    equ >7f               ; fctn + v
key.fctn.w    equ >7e               ; fctn + w
key.fctn.x    equ >0a               ; fctn + x
key.fctn.y    equ >c6               ; fctn + y
key.fctn.z    equ >00               ; fctn + z
*---------------------------------------------------------------
* Keyboard scancodes - Function keys extra
*---------------------------------------------------------------
key.fctn.dot    equ >b9             ; fctn + .
key.fctn.comma  equ >b8             ; fctn + ,
key.fctn.plus   equ >05             ; fctn + +
*---------------------------------------------------------------
* Keyboard scancodes - control keys
*-------------|---------------------|---------------------------
key.ctrl.0    equ >b0               ; ctrl + 0
key.ctrl.1    equ >b1               ; ctrl + 1
key.ctrl.2    equ >b2               ; ctrl + 2
key.ctrl.3    equ >b3               ; ctrl + 3
key.ctrl.4    equ >b4               ; ctrl + 4
key.ctrl.5    equ >b5               ; ctrl + 5
key.ctrl.6    equ >b6               ; ctrl + 6
key.ctrl.7    equ >b7               ; ctrl + 7
key.ctrl.8    equ >9e               ; ctrl + 8
key.ctrl.9    equ >9f               ; ctrl + 9
key.ctrl.a    equ >81               ; ctrl + a
key.ctrl.b    equ >82               ; ctrl + b
key.ctrl.c    equ >83               ; ctrl + c
key.ctrl.d    equ >84               ; ctrl + d
key.ctrl.e    equ >85               ; ctrl + e
key.ctrl.f    equ >86               ; ctrl + f
key.ctrl.g    equ >87               ; ctrl + g
key.ctrl.h    equ >88               ; ctrl + h
key.ctrl.i    equ >89               ; ctrl + i
key.ctrl.j    equ >8a               ; ctrl + j
key.ctrl.k    equ >8b               ; ctrl + k
key.ctrl.l    equ >8c               ; ctrl + l
key.ctrl.m    equ >8d               ; ctrl + m
key.ctrl.n    equ >8e               ; ctrl + n
key.ctrl.o    equ >8f               ; ctrl + o
key.ctrl.p    equ >90               ; ctrl + p
key.ctrl.q    equ >91               ; ctrl + q
key.ctrl.r    equ >92               ; ctrl + r
key.ctrl.s    equ >93               ; ctrl + s
key.ctrl.t    equ >94               ; ctrl + t
key.ctrl.u    equ >95               ; ctrl + u
key.ctrl.v    equ >96               ; ctrl + v
key.ctrl.w    equ >97               ; ctrl + w
key.ctrl.x    equ >98               ; ctrl + x
key.ctrl.y    equ >99               ; ctrl + y
key.ctrl.z    equ >9a               ; ctrl + z
*---------------------------------------------------------------
* Keyboard scancodes - control keys extra
*---------------------------------------------------------------
key.ctrl.dot    equ >9b             ; ctrl + .
key.ctrl.comma  equ >80             ; ctrl + ,
key.ctrl.plus   equ >9d             ; ctrl + +
key.ctrl.slash  equ >bb             ; ctrl + /
key.ctrl.space  equ >f0             ; ctrl + SPACE
*---------------------------------------------------------------
* Special keys
*---------------------------------------------------------------
key.enter     equ >0d               ; enter
key.space     equ >20               ; space

* FILE......: equates.c99.asm
* Purpose...: Equates related to classic99

***************************************************************
*                 Extra opcodes for classic99
********|*****|*********************|**************************
c99_norm      equ  >0110            ; CPU normal
c99_ovrd      equ  >0111            ; CPU overdrive
c99_smax      equ  >0112            ; System Maximum
c99_brk       equ  >0113            ; Breakpoint
c99_quit      equ  >0114            ; Quit emulator
c99_dbg_r0    equ  >0120            ; Debug printf r0
c99_dbg_r1    equ  >0121            ; Debug printf r1
c99_dbg_r2    equ  >0122            ; Debug printf r2
c99_dbg_r3    equ  >0123            ; Debug printf r3
c99_dbg_r4    equ  >0124            ; Debug printf r4
c99_dbg_r5    equ  >0125            ; Debug printf r5
c99_dbg_r6    equ  >0126            ; Debug printf r6
c99_dbg_r7    equ  >0127            ; Debug printf r7
c99_dbg_r8    equ  >0128            ; Debug printf r8
c99_dbg_r9    equ  >0199            ; Debug printf r9
c99_dbg_ra    equ  >012a            ; Debug printf ra
c99_dbg_rb    equ  >012b            ; Debug printf rb
c99_dbg_rc    equ  >012c            ; Debug printf rc
c99_dbg_rd    equ  >012d            ; Debug printf rd
c99_dbg_re    equ  >012e            ; Debug printf re
c99_dbg_rf    equ  >012f            ; Debug printf rf
c99_dbg_tmp0  equ  c99_dbg_r4       ; Debug printf tmp0
c99_dbg_tmp1  equ  c99_dbg_r5       ; Debug printf tmp1
c99_dbg_tmp2  equ  c99_dbg_r6       ; Debug printf tmp2
c99_dbg_tmp3  equ  c99_dbg_r7       ; Debug printf tmp3
c99_dbg_tmp4  equ  c99_dbg_r8       ; Debug printf tmp4
c99_dbg_stck  equ  c99_dbg_r9       ; Debug printf stack
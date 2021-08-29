* FILE......: run.tibasic.asm
* Purpose...: Run console TI Basic 

***************************************************************
* run.tibasic.asm
* Run console TI Basic
***************************************************************
* b   @run.tibasic
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* r1 in GPL WS
********|*****|*********************|**************************
run.tibasic:
        ;-------------------------------------------------------
        ; Put VDP in TI Basic compatible mode
        ;-------------------------------------------------------        
        bl    @f18rst               ; Reset and lock the F18A

        bl    @vidtab               ; Load video mode table into VDP
              data tibasic          ; Equate selected video mode table

        bl    @ldfnt
              data >0900,fnopt3     ; Load font (upper & lower case)
      
        bl    @filv
              data >0380,>17,32     ; Load color table

        bl    @cpu.scrpad.restore     
        
        clr   r11

        mov   @run.tibasic.83d4,@>83d4
        mov   @run.tibasic.83fa,@>83fa
        mov   @run.tibasic.83fc,@>83fc
        mov   @run.tibasic.83fe,@>83fe

        ;-------------------------------------------------------
        ; Run TI Basic in GPL Interpreter
        ;-------------------------------------------------------
        lwpi  >83e0
        li    r1,>216f              ; Entrypoint for GPL TI Basic interpreter
        movb  r1,@grmwa             ; \
        swpb  r1                    ; | Set GPL address
        movb  r1,@grmwa             ; / 
        nop
        b     @>70                  ; Start GPL interpreter

run.tibasic.83d4:
        data  >e0d5
run.tibasic.83fa:
        data  >9800
run.tibasic.83fc:        
        data  >0108
run.tibasic.83fe:
        data  >8c02        
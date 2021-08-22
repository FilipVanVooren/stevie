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
        ; Reset SAMS to default pages
        ;-------------------------------------------------------        
        bl    @f18rst               ; Reset and lock the F18A

        bl    @vidtab               ; Load video mode table into VDP
              data graph1           ; Equate selected video mode table

        bl    @ldfnt
              data >0900,fnopt3     ; Load font (upper & lower case)
      
        bl    @filv
              data >0380,>f0,32*24  ; Load color table

        ;clr  @bank0.rom            ; Activate bank 0

        bl    @cpu.scrpad.restore     


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

run.tibasic.83fa:
        data  >9800
run.tibasic.83fc:        
        data  >0001
run.tibasic.83fe:
        data  >8c02        
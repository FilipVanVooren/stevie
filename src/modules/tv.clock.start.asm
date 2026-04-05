* FILE......: tv.clock.start.asm
* Purpose...: Setup clock reading task

***************************************************************
* tv.clock.start
* Setup clock reading task
***************************************************************
* bl  @tv.clock.start
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
********|*****|*********************|**************************
tv.clock.start:
        .pushregs 2                 ; Push registers and return address on stack
        ;------------------------------------------------------
        ; Reset clock
        ;------------------------------------------------------
        bl    @film                 ; Clear clock structure
              data  fh.clock.datetime,>00,19

        seto  @tv.clock.state        ; Set clock display flag              
        ;------------------------------------------------------
        ; Start clock reading task
        ;------------------------------------------------------
        bl    @mkslot               ; Setup Task Scheduler slots         
              data >017f,task.clock ; \ Task 1 - Read clock device
              data eol              ; /
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
tv.clock.start.exit:
        .popregs 2                  ; Pop registers and return to caller
* FILE......: task.oneshot.asm
* Purpose...: Trigger one-shot task

***************************************************************
* Task - One-shot
***************************************************************

task.oneshot:
        dect  stack
        mov   tmp0,*stack            ; Push tmp0
        mov   @tv.task.oneshot,tmp0  ; Get pointer to one-shot task
        jeq   task.oneshot.exit
        bl    *tmp0                  ; Execute one-shot task
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
task.oneshot.exit:
        mov   *stack+,tmp0           ; Pop tmp0
        b     @slotok                ; Exit task
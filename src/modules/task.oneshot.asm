task.oneshot:
        mov   @tv.task.oneshot,tmp0  ; Get pointer to one-shot task
        jeq   task.oneshot.exit

        bl    *tmp0                  ; Execute one-shot task
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
task.oneshot.exit:
        b     @slotok                ; Exit task
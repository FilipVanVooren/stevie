* FILE......: edkey.cmdb.shortcuts.asm
* Purpose...: Actions in shortcuts dialog

*---------------------------------------------------------------
* Toggle editor AutoInsert mode
*---------------------------------------------------------------
edkey.action.cmdb.autoinsert:
        bl    @hchar
              byte 0,52,32,20
              data EOL              ; Erase any previous message

        inv   @edb.autoinsert       ; Toggle AutoInsert mode
        jeq   !
        ;-------------------------------------------------------
        ; Show message 'AutoInsert on'
        ;-------------------------------------------------------
        bl    @putat
              byte 0,52
              data txt.autoins.on   ; AutoInsert on
        jmp   edkey.action.cmdb.autoinsert.oneshot
        ;-------------------------------------------------------
        ; Show message 'AutoInsert off'
        ;-------------------------------------------------------
!       bl    @putat
              byte 0,52
              data txt.autoins.off   ; AutoInsert off
        ;-------------------------------------------------------
        ; Setup one shot task for removing overlay message
        ;-------------------------------------------------------
edkey.action.cmdb.autoinsert.oneshot:
        li    tmp0,pane.topline.oneshot.clearmsg
        mov   tmp0,@tv.task.oneshot

        bl    @rsslot               ; \ Reset loop counter slot 3
              data 3                ; / for getting consistent delay
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.autoinsert.exit:
        bl    @cmdb.dialog.close    ; Close dialog
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

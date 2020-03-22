* FILE......: edkey.asm
* Purpose...: Initialisation & setup key actions





*---------------------------------------------------------------
* Movement keys
*---------------------------------------------------------------
key_left      equ >0800                      ; fctn + s
key_right     equ >0900                      ; fctn + d
key_up        equ >0b00                      ; fctn + e
key_down      equ >0a00                      ; fctn + x
key_home      equ >8100                      ; ctrl + a
key_end       equ >8600                      ; ctrl + f 
key_pword     equ >9300                      ; ctrl + s
key_nword     equ >8400                      ; ctrl + d
key_ppage     equ >8500                      ; ctrl + e
key_npage     equ >9800                      ; ctrl + x
key_tpage     equ >9400                      ; ctrl + t
key_bpage     equ >8200                      ; ctrl + b
*---------------------------------------------------------------
* Modifier keys
*---------------------------------------------------------------
key_enter       equ >0d00                    ; enter
key_del_char    equ >0300                    ; fctn + 1 
key_del_line    equ >0700                    ; fctn + 3
key_del_eol     equ >8b00                    ; ctrl + k
key_ins_char    equ >0400                    ; fctn + 2
key_ins_onoff   equ >b900                    ; fctn + .
key_ins_line    equ >0e00                    ; fctn + 5
key_quit1       equ >0500                    ; fctn + +
key_quit2       equ >9d00                    ; ctrl + +
*---------------------------------------------------------------
* File buffer keys
*---------------------------------------------------------------
key_buf0        equ >b000                    ; ctrl + 0
key_buf1        equ >b100                    ; ctrl + 1
key_buf2        equ >b200                    ; ctrl + 2
key_buf3        equ >b300                    ; ctrl + 3
key_buf4        equ >b400                    ; ctrl + 4
key_buf5        equ >b500                    ; ctrl + 5
key_buf6        equ >b600                    ; ctrl + 6
key_buf7        equ >b700                    ; ctrl + 7
key_buf8        equ >9e00                    ; ctrl + 8
key_buf9        equ >9f00                    ; ctrl + 9
*---------------------------------------------------------------
* Misc keys
*---------------------------------------------------------------
key_cmdb_tog    equ >0f00                    ; fctn + 9
key_cycle       equ >9a00                    ; ctrl + z


*---------------------------------------------------------------
* Action keys mapping <-> actions table
*---------------------------------------------------------------
keymap_actions
        ;-------------------------------------------------------
        ; Movement keys
        ;-------------------------------------------------------
        data  key_enter,edkey.action.enter          ; New line
        data  key_left,edkey.action.left            ; Move cursor left
        data  key_right,edkey.action.right          ; Move cursor right
        data  key_up,edkey.action.up                ; Move cursor up
        data  key_down,edkey.action.down            ; Move cursor down
        data  key_home,edkey.action.home            ; Move cursor to line begin
        data  key_end,edkey.action.end              ; Move cursor to line end
        data  key_pword,edkey.action.pword          ; Move cursor previous word
        data  key_nword,edkey.action.nword          ; Move cursor next word
        data  key_ppage,edkey.action.ppage          ; Move cursor previous page
        data  key_npage,edkey.action.npage          ; Move cursor next page
        data  key_tpage,edkey.action.top            ; Move cursor to file top
        data  key_bpage,edkey.action.bot            ; Move cursor to file bottom
        ;-------------------------------------------------------
        ; Modifier keys - Delete
        ;-------------------------------------------------------
        data  key_del_char,edkey.action.del_char    ; Delete character
        data  key_del_eol,edkey.action.del_eol      ; Delete until end of line
        data  key_del_line,edkey.action.del_line    ; Delete current line
        ;-------------------------------------------------------
        ; Modifier keys - Insert
        ;-------------------------------------------------------
        data  key_ins_char,edkey.action.ins_char.ws ; Insert whitespace
        data  key_ins_onoff,edkey.action.ins_onoff  ; Insert mode on/off
        data  key_ins_line,edkey.action.ins_line    ; Insert new line
        ;-------------------------------------------------------
        ; Other action keys
        ;-------------------------------------------------------
        data  key_quit1,edkey.action.quit           ; Quit TiVi
        data  key_cmdb_tog,edkey.action.cmdb.toggle ; Toggle command buffer pane
        data  key_cycle,edkey.action.color.cycle    ; Cycle color scheme                                  
        ;-------------------------------------------------------
        ; Editor/File buffer keys
        ;-------------------------------------------------------
        data  key_buf0,edkey.action.buffer0
        data  key_buf1,edkey.action.buffer1
        data  key_buf2,edkey.action.buffer2
        data  key_buf3,edkey.action.buffer3
        data  key_buf4,edkey.action.buffer4
        data  key_buf5,edkey.action.buffer5
        data  key_buf6,edkey.action.buffer6
        data  key_buf7,edkey.action.buffer7
        data  key_buf8,edkey.action.buffer8
        data  key_buf9,edkey.action.buffer9
        data  >ffff                                 ; EOL



****************************************************************
* Editor - Process key
****************************************************************
edkey   mov   @waux1,tmp1           ; Get key value
        andi  tmp1,>ff00            ; Get rid of LSB

        li    tmp2,keymap_actions   ; Load keyboard map
        seto  tmp3                  ; EOL marker
        ;-------------------------------------------------------
        ; Iterate over keyboard map for matching key
        ;-------------------------------------------------------
edkey.check_next_key:
        c     *tmp2,tmp3            ; EOL reached ?
        jeq   edkey.do_action.set   ; Yes, so go add letter

        c     tmp1,*tmp2+           ; Key matched?
        jeq   edkey.do_action       ; Yes, do action
        inct  tmp2                  ; No, skip action
        jmp   edkey.check_next_key  ; Next key

edkey.do_action:
        mov  *tmp2,tmp2             ; Get action address
        b    *tmp2                  ; Process key action
edkey.do_action.set:
        b    @edkey.action.char     ; Add character to buffer        
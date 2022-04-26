* FILE......: tib.uncrunch.prep.asm
* Purpose...: Uncrunch TI Basic program to editor buffer


***************************************************************
* tib.uncrunch
* Uncrunch TI Basic program to editor buffer
***************************************************************
* bl   @tib.uncrunch
*--------------------------------------------------------------
* INPUT
* @parm1 = TI Basic session to uncrunch (1-5)
*
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2, tmp3, tmp4
********|*****|*********************|**************************
tib.uncrunch:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;------------------------------------------------------
        ; Set indicator
        ;------------------------------------------------------
        dect  stack
        mov   @parm1,*stack         ; Push @parm1

        bl    @fm.newfile           ; \ Clear editor buffer 
                                    ; / (destroys parm1)
        ;------------------------------------------------------
        ; Determine filename of TI Basic program
        ;------------------------------------------------------
tib.uncrunch.get.fname:        
        bl    @sams.page.set        ; Set SAMS page
              data >000f,>f000      ; \ i  p1  = SAMS page number
                                    ; / i  p2  = Memory map address

        mov   @>ff00,tmp0           ; Is the filename set?
        jeq   tib.uncrunch.skip.fname
                                    ; No filename set, show default
        ;------------------------------------------------------
        ; Copy filename
        ;------------------------------------------------------
        bl    @cpym2m
              data >ff00,edb.filename,80
                                    ; \ Copy TI Basic filename
                                    ; | i  p1 = Source address
                                    ; | i  p2 = Target address
                                    ; / i  p3 = Number of bytes to copy

        li    tmp0,edb.filename     ; Set pointer to filename
        mov   tmp0,@edb.filename.ptr
        ;------------------------------------------------------
        ; Restore SAMS page
        ;------------------------------------------------------
        mov   @tv.sams.f000,tmp0    ; Get SAMS page number
        li    tmp1,>f000            ; Map SAMS page to >f000-ffff

        bl    @xsams.page.set       ; Set SAMS page
                                    ; \ i  tmp0  = SAMS page number
                                    ; / i  tmp1  = Memory map address

        jmp   tib.uncrunch.rest     ; Skip to rest
        ;------------------------------------------------------
        ; Skip TI Basic filename, it's empty
        ;------------------------------------------------------
tib.uncrunch.skip.fname:
        mov   *stack,tmp0           ; Get TI Basic session
        sla   tmp0,1                ; Align to word boundary
        mov   @data.filename.ptr(tmp0),@edb.filename.ptr
        ;------------------------------------------------------
        ; Set color combination, remove shortcuts, shpw message        
        ;------------------------------------------------------
tib.uncrunch.rest:
        mov   @tv.busycolor,@parm1  ; Get busy color
        bl    @pane.action.colorscheme.statlines
                                    ; Set color combination for status line
                                    ; \ i  @parm1 = Color combination
                                    ; /

        mov   *stack+,@parm1        ; Pop @parm1

        bl    @hchar
              byte pane.botrow,0,32,55
              data eol              ; Remove shortcuts

        bl    @putat
              byte pane.botrow,0
              data txt.uncrunching  ; Show expansion message
        ;------------------------------------------------------
        ; Prepare for uncrunching
        ;------------------------------------------------------
        bl    @tib.uncrunch.prepare ; Prepare for uncrunching TI Basic program
                                    ; \ i  @parm1 = TI Basic session to uncrunch
                                    ; /
        ;------------------------------------------------------
        ; Uncrunch TI Basic program
        ;------------------------------------------------------
        bl    @tib.uncrunch.prg     ; Uncrunch TI Basic program
        ;------------------------------------------------------
        ; Prepare for exit
        ;------------------------------------------------------
        mov   @tv.sams.f000,tmp0    ; Get SAMS page number
        li    tmp1,>f000            ; Map SAMS page to >f000-ffff

        bl    @xsams.page.set       ; Set SAMS page
                                    ; \ i  tmp0  = SAMS page number
                                    ; / i  tmp1  = Memory map address
        ;------------------------------------------------------
        ; Close dialog and refresh frame buffer
        ;------------------------------------------------------
        bl    @cmdb.dialog.close    ; Close dialog

        clr   @parm1                ; Goto line 1

        bl    @fb.refresh           ; \ Refresh frame buffer
                                    ; | i  @parm1 = Line to start with
                                    ; /             (becomes @fb.topline)

        clr   @fb.row               ; Frame buffer line 0
        clr   @fb.column            ; Frame buffer column 0
        clr   @wyx                  ; Position VDP cursor
        bl    @fb.calc_pointer      ; Calculate position in frame buffer

        bl    @edb.line.getlength2  ; \ Get length current line
                                    ; | i  @fb.row        = Row in frame buffer
                                    ; / o  @fb.row.length = Length of row
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
tib.uncrunch.exit:
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return


data.filename.ptr:
        data  txt.newfile,txt.tib1,txt.tib2,txt.tib3,txt.tib4,txt.tib5
* FILE......: fg99.run.asm
* Purpose...: Run FinalGROM cartridge image


***************************************************************
* fg99.run
* Run FinalGROM cartridge image
***************************************************************
* bl   @fg99.run
*--------------------------------------------------------------
* INPUT
* @tv.fg99.img.ptr = Pointer to cartridge image entry
*
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* r1 in GPL WS, tmp0, tmp1, tmp2, r12
*--------------------------------------------------------------
* Remarks
* Based on tib.run
********|*****|*********************|**************************
fg99.run:
        ;-------------------------------------------------------
        ; Put VDP in TI Basic compatible mode (32x24)
        ;-------------------------------------------------------
        bl    @f18rst               ; Reset and lock the F18A

        bl    @vidtab               ; Load video mode table into VDP
              data tibasic.32x24    ; Equate selected video mode table

        bl    @scroff               ; Turn off screen
        ;-------------------------------------------------------
        ; Load FG99 cartridge, but do not start cartridge yet
        ;------------------------------------------------------- 
        mov   @tv.fg99.img.ptr,tmp0 ; Get pointer to cartridge image
        bl    @xfg99                ; Run FinalGROM cartridge image
                                    ; \ i tmp0 = Pointer to cartridge image
                                    ; /
        ;-------------------------------------------------------
        ; Turn SAMS mapper off and exit to monitor
        ;-------------------------------------------------------
        li    r12,>1e00             ; SAMS CRU address
        sbz   1                     ; Disable SAMS mapper
                                    ; \ We keep the mapper off while
                                    ; | running TI Basic or other external
                                    ; / programs.      

        blwp @0                     ; Return to monitor

* FILE......: jbasic.support.asm
* Purpose...: Stevie Editor - Jackalope Basic support 

***************************************************************
* jbasic.start
* Start Jackalope Basic intepreter
***************************************************************
* b   @jbasic.start
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* -
*--------------------------------------------------------------
* Notes
* Main entry point for stevie editor
********|*****|*********************|**************************
jbasic.start:
              ;------------------------------------------------------
              ; Start Jackalope Basic
              ;------------------------------------------------------
              li    r12,>1e00             ; \ Disable SAMS mapper (transparent mode)
              sbz   1                     ; / >02 >03 >0a >0b >0c >0d >0e >0f
              clr   @bank9.rom            ; Activate bank 9 "Jackalope Basic"
              ;------------------------------------------------------
              ; Returning from Jackalope Basic
              ;------------------------------------------------------
              aorg  >6012                 ; We get here from SYS 24590 in bank 9
              jmp  jbasic.return          ; Return to Stevie


***************************************************************
* jbasic.return
* Return from Jackalope Basic to Stevie
***************************************************************
* jmp   jbasic.return
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* none
*--------------------------------------------------------------
* REMARKS
* We return here from SYS 24590 (>600e) in bank 9
********|*****|*********************|**************************
jbasic.return:
        li    r12,>1e00             ; \ Enable SAMS mapper again with        
        sbo   1                     ; | sams layout table
                                    ; / 

       
       aorg  kickstart.code1 - 6   ; >6030 - 6
       clr   @bank0.rom            ; Activate bank 1 "James" ROM
********************************************************************************
*   Stevie
*   Modern Programming Editor for the Texas Instruments TI-99/4a Home Computer.
*   Copyright (C) 2018-2025 / Filip van Vooren
*
*   This program is free software: you can redistribute it and/or modify
*   it under the terms of the GNU General Public License as published by
*   the Free Software Foundation, either version 3 of the License, or
*   (at your option) any later version.
*
*   This program is distributed in the hope that it will be useful,
*   but WITHOUT ANY WARRANTY; without even the implied warranty of
*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*   GNU General Public License for more details.
*
*   You should have received a copy of the GNU General Public License
*   along with this program.  If not, see <https://www.gnu.org/licenses/>.
********************************************************************************
* File: stevie_b9.asm
*
* Bank 9 "Jackalope Basic"
* Jackalope Basic by Alex Johnson (compuwiz@gmail.com)
********************************************************************************
        aorg  >6000
        save  >6000,>8000           ; Save bank

        aorg  >600a
        b     @INIT                 ; Start Jackalope Basic
        aorg  >600e
        clr   @bank8.rom            ; Return to Jackalope integration layer
********************************************************************

***************************************************************
* Step 1: Include Jackalope Basic
********|*****|*********************|**************************
        copy  "equ.romseq.asm"      ; Get ROM bank order
        copy  "jbasic.asm"          ; Jackalope Basic by Alex Johnson
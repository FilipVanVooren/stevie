* FILE......: data.devices.asm
* Purpose...: Device name strings

***************************************************************
*                     Device names
********|*****|*********************|**************************
              even
def.dsk1      stri 'DSK1.'
def.dsk2      stri 'DSK2.'
def.dsk3      stri 'DSK3.'
def.dsk4      stri 'DSK4.'
def.dsk5      stri 'DSK5.'
def.dsk6      stri 'DSK6.'
def.dsk7      stri 'DSK7.'
def.dsk8      stri 'DSK8.'
def.dsk9      stri 'DSK9.'
def.tipi      stri 'TIPI.'
def.scs1      stri 'SCS1.'
def.scs2      stri 'SCS2.'
def.scs3      stri 'SCS3.'
def.ide1      stri 'IDE1.'
def.ide2      stri 'IDE2.'
def.ide3      stri 'IDE3.'
def.clock     stri 'PI.CLOCK'

*---------------------------------------------------------------
* List with device names
*-------------|---------------------|---------------------------
device.list:
        even
        ;-------------------------------------------------------
        ; Pointers to device strings
        ;-------------------------------------------------------
        data  def.dsk1, def.dsk2, def.dsk3, def.dsk4, def.dsk5
        data  def.dsk6, def.dsk7, def.dsk8, def.dsk9, def.tipi
        data  def.scs1, def.scs2, def.scs3, def.ide1, def.ide2
        data  def.ide3
        ;-------------------------------------------------------
        ; End of list
        ;-------------------------------------------------------
        data  EOL             ; EOL                      

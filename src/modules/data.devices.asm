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
def.dska      stri 'DSKA.'
def.dskb      stri 'DSKB.'
def.dskc      stri 'DSKC.'
def.dske      stri 'DSKE.'
def.dskf      stri 'DSKF.'


*---------------------------------------------------------------
* List with device names
*-------------|---------------------|---------------------------
device.list:
        even
        ;-------------------------------------------------------
        ; Pointers to device strings
        ;-------------------------------------------------------
        data  def.dsk1, def.dsk2, def.dsk3, def.dsk4, def.dsk5
        data  def.dsk6, def.dsk7, def.dsk8, def.dsk9
        data  def.dska, def.dskb, def.dskc, def.dske, def.dskf
        ;-------------------------------------------------------
        ; End of list
        ;-------------------------------------------------------
        data  EOL             ; EOL                      

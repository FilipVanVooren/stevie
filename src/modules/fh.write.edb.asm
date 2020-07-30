* FILE......: fh.write.edb.asm
* Purpose...: File write module

*//////////////////////////////////////////////////////////////
*               Write editor buffer to file
*//////////////////////////////////////////////////////////////


***************************************************************
* fh.file.write.edb
* Write editor buffer to file
***************************************************************
*  bl   @fh.file.write.edb
*--------------------------------------------------------------
* INPUT
* parm1 = Pointer to length-prefixed file descriptor
* parm2 = Pointer to callback function "Before Open file"
* parm3 = Pointer to callback function "Write line to file"
* parm4 = Pointer to callback function "Close file"
* parm5 = Pointer to callback function "File I/O error"
*--------------------------------------------------------------
* OUTPUT
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2
********|*****|*********************|**************************
fh.file.write.edb:

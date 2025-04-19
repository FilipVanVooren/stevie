* FILE......: data.colorstable.asm
* Purpose...: Stevie Editor - Color schemes table

***************************************************************
* Stevie color schemes table
*--------------------------------------------------------------
* ;
* ; Word 0
* ; A  MSB  high-nibble    Foreground color text line in frame buffer
* ; B  MSB  low-nibble     Background color text line in frame buffer
* ; C  LSB  high-nibble    Foreground color top line
* ; D  LSB  low-nibble     Background color top line
*
* ; Word 1
* ; E  MSB  high-nibble    Foreground color cmdb pane
* ; F  MSB  low-nibble     Background color cmdb pane
* ; G  LSB  high-nibble    Cursor foreground color cmdb pane
* ; H  LSB  low-nibble     Cursor foreground color frame buffer
* ;
* ; Word 2
* ; I  MSB  high-nibble    Foreground color busy top/bottom line
* ; J  MSB  low-nibble     Background color busy top/bottom line
* ; K  LSB  high-nibble    Foreground color marked line in frame buffer
* ; L  LSB  low-nibble     Background color marked line in frame buffer
*
* ; Word 3
* ; M  MSB  high-nibble    Foreground color command buffer header line
* ; N  MSB  low-nibble     Background color command buffer header line
* ; O  LSB  high-nibble    Foreground color line+column indicator frame buffer
* ; P  LSB  low-nibble     Foreground color ruler frame buffer
*
* ; Word 4
* ; Q  MSB  high-nibble    Foreground color bottom line
* ; R  LSB  low-nibble     Background color bottom line
* ; S  MSB  high-nibble   
* ; T  LSB  low-nibble     
*
* ; Colors
* ; 0  Transparant
* ; 1  black      
* ; 2  Green      
* ; 3  Light Green
* ; 4  Blue       
* ; 5  Light Blue 
* ; 6  Dark Red   
* ; 7  Cyan       
* ; 8  Red
* ; 9  Light Red
* ; A  Yellow
* ; B  Light Yellow
* ; C  Dark Green
* ; D  Magenta
* ; E  Grey
* ; F  White
*--------------------------------------------------------------
tv.colorscheme.table:
        ;      0     2     4     6     8
        ;      ABCD  EFGH  IJKL  MNOP  QRST ; 
        data  >f417,>f171,>1b1f,>7111,>0000 ; 1  White on blue with cyan (1)
        data  >21f0,>21ff,>f112,>21ff,>0000 ; 2  Dark green on black
        data  >a11a,>f0ff,>1f1a,>f1ff,>0000 ; 3  Dark yellow on black
        data  >1e1e,>1e11,>1ee1,>1e11,>0000 ; 4  Black on grey
        data  >f417,>7171,>1b1f,>7111,>0000 ; 5  White on blue with cyan (2)
        data  >1313,>1311,>1331,>1311,>0000 ; 6  Black on light green
        data  >1771,>1011,>0171,>1711,>0000 ; 7  Black on cyan        
        data  >2112,>f0ff,>1f12,>f1f6,>0000 ; 8  Dark green on black         
        data  >1ff1,>1011,>f1f1,>1f11,>0000 ; 9  Black on white
        data  >1af1,>a111,>1f1f,>f11f,>0000 ; 10 Black on dark yellow
        data  >1919,>1911,>1991,>1911,>0000 ; 11 Black on light red
        data  >f41f,>f1f1,>1b1f,>7111,>0000 ; 12  White on blue with cyan (3)
        even

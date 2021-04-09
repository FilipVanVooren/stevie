* FILE......: rom.vectors.bank0.asm
* Purpose...: Bank 0 vectors for trampoline function
        
        aorg  >7f9c

*--------------------------------------------------------------
* Vector table for trampoline functions
*--------------------------------------------------------------
vec.1   data  vdp.patterns.dump     ;   
vec.2   data  cpu.crash             ;
vec.3   data  cpu.crash             ; 
vec.4   data  cpu.crash             ; 
vec.5   data  cpu.crash             ; 
vec.6   data  cpu.crash             ; 
vec.7   data  cpu.crash             ; 
vec.8   data  cpu.crash             ; 
vec.9   data  cpu.crash             ; 
vec.10  data  cpu.crash             ; 
vec.11  data  cpu.crash             ; 
vec.12  data  cpu.crash             ; 
vec.13  data  cpu.crash             ; 
vec.14  data  cpu.crash             ; 
vec.15  data  cpu.crash             ; 
vec.16  data  cpu.crash             ; 
vec.17  data  cpu.crash             ; 
vec.18  data  cpu.crash             ; 
vec.19  data  cpu.crash             ; 
vec.20  data  cpu.crash             ; 
vec.21  data  cpu.crash             ; 
vec.22  data  cpu.crash             ; 
vec.23  data  cpu.crash             ; 
vec.24  data  cpu.crash             ; 
vec.25  data  cpu.crash             ; 
vec.26  data  cpu.crash             ; 
vec.27  data  cpu.crash             ; 
vec.28  data  cpu.crash             ; 
vec.29  data  cpu.crash             ; 
vec.30  data  cpu.crash             ; 
vec.31  data  cpu.crash             ; 
vec.32  data  cpu.crash             ; 

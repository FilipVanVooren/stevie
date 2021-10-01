# SAMS banks

## Introduction

Stevie requires a 1MB SAMS card to run.  

Depending on the mode currently active, SAMS banks are constantly being paged-in
and out. This is for the most handled via the subroutines in the spectra2 module 
``/modules/cpu_sams_support.asm``

There are some additional higher-level modules in stevie for dealing with SAMS
banks.


## Editor mode

In editor mode -that is when not calling any external program or TI basic
session-, SAMS banks are configured as follows:

* banks 20-2f are reserved for the index and are paged-in at >b000.
  This allows for a maximum of 65635 lines to be indexed.

  |  >2000 | >3000 | >a000 | >b000  | >c000  | >d000 | >e000 | >f000 |  
  |--------|-------|-------|--------|--------|-------|-------|-------|  
  |   >02  |  >03  |  >0a  | >20-2f | >40-ff |  >0d  |  >0e  |  >0f  |  

  Note that during index reorganization (e.g. when inserting/removing a line),
  sequential index pages are aditionally paged-in at >c000, >d000, >e000, >f000.
  That is to form a continuous index region at >b000 to >ffff. 

  For details see stevie module ``/modules/idx.asm``  
  
  Example:

  |  >2000 | >3000 | >a000 | >b000  | >c000  | >d000 | >e000 | >f000 |  
  |--------|-------|-------|--------|--------|-------|-------|-------|  
  |   >02  |  >03  |  >0a  |   >20  |  >21   |  >22  |  >23  |  >24  |  

```
        bl    @_idx.sams.mapcolumn.on
                                    ; Index in continuous memory region    
                                    ; b000 - ffff (5 SAMS pages)            
```


* banks 40-ff are reserved for the editor buffer itself. The editor follows a
  copy-on-write approach. When the text in a line is updated and
  the content does not fit in the existing space reserved for that line, a new
  line is added to the end of the editor buffer and the line pointer in
  the index is changed accordingly.

  |  >2000 | >3000 | >a000 | >b000  | >c000  | >d000 | >e000 | >f000 |  
  |--------|-------|-------|--------|--------|-------|-------|-------|  
  |   >02  |  >03  |  >0a  | >20-2f | >40-ff |  >0d  |  >0e  |  >0f  |  


## External program

Before calling an external program or if returning from an external program, 
SAMS banks are configured as follows:

* banks 30-33 are paged-in for storing or retrieving a copy of the 16K of VDP 
  memory used by Stevie.  

|  >2000 | >3000 | >a000 | >b000  | >c000  | >d000 | >e000 | >f000 |  
|--------|-------|-------|--------|--------|-------|-------|-------|  
|   >02  |  >03  |  >0a  |   >30  |   >31  |  >32  |  >33  |  >0f  |  

```
    bl  @sams.layout          
        data mem.sams.external ; Load SAMS page layout for calling an
                               ; external program.
```

## TI Basic session

Each TI Basic session has its own set of SAMS banks assigned exclusively.
By doing so there's a proper isolation


### Session 1

|  >2000 | >3000 | >a000 | >b000  | >c000  | >d000 | >e000 | >f000 |  
|--------|-------|-------|--------|--------|-------|-------|-------|  
|   >02  |  >03  |  >0a  |   >04  |   >05  |  >06  |  >07  |  >08  |  


```
    bl @sams.layout          
       data mem.sams.tibasic1 ; Load SAMS page layout for TI Basic session 1
```
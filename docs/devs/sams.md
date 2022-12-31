# SAMS banks

## Introduction

stevie requires a 1MB SAMS card to run.

Depending on the mode currently active, SAMS banks are paged-in and out.
This is for the most handled via the subroutines in the spectra2 module
``/modules/cpu_sams_support.asm``

There are some additional high-level modules in stevie for dealing with SAMS
banks.

* ``/modules/mem_sams_setup.asm``
* ``/modules/mem_sams_layout.asm``

There's also boot-specific SAMS setup code in ``stevie_b0.asm``.


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


* banks 40-XX are reserved for the editor buffer itself. The editor follows a
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

When calling TI Basic or when exiting Stevie, the banks are switched to
the default order. This is for assuring external programs behave as
expected. With default order the same bank mapping is meant as when
powering on the SAMS card.

### SAMS layout while a TI Basic session is running

|  >2000 | >3000 | >a000 | >b000  | >c000  | >d000 | >e000 | >f000 |
|--------|-------|-------|--------|--------|-------|-------|-------|
|   >02  |  >03  |  >0a  |   >0b  |   >0c  |  >0d  |  >0e  |  >0f  |



## Dumps of TI Basic sessions

The 16K VRAM, 32K memory expansion and scratchpad memory used by a TI Basic
session is dumped to SAMS upon exit from the TI Basic session.
The idea behind being that a dumped TI Basic session can be resumed later.
There is space reserved for dumping up to 5 parallel TI Basic sessions.

The SAMS pages used for storing each dump are hardcoded and defined in the file
'data.sams.layout.sams'. Note that the dumps are stored in reversed order at the
end of the 1MB SAMS address page range, going downwards.
With this bank order there's more space for editor buffer(s) and indexes 
if few TI Basic sessions get dumped.

### SAMS pages

| Session    | VRAM  | 32K   | Scratchpad |
|------------|-------|-------|------------|
| TI Basic 1 | fb-fe | xx-xx | ff         |
| TI Basic 2 | f6-f9 | xx-xx | ff         |
| TI Basic 3 | f1-f4 | xx-xx | ff         |
| TI Basic 4 | ec-ef | xx-xx | ff         |
| TI Basic 5 | e7-ea | xx-xx | ff         |

### Scratchpad dumps in SAMS page >ff

The scratchpads of the 5 TI Basic sessions are always dumped to the page >ff,
but to different memory ranges within that page.

| Address      | Scratchpad dumps     |
|--------------|----------------------|
| >f000 - f0ff | Temporary copy       |
| >f100 - f1ff | TI Basic session 1   |
| >f200 - f2ff | TI Basic session 2   |
| >f300 - f3ff | TI Basic session 3   |
| >f400 - f4ff | TI Basic session 4   |
| >f500 - f5ff | TI Basic session 5   |


### Auxiliary stuff in SAMS page >ff

Each of the TI Basic sessions dump some auxiliary stuff to the page >ff,
but to different memory ranges within that page, e.g. TI Basic program file name
captured by Stevie helper ISR in TI Basic.

| Address      | Auxiliary memory     |
|--------------|----------------------|
| >f600 - f6ff | TI Basic session 1   |
| >f700 - f7ff | TI Basic session 2   |
| >f800 - f8ff | TI Basic session 3   |
| >f900 - f9ff | TI Basic session 4   |
| >fa00 - faff | TI Basic session 5   |


## Locked pages >02 and >03

|  >2000 | >3000 | 
|--------|-------|
|   >02  |  >03  |

The memory regions ``>2000 - >2fff`` and ``>3000 - >3fff`` contains spectra2  
modules, Stevie core memory and Stevie resident modules. These memory regions   
are locked to pages ``>02`` and ``>03``. This is required so that the mapper can
be turned off and the that resides there can still be executed.

This is important for memory setup when chaining to another FinalGROM cartridge.

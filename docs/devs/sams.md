# SAMS banks

## Introduction

Stevie requires a 1MB SAMS card to run.

Depending on the mode currently active, SAMS banks are constantly being paged-in
and out.
This is for the most handled via the subroutines in the spectra2 module
``/modules/cpu_sams_support.asm``

There are some additional high-level modules in stevie for dealing with SAMS
banks.

* ``/modules/mem.asm``

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

When running TI Basic or when exiting Stevie, the banks are switched to
the default order. This is for assuring external programs behave as
expected. With default order the same bank mapping is meant as when
powering on the SAMS card.

### SAMS layout while a TI Basic session is running

|  >2000 | >3000 | >a000 | >b000  | >c000  | >d000 | >e000 | >f000 |
|--------|-------|-------|--------|--------|-------|-------|-------|
|   >02  |  >03  |  >0a  |   >0b  |   >0c  |  >0d  |  >0e  |  >0f  |



## Dumps of TI Basic sessions

The 16K VRAM, 32K memory expansion and scratchpad memory used by a TI Basic session
is dumped to SAMS upon exit from the TI Basic session. The idea behind being that
a dumped TI Basic session can be resumed at a later time.
There is space reserved for dumping up to 5 parallel TI Basic sessions.

The SAMS pages used for storing each dump are hardcoded and defined in the file
'data.sams.layout.sams'. Note that the dumps are stored in reversed order at the
end of the 1MB SAMS address page range, going downwards. with this bank
order there's more space for the file editor buffer(s) and indexes if few
TI Basic sessions get dumped.

### SAMS pages

VRAM/32K/scratch session 1: SAMS pages fb-fe, xx-xx, ff
VRAM/32K/scratch session 2: SAMS pages f6-f9, xx-xx, ff
VRAM/32K/scratch session 3: SAMS pages f1-f4, xx-xx, ff
VRAM/32K/scratch session 4: SAMS pages ec-ef, xx-xx, ff
VRAM/32K/scratch session 5: SAMS pages e7-ea, xx-xx, ff

### Scratchpad dump

The scratchpad of the 5 TI Basic sessions is always dumped to the page >ff, but
to different memory ranges within that page

>f000 - f0ff  Work copy for save (hardcoded, then double copy to destination)
>f100 - f1ff  Scratchpad TI Basic session 1
>f200 - f2ff  Scratchpad TI Basic session 2
>f300 - f3ff  Scratchpad TI Basic session 3
>f400 - f4ff  Scratchpad TI Basic session 4
>f500 - f5ff  Scratchpad TI Basic session 5

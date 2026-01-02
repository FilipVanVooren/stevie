# Memory map

## CPU RAM (SAMS MEMEXP 32K)

The following table reflects the CPU-side RAM layout derived from `equ.asm`.  
Sizes are approximate where structures contain many small fields; see `equ.asm` 
for exact offsets and field names.

| Address    |  SAMS  | Size | Purpose                                         |
|------------|--------|------|-------------------------------------------------|
| >2000-2fff |  #02   | 4096 | Resident spectra2 and Stevie modules            |
| >3000-3fff |  #03   | 4096 | Resident spectra2 and Stevie modules            |
| >a000-a0ff |  #0a   |  256 | Stevie core 1 RAM                               |
|            |        |      | >a006-a016 : parm1..parm9 (input parameters)    |
|            |        |      | >a018-a024 : outparm1..outparm7 (output params) |
|            |        |      | >a026-a02b : keyboard flags / keycodes          |
|            |        |      | >a02c-a031 : unpacked/packed uint16 workbuffers |
|            |        |      | >a034      : trampoline vector                  |
|            |        |      | >a036-a063 : free / temporary workspace         |
|            |        |      | >a064-a0b3 : timers (80 bytes)                  |
|            |        |      | >a0b4-a0d3 : TI-Basic session management area   |
|            |        |      | >a0d4-a0f9 : TI-Basic temporary/free area       |
| >a100-a1ff |  #0a   |  256 | Stevie core 2 RAM (RAM workbuffer at >a100)     |
| >a200-a2ff |  #0a   |  256 | Shared Stevie editor structure (`tv.struct`)    |
|            |        |      | `tv.sams.*`, color scheme, cursor, pane focus,  |
|            |        |      | pointers to font, error msg, device path, ...   |
| >a300-a3ff |  #0a   |  256 | Frame buffer structure (`fb.struct`)            |
|            |        |      | framebuffer pointers, current row/col, ruler,   |
|            |        |      | colorize flags, cursor toggle, dirty flags, ... |
| >a400-a4ff |  #0a   |  256 | File handle structures (`fh.struct`)            |
|            |        |      | `dsrlnk` workspace, PAB pointers, I/O status,   |
|            |        |      | file memory buffer, callbacks, EA5 trans. state |
| >a500-a5ff |  #0a   |  256 | Editor buffer structure (`edb.struct`)          |
|            |        |      | buffer pointers, index ptr, lines count,        |
|            |        |      | insert/autoinsert flags, block marks, filename, |
|            |        |      | search string buffer and search state           |
| >a600-a6ff |  #0a   |  256 | Index structure (`idx.struct`)                  |
| >a700-a7ff |  #0a   |  256 | Command buffer structure (`cmdb.struct`)        |
|            |        |      | history buffer pointer, pane sizing, dialog ids,|
|            |        |      | current command buffer and pane header buffers  |
| >a800-a8ff |  #0a   |  256 | Stevie value stack (SP2 user stack area)        |
| >a900-a9ff |  #0a   |  256 | FREE                                            |
| >aa00-aaff |  #0a   |  256 | FREE                                            |
| >ab00-abff |  #0a   |  256 | FREE                                            |
| >ac00-acff |  #0a   |  256 | FREE                                            |
| >ad00-adff |  #0a   |  256 | FREE                                            |
| >ae00-aeff |  #0a   |  256 | Paged-out scratchpad memory (maps >8300-83ff)   |
| >af00-afff |  #0a   |  256 | Far-jump / cartridge bankswitch trampoline stack|
| >b000-bfff | #10-1f | 4096 | Index / bankswitched pages (EA5 image, index)   |
| >c000-cfff | #30-xx | 4096 | Editor buffer pages (bankswitched via SAMS)     |
| >d000-dfff |  #05   | 4096 | Frame buffer area and uncrunch space            |
|            |        |      | >d000-dfff : framebuffer                        |
|            |        |      | >d960-dcff : uncrunch area for TI-Basic lines   |
| >e000-efff |  #06   | 4096 | Frame buffer / file catalog / command buffers   |
|            |        |      | catalog and filename lists starting at >e220    |
| >f000-ffff |  #07   | 4096 | Heap, strings, search indices and misc          |
|            |        |      | >f000-f0ff : heap & strings (heap.top = >f700)  |
|            |        |      | >f100-f4ff : search results index (rows)        |
|            |        |      | >f500-f6ff : search results index (cols)        |
|            |        |      | >f900-f9ff : command history buffer             |
|            |        |      | >fa00-ffff : free (1536 bytes)                  |


### Memory layout when activating TI Basic

Note: Other memory ranges are the same as the regular memory map.

| Address    | SAMS/Addr. | Bytes | Purpose                                    |
| ---------- | ---------- | ----- | -------------------------------------------|
| >b000-bfff |     #10    |  4096 | TI Basic VDP buffer                        |
| >c000-cfff |     #11    |  4096 | TI Basic VDP buffer                        |
| >d000-dfff |     #12    |  4096 | TI Basic VDP buffer                        |
| >e000-efff |     #13    |  4096 | TI Basic VDP buffer                        |
| >f000-ffff |     #07    |  4096 | Stevie VDP, scratchpad, ...                |
|            | >f000-f95f |  2400 |   Stevie VDP screen buffer copy 80x30      |
|            | >f960-f97f |    32 |   TI Basic scratchpad memory               |
|            | >f980-ffff |  1664 |   FREE                                     |

## VDP VRAM map

The VDP tables are kept the same, independently of the used GPU and rows mode.  
Actual allocation depends on the number of rows per screen.

| Address    | Size | VDP# | Value/Base | Purpose                            |
|------------|------|------|------------|------------------------------------|
| >0000-12bf | 4800 | #02  | >00 * >960 | Pattern name table for max 60 rows |
| >12c0-257f | 4800 | #03  | >4b * >040 | Color table (PAT) for max 60 rows  |
| >2580-27ff |  640 | #05  | >4b * >080 | Sprite SAT table. Not used /       |
|            |      |      |            | File PAB and record buffer         |
| >2800-2fff | 2048 | #04  | >05 * >800 | Pattern descriptor table           |
| >2800-2fff | 2048 | #06  | >05 * >800 | Sprite SPT table. Not used         |
| >3000-3fff | 4096 |      |            | Multi-purpose. See usage           |
| >4000-47ff | 2048 |      |            | F18a extended memory               |

Notes:
- Using position-based Pattern Color Table of max 4800 bytes (60 * 80) at >12c0.
- Sprite SAT table not used in text mode, >2580-27ff used for 
  file PAB and record buffer.
- File buffer header setup by TI-Disk Controller on startup   
  [Docs](https://www.unige.ch/medecine/nouspikel/ti99/disks2.htm#ROM)

### Allocation of VDP tables

#### Screen table

| PNT   | rows | end (+1) | Size | Hex   | gpu
|-------|------|----------|------|-------|----------------|
| >0000 | 24   | >0780    | 1920 | >780  | f18a, pico9918 |
| >0000 | 30   | >0960    | 2400 | >960  | f18a, pico9918 |
| >0000 | 48   | >0f00    | 3840 | >f00  | pico9918       |
| >0000 | 60   | >12c0    | 4800 | >12c0 | pico9918       |

#### Color table

| PCT   | rows | end (+1) | Size | Hex   | gpu
|-------|------|----------|------|-------|----------------|
| >12c0 | 24   | >1a40    | 1920 | >780  | f18a, pico9918 |
| >12c0 | 30   | >1c20    | 2400 | >960  | f18a, pico9918 |
| >12c0 | 48   | >21c0    | 3840 | >f00  | pico9918       |
| >12c0 | 60   | >2580    | 4800 | >12c0 | pico9918       |

#### Free space between PCT and PDT

>2580 - >27ff for file PAB and record buffer.

#### Pattern descriptor table

| PDT   | patterns | end (-1) | Size | Hex  |
|-------|----------|----------|------|------|
| >2800 | 256      | >3000    | 2048 | >800 |

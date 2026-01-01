# Memory map

## CPU RAM (SAMS MEMEXP 32K)

For each of the 256 bytes ranges, there are structures defined in ``equ.asm``.  
Check there for free memory ranges, because most structures do not use full
256 bytes range. First free address has equate <struct>.free

Note regarding column "SAMS/Addr.":

- The format ``>`` means MEMEXP memory range in hex.
- The format ``#`` means the SAMS page number in hex.

| Address    | SAMS/Addr. | Bytes | Purpose                                    | 
| ---------- | ---------- | ----- | -------------------------------------------|
| >2000-2fff |    #02     |  4096 | Resident spectra2 and Stevie modules       |
|------------|------------|-------|--------------------------------------------|
| >3000-3fff |    #03     |  4096 | Resident spectra2 and Stevie modules       |
|------------|------------|-------|--------------------------------------------|
| >a000-a0ff |    #0a     |   256 | Stevie core 1 RAM                          |
|            | >a006-a017 |    18 |   Input parameters parm1-parm9             |
|            | >a018-a025 |    14 |   Output parameters outparm1-outparm7      |
|            | >a026-a029 |     4 |   Keyboard flags, keycodes                 |
|            | >a02c-a035 |    10 |   Packed/Unpacked uint16, vector           |
|            | >0036-a055 |    32 |   FREE                                     |
|            | >a056-a063 |    14 |   Shadow Sprite attribute table, ramsat    |
|            | >a064-a0b3 |    80 |   Timers for stevie background tasks       |
|            | >a0b4-a0d3 |    30 |   TI Basic session pointers, variables     |
|            | >a0d4-a0e9 |    22 |   FREE                                     |
|            | >a0ea-a0ff |    22 |   TI Basic pointers, temporary variables   |
|            |            |       |                                            |
| >a100-a1ff |    #0a     |   256 | Stevie core 2 RAM                          |
|            | >a100-a1ff |   256 |   RAM workbuffer for various stuff         |
|            |            |       |                                            |
| >a200-a2ff |    #0a     |   256 | Stevie editor shared structure             |
|            | >a200-a20f |    16 |   SAMS page in window >2000, >3000, ...    |
|            | >a210-a237 |       |   Variables, pointers, flags, ...          |
|            | >a238-a2d7 |   160 |   Error message (max 160 chars)            |
|            | >a2d8-a2ff |       |   FREE                                     |
|            |            |       |                                            |
| >a300-a3ff |    #0a     |   256 | Frame buffer structure                     |
|            | >a300-a31f |    32 |   Variables, pointers, flags, ...          |
|            | >a320-a36f |    80 |   Ruler ascii chars                        |
|            | >a370-a3bf |    80 |   Ruler color attributes                   |
|            | >a3c0-a3ff |       |   FREE                                     |
|            |            |       |                                            |
| >a400-a4ff |    #0a     |   256 | File handle structure                      |
|            | >a400-a41f |    32 |   dsrlnk workspace                         |
|            | >a420-a435 |    32 |   dsrlnk variables, pointers, flags, ...   |
|            | >a436-a469 |    30 |   Variables, pointers, flags, ...          |
|            | >a46a-a4b9 |    80 |   Memory buffer for file handle            |
|            | >a4ba-a4ff |       |   FREE                                     |
|            |            |       |                                            |
| >a500-a5ff |     #0a    |   256 | Editor buffer structure                    |
|            | >a500-a525 |    38 |   Variables, pointers, flags, ...          |
|            | >a526-a575 |    80 |   Buffer for filename                      |
|            | >a576-a5d9 |   100 |   Search string buffer, pointers, counters |
|            | >a5da-a5ff |       |   FREE                                     |
|            |            |       |                                            |
| >a600-a6ff |     #0a    |   256 | Index structure                            |
|            | >a600-a605 |     6 |   SAMS page counters                       |
|            | >a606-a6ff |       |   FREE                                     |
|            |            |       |                                            |
| >a700-a7ff |     #0a    |   256 | Command buffer structure                   |
|            | >a700-a72d |    46 |   Variables, pointers, flags, ...          |
|            | >a72e-a77f |    80 |   Buffer for current command               |
|            | >a780-a7b1 |    50 |   String buffer for pane header            |
|            | >a7b2-a7ff |    50 |   Buffer for default filename              |
|            |            |       |                                            |
| >a800-a8ff |     #0a    |   256 | Stevie value stack                         |
|            |            |       |                                            |
| >a900-a9ff |     #0a    |   256 | FREE                                       |
| >aa00-aaff |     #0a    |   256 | FREE                                       |
| >ab00-abff |     #0a    |   256 | FREE                                       |
| >ac00-acff |     #0a    |   256 | FREE                                       |
| >ac00-acff |     #0a    |   256 | FREE                                       |
|            |            |       |                                            |
| >ad00-adff |     #0a    |   256 | Paged-out scratchpad memory >8300-83ff     |
| >ae00-aeff |     #0a    |   256 | FREE                                       |
|            |            |       |                                            |
| >af00-afff |     #0a    |   256 | Cart bankswitch trampoline return stack    |
|------------|------------|-------|--------------------------------------------|
| >b000-bfff |   #10-1f   |  4096 | Index page, bankswitched in SAMS /         |
|            |            |       | EA5 image in RAM, bankswitched in SAMS     |
|------------|------------|-------|--------------------------------------------|
| >c000-cfff |   #30-xx   |  4096 | Editor buffer page, bankswitched in SAMS / |
|            |            |       | EA5 image in RAM, bankswitched in SAMS     |
|------------|------------|-------|--------------------------------------------|
| >d000-dfff |     #05    |  4096 | Frame buffer part 1, uncrunch              |
|            | >d000-dfff |  4096 |   Frame buffer for max. 80x58 rows         |
|            | >d960-dcff |       |   Uncrunched TI Basic statement            |
|------------|------------|-------|--------------------------------------------|
| >e000-efff |     #06    |  4096 | Frame buffer part 2, File catalog          |
|            |            |       | (max 127 files), command buffer            |
|            | >e000-e21f |   544 |   Frame buffer for max. 80x58 rows         |
|            | >e000-e001 |     2 |   Variables, volume name                   |
|            | >e00e-e574 |  1398 |   length-prefixed file names list (127*11) |
|            | >e575-e5ff |  1398 |   File size list (127*2)                   |
|------------|------------|-------|--------------------------------------------|
| >f000-ffff |     #07    |  4096 | Heap, Strings area, Search results index   |
|            | >f000-f0ff |   256 |   Heap & Strings area                      |
|            | >f100-f8ff |  2048 |   Search results index (rows)              |
|            | >f900-fcff |  1024 |   Search results index (columns)           |
|            | >fe00-feef |   240 |   Default filenames                        |
|            | >fef0-ffef |   256 | Command buffer space                       |
|            | >fff0-ffff |    16 | FREE                                       |

### Memory layout when activating TI Basic

Note: Other memory ranges are the same as the regular memory map.

| Address    | SAMS/Addr. | Bytes | Purpose                                    |
| ---------- | ---------- | ----- | -------------------------------------------|
| >b000-bfff |     #10    |  4096 | TI Basic VDP buffer                        |
|------------|------------|-------|--------------------------------------------|
| >c000-cfff |     #11    |  4096 | TI Basic VDP buffer                        |
|------------|------------|-------|--------------------------------------------|
| >d000-dfff |     #12    |  4096 | TI Basic VDP buffer                        |
|------------|------------|-------|--------------------------------------------|
| >e000-efff |     #13    |  4096 | TI Basic VDP buffer                        |
|------------|------------|-------|--------------------------------------------|
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

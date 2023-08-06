# Memory map

For each of the 256 bytes ranges, there are structures defined in equ.asm    
Check there for free memory ranges, because most structures do not use full    
256 bytes range. F irst free address has equate <struct>.free  

| Address    | SAMS/Addr. | Bytes | Purpose                                    | 
| ---------- | ---------- | ----: | -------------------------------------------|
| >2000-2fff |    #02     |  4096 | Resident spectra2 and Stevie modules       |
|            |            |       |                                            |
| >3000-3fff |    #03     |  4096 | Resident spectra2 and Stevie modules       |
|            |            |       |                                            |
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
|            | >a3c0-a3ff |    64 |   FREE                                     |
|            |            |       |                                            |
| >a400-a4ff |    #0a     |   256 | File handle structure                      |
|            | >a400-a41f |    32 |   dsrlnk workspace                         |
|            | >a420-a435 |    32 |   dsrlnk variables, pointers, flags, ...   |
|            | >a436-a469 |    30 |   Variables, pointers, flags, ...          |
|            | >a46a-a4b9 |    80 |   Memory buffer for file handle            |
|            | >a4ba-a4ff |    72 |   FREE                                     |
|            |            |       |                                            |
| >a500-a5ff |     #0a    |   256 | Editor buffer structure                    |
|            | >a500-a525 |    38 |   Variables, pointers, flags, ...          |
|            | >a526-a575 |    80 |   Buffer for filename                      |
|            | >a576-a5ff |   138 |   FREE                                     |
|            |            |       |                                            |
| >a600-a6ff |     #0a    |   256 | Index structure                            |
|            | >a600-a605 |     6 |   SAMS page counters                       |
|            | >a606-a6ff |   250 |   FREE                                     |
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
|            |            |       |                                            |
| >b000-bfff |   #10-1f   |  4096 | Index page, bankswitched in SAMS           |
|            |            |       |                                            |
| >c000-cfff |   #30-xx   |  4096 | Editor buffer page, bankswitched in SAMS   |
|            |            |       |                                            |
| >d000-dfff |     #05    |  4096 | Frame buffer, uncrunch, default filenames  |
|            | >d000-d95f |  2400 |   Frame buffer for max. 80x30 rows         |
|            | >d960-dcff |       |   Uncrunched TI Basic statement            |
|            | >de00-deff |       |   Default filenames                        |
|            | >df00-dfff |   256 |   FREE                                     |
|            |            |       |                                            |
| >e000-efff |     #06    |  4096 | Directory file catalog (max. 127 files)    |
| >e000-efff | >e000-e574 |  1398 |   length-prefixed file names (127*11)      |
| >e000-efff | >e575-e574 |  1398 |   length-prefixed file names (127*11)      |
|            |            |       |                                            |
| >f000-ffff |     #07    |  4096 | Heap                                       |


# Memory layout when activating TI Basic

| Address    | SAMS/Addr. | Bytes | Purpose                                    | 
| ---------- | ---------- | ----: | -------------------------------------------|
| >b000-bfff |     #04    |  4096 | TI Basic VDP buffer                        |
|            |            |       |                                            |
| >c000-cfff |     #05    |  4096 | TI Basic VDP buffer                        |
|            |            |       |                                            |
| >d000-dfff |     #06    |  4096 | TI Basic VDP buffer                        |
|            |            |       |                                            |
| >e000-efff |     #07    |  4096 | TI Basic VDP buffer                        |
|            |            |       |                                            |
| >f000-ffff |     #08    |  4096 | Stevie VDP, scratchpad, ...                |
|            | >f000-f95f |  2400 |   Stevie VDP screen buffer copy 80x30      |
|            | >f960-f97f |    32 |   TI Basic scratchpad memory               |
|            | >f980-ffff |  1664 |   FREE                                     |
|            |            |       |                                            |

Other memory ranges same as regular memory map.

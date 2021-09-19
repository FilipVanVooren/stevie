# Low memory expansion

## >2000-3FFF / Resident modules

| Address       | Bytes | Size | Equates        | Purpose                                         | 
|---------------|-------|------|----------------|-------------------------------------------------|
| >2000 - >3fff | 8192  |      |                | Resident spectra2 and Stevie modules            |


## High memory expansion

## >a000  Stevie core RAM area

Basically for each of the 256 bytes ranges, there are structures defined in equates.asm
Check there for free memory ranges, because most structures do not use full 256 bytes range.
First free address has equate <struct>.free

| Address       | Bytes | Size | Equates        | Purpose                                         | 
|---------------|-------|------|----------------|-------------------------------------------------|
| >a000         |  256  |      |                | Stevie core 1 RAM                               |
|               |       |   32 | parm1          |   Input/Output parameters for Stevie functions  |
|               |       |   16 |                |   Variables for keyboard scan, unpack, ..       | 
| >a100         |  256  |      |                | RAM core area 2 RAM                             |
|               |       |   64 | timers         |   spectra2 timers table                         | 
|               |       |   64 | rambuf         |   RAM buffer for spectra2/stevie modules        | 
|               |       |   32 | ramsat         |   Shadow sprite table                           | 
| >a200         |  256  |  202 | tv.top         | struct - Stevie shared structures               |
| >a300         |  256  |  190 | fb.struct      | struct - Frame buffer                           |
| >a400         |  256  |  172 | fh.struct      | struct - File handle                            |
| >a500         |  256  |  105 | edb.struct     | struct - Editor buffer                          |
| >a600         |  256  |    6 | idx.struct     | struct - Index                                  |
| >a700         |  256  |  121 | cmdb.struct    | struct - Command buffer structure               |
| >a800         |  256  |      |                | **free**                                        |
| >a900         |  256  |      |                | **free**                                        |
| >aa00         |  256  |      |                | **free**                                        |
| >ab00         |  256  |      |                | **free**                                        |
| >ac00         |  256  |      |                | **free**                                        |
| >ad00         |  256  |      | pgout          | Paged-out scratchpad memory >8300-83ff          |
| >ae00         |  256  |      | stack          | Value/Return stack, downwards from >af00        |
| >af00         |  256  |      | fj.bottom      | Farjump return stack, downwards from >b000      |


## >b000  Index page

| Address       | Bytes | Size | Equates        | Purpose                                         | 
|---------------|-------|------|----------------|-------------------------------------------------|
| >b000 - >bfff | 4096  |      | idx.top        | Single index page, bankswitched in SAMS         |


## >c000  Editor buffer page

| Address       | Bytes | Size | Equates        | Purpose                                         | 
|---------------|-------|------|----------------|-------------------------------------------------|
| >c000 - >cfff | 4096  |      | edb.top        | Single editor buffer page, bankswitched in SAMS |


## >d000  Frame buffer for VDP

| Address       | Bytes | Size | Equates        | Purpose                                         | 
|---------------|-------|------|----------------|-------------------------------------------------|
| >d000 - >d95f | 2400  |      | fb.top         | Frame buffer page for 80x30 rows                |
| >d960 - >dfff | 1696  |      |                | **free**                                        |


## >e000  Command buffer history

| Address       | Bytes | Size | Equates        | Purpose                                         | 
|---------------|-------|------|----------------|-------------------------------------------------|
| >e000 - >efff | 4096  |      | cmdb.top       | Command buffer history                          |


## >f000  Heap

| Address       | Bytes | Size | Equates        | Purpose                                         | 
|---------------|-------|------|----------------|-------------------------------------------------|
| >f000 - >ffff | 4096  |      |                | Heap                                            |
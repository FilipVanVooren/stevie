# >2000-2FFF / spectra2 resident

| Address       | Size | Subrange   | Subsize | Equates        | Purpose                                         | 
|---------------|------|------------|---------|----------------|-------------------------------------------------|
| >2000 - >2FFF | 4096 |            |         |                | Resident spectra2 library                       |


# >3000-3FFF / Stevie resident & work memory

| Address       | Size | Subrange   | Subsize | Equates        | Purpose                                         | 
|---------------|------|------------|---------|----------------|-------------------------------------------------|
| >3000 - >3CFF | 3584 |            |         |                | Resident Stevie modules                         |
| >3E00 - >3EFF | 256  |            |         |                | RAM core area 1                                 |
|               |      | >3E00-3ECF |     224 |                |   Stevie variables area                         | 
|               |      |            |         |                |   keycode1, keycode2, repeat count              | 
|               |      |            |         |                |   Unpacked uint6                                | 
|               |      |            |         |                |   **free more than 200 bytes**                  | 
|               |      | >3EE0-3EFF |      32 | ramsat         |   Shadow sprite table                           | 
| >3F00 - >3FFF | 256  |            |         |                | RAM core area 2                                 |
|               |      | >3F00-3F1F |      32 | timers         |   spectra2 timers table                         | 
|               |      | >3F20-3F5F |      64 | rambuf         |   RAM buffer for spectra2/stevie modules        | 
|               |      | >3F60-3F7F |      32 | parm1-outparm7 |   Input/Output parameters for Stevie functions  |
|               |      | >3F80-3FFF |     128 | stack          |   Value/Return stack (grows downwards from 3fff)|


## High memory expansion



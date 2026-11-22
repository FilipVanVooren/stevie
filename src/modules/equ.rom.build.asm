* FILE......: equ.rom.build.asm
* Purpose...: Cartridge build options

*--------------------------------------------------------------
* Skip unused spectra2 code modules for reduced code size
*--------------------------------------------------------------
skip_rom_bankswitch       equ  1       ; Skip support for ROM bankswitching
skip_grom_cpu_copy        equ  1       ; Skip GROM to CPU copy functions
skip_grom_vram_copy       equ  1       ; Skip GROM to VDP vram copy functions
skip_vdp_boxes            equ  1       ; Skip filbox, putbox
skip_vdp_bitmap           equ  1       ; Skip bitmap functions
skip_vdp_viewport         equ  1       ; Skip viewport functions
skip_cpu_rle_compress     equ  1       ; Skip CPU RLE compression
skip_cpu_rle_decompress   equ  1       ; Skip CPU RLE decompression
skip_vdp_rle_decompress   equ  1       ; Skip VDP RLE decompression
skip_vdp_px2yx_calc       equ  1       ; Skip pixel to YX calculation
skip_speech_detection     equ  1       ; Skip speech synthesizer detection
skip_speech_player        equ  1       ; Skip inclusion of speech player code
skip_virtual_keyboard     equ  1       ; Skip virtual keyboard scan
skip_random_generator     equ  1       ; Skip random functions
skip_cpu_crc16            equ  1       ; Skip CPU memory CRC-16 calculation
*--------------------------------------------------------------
* Skip (manually included) spectra2 modules from resident RAM
*--------------------------------------------------------------
skip_sams_layout          equ  1       ; Skip SAMS memory layout routine
skip_sams_size            equ  1       ; Skip SAMS card size check
skip_fio_memprep          equ  1       ; Skip VDP memory setup for file I/O
*--------------------------------------------------------------
* SPECTRA2 / Stevie startup options
*--------------------------------------------------------------
kickstart.code1           equ  >6030   ; Uniform aorg entry addr accross banks
kickstart.code2           equ  >6000   ; Uniform aorg entry addr accross banks
rom0_kscan_on             equ  1       ; Use KSCAN in console ROM#0
debug                     equ  0       ; Turn on debugging mode
*--------------------------------------------------------------
* ROM layout (top of every 8K cartridge bank)
*
*   >6000 ...    program code, guarded by '.ifge $, >xxxx' in stevie_bN.asm
*   bankx.exttab vector extension slots 33-48; ONLY banks that need more than
*                32 cross-bank entry points carry this island (today: bank 3
*                and bank 4). Those banks lower their guard to >7f68, every
*                other bank may use the space up to the main vector table.
*   bankx.vectab main vector table, slots 1-32 (all banks)
*   bankx.vdptab VDP mode tables
*   >7fea        ROM identification string 'ROM#n'
*   >7ff0        cpu.crash.showbank
*
* gen_vectors.py validates these equates and the per-bank guards on every
* build ('gen_vectors.py check'); packing slots is 'gen_vectors.py compact'.
*--------------------------------------------------------------
bankx.exttab              equ  >7f68   ; Vector extension, slots 33-48 (optional)
bankx.vectab              equ  >7f88   ; Vector table, slots 1-32
bankx.vdptab              equ  >7fc8   ; VDP mode tables
bankx.crash.showbank      equ  >7ff0   ; Show ROM bank in CPU crash screen
device.fg99.mode.adv      equ  0       ; FG99 advanced mode off

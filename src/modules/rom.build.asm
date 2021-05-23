* FILE......: rom.build.asm
* Purpose...: Equates with cartridge build options

*--------------------------------------------------------------
* Skip unused spectra2 code modules for reduced code size
*--------------------------------------------------------------
skip_rom_bankswitch       equ  1       ; Skip support for ROM bankswitching
skip_grom_cpu_copy        equ  1       ; Skip GROM to CPU copy functions
skip_grom_vram_copy       equ  1       ; Skip GROM to VDP vram copy functions
skip_vdp_vchar            equ  1       ; Skip vchar, xvchar
skip_vdp_boxes            equ  1       ; Skip filbox, putbox
skip_vdp_bitmap           equ  1       ; Skip bitmap functions
skip_vdp_viewport         equ  1       ; Skip viewport functions
skip_cpu_rle_compress     equ  1       ; Skip CPU RLE compression
skip_cpu_rle_decompress   equ  1       ; Skip CPU RLE decompression
skip_vdp_rle_decompress   equ  1       ; Skip VDP RLE decompression
skip_vdp_px2yx_calc       equ  1       ; Skip pixel to YX calculation
skip_sound_player         equ  1       ; Skip inclusion of sound player code
skip_speech_detection     equ  1       ; Skip speech synthesizer detection
skip_speech_player        equ  1       ; Skip inclusion of speech player code
skip_virtual_keyboard     equ  1       ; Skip virtual keyboard scan
skip_random_generator     equ  1       ; Skip random functions
skip_cpu_crc16            equ  1       ; Skip CPU memory CRC-16 calculation
skip_mem_paging           equ  1       ; Skip support for memory paging 
*--------------------------------------------------------------
* Assembly (compile) options for Stevie
*--------------------------------------------------------------
device.f18a.mode.30x80    equ  0       ; F18a 30 rows mode on
device.fg99.mode.adv      equ  0       ; FG99 advanced mode on

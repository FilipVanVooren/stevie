* FILE......: rom.build.asm
* Purpose...: Cartridge build options

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
skip_speech_detection     equ  1       ; Skip speech synthesizer detection
skip_speech_player        equ  1       ; Skip inclusion of speech player code
skip_virtual_keyboard     equ  1       ; Skip virtual keyboard scan
skip_random_generator     equ  1       ; Skip random functions
skip_cpu_crc16            equ  1       ; Skip CPU memory CRC-16 calculation


*--------------------------------------------------------------
* Stack location
*--------------------------------------------------------------
sp2.stktop                equ  >8400   ; \ SP2 stack >ae00 - >aeff
                                       ; | The stack grows from high memory
                                       ; / to low memory


*--------------------------------------------------------------
* classic99 and JS99er emulators are mutually exclusive.
* At the time of writing JS99er has full F18a compatibility.
*
* When targetting the JS99er emulator or a real F18a + TI-99/4a 
* then set the 'full_f18a_support' equate to 1.
*
* When targetting the classic99 emulator then set the 
* 'full_f18a_support' equate to 0. This will activate the
* trimmed down 9938 version, that only works in classic99, but
* not on the real TI-99/4a yet.
*--------------------------------------------------------------
full_f18a_support         equ  1       ; 30 rows mode with sprites


*--------------------------------------------------------------
* JS99er F18a 30x80, no FG99 advanced mode
*--------------------------------------------------------------
  .ifeq full_f18a_support, 1
device.f18a               equ  1       ; F18a GPU
device.9938               equ  0       ; 9938 GPU
device.fg99.mode.adv      equ  0       ; FG99 advanced mode off
  .endif



*--------------------------------------------------------------
* Classic99 F18a 24x80, no FG99 advanced mode
*--------------------------------------------------------------
  .ifeq full_f18a_support, 0
device.f18a               equ  0       ; F18a GPU
device.9938               equ  1       ; 9938 GPU
device.fg99.mode.adv      equ  0       ; FG99 advanced mode off
skip_vdp_f18a_support     equ  1       ; Turn off f18a GPU check
  .endif
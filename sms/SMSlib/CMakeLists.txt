cmake_minimum_required(VERSION 3.16)

add_library(SMSlib STATIC
    SMSlib_aPLib.c SMSlib_autotext.c SMSlib_deprecated.c SMSlib_load1bppTiles.c SMSlib_load2bppTiles.c SMSlib_loadTileMapArea.c SMSlib_loadTileMapColumn.c SMSlib_paddle.c SMSlib_paletteAdd.c SMSlib_paletteSub.c SMSlib_STC0comp.c SMSlib_STC4comp.c SMSlib_PSGaiden.c SMSlib_spriteAdv.c SMSlib_sprite.c SMSlib_STMcomp.c SMSlib_textrenderer.c SMSlib_twosprites.c SMSlib_threesprites.c SMSlib_foursprites.c SMSlib_metasprite.c SMSlib_UNSAFE.c SMSlib_UNSAFE_SAT.c SMSlib_UNSAFE_memcpy.c SMSlib_UNSAFE_aPLib.c SMSlib_VRAMmemcpy_brief.c SMSlib_VRAMmemcpy.c SMSlib_VRAMmemset.c SMSlib_zx7.c SMSlib_zx7_VRAM.c SMSlib_string.c SMSlib_getTile.c SMSlib_readVRAM.c SMSlib_debug.c SMSlib_OUTI.asm
)

target_compile_options(SMSlib PRIVATE --max-allocs-per-node100000)

cmake_minimum_required(VERSION 3.16)

if(CMAKE_CURRENT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
    # Set the z88dk target for this build
    set(ZCCTARGET sms)
    # Use the z88dk provided tool configuration from the snap install
    set(CMAKE_TOOLCHAIN_FILE /snap/z88dk/current/share/z88dk/cmake/Toolchain-zcc.cmake)
    project(SMSlib C ASM)
endif()

if(TARGET SMSlib)
    return()
endif()

add_library(SMSlib STATIC
    SMSlib.c
    SMSlib_aPLib.c
    SMSlib_autotext.c
    SMSlib_deprecated.c
    SMSlib_load1bppTiles.c
    SMSlib_load2bppTiles.c
    SMSlib_loadTileMapArea.c
    SMSlib_loadTileMapColumn.c
    SMSlib_paddle.c
    SMSlib_paletteAdd.c
    SMSlib_paletteSub.c
    SMSlib_STC0comp.c
    SMSlib_STC4comp.c
    SMSlib_PSGaiden.c
    SMSlib_spriteAdv.c
    SMSlib_sprite.c
    SMSlib_STMcomp.c
    SMSlib_textrenderer.c
    SMSlib_twosprites.c
    SMSlib_threesprites.c
    SMSlib_foursprites.c
    SMSlib_metasprite.c
    SMSlib_UNSAFE.c
    SMSlib_UNSAFE_SAT.c
    SMSlib_UNSAFE_memcpy.c
    SMSlib_UNSAFE_aPLib.c
    SMSlib_VRAMmemcpy_brief.c
    SMSlib_VRAMmemcpy.c
    SMSlib_VRAMmemset.c
    SMSlib_zx7.c
    SMSlib_zx7_VRAM.c
    SMSlib_string.c
    SMSlib_getTile.c
    SMSlib_readVRAM.c
    SMSlib_debug.c
    SMSlib_OUTI.asm
)

target_compile_options(SMSlib PRIVATE -compiler=sdcc --max-allocs-per-node100000 -O3 -SO3 --fsigned-char -custom-copt-rules=${CMAKE_CURRENT_SOURCE_DIR}/rules.copt -DVDPTYPE_DETECTION)

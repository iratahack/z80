; Tile Map I/O ports - values set in setPorts.asm

IO_TileMapContr equ $6B                 ; Tile Map Control
IO_TileMapAttr  equ $6C                 ; Default Tilemap Attribute

IO_TileMapBaseAdrr  equ $6E             ; Tilemap Base Address
IO_TileMapDefBaseAddr   equ $6F         ; Tile Definitions Base Address
IO_TileMapPaletteContr  equ $43         ; Palette Control

IO_TileMapClipWindow    equ $1B         ; Clip Window Tilemap
IO_TileMapTransparency  equ $4C         ; Transparency index for the tilemap
IO_ULAControl   equ $68                 ; ULA Control

IO_TileMapOffSetXMSB    equ $2F         ; Tilemap Offset X MSB
IO_TileMapOffSetXLSB    equ $30         ; Tilemap Offset X LSB
IO_TileMapOffsetY   equ $31             ; Tilemap Offset Y

screen  equ     $4000
ulaattr equ     $5800
tilemap equ     $5b00

tileMapDefAddr  equ tilemap+1280        ; start address of tile map definitons

characterData   equ $3D00               ; start address of characterData
screenAddresstoPrint    equ 20489       ; address where 'Central Cavern' title will be printed

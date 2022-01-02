
	; GET MSB for port write of tileMapDefinitions base address

	;********

	; Note!
	; As the documentation says, bits 7,6 are ignored, first 5 bits
	; are writtedn to the port, so no processing has to be done.
	; here I load the values from the defined variables, and data file for tile defs

	;********

;*___________________________________________________________________________________________________________________________________

        ld      a, tilemap>>8
        nextreg IO_TileMapBaseAdrr, a


        ld      a, tilemap+1280>>8
        nextreg IO_TileMapDefBaseAddr, a

;*___________________________________________________________________________________________________________________________________

	; TILE MAP CONTROL
	; bit 7    = 1 to enable the tilemap
  	; bit 6    = 0 for 40x32, 1 for 80x32
  	; bit 5    = 1 to eliminate the attribute entry in the tilemap
  	; bit 4    = palette select
  	; bits 3-2 = Reserved set to 0
  	; bit 1    = 1 to activate 512 tile mode
  	; bit 0    = 1 to force tilemap on top of ULA

        nextreg IO_TileMapContr, %10100000
                                        ; tile map with  attribute byte eliminated is selected, (bit 5 is 1)

;*___________________________________________________________________________________________________________________________________

	; only used if no tile attrs in the tile map


	; (R/W) 0x6C (108) => Default Tilemap Attribute
	; bits 7-4 = Palette Offset
	; bit 3    = X mirror
	; bit 2    = Y mirror
	; bit 1    = Rotate
	; bit 0    = ULA over tilemap
	; bit 8 of the tile number if 512 tile mode is enabled)

        nextreg IO_TileMapAttr, %00000000

;*___________________________________________________________________________________________________________________________________


	; (R/W) 0x4C (76) => Transparency index for the tilemap
	; bits 7-4 = Reserved, must be 0
	; bits 3-0 = Set the index value (0xF after reset)

        nextreg IO_TileMapTransparency, %0000000
                                        ; bits 0-3 (0-15)

;*___________________________________________________________________________________________________________________________________


	;(R/W) 0x43 (67) => Palette Control
	; bit 7 = '1' to disable palette write auto-increment.
	; bits 6-4 = Select palette for reading or writing:
     	; 000 = ULA first palette
     	; 100 = ULA second palette
	; 001 = Layer 2 first palette
	; 101 = Layer 2 second palette
	; 010 = Sprites first palette
	; 110 = Sprites second palette
	; 011 = Tilemap first palette
	; 111 = Tilemap second palette
    	; bit 3 = Select Sprites palette (0 = first palette, 1 = second palette)
  	; bit 2 = Select Layer 2 palette (0 = first palette, 1 = second palette)
 	; bit 1 = Select ULA palette (0 = first palette, 1 = second palette)
  	; bit 0 = Enabe ULANext mode if 1. (0 after a reset)

        nextreg IO_TileMapPaletteContr, %00110000	; Tilemap first palette

;*___________________________________________________________________________________________________________________________________


	; (R/W) 0x68 (104) => ULA Control
 	 ; bit 7 = 1 to disable ULA output
  	 ; bit 6 = 0 to select the ULA colour for blending in SLU modes 6 & 7
      	 ;       = 1 to select the ULA/tilemap mix for blending in SLU modes 6 & 7
  	 ; bits 5-1 = Reserved must be 0
 	 ; bit 0 = 1 to enable stencil mode when both the ULA and tilemap are enabled
 	 ; (if either are transparent the result is transparent otherwise the result is a logical AND of both colours)

        nextreg IO_ULAControl, %00000000

;*___________________________________________________________________________________________________________________________________

        nextreg IO_TileMapOffSetXMSB, 0
        nextreg IO_TileMapOffSetXLSB, 0
        nextreg IO_TileMapOffsetY, 0

;*___________________________________________________________________________________________________________________________________

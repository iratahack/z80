#include <sms.h>
#include <stdio.h>

unsigned char pal1[] = {0x00, 0x20, 0x08, 0x28, 0x02, 0x22, 0x0A, 0x2A,
						0x15, 0x35, 0x1D, 0x3D, 0x17, 0x37, 0x1F, 0x3F};

unsigned char pal2[] = {0x00, 0x03, 0x08, 0x28, 0x02, 0x22, 0x0A, 0x2A,
						0x15, 0x35, 0x1D, 0x3D, 0x17, 0x37, 0x1F, 0x3F};

#asm
_titlePal:
	include "title_pal.inc"
_titlePalEnd:
_tiles:
	include "tiles.inc"
_tilesEnd:
_tileMap:
	include "tilemap.inc"
_tileMapEnd:
#endasm

	void
	main()
{
#if 0
	int y = 0;

	clear_vram();
	load_tiles(standard_font, 0, 255, 1);
	load_palette(pal1, 0, 16);
	load_palette(pal2, 16, 16);
	set_vdp_reg(VDP_REG_FLAGS1, VDP_REG_FLAGS1_BIT7 | VDP_REG_FLAGS1_SCREEN);

	printf("Hello, stdio!\nIs it working?\nI hope so.\n");
	printf("01234567890123456789012345678901\n");
	gotoxy(5, 5);
	printf("Hello, gotoxy(%d, %d)!", 5, 5);
#else
	clear_vram();
	load_tiles((unsigned char *)&tiles, 0, ((unsigned char *)&tilesEnd - (unsigned char *)&tiles) / 32, 4);
	load_palette((unsigned char *)&titlePal, 0, ((unsigned char *)&titlePalEnd - (unsigned char *)&titlePal));
	set_bkg_map((unsigned int *)&tileMap, 0, 0, 32, 24);
	set_vdp_reg(VDP_REG_FLAGS1, VDP_REG_FLAGS1_BIT7 | VDP_REG_FLAGS1_SCREEN);
#endif
	for (;;)
	{
		wait_vblank_noint();
	}
}

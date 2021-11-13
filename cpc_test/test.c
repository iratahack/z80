#include <stdio.h>
#include <cpc.h>
#include <compress/zx0.h>

// Address of screen memory
extern unsigned char _BANK_3_head;

__asm
    section RODATA
_image:
    binary "title.scr.zx0"
__endasm

// Palette for The Enterprise
unsigned char palette[] = {00, 06, 18, 26};

int main(void)
{
    cpc_setmode(1);

	for(int n=0; n<4; n++)
	    cpc_SetInk(n, palette[n]);

	dzx0_standard(&image, &_BANK_3_head);

    printf("Hello World!\n");

	while (1)
		;

	return (0);
}

#include <stdio.h>
#include <cpc.h>
#include <compress/zx0.h>

__asm
    section RODATA
_image:
    binary "title.scr.zx0"
__endasm

unsigned char palette[] = {00, 06, 18, 26};


int main(void)
{
    cpc_setmode(1);

	for(int n=0; n<4; n++)
	    cpc_SetInk(n, palette[n]);

	dzx0_standard(&image, 0xc000);

    printf("Hello World!\n");

	while (1)
		;

	return (0);
}

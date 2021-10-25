#include <stdio.h>
#ifdef CPC
#include <cpc.h>
#else
#include <arch/gb/gb.h>
#include <arch/gb/drawing.h>
#endif

int main(void)
{
#ifdef CPC
	cpc_setmode(2);
	cpc_SetInk(0, 0);
	cpc_SetInk(1, 26);

	__asm__("halt");
	cpc_ClrScr();
	cpc_SetBorder(0);

	printf("Hello World!\n");

	while (1)
		;
#else
	int a = 0;
	int n;
	color(BLACK, WHITE, OR);
	circle(GRAPHICS_WIDTH / 2, GRAPHICS_HEIGHT / 2, GRAPHICS_WIDTH / 4, M_NOFILL);
	while (1)
	{
		move_bkg(a--, 0);
		__asm__("halt");
	}
#endif

	return (0);
}

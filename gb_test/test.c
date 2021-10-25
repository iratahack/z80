#include <stdio.h>
#include <arch/gb/gb.h>
#include <arch/gb/drawing.h>

int main(void)
{
	int a = 0;
	int n;
	color(BLACK, WHITE, OR);
	circle(GRAPHICS_WIDTH / 2, GRAPHICS_HEIGHT / 2, GRAPHICS_WIDTH / 4, M_NOFILL);
	while (1)
	{
		move_bkg(a--, 0);
		__asm__("halt");
	}

	return (0);
}

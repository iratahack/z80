#include <stdio.h>
#ifdef CPC
#include <cpc.h>
#else
#include <arch/gb/gb.h>
#endif

int main(void)
{
#ifdef CPC
	cpc_setmode(2);
	cpc_ClrScr();
	cpc_SetBorder(0);
	cpc_SetInk(0, 0);
	cpc_SetInk(1, 26);

	printf("Hello World!\n");
#else
	int a = 0;
	int n;

	printf("Hello World!\n");
	while (1)
	{
		move_bkg(a--, 0);
		for (n = 0; n < 255; n++)
			;
	}
#endif

	while (1)
		;
	return (0);
}

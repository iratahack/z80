#include <stdio.h>
#include <cpc.h>

int main(void)
{
	cpc_setmode(0);
	cpc_SetInk(0, 0);
	cpc_SetInk(1, 26);

	__asm__("halt");
	cpc_ClrScr();
	cpc_SetBorder(0);

	printf("Hello World!\n");

	while (1)
		;

	return (0);
}

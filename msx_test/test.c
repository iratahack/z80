#include <stdio.h>


extern void music(void);

int main(void)
{
	__asm__("ei");
	printf("Hello World!\n");

	music();

	while (1)
		;

	return (0);
}

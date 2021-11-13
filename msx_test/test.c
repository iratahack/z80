#include <stdio.h>


extern void music(void);

int main(void)
{
	msx_set_mode(1);
	printf("Hello World!\n");

	music();

	while (1)
		;

	return (0);
}

#include <stdio.h>

extern void bank6(void) __banked;

#pragma bank 5

void bank5(void)
{
	printf("Test from bank 5\n");
	bank6();
}


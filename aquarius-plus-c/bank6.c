#include <stdio.h>

extern void bank7(void) __banked;

#pragma bank 6

void bank6(void)
{
	printf("Test from bank 6\n");
	bank7();
}


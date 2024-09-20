#include <stdio.h>

extern void bank3(void) __banked;

#pragma bank 2

void bank2(void)
{
	printf("Test from bank 2\n");
	bank3();
}


#include <stdio.h>

extern void bank2(void) __banked;

#pragma bank 1

void bank1(void)
{
	printf("Test from bank 1\n");
	bank2();
}


#include <stdio.h>

extern void bank4(void) __banked;

#pragma bank 3

void bank3(void)
{
	printf("Test from bank 3\n");
	bank4();
}


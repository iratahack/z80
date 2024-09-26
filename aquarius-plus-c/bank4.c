#include <stdio.h>

extern void bank5(void) __banked;

#pragma bank 4

// This const value is stored in bank 4,
// but it can be read from code in any bank.
const int bankedValue = 4;

void bank4(void)
{
	printf("Test from bank 4\n");
	bank5();
}


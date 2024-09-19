#include <stdio.h>

extern void bank1(void) __banked;
extern void bank2(void) __banked;
extern void bank3(void) __banked;
extern void bank4(void) __banked;

int main(void)
{
	char s[16];
	printf("Hello world!\n");
	bank1();
	bank2();
	bank3();
	bank4();
	printf("Enter your name: ");
	gets(s);
	printf("Hello %s\n", s);
	return(0);
}

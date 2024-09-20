#include <stdio.h>

extern void bank1(void) __banked;

int main(void)
{
	char s[16];
	printf("Hello world!\n");
	bank1();
	printf("Enter your name: ");
	gets(s);
	printf("Hello %s\n", s);
	return(0);
}

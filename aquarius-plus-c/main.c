#include <stdio.h>
#include <malloc.h>

extern void bank4(void) __banked;
extern __banked int bankedValue;

char *__far ptr;


int main(void)
{
	char s[16];
	ptr = malloc_far(0x4000);
	printf("ptr = %lp\n", ptr);

	printf("ptr = %lp\n", &ptr[0x3fff]);
	ptr[0x3fff] = '?';

	printf("%c\n", ptr[0x3fff]);

	printf("Hello world!\n");

	printf("Banked value is %d\n", bankedValue);
	bank4();

	printf("Enter your name: ");
	gets(s);
	printf("Hello %s\n", s);

	return(0);
}

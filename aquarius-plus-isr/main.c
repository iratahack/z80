#include <games.h>
#include <interrupt.h>
#include <intrinsic.h>
#include <stdio.h>

isr_t ISR(void)
{
    M_PRESERVE_MAIN;

    // Do something really cool here!

    M_RESTORE_MAIN;
}

void main(void)
{
    int a;

    // Setup im1 interrupts
    im1_init();

    // Install user ISR
    im1_install_isr(ISR);

    do
    {
        intrinsic_halt();
        a = joystick(1);
        printf("0x%02x\n", a);
        if (a & 0x10)
            return;
    } while (1);
}

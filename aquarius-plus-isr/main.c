#include <intrinsic.h>
#include <arch/z80.h>
#include <arch/aqplus.h>

#define ISR_ADDR	(0x38)
#define Z80_OPCODE_JP	(0xc3)

void service_interrupt( void )
{
	IO_IRQSTAT = 1;
	intrinsic_ei();
}

void main(void)
{
	intrinsic_di();

	// Disable readonly on BANK 0
	IO_BANK0 = IO_BANK0 & 0x7f;	

	// Add 'jp service_interrupt' to address 0x38
	z80_bpoke( ISR_ADDR, Z80_OPCODE_JP );
	z80_wpoke( ISR_ADDR + 1, (uint16_t) service_interrupt );

	// Unmask VBLANK interrupt
	IO_IRQMASK = 1;

	// Clear VBLANK interrupt status
	IO_IRQSTAT = 1;

	// Interrupt mode 1, rst 0x38
	intrinsic_im_1();

	// Enable interrupts
	intrinsic_ei();

	do {
		intrinsic_halt();
	} while(1);
}

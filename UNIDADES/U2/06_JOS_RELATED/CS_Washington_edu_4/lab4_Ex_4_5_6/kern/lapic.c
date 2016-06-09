// The local APIC manages internal (non-I/O) interrupts.
// See Chapter 8 & Appendix C of Intel processor manual volume 3.

#include <inc/types.h>
#include <inc/memlayout.h>
#include <inc/trap.h>
#include <inc/mmu.h>
#include <inc/stdio.h>
#include <inc/x86.h>
#include <kern/pmap.h>
#include <kern/cpu.h>

// Local APIC registers, divided by 4 for use as uint32_t[] indices.
#define ID      (0x0020/4)   // ID
#define VER     (0x0030/4)   // Version
#define TPR     (0x0080/4)   // Task Priority
#define EOI     (0x00B0/4)   // EOI
#define SVR     (0x00F0/4)   // Spurious Interrupt Vector
	#define ENABLE     0x00000100   // Unit Enable
#define ESR     (0x0280/4)   // Error Status
#define ICRLO   (0x0300/4)   // Interrupt Command
	#define INIT       0x00000500   // INIT/RESET
	#define STARTUP    0x00000600   // Startup IPI
	#define DELIVS     0x00001000   // Delivery status
	#define ASSERT     0x00004000   // Assert interrupt (vs deassert)
	#define DEASSERT   0x00000000
	#define LEVEL      0x00008000   // Level triggered
	#define BCAST      0x00080000   // Send to all APICs, including self.
	#define OTHERS     0x000C0000   // Send to all APICs, excluding self.
	#define BUSY       0x00001000
	#define FIXED      0x00000000
#define ICRHI   (0x0310/4)   // Interrupt Command [63:32]
#define TIMER   (0x0320/4)   // Local Vector Table 0 (TIMER)
	#define X1         0x0000000B   // divide counts by 1
	#define PERIODIC   0x00020000   // Periodic
#define PCINT   (0x0340/4)   // Performance Counter LVT
#define LINT0   (0x0350/4)   // Local Vector Table 1 (LINT0)
#define LINT1   (0x0360/4)   // Local Vector Table 2 (LINT1)
#define ERROR   (0x0370/4)   // Local Vector Table 3 (ERROR)
	#define MASKED     0x00010000   // Interrupt masked
#define TICR    (0x0380/4)   // Timer Initial Count
#define TCCR    (0x0390/4)   // Timer Current Count
#define TDCR    (0x03E0/4)   // Timer Divide Configuration

//physaddr_t lapic_addr;       // Initialized in mpconfig.c
physaddr_t lapicaddr;        // Initialized in mpconfig.c
static volatile uint32_t *lapic;

static uint32_t
lapic_read(uint32_t index)
{
	return lapic[index];
}

static void
lapic_write(uint32_t index, uint32_t value)
{
	lapic[index] = value;
	lapic[ID];  // wait for write to finish, by reading
}

void
lapic_init(void)
{
	//assert(lapic_addr);
	assert(lapicaddr);

	// lapic_addr is the physical address of the LAPIC's 4K MMIO
	// region.  Map it in to virtual memory so we can access it.
	//lapic = mmio_map_region(lapic_addr, 4096);
	lapic = mmio_map_region(lapicaddr, 4096);

	if (thiscpu == bootcpu)
		//cprintf("SMP: LAPIC %08p v%02x\n", lapic_addr, lapic_read(VER) & 0xFF);
		cprintf("SMP: LAPIC %08p v%02x\n", lapicaddr, lapic_read(VER) & 0xFF);

	// Enable local APIC; set spurious interrupt vector.
	lapic_write(SVR, ENABLE | (IRQ_OFFSET + IRQ_SPURIOUS));

	// The timer repeatedly counts down at bus frequency
	// from lapic[TICR] and then issues an interrupt.
	// If we cared more about precise timekeeping,
	// TICR would be calibrated using an external time source.
	lapic_write(TDCR, X1);
	lapic_write(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
	lapic_write(TICR, 10000000);

	// Leave LINT0 of the BSP enabled so that it can get
	// interrupts from the 8259A chip.
	//
	// According to Intel MP Specification, the BIOS should initialize
	// BSP's local APIC in Virtual Wire Mode, in which 8259A's
	// INTR is virtually connected to BSP's LINTIN0. In this mode,
	// we do not need to program the IOAPIC.
	if (thiscpu != bootcpu)
		lapic_write(LINT0, MASKED);

	// Disable NMI (LINT1) on all CPUs
	lapic_write(LINT1, MASKED);

	// Disable performance counter overflow interrupts
	// on machines that provide that interrupt entry.
	if (((lapic_read(VER)>>16) & 0xFF) >= 4)
		lapic_write(PCINT, MASKED);

	// Map error interrupt to IRQ_ERROR.
	lapic_write(ERROR, IRQ_OFFSET + IRQ_ERROR);

	// Clear error status register (requires back-to-back writes).
	lapic_write(ESR, 0);
	lapic_write(ESR, 0);

	// Ack any outstanding interrupts.
	lapic_write(EOI, 0);

	// Send an Init Level De-Assert to synchronize arbitration ID's.
	lapic_write(ICRHI, 0);
	lapic_write(ICRLO, BCAST | INIT | LEVEL);
	while(lapic_read(ICRLO) & DELIVS)
		;

	// Enable interrupts on the APIC (but not on the processor).
	lapic_write(TPR, 0);
}

int
cpunum(void)
{
	int apicid, i;

	if (!lapic)
		return 0;
	apicid = lapic_read(ID) >> 24;
	for (i = 0; i < ncpu; ++i) {
		if (cpus[i].cpu_apicid == apicid)
			return i;
	}
	assert(0);
}

// Acknowledge interrupt.
void
lapic_eoi(void)
{
	if (lapic)
		lapic_write(EOI, 0);
}

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
static void
microdelay(int us)
{
}

#define IO_RTC  0x70

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uint8_t apicid, uint32_t addr)
{
	int i;
	uint16_t *wrv;

	// "The BSP must initialize CMOS shutdown code to 0AH
	// and the warm reset vector (DWORD based at 40:67) to point at
	// the AP startup code prior to the [universal startup algorithm]."
	outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
	outb(IO_RTC+1, 0x0A);
	wrv = (uint16_t *)KADDR((0x40 << 4 | 0x67));  // Warm reset vector
	wrv[0] = 0;
	wrv[1] = addr >> 4;

	// "Universal startup algorithm."
	// Send INIT (level-triggered) interrupt to reset other CPU.
	lapic_write(ICRHI, apicid << 24);
	lapic_write(ICRLO, INIT | LEVEL | ASSERT);
	microdelay(200);
	lapic_write(ICRLO, INIT | LEVEL);
	microdelay(100);    // should be 10ms, but too slow in Bochs!

	// Send startup IPI (twice!) to enter code.
	// Regular hardware is supposed to only accept a STARTUP
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapic_write(ICRHI, apicid << 24);
		lapic_write(ICRLO, STARTUP | (addr >> 12));
		microdelay(200);
	}
}

void
lapic_ipi(int vector)
{
	lapic_write(ICRLO, OTHERS | FIXED | vector);
	while (lapic_read(ICRLO) & DELIVS)
		;
}

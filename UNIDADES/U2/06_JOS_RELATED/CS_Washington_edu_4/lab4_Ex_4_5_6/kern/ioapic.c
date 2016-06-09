// The I/O APIC manages hardware interrupts for an SMP system.
// http://www.intel.com/design/chipsets/datashts/29056601.pdf
// See also picirq.c.

#include <inc/stdio.h>
#include <inc/trap.h>

#include <kern/cpu.h>
#include <kern/pmap.h>

#define IOREGSEL	(0x00/4)
#define IOWIN		(0x10/4)

#define IOAPICID	0x00		// Register index: ID
#define IOAPICVER	0x01		// Register index: version
#define IOREDTBL	0x10		// Redirection table base

// The redirection table starts at REG_TABLE and uses
// two registers to configure each interrupt.  
// The first (low) register in a pair contains configuration bits.
// The second (high) register contains a bitmask telling which
// CPUs can serve that interrupt.
#define INT_DISABLED	0x00010000	// Interrupt disabled
#define INT_LEVEL	0x00008000	// Level-triggered (vs edge-)
#define INT_ACTIVELOW	0x00002000	// Active low (vs high)
#define INT_LOGICAL	0x00000800	// Destination is CPU id (vs APIC ID)

physaddr_t ioapic_addr;			// Initialized in mpconfig.c
static volatile uint32_t *ioapic;
uint8_t ioapicid;                       // Initialized in mpconfig.c

static uint32_t
ioapic_read(int reg)
{
	*(ioapic + IOREGSEL) = reg;
	return *(ioapic + IOWIN);
}

static void
ioapic_write(int reg, uint32_t data)
{
	*(ioapic + IOREGSEL) = reg;
	*(ioapic + IOWIN) = data;
}

void
ioapic_init(void)
{
	int i, reg_ver, ver, pins;
	int id;

	// Default physical address.
	assert(ioapic_addr == 0xfec00000);

	// IOAPIC is the default physical address.  Map it in to
	// virtual memory so we can access it.
	ioapic = mmio_map_region(ioapic_addr, 4096);

	reg_ver = ioapic_read(IOAPICVER);
	ver = reg_ver & 0xff;
	pins = ((reg_ver >> 16) & 0xff) + 1;
	cprintf("SMP: IOAPIC %08p v%02x [global_irq %02d-%02d]\n",
		ioapic_addr, ver, 0, pins - 1);

  //id = ioapic_read(IOAPICID) >> 24;                                         //
  //if(id != ioapicid)                                                        //
  //  cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");          //

	// Mark all interrupts edge-triggered, active high, disabled,
	// and not routed to any CPUs.
	for (i = 0; i < pins; ++i) {
		ioapic_write(IOREDTBL+2*i, INT_DISABLED | (IRQ_OFFSET + i));
		ioapic_write(IOREDTBL+2*i+1, 0);
	}
}

void
ioapic_enable(int irq, int apicid)
{
	// Mark interrupt edge-triggered, active high, enabled,
	// and routed to the given cpu's APIC ID.
	ioapic_write(IOREDTBL+2*irq, IRQ_OFFSET + irq);
	ioapic_write(IOREDTBL+2*irq+1, apicid << 24);
}

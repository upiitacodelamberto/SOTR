/* See COPYRIGHT for copyright information. */

#include <inc/string.h>
#include <inc/assert.h>

#include <kern/acpi.h>
#include <kern/cpu.h>
#include <kern/pmap.h>

struct CpuInfo cpus[NCPU];
struct CpuInfo *bootcpu;
int ismp;
int ncpu;
uint8_t ioapicid;


// Per-CPU kernel stacks
unsigned char percpu_kstacks[NCPU][KSTKSIZE]
__attribute__ ((aligned(PGSIZE)));


// See MultiProcessor Specification Version 1.[14]

struct mp {             // floating pointer [MP 4.1]
	uint8_t signature[4];           // "_MP_"
	physaddr_t physaddr;            // phys addr of MP config table
	uint8_t length;                 // 1
	uint8_t specrev;                // [14]
	uint8_t checksum;               // all bytes must add up to 0
	uint8_t type;                   // MP system config type
	uint8_t imcrp;
	uint8_t reserved[3];
} __attribute__((__packed__));

struct mpconf {         // configuration table header [MP 4.2]
	uint8_t signature[4];           // "PCMP"
	uint16_t length;                // total table length
	uint8_t version;                // [14]
	uint8_t checksum;               // all bytes must add up to 0
	uint8_t product[20];            // product id
	physaddr_t oemtable;            // OEM table pointer
	uint16_t oemlength;             // OEM table length
	uint16_t entry;                 // entry count
	physaddr_t lapicaddr;           // address of local APIC
	uint16_t xlength;               // extended table length
	uint8_t xchecksum;              // extended table checksum
	uint8_t reserved;
	uint8_t entries[0];             // table entries
} __attribute__((__packed__));

struct mpproc {         // processor table entry [MP 4.3.1]
	uint8_t type;                   // entry type (0)
	uint8_t apicid;                 // local APIC id
	uint8_t version;                // local APIC version
	uint8_t flags;                  // CPU flags
	uint8_t signature[4];           // CPU signature
	uint32_t feature;               // feature flags from CPUID instruction
	uint8_t reserved[8];
} __attribute__((__packed__));

struct mpproc *ioapic;
// mpproc flags
#define MPPROC_BOOT 0x02                // This mpproc is the bootstrap processor

// Table entry types
#define MPPROC    0x00  // One per processor
#define MPBUS     0x01  // One per bus
#define MPIOAPIC  0x02  // One per I/O APIC
#define MPIOINTR  0x03  // One per bus interrupt source
#define MPLINTR   0x04  // One per system interrupt source

static uint8_t
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
	for (i = 0; i < len; i++)
		sum += ((uint8_t *)addr)[i];
	return sum;
}

// Look for an MP structure in the len bytes at physical address addr.
static struct mp *
mpsearch1(physaddr_t a, int len)
{
	struct mp *mp = KADDR(a), *end = KADDR(a + len);

	for (; mp < end; mp++)
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
		    sum(mp, sizeof(*mp)) == 0)
			return mp;
	return NULL;
}

// Search for the MP Floating Pointer Structure, which according to
// [MP 4] is in one of the following three locations:
// 1) in the first KB of the EBDA;
// 2) if there is no EBDA, in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp *
mpsearch(void)
{
	uint8_t *bda;
	uint32_t p;
	struct mp *mp;

	static_assert(sizeof(*mp) == 16);

	// The BIOS data area lives in 16-bit segment 0x40.
	bda = (uint8_t *) KADDR(0x40 << 4);

	// [MP 4] The 16-bit segment of the EBDA is in the two bytes
	// starting at byte 0x0E of the BDA.  0 if not present.
	if ((p = *(uint16_t *) (bda + 0x0E))) {
		p <<= 4;	// Translate from segment to PA
		if ((mp = mpsearch1(p, 1024)))
			return mp;
	} else {
		// The size of base memory, in KB is in the two bytes
		// starting at 0x13 of the BDA.
		p = *(uint16_t *) (bda + 0x13) * 1024;
		if ((mp = mpsearch1(p - 1024, 1024)))
			return mp;
	}
	return mpsearch1(0xF0000, 0x10000);
}

// Search for an MP configuration table.  For now, don't accept the
// default configurations (physaddr == 0).
// Check for the correct signature, checksum, and version.
static struct mpconf *
mpconfig(struct mp **pmp)
{
	struct mpconf *conf;
	struct mp *mp;

	if ((mp = mpsearch()) == 0)
		return NULL;
	if (mp->physaddr == 0 || mp->type != 0) {
		cprintf("SMP: Default configurations not implemented\n");
		return NULL;
	}
	conf = (struct mpconf *) KADDR(mp->physaddr);
	if (memcmp(conf, "PCMP", 4) != 0) {
		cprintf("SMP: Incorrect MP configuration table signature\n");
		return NULL;
	}
	if (sum(conf, conf->length) != 0) {
		cprintf("SMP: Bad MP configuration checksum\n");
		return NULL;
	}
	if (conf->version != 1 && conf->version != 4) {
		cprintf("SMP: Unsupported MP version %d\n", conf->version);
		return NULL;
	}
	if ((sum((uint8_t *)conf + conf->length, conf->xlength) + conf->xchecksum) & 0xff) {
		cprintf("SMP: Bad MP configuration extended checksum\n");
		return NULL;
	}
	*pmp = mp;
	return conf;
}

void
mp_init(void)
{
//	struct acpi_table_madt *madt;                  
//	struct acpi_subtable_header *hdr, *end;        
	struct mp *mp;
	struct mpconf *conf;
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;
	ioapic_addr=0xfec00000;

	bootcpu = &cpus[0];
	if ((conf = mpconfig(&mp)) == 0)
		return;
	ismp = 1;

//	// 5.2.12.1 MADT Processor Local APIC / SAPIC Structure Entry Order
//	// * initialize processors in the order that they appear in MADT;
//	// * the boot processor is the first processor entry.
//	bootcpu->cpu_status = CPU_STARTED;             

//	madt = acpi_get_table(ACPI_SIG_MADT);          
//	if (!madt)                                     
//		panic("ACPI: No MADT found");          
//
//	lapic_addr = madt->address;
	lapicaddr = conf->lapicaddr;

//	hdr = (void *)madt + sizeof(*madt);
//	end = (void *)madt + madt->header.length;
//	for (; hdr < end; hdr = (void *)hdr + hdr->length) {
//		switch (hdr->type) {
//		case ACPI_MADT_TYPE_LOCAL_APIC: {
//			struct acpi_madt_local_apic *p = (void *)hdr;
//			bool enabled = p->lapic_flags & BIT(0);
//
//			if (ncpu < NCPU && enabled) {
//				// Be careful: cpu_apicid may differ from cpus index
//				cpus[ncpu].cpu_apicid = p->id;
//				ncpu++;
//			}
//			break;
//		}
//		case ACPI_MADT_TYPE_IO_APIC: {
//			struct acpi_madt_io_apic *p = (void *)hdr;
//
//			// We use one IOAPIC.
//			if (p->global_irq_base == 0)
//				ioapic_addr = p->address;
//			break;
//		}
//		default:
//			break;
//		}
//	}
	for (p = conf->entries, i = 0; i < conf->entry; i++) {
		switch (*p) {
		case MPPROC:
			proc = (struct mpproc *)p;
			if (proc->flags & MPPROC_BOOT)
				bootcpu = &cpus[ncpu];
			if (ncpu < NCPU) {
				cpus[ncpu].cpu_apicid = ncpu;
				ncpu++;
			} else {
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
					proc->apicid);
			}
			p += sizeof(struct mpproc);
			continue;
		case MPBUS:
		case MPIOAPIC:
      //ioapic = (struct mpproc*)p;                                          //
      //ioapicid = ioapic->apicid;                                           //
      ////p += sizeof(struct mpproc);                                        //
      //continue;                                                            //
		case MPIOINTR:
		case MPLINTR:
			p += 8;
			continue;
		default:
			cprintf("mpinit: unknown config type %x\n", *p);
			ismp = 0;
			i = conf->entry;
		}
	}

	cprintf("SMP: %d CPU(s)\n", ncpu);
}

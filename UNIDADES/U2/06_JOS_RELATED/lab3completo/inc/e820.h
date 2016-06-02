#ifndef JOS_INC_E820_H
#define JOS_INC_E820_H

#include <inc/types.h>

#define E820_NR_MAX		64

// ACPI 15, Table 15-312, Address Range Types
enum {
	E820_AVAILABLE		= 1,
	E820_RESERVED		= 2,
	E820_ACPI_RECLAIMABLE	= 3,
	E820_ACPI_NVS		= 4,
	E820_UNUSABLE		= 5,
};

// ACPI 15.1, INT 15H, E820H
// Ignore extended attributes.
struct e820_entry {
	uint64_t addr;
	uint64_t len;
	uint32_t type;
} __attribute__((packed));

struct e820_map {
	uint32_t nr;
	struct e820_entry entries[E820_NR_MAX];
};

extern struct e820_map e820_map;

void e820_init(physaddr_t mbi_pa);

#endif // !JOS_INC_E820_H

/* See COPYRIGHT for copyright information. */

#ifndef JOS_KERN_ACPI_H
#define JOS_KERN_ACPI_H

#include <inc/types.h>

#define ACPI_SIG_RSDP	"RSD PTR "
#define ACPI_SIG_RSDT	"RSDT"
#define ACPI_SIG_XSDT	"XSDT"
#define ACPI_SIG_MADT	"APIC"

// 5.2.5 Root System Description Pointer (RSDP)
struct acpi_table_rsdp {
	uint8_t signature[8];		// "RSD PTR "
	uint8_t checksum;		// first 20 bytes must add up to 0
	uint8_t oem_id[6];
	uint8_t revision;
	uint32_t rsdt_physical_address;	// 32-bit physical address of RSDT
	uint32_t length;		// table length
	uint64_t xsdt_physical_address;	// 64-bit physical address of XSDT
	uint8_t	extended_checksum;	// the entire table must add up to 0
	uint8_t reserved[3];
} __attribute__((packed));

// 5.2.6 System Description Table Header
struct acpi_table_header {
	uint8_t signature[4];		// "XSDT"
	uint32_t length;		// table length
	uint8_t revision;
	uint8_t checksum;		// the entire table must add up to 0
	uint8_t oem_id[6];
	uint8_t oem_table_id[8];
	uint32_t oem_revision;
	uint8_t asl_compiler_id[4];
	uint32_t asl_compiler_revision;
} __attribute__((packed));

// 5.2.7 Root System Description Table (RSDT)
// QEMU supports ACPI 1.0 only so we still have to deal with RSDT
struct acpi_table_rsdt {
	struct acpi_table_header header;
	uint32_t table_offset_entry[];
} __attribute__((packed));

// 5.2.8 Extended System Description Table (XSDT)
struct acpi_table_xsdt {
	struct acpi_table_header header;
	uint64_t table_offset_entry[];
} __attribute__((packed));

// 5.2.12 Multiple APIC Description Table (MADT)
struct acpi_table_madt {
	struct acpi_table_header header;
	uint32_t address;		// physical address of local APIC
	uint32_t flags;
} __attribute__((packed));

enum acpi_madt_type {
	ACPI_MADT_TYPE_LOCAL_APIC		= 0,
	ACPI_MADT_TYPE_IO_APIC			= 1,
};

struct acpi_subtable_header {
	uint8_t type;			// acpi_madt_type
	uint8_t length;
} __attribute__((packed));

struct acpi_madt_local_apic {
	struct acpi_subtable_header header;
	uint8_t processor_id;
	uint8_t id;			// processor's local APIC id
	uint32_t lapic_flags;
} __attribute__((packed));

struct acpi_madt_io_apic {
	struct acpi_subtable_header header;
	uint8_t id;
	uint8_t reserved;
	uint32_t address;
	uint32_t global_irq_base;
} __attribute__((packed));

void acpi_init(void);
void *acpi_get_table(const char *signature);

#endif // !JOS_KERN_ACPI_H

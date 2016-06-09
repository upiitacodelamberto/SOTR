/* See COPYRIGHT for copyright information. */

#include <inc/assert.h>
#include <inc/stdio.h>
#include <inc/multiboot.h>

struct e820_map e820_map;

static const char *e820_map_types[] = {
	"available",
	"reserved",
	"ACPI reclaimable",
	"ACPI NVS",
	"unusable",
};

static void
print_e820_map_type(uint32_t type) {
	switch (type) {
	case 1 ... 5:
		cprintf(e820_map_types[type - 1]);
		break;
	default:
		cprintf("type %u", type);
		break;
	}
}

// This function may ONLY be used during initialization,
// before page_init().
void
e820_init(physaddr_t mbi_pa)
{
	struct multiboot_info *mbi;
	uint32_t addr, addr_end, i;

	mbi = (struct multiboot_info *)mbi_pa;
	assert(mbi->flags & MULTIBOOT_INFO_MEM_MAP);
	cprintf("E820: physical memory map [mem 0x%08x-0x%08x]\n",
		mbi->mmap_addr, mbi->mmap_addr + mbi->mmap_length - 1);

	addr = mbi->mmap_addr;
	addr_end = mbi->mmap_addr + mbi->mmap_length;
	for (i = 0; addr < addr_end; ++i) {
		struct multiboot_mmap_entry *e;

		// Print memory mapping.
		assert(addr_end - addr >= sizeof(*e));
		e = (struct multiboot_mmap_entry *)addr;
		cprintf("  [mem %08p-%08p] ",
			(uintptr_t)e->e820.addr,
			(uintptr_t)(e->e820.addr + e->e820.len - 1));
		print_e820_map_type(e->e820.type);
		cprintf("\n");

		// Save a copy.
		assert(i < E820_NR_MAX);
		e820_map.entries[i] = e->e820;
		addr += (e->size + 4);
	}
	e820_map.nr = i;
}

#ifndef JOS_INC_MULTIBOOT_H
#define JOS_INC_MULTIBOOT_H

// headers
#define MULTIBOOT_HEADER_MAGIC		0x1BADB002
#define MULTIBOOT_MEMORY_INFO		0x00000002

// entry magic
#define MULTIBOOT_BOOTLOADER_MAGIC	0x2BADB002

// flags for struct multiboot_info
#define MULTIBOOT_INFO_MEM_MAP		0x00000040

#ifndef __ASSEMBLER__
#include <inc/e820.h>

struct multiboot_info {
	uint32_t flags;
	uint32_t ignore_0[10];
	uint32_t mmap_length;
	uint32_t mmap_addr;
	uint32_t ignore_1[9];
} __attribute__((packed));

struct multiboot_mmap_entry {
	uint32_t size;
	struct e820_entry e820;
} __attribute__((packed));

#endif /* !__ASSEMBLER__ */

#endif /* !JOS_INC_MULTIBOOT_H */

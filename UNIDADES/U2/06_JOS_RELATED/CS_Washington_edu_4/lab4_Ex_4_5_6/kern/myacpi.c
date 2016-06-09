/* See COPYRIGHT for copyright information. */

#include <inc/stdio.h>
#include <inc/string.h>

#include <kern/acpi.h>
#include <kern/pmap.h>

#define ACPI_NR_MAX	32

struct acpi_tables {
	uint32_t nr;
	struct acpi_table_header *entries[ACPI_NR_MAX];
};

static struct acpi_tables acpi_tables;


void *
acpi_get_table(const char *signature)
{
	uint32_t i;
	struct acpi_table_header **phdr = acpi_tables.entries;

	for (i = 0; i < acpi_tables.nr; ++i, ++phdr) {
		if (!memcmp((*phdr)->signature, signature, 4))
			return *phdr;
	}
	return NULL;
}

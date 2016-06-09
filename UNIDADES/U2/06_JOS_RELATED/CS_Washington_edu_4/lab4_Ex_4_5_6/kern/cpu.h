
#ifndef JOS_INC_CPU_H
#define JOS_INC_CPU_H

#include <inc/types.h>
#include <inc/memlayout.h>
#include <inc/mmu.h>
#include <inc/env.h>

// Maximum number of CPUs
#define NCPU  8

// Values of status in struct Cpu
enum {
	CPU_UNUSED = 0,
	CPU_STARTED,
	CPU_HALTED,
};

// Per-CPU state
struct CpuInfo {
	uint8_t cpu_apicid;             // Local APIC ID
	volatile unsigned cpu_status;   // The status of the CPU
	struct Env *cpu_env;            // The currently-running environment.
	struct Taskstate cpu_ts;        // Used by x86 to find stack for interrupt
};

// Initialized in mpconfig.c
extern struct CpuInfo cpus[NCPU];
extern int ncpu;                    // Total number of CPUs in the system
//extern physaddr_t lapic_addr;       // Physical MMIO address of the local APIC
extern physaddr_t lapicaddr;        // Physical MMIO address of the local APIC
extern physaddr_t ioapic_addr;      // Physical MMIO address of the IO APIC

// Per-CPU kernel stacks
extern uint8_t percpu_kstacks[NCPU][KSTKSIZE];

// Index into cpus[]
int cpunum(void);
#define thiscpu (&cpus[cpunum()])
//#define bootcpu (&cpus[0])          // The boot-strap processor (BSP)
extern struct CpuInfo *bootcpu;     // The boot-strap processor (BSP)

void mp_init(void);

void lapic_init(void);
void lapic_startap(uint8_t apicid, uint32_t addr);
void lapic_eoi(void);
void lapic_ipi(int vector);

void pic_init(void);
void ioapic_init(void);
void ioapic_enable(int irq, int apicid);

#endif

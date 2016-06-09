/* See COPYRIGHT for copyright information. */

#include <inc/assert.h>
#include <inc/cpuid.h>
#include <inc/multiboot.h>
#include <inc/stdio.h>
#include <inc/string.h>
#include <inc/x86.h>

#include <kern/monitor.h>
#include <kern/console.h>
#include <kern/pmap.h>
#include <kern/env.h>
#include <kern/trap.h>
//#include <kern/acpi.h>
#include <kern/sched.h>
#include <kern/cpu.h>
#include <kern/spinlock.h>

static void boot_aps(void);


void
i386_init(uint32_t magic, uint32_t addr)
{
	extern char edata[], end[];

	// Before doing anything else, complete the ELF loading process.
	// Clear the uninitialized global data (BSS) section of our program.
	// This ensures that all static/global variables start out zero.
	memset(edata, 0, end - edata);

	// Initialize the console.
	// Can't call cprintf until after we do this!
	cons_init();

	// Must boot from Multiboot.
	assert(magic == MULTIBOOT_BOOTLOADER_MAGIC);

	cprintf("451 decimal is %o octal!\n", 451);

	// Print CPU information.
	cpuid_print();

	// Initialize e820 memory map.
	e820_init(addr);

	// Lab 2 memory management initialization functions
	mem_init();

	// Lab 3 user environment initialization functions
	env_init();
	trap_init();

	// Lab 4 multiprocessor initialization functions
	//acpi_init();
	mp_init();
	lapic_init();

	// Lab 4 multitasking initialization functions
	pic_init();
	ioapic_init();

	// Enable keyboard & serial interrupts
	ioapic_enable(IRQ_KBD, bootcpu->cpu_apicid);
	ioapic_enable(IRQ_SERIAL, bootcpu->cpu_apicid);

	// Acquire the big kernel lock before waking up APs
	// Your code here://ANSWER LAB 4 Exercise 5 1/4
	lock_kernel();

	// Starting non-boot CPUs
	boot_aps();

#if defined(TEST)
	// Don't touch -- used by grading script!
	ENV_CREATE(TEST, ENV_TYPE_USER);
#else
	// Touch all you want.
//<<<<<<< HEAD
	//ENV_CREATE(user_primes, ENV_TYPE_USER);
//=======
	//ENV_CREATE(user_hello, ENV_TYPE_USER);
	//ENV_CREATE(user_divzero, ENV_TYPE_USER);
	//ENV_CREATE(user_badsegment, ENV_TYPE_USER);
	//ENV_CREATE(user_buggyhello, ENV_TYPE_USER);
	ENV_CREATE(user_yield,ENV_TYPE_USER);
	ENV_CREATE(user_yield,ENV_TYPE_USER);
	ENV_CREATE(user_yield,ENV_TYPE_USER);
//>>>>>>> lab3
#endif // TEST*

	// Schedule and run the first user environment!
	sched_yield();
}

// While boot_aps is booting a given CPU, it communicates the per-core
// stack pointer that should be loaded by mpentry.S to that CPU in
// this variable.
void *mpentry_kstack;

// Start the non-boot (AP) processors.
static void
boot_aps(void)
{
	extern unsigned char mpentry_start[], mpentry_end[];
	void *code;
	struct CpuInfo *c;

	if (ncpu <= 1)
		return;
	cprintf("SMP: BSP #%d [apicid %02x]\n", cpunum(), thiscpu->cpu_apicid);

	// Write entry code to unused memory at MPENTRY_PADDR
	code = KADDR(MPENTRY_PADDR);
	memmove(code, mpentry_start, mpentry_end - mpentry_start);

	// Boot each AP one at a time
	for (c = cpus + 1; c < cpus + ncpu; c++) {
		// Tell mpentry.S what stack to use 
		mpentry_kstack = percpu_kstacks[c - cpus] + KSTKSIZE;
		// Start the CPU at mpentry_start
		lapic_startap(c->cpu_apicid, PADDR(code));
		// Wait for the CPU to finish some basic setup in mp_main()
		while(c->cpu_status != CPU_STARTED)
			;
	}
}

// Setup code for APs
void
mp_main(void)
{
	// We are in high EIP now, safe to switch to kern_pgdir 
	lcr3(PADDR(kern_pgdir));
	cprintf("  AP #%d [apicid %02x] starting\n", cpunum(), thiscpu->cpu_apicid);

	lapic_init();
	env_init_percpu();
	trap_init_percpu();
	xchg(&thiscpu->cpu_status, CPU_STARTED); // tell boot_aps() we're up

	// Now that we have finished some basic setup, call sched_yield()
	// to start running processes on this CPU.  But make sure that
	// only one CPU can enter the scheduler at a time!
	//
	// Your code here:
	lock_kernel();                  //ANSWER LAB 4 Exercise 5  2/4
	sched_yield();                  //ANSWER LAB 4 Exercise 5  2/4

	// Remove this after you finish Exercise 4
	for (;;);
}

/*
 * Variable panicstr contains argument to first call to panic; used as flag
 * to indicate that the kernel has already called panic.
 */
const char *panicstr;

/*
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
	va_list ap;

	if (panicstr)
		goto dead;
	panicstr = fmt;

	// Be extra sure that the machine is in as reasonable state
	asm volatile("cli; cld");

	va_start(ap, fmt);
	cprintf("kernel panic on CPU %d at %s:%d: ", cpunum(), file, line);
	vcprintf(fmt, ap);
	cprintf("\n");
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
	va_list ap;

	va_start(ap, fmt);
	cprintf("kernel warning at %s:%d: ", file, line);
	vcprintf(fmt, ap);
	cprintf("\n");
	va_end(ap);
}

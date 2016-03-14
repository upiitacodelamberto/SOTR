/* yield.c - yield */

/*#include <xinu.h>*/
#include "kernel.h"
#include "conf.h"
#include "tty.h"
#include "uart.h"
#include "semaphore.h"
#include "process.h"
#include "prototypes.h"

/*------------------------------------------------------------------------
 *  yield  -  Voluntarily relinquish the CPU (end a timeslice)
 *------------------------------------------------------------------------
 */
syscall	yield(void)
{
	intmask	mask;			/* Saved interrupt mask		*/

	mask = disable();
	resched();
	restore(mask);
	return OK;
}

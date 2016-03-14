/* panic.c - panic */

/*#include <xinu.h>*/
#include "kernel.h"
#include "conf.h"
#include "uart.h"
#include "prototypes.h"

/*------------------------------------------------------------------------
 * panic  -  Display a message and stop all processing
 *------------------------------------------------------------------------
 */
void	panic (
	 char	*msg			/* Message to display		*/
	)
{
	disable();			/* Disable interrupts		*/
	kprintf("\n\n\rpanic: %s\n\n", msg);
	while(TRUE) {;}			/* Busy loop forever		*/
}

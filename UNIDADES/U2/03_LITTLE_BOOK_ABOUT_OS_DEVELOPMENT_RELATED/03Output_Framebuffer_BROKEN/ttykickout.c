/* ttykickout.c - ttykickout */

/*#include <xinu.h>*/
#include "kernel.h"
#include "conf.h"
#include "tty.h"
#include "uart.h"
#include "prototypes.h"

/*------------------------------------------------------------------------
 *  ttykickout  -  "Kick" the hardware for a tty device, causing it to
 *		     generate an output interrupt (interrupts disabled)
 *------------------------------------------------------------------------
 */
void	ttykickout(
	 struct uart_csreg *csrptr	/* Address of UART's CSRs	*/
	)
{
	/* Force the UART hardware generate an output interrupt */

	csrptr->ier = UART_IER_ERBFI | UART_IER_ETBEI;

	return;
}

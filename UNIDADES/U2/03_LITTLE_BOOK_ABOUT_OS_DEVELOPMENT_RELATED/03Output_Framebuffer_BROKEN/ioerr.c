/* ioerr.c - ioerr */

/*#include <xinu.h>*/
#include "kernel.h"
#include "conf.h"
#include "tty.h"
#include "uart.h"
#include "prototypes.h"

/*------------------------------------------------------------------------
 *  ioerr  -  Return an error status (used for "error" entries in devtab)
 *------------------------------------------------------------------------
 */
devcall	ioerr(void)
{
	return SYSERR;
}

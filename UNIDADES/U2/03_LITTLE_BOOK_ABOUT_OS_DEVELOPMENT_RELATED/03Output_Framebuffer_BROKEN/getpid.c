/* getpid.c - getpid */

/*#include <xinu.h>*/
#include "kernel.h"
#include "process.h"

/*------------------------------------------------------------------------
 *  getpid  -  Return the ID of the currently executing process
 *------------------------------------------------------------------------
 */
pid32	getpid(void)
{
	return (currpid);
}

/* userret.c - userret */

/*#include <xinu.h>*/
#include "kernel.h"

#include "prototypes.h"

/*------------------------------------------------------------------------
 *  userret  -  Called when a process returns from the top-level function
 *------------------------------------------------------------------------
 */
void	userret(void)
{
	kill(getpid());			/* Force process to exit */
}

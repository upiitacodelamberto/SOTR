/* bufinit.c - bufinit */

/*#include <xinu.h>*/
#include "kernel.h"
#include "bufpool.h"

struct	bpentry	buftab[NBPOOLS];		/* Buffer pool table	*/
bpid32	nbpools;

/*------------------------------------------------------------------------
 *  bufinit  -  Initialize the buffer pool data structure
 *------------------------------------------------------------------------
 */
status	bufinit(void)
{
	nbpools = 0;
	return OK;
}

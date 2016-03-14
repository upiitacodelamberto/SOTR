/* sprintf.c - sprintf */

/*#include <stdarg.h>*/
#include "kernel.h"
#include "conf.h"
#include "tty.h"
#include "uart.h"
#include "semaphore.h"
#include "process.h"
#include "queue.h"
#include "stdarg.h"
#include "prototypes.h"

static int sprntf(int, int);
extern void _fdoprnt(char *, va_list, int (*func) (int, int), int);

/*------------------------------------------------------------------------
 *  sprintf  -  Format arguments and place output in a string.
 *------------------------------------------------------------------------
 */
int		sprintf(
		  char		*str,		/* output string						*/
		  char		*fmt,		/* format string						*/
		  ...
		)
{
    va_list ap;
    char *s;

    s = str;
    va_start(ap, fmt);
    _fdoprnt(fmt, ap, sprntf, (int)&s);
    va_end(ap);
    *s++ = '\0';

    return ((int)str);
}

/*------------------------------------------------------------------------
 *  sprntf  -  Routine called by _doprnt to handle each character.
 *------------------------------------------------------------------------
 */
static int		sprntf(
				  int		acpp,
				  int		ac
				)
{
    char **cpp = (char **)acpp;
    char c = (char)ac;

    return (*(*cpp)++ = c);
}

// buggy hello world -- unmapped pointer passed to kernel
// kernel should destroy user environment in response

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
	sys_cputs((char*)1, 1);
	/*si usamos UENVS=0xeec00000, ya no se produce la excepcion Page fault en el lab3completo*/
	//sys_cputs((char*)0xeec00000, 1);   
	/*si usamos UENVS-1=0xeebfffff, si se produce la Page fault*/
	//sys_cputs((char*)0xeebfffff, 1);   
	/*ULIM=0xef800000, vease inc/memlayout.h, usando ULIM-1 SI hay Page fault*/
	/*con el mensaje de panic del kernel y diciendo que el err es de [kernel read Not-Present] */
	//sys_cputs((char*)0xef7fffff, 1);   
	/*ULIM=0xef800000. Si usamos ULIM+1=0xef800001, debe producirse la Page fault */
	//sys_cputs((char*)0xef800001, 1);      /*de hecho se produce kernel panic*/
					      /*y assertion failed: page2pa(pp) != MPENTRY_PADDR*/
	//int i;     /*PGSIZE es 4096*/
	//for(i=0;i<10;i++)
	//  sys_cputs((char*)0xeec00000+i,1);
}


/* the layout of this structure must match the order of registers
   pushed and popped  by the exception handlers in START.ASM */
typedef struct regs{
  /*pushed by pusha*/
  unsigned int edi,esi,ebp,esp,ebx,edx,ecx,eax;
  /*pushed separately*/
  unsigned short ds,es,fs,gs;
  unsigned which_int,err_code;
  /*pushed by exception. Exception may also push err_code.
    user_esp, and user_ss are pushed only if a privilige change ossurs.*/
  unsigned int error_code,eip,cs,eflags,user_esp,user_ss;
}regs_t;

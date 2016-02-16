#include <stdio.h>
void main(){
  int a=10,b=20;
  asm("movl %1,%%eax\n\t"
      "movl %%eax,%0\n\t"
      :"=r"(b)      /* output */
      :"r"(a)       /* input  */
      :"%eax"       /* clobbered register */
  );
  printf("b=%d a=%d\n",b,a);
}

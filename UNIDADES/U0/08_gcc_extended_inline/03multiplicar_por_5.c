#include <stdio.h>
void Five_Times_X(int *,int *);
void main(){
  int x=10,five_times_x;
  int y=20,five_times_y;
  int z=30,five_times_z;
  asm("leal (%1,%1,4),%0"   /* five_times_x=4(x)+x */
      : "=r" (five_times_x)
      : "r" (x)
      );
  printf("x=%i\tfive_times_x=%i\n",x,five_times_x);
  Five_Times_X(&x,&five_times_x);
  printf("DESPUES:x=%i\tfive_times_x=%i\n",x,five_times_x);

  asm("leal (%1,%1,4),%0"   /* five_times_x=4(x)+x */
      : "=r" (five_times_y)
      : "0" (y)             /* read-write operand, we didn't specify the register to be used */
      );                    /* but we don't know which register */
  printf("y=%i\tfive_times_y=%i\n",y,five_times_y);

  printf("z=%i\n",z);
  asm("leal (%%ecx,%%ecx,4),%%ecx"   /* five_times_x=4(x)+x */
      : "=c" (z)
      : "c" (z)             /* read-write operand, input and output operand are in the same register */
      );                    /* and now we know which register */
  printf("z now is five_times_previous_z=%i\n",z);
}

void Five_Times_X(int *x,int *five_times_x){
  asm("leal (%1,%1,4),%0"     /* five_times_x=4 veces *x + *x */
      : "=r" (*five_times_x)
      : "r" (*x)
      );
}

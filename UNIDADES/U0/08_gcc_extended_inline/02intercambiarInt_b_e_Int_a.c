#include <stdio.h>
void myxchg(int*,int*);

void main(){
  int a=10,b=20;
  printf("ANTES a=%d, b=%d\n",a,b);
  asm("movl %2,%%eax\n\t"
      "movl %3,%%ebx\n\t"
      "movl %%eax,%1\n\t"
      "movl %%ebx,%0\n\t"
      :"=r"(a),"=r"(b)     /* output */
      :"r"(a),"r"(b)       /* input  */
      :"%eax","%ebx"       /* clobbered register */
  );
  printf("DESPUES a=%d, b=%d\n",a,b);
  myxchg(&a,&b);
  printf("MAS DESPUES a=%d, b=%d\n",a,b);
}

/* Funcion que intercambia el contenido de dos variables int, 
   Para usarla se deben pasar las direcciones de las dos variables 
   enteras cuyos contenidos se desea intercambiar */
void myxchg(int *x,int *y){
  asm("movl %2,%%eax\n\t"
      "movl %3,%%ebx\n\t"
      "movl %%eax,%1\n\t"
      "movl %%ebx,%0\n\t"
      :"=r"(*x),"=r"(*y)     /* output */
      :"r"(*x),"r"(*y)       /* input  */
      :"%eax","%ebx"         /* clobbered registers */
  );
}

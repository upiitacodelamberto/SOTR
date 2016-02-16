#include <stdio.h>
#include <stdlib.h>

void main(){
  int count=10;
  long src=0x0;
  long *dest=(long*)malloc(count*sizeof(long));
  asm ("cld\n\t"
       "rep\n\t"
       "stosl"
       : "=D"(dest), "=c" (count)
       : "0" (dest), "1" (count), "a" (src)
       : "memory", "cc" 
       );
//  free(dest); /*en este programa esta linea produce error, por que?*/
                /*2016.02.16*/
/*Vease tambien el archivo Ejemplo01.c en este mismo repositorio*/
}

//Now, what does this code do? 
//The above inline fills the fill_value count times 
//to the location pointed to by the register edi. It 
//also says to gcc that, the contents of registers eax 
//and edi are no longer valid.


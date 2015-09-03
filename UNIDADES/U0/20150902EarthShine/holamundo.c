#include <stdio.h>



#ifndef __unix__
#include <conio.h>
#endif /* __unix__ */

//GNU=GNU Not Unix

/* 
  0 No hubo error.
  */
int main(void){
  printf("HOLA MUNDO UPIITA");
#ifndef __unix__
  getch();
#endif /* __unix__ */
  return 0;
}

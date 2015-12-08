#include <stdio.h>



#ifndef _WIN32
#include <conio.h>
#endif /* _WIN32 */

//GNU=GNU Not Unix

/* 
  0 No hubo error.
  */
int main(void){
  printf("HOLA MUNDO UPIITA");
#ifndef _WIN32
  getch();
#endif /* _WIN32 */
  return 0;
}

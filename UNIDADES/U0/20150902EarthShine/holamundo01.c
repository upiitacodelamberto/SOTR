#include <stdio.h>

#ifdef _WIN32
#include <conio.h>
#endif /* _WIN32 */

#ifdef _WIN32
#include "prueba.h"
#endif

//GNU=GNU Not Unix

/* 
  0 No hubo error.
  */
int main(void){
  printf("HOLA MUNDO UPIITA\n");
  int x=maximo(10,20);
  int i;
  printf("x=%i\n",x);
  union sotr *nombre;
  nombre=&SOTR;
  nombre->what[0]='H';
  nombre->what[1]='O';
  nombre->what[2]='L';
  nombre->what[3]='A';
  for(i=0; i<sizeof(SIZE); ++i)
    printf("%c",nombre->what[i]); 
  printf("\n");
  printf("nombre->que=%p\n",nombre->que);
#ifdef _WIN32
  getch();
#endif /* __unix__ */
  return 0;
}






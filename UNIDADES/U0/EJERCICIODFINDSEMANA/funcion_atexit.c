#include <stdio.h>
#include <stdlib.h>

void func1(void);
void func2(void);

long main(){
  atexit(func1);
  atexit(func2);

  printf("Funcion principal\n");
  return 0;
}//end main()

void func1(void){
  printf("Funcion 1\n");
}

void func2(void){
  printf("Funcion 2\n");
}

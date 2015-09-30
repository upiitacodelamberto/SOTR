#include <stdio.h>
#include <malloc.h>
#include <iostream>
using namespace std;

#include "fooInt.h"
#ifdef EXAMPLEORIG
template <typename T>  /* Como se incluye fooInt.h, esto parece funcionar como */
T Static_T<T>::My = 1 ;/* una asignacion a un simbolo debil. */
#else
template <typename T>  /* Como se incluye fooInt.h, esto parece funcionar como */
T Static_T<T>::My = (char*)malloc(10*sizeof(char)) ;/* una asignacion a un simbolo debil. */
#endif

int foo_2()
{
#ifdef EXAMPLEORIG
    return fooInt*fooInt*Static_T<int>::My ;
#else
    cout << Static_T<char*>::My[0] <<"\n";
#endif
    return fooInt*fooInt ;
}

#ifdef CONMAIN_N_MAINDOTCPP
int main(int argc, char *argv[])
{
  printf("%d,%d\n" ,foo_2() ,foo_3() ) ;
#ifdef EXAMPLEORIG
//  Static_T<int>::My = 20 ;//fooInt=1;
#else
  Static_T<char*>::My[0] = 'Z' ;//fooInt=1;
#endif
  printf("%d,%d\n" ,foo_2() ,foo_3() ) ;  
  return 0;
}
#endif

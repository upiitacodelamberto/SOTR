#include <malloc.h>
#include "fooInt.h"
#ifdef EXAMPLEORIG
template <typename T>
T Static_T<T>::My = -1 ;/* Este simbolo parece ser ``mas debil'' que el de abajo */
#else
template <typename T>
T Static_T<T>::My=(char*)malloc(sizeof("__atribute__((weak))"));
#endif


#ifndef CONDUMMYVACIA
void dummy(){
#ifdef EXAMPLEORIG
  Static_T<int>::My=10;/* Este simbolo parece ser ``mas fuerte'' que el de arriba */
                       /* pero para poder usarlo se necesita la inicializacion de arriba. */
                       /* Con dummy vacia o no vacia (definiendo o no CONDUMMYVACIA en 
                          fooInt.h) parece no importar donde esta la funcion main y no se 
                          de que depende que prevalezca alguno de los simbolo debiles. 
                          En ese caso parece prevalecer T Static_T::My=1 en main.cpp
                          en lugar de T Static_T::My=-1 en cpp3.cpp */
/*
El simbolo fuerte prevalece pero necesita que exista el debil en el archivo: i.e., al 
parecer solo se puede usar (el simbolo fuerte) en alcance de archivo y si se ha definido 
antes (en el mismo archivo) el simbolo debil.
*/
#else
//  //Static_T<int>::My=10;
//  Static_T<char*>::My[]={"UFF!"};
  Static_T<char*>::My[0]='_';
  Static_T<char*>::My[1]='_';
  Static_T<char*>::My[2]='a';
  Static_T<char*>::My[3]='\0';
#endif
}
#else
void dummy(){}
#endif

#ifdef CONMAIN_N_CPP3DOTCPP
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

//int fooInt=1;

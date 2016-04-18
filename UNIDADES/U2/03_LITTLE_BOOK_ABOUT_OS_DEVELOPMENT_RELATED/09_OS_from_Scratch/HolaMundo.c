typedef unsigned int uint;
#include "user.h"




int main(){
  int pid;
  printf(1, "Hola Mundo XV6!!\n");
  printf(1,"Antes de hacer syscall a fork(): getpid()=%d, candprocs()=%d\n",getpid(),candprocs());
  if((pid=fork()))/*codigo del padre*/
  {
    printf(1,"Soy el proceso %d, mi hijo es %d, candprocs()=%d\n",getpid(),pid,candprocs());
  }else
  {             /*codigo del hijo*/
    printf(1,"Soy el proceso hijo:getpid()=%d,candprocs()=%d\n",getpid(),candprocs());
  }
  //exit();
  while(!0);
}//end main()

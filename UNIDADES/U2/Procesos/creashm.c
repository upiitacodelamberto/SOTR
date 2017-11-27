/**creashm.c obtiene  una region de memoria que sera compartida
 * por mas de un proceso.
 */
#include <sys/ipc.h>
#include <sys/shm.h>
#include <stdio.h> /*printf()*/
#include <stdlib.h>	/*EXIT_FAILURE,EXIT_SUCCESS*/

int main(void)
{
  int intShmemget,intBufsize=4096;
  if((intShmemget=shmget(IPC_PRIVATE,intBufsize,0777))==-1){
    perror("shmget FAILURE!!!");
    exit(EXIT_FAILURE);
  }
  /*printf("Shared memory = %d\n",intShmemget);*/
  printf("%d",intShmemget);
/*
  char str[32];
  sprintf(str,"ipcs -m --id %d",intShmemget);
  system(str);
*/

  exit(EXIT_SUCCESS);
}/*end main()*/

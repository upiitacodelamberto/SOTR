/**sharedmem.c obtiene  una region de memoria que sera compartida
 * por mas de un proceso.
 */
#include <sys/ipc.h>
#include <sys/shm.h>
#include <stdio.h> /*printf()*/
#include <stdlib.h>	/*EXIT_FAILURE*/

int main(void)
{
  int intShmemget,intBufsize=4096;
  char *charPt=0;
  if((intShmemget=shmget(IPC_PRIVATE,intBufsize,0777))==-1){
    perror("shmget FAILURE!!!");
    exit(EXIT_FAILURE);
  }
  printf("Shared memory = %d\n",intShmemget);
  char str[32];
  sprintf(str,"ipcs -m --id %d",intShmemget);
  system(str);
  if((charPt=shmat(intShmemget,NULL,0777))<0){
    sprintf(str,"shmat FAILURE!, %d\n",intShmemget);
    perror(str);
    exit(EXIT_FAILURE);
  }
  sprintf(str,"ipcs -m --id %d",intShmemget);
  system(str);
  printf("Shared memory attached at %p\n",charPt);
  exit(EXIT_SUCCESS);
}//end main()

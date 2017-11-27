/**adjuntashm.c obtiene  una region de memoria que sera compartida
 * por mas de un proceso.
 */
#include <sys/ipc.h>
#include <sys/shm.h>
#include <stdio.h> /*printf()*/
#include <stdlib.h>	/*EXIT_FAILURE*/
#include <unistd.h>	/*pid_t fork(void), sleep(unsigned int)*/

int main(int argc,char *argv[])
{
  int intShmid;
  char *charPt=0;
  char str[32];
  int *intPt;
  pid_t pid;
/*
  if(argc<2){
    printf("Forma de uso: %s <identificador>",argv[0]);
    exit(EXIT_FAILURE);
  }
  intShmid=atoi(argv[1]);
*/
  scanf("%d",&intShmid);
  sprintf(str,"ipcs -m --id %d",intShmid);
  system(str);

  if((charPt=shmat(intShmid,NULL,0777))<0){
    sprintf(str,"shmat FAILURE!, %d\n",intShmid);
    perror(str);
    exit(EXIT_FAILURE);
  }
  sprintf(str,"ipcs -m --id %d",intShmid);
  system(str);
  printf("Shared memory attached at %p\n",charPt);
  intPt=(int*)charPt;
  *intPt=0;
  printf("*intPt=%d\n",*intPt);
  pid=fork();
  if(pid==0){/*Child*/
/*    while(!0){*/
      fflush(stdin);
      printf("Pulse una tecla!!!\n",*intPt);
      sleep(5);
      scanf("%c",str);
      if(str[0]=='q'){
        *intPt=*intPt+1;
      }
      printf("*intPt=%d",*intPt);
/*    }*/
  }else{/*Father*/
  }
  exit(EXIT_SUCCESS);
}/*end main()*/












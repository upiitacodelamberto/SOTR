/** varCompartida.c -- obtiene  una region de memoria que sera compartida
 *  por mas de un proceso. Se adjunta el segmento de memoria compartida y 
 *  en el, padre e hijo comparten una variable.
 */

#include <sys/ipc.h>
#include <sys/shm.h>
#include <stdio.h> 	/*printf()*/
#include <stdlib.h>	/*EXIT_FAILURE,EXIT_SUCCESS*/
#include <unistd.h>	/*pid_t fork(void), unsigned int sleep(unsigned int seconds)*/
#define chsemaph	*(intPt+1)
#define fasemaph	*(intPt+2)

int main(void)
{
  int intShmemget,intBufsize=4096;
  int intShmid;
  char *charPt=0;
  char str[32];
  int *intPt;
  pid_t pid;
  if((intShmemget=shmget(IPC_PRIVATE,intBufsize,0777))==-1){
    perror("shmget FAILURE!!!");
    exit(EXIT_FAILURE);
  }
  intShmid=intShmemget;
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
  chsemaph=0;
  fasemaph=1;
  *intPt=0;
  printf("*intPt=%d\n",*intPt);
  pid=fork();
  if(pid==0){/*Child*/
    while(!0){
/*      sleep(5);
      *intPt=*intPt+1;*/
      printf("CHILD before scanf! *intPt=%d\n",*intPt);
      while(!chsemaph);
      scanf("%c",str);
      fasemaph=1;
      chsemaph=0;
      printf("CHILD %c\n",str[0]);
      if(str[0]=='w'){
        *intPt=*intPt+1;
      }
      printf("CHILD after scanf! *intPt=%d\n",*intPt);
    }
  }else{/*Father*/
    while(!0){
/*      fflush(stdin);*/
      printf("FATHER --> Pulse una tecla!!!\n",*intPt);
      sleep(1);
      while(!fasemaph);
      scanf("%c",str);
      fasemaph=0;
      chsemaph=1;
      printf("FATHER %c\n",str[0]);
      if(str[0]=='q'){
        *intPt=*intPt+1;
      }
      printf("FATHER -->*intPt=%d\n",*intPt);
    }
  }
  exit(EXIT_SUCCESS);
}/*end main()*/












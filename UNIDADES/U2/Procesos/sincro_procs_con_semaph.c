#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/sem.h>
#include <stdio.h>
#include <stdlib.h>

int main(void)
{
  int semid;
  int nsems=1; /*cantidad de semaforos a crear*/
  int flags=0666;
  struct sembuf buf;	/*Comportamiento del semaforo*/
  semid=semget(IPC_PRIVATE,nsems,flags);
  if(semid<0){
    perror("semget()");
    exit(EXIT_FAILURE);
  }
  printf("Semaforo creado: %d\n",semid);
  
  /*Configuracion de la estructura*/
  buf.sem_num=0;	/*Un solo semaforo*/
  buf.sem_op=1;		/*Incrementa el valor del semaforo*/
  buf.sem_flg=IPC_NOWAIT;/*No lo bloquea*/
  if((semop(semid,&buf,nsems))<0){
    perror("semop()");
    exit(EXIT_FAILURE);
  }
  system("ipcs -s");
  exit(EXIT_SUCCESS);
}//end main()

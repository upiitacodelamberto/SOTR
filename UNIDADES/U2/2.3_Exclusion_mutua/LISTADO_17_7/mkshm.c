/**
 * mkshm.c Crea e inicia un segmento de memoria compartida
 * REFERENCIA: Programacion en Linux al Descubierto
 */
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <stdio.h>
#include <stdlib.h>

#define BUFSZ	4096	/*tamanio del segmento*/

int main(void)
{
  int shmid;
  if((shmid=shmget(IPC_PRIVATE,BUFSZ,0666))<0){
    perror("shmget");
    exit(EXIT_FAILURE);
  }
  printf("Segmento de memoria a compartir creado: %d\n",shmid);
  system("ipcs -m");

  exit(EXIT_SUCCESS);
}//end main()

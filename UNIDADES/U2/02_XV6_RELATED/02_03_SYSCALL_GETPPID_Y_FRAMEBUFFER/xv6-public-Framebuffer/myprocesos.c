//#include <stdio.h>
//#include <unistd.h>
//#include <stdlib.h>
#include "types.h"
#include "user.h"  /* printf(), fork() */


int main(){
  printf(1,"PID=%d\n", getpid());
  uint pid=fork();
  switch(pid){
    case 0:{   /* codigo del proceso hijo */
      printf(1,"(%d): soy hijo de %d\n", getpid(), getppid());
      break;
    }
    default:{  /* codigo del proceso padre */
      printf(1,"(%d): soy el padre de %d y soy hijo de %d\n", getpid(), pid, getppid());
      switch(fork()){
        case 0:{   /*  si estamos en el segundo hijo */
          printf(1,"(%d): soy hijo de %d\n", getpid(), getppid());
          break;
        }
        default:{
          printf(1, "Cantidad de procesos: %d\n", getprocs());
          break;
        }
      }
      break;
    }
  }
      while(1);
  //exit(0);
  exit();
}// end main()

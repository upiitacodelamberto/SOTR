#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>	/*fork(), man 2 fork*/

int  main(){
  int intA=10;
  int pid,ppid;
  if((pid=fork())>0){//Si somos el Padre
    printf("Mi hijo es %d, intA=%d\n",pid,intA);
    intA++;
    printf("Mi hijo es %d, intA=%d\n",pid,intA);
    pid=getpid();
    ppid=getppid();
    printf("Proceso %d\n",pid);
    printf("Proceso padre %d\n",ppid);
  }else{//Si somos el hijo
    printf("intA=%d\n",intA);
    intA+=10;
    printf("intA=%d\n",intA);
  }
  while(!0){ }
  return 0;
}

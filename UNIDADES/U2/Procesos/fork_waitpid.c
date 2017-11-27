#include <stdio.h>	/*printf()*/
#include <sys/types.h>  /*pid_t,pid_t wait(int *status),*//*man 2 waitpid*/
#include <sys/wait.h>	/*pid_t waitpid(pid_t pid,int *wstatus,int options)*/
#include <unistd.h>	/*pid_t fork(void),man 2 fork*/

int main(int argc,char *argv[])
{
  pid_t pid;
  int intA;
  if((pid=fork())==0){/*hijo*/
    printf("Teclea un entero: ");
    scanf("%d",&intA);
//    intA=(intA<0)?-intA:intA;
//    return intA%2;/* 1 si impar, 0 si par*/
    return intA;
  }else{/*padre*/
    waitpid(pid,&intA,WUNTRACED|WCONTINUED);
    if(WIFEXITED(intA)){
      printf("intA=%d\n",intA=WEXITSTATUS(intA));
//      printf("El hijo dice que Ud. tecleo un ");
      printf("Ud. tecleo un ");
//      if(intA)
    if(intA%2)
        printf("impar.\n");
      else
        printf("par.\n");
    }else{
      printf("WIFEXITED(intA) devolvio false!!!!!\n");
    }
  }
  return 0;
}/*end main()*/

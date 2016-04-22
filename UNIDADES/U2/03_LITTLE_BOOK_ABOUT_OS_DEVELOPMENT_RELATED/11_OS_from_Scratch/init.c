// init: The initial user-level program

#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"
#include "osHeader.h"

char *argv[] = { "sh", 0 };
//La version de las llamadas al sistema por ejemplo 
//para: int createTask(int iPriority,int iTaskId,char *arg[]), 
//int startTask(int TaskId), int waitTask(void) y int Sched(void)
//para el kernel son las que estan resueltas en tareas.c mientras 
//que para los programas de usuario la version de las mismas 
//llamadas al sistema: 
//int createTask(int iPriority,int iTaskId,char *arg[]), 
//int startTask(int TaskId), int waitTask(void) y int Sched(void) 
//son las funciones que estan resueltas en usys.S que forman parte 
//de la biblioteca de usuario ULIB y cuyos prototipos se ponen a 
//disposicion de los programas de usuario a traves del archivo de 
//cabecera user.h

//Solo para corregir error de compilacion
//de este archivo (vease int sys_createTask(void) 
//en sysproc.c)   2016.04.01
char *argv1[] = { "TaskId_1", 0 };
char *argv2[] = { "TaskId_2", 0 };

int
main(void)
{
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  dup(0);  // stderr

  //createTask(1, TaskId_1,argv1);
  //createTask(2, TaskId_2,argv2);
  for(;;){
    /*Este mensaje solo se muestra una vez*/
    /*Por lo que aunque este ciclo for es infinito, 
      en realidad parece ejecutarse solo una vez.*/
    printf(1, "init: starting sh\n");
    pid = fork();
    if(pid < 0){
      printf(1, "init: fork failed\n");
      exit();
    }
    if(pid == 0){
//20160401
      printf(1,"En el proceso hijo de init:exec(\"sh\", argv);\n");
      exec("sh", argv);
//      Sched();

      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  }
}


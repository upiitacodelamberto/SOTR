#include <malloc.h>
#include "osHeader.h"
struct TaskTable arrTaskTable[3];
int iTaskcount;
int PriorityTable[3];
int iHighPriorityTask;
int iIndexPriority;

void startOS(){
  //Call Sched
  Sched();
}

/**
 Busca la tarea con minimo atributo priority que este lista para correr y la llama.
*/
void Sched(){
  int iIndex, i, j;
  int **estado=(int **)malloc(iTaskcount*sizeof(int*));
  for(iIndex=0; iIndex<iTaskcount;iIndex++)estado[iIndex]=(int*)malloc(2*sizeof(int));

  //Select task with high priority
  iHighPriorityTask = 10;
  /* Este for guarda en iIndexPriority el min\{ arrTaskTable[0].Priority, arrTaskTable[1].Priority, ...\}*/
  for(iIndex = 0; iIndex < iTaskcount; iIndex++){//Si la tarea en arrTaskTable[iIndex] tiene prioridad <= iHighPriorityTask Y esta lista para correr
    estado[iIndex][0]=arrTaskTable[iIndex].Priority;
    estado[iIndex][1]=arrTaskTable[iIndex].Ready;
    if((arrTaskTable[iIndex].Priority <= iHighPriorityTask) &&
                            (arrTaskTable[iIndex].Ready == 1)){
      iHighPriorityTask = arrTaskTable[iIndex].Priority;//iHighPriorityTask se hace igual a su prioridad.
      iIndexPriority = iIndex;//En iIndexPriority guardamos el indice de la tarea (posicion de la tarea).
    }
  }
  printf("Id\t\tPriority\tReady\n");
  for(i=0;i<iTaskcount;i++)
      printf("TaskId_%i\t%i\t\t%i\n", i+1, estado[i][0], estado[i][1]);

  //Call task with high priority
  (*arrTaskTable[iIndexPriority].ptrTask) ();//se llama a la tarea ``seleccionada'' arrTaskTable[iIndexPriority]

}

void createTask(void (*ptrTask)(void), int iPriority, int iTaskId){
  //Save priority
  arrTaskTable[iTaskcount].Priority = iPriority;

  //Save task address
  arrTaskTable[iTaskcount].ptrTask = ptrTask;

  //Save task ID
  arrTaskTable[iTaskcount].TaskId = iTaskId;

  //Make the task ready
  arrTaskTable[iTaskcount].Ready = 1;

  //Increment iTaskcount
  iTaskcount ++;
}//end createTask()

void waitTask(){
  arrTaskTable[iIndexPriority].Ready = 0;

  //Call Sched
  Sched();
}

void startTask(int TaskId){
  int iIndex;

  for(iIndex = 0; iIndex < iTaskcount; iIndex++){
    if(TaskId == arrTaskTable[iIndex].TaskId){
      arrTaskTable[iIndex].Ready = 1;
    }
  }

  //Call Sched
/*  Sched();*/
}

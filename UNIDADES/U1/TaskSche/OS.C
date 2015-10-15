#include <stdlib.h>
#include "osHeader.h"
#include "sst.h"
#include "sst_exa.h"
#include "sst_port.h"
#define KBD_VECTOR 0x09


struct TaskTable arrTaskTable[3];
int iTaskcount;
int PriorityTable[3];
int iHighPriorityTask;
int iIndexPriority;
uint8_t KEY=0x00;
static void interrupt(*l_dosKbdISR)();
static void interrupt kbdISR();
void SST_exit();

void startOS(){
  //Call Sched
  l_dosKbdISR=getvect(KBD_VECTOR);
  SST_INT_LOCK();
  setvect(KBD_VECTOR,&kbdISR);
  SST_INT_UNLOCK();
  Sched();
}

/**
 Busca la tarea con minimo atributo priority que este lista para correr y la llama.
*/
void Sched(){
  int iIndex, i, j;
//  int **estado=(int **)malloc(iTaskcount*sizeof(int*));
//  for(iIndex=0; iIndex<iTaskcount;iIndex++)estado[iIndex]=(int*)malloc(2*sizeof(int));

  //Select task with high priority
  iHighPriorityTask = 10;
  /* Este for guarda en iIndexPriority el min\{ arrTaskTable[0].Priority, arrTaskTable[1].Priority, ...\}*/
  for(iIndex = 0; iIndex < iTaskcount; iIndex++){//Si la tarea en arrTaskTable[iIndex] tiene prioridad <= iHighPriorityTask Y esta lista para correr
//    estado[iIndex][0]=arrTaskTable[iIndex].Priority;
//    estado[iIndex][1]=arrTaskTable[iIndex].Ready;
    if((arrTaskTable[iIndex].Priority <= iHighPriorityTask) &&
			    (arrTaskTable[iIndex].Ready == 1)){
      iHighPriorityTask = arrTaskTable[iIndex].Priority;//iHighPriorityTask se hace igual a su prioridad.
      iIndexPriority = iIndex;//En iIndexPriority guardamos el indice de la tarea (posicion de la tarea).
    }
  }
//  printf("Id\t\tPriority\tReady\n");
//  for(i=0;i<iTaskcount;i++)
//      printf("TaskId_%i\t%i\t\t%i\n", i+1, estado[i][0], estado[i][1]);

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

static void interrupt kbdISR() {
    uint8_t pin;
    uint8_t key = inport(0x60);/* get scan code from the 8042 kbd controller */
    KEY=key;
    //displayPreemptions(SST_currPrio_, KBD_ISR_PRIO); /* for testing, NOTE01 */
    //SST_ISR_ENTRY(pin, KBD_ISR_PRIO);

    SST_ISR_ENTRY();
    printf("ESTAMOS AQUI!!");
    //SST_post(KBD_TASK_PRIO, KBD_SIG, key);   /* post the Key to the KbdTask */

    //busyDelay();                                 /* for testing, see NOTE02 */
    //SST_ISR_EXIT(pin, outportb(0x20, 0x20));
    SST_ISR_EXIT(outportb(0x20,0x20));
}

void SST_exit(){
 SST_INT_LOCK();
 setvect(KBD_VECTOR,l_dosKbdISR);
 SST_INT_UNLOCK();
 _exit(0);
}
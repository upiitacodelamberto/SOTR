#include "types.h"
#include "user.h"
#include "osHeader.h"

struct TaskTable arrTaskTable[3];
int iTaskcount;
int PriorityTable[3];
int iHighPriorityTask;
int iIndexPriority;

int createTask(int iPriority,int iTaskId,char *arg[]){
  //Save priority
  arrTaskTable[iTaskcount].Priority = iPriority;

  //Save task address
//  arrTaskTable[iTaskcount].ptrTask = ptrTask;

  //Save task ID
  arrTaskTable[iTaskcount].TaskId = iTaskId;

  //Make the task ready
  arrTaskTable[iTaskcount].Ready = 1;

  arrTaskTable[iTaskcount].argv[0]=arg[0];
  arrTaskTable[iTaskcount].argv[1]=arg[1];

  //Increment iTaskcount
  iTaskcount ++;

  return 0;
}//end createTask()

int startTask(int TaskId){
  int iIndex;

  for(iIndex = 0; iIndex < iTaskcount; iIndex++){
    if(TaskId == arrTaskTable[iIndex].TaskId){
      arrTaskTable[iIndex].Ready = 1;
    }
  }

  //Call Sched
  Sched();
  return 0;
}

int waitTask(void){
  arrTaskTable[iIndexPriority].Ready = 0;
  Sched();
  return 0;
}

int Sched(void){
  int iIndex;

  //Select task with high priority
  iHighPriorityTask = 10;

  for(iIndex = 0; iIndex < iTaskcount; iIndex++){
    if((arrTaskTable[iIndex].Priority <= iHighPriorityTask) &&
                            (arrTaskTable[iIndex].Ready == 1)){
      iHighPriorityTask = arrTaskTable[iIndex].Priority;
      iIndexPriority = iIndex;
    }
  }

  //Call task with high priority
//  (*arrTaskTable[iIndexPriority].ptrTask) ();
  exec(arrTaskTable[iIndexPriority].argv[0],arrTaskTable[iIndexPriority].argv);
  return 0;
}

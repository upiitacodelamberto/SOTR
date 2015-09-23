#include "osHeader.h"

void startOS(){
  //Call Sched
  Sched();
}

void Sched(){
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
  (*arrTaskTable[iIndexPriority].ptrTask) ();

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
}

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
  Sched();
}

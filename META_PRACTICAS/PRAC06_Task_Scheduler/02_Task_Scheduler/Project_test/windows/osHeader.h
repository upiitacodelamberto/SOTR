#ifndef OSHEADER_H_
#define OSHEADER_H_

#define TaskId_1	10
#define TaskId_2	20
#define TaskId_3	30

struct TaskTable{
  void (*ptrTask) (void);
  int Priority;
  int Ready;
  int TaskId;
//}arrTaskTable[3];
};

//int iTaskcount;

//int PriorityTable[3];
//int iHighPriorityTask;
//int iIndexPriority;

void Sched();
void Task1();
void Task2();
void Task3();
void createTask(void (*ptrTask)(void), int iPriority, int iTaskId);
void startOS();
void waitTask();
void startTask(int TaskId);
#endif /* OSHEADER_H_ */

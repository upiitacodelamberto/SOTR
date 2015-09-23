#ifndef OSHEADER_H_
#define OSHEADER_H_

#define TaskId_1	10
#define TaskId_2	20

struct TaskTable{
  void (*ptrTask) (void);
  int Priority;
  int Ready;
  int TaskId;
}arrTaskTable[3];

int iTaskcount;

int PriorityTable[3];
int iHighPriorityTask;
int iIndexPriority;

void Sched();
void Task1();
void Task2();
#endif /* OSHEADER_H_ */

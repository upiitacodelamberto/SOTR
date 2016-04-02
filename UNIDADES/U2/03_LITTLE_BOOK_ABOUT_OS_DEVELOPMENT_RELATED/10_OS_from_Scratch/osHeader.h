#ifndef OSHEADER_H_
#define OSHEADER_H_

#define TaskId_1	10
#define TaskId_2	20

struct TaskTable{
//  void (*ptrTask) (void);  /*no se esta usando 2016.04.01*/
  char *argv[2];             /*20160401*/
  int Priority;
  int Ready;
  int TaskId;
};


//void Task1();
//void Task2();
//void createTask(void (*ptrTask)(void), int iPriority, int iTaskId,char *arg[]);
//void startOS();
//void waitTask();
//void startTask(int TaskId);
#endif /* OSHEADER_H_ */

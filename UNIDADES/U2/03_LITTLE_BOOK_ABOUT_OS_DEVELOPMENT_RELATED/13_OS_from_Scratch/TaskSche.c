typedef unsigned int uint;
#include "user.h"
#include "osHeader.h"
char *argv1[] = { "TaskId_1", 0 };
char *argv2[] = { "TaskId_2", 0 };

int main(){
  createTask(1, TaskId_1,argv1);
  createTask(2, TaskId_2,argv2);
  Sched();
  exit();
}

typedef unsigned int uint;
#include "user.h"
#include "osHeader.h"

int main(){
  static int dummy2=0;
  printf(1,"I am task 2 dummy2=%d. Actualmente hay %d procesos\n", dummy2,candprocs());
  //wait
  sleep(100);//? sec
  dummy2++;
  //start the task
  startTask(TaskId_1);
  exit();
}

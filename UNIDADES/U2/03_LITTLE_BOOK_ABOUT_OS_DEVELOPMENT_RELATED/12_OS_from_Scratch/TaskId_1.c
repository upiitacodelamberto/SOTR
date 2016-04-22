typedef unsigned int uint;
#include "fcntl.h"
#include "osHeader.h"
#include "user.h"

int main(){
  if(open("console", O_RDWR) < 0){
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  dup(0);  // stderr

  printf(1,"I am task 1. Actualmente hay %d procesos\n",candprocs());
  //wait
  sleep(100);
  //stop the task
  waitTask();
  exit();
}

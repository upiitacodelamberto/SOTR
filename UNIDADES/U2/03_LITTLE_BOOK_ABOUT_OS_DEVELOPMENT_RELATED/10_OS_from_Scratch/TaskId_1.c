typedef unsigned int uint;
#include "osHeader.h"
#include "user.h"

int main(){
  printf(1,"I am task 1\n");
  //wait
  sleep(100);
  //stop the task
  waitTask();
  exit();
}

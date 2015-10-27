#include "types.h"
#include "user.h"

int main(){
  printf(1, "%d (father) says: Currently running processes: %d\n", getpid(), getprocs());
  if(fork()){//in father
    wait();
    printf(1, "%d (father) says: Currently running processes: %d\n", getpid(), getprocs());
  }else{//in child
    printf(1, "%d (child) says: currently running processes: %d\n", getpid(), getprocs());
  }
  exit();
}//end main()

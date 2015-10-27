#include "types.h"
#include "user.h"
//#include "mmu.h"
//#include "param.h"
//#include "proc.h"

int main(void){
//  printf(1, "HOLA ncpus=%d\n", getprocs());
  printf(1, "Currently running processes: %d\n", getprocs());
  exit();
}

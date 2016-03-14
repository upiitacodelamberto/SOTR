#include "types.h"
#include "scrn.h"

/*int main(void){*/
void kmain(void){
  /*do some work here, like initialize timer or paging*/
  vga_init();
  puts((uint8_t*)"Hello world!");
  for(;;);/*start infinite loop*/
}

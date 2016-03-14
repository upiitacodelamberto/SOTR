#include "types.h"
#include "defs.h"
#include "defs.h"
#include "scrn.h"

/*int main(void){*/
void kmain(void){
  /*do some work here, like initialize timer or paging*/
  vga_init();
  puts((uint8_t*)"Hello world!");

  gdt_descriptor();
  for(;;);/*start infinite loop*/
}

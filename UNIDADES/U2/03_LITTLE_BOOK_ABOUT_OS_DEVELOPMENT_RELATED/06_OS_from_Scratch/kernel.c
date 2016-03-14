#include "types.h"
#include "defs.h"
#include "defs.h"
#include "scrn.h"

/*int main(void){*/
void kmain(void){
  /*do some work here, like initialize timer or paging*/
  vga_init();
  puts((uint8_t*)"Hello kernel world!\n");

  gdt_descriptor();
  puts((uint8_t*)"GDT initialized...\n");
  idt_descriptor();
  puts((uint8_t*)"IDT initialized...\n");
  cprintf("IDT initialized...\n");
  for(;;);/*start infinite loop*/
}

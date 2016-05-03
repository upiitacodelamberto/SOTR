#include "types.h"
/*We use inbyte for reading from the I/O portsto get data from 
  devices such as the keyboard, to do so we need the 'inb' instruction, 
  which is only accesible from assembly. So the C function is simply a 
  wrapper around a single assembly instruction */
uint8_t inbyte(uint16_t port){
  uint8_t ret;
  __asm__ __volatile__ ("inb %1,%0" : "=a"(ret) : "d"(port));
  return ret;
}

/*We use outbyte to write to I/O ports, i.e. to send bytes to 
  devices. Again we use inline assembly for the stuff that can not be 
  done in C*/
void outbyte(uint16_t port,uint8_t dato){
  __asm__ __volatile__ ("outb %1,%0" : : "d"(port),"a"(dato));
}

void sti(void){
  __asm__ __volatile__ ("sti");
}

void cli(void){
  __asm__ __volatile__ ("cli");
}

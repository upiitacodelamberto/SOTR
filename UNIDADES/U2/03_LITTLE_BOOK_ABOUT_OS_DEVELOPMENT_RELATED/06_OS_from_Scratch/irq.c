#include "types.h"
#include "basicio.h"
#define inportb inbyte 
#define outportb  outbyte
int timer_ticks;

/* Handles the timer (irq0). In this case, ot's very simple: We 
 * increment the 'timer_ticks' variable every time the 
 * timer fires. by default, the timer fires 18.222 times 
 * per second. */
void timer_handler(void){
  /*Increment our 'tick count'*/
  timer_ticks++;

  /*Every 18 clocks (approximately 1 second), we will 
   *do something*/
  if(timer_ticks % 18 == 0){
    /*do whatever you want*/
  }
}

/*set timer phase*/
void timer_phase(int hz){
  int divisor=1193180/hz;      /*Calculate our divisor*/
  outportb(0x43,0x36);         /*Set our command byte 0x36*/
  outportb(0x40,divisor&0xFF); /*Set low byte of divisor*/
  outportb(0x40,divisor>>8);   /*Set higt byte of divisor*/
}

#include "types.h"
#include "basicio.h"
#define PIC1  0x20
#define PIC2  0xA0
#define PIC1e  (PIC1 + 1)
#define PIC2e  (PIC2 + 1)
#define ICW1  0x11
#define ICW4  0x01
#define PICenable  0x00
#define PICdisable  0xff
#define inportb inbyte 
#define outportb  outbyte


/*enable all passible IRQ interrupts*/
void enableIRQ(void){
  outportb(PIC1e,PICenable);
  outportb(PIC2e,PICenable);
  sti();
}

/*disable all IRQs*/
void disableIRQ(void){
  outportb(PIC1e,PICdisable);
}

/* init_pics()
 * init the PICs and remap the,
 */
static void init_pics(int pic1,int pic2){
  /*send ICW1*/
  outportb(PIC1,ICW1);
  outportb(PIC2,ICW1);

  /*send ICW2*/
  outportb(PIC1e,pic1); /*remap*/
  outportb(PIC2e,pic2);

  /*send ICW3*/
  outportb(PIC1e,4); /*IRQ2 -> connection to slave*/
  outportb(PIC2e,2);

  /*send ICW4*/
  outportb(PIC1e,ICW4);
  outportb(PIC2e,ICW4);
}

/*remap IRQs to 0x20-0x2f*/
void remap_pics(void){
  init_pics(0x20,0x28);
  enableIRQ();
}

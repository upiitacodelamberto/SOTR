#include  "TM4C123.h"            /* Device header */
void delay_ms(void);

int main(){
  SYSCTL->RCGCGPIO|=(0x01)<<5;     // enable clock to GPIOF
//  GPIOF->DEN|=0xFF;             // eight bits as digital
  GPIOF->DEN|=(0x1<<1)|(0x1<<2)|(0x1<<3);//Activamos pin F1 F2 F3
  GPIOF->DIR|=(0x1<<1)|(0x1<<2)|(0x1<<3);// out configuration
  for(;;){
    GPIOF->DATA|=0x06;
//    GPIOF->DATA=0xF;
    delay_ms();
    GPIOF->DATA&=0x11;
//    GPIOF->DATA=0x0;
    delay_ms();
  }
  return 0;
}//end main() 

void delay_ms(void){
	int a=0, i;
	//for(i=0; i<500000; i++){
	for(i=0; i<4000000; i++){
		 a++;
	}
}

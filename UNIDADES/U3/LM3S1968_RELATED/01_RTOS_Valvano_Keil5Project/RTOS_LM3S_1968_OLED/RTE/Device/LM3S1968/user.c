//*****************************************************************************
// Real Time Operating System 

/* This example accompanies the book
   "Embedded Systems: Real Time Interfacing to the Arm Cortex M3",
   ISBN: 978-1463590154, Jonathan Valvano, copyright (c) 2011

   Programs 6.4 through 6.12, section 6.2

 Copyright 2011 by Jonathan W. Valvano, valvano@mail.utexas.edu
    You may use, edit, run or distribute this file
    as long as the above copyright notice remains
 THIS SOFTWARE IS PROVIDED "AS IS".  NO WARRANTIES, WHETHER EXPRESS, IMPLIED
 OR STATUTORY, INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE APPLY TO THIS SOFTWARE.
 VALVANO SHALL NOT, IN ANY CIRCUMSTANCES, BE LIABLE FOR SPECIAL, INCIDENTAL,
 OR CONSEQUENTIAL DAMAGES, FOR ANY REASON WHATSOEVER.
 For more information about my classes, my research, and my books, see
 http://users.ece.utexas.edu/~valvano/
 */
 
#include <stdio.h>
#include "Output.h"
#include "inc/hw_types.h"
#include "os.h"



//#define TIMESLICE               TIME_2MS    // thread switch time in system time units
//#define TIMESLICE               TIME_10MS    // thread switch time in system time units
#define TIMESLICE               TIME_20MS    // thread switch time in system time units
//#define TIMESLICE               TIME_100MS    // thread switch time in system time units


//
//*******************Initial TEST**********
// This is the simplest configuration, test this first
// run this with
// no UART interrupts
// no SYSTICK interrupts
// no timer interrupts
// no select interrupts
// no ADC serial port or oLED output
// no calls to semaphores
//unsigned long Count1;   // number of times thread1 loops
//unsigned long Count2;   // number of times thread2 loops
//unsigned long Count3;   // number of times thread3 loops
unsigned int Count1;   // number of times thread1 loops
unsigned int Count2;   // number of times thread2 loops
unsigned int Count3;   // number of times thread3 loops
#define GPIO_PORTD_DIR_R        (*((volatile unsigned long *)0x40007400))
#define GPIO_PORTD_DEN_R        (*((volatile unsigned long *)0x4000751C))
#define GPIO_PORTD1             (*((volatile unsigned long *)0x40007008))
#define GPIO_PORTD2             (*((volatile unsigned long *)0x40007010))
#define GPIO_PORTD3             (*((volatile unsigned long *)0x40007020))
#define SYSCTL_RCGC2_R          (*((volatile unsigned long *)0x400FE108))   /* LM3S1968 */
#define SYSCTL_RCGC2_GPIOD      0x00000008  // port D Clock Gating Control

#define GPIO_PORTD1     (*((volatile unsigned long *)0x40007008))
#define GPIO_PORTD2     (*((volatile unsigned long *)0x40007010))
#define GPIO_PORTD3     (*((volatile unsigned long *)0x40007020))

// delay function for testing from sysctl.c
// which delays 3*ulCount cycles
#ifdef __TI_COMPILER_VERSION__
	//Code Composer Studio Code
	void Delay(unsigned long ulCount){
	__asm (	"    subs    r0, #1\n"
			"    bne     Delay\n"
			"    bx      lr\n");
}

#else
	//Keil uVision Code
__asm void 
	Delay(unsigned long ulCount)
		  {
    subs    r0, #1
    bne     Delay
    bx      lr
}

#endif
// function definitions in osasm.s
void OS_DisableInterrupts(void);
void OS_EnableInterrupts(void);
long StartCritical(void);
void EndCritical(long primask);

void Task1(void){
	long st1;
  Count1 = 0;
      //printf("Task 1 first time");
	    //printf("%c", NEWLINE);
  for(;;){
    Count1++;
    //GPIO_PORTD1 ^= 0x02;      // toggle PD1
		if(Count1<5){
			st1=StartCritical();
      printf("Task 1 Count1:%u",Count1);
	    printf("%c", NEWLINE);
			EndCritical(st1);
			Delay(500000);
			//Delay(250000);
			//Delay(125000);
			//Delay(62500);
			//Delay(31250);
		}
  }
}
void Task2(void){
	long st2;
  Count2 = 0;
      //printf("Task 2 first time");
	    //printf("%c", NEWLINE);
  for(;;){
    Count2++;
//    GPIO_PORTD2 ^= 0x04;      // toggle PD2
		if(Count2<3){
			st2=StartCritical();
      printf("Task 2 Count2:%u",Count2);
	    printf("%c", NEWLINE);
			EndCritical(st2);
		}
  }
}
void Task3(void){
	long st3;
  Count3 = 0;
      //printf("Task 3 first time");
	    //printf("%c", NEWLINE);
  for(;;){
    Count3++;
 //   GPIO_PORTD3 ^= 0x08;      // toggle PD3
		if(Count3<3){
			st3=StartCritical();
      printf("Task 3 Count3:%u",Count3);
	    printf("%c", NEWLINE);
			EndCritical(st3);
		}
  }
}
int main(void){  // testmain2
  OS_Init();           // initialize, disable interrupts
	//Output_Init();
  Output_Color(15);
	//printf("HolaMundo!! 20151226");
	//printf("%c", NEWLINE);
//  SYSCTL_RCGC2_R |= SYSCTL_RCGC2_GPIOD; // activate port D
//  GPIO_PORTD_DIR_R |= 0x0E;   // make PD3-1 out
//  GPIO_PORTD_DEN_R |= 0x0E;   // enable digital I/O on PD3-1
	//printf("Before OS_AddThreads()!! 20151227");
	//printf("%c", NEWLINE);
  OS_AddThreads(&Task1, &Task2, &Task3);
	//printf("After OS_AddThreads()");
	//printf("%c", NEWLINE);
  OS_Launch(TIMESLICE); // doesn't return, interrupts enabled in here
  return 0;             // this never executes
}

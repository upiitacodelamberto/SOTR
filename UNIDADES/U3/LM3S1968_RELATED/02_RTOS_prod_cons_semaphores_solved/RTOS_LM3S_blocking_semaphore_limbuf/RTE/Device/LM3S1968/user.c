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
// function definitions in osasm.s
void OS_DisableInterrupts(void);
void OS_EnableInterrupts(void);
long StartCritical(void);
void EndCritical(long primask);

//#define TIMESLICE               TIME_2MS    // thread switch time in system time units
//#define TIMESLICE               TIME_10MS    // thread switch time in system time units
#define TIMESLICE               TIME_20MS    // thread switch time in system time units
//#define TIMESLICE               TIME_100MS    // thread switch time in system time units

unsigned int Count1;   // number of times thread1 loops
unsigned int Count2;   // number of times thread2 loops
unsigned int Count3;   // number of times thread3 loops

// three semaphores used to solve producer-consumer problem
long RoomLeft;
long CurrentSize;
long mutex;

/* Required function prototypes */
/* Data sink and source functions */
DataType produce_item(void);
void consume_item(DataType item);
/* buffer/FIFO functions */
void enter_item(DataType);
void remove_item(DataType*);

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

/* Producer thread function */
void producer(void){
  DataType item;
	Count1=0;
	//long st;
  while(1){
		Count1++;
    item=produce_item();
    OS_Wait(&RoomLeft);
    OS_Wait(&mutex);
    enter_item(item);
		//st=StartCritical();
		if(Count1<5){
		  printf("Produced=%u",item);
		  printf("%c",NEWLINE);
		}
		//EndCritical(st);
    OS_Signal(&mutex);
    OS_Signal(&CurrentSize);
		//Delay(500000);
		//Delay(250000);
		//Delay(125000);
		//Delay(62500);
		//Delay(31250);
  }
}
/* Consumer thread function */
void consumer(void){
  DataType item;
	Count2=0;
  while(1){
		//Delay(500000);
		Delay(250000);
		//Delay(125000);
		//Delay(62500);
		//Delay(31250);
		Count2++;
    OS_Wait(&CurrentSize);
    OS_Wait(&mutex);
    remove_item(&item);
    OS_Signal(&mutex);
    OS_Signal(&RoomLeft);
		if(Count2<4){
      consume_item(item);
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
		if(Count3<4){
			st3=StartCritical();
      printf("Task 3 Count3:%u",Count3);
	    printf("%c", NEWLINE);
			EndCritical(st3);
		}
  }
}
int main(void){  // testmain2
  OS_Init();           // initialize, disable interrupts
  Output_Init();              // initialize OLED
  Output_Color(15);
	// Inicialization of semaphores, the FIFO is initialized in file os.c
  OS_Semaphore_Init(&RoomLeft,FIFOSIZE); // sinchronizatization semaphore
	OS_Semaphore_Init(&CurrentSize,0);     // sinchronizatization semaphore
	OS_Semaphore_Init(&mutex,1);           // binary semaphore
  OS_AddThreads(&producer, &consumer, &Task3);
  OS_Launch(TIMESLICE); // doesn't return, interrupts enabled in here
  return 0;             // this never executes
}


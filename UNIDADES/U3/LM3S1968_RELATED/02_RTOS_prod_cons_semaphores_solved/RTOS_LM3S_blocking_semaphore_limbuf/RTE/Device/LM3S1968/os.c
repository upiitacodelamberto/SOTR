// filename **********OS.C***********
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
#include "os.h"
#include "Output.h"
#include "inc/hw_types.h"
#include "driverlib/sysctl.h"

#define SYSCTL_RCGC2_R          (*((volatile unsigned long *)0x400FE108))
#define SYSCTL_RCGC2_GPIOC      0x00000004  // port C Clock Gating Control
#define NVIC_ST_CTRL_R          (*((volatile unsigned long *)0xE000E010))
#define NVIC_ST_CTRL_CLK_SRC    0x00000004  // Clock Source
#define NVIC_ST_CTRL_INTEN      0x00000002  // Interrupt enable
#define NVIC_ST_CTRL_ENABLE     0x00000001  // Counter mode
#define NVIC_ST_RELOAD_R        (*((volatile unsigned long *)0xE000E014))
#define NVIC_ST_CURRENT_R       (*((volatile unsigned long *)0xE000E018))
#define NVIC_INT_CTRL_R         (*((volatile unsigned long *)0xE000ED04))
#define NVIC_INT_CTRL_PENDSTSET 0x04000000  // Set pending SysTick interrupt
#define NVIC_SYS_PRI3_R         (*((volatile unsigned long *)0xE000ED20))  // Sys. Handlers 12 to 15 Priority
// function definitions in osasm.s
void OS_DisableInterrupts(void); // Disable interrupts
void OS_EnableInterrupts(void);  // Enable interrupts
long StartCritical(void);
void EndCritical(long primask);
void StartOS(void);

#define NUMTHREADS  3        // maximum number of threads
#define STACKSIZE   100      // number of 32-bit words in stack
struct tcb{
  long *sp;          // pointer to stack (valid for threads not running
  struct tcb *next;  // linked-list pointer
	long *status;        // the second implementation, page 176.
};
typedef struct tcb tcbType;
tcbType tcbs[NUMTHREADS];
tcbType *RunPt;
long Stacks[NUMTHREADS][STACKSIZE];

DataType volatile *PutPt;   // put next
DataType volatile *GetPt;   // get next

// ******** OS_Init ************
// initialize operating system, disable interrupts until OS_Launch
// initialize OS controlled I/O: serial, ADC, systick, select switch and timer2 
// input:  none
// output: none
void OS_Init(void){  
  OS_DisableInterrupts();   // set processor clock to 50 MHz
//  SysCtlClockSet(SYSCTL_SYSDIV_4 | SYSCTL_USE_PLL |
//                 SYSCTL_XTAL_6MHZ | SYSCTL_OSC_MAIN);
  SysCtlClockSet(SYSCTL_SYSDIV_4 | SYSCTL_USE_PLL |
                 SYSCTL_XTAL_8MHZ | SYSCTL_OSC_MAIN);
	// set processor clock to 10 MHz
  //SysCtlClockSet(SYSCTL_SYSDIV_20 | SYSCTL_USE_PLL | SYSCTL_OSC_MAIN |
  //                 SYSCTL_XTAL_8MHZ);
  Fifo_Init();                // initialize the FIFO
  NVIC_ST_CTRL_R = 0;         // disable SysTick during setup
  NVIC_ST_CURRENT_R = 0;      // any write to current clears it
  NVIC_SYS_PRI3_R =(NVIC_SYS_PRI3_R&0x00FFFFFF)|0xE0000000; // priority 7
}

void SetInitialStack(int i){
  tcbs[i].sp = &Stacks[i][STACKSIZE-16]; // thread stack pointer
  Stacks[i][STACKSIZE-1] = 0x01000000;   // thumb bit
  Stacks[i][STACKSIZE-3] = 0x14141414;   // R14
  Stacks[i][STACKSIZE-4] = 0x12121212;   // R12
  Stacks[i][STACKSIZE-5] = 0x03030303;   // R3
  Stacks[i][STACKSIZE-6] = 0x02020202;   // R2
  Stacks[i][STACKSIZE-7] = 0x01010101;   // R1
  Stacks[i][STACKSIZE-8] = 0x00000000;   // R0
  Stacks[i][STACKSIZE-9] = 0x11111111;   // R11
  Stacks[i][STACKSIZE-10] = 0x10101010;  // R10
  Stacks[i][STACKSIZE-11] = 0x09090909;  // R9
  Stacks[i][STACKSIZE-12] = 0x08080808;  // R8
  Stacks[i][STACKSIZE-13] = 0x07070707;  // R7
  Stacks[i][STACKSIZE-14] = 0x06060606;  // R6
  Stacks[i][STACKSIZE-15] = 0x05050505;  // R5
  Stacks[i][STACKSIZE-16] = 0x04040404;  // R4
}
int OS_AddThreads(void(*task0)(void),
                 void(*task1)(void), 
                 void(*task2)(void)){ long status;
  status = StartCritical();
  tcbs[0].next = &tcbs[1]; // 0 points to 1
  tcbs[1].next = &tcbs[2]; // 1 points to 2
  tcbs[2].next = &tcbs[0]; // 2 points to 0
  SetInitialStack(0); Stacks[0][STACKSIZE-2] = (long)(task0); // PC
  SetInitialStack(1); Stacks[1][STACKSIZE-2] = (long)(task1); // PC
  SetInitialStack(2); Stacks[2][STACKSIZE-2] = (long)(task2); // PC
  RunPt = &tcbs[0];       // thread 0 will run first
  EndCritical(status);
  return 1;               // successful
}


///******** OS_Launch *************** 
// start the scheduler, enable interrupts
// Inputs: number of 20ns clock cycles for each time slice
// (1/20ns)=(1/(20*10^{-9}))=0.05*10^{9}=5*10^{-2}*10^{9}=5*10^{7}=50*10^{6}=50MHz
//         (maximum of 24 bits)
// (1/(10*10^{6}))=0.1*10^{-6}=0.1*10^{3}*10^{-9}=100*10^{-9}=100ns
// Inputs: number of 100ns clock cycles for each time slice.
// In this case: TIME_10MS=10*10000=100000=10^{5}; So a SysTick every 10^{5}*100*10^{-9}
// =10^{7}*10^{-9}=10^{-2}=0.01=10ms, and 
// for TIME_100MS=100ms=0.1s (1000000=11110100001001000000$_{2}$, i.e 20 bits<24 bits)
// Outputs: none (does not return)
void OS_Launch(unsigned long theTimeSlice){
//	printf("OS_Launch()!! 20151227");
//	printf("%c", NEWLINE);
  NVIC_ST_RELOAD_R = theTimeSlice - 1; // reload value
  NVIC_ST_CTRL_R = 0x00000007; // enable, core clock and interrupt arm
  StartOS();                   // start on the first task
}

void OS_Semaphore_Init(long *s, long value){
	*s=value;
}

void OS_Suspend(void){
	NVIC_ST_CURRENT_R=0;         // clear counter
	NVIC_INT_CTRL_R=0x04000000;  // trigger SysTick interrupt
}

// Blocking semaphore implementation based on description on page 174 of 
// Embedded Systems: Real-Time Operating Systems for the ARM Cortex M3.
// For this implementation work, SysTick_Handler must also be modified: see 
// NotBSearch loop added in the ISR SysTick_Handler in file osasm.s
void OS_Wait(long *s){
	OS_DisableInterrupts();
	*s=*s-1;
	if(*s<0){// the ''Block this thread'' operation
		RunPt->status=s;          // reason it is blocked
		OS_Suspend();
	}
	OS_EnableInterrupts();
}

void OS_Signal(long *s){
	long st;
	tcbType *pt;
	st=StartCritical();
	*s=*s+1;
	if(*s<=0){// the ''wakeup one thread'' operation
		pt=RunPt->next;
		while(pt->status!=s) pt=pt->next;
		pt->status=0;             // wakeup this one
	}
	EndCritical(st);
}

//initialize FIFO
void Fifo_Init(void){
  PutPt=GetPt=&Fifo[0];  // Empty
}

//// add element to FIFO (Not used in this example 2015.12.28)
//void Fifo_Put(DataType data){
//  OS_Wait(&RoomLeft);
//  OS_Wait(&mutex);
//  *(PutPt++)=data;  // put
//  if(PutPt==&Fifo[FIFOSIZE]){
//    PutPt=&Fifo[0]; // wrap
//  }
//  OS_Signal(&mutex);
//  OS_Signal(&CurrentSize);
//}
//// remove element from FIFO (Not used in this example 2015.12.28)
//void Fifo_Get(DataType *datapt){
//  OS_Wait(&CurrentSize);
//  OS_Wait(&mutex);
//  *datapt=*(GetPt++);
//  if(GetPt==&Fifo[FIFOSIZE]){
//    GetPt=&Fifo[0];  // wrap
//  }
//  OS_Signal(&mutex);
//  OS_Signal(&RoomLeft);
//}

// add element to FIFO
void enter_item(DataType data){
  *(PutPt++)=data; // put
  if(PutPt==&Fifo[FIFOSIZE]){
    PutPt=&Fifo[0];  // wrap
  }
}

// remove element from FIFO
void remove_item(DataType *datapt){
  *datapt=*(GetPt++); // get
  if(GetPt==&Fifo[FIFOSIZE]){
    GetPt=&Fifo[0];  // wrap
  }
}

int mycounter=0;
int produce_item(void){
  mycounter++;
  if((mycounter%FIFOSIZE)==0){
    Delay(1000);
  }
  return mycounter;
}

void consume_item(DataType item){	
  //printf("i=%06u\n",item);
  printf("Consumed item=%u",item);
  printf("%c",NEWLINE);
}

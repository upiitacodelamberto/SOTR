// filename **********OS.H***********
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
 
 
#ifndef __OS_H
#define __OS_H  1

// fill these depending on your clock        
#define TIME_1MS  50000

//Suponiendo XTAL=8MHz, y si se usa PLL y SYSCTL_SYSDIV_20 en SysCtlClockSet()          
//T_{c}=(1/10)*10^{-6}; Por lo tanto TIME_1MS=(1*10^{-3})/(1/10)*10^{-6}
//TIME_1MS=10*10^{3}=10000

//#define TIME_1MS	10000
#define TIME_2MS  2*TIME_1MS
#define TIME_10MS	10*TIME_1MS
#define TIME_20MS	20*TIME_1MS
#define TIME_100MS	100*TIME_1MS  

#define FIFOSIZE	2  // can be almost any size
#define FIFOSUCCESS	1
#define FIFOFAIL	0

//typedef char DataType;
typedef int DataType;
DataType static Fifo[FIFOSIZE];


// ******** OS_Init ************
// initialize operating system, disable interrupts until OS_Launch
// initialize OS controlled I/O: serial, ADC, systick, select switch and timer2 
// input:  none
// output: none
void OS_Init(void); 

//******** OS_AddThread *************** 
// add three foregound threads to the scheduler
// Inputs: three pointers to a void/void foreground tasks
// Outputs: 1 if successful, 0 if this thread can not be added
int OS_AddThreads(void(*task0)(void),
                 void(*task1)(void), 
                 void(*task2)(void));



//******** OS_Launch *************** 
// start the scheduler, enable interrupts
// Inputs: number of 20ns clock cycles for each time slice
//         (maximum of 24 bits)
// Outputs: none (does not return)
void OS_Launch(unsigned long theTimeSlice);

void Delay(unsigned long);
								 
								 
void OS_Wait(long *);
void OS_Signal(long *);
void OS_Suspend(void);
void OS_Semaphore_Init(long *s, long value);
void Fifo_Init(void);
								 
// add element to FIFO
void enter_item(DataType data);
// remove element from FIFO
void remove_item(DataType *datapt);
int produce_item(void);
void consume_item(DataType item);
#endif  /* __OS_H */

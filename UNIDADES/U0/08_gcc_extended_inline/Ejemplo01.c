#include <stdio.h>
#include <stdlib.h>/*malloc()*/


//static inline int * mystrcpy(int * dest,int src,int c);
static inline int * mystrcpy(int * dest,int src);

int main(){
  int fill_value=0xAA55AA55;
//  int *ARR=(int*)malloc(10*sizeof(int));
  int ARR[10];
  int cnt=10;
  mystrcpy(ARR,fill_value);
  printf("ARR[0]=%x\n",ARR[0]);
  printf("ARR[1]=%x\n",ARR[1]);

  fill_value=0x55AA55AA;
  mystrcpy(ARR,fill_value);
  printf("ARR[0]=%x\n",ARR[0]);
  return 0;
}


//static inline int * mystrcpy(int* dest,int src,int count){
static inline int * mystrcpy(int * dest, int src){
    int count=10;
        asm (                 
             "cld\n\t"
             "rep\n\t"
             "stosl"
             : "=D"(dest), "=c" (count)
             : "0" (dest), "1" (count), "a" (src)
             : "memory", "cc" 
             );
    return dest;
}


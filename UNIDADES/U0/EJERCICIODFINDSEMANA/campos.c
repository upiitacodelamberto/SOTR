#include <stdio.h>
//#define SEPT_6
#define float_2_MyFloat(a) (*((MyFloat*)(&(a))))

typedef 
struct myfloat{/* Little Endian */
  unsigned mantisa	:23;
  unsigned power	:8;
  unsigned sign		:1;
}MyFloat;
struct four_chars{/* Little Endian */
  unsigned char abcd0;
  unsigned char abcd1;
  unsigned char abcd2;
  unsigned char abcd3;
};
union UFloat{
  MyFloat MyF;	/* 4 bytes */
  struct four_chars FourChars;	/* 4 bytes */
};
typedef 
struct Int{/* Little Endian */
  unsigned byte0	:8; 
  unsigned byte1	:8; 
  unsigned byte2	:8; 
  unsigned byte3	:8; 
}Int;
union paraInt{         /*Otro ejemplo de uso de una union se puede ver en    */
  Int IntV;            /*las fuentes del kernel linux 0.11                */
  struct four_chars FC;/*//Code path:kernel/sched.c                          */
};                     /*   ....                                             */
                       /* union task_union {  // The union of task_struct    */
                       /*      struct task_struct task;// and kernel's stack */
                       /*      char stack[PAGE_STACK]; // PAGE_SIZE is	4K   */
                       /* };                                                 */
                       /* static union task_union init_task={INIT_TASK,};    */
                       /*                       //task_struct of process 0   */
                       /* //task[0] is used by process 0                     */
          /*     struct task_struct * task[NR_TASKS] = {&(init_task.task),}; */
/*// como vemos, se usa tambien un arreglo de apuntadores a struct task_struct*/
/*   Vease pag. 68 del libro The art of Linux Kernel Design:Ilustrating the  */
/* Operating System  Design Principle and Implementation, Lixiang Yang       */
/* Pag. 83 del archivo pdf                                                   */
/* [Lixiang_Yang]_The_Art_of_Linux_Kernel_Design_Ill(BookZZ.org).pdf         */
/**
 * Imprime los bits de un int
 */
void show_bits(int);

long main(){
  int intA=2012026905;
  show_bits(intA);
  printf("\n");
  Int IntVar=*((Int*)(&intA));
  printf("IntVar=%d\n",*((int*)(&IntVar)));
  printf("byte0=%x\tbyte1=%x\tbyte2=%x\tbyte3=%x\n",
         IntVar.byte0,IntVar.byte1,IntVar.byte2,IntVar.byte3);
  union paraInt union_para_Int;
  union_para_Int.IntV=IntVar; 
  printf("&byte0=%x\t&byte1=%x\t&byte2=%x\t&byte3=%x\n",
         &(union_para_Int.FC.abcd0),
         &(union_para_Int.FC.abcd1),
         &(union_para_Int.FC.abcd2),
         &(union_para_Int.FC.abcd3));


  float floatA=7.5;
  intA=*((int*)(&floatA));
  show_bits(intA);
  printf("\n");
  MyFloat MyF;
  printf("sizeof(MyF)=%d\n",sizeof(MyF));	/* sizeof(MyF)=4 */
  printf("sizeof(unsigned char)=%d\n",sizeof(unsigned char));/* sizeof(uchar)=1 */
  printf("sizeof(struct four_chars)=%d\n",sizeof(struct four_chars));/* sizeof(fchars)=4 */
  //MyF=floatA;
  MyF=*((MyFloat*)(&floatA));
  union UFloat union_UFloat;
  union_UFloat.MyF=MyF;
  printf("%x\t",union_UFloat.FourChars.abcd0);
  printf("%x\t",union_UFloat.FourChars.abcd1);
  printf("%x\t",union_UFloat.FourChars.abcd2);
  printf("%x\t",union_UFloat.FourChars.abcd3);
  printf("\n");
  printf("&byte0=%x\t&byte1=%x\t&byte2=%x\t&byte3=%x\n",
         &(union_UFloat.FourChars.abcd0),
         &(union_UFloat.FourChars.abcd1),
         &(union_UFloat.FourChars.abcd2),
         &(union_UFloat.FourChars.abcd3));
  printf("\n");
  printf("sign=%x\n",union_UFloat.MyF.sign);
  printf("power=%x\n",union_UFloat.MyF.power);
  printf("mantisa=%x\n",union_UFloat.MyF.mantisa);

  floatA=-7.5;
  MyF=*((MyFloat*)(&floatA));
  union_UFloat.MyF=MyF;
  printf("%x\t",union_UFloat.FourChars.abcd0);
  printf("%x\t",union_UFloat.FourChars.abcd1);
  printf("%x\t",union_UFloat.FourChars.abcd2);
  printf("%x\t",union_UFloat.FourChars.abcd3);
  printf("\n");

  printf("sign=%x\n",union_UFloat.MyF.sign);
  printf("power=%x\n",union_UFloat.MyF.power);
  printf("mantisa=%x\n",union_UFloat.MyF.mantisa);

  MyF.sign=0x0;
  MyF.power=0x81;
  MyF.mantisa=0x710000;
  union_UFloat.MyF=MyF;
  printf("sign=%x\n",union_UFloat.MyF.sign);
  printf("power=%x\n",union_UFloat.MyF.power);
  printf("mantisa=%x\n",union_UFloat.MyF.mantisa);
  printf("MyF=%f\n",*((float*)(&MyF)));
  floatA=4.220703;
  MyF=*((MyFloat*)(&floatA));
  printf("MyF=%f\n",*((float*)(&MyF)));
  printf("sign=%x\n",MyF.sign);
  printf("power=%x\n",MyF.power);
  printf("mantisa=%x\n",MyF.mantisa);
  MyF=float_2_MyFloat(floatA);
  
  /* Escribamos el 0.5 usando MyF */
  MyF.sign=0;MyF.power=0x7e;MyF.mantisa=0x00;//MyF.power=7f+(-1)=0x7e, -1 sale de 0.5 = 1*2^{-1}
  printf("MyF=%f\t",*((float*)(&MyF)));
  printf("sign=%x\t",MyF.sign);
  printf("power=%x\t",MyF.power);
  printf("mantisa=%x\n",MyF.mantisa);
  /* Escribamos el 0.25 usando MyF */
  MyF.sign=0;MyF.power=0x7d;MyF.mantisa=0x00;
  printf("MyF=%f\t",*((float*)(&MyF)));
  printf("sign=%x\t",MyF.sign);
  printf("power=%x\t",MyF.power);
  printf("mantisa=%x\n",MyF.mantisa);
  int i;
  for(i=0;i<20;i++){
    MyF.sign=0;MyF.power=0x7f-i;MyF.mantisa=0x00;
    printf("MyF=%f\t",*((float*)(&MyF)));
    printf("sign=%x\t",MyF.sign);
    printf("power=%x\t",MyF.power);
    printf("mantisa=%x\n",MyF.mantisa);
  }
#ifdef SEPT_6
#endif /* SEPT_6 */
  return 0;
}//end main()

void show_bits(int intTmp){
  int i;
  for(i=8*sizeof(int)-1;i>=0;i--){        //A1:
    printf("%d",((intTmp)>>i)&0x00000001);//A2:
  }                                       //A3:
}


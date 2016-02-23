#include <stdlib.h>/*malloc()*/
#include "FechaType.h"

void set_Fecha(FechaType* f,int d,int m){
  f->dia=d;f->mes=m;f->n=5;
  f->intPt=(int*)malloc(5*sizeof(int));
  *(f->intPt+0)=1;
  *(f->intPt+1)=8;
  *(f->intPt+2)=15;
  *(f->intPt+3)=22;
  *(f->intPt+4)=29;
}

#include <stdio.h>
#include <stdlib.h> /*malloc()*/
#include <string.h> /*atoi()*/
#include "FechaType.h"
char *MES[]={
  "enero","febrero","marzo","abril","mayo","junio","julio",
  "agosto","septiembre","octubre","noviembre","dicembre"
};


/**
 Los dos ultimos argumentos deben ser el numero del 
 dia del mes y el numero del mes 0 para enero, 
 1 para febrero, 2 para marzo, etc.
*/
void set_Fecha(FechaType*,int,int);

int main(int argc,char *argv[]){
  int i;
  FechaType *fecha=(FechaType*)malloc(sizeof(FechaType));
  if(argc<3){
    printf("FORMA DE USO: %s <dia> <mes>\n",argv[0]);
    exit(0);
  }
  set_Fecha(fecha,atoi(argv[1]),atoi(argv[2]));
  for(i=0;i<fecha->n;i++)
    printf("%i de %i de 2016\n",*(fecha->intPt+i),fecha->mes);

  /*Otra forma de inicializar estructuras*/
  struct Fecha fecha1={
    .dia=18,
    .mes=1,
    .n=4,
    .intPt=(int*)malloc(4*sizeof(int)),
  };
  *(fecha1.intPt+0)=4;
  *(fecha1.intPt+1)=11;
  *(fecha1.intPt+2)=18;
  *(fecha1.intPt+3)=25;
  fecha=&fecha1;
  printf("/****************************/\n");
  for(i=0;i<fecha->n;i++)
    printf("%i de %s de 2016\n",*(fecha->intPt+i),MES[fecha->mes]);

  return 0;
}












































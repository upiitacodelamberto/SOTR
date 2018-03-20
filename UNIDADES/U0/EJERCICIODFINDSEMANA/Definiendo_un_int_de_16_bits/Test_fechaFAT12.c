#include <stdio.h>
#include "fechafat12.h"


/* Packing structs                                             */
/* When using a struct there is no guarantee that the size of  */
/* the struct will be exactly of the size one could expect.    */
/* The compiler can add some padding between elements for      */
/* various reasons (mainly efficiency). The attribute packed   */
/* can be used to force GCC to not add any padding.            */



void show_b16(FechaFAT12 fech);

int main(){
  FechaFAT12 f;
  f.dia=1;
  f.mes=1;
  f.anio=0;
  printf("tamanio de FechaFAT12=%d\n",sizeof(FechaFAT12));
  show_b16(f);
  printf("\t\t1 de enero de 1980\n");
  printf("\n");
  FechaFAT12 F;
  F.dia=31;
  F.mes=12;
  F.anio=2099-1980;
  printf("\n");
  show_b16(F);
  printf("\t\t31 de diciembre de 2099\n");
  printf("\n");
  uInt16 f1=*((uInt16*)(&f));
  uInt16 F1=*((uInt16*)(&F));
  printf("Ahora imprimir en hexadecimal:\n");
  show_b16(f);
  printf("\t%x\n", f1);
  show_b16(F);
  printf("\t%x\n", F1);

  printf("\n");
  printf("\n");
  printf("Nuevamente imprimir en hexadecimal:\n");
  printf("CASTEANDO CON EL TIPO DE DATO int NO SE OBTIENEN LOS VALORES CORRECTOS!\n");
  show_b16(f);
  printf("\t%x\n",*((int*)((&f)))  );
  show_b16(F);
  printf("\t%x\n", *((int*)((&F)))  );

  printf("\n");
  printf("\n");
  printf("Tambi\'en se puede \"no declarar\" las variables de tipo uInt16\n");
  printf("Nuevamente imprimir en hexadecimal:\n");
  show_b16(f);
  printf("\t%x\n",*((uInt16*)((&f)))  );
  show_b16(F);
  printf("\t%x\n", *((uInt16*)((&F)))  );


  return 0;
}

void show_b16(FechaFAT12 fech){
  int i,intTmp;
  intTmp=*((int*)(&fech));
  for(i=8*sizeof(FechaFAT12)-1;i>=0;i--){        
    printf("%d",((intTmp)>>i)&0x0001);
  }                                       
}

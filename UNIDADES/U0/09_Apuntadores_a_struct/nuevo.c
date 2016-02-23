#include <stdio.h>
#include <stdlib.h>/*malloc()*/
int main(){
  int A,i;
  int* p;
  p=&A;
  *p=10;
  printf("*p=%i\tA=%i\n",*p,A);

  p=(int*)malloc(3*sizeof(int));
  p[0]=10;p[1]=20;p[2]=30; /*se puede indexar con corchetes*/
  for(i=0;i<3;i++){
    printf("%i\t",*(p+i));
  }
  printf("\n");
  *(p+0)=100;//        
  *(p+1)=200;//      y tambien podemos indexar con parentesis
  *(p+2)=300;//     
  for(i=0;i<3;i++){
    printf("%i\t",p[i]);
  }
  printf("\n");
  return 0;
}

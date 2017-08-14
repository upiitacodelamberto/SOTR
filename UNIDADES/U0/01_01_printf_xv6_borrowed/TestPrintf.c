/*
  TestPrintf.c - driver para usar la funcion
  void printf(int, char*, ...)
 */

/*#include <stdio.h>*/

extern void printf(int fd,char *fmt,...);
extern void salir(int status);

int main(){
  char A[]="Hello everybody!";
  printf(1,A);
  char B[]="\n";
  char C[]="SOTR grupo: %s\n";
  char D[]="3MV7 2017-B";
  char E[]="Happy hackings!";
  printf(1,B);
  printf(1,"Viernes %d de agosto de %d.\n",11,2017);
  printf(1,B);
  printf(1,"Pointer A=%x, Pointer B=%p\n",A,B);
  printf(1,B);
  printf(1,C,D);
  int a=2;
  int b=32;
  printf(1,"Pointer &a=%x, Pointer &b=%p\n",&a,&b);
  printf(1,B);
  long c=(long)&a;
  long d=(long)&b;
  printf(1,"Notemos que la resta &a-&b=%d en aritmetica de apuntador.\n",&a-&b);
  printf(1,"Mientras que la resta &b-&a=%d en aritmetica de apuntador.\n",&b-&a);
  printf(1,"Pero si hacemos que c=(long)&a y que d=(long)&b, entonces:\n");
  printf(1,"la resta c-d=%d\n",c-d);
  printf(1,"y la resta d-c=%d\n%s\n",d-c,E);
  printf(1,B);

  salir(0xff);
}/*end main()*/

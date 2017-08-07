/*#include <stdio.h>*/

int main(){
/*
  union{
    char que[16];
    int clave[4];
  } misterio,*p;
  p=&misterio;
  p->clave[0]=0x6c6c6568;
  p->clave[1]=0x7720206f;
  p->clave[2]=0x646c726f;
  p->clave[3]=0x00000a21;
*/
  char msg[]="Hello  World!";
  char c=msg[7];



/*  printf("%s",p->que);*/
/*  getchar();*/

  return c;
}/*end main()*/














#include <stdio.h>
extern char variable; /*resuelto en nuevo.asm*/
int main(){
  char c=variable;
  printf("%c\n",c);
  return 0;
}

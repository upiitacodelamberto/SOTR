/*Listado 1.3 Uso basico de fork()*/
#include <sys/types.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
int main (void) {
  int *valor = malloc(sizeof(int));
  *valor = 0;
  fork();
  *valor = 13;
  printf(" %ld: %d\n", (long)getpid(), *valor);
  free(valor);
  return 0;
}

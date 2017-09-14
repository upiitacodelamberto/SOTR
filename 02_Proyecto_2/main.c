/**
 * main.c - imprime los bits de una variable de tipo int
 */
#include <stdio.h>
#include <stdlib.h>

/* run this program using the console pauser or add your own getch, system("pause") or input loop */
int float_to_int(float);

int main(int argc, char *argv[]) {
	int intVar=8,i;
	float floatVar=7.5;
/*	intVar=*(int *)(void *)floatVar; 
	printf("%d\n",sizeof(float));    
	printf("%d representado en 8*%d=%d bits:\n",
			intVar,sizeof(intVar),8*sizeof(int));   */
	intVar=float_to_int(floatVar);
	for(i=sizeof(int)-1;i>=0;i--){
		printf("%d",(intVar>>i)&0x00000001);
	}
	
	return 0;
}

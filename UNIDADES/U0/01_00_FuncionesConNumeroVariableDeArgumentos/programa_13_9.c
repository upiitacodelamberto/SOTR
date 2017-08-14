#include <stdio.h>
#include <stdarg.h>

/* prototipo de funcion que recibe un numero variable de argumentos */
int sumar(int cantidad, ...); /* devuelve la suma de cantidad enteros */

int multiplicar(int cantidad, ...); /* devuelve la multiplicacion de cantidad enteros */

int main(){
    int suma, producto;
    suma = sumar(4, 1, 2, 3, 4);
    printf("suma = %d\n", suma);
    producto = multiplicar(4, 1, 2, 3, 4);
    printf("producto = %d\n", producto);
    return 0;
}// End main()

int sumar(int cantidad, ...){
    va_list ap;
    int arg;
    int total = 0;
    int i = 0;

    va_start(ap, cantidad);
    for(i = 0; i < cantidad; i++){
        arg = va_arg(ap, int);
#ifdef DEBUG
        printf("total = %d\n", total);
        printf("arg = %d\n", arg);
#endif
        total += arg;
    }
    va_end(ap);
    return total;
}

/* STUB retorna -1 */ 
int multiplicar(int cantidad, ...){
    return -1;/* como ejercicio edite el codigo de esta funcion 
                 para que devuelva el producto de los cantidad 
                 de enteros que se le pasaran como argumento. 
                 HINT: siga los pasos que se hacen en la funcion
                       sumar de este mismo archivo. */
}

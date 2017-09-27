/**
 Decido colocar esta constante provisionalmente por comodidad, en lugar de incluir 
Ael archivo de cabecera donde esta definida, a.out.h 
Se puede encontrar en que archivo de cabecera esta definida PAGE_SIZE revisando la 
salida del comamndo:
find . -iname '*.h' -print -exec grep PAGE_SIZE {} \; 

Tambien, para encontrar en cual Makefile esta la receta para construir un target se 
puede usar en el directorio raiz de las fuentes:
find . -name Makefile -print -exec grep target_name {} \;

En los Makefile, los comandos que aparecen precedidos por un @ no se muestran durante 
la construccion del target. Si quitamos esa @ entonces si se muestra la ejecucion del 
comando.
*/
#define PAGE_SIZE 4096
long user_stack [ PAGE_SIZE>>2 ] ;

struct {
	long * a;
	short b;
	} stack_start = { & user_stack [PAGE_SIZE>>2] , 0x10 };


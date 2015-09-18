#include <stdio.h>
#include <stdlib.h> /* malloc() */
#include "tddprogdetallado.h"

void copy(wchar_t to[], wchar_t from[]){
	int i = 0;
	while((to[i] = from[i]) != L'\0') i++; 
}


void prog_detallado(struct prog_detallado *pd){
	/* inicializamos el programa detallado */
	set_prog_detallado(pd);
	/* finalmente mostramos el programa detallado de la UA */
	mostrar_prog_detallado(pd);
}

void set_prog_detallado(struct prog_detallado *pd){
	int i, j, k;
	/* copiando el nombre de la unidad de aprendizaje */
	copy(pd->nombre, unidaddaprendizaje);
	pd->numdunidades = numdunidades;
	/* reservamos espacio para las struct unidad de 
	   la unidad de aprendizaje */
	pd->unidad = (struct unidad *) malloc(pd->numdunidades * sizeof(struct unidad));

	/* coloco los nombres de los temas en un arreglo de dimensiones 
	   adecuadas */
	wchar_t ***nombresdtemas = (wchar_t ***)malloc(numdunidades * sizeof(wchar_t **));
//#if(CANTIDADDUNIDADES == 1)	
//	*(nombresdtemas + 0) = nombresdtemasdu1;
//#endif
//#if(CANTIDADDUNIDADES == 4)
	*(nombresdtemas + 0) = nombresdtemasdu1;
	*(nombresdtemas + 1) = nombresdtemasdu2;
	*(nombresdtemas + 2) = nombresdtemasdu3;
	*(nombresdtemas + 3) = nombresdtemasdu4;
//#endif

	for(i = 0; i < numdunidades; ++i){
		/* guardamos los numeros de temas de cada unidad */
		(pd->unidad + i)->numdtemas = numdtemas[i];
		/* reservamos espacio para las estructuras de los temas 
		   de cada unidad */
		(pd->unidad + i)->tema = (struct tema *)
			malloc((pd->unidad + i)->numdtemas * 
					sizeof(struct tema));
		/* copiando nombres de las unidades */
		copy((pd->unidad + i)->nombre, unit[i]);  
		/* copiando nombres de los temas de las unidades */
		for(j = 0; j < numdtemas[i]; ++j){
			copy(((pd->unidad + i)->tema + j)->nombre, 
						*(*(nombresdtemas + i) + j));
            ((pd->unidad + i)->tema + j)->numdsubtemas = *(*(numdsubtemas + i) + j); // <-ES LO MISMO QUE TEMA[i][j]
            /* RESERVAMOS MEMORIA PARA SUBTEMA */
            ((pd->unidad + i)->tema + j)->subtema = (struct subtema *)
                malloc(((pd->unidad + i)->tema + j)->numdsubtemas *
                       sizeof(struct subtema));
            /* ciclo para los subtemas */
                  for(k = 0; k < *(*(numdsubtemas + i) + j); ++k){
            /* COPIA SUBTEMA */
                   copy((((pd->unidad + i)->tema + j)->subtema + k)->nombre,
                           *(*(*(nombresdsubtemas + i) + j) + k));
                  }
                }
	}
}

void mostrar_prog_detallado(struct prog_detallado *pd){
	int i, j, k;
	wprintf(L"Unidad de Aprendizaje: %Ls\n", pd->nombre);
	for(i = 0; i < numdunidades; ++i){
		wprintf(L"UNIDAD %d %Ls\n", i + 1, (pd->unidad + i)->nombre);
		for(j = 0; j < (pd->unidad + i)->numdtemas; ++j){
			wprintf(L"  %d.%d %Ls\n", i+1,j+1, ((pd->unidad + i)->tema + j)->nombre);
                        for(k = 0; k < ((pd->unidad + i)->tema + j)->numdsubtemas; ++k){
                                wprintf(L"    %d.%d.%d %Ls\n", i+1, j+1, k+1, (((pd->unidad + i)->tema + j)->subtema + k)->nombre);
                        }
		}
	}
}

/** visionartificial.c */
#define NULL ((void *)0)
#include <wchar.h> /* wchar_t */
#include "DefaultNames.h"


//<!--INFORMACION UNIDAD 1
/* Unidad 1 */
wchar_t Unidad_1[] = L"Introduccion a los \
sistemas de Vision Artificial";

/* Temas Unidad 1 */
wchar_t Tema_1_1[] = {L"Percepcion de color"};
wchar_t Tema_1_2[] = L"Elementos de un sistema de vision artificial";
//wchar_t *nombresdtemasdu1[] = {Tema_1_1, Tema_1_2};
wchar_t *nombresdtemasdu1[];
void set_nombresdtemasdu1(){
  DefaultNames<wchar_t>::nombresdtemasdu1={Tema_1_1, Tema_1_2};
  nombresdtemasdu1=DefaultNames<wchar_t>::nombresdtemasdu1;
}

/* Subtemas Unidad 1 */
wchar_t *nombresdsubtemasdu1t1[]={NULL};
wchar_t *nombresdsubtemasdu1t2[]={NULL};
wchar_t **nombresdsubtemasdu1[] = { nombresdsubtemasdu1t1, nombresdsubtemasdu1t2 };

/*cantidades de subtemas de los temas de u1*/
int numdsubtemasdu1[] = {0, 0};
//-->


//<!--INFORMACION UNIDAD 2
wchar_t *nombresdtemasdu2[]={NULL};
//-->

//<!--INFORMACION UNIDAD 3
wchar_t *nombresdtemasdu3[]={NULL};
//-->

//<!--INFORMACION UNIDAD 4
wchar_t *nombresdtemasdu4[]={NULL};
//-->

//<!--INFORMACION UNIDAD 5
wchar_t *nombresdtemasdu5[]={NULL};
//-->


//<!--INFORMACION GLOBAL DE LA UA VISION ARTIFICIAL
/* Nombre de la Unidad de Aprendizaje (UA) */
wchar_t unidaddaprendizaje[]=L"SISTEMAS DE VISION ARTIFICIAL"; 
int numdunidades = 1; /* numero de unidades de la UA */

wchar_t *unit[] = {Unidad_1};
int numdtemas[] = {2, -1, -1, -1, -1};

wchar_t ***nombresdsubtemas[]={nombresdsubtemasdu1};

int *numdsubtemas[] = { numdsubtemasdu1 };
//-->



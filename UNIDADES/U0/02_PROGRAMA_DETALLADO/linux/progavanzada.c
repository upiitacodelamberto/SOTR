/** visionartificial.c */
#define NULL ((void *)0)
#include <wchar.h> /* wchar_t */

wchar_t unidaddaprendizaje[]=L"PROGRAMACION AVANZADA"; /* Nombre de la Unidad de Aprendizaje (UA) */
int numdunidades = 2; /* numero de unidades de la UA */

wchar_t Unidad_1[] = L"Programacion Orientada a \
Objetos";

wchar_t Tema_1_1[] = {L"Clases"};

wchar_t Tema_1_2[] = {L"Objetos"};

wchar_t Tema_1_3[]={L"Herencia"};
wchar_t Tema_1_4[]={L"Polimorfismo"};
wchar_t Tema_1_5[]={L"Abstraccion"};

int numdtemas[] = {5, 2, -1, -1};/* cantidades de temas de las unidades */

wchar_t *nombresdtemasdu1[] = { Tema_1_1, Tema_1_2, Tema_1_3, Tema_1_4, Tema_1_5 };

int numdsubtemasdu1[] = {0, 0, 0, 0, 0};/*cantidades de subtemas de los temas de u1*/
int numdsubtemasdu2[]={0, 0};/*cantidades de subtemas de los temas de u2*/
int *numdsubtemas[] = { numdsubtemasdu1, numdsubtemasdu2};

wchar_t *nombresdsubtemasdu1t1[]={NULL};
wchar_t *nombresdsubtemasdu1t2[]={NULL};
wchar_t *nombresdsubtemasdu1t3[]={NULL};
wchar_t *nombresdsubtemasdu1t4[]={NULL};
wchar_t *nombresdsubtemasdu1t5[]={NULL};
wchar_t **nombresdsubtemasdu1[] = { nombresdsubtemasdu1t1, nombresdsubtemasdu1t2, 
nombresdsubtemasdu1t3, nombresdsubtemasdu1t4, nombresdsubtemasdu1t5};
wchar_t *nombresdsubtemasdu2t1[]={NULL};
wchar_t *nombresdsubtemasdu2t2[]={NULL};
wchar_t **nombresdsubtemasdu2[]={nombresdsubtemasdu2t1, nombresdsubtemasdu2t2};

wchar_t ***nombresdsubtemas[] = { nombresdsubtemasdu1 };


wchar_t Unidad_2[]={L"Entorno de Desarrollo"};
wchar_t Tema_2_1[]={L"Ambiente de Desarrollo"};
wchar_t Tema_2_2[]={L"Proyecto"};

wchar_t *unit[] = {Unidad_1, Unidad_2};

wchar_t *nombresdtemasdu2[] = { NULL };
wchar_t *nombresdtemasdu3[] = { NULL };
wchar_t *nombresdtemasdu4[] = { NULL };

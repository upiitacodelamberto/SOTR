/** visionartificial.c */
#define NULL ((void *)0)
#include <wchar.h> /* wchar_t */

wchar_t unidaddaprendizaje[]=L"SISTEMAS DE VISION ARTIFICIAL"; /* Nombre de la Unidad de Aprendizaje (UA) */
int numdunidades = 1; /* numero de unidades de la UA */

wchar_t Unidad_1[] = L"Introduccion a los \
sistemas de Vision Artificial";

wchar_t Tema_1_1[] = {L"Percepcion de color"};

wchar_t Tema_1_2[] = L"Elementos de un \
sistema de vision artificial";


int numdtemas[] = {2, -1, -1, -1};

wchar_t *nombresdtemasdu1[] = { Tema_1_1, Tema_1_2 };
int   numdsubtemasdu1[] = {0, 0};
wchar_t *unit[] = {Unidad_1};
int *numdsubtemas[] = { numdsubtemasdu1 };

wchar_t *nombresdsubtemasdu1t1[]={NULL};
wchar_t *nombresdsubtemasdu1t2[]={NULL};
wchar_t **nombresdsubtemasdu1[] = { nombresdsubtemasdu1t1, nombresdsubtemasdu1t2 };
wchar_t ***nombresdsubtemas[] = { nombresdsubtemasdu1 };


wchar_t *nombresdtemasdu2[] = { NULL };
wchar_t *nombresdtemasdu3[] = { NULL };
wchar_t *nombresdtemasdu4[] = { NULL };

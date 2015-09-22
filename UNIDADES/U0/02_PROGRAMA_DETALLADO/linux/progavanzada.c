/** visionartificial.c */
#define NULL ((void *)0)
#include <wchar.h> /* wchar_t */
//#define CUATRO
#define CINCO


//<!--INFORMACION UNIDAD 1
/* Unidad 1 */
wchar_t Unidad_1[] = L"Programacion Orientada a \
Objetos";

/* Temas Unidad 1 */
wchar_t Tema_1_1[] = L"Clases";
wchar_t Tema_1_2[] = L"Objetos";
wchar_t Tema_1_3[]=L"Herencia";
wchar_t Tema_1_4[]=L"Polimorfismo";
wchar_t Tema_1_5[]=L"Abstraccion";
wchar_t *nombresdtemasdu1[] = { Tema_1_1, Tema_1_2, Tema_1_3, Tema_1_4, Tema_1_5 };

/* Subtemas Unidad 1 */
wchar_t *nombresdsubtemasdu1t1[]={NULL};
wchar_t *nombresdsubtemasdu1t2[]={NULL};
wchar_t *nombresdsubtemasdu1t3[]={NULL};
wchar_t *nombresdsubtemasdu1t4[]={NULL};
wchar_t *nombresdsubtemasdu1t5[]={NULL};
wchar_t **nombresdsubtemasdu1[] = { nombresdsubtemasdu1t1, nombresdsubtemasdu1t2, 
nombresdsubtemasdu1t3, nombresdsubtemasdu1t4, nombresdsubtemasdu1t5};

/*cantidades de subtemas de los temas de u1*/
int numdsubtemasdu1[] = {0, 0, 0, 0, 0};
//-->


//<!--INFORMACION UNIDAD 2
/* Unidad 2 */
wchar_t Unidad_2[]=L"Entorno de Desarrollo";

/* Temas Unidad 2 */
wchar_t Tema_2_1[]=L"Ambiente de Desarrollo";
wchar_t Tema_2_2[]=L"Proyecto";
wchar_t *nombresdtemasdu2[]={Tema_2_1, Tema_2_2};

/* Subtemas Unidad 2 */
wchar_t *nombresdsubtemasdu2t1[]={NULL};
wchar_t *nombresdsubtemasdu2t2[]={NULL};
wchar_t **nombresdsubtemasdu2[]={nombresdsubtemasdu2t1, nombresdsubtemasdu2t2};

/*cantidades de subtemas de los temas de u2*/
int numdsubtemasdu2[]={0, 0};
//-->


//<!--INFORMACION UNIDAD 3
/* Unidad 3 */
wchar_t Unidad_3[]=L"Interfaz grafica de usuario (GUI)";

/* Temas Unidad 3 */
wchar_t Tema_3_1[]={L"Controles Basicos"};
wchar_t Tema_3_2[]={L"Controles Avanzados"};
wchar_t Tema_3_3[]={L"Eventos"};
wchar_t *nombresdtemasdu3[]={Tema_3_1, Tema_3_2, Tema_3_3};

/* Subtemas Unidad 3 */
wchar_t *nombresdsubtemasdu3t1[]={NULL};
wchar_t *nombresdsubtemasdu3t2[]={NULL};
wchar_t *nombresdsubtemasdu3t3[]={NULL};
wchar_t **nombresdsubtemasdu3[]={
    nombresdsubtemasdu3t1,nombresdsubtemasdu3t2,nombresdsubtemasdu3t3};

/*cantidades de subtemas de los temas de u3*/
int numdsubtemasdu3[] = {0, 0, 0};
//-->


//<!--INFORMACION UNIDAD 4
/* Unidad 4 */
wchar_t Unidad_4[]=L"Puertos y comunicaciones";

/* Temas Unidad 4 */
wchar_t Tema_4_1[]=L"Puerto serie";
wchar_t Tema_4_2[]=L"Puerto USB";
wchar_t Tema_4_3[]=L"Comunicacion TCP/IP";
wchar_t *nombresdtemasdu4[]={Tema_4_1, Tema_4_2, Tema_4_3};

/* Subtemas Unidad 4 */
wchar_t *nombresdsubtemasdu4t1[]={NULL};
wchar_t *nombresdsubtemasdu4t2[]={NULL};
wchar_t *nombresdsubtemasdu4t3[]={NULL};
wchar_t **nombresdsubtemasdu4[]={
    nombresdsubtemasdu4t1, nombresdsubtemasdu4t2, nombresdsubtemasdu4t3};

/*cantidades de subtemas de los temas de u4*/
int numdsubtemasdu4[] = {0, 0, 0};
//-->


//<!--INFORMACION UNIDAD 5
/* Unidad 5 */
wchar_t Unidad_5[]=L"Vision";

/* Temas Unidad 5 */
wchar_t Tema_5_1[]=L"Vision";
wchar_t *nombresdtemasdu5[]={Tema_5_1};

/* Subtemas Unidad 5 */
wchar_t *nombresdsubtemasdu5t1[]={NULL};
wchar_t **nombresdsubtemasdu5[]={nombresdsubtemasdu5t1};

/*cantidades de subtemas de los temas de u5*/
int numdsubtemasdu5[] = {0};
//-->


//<!--INFORMACION GLOBAL DE LA UA PROGRAMACION AVANZADA
/* Nombre de la Unidad de Aprendizaje (UA) */
wchar_t unidaddaprendizaje[]=L"PROGRAMACION AVANZADA"; 
int numdunidades = 5; /* numero de unidades de la UA */

wchar_t *unit[] = {Unidad_1, Unidad_2, Unidad_3, Unidad_4, Unidad_5};
int numdtemas[] = {5, 2, 3, 3, 1};/* cantidades de temas de las unidades */

wchar_t ***nombresdsubtemas[]={nombresdsubtemasdu1, nombresdsubtemasdu2, 
    nombresdsubtemasdu3, nombresdsubtemasdu4, nombresdsubtemasdu5};

int *numdsubtemas[] = {numdsubtemasdu1, numdsubtemasdu2, 
    numdsubtemasdu3, numdsubtemasdu4, numdsubtemasdu5};
//-->

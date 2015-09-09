/** sotr.c */
#define NULL ((void *)0)
#include <wchar.h> /* wchar_t */

wchar_t unidaddaprendizaje[] = L"SISTEMAS OPERATIVOS EN TIEMPO REAL"; /* Nombre de la Unidad de Aprendizaje (UA) */
int numdunidades = 4; /* numero de unidades de la UA */

wchar_t Unidad_1[] = L"Introducción a los sistemas operativos en tiempo real";
wchar_t Tema_1_1[] = L"Definición de un sistema operativo en tiempo real";
wchar_t Subtema_1_1_1[] = L"Clasificación";
wchar_t Subtema_1_1_2[] = L"Características";
wchar_t Tema_1_2[] = L"Diferencias entre un kernel de tiempo real y un kernel normal";
wchar_t Subtema_1_2_1[] = L"Ejemplos de sistemas de tiempo real";
wchar_t Tema_1_3[] = L"Conociendo sistemas operativos en tiempo real";
wchar_t Subtema_1_3_1[] = L"Ejemplos de sistemas operativos en tiempo real";
wchar_t Tema_1_4[] = L"Instalación de un sistema operativo en tiempo real";

wchar_t Unidad_2[] = L"Programación Concurrente";
wchar_t Tema_2_1[] = L"Concepto de procesos";
wchar_t Subtema_2_1_1[] = L"Estados de los procesos";
wchar_t Subtema_2_1_2[] = L"Bloque de control de procesos";
wchar_t Tema_2_2[] = L"Concepto de concurrencia";
wchar_t Subtema_2_2_1[] = L"Procesos síncronos y asíncronos";
wchar_t Tema_2_3[] = L"Exclusión mutua";
wchar_t Subtema_2_3_1[] = L"Región crítica";
wchar_t Subtema_2_3_2[] = L"Algoritmo de Dekker";
wchar_t Subtema_2_3_3[] = L"Algoritmo de Peterson";
wchar_t Tema_2_4[] = L"Semáforos";
wchar_t Subtema_2_4_1[] = L"Sincronización de procesos con semáforos";
wchar_t Tema_2_5[] = L"Mensajes";
wchar_t Subtema_2_5_1[] = L"Comunicación de procesos con mensajes";

wchar_t Unidad_3[] = L"Las tareas, interrupciones y el reloj en tiempo real";
wchar_t Tema_3_1[] = L"Tareas en tiempo real";
wchar_t Subtema_3_1_1[] = L"Clasificación de tareas";
wchar_t Tema_3_2[] = L"Interrupciones";
wchar_t Subtema_3_2_1[] = L"Concepto";
wchar_t Subtema_3_2_2[] = L"Clasificación de las interrupciones";
wchar_t Subtema_3_2_3[] = L"Tratamiento de interrupciones";
wchar_t Tema_3_3[] = L"Reloj del sistema";
wchar_t Subtema_3_3_1[] = L"Sistemas de referencia";
wchar_t Subtema_3_3_2[] = L"Relojes de tiempo real";
wchar_t Subtema_3_3_3[] = L"Funciones para medir el tiempo";

wchar_t Unidad_4[] = L"Planificación de procesos";
wchar_t Tema_4_1[] = L"Planificador del sistema en tiempo real";
wchar_t Subtema_4_1_1[] = L"Estructura de planificación";
wchar_t Subtema_4_1_2[] = L"Despachador";
wchar_t Tema_4_2[] = L"Enfoque cíclico";
wchar_t Tema_4_3[] = L"Algoritmos de planificación";
wchar_t Subtema_4_3_1[] = L"Planificación apropiativa y no apropiativa";
wchar_t Subtema_4_3_2[] = L"Planificación por prioridad";
wchar_t Subtema_4_3_3[] = L"Evaluación de los algoritmos";
wchar_t Tema_4_4[] = L"Procesos esporádicos y aperiodicos";
wchar_t Tema_4_5[] = L"Interacción de procesos y bloqueo";

wchar_t Unidad_5[] = L"";

wchar_t *unit[] = {Unidad_1, Unidad_2, Unidad_3, Unidad_4};
int numdtemas[] = {4, 5, 3, 5};


wchar_t *nombresdtemasdu1[] = { Tema_1_1, Tema_1_2, Tema_1_3, Tema_1_4 };
int   numdsubtemasdu1[] = {2, 1, 1, 0};
wchar_t *nombresdsubtemasdu1t1[] = { Subtema_1_1_1, Subtema_1_1_2 };
wchar_t *nombresdsubtemasdu1t2[] = { Subtema_1_2_1 };
wchar_t *nombresdsubtemasdu1t3[] = { Subtema_1_3_1 };
wchar_t *nombresdsubtemasdu1t4[] = { NULL };
wchar_t **nombresdsubtemasdu1[] = { nombresdsubtemasdu1t1, nombresdsubtemasdu1t2, nombresdsubtemasdu1t3, nombresdsubtemasdu1t4 };


wchar_t *nombresdtemasdu2[] = { Tema_2_1, Tema_2_2, Tema_2_3, Tema_2_4, Tema_2_5 };
int   numdsubtemasdu2[] = {2, 1, 3, 1, 1};
wchar_t *nombresdsubtemasdu2t1[] = { Subtema_2_1_1, Subtema_2_1_2 };
wchar_t *nombresdsubtemasdu2t2[] = { Subtema_2_2_1 };
wchar_t *nombresdsubtemasdu2t3[] = { Subtema_2_3_1, Subtema_2_3_2, Subtema_2_3_3 };
wchar_t *nombresdsubtemasdu2t4[] = { Subtema_2_4_1 };
wchar_t *nombresdsubtemasdu2t5[] = { Subtema_2_5_1 };
wchar_t **nombresdsubtemasdu2[] =  { nombresdsubtemasdu2t1, nombresdsubtemasdu2t2, nombresdsubtemasdu2t3, nombresdsubtemasdu2t4, nombresdsubtemasdu2t5 };

wchar_t *nombresdtemasdu3[] = { Tema_3_1, Tema_3_2, Tema_3_3 };
int   numdsubtemasdu3[] = {1, 3, 3};
wchar_t *nombresdsubtemasdu3t1[] = { Subtema_3_1_1 };
wchar_t *nombresdsubtemasdu3t2[] = { Subtema_3_2_1, Subtema_3_2_2, Subtema_3_2_3 };
wchar_t *nombresdsubtemasdu3t3[] = { Subtema_3_3_1, Subtema_3_3_2, Subtema_3_3_3 };
wchar_t **nombresdsubtemasdu3[] = { nombresdsubtemasdu3t1, nombresdsubtemasdu3t2, nombresdsubtemasdu3t3 };

wchar_t *nombresdtemasdu4[] = { Tema_4_1, Tema_4_2, Tema_4_3, Tema_4_4, Tema_4_5 };
int   numdsubtemasdu4[] = {2, 0, 3, 0, 0};
wchar_t *nombresdsubtemasdu4t1[] = { Subtema_4_1_1, Subtema_4_1_2 };
wchar_t *nombresdsubtemasdu4t2[] = { NULL };
wchar_t *nombresdsubtemasdu4t3[] = { Subtema_4_3_1, Subtema_4_3_2, Subtema_4_3_3 };
wchar_t *nombresdsubtemasdu4t4[] = { NULL };
wchar_t *nombresdsubtemasdu4t5[] = { NULL };
wchar_t **nombresdsubtemasdu4[] = { nombresdsubtemasdu4t1, nombresdsubtemasdu4t2, nombresdsubtemasdu4t3, nombresdsubtemasdu4t4, nombresdsubtemasdu4t5 };

wchar_t *nombresdtemasdu5[] = {NULL};


int *numdsubtemas[] = { numdsubtemasdu1, numdsubtemasdu2, numdsubtemasdu3, numdsubtemasdu4};
wchar_t ***nombresdsubtemas[] = { nombresdsubtemasdu1, nombresdsubtemasdu2, nombresdsubtemasdu3, nombresdsubtemasdu4 };

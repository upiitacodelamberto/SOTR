/**
 * $ matrices nro_de_procesos
 * Programa para multiplicar matices concurrentemente
 * REFERENCIA: Marquez F. (2004), UNIX Programacion Avanzada (3a Edicion), Espania: Alfaomega
 *             ISBN: 9701510496
 */
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h> 	/*pid_t*/
#include <sys/wait.h>	/*pid_t wait(int *status), man 2 wait*/
#include <sys/ipc.h>
#include <sys/sem.h>
#include <sys/shm.h>
#include <unistd.h> /*pid_t fork(void), man 2 fork*/

/*Definicion de matriz*/
typedef struct{
  /*Identificador de la zona de memoria compartida donde estara la matriz.*/
  int shmid;	/*shARED mEMORY id*/
  int filas,columnas;	/*Numero de filas y columnas de la matriz.*/
  float **coef;	/*Coeficientes de la matriz.*/
}matriz;

/**
 * crear_matriz: crea la memoria compartida donde se almacenara la matriz.
 */
matriz *crear_matriz(int filas,int columnas)
{
  int shmid,i;
  matriz *m;

  /*peticion de memoria compartida*/
  shmid=shmget(IPC_PRIVATE,
               sizeof(matriz)+filas*sizeof(float*)+
               filas*columnas*sizeof(float),
               IPC_CREAT|0600);
  if(shmid==-1){
    perror("crear_matriz(shmget)");
    exit(-1);
  }
  /*Atamos la memoria*/
  if((m=(matriz*)shmat(shmid,0,0))==(matriz*)-1){
    perror("crear_matriz(shmat)");
    exit(-1);
  }
  /*inicializacion de la matriz*/
  m->shmid=shmid;
  m->filas=filas;
  m->columnas=columnas;
  /*Formateamos la memoria para poder direccionar los coeficientes de la matriz.*/
  m->coef=(float**)&m->coef+sizeof(float**);
  for(i=0;i<filas;i++)
    m->coef[i]=(float*)&m->coef[filas]+i*columnas*sizeof(float);
  return m;
}//end crear_matriz()

/**
 * leer_matriz: lee una matriz del flujo estandar de entrada
 */
matriz *leer_matriz()
{
  int filas,columnas,i,j;
  matriz *m;
  printf("Filas: ");
  scanf("%d",&filas);
  printf("Columnas: ");
  scanf("%d",&columnas);
  m=crear_matriz(filas,columnas);
  for(i=0;i<filas;i++)
    for(j=0;j<columnas;j++){
      printf("[%d][%d]=",i,j);
      scanf("%f",*(m->coef+i)+j);
    }
  return m;
}//end leer_matriz

/**
 * multiplicar_matrices: multiplica dos matrices y crea una nueva para el 
 * resultado. El trabajo se distribuye entre el total de procesos que indique numproc.
 */
matriz *multiplicar_matrices(matriz *a,matriz *b,int numproc)
{
  int p,semid,estado;
  matriz *c;

  if(a->columnas!=b->filas)
    return NULL;
  c=crear_matriz(a->filas,b->columnas);
  /*Creacion de dos semaforos. Uno de ellos se inicializa con el total de filas de
    la matriz producto.*/
  semid=semget(IPC_PRIVATE,2,IPC_CREAT|0600);
  if(semid==-1){
    perror("multiplicar_matrices(semget)");
    exit(-1);
  }
  semctl(semid,0,SETVAL,1);
  semctl(semid,1,SETVAL,c->filas);
  /*Creacion de tantos procesos como indique numproc.*/
  for(p=0;p<numproc;p++){/*----- 1-for -----*/
    if(fork()==0){/*----- 2-if -----*/
      /*Codigo para los procesos hijo.*/
      int i,j,k;
      struct sembuf operacion;

      operacion.sem_flg=SEM_UNDO;
      while(1){/*----- 3-while -----*/
        /*Cada proceso hijo se encarga de generar una fila de la matriz
          producto. Para saber que columna tiene que generar, consulta el 
          valor del semaforo.*/
        /*Operacion \mathcal{P} sobre el semaforo 0.*/
        operacion.sem_num=0;
        operacion.sem_op=-1;
        semop(semid,&operacion,1);
        /*Consultamos el valor del semaforo*/
        i=semctl(semid,1,GETVAL,--i);
        if(i>0){
          /*Decrementamos el valor del semaforo 1 en una unidad.*/
          semctl(semid,1,SETVAL,--i);
          /*Operacion \mathcal{V} sobre el semaforo 0.*/
          operacion.sem_num=0;
          operacion.sem_op=1;
          semop(semid,&operacion,1);
        }else
          exit(0);
        /*Calculo de la fila i-esima de la matriz producto.*/
        for(j=0;j<c->columnas;j++){
          c->coef[i][j]=0;
          for(k=0;k<a->columnas;k++)
            c->coef[i][j]+=a->coef[i][k]*b->coef[k][j];
        }
      }/*----- 3-while -----*/
    }/*----- 2-if -----*/
  }/*----- 1-for -----*/
  /*Esperamos a que terminen todos los procesos.*/
  for(p=0;p<numproc;p++)
    wait(&estado);
  /*Borramos el semaforo.*/
  semctl(semid,0,IPC_RMID,0);
  return c;
}//end multiplicar_matrices()

/**
 * destruir_matriz: libera una zona de memoria compartida.
 */
void destruir_matriz(matriz *m)
{
  shmctl(m->shmid,IPC_RMID,0);
}

/**
 * imprimir_matriz: presenta una matriz en el flujo estandar de salida.
 */
void imprimir_matriz(matriz *m)
{
  int i,j;
  for(i=0;i<m->filas;i++){
    for(j=0;j<m->columnas;j++)
      printf("%g ",m->coef[i][j]);
    printf("\n");
  }
}//end imprimir_matriz()

/**
 * Funcion principal.
 */
void main(int argc,char *argv[])
{
  int numproc;
  matriz *a,*b,*c;

  /*Analisis de los argumentos de la linea de ordenes.*/
  if(argc!=2||(numproc=atoi(argv[1])<1))
    numproc=2;
  /*Lectura de las matrices.*/
  a=leer_matriz();
  b=leer_matriz();
  /*Procesamiento de las matrices.*/
  c=multiplicar_matrices(a,b,numproc);
  if(c!=NULL)
    imprimir_matriz(c);
  else
    fprintf(stderr,"Las matrices no se pueden multiplicar.");
  destruir_matriz(a);
  destruir_matriz(b);
  destruir_matriz(c);
}//end main()

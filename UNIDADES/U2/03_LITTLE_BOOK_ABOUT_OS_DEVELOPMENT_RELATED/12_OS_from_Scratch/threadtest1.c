#include "types.h"
#include "stat.h"
#include "fcntl.h"
#include "user.h"
#include "x86.h"
#include "threadlib.h"

typedef struct __counter_args {
	int *nLoops;
	int *count;
	struct node *nod;
	struct lock_t *lock;
} counter_args;


void *counter(void *arg)
{
	counter_args *args= (counter_args*)arg;

	int i;

	for(i = 0; i < *args->nLoops; i++)
	{
		lock_acquire(args->lock);
		(*args->count)++;
		agregar(args->nod,*args->count);
		lock_release(args->lock);
	}

	return NULL;
}

int
main(int argc, char *argv[])
{
	if(argc != 3)
	{
			printf(1, "Usage: threadtest1 numberOfThreads loopCount");
			exit();
	}
	
	int nThreads = atoi(argv[1]);
	int nLoops =  atoi(argv[2]);
	
	int count = 0;
	struct lock_t lock;
	lock_init(&lock);
	//struct node *Nod=(struct node*)malloc(sizeof(struct node));
	//Nod->next=0;
	//Nod->x=count;
	struct node Nod;
	Nod.next=0;
	Nod.x=count;

	counter_args args;
	args.nLoops = &nLoops;
	args.count = &count;
	args.nod=&Nod;
	args.lock = &lock;


	void * a = (void*) &args;

	int i;
	for(i = 0; i < nThreads; i++)
	{
		thread_create(counter, a);
	}

	for(i = 0; i < nThreads; i++)
	{
		thread_join();
	}
	
	printf(1, "Result is: %d\n", count);
	printnode(args.nod);
	exit();
}


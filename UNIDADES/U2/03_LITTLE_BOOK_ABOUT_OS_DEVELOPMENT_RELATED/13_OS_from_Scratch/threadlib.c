#include "types.h"
#include "stat.h"
#include "fcntl.h"
#include "user.h"
#include "x86.h"
#include "threadlib.h"

struct lock_t lock;

void thread_create(void *(*start_routine)(void*), void *arg)
{
  void *nSp = malloc(4096);
  int rc;
  rc = clone(nSp, 4096);

  if(rc == 0)
  {
    (*start_routine)(arg);
    exit();
  }
}

void thread_join()
{
  wait();
}

void lock_init(struct lock_t *lk)
{
    lk->locked = 0;
}

void lock_acquire(struct lock_t *lk)
{
  while(xchg(&lk->locked, 1) != 0)
      ;
}

void lock_release(struct lock_t *lk)
{
  xchg(&lk->locked, 0);
}

/**
  adds the int elem to the linked list list
*/
int agregar(struct node *list,int elem)
{
  if(list!=0){
    while(list->next!=0)
    {
      list=list->next;
    }
  }
  /*creates a node at the end of the list*/
  list->next=(struct node*)malloc(sizeof(struct node));
  list=list->next;
  if(list==0){
    printf(1,"Out of memory\n");
    return 0;
  }
  list->next=0;
  list->x=elem;
  return list->x;
}

void printnode(struct node *nod)
{
  if(nod!=0){
    while(nod->next!=0)
    {
      printf(1,"%d->",nod->x);
      nod=nod->next;
    }
    printf(1,"%d\n",nod->x);
  }
}

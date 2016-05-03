struct lock_t {
  uint locked;       // Is the lock held?
};

//for testing the thread library
struct node{
  int x;
  struct node *next;
};

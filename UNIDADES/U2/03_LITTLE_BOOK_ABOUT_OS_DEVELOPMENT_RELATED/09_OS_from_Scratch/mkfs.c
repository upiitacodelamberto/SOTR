#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <assert.h>

#define stat xv6_stat  // avoid clash with host struct stat
#include "types.h"
#include "fs.h"
#include "stat.h"
#include "param.h"

#ifndef static_assert
#define static_assert(a, b) do { switch (0) case 0: case (a): ; } while (0)
#endif

#define NINODES 200

// Disk layout:
// [ boot block | sb block | log | inode blocks | free bit map | data blocks ]

int nbitmap = FSSIZE/(BSIZE*8) + 1;
int ninodeblocks = NINODES / IPB + 1;
int nlog = LOGSIZE;  
int nmeta;    // Number of meta blocks (boot, sb, nlog, inode, bitmap)
int nblocks;  // Number of data blocks

int fsfd;
struct superblock sb;
char zeroes[BSIZE];
uint freeinode = 1;
uint freeblock;


void balloc(int);
void wsect(uint, void*);
void winode(uint, struct dinode*);
void rinode(uint inum, struct dinode *ip);
void rsect(uint sec, void *buf);
uint ialloc(ushort type);
void iappend(uint inum, void *p, int n);

// convert to intel byte order
ushort
xshort(ushort x)
{
  ushort y;
  uchar *a = (uchar*)&y;
  a[0] = x;
  a[1] = x >> 8;
  return y;
}

uint
xint(uint x)
{
  uint y;
  uchar *a = (uchar*)&y;
  a[0] = x;
  a[1] = x >> 8;
  a[2] = x >> 16;
  a[3] = x >> 24;
  return y;
}

int
main(int argc, char *argv[])
{
  int i, cc, fd;
  uint rootino, inum, off;
  struct dirent de;
  char buf[BSIZE];
  struct dinode din;


  static_assert(sizeof(int) == 4, "Integers must be 4 bytes!");

  if(argc < 2){
    fprintf(stderr, "Usage: mkfs fs.img files...\n");
    exit(1);
  }

  assert((BSIZE % sizeof(struct dinode)) == 0);
  assert((BSIZE % sizeof(struct dirent)) == 0);

  fsfd = open(argv[1], O_RDWR|O_CREAT|O_TRUNC, 0666);
  if(fsfd < 0){
    perror(argv[1]);
    exit(1);
  }

  // 1 fs block = 1 disk sector
  nmeta = 2 + nlog + ninodeblocks + nbitmap;
  nblocks = FSSIZE - nmeta;

  sb.size = xint(FSSIZE);
  sb.nblocks = xint(nblocks);
  sb.ninodes = xint(NINODES);
  sb.nlog = xint(nlog);
  sb.logstart = xint(2);
  sb.inodestart = xint(2+nlog);
  sb.bmapstart = xint(2+nlog+ninodeblocks);

  printf("nmeta %d (boot, super, log blocks %u inode blocks %u, bitmap blocks %u) blocks %d total %d\n",
         nmeta, nlog, ninodeblocks, nbitmap, nblocks, FSSIZE);

  freeblock = nmeta;     // the first free block that we can allocate

  for(i = 0; i < FSSIZE; i++)
    wsect(i, zeroes);

  memset(buf, 0, sizeof(buf));
  memmove(buf, &sb, sizeof(sb));
  wsect(1, buf);

  rootino = ialloc(T_DIR);
  assert(rootino == ROOTINO);

  bzero(&de, sizeof(de));
  de.inum = xshort(rootino);
  strcpy(de.name, ".");
  iappend(rootino, &de, sizeof(de));

  bzero(&de, sizeof(de));
  de.inum = xshort(rootino);
  strcpy(de.name, "..");
  iappend(rootino, &de, sizeof(de));

  for(i = 2; i < argc; i++){
    assert(index(argv[i], '/') == 0);

    if((fd = open(argv[i], 0)) < 0){
      perror(argv[i]);
      exit(1);
    }
    
    // Skip leading _ in name when writing to file system.
    // The binaries are named _rm, _cat, etc. to keep the
    // build operating system from trying to execute them
    // in place of system binaries like rm and cat.
    if(argv[i][0] == '_')
      ++argv[i];

    inum = ialloc(T_FILE);

    bzero(&de, sizeof(de));
    de.inum = xshort(inum);
    strncpy(de.name, argv[i], DIRSIZ);
    iappend(rootino, &de, sizeof(de));

    while((cc = read(fd, buf, sizeof(buf))) > 0)
      iappend(inum, buf, cc);

    close(fd);
  }

  // fix size of root inode dir
  rinode(rootino, &din);
  off = xint(din.size);
  off = ((off/BSIZE) + 1) * BSIZE;
  din.size = xint(off);
  winode(rootino, &din);

  balloc(freeblock);

  exit(0);
}

void
wsect(uint sec, void *buf)
{
  if(lseek(fsfd, sec * BSIZE, 0) != sec * BSIZE){
    perror("lseek");
    exit(1);
  }
  if(write(fsfd, buf, BSIZE) != BSIZE){
    perror("write");
    exit(1);
  }
}

void
winode(uint inum, struct dinode *ip)
{
  char buf[BSIZE];
  uint bn;
  struct dinode *dip;

  bn = IBLOCK(inum, sb);
  rsect(bn, buf);
  dip = ((struct dinode*)buf) + (inum % IPB);
  *dip = *ip;
  wsect(bn, buf);
}

void
rinode(uint inum, struct dinode *ip)
{
  char buf[BSIZE];
  uint bn;
  struct dinode *dip;

  bn = IBLOCK(inum, sb);
  rsect(bn, buf);
  dip = ((struct dinode*)buf) + (inum % IPB);
  *ip = *dip;
}

void
rsect(uint sec, void *buf)
{
  if(lseek(fsfd, sec * BSIZE, 0) != sec * BSIZE){
    perror("lseek");
    exit(1);
  }
  if(read(fsfd, buf, BSIZE) != BSIZE){
    perror("read");
    exit(1);
  }
}

uint
ialloc(ushort type)
{
  uint inum = freeinode++;
  struct dinode din;

  bzero(&din, sizeof(din));
  din.type = xshort(type);
  din.nlink = xshort(1);
  din.size = xint(0);
  winode(inum, &din);
  return inum;
}

void
balloc(int used)
{
  uchar buf[BSIZE];
  int i;

  printf("balloc: first %d blocks have been allocated\n", used);
  assert(used < BSIZE*8);
  bzero(buf, BSIZE);
  for(i = 0; i < used; i++){
    buf[i/8] = buf[i/8] | (0x1 << (i%8));
  }
  printf("balloc: write bitmap block at sector %d\n", sb.bmapstart);
  wsect(sb.bmapstart, buf);
}

#define min(a, b) ((a) < (b) ? (a) : (b))

void
iappend(uint inum, void *xp, int n)
{
  char *p = (char*)xp;
  uint fbn, off, n1;
  struct dinode din;
  char buf[BSIZE];
  uint indirect[NINDIRECT];
  uint x;

  rinode(inum, &din);
  off = xint(din.size);
  // printf("append inum %d at off %d sz %d\n", inum, off, n);
  while(n > 0){
    fbn = off / BSIZE;
    assert(fbn < MAXFILE);
    if(fbn < NDIRECT){
      if(xint(din.addrs[fbn]) == 0){
        din.addrs[fbn] = xint(freeblock++);
      }
      x = xint(din.addrs[fbn]);
    } else {
      if(xint(din.addrs[NDIRECT]) == 0){
        din.addrs[NDIRECT] = xint(freeblock++);
      }
      rsect(xint(din.addrs[NDIRECT]), (char*)indirect);
      if(indirect[fbn - NDIRECT] == 0){
        indirect[fbn - NDIRECT] = xint(freeblock++);
        wsect(xint(din.addrs[NDIRECT]), (char*)indirect);
      }
      x = xint(indirect[fbn-NDIRECT]);
    }
    n1 = min(n, (fbn + 1) * BSIZE - off);
    rsect(x, buf);
    bcopy(p, buf + off - (fbn * BSIZE), n1);
    wsect(x, buf);
    n -= n1;
    off += n1;
    p += n1;
  }
  din.size = xint(off);
  winode(inum, &din);
}

/*****************************************************/
#include "buf.h"
//#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"
//#include "x86.h"

// Key addresses for address space layout (see kmap in vm.c for layout)
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

struct buf* bread_1(uint dev, uint blockno);
//void log_write_1(struct buf *b);
//void brelse_1(struct buf *b);
////static struct buf* bget_1(uint dev, uint blockno);
//void            sleep(void*, struct spinlock*);
void iderw(struct buf *b);
//void iderw_1(struct buf *b);
void panic_1(char*) __attribute__((noreturn));
//void            acquire(struct spinlock*);
void            release(struct spinlock*);
//void            wakeup(void*);
//void            ideinit(void);
//20160321
//static struct buf* bget(uint dev, uint blockno);
struct buf* bget(uint dev, uint blockno);
// idequeue points to the buf now being read/written to the disk.
// idequeue->qnext points to the next buf to be processed.
// You must hold idelock while manipulating queue.

//static struct spinlock idelock_1;
//static struct buf *idequeue_1;
//static int havedisk_1;
//static void idestart_1(struct buf*);
//void            sleep_1(void*, struct spinlock*);
//void            sleep(void*, struct spinlock*);

struct {
  struct spinlock lock;
  struct buf buf[NBUF];

  // Linked list of all buffers, through prev/next.
  // head.next is most recently used.
  struct buf head;
} bcache;

// Contents of the header block, used for both the on-disk header block
// and to keep track in memory of logged block# before commit.
struct logheader_1 {
  int n;   
  int block[LOGSIZE];
};

//struct log_1 {
//  struct spinlock lock;
//  int start;
//  int size;
//  int outstanding; // how many FS sys calls are executing.
//  int committing;  // in commit(), please wait.
//  int dev;
//  struct logheader_1 lh;
//};
//struct log_1 log;

//static int panicked_1 = 0;

//static struct {
//  struct spinlock lock;
//  int locking;
//} cons_1;


/*
 Remplazar a fs.c::static void bzero(int dev,int bno)
*/
//// Zero a block.
//static void
//bzero_1(int dev, int bno)
//{
//  struct buf *bp;
//  
//  bp = bread_1(dev, bno);
//  memset(bp->data, 0, BSIZE);
//  log_write_1(bp);
//  brelse_1(bp);
//}
extern struct cpu *cpu asm("%gs:0");       // &cpus[cpunum()]
static inline uint
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
}
/*
 Remplazar a bio.c::struct buf* bread(uint dev, uint blockno)
*/
//// Return a B_BUSY buf with the contents of the indicated block.
//struct buf*
//bread_1(uint dev, uint blockno)
//{
//  struct buf *b;
//
////  b = bget(dev, blockno);
//struct buf *b1;
//acquire(&bcache.lock);
//struct spinlock *lk=&bcache.lock;
////pushcli(); // disable interrupts to avoid deadlock.
//  uint eflags;
//  
////  eflags = readeflags();
//  asm volatile("pushfl; popl %0" : "=r" (eflags));
////cli();
//  asm volatile("cli");
//  if(cpu->ncli++ == 0)
//end pushcli()
////if(holding(lk))
//if(lk->locked && lk->cpu == cpu)
////  panic("acquire");
//  panic_1("acquire");
//
//// The xchg is atomic.
//// It also serializes, so that reads after acquire are not
//// reordered before it. 
//while(xchg(&lk->locked, 1) != 0)
//  ;
//
//// Record info about lock acquisition for debugging.
//lk->cpu = cpu;
////getcallerpcs(&lk, lk->pcs);
//struct spinlock *v=lk;
//uint *pcs=lk->pcs;
//  uint *ebp1;
//  int i1;
//  
//  ebp1 = (uint*)v - 2;
//  for(i1 = 0; i1 < 10; i1++){
//    if(ebp1 == 0 || ebp1 < (uint*)KERNBASE || ebp1 == (uint*)0xffffffff)
//      break;
//    pcs[i1] = ebp1[1];     // saved %eip
//    ebp1 = (uint*)ebp1[0]; // saved %ebp
//  }
//  for(; i1 < 10; i1++)
//    pcs[i1] = 0;
////end getcallerpcs
//loop:
//// Is the block already cached?
//for(b1 = bcache.head.next; b1 != &bcache.head; b1 = b1->next){
//  if(b1->dev == dev && b1->blockno == blockno){
//    if(!(b1->flags & B_BUSY)){
//      b1->flags |= B_BUSY;
////      release(&bcache.lock);
//lk=&bcache.lock;
////if(!holding(lk))
//if(lk->locked && lk->cpu == cpu)
////  panic("release");
//  panic_1("release");
//
//lk->pcs[0] = 0;
//lk->cpu = 0;
//
//// The xchg serializes, so that reads before release are 
//// not reordered after it.  The 1996 PentiumPro manual (Volume 3,
//// 7.2) says reads can be carried out speculatively and in
//// any order, which implies we need to serialize here.
//// But the 2007 Intel 64 Architecture Memory Ordering White
//// Paper says that Intel 64 and IA-32 will not move a load
//// after a store. So lock->locked = 0 would work here.
//// The xchg being asm volatile ensures gcc emits it after
//// the above assignments (and after the critical section).
//xchg(&lk->locked, 0);
//
////popcli();
//  if(readeflags()&FL_IF)
//asm volatile("pushfl; popl %0" : "=r" (eflags));
//  if(eflags&FL_IF)
//    //panic("popcli - interruptible");
//    panic_1("popcli - interruptible");
//  if(--cpu->ncli < 0)
//    //panic("popcli");
//    panic_1("popcli");
//  if(cpu->ncli == 0 && cpu->intena)
//    //sti();
//  asm volatile("sti");
////end popcli
////end release
////      return b;
//      b=b1;
//    }
//    sleep(b1, &bcache.lock);
////void            sleep(void*, struct spinlock*);
//    goto loop;
//  }
//}
//// Not cached; recycle some non-busy and clean buffer.
//// "clean" because B_DIRTY and !B_BUSY means log.c
//// hasn't yet committed the changes to the buffer.
//for(b1 = bcache.head.prev; b1 != &bcache.head; b1 = b1->prev){
//  if((b1->flags & B_BUSY) == 0 && (b1->flags & B_DIRTY) == 0){
//    b1->dev = dev;
//    b1->blockno = blockno;
//    b1->flags = B_BUSY;
//    release(&bcache.lock);
////    return b;
//    b=b1;
//  }
//}
////panic("bget_1: no buffers");
//panic_1("bget_1: no buffers");
//  if(!(b->flags & B_VALID)) {
//    iderw(b);
//  }
//  return b;
//}
//
////// Caller has modified b->data and is done with the buffer.
////// Record the block number and pin in the cache with B_DIRTY.
//// commit()/write_log() will do the disk write.
////
//// log_write() replaces bwrite(); a typical use is:
////   bp = bread(...)
////   modify bp->data[]
////   log_write(bp)
////   brelse(bp)
/*
Remmplaza a log.c::void log_write(struct buf *b)
*/
//void log_write_1(struct buf *b)
//{
//  int i;
//
//  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
//    panic_1("too big a transaction");
//  if (log.outstanding < 1)
//    panic_1("log_write outside of trans");
//
//  acquire(&log.lock);
//  for (i = 0; i < log.lh.n; i++) {
//    if (log.lh.block[i] == b->blockno)   // log absorbtion
//      break;
//  }
//  log.lh.block[i] = b->blockno;
//  if (i == log.lh.n)
//    log.lh.n++;
//  b->flags |= B_DIRTY; // prevent eviction
//  release(&log.lock);
//}

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
/*
Remplaza a bio.c::void brelse(struct buf *b)
*/
//void brelse_1(struct buf *b)
//{
//  if((b->flags & B_BUSY) == 0)
//    panic_1("brelse");
//
//  acquire(&bcache.lock);
//
//  b->next->prev = b->prev;
//  b->prev->next = b->next;
//  b->next = bcache.head.next;
//  b->prev = &bcache.head;
//  bcache.head.next->prev = b;
//  bcache.head.next = b;
//
//  b->flags &= ~B_BUSY;
//  wakeup(b);
//
//  release(&bcache.lock);
//}

// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
/*
Remplaa a bio.c::static struct buf* bget(uint dev,uintblockno)
*/
////static struct buf* bget_1(uint dev, uint blockno)
////{
////  struct buf *b;
////
////  acquire(&bcache.lock);
////
//// loop:
////  // Is the block already cached?
////  for(b = bcache.head.next; b != &bcache.head; b = b->next){
////    if(b->dev == dev && b->blockno == blockno){
////      if(!(b->flags & B_BUSY)){
////        b->flags |= B_BUSY;
////        release(&bcache.lock);
////        return b;
////      }
////      sleep(b, &bcache.lock);
////      goto loop;
////    }
////  }
////
////  // Not cached; recycle some non-busy and clean buffer.
////  // "clean" because B_DIRTY and !B_BUSY means log.c
////  // hasn't yet committed the changes to the buffer.
////  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
////    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
////      b->dev = dev;
////      b->blockno = blockno;
////      b->flags = B_BUSY;
////      release(&bcache.lock);
////      return b;
////    }
////  }
////  panic_1("bget: no buffers");
////}

// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
//void iderw_1(struct buf *b)
//{
//  struct buf **pp;
//
//  if(!(b->flags & B_BUSY))
//    panic_1("iderw: buf not busy");
//  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
//    panic_1("iderw_1: nothing to do");
//  if(b->dev != 0 && !havedisk_1)
//    panic_1("iderw: ide disk 1 not present");
//
//  acquire(&idelock_1);  //DOC:acquire-lock
//
//  // Append b to idequeue.
//  b->qnext = 0;
//  for(pp=&idequeue_1; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
//    ;
//  *pp = b;
//  
//  // Start disk if necessary.
//  if(idequeue_1 == b)
//    idestart_1(b);
//  
//  // Wait for request to finish.
//  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
//    sleep_1(b, &idelock_1);
//  }
//
//  release(&idelock_1);
//}
//
void panic_1(char *s)
{
//  int i;
//  uint pcs[10];
//  
//  cli();
  asm volatile("cli");
//  cons_1.locking = 0;
//  cprintf("cpu%d: panic: ", cpu->id);
//  cprintf(s);
//  cprintf("\n");
//  getcallerpcs(&s, pcs);
//  for(i=0; i<10; i++)
//    cprintf(" %p", pcs[i]);
//  panicked_1 = 1; // freeze other CPU
  for(;;)
    ;
}
//
//// Start the request for b.  Caller must hold idelocki_1.
//static void idestart_1(struct buf *b)
//{
//  if(b == 0)
//    panic_1("idestart");
//  if(b->blockno >= FSSIZE)
//    panic_1("incorrect blockno");
//  int sector_per_block =  BSIZE/SECTOR_SIZE;
//  int sector = b->blockno * sector_per_block;
//
//  if (sector_per_block > 7) panic("idestart");
//  
//  idewait(0);
//  outb(0x3f6, 0);  // generate interrupt
//  outb(0x1f2, sector_per_block);  // number of sectors
//  outb(0x1f3, sector & 0xff);
//  outb(0x1f4, (sector >> 8) & 0xff);
//  outb(0x1f5, (sector >> 16) & 0xff);
//  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
//  if(b->flags & B_DIRTY){
//    outb(0x1f7, IDE_CMD_WRITE);
//    outsl(0x1f0, b->data, BSIZE/4);
//  } else {
//    outb(0x1f7, IDE_CMD_READ);
//  }
//}


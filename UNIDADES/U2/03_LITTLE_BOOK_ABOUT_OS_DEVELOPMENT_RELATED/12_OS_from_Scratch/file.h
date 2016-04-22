struct file {
  enum { FD_NONE, FD_PIPE, FD_INODE } type;
  int ref; // reference count
  char readable;
  char writable;
  struct pipe *pipe;
  struct inode *ip;
  uint off;
};


// in-memory copy of an inode
struct inode {
  uint dev;           // Device number
  uint inum;          // Inode number
  int ref;            // Reference count
  int flags;          // I_BUSY, I_VALID

  short type;         // copy of disk inode
  short major;
  short minor;
  short nlink;
  short ownerid;      //The id of the user who owns the file
  short groupid;      //The id of the group who owns the file
  uint mode;          //The files mode e.g. 0700
  uint size;
  uint addrs[NDIRECT+1];
};
#define I_BUSY 0x1
#define I_VALID 0x2

// table mapping major device number to
// device functions
struct devsw {
  int (*read)(struct inode*, char*, int);
//20160313--
  int (*write)(struct inode*, char*, int);
//  int (*write)(char*, int);
};

extern struct devsw devsw[];

#define CONSOLE 1

//PAGEBREAK!
// Blank page.

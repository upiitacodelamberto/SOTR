# 1 "main.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 31 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 32 "<command-line>" 2
# 1 "main.c"







# 1 "include/unistd.h" 1
# 53 "include/unistd.h"
# 1 "include/sys/stat.h" 1



# 1 "include/sys/types.h" 1





typedef unsigned int size_t;




typedef long time_t;




typedef long ptrdiff_t;






typedef int pid_t;
typedef unsigned short uid_t;
typedef unsigned char gid_t;
typedef unsigned short dev_t;
typedef unsigned short ino_t;
typedef unsigned short mode_t;
typedef unsigned short umode_t;
typedef unsigned char nlink_t;
typedef int daddr_t;
typedef long off_t;
typedef unsigned char u_char;
typedef unsigned short ushort;

typedef struct { int quot,rem; } div_t;
typedef struct { long quot,rem; } ldiv_t;

struct ustat {
 daddr_t f_tfree;
 ino_t f_tinode;
 char f_fname[6];
 char f_fpack[6];
};
# 5 "include/sys/stat.h" 2

struct stat {
 dev_t st_dev;
 ino_t st_ino;
 umode_t st_mode;
 nlink_t st_nlink;
 uid_t st_uid;
 gid_t st_gid;
 dev_t st_rdev;
 off_t st_size;
 time_t st_atime;
 time_t st_mtime;
 time_t st_ctime;
};
# 51 "include/sys/stat.h"
extern int chmod(const char *_path, mode_t mode);
extern int fstat(int fildes, struct stat *stat_buf);
extern int mkdir(const char *_path, mode_t mode);
extern int mkfifo(const char *_path, mode_t mode);
extern int stat(const char *filename, struct stat *stat_buf);
extern mode_t umask(mode_t mask);
# 54 "include/unistd.h" 2
# 1 "include/sys/times.h" 1





struct tms {
 time_t tms_utime;
 time_t tms_stime;
 time_t tms_cutime;
 time_t tms_cstime;
};

extern time_t times(struct tms * tp);
# 55 "include/unistd.h" 2
# 1 "include/sys/utsname.h" 1





struct utsname {
 char sysname[9];
 char nodename[9];
 char release[9];
 char version[9];
 char machine[9];
};

extern int uname(struct utsname * utsbuf);
# 56 "include/unistd.h" 2
# 1 "include/utime.h" 1





struct utimbuf {
 time_t actime;
 time_t modtime;
};

extern int utime(const char *filename, struct utimbuf *times);
# 57 "include/unistd.h" 2
# 189 "include/unistd.h"
extern int errno;

int access(const char * filename, mode_t mode);
int acct(const char * filename);
int alarm(int sec);
int brk(void * end_data_segment);
void * sbrk(ptrdiff_t increment);
int chdir(const char * filename);
int chmod(const char * filename, mode_t mode);
int chown(const char * filename, uid_t owner, gid_t group);
int chroot(const char * filename);
int close(int fildes);
int creat(const char * filename, mode_t mode);
int dup(int fildes);
int execve(const char * filename, char ** argv, char ** envp);
int execv(const char * pathname, char ** argv);
int execvp(const char * file, char ** argv);
int execl(const char * pathname, char * arg0, ...);
int execlp(const char * file, char * arg0, ...);
int execle(const char * pathname, char * arg0, ...);

void _exit(int status);

int fcntl(int fildes, int cmd, ...);
static int fork(void);
int getpid(void);
int getuid(void);
int geteuid(void);
int getgid(void);
int getegid(void);
int ioctl(int fildes, int cmd, ...);
int kill(pid_t pid, int signal);
int link(const char * filename1, const char * filename2);
int lseek(int fildes, off_t offset, int origin);
int mknod(const char * filename, mode_t mode, dev_t dev);
int mount(const char * specialfile, const char * dir, int rwflag);
int nice(int val);
int open(const char * filename, int flag, ...);
static int pause(void);
int pipe(int * fildes);
int read(int fildes, char * buf, off_t count);
int setpgrp(void);
int setpgid(pid_t pid,pid_t pgid);
int setuid(uid_t uid);
int setgid(gid_t gid);
void (*signal(int sig, void (*fn)(int)))(int);
int stat(const char * filename, struct stat * stat_buf);
int fstat(int fildes, struct stat * stat_buf);
int stime(time_t * tptr);
static int sync(void);
time_t time(time_t * tloc);
time_t times(struct tms * tbuf);
int ulimit(int cmd, long limit);
mode_t umask(mode_t mask);
int umount(const char * specialfile);
int uname(struct utsname * name);
int unlink(const char * filename);
int ustat(dev_t dev, struct ustat * ubuf);
int utime(const char * filename, struct utimbuf * times);
pid_t waitpid(pid_t pid,int * wait_stat,int options);
pid_t wait(int * wait_stat);
int write(int fildes, const char * buf, off_t count);
int dup2(int oldfd, int newfd);
int getppid(void);
pid_t getpgrp(void);
pid_t setsid(void);
# 9 "main.c" 2
# 1 "include/time.h" 1
# 16 "include/time.h"
typedef long clock_t;

struct tm {
 int tm_sec;
 int tm_min;
 int tm_hour;
 int tm_mday;
 int tm_mon;
 int tm_year;
 int tm_wday;
 int tm_yday;
 int tm_isdst;
};

clock_t clock(void);
time_t time(time_t * tp);
double difftime(time_t time2, time_t time1);
time_t mktime(struct tm * tp);

char * asctime(const struct tm * tp);
char * ctime(const time_t * tp);
struct tm * gmtime(const time_t *tp);
struct tm *localtime(const time_t * tp);
size_t strftime(char * s, size_t smax, const char * fmt, const struct tm * tp);
void tzset(void);
# 10 "main.c" 2
# 26 "main.c"
static inline pause(void) __attribute__((always_inline));



static inline int pause(void) { long __res; __asm__ volatile ("int $0x80" : "=a" (__res) : "0" (29)); if (__res >= 0) return (int) __res; errno = -__res; return -1; }





# 1 "include/linux/tty.h" 1
# 12 "include/linux/tty.h"
# 1 "include/termios.h" 1
# 36 "include/termios.h"
struct winsize {
 unsigned short ws_row;
 unsigned short ws_col;
 unsigned short ws_xpixel;
 unsigned short ws_ypixel;
};


struct termio {
 unsigned short c_iflag;
 unsigned short c_oflag;
 unsigned short c_cflag;
 unsigned short c_lflag;
 unsigned char c_line;
 unsigned char c_cc[8];
};


struct termios {
 unsigned long c_iflag;
 unsigned long c_oflag;
 unsigned long c_cflag;
 unsigned long c_lflag;
 unsigned char c_line;
 unsigned char c_cc[17];
};
# 214 "include/termios.h"
typedef int speed_t;

extern speed_t cfgetispeed(struct termios *termios_p);
extern speed_t cfgetospeed(struct termios *termios_p);
extern int cfsetispeed(struct termios *termios_p, speed_t speed);
extern int cfsetospeed(struct termios *termios_p, speed_t speed);
extern int tcdrain(int fildes);
extern int tcflow(int fildes, int action);
extern int tcflush(int fildes, int queue_selector);
extern int tcgetattr(int fildes, struct termios *termios_p);
extern int tcsendbreak(int fildes, int duration);
extern int tcsetattr(int fildes, int optional_actions,
 struct termios *termios_p);
# 13 "include/linux/tty.h" 2



struct tty_queue {
 unsigned long data;
 unsigned long head;
 unsigned long tail;
 struct task_struct * proc_list;
 char buf[1024];
};
# 45 "include/linux/tty.h"
struct tty_struct {
 struct termios termios;
 int pgrp;
 int stopped;
 void (*write)(struct tty_struct * tty);
 struct tty_queue read_q;
 struct tty_queue write_q;
 struct tty_queue secondary;
 };

extern struct tty_struct tty_table[];
# 65 "include/linux/tty.h"
void rs_init(void);
void con_init(void);
void tty_init(void);

int tty_read(unsigned c, char * buf, int n);
int tty_write(unsigned c, char * buf, int n);

void rs_write(struct tty_struct * tty);
void con_write(struct tty_struct * tty);

void copy_to_cooked(struct tty_struct * tty);
# 37 "main.c" 2
# 1 "include/linux/sched.h" 1
# 10 "include/linux/sched.h"
# 1 "include/linux/head.h" 1



typedef struct desc_struct {
 unsigned long a,b;
} desc_table[256];

extern unsigned long pg_dir[1024];
extern desc_table idt,gdt;
# 11 "include/linux/sched.h" 2
# 1 "include/linux/fs.h" 1
# 31 "include/linux/fs.h"
void buffer_init(long buffer_end);
# 66 "include/linux/fs.h"
typedef char buffer_block[1024];

struct buffer_head {
 char * b_data;
 unsigned long b_blocknr;
 unsigned short b_dev;
 unsigned char b_uptodate;
 unsigned char b_dirt;
 unsigned char b_count;
 unsigned char b_lock;
 struct task_struct * b_wait;
 struct buffer_head * b_prev;
 struct buffer_head * b_next;
 struct buffer_head * b_prev_free;
 struct buffer_head * b_next_free;
};

struct d_inode {
 unsigned short i_mode;
 unsigned short i_uid;
 unsigned long i_size;
 unsigned long i_time;
 unsigned char i_gid;
 unsigned char i_nlinks;
 unsigned short i_zone[9];
};

struct m_inode {
 unsigned short i_mode;
 unsigned short i_uid;
 unsigned long i_size;
 unsigned long i_mtime;
 unsigned char i_gid;
 unsigned char i_nlinks;
 unsigned short i_zone[9];

 struct task_struct * i_wait;
 unsigned long i_atime;
 unsigned long i_ctime;
 unsigned short i_dev;
 unsigned short i_num;
 unsigned short i_count;
 unsigned char i_lock;
 unsigned char i_dirt;
 unsigned char i_pipe;
 unsigned char i_mount;
 unsigned char i_seek;
 unsigned char i_update;
};

struct file {
 unsigned short f_mode;
 unsigned short f_flags;
 unsigned short f_count;
 struct m_inode * f_inode;
 off_t f_pos;
};

struct super_block {
 unsigned short s_ninodes;
 unsigned short s_nzones;
 unsigned short s_imap_blocks;
 unsigned short s_zmap_blocks;
 unsigned short s_firstdatazone;
 unsigned short s_log_zone_size;
 unsigned long s_max_size;
 unsigned short s_magic;

 struct buffer_head * s_imap[8];
 struct buffer_head * s_zmap[8];
 unsigned short s_dev;
 struct m_inode * s_isup;
 struct m_inode * s_imount;
 unsigned long s_time;
 struct task_struct * s_wait;
 unsigned char s_lock;
 unsigned char s_rd_only;
 unsigned char s_dirt;
};

struct d_super_block {
 unsigned short s_ninodes;
 unsigned short s_nzones;
 unsigned short s_imap_blocks;
 unsigned short s_zmap_blocks;
 unsigned short s_firstdatazone;
 unsigned short s_log_zone_size;
 unsigned long s_max_size;
 unsigned short s_magic;
};

struct dir_entry {
 unsigned short inode;
 char name[14];
};

extern struct m_inode inode_table[32];
extern struct file file_table[64];
extern struct super_block super_block[8];
extern struct buffer_head * start_buffer;
extern int nr_buffers;

extern void check_disk_change(int dev);
extern int floppy_change(unsigned int nr);
extern int ticks_to_floppy_on(unsigned int dev);
extern void floppy_on(unsigned int dev);
extern void floppy_off(unsigned int dev);
extern void truncate(struct m_inode * inode);
extern void sync_inodes(void);
extern void wait_on(struct m_inode * inode);
extern int bmap(struct m_inode * inode,int block);
extern int create_block(struct m_inode * inode,int block);
extern struct m_inode * namei(const char * pathname);
extern int open_namei(const char * pathname, int flag, int mode,
 struct m_inode ** res_inode);
extern void iput(struct m_inode * inode);
extern struct m_inode * iget(int dev,int nr);
extern struct m_inode * get_empty_inode(void);
extern struct m_inode * get_pipe_inode(void);
extern struct buffer_head * get_hash_table(int dev, int block);
extern struct buffer_head * getblk(int dev, int block);
extern void ll_rw_block(int rw, struct buffer_head * bh);
extern void brelse(struct buffer_head * buf);
extern struct buffer_head * bread(int dev,int block);
extern void bread_page(unsigned long addr,int dev,int b[4]);
extern struct buffer_head * breada(int dev,int block,...);
extern int new_block(int dev);
extern void free_block(int dev, int block);
extern struct m_inode * new_inode(int dev);
extern void free_inode(struct m_inode * inode);
extern int sync_dev(int dev);
extern struct super_block * get_super(int dev);
extern int ROOT_DEV;

extern void mount_root(void);
# 12 "include/linux/sched.h" 2
# 1 "include/linux/mm.h" 1





extern unsigned long get_free_page(void);
extern unsigned long put_page(unsigned long page,unsigned long address);
extern void free_page(unsigned long addr);
# 13 "include/linux/sched.h" 2
# 1 "include/signal.h" 1





typedef int sig_atomic_t;
typedef unsigned int sigset_t;
# 48 "include/signal.h"
struct sigaction {
 void (*sa_handler)(int);
 sigset_t sa_mask;
 int sa_flags;
 void (*sa_restorer)(void);
};

void (*signal(int _sig, void (*_func)(int)))(int);
int raise(int sig);
int kill(pid_t pid, int sig);
int sigaddset(sigset_t *mask, int signo);
int sigdelset(sigset_t *mask, int signo);
int sigemptyset(sigset_t *mask);
int sigfillset(sigset_t *mask);
int sigismember(sigset_t *mask, int signo);
int sigpending(sigset_t *set);
int sigprocmask(int how, sigset_t *set, sigset_t *oldset);
int sigsuspend(sigset_t *sigmask);
int sigaction(int sig, struct sigaction *act, struct sigaction *oldact);
# 14 "include/linux/sched.h" 2
# 29 "include/linux/sched.h"
extern int copy_page_tables(unsigned long from, unsigned long to, long size);
extern int free_page_tables(unsigned long from, unsigned long size);

extern void sched_init(void);
extern void schedule(void);
extern void trap_init(void);

void panic(const char * str);

extern int tty_write(unsigned minor,char * buf,int count);

typedef int (*fn_ptr)();

struct i387_struct {
 long cwd;
 long swd;
 long twd;
 long fip;
 long fcs;
 long foo;
 long fos;
 long st_space[20];
};

struct tss_struct {
 long back_link;
 long esp0;
 long ss0;
 long esp1;
 long ss1;
 long esp2;
 long ss2;
 long cr3;
 long eip;
 long eflags;
 long eax,ecx,edx,ebx;
 long esp;
 long ebp;
 long esi;
 long edi;
 long es;
 long cs;
 long ss;
 long ds;
 long fs;
 long gs;
 long ldt;
 long trace_bitmap;
 struct i387_struct i387;
};

struct task_struct {

 long state;
 long counter;
 long priority;
 long signal;
 struct sigaction sigaction[32];
 long blocked;

 int exit_code;
 unsigned long start_code,end_code,end_data,brk,start_stack;
 long pid,father,pgrp,session,leader;
 unsigned short uid,euid,suid;
 unsigned short gid,egid,sgid;
 long alarm;
 long utime,stime,cutime,cstime,start_time;
 unsigned short used_math;

 int tty;
 unsigned short umask;
 struct m_inode * pwd;
 struct m_inode * root;
 struct m_inode * executable;
 unsigned long close_on_exec;
 struct file * filp[20];

 struct desc_struct ldt[3];

 struct tss_struct tss;
};
# 138 "include/linux/sched.h"
extern struct task_struct *task[64];
extern struct task_struct *last_task_used_math;
extern struct task_struct *current;
extern long volatile jiffies;
extern long startup_time;



extern void add_timer(long jiffies, void (*fn)(void));
extern void sleep_on(struct task_struct ** p);
extern void interruptible_sleep_on(struct task_struct ** p);
extern void wake_up(struct task_struct ** p);
# 235 "include/linux/sched.h"
static inline unsigned long _get_base(char * addr)
{
         unsigned long __base;
         __asm__("movb %3,%%dh\n\t"
                 "movb %2,%%dl\n\t"
                 "shll $16,%%edx\n\t"
                 "movw %1,%%dx"
                 :"=&d" (__base)
                 :"m" (*((addr)+2)),
                  "m" (*((addr)+4)),
                  "m" (*((addr)+7)));
         return __base;
}
# 38 "main.c" 2

# 1 "include/asm/system.h" 1
# 40 "main.c" 2
# 1 "include/asm/io.h" 1
# 41 "main.c" 2

# 1 "include/stddef.h" 1
# 43 "main.c" 2
# 1 "include/stdarg.h" 1



typedef char *va_list;
# 21 "include/stdarg.h"
void va_end (va_list);
# 44 "main.c" 2

# 1 "include/fcntl.h" 1
# 43 "include/fcntl.h"
struct flock {
 short l_type;
 short l_whence;
 off_t l_start;
 off_t l_len;
 pid_t l_pid;
};

extern int creat(const char * filename,mode_t mode);
extern int fcntl(int fildes,int cmd, ...);
extern int open(const char * filename, int flags, ...);
# 46 "main.c" 2




static char printbuf[1024];

extern int vsprintf();
extern void init(void);
extern void blk_dev_init(void);
extern void chr_dev_init(void);
extern void hd_init(void);
extern void floppy_init(void);
extern void mem_init(long start, long end);
extern long rd_init(long mem_start, int length);
extern long kernel_mktime(struct tm * tm);
extern long startup_time;
# 107 "main.c"
static long memory_end = 0;
static long buffer_memory_end = 0;
static long main_memory_start = 0;

struct drive_info { char dummy[32]; } drive_info;

void main(void)
{
# 166 "main.c"
 for(;;) pause();
}

static int printf(const char *fmt, ...)
{
 va_list args;
 int i;

 (args = ((char *) &(fmt) + (((sizeof (fmt) + sizeof (int) - 1) / sizeof (int)) * sizeof (int))));
 write(1,printbuf,i=vsprintf(printbuf, fmt, args));
 ;
 return i;
}

static char * argv_rc[] = { "/bin/sh", ((void *)0) };
static char * envp_rc[] = { "HOME=/", ((void *)0) };

static char * argv[] = { "-/bin/sh",((void *)0) };
static char * envp[] = { "HOME=/usr/root", ((void *)0) };

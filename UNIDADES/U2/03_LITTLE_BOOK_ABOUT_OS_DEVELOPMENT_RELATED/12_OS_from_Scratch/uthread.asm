
_uthread:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <thread_init>:
thread_p  next_thread;
extern void thread_switch(void);

void 
thread_init(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
  current_thread = &all_thread[0];
   3:	c7 05 6c 8d 00 00 40 	movl   $0xd40,0x8d6c
   a:	0d 00 00 
  current_thread->state = RUNNING;
   d:	a1 6c 8d 00 00       	mov    0x8d6c,%eax
  12:	c7 80 04 20 00 00 01 	movl   $0x1,0x2004(%eax)
  19:	00 00 00 
}
  1c:	5d                   	pop    %ebp
  1d:	c3                   	ret    

0000001e <thread_schedule>:

static void 
thread_schedule(void)
{
  1e:	55                   	push   %ebp
  1f:	89 e5                	mov    %esp,%ebp
  21:	83 ec 18             	sub    $0x18,%esp
  thread_p t;

  /* Find another runnable thread. */
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  24:	c7 45 f4 40 0d 00 00 	movl   $0xd40,-0xc(%ebp)
  2b:	eb 29                	jmp    56 <thread_schedule+0x38>
    if (t->state == RUNNABLE && t != current_thread) {
  2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  30:	8b 80 04 20 00 00    	mov    0x2004(%eax),%eax
  36:	83 f8 02             	cmp    $0x2,%eax
  39:	75 14                	jne    4f <thread_schedule+0x31>
  3b:	a1 6c 8d 00 00       	mov    0x8d6c,%eax
  40:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  43:	74 0a                	je     4f <thread_schedule+0x31>
      next_thread = t;
  45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  48:	a3 70 8d 00 00       	mov    %eax,0x8d70
      break;
  4d:	eb 10                	jmp    5f <thread_schedule+0x41>
thread_schedule(void)
{
  thread_p t;

  /* Find another runnable thread. */
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  4f:	81 45 f4 08 20 00 00 	addl   $0x2008,-0xc(%ebp)
  56:	81 7d f4 60 8d 00 00 	cmpl   $0x8d60,-0xc(%ebp)
  5d:	72 ce                	jb     2d <thread_schedule+0xf>
      next_thread = t;
      break;
    }
  }

  if (t >= all_thread + MAX_THREAD && current_thread->state == RUNNABLE) {
  5f:	81 7d f4 60 8d 00 00 	cmpl   $0x8d60,-0xc(%ebp)
  66:	72 1a                	jb     82 <thread_schedule+0x64>
  68:	a1 6c 8d 00 00       	mov    0x8d6c,%eax
  6d:	8b 80 04 20 00 00    	mov    0x2004(%eax),%eax
  73:	83 f8 02             	cmp    $0x2,%eax
  76:	75 0a                	jne    82 <thread_schedule+0x64>
    /* The current thread is the only runnable thread; run it. */
    next_thread = current_thread;
  78:	a1 6c 8d 00 00       	mov    0x8d6c,%eax
  7d:	a3 70 8d 00 00       	mov    %eax,0x8d70
  }

  if (next_thread == 0) {
  82:	a1 70 8d 00 00       	mov    0x8d70,%eax
  87:	85 c0                	test   %eax,%eax
  89:	75 17                	jne    a2 <thread_schedule+0x84>
    printf(2, "thread_schedule: no runnable threads; deadlock\n");
  8b:	83 ec 08             	sub    $0x8,%esp
  8e:	68 c4 09 00 00       	push   $0x9c4
  93:	6a 02                	push   $0x2
  95:	e8 74 05 00 00       	call   60e <printf>
  9a:	83 c4 10             	add    $0x10,%esp
    exit();
  9d:	e8 c7 03 00 00       	call   469 <exit>
  }

  if (current_thread != next_thread) {         /* switch threads?  */
  a2:	8b 15 6c 8d 00 00    	mov    0x8d6c,%edx
  a8:	a1 70 8d 00 00       	mov    0x8d70,%eax
  ad:	39 c2                	cmp    %eax,%edx
  af:	74 16                	je     c7 <thread_schedule+0xa9>
    next_thread->state = RUNNING;
  b1:	a1 70 8d 00 00       	mov    0x8d70,%eax
  b6:	c7 80 04 20 00 00 01 	movl   $0x1,0x2004(%eax)
  bd:	00 00 00 
    thread_switch();
  c0:	e8 4e 01 00 00       	call   213 <thread_switch>
  c5:	eb 0a                	jmp    d1 <thread_schedule+0xb3>
  } else
    next_thread = 0;
  c7:	c7 05 70 8d 00 00 00 	movl   $0x0,0x8d70
  ce:	00 00 00 
}
  d1:	c9                   	leave  
  d2:	c3                   	ret    

000000d3 <thread_create>:

void 
thread_create(void (*func)())
{
  d3:	55                   	push   %ebp
  d4:	89 e5                	mov    %esp,%ebp
  d6:	83 ec 10             	sub    $0x10,%esp
  thread_p t;

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  d9:	c7 45 fc 40 0d 00 00 	movl   $0xd40,-0x4(%ebp)
  e0:	eb 16                	jmp    f8 <thread_create+0x25>
    if (t->state == FREE) break;
  e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  e5:	8b 80 04 20 00 00    	mov    0x2004(%eax),%eax
  eb:	85 c0                	test   %eax,%eax
  ed:	75 02                	jne    f1 <thread_create+0x1e>
  ef:	eb 10                	jmp    101 <thread_create+0x2e>
void 
thread_create(void (*func)())
{
  thread_p t;

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  f1:	81 45 fc 08 20 00 00 	addl   $0x2008,-0x4(%ebp)
  f8:	81 7d fc 60 8d 00 00 	cmpl   $0x8d60,-0x4(%ebp)
  ff:	72 e1                	jb     e2 <thread_create+0xf>
    if (t->state == FREE) break;
  }
  t->sp = (int) (t->stack + STACK_SIZE);   // set sp to the top of the stack
 101:	8b 45 fc             	mov    -0x4(%ebp),%eax
 104:	05 04 20 00 00       	add    $0x2004,%eax
 109:	89 c2                	mov    %eax,%edx
 10b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 10e:	89 10                	mov    %edx,(%eax)
  t->sp -= 4;                              // space for return address
 110:	8b 45 fc             	mov    -0x4(%ebp),%eax
 113:	8b 00                	mov    (%eax),%eax
 115:	8d 50 fc             	lea    -0x4(%eax),%edx
 118:	8b 45 fc             	mov    -0x4(%ebp),%eax
 11b:	89 10                	mov    %edx,(%eax)
  * (int *) (t->sp) = (int)func;           // push return address on stack
 11d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 120:	8b 00                	mov    (%eax),%eax
 122:	89 c2                	mov    %eax,%edx
 124:	8b 45 08             	mov    0x8(%ebp),%eax
 127:	89 02                	mov    %eax,(%edx)
  t->sp -= 32;                             // space for registers that thread_switch will push
 129:	8b 45 fc             	mov    -0x4(%ebp),%eax
 12c:	8b 00                	mov    (%eax),%eax
 12e:	8d 50 e0             	lea    -0x20(%eax),%edx
 131:	8b 45 fc             	mov    -0x4(%ebp),%eax
 134:	89 10                	mov    %edx,(%eax)
  t->state = RUNNABLE;
 136:	8b 45 fc             	mov    -0x4(%ebp),%eax
 139:	c7 80 04 20 00 00 02 	movl   $0x2,0x2004(%eax)
 140:	00 00 00 
}
 143:	c9                   	leave  
 144:	c3                   	ret    

00000145 <thread_yield>:

void 
thread_yield(void)
{
 145:	55                   	push   %ebp
 146:	89 e5                	mov    %esp,%ebp
 148:	83 ec 08             	sub    $0x8,%esp
  current_thread->state = RUNNABLE;
 14b:	a1 6c 8d 00 00       	mov    0x8d6c,%eax
 150:	c7 80 04 20 00 00 02 	movl   $0x2,0x2004(%eax)
 157:	00 00 00 
  thread_schedule();
 15a:	e8 bf fe ff ff       	call   1e <thread_schedule>
}
 15f:	c9                   	leave  
 160:	c3                   	ret    

00000161 <mythread>:

static void 
mythread(void)
{
 161:	55                   	push   %ebp
 162:	89 e5                	mov    %esp,%ebp
 164:	83 ec 18             	sub    $0x18,%esp
  int i;
  printf(1, "my thread running\n");
 167:	83 ec 08             	sub    $0x8,%esp
 16a:	68 f4 09 00 00       	push   $0x9f4
 16f:	6a 01                	push   $0x1
 171:	e8 98 04 00 00       	call   60e <printf>
 176:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < 100; i++) {
 179:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 180:	eb 21                	jmp    1a3 <mythread+0x42>
    printf(1, "my thread 0x%x\n", (int) current_thread);
 182:	a1 6c 8d 00 00       	mov    0x8d6c,%eax
 187:	83 ec 04             	sub    $0x4,%esp
 18a:	50                   	push   %eax
 18b:	68 07 0a 00 00       	push   $0xa07
 190:	6a 01                	push   $0x1
 192:	e8 77 04 00 00       	call   60e <printf>
 197:	83 c4 10             	add    $0x10,%esp
    thread_yield();
 19a:	e8 a6 ff ff ff       	call   145 <thread_yield>
static void 
mythread(void)
{
  int i;
  printf(1, "my thread running\n");
  for (i = 0; i < 100; i++) {
 19f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1a3:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
 1a7:	7e d9                	jle    182 <mythread+0x21>
    printf(1, "my thread 0x%x\n", (int) current_thread);
    thread_yield();
  }
  printf(1, "my thread: exit\n");
 1a9:	83 ec 08             	sub    $0x8,%esp
 1ac:	68 17 0a 00 00       	push   $0xa17
 1b1:	6a 01                	push   $0x1
 1b3:	e8 56 04 00 00       	call   60e <printf>
 1b8:	83 c4 10             	add    $0x10,%esp
  current_thread->state = FREE;
 1bb:	a1 6c 8d 00 00       	mov    0x8d6c,%eax
 1c0:	c7 80 04 20 00 00 00 	movl   $0x0,0x2004(%eax)
 1c7:	00 00 00 
  thread_schedule();
 1ca:	e8 4f fe ff ff       	call   1e <thread_schedule>
}
 1cf:	c9                   	leave  
 1d0:	c3                   	ret    

000001d1 <main>:


int 
main(int argc, char *argv[]) 
{
 1d1:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 1d5:	83 e4 f0             	and    $0xfffffff0,%esp
 1d8:	ff 71 fc             	pushl  -0x4(%ecx)
 1db:	55                   	push   %ebp
 1dc:	89 e5                	mov    %esp,%ebp
 1de:	51                   	push   %ecx
 1df:	83 ec 04             	sub    $0x4,%esp
  thread_init();
 1e2:	e8 19 fe ff ff       	call   0 <thread_init>
  thread_create(mythread);
 1e7:	68 61 01 00 00       	push   $0x161
 1ec:	e8 e2 fe ff ff       	call   d3 <thread_create>
 1f1:	83 c4 04             	add    $0x4,%esp
  thread_create(mythread);
 1f4:	68 61 01 00 00       	push   $0x161
 1f9:	e8 d5 fe ff ff       	call   d3 <thread_create>
 1fe:	83 c4 04             	add    $0x4,%esp
  thread_schedule();
 201:	e8 18 fe ff ff       	call   1e <thread_schedule>
  return 0;
 206:	b8 00 00 00 00       	mov    $0x0,%eax
}
 20b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
 20e:	c9                   	leave  
 20f:	8d 61 fc             	lea    -0x4(%ecx),%esp
 212:	c3                   	ret    

00000213 <thread_switch>:
 * Use eax as a temporary register, which should be caller saved.
 */
	.globl thread_switch
thread_switch:
	/* YOUR CODE HERE */
	ret				/* pop return address from stack */
 213:	c3                   	ret    

00000214 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 214:	55                   	push   %ebp
 215:	89 e5                	mov    %esp,%ebp
 217:	57                   	push   %edi
 218:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 219:	8b 4d 08             	mov    0x8(%ebp),%ecx
 21c:	8b 55 10             	mov    0x10(%ebp),%edx
 21f:	8b 45 0c             	mov    0xc(%ebp),%eax
 222:	89 cb                	mov    %ecx,%ebx
 224:	89 df                	mov    %ebx,%edi
 226:	89 d1                	mov    %edx,%ecx
 228:	fc                   	cld    
 229:	f3 aa                	rep stos %al,%es:(%edi)
 22b:	89 ca                	mov    %ecx,%edx
 22d:	89 fb                	mov    %edi,%ebx
 22f:	89 5d 08             	mov    %ebx,0x8(%ebp)
 232:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 235:	5b                   	pop    %ebx
 236:	5f                   	pop    %edi
 237:	5d                   	pop    %ebp
 238:	c3                   	ret    

00000239 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 239:	55                   	push   %ebp
 23a:	89 e5                	mov    %esp,%ebp
 23c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 23f:	8b 45 08             	mov    0x8(%ebp),%eax
 242:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 245:	90                   	nop
 246:	8b 45 08             	mov    0x8(%ebp),%eax
 249:	8d 50 01             	lea    0x1(%eax),%edx
 24c:	89 55 08             	mov    %edx,0x8(%ebp)
 24f:	8b 55 0c             	mov    0xc(%ebp),%edx
 252:	8d 4a 01             	lea    0x1(%edx),%ecx
 255:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 258:	0f b6 12             	movzbl (%edx),%edx
 25b:	88 10                	mov    %dl,(%eax)
 25d:	0f b6 00             	movzbl (%eax),%eax
 260:	84 c0                	test   %al,%al
 262:	75 e2                	jne    246 <strcpy+0xd>
    ;
  return os;
 264:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 267:	c9                   	leave  
 268:	c3                   	ret    

00000269 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 269:	55                   	push   %ebp
 26a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 26c:	eb 08                	jmp    276 <strcmp+0xd>
    p++, q++;
 26e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 272:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 276:	8b 45 08             	mov    0x8(%ebp),%eax
 279:	0f b6 00             	movzbl (%eax),%eax
 27c:	84 c0                	test   %al,%al
 27e:	74 10                	je     290 <strcmp+0x27>
 280:	8b 45 08             	mov    0x8(%ebp),%eax
 283:	0f b6 10             	movzbl (%eax),%edx
 286:	8b 45 0c             	mov    0xc(%ebp),%eax
 289:	0f b6 00             	movzbl (%eax),%eax
 28c:	38 c2                	cmp    %al,%dl
 28e:	74 de                	je     26e <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 290:	8b 45 08             	mov    0x8(%ebp),%eax
 293:	0f b6 00             	movzbl (%eax),%eax
 296:	0f b6 d0             	movzbl %al,%edx
 299:	8b 45 0c             	mov    0xc(%ebp),%eax
 29c:	0f b6 00             	movzbl (%eax),%eax
 29f:	0f b6 c0             	movzbl %al,%eax
 2a2:	29 c2                	sub    %eax,%edx
 2a4:	89 d0                	mov    %edx,%eax
}
 2a6:	5d                   	pop    %ebp
 2a7:	c3                   	ret    

000002a8 <strlen>:

uint
strlen(char *s)
{
 2a8:	55                   	push   %ebp
 2a9:	89 e5                	mov    %esp,%ebp
 2ab:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 2ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2b5:	eb 04                	jmp    2bb <strlen+0x13>
 2b7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2bb:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2be:	8b 45 08             	mov    0x8(%ebp),%eax
 2c1:	01 d0                	add    %edx,%eax
 2c3:	0f b6 00             	movzbl (%eax),%eax
 2c6:	84 c0                	test   %al,%al
 2c8:	75 ed                	jne    2b7 <strlen+0xf>
    ;
  return n;
 2ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2cd:	c9                   	leave  
 2ce:	c3                   	ret    

000002cf <memset>:

void*
memset(void *dst, int c, uint n)
{
 2cf:	55                   	push   %ebp
 2d0:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 2d2:	8b 45 10             	mov    0x10(%ebp),%eax
 2d5:	50                   	push   %eax
 2d6:	ff 75 0c             	pushl  0xc(%ebp)
 2d9:	ff 75 08             	pushl  0x8(%ebp)
 2dc:	e8 33 ff ff ff       	call   214 <stosb>
 2e1:	83 c4 0c             	add    $0xc,%esp
  return dst;
 2e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2e7:	c9                   	leave  
 2e8:	c3                   	ret    

000002e9 <strchr>:

char*
strchr(const char *s, char c)
{
 2e9:	55                   	push   %ebp
 2ea:	89 e5                	mov    %esp,%ebp
 2ec:	83 ec 04             	sub    $0x4,%esp
 2ef:	8b 45 0c             	mov    0xc(%ebp),%eax
 2f2:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2f5:	eb 14                	jmp    30b <strchr+0x22>
    if(*s == c)
 2f7:	8b 45 08             	mov    0x8(%ebp),%eax
 2fa:	0f b6 00             	movzbl (%eax),%eax
 2fd:	3a 45 fc             	cmp    -0x4(%ebp),%al
 300:	75 05                	jne    307 <strchr+0x1e>
      return (char*)s;
 302:	8b 45 08             	mov    0x8(%ebp),%eax
 305:	eb 13                	jmp    31a <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 307:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 30b:	8b 45 08             	mov    0x8(%ebp),%eax
 30e:	0f b6 00             	movzbl (%eax),%eax
 311:	84 c0                	test   %al,%al
 313:	75 e2                	jne    2f7 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 315:	b8 00 00 00 00       	mov    $0x0,%eax
}
 31a:	c9                   	leave  
 31b:	c3                   	ret    

0000031c <gets>:

char*
gets(char *buf, int max)
{
 31c:	55                   	push   %ebp
 31d:	89 e5                	mov    %esp,%ebp
 31f:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 322:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 329:	eb 44                	jmp    36f <gets+0x53>
    cc = read(0, &c, 1);
 32b:	83 ec 04             	sub    $0x4,%esp
 32e:	6a 01                	push   $0x1
 330:	8d 45 ef             	lea    -0x11(%ebp),%eax
 333:	50                   	push   %eax
 334:	6a 00                	push   $0x0
 336:	e8 46 01 00 00       	call   481 <read>
 33b:	83 c4 10             	add    $0x10,%esp
 33e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 341:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 345:	7f 02                	jg     349 <gets+0x2d>
      break;
 347:	eb 31                	jmp    37a <gets+0x5e>
    buf[i++] = c;
 349:	8b 45 f4             	mov    -0xc(%ebp),%eax
 34c:	8d 50 01             	lea    0x1(%eax),%edx
 34f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 352:	89 c2                	mov    %eax,%edx
 354:	8b 45 08             	mov    0x8(%ebp),%eax
 357:	01 c2                	add    %eax,%edx
 359:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 35d:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 35f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 363:	3c 0a                	cmp    $0xa,%al
 365:	74 13                	je     37a <gets+0x5e>
 367:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 36b:	3c 0d                	cmp    $0xd,%al
 36d:	74 0b                	je     37a <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 36f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 372:	83 c0 01             	add    $0x1,%eax
 375:	3b 45 0c             	cmp    0xc(%ebp),%eax
 378:	7c b1                	jl     32b <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 37a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 37d:	8b 45 08             	mov    0x8(%ebp),%eax
 380:	01 d0                	add    %edx,%eax
 382:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 385:	8b 45 08             	mov    0x8(%ebp),%eax
}
 388:	c9                   	leave  
 389:	c3                   	ret    

0000038a <stat>:

int
stat(char *n, struct stat *st)
{
 38a:	55                   	push   %ebp
 38b:	89 e5                	mov    %esp,%ebp
 38d:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 390:	83 ec 08             	sub    $0x8,%esp
 393:	6a 00                	push   $0x0
 395:	ff 75 08             	pushl  0x8(%ebp)
 398:	e8 0c 01 00 00       	call   4a9 <open>
 39d:	83 c4 10             	add    $0x10,%esp
 3a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 3a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3a7:	79 07                	jns    3b0 <stat+0x26>
    return -1;
 3a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3ae:	eb 25                	jmp    3d5 <stat+0x4b>
  r = fstat(fd, st);
 3b0:	83 ec 08             	sub    $0x8,%esp
 3b3:	ff 75 0c             	pushl  0xc(%ebp)
 3b6:	ff 75 f4             	pushl  -0xc(%ebp)
 3b9:	e8 03 01 00 00       	call   4c1 <fstat>
 3be:	83 c4 10             	add    $0x10,%esp
 3c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 3c4:	83 ec 0c             	sub    $0xc,%esp
 3c7:	ff 75 f4             	pushl  -0xc(%ebp)
 3ca:	e8 c2 00 00 00       	call   491 <close>
 3cf:	83 c4 10             	add    $0x10,%esp
  return r;
 3d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3d5:	c9                   	leave  
 3d6:	c3                   	ret    

000003d7 <atoi>:

int
atoi(const char *s)
{
 3d7:	55                   	push   %ebp
 3d8:	89 e5                	mov    %esp,%ebp
 3da:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 3dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3e4:	eb 25                	jmp    40b <atoi+0x34>
    n = n*10 + *s++ - '0';
 3e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3e9:	89 d0                	mov    %edx,%eax
 3eb:	c1 e0 02             	shl    $0x2,%eax
 3ee:	01 d0                	add    %edx,%eax
 3f0:	01 c0                	add    %eax,%eax
 3f2:	89 c1                	mov    %eax,%ecx
 3f4:	8b 45 08             	mov    0x8(%ebp),%eax
 3f7:	8d 50 01             	lea    0x1(%eax),%edx
 3fa:	89 55 08             	mov    %edx,0x8(%ebp)
 3fd:	0f b6 00             	movzbl (%eax),%eax
 400:	0f be c0             	movsbl %al,%eax
 403:	01 c8                	add    %ecx,%eax
 405:	83 e8 30             	sub    $0x30,%eax
 408:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 40b:	8b 45 08             	mov    0x8(%ebp),%eax
 40e:	0f b6 00             	movzbl (%eax),%eax
 411:	3c 2f                	cmp    $0x2f,%al
 413:	7e 0a                	jle    41f <atoi+0x48>
 415:	8b 45 08             	mov    0x8(%ebp),%eax
 418:	0f b6 00             	movzbl (%eax),%eax
 41b:	3c 39                	cmp    $0x39,%al
 41d:	7e c7                	jle    3e6 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 41f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 422:	c9                   	leave  
 423:	c3                   	ret    

00000424 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 424:	55                   	push   %ebp
 425:	89 e5                	mov    %esp,%ebp
 427:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 42a:	8b 45 08             	mov    0x8(%ebp),%eax
 42d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 430:	8b 45 0c             	mov    0xc(%ebp),%eax
 433:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 436:	eb 17                	jmp    44f <memmove+0x2b>
    *dst++ = *src++;
 438:	8b 45 fc             	mov    -0x4(%ebp),%eax
 43b:	8d 50 01             	lea    0x1(%eax),%edx
 43e:	89 55 fc             	mov    %edx,-0x4(%ebp)
 441:	8b 55 f8             	mov    -0x8(%ebp),%edx
 444:	8d 4a 01             	lea    0x1(%edx),%ecx
 447:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 44a:	0f b6 12             	movzbl (%edx),%edx
 44d:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 44f:	8b 45 10             	mov    0x10(%ebp),%eax
 452:	8d 50 ff             	lea    -0x1(%eax),%edx
 455:	89 55 10             	mov    %edx,0x10(%ebp)
 458:	85 c0                	test   %eax,%eax
 45a:	7f dc                	jg     438 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 45c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 45f:	c9                   	leave  
 460:	c3                   	ret    

00000461 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 461:	b8 01 00 00 00       	mov    $0x1,%eax
 466:	cd 40                	int    $0x40
 468:	c3                   	ret    

00000469 <exit>:
SYSCALL(exit)
 469:	b8 02 00 00 00       	mov    $0x2,%eax
 46e:	cd 40                	int    $0x40
 470:	c3                   	ret    

00000471 <wait>:
SYSCALL(wait)
 471:	b8 03 00 00 00       	mov    $0x3,%eax
 476:	cd 40                	int    $0x40
 478:	c3                   	ret    

00000479 <pipe>:
SYSCALL(pipe)
 479:	b8 04 00 00 00       	mov    $0x4,%eax
 47e:	cd 40                	int    $0x40
 480:	c3                   	ret    

00000481 <read>:
SYSCALL(read)
 481:	b8 05 00 00 00       	mov    $0x5,%eax
 486:	cd 40                	int    $0x40
 488:	c3                   	ret    

00000489 <write>:
SYSCALL(write)
 489:	b8 10 00 00 00       	mov    $0x10,%eax
 48e:	cd 40                	int    $0x40
 490:	c3                   	ret    

00000491 <close>:
SYSCALL(close)
 491:	b8 15 00 00 00       	mov    $0x15,%eax
 496:	cd 40                	int    $0x40
 498:	c3                   	ret    

00000499 <kill>:
SYSCALL(kill)
 499:	b8 06 00 00 00       	mov    $0x6,%eax
 49e:	cd 40                	int    $0x40
 4a0:	c3                   	ret    

000004a1 <exec>:
SYSCALL(exec)
 4a1:	b8 07 00 00 00       	mov    $0x7,%eax
 4a6:	cd 40                	int    $0x40
 4a8:	c3                   	ret    

000004a9 <open>:
SYSCALL(open)
 4a9:	b8 0f 00 00 00       	mov    $0xf,%eax
 4ae:	cd 40                	int    $0x40
 4b0:	c3                   	ret    

000004b1 <mknod>:
SYSCALL(mknod)
 4b1:	b8 11 00 00 00       	mov    $0x11,%eax
 4b6:	cd 40                	int    $0x40
 4b8:	c3                   	ret    

000004b9 <unlink>:
SYSCALL(unlink)
 4b9:	b8 12 00 00 00       	mov    $0x12,%eax
 4be:	cd 40                	int    $0x40
 4c0:	c3                   	ret    

000004c1 <fstat>:
SYSCALL(fstat)
 4c1:	b8 08 00 00 00       	mov    $0x8,%eax
 4c6:	cd 40                	int    $0x40
 4c8:	c3                   	ret    

000004c9 <link>:
SYSCALL(link)
 4c9:	b8 13 00 00 00       	mov    $0x13,%eax
 4ce:	cd 40                	int    $0x40
 4d0:	c3                   	ret    

000004d1 <mkdir>:
SYSCALL(mkdir)
 4d1:	b8 14 00 00 00       	mov    $0x14,%eax
 4d6:	cd 40                	int    $0x40
 4d8:	c3                   	ret    

000004d9 <chdir>:
SYSCALL(chdir)
 4d9:	b8 09 00 00 00       	mov    $0x9,%eax
 4de:	cd 40                	int    $0x40
 4e0:	c3                   	ret    

000004e1 <dup>:
SYSCALL(dup)
 4e1:	b8 0a 00 00 00       	mov    $0xa,%eax
 4e6:	cd 40                	int    $0x40
 4e8:	c3                   	ret    

000004e9 <getpid>:
SYSCALL(getpid)
 4e9:	b8 0b 00 00 00       	mov    $0xb,%eax
 4ee:	cd 40                	int    $0x40
 4f0:	c3                   	ret    

000004f1 <sbrk>:
SYSCALL(sbrk)
 4f1:	b8 0c 00 00 00       	mov    $0xc,%eax
 4f6:	cd 40                	int    $0x40
 4f8:	c3                   	ret    

000004f9 <sleep>:
SYSCALL(sleep)
 4f9:	b8 0d 00 00 00       	mov    $0xd,%eax
 4fe:	cd 40                	int    $0x40
 500:	c3                   	ret    

00000501 <uptime>:
SYSCALL(uptime)
 501:	b8 0e 00 00 00       	mov    $0xe,%eax
 506:	cd 40                	int    $0x40
 508:	c3                   	ret    

00000509 <createTask>:

SYSCALL(createTask)
 509:	b8 16 00 00 00       	mov    $0x16,%eax
 50e:	cd 40                	int    $0x40
 510:	c3                   	ret    

00000511 <startTask>:
SYSCALL(startTask)
 511:	b8 17 00 00 00       	mov    $0x17,%eax
 516:	cd 40                	int    $0x40
 518:	c3                   	ret    

00000519 <waitTask>:
SYSCALL(waitTask)
 519:	b8 18 00 00 00       	mov    $0x18,%eax
 51e:	cd 40                	int    $0x40
 520:	c3                   	ret    

00000521 <Sched>:
SYSCALL(Sched)
 521:	b8 19 00 00 00       	mov    $0x19,%eax
 526:	cd 40                	int    $0x40
 528:	c3                   	ret    

00000529 <chmod>:

SYSCALL(chmod)
 529:	b8 1a 00 00 00       	mov    $0x1a,%eax
 52e:	cd 40                	int    $0x40
 530:	c3                   	ret    

00000531 <candprocs>:
SYSCALL(candprocs)
 531:	b8 1b 00 00 00       	mov    $0x1b,%eax
 536:	cd 40                	int    $0x40
 538:	c3                   	ret    

00000539 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 539:	55                   	push   %ebp
 53a:	89 e5                	mov    %esp,%ebp
 53c:	83 ec 18             	sub    $0x18,%esp
 53f:	8b 45 0c             	mov    0xc(%ebp),%eax
 542:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 545:	83 ec 04             	sub    $0x4,%esp
 548:	6a 01                	push   $0x1
 54a:	8d 45 f4             	lea    -0xc(%ebp),%eax
 54d:	50                   	push   %eax
 54e:	ff 75 08             	pushl  0x8(%ebp)
 551:	e8 33 ff ff ff       	call   489 <write>
 556:	83 c4 10             	add    $0x10,%esp
}
 559:	c9                   	leave  
 55a:	c3                   	ret    

0000055b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 55b:	55                   	push   %ebp
 55c:	89 e5                	mov    %esp,%ebp
 55e:	53                   	push   %ebx
 55f:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 562:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 569:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 56d:	74 17                	je     586 <printint+0x2b>
 56f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 573:	79 11                	jns    586 <printint+0x2b>
    neg = 1;
 575:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 57c:	8b 45 0c             	mov    0xc(%ebp),%eax
 57f:	f7 d8                	neg    %eax
 581:	89 45 ec             	mov    %eax,-0x14(%ebp)
 584:	eb 06                	jmp    58c <printint+0x31>
  } else {
    x = xx;
 586:	8b 45 0c             	mov    0xc(%ebp),%eax
 589:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 58c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 593:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 596:	8d 41 01             	lea    0x1(%ecx),%eax
 599:	89 45 f4             	mov    %eax,-0xc(%ebp)
 59c:	8b 5d 10             	mov    0x10(%ebp),%ebx
 59f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5a2:	ba 00 00 00 00       	mov    $0x0,%edx
 5a7:	f7 f3                	div    %ebx
 5a9:	89 d0                	mov    %edx,%eax
 5ab:	0f b6 80 20 0d 00 00 	movzbl 0xd20(%eax),%eax
 5b2:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 5b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5bc:	ba 00 00 00 00       	mov    $0x0,%edx
 5c1:	f7 f3                	div    %ebx
 5c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5ca:	75 c7                	jne    593 <printint+0x38>
  if(neg)
 5cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5d0:	74 0e                	je     5e0 <printint+0x85>
    buf[i++] = '-';
 5d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5d5:	8d 50 01             	lea    0x1(%eax),%edx
 5d8:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5db:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5e0:	eb 1d                	jmp    5ff <printint+0xa4>
    putc(fd, buf[i]);
 5e2:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5e8:	01 d0                	add    %edx,%eax
 5ea:	0f b6 00             	movzbl (%eax),%eax
 5ed:	0f be c0             	movsbl %al,%eax
 5f0:	83 ec 08             	sub    $0x8,%esp
 5f3:	50                   	push   %eax
 5f4:	ff 75 08             	pushl  0x8(%ebp)
 5f7:	e8 3d ff ff ff       	call   539 <putc>
 5fc:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5ff:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 603:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 607:	79 d9                	jns    5e2 <printint+0x87>
    putc(fd, buf[i]);
}
 609:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 60c:	c9                   	leave  
 60d:	c3                   	ret    

0000060e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 60e:	55                   	push   %ebp
 60f:	89 e5                	mov    %esp,%ebp
 611:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 614:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 61b:	8d 45 0c             	lea    0xc(%ebp),%eax
 61e:	83 c0 04             	add    $0x4,%eax
 621:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 624:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 62b:	e9 59 01 00 00       	jmp    789 <printf+0x17b>
    c = fmt[i] & 0xff;
 630:	8b 55 0c             	mov    0xc(%ebp),%edx
 633:	8b 45 f0             	mov    -0x10(%ebp),%eax
 636:	01 d0                	add    %edx,%eax
 638:	0f b6 00             	movzbl (%eax),%eax
 63b:	0f be c0             	movsbl %al,%eax
 63e:	25 ff 00 00 00       	and    $0xff,%eax
 643:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 646:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 64a:	75 2c                	jne    678 <printf+0x6a>
      if(c == '%'){
 64c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 650:	75 0c                	jne    65e <printf+0x50>
        state = '%';
 652:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 659:	e9 27 01 00 00       	jmp    785 <printf+0x177>
      } else {
        putc(fd, c);
 65e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 661:	0f be c0             	movsbl %al,%eax
 664:	83 ec 08             	sub    $0x8,%esp
 667:	50                   	push   %eax
 668:	ff 75 08             	pushl  0x8(%ebp)
 66b:	e8 c9 fe ff ff       	call   539 <putc>
 670:	83 c4 10             	add    $0x10,%esp
 673:	e9 0d 01 00 00       	jmp    785 <printf+0x177>
      }
    } else if(state == '%'){
 678:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 67c:	0f 85 03 01 00 00    	jne    785 <printf+0x177>
      if(c == 'd'){
 682:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 686:	75 1e                	jne    6a6 <printf+0x98>
        printint(fd, *ap, 10, 1);
 688:	8b 45 e8             	mov    -0x18(%ebp),%eax
 68b:	8b 00                	mov    (%eax),%eax
 68d:	6a 01                	push   $0x1
 68f:	6a 0a                	push   $0xa
 691:	50                   	push   %eax
 692:	ff 75 08             	pushl  0x8(%ebp)
 695:	e8 c1 fe ff ff       	call   55b <printint>
 69a:	83 c4 10             	add    $0x10,%esp
        ap++;
 69d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6a1:	e9 d8 00 00 00       	jmp    77e <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 6a6:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6aa:	74 06                	je     6b2 <printf+0xa4>
 6ac:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6b0:	75 1e                	jne    6d0 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 6b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6b5:	8b 00                	mov    (%eax),%eax
 6b7:	6a 00                	push   $0x0
 6b9:	6a 10                	push   $0x10
 6bb:	50                   	push   %eax
 6bc:	ff 75 08             	pushl  0x8(%ebp)
 6bf:	e8 97 fe ff ff       	call   55b <printint>
 6c4:	83 c4 10             	add    $0x10,%esp
        ap++;
 6c7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6cb:	e9 ae 00 00 00       	jmp    77e <printf+0x170>
      } else if(c == 's'){
 6d0:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6d4:	75 43                	jne    719 <printf+0x10b>
        s = (char*)*ap;
 6d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6d9:	8b 00                	mov    (%eax),%eax
 6db:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6de:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6e6:	75 07                	jne    6ef <printf+0xe1>
          s = "(null)";
 6e8:	c7 45 f4 28 0a 00 00 	movl   $0xa28,-0xc(%ebp)
        while(*s != 0){
 6ef:	eb 1c                	jmp    70d <printf+0xff>
          putc(fd, *s);
 6f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f4:	0f b6 00             	movzbl (%eax),%eax
 6f7:	0f be c0             	movsbl %al,%eax
 6fa:	83 ec 08             	sub    $0x8,%esp
 6fd:	50                   	push   %eax
 6fe:	ff 75 08             	pushl  0x8(%ebp)
 701:	e8 33 fe ff ff       	call   539 <putc>
 706:	83 c4 10             	add    $0x10,%esp
          s++;
 709:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 70d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 710:	0f b6 00             	movzbl (%eax),%eax
 713:	84 c0                	test   %al,%al
 715:	75 da                	jne    6f1 <printf+0xe3>
 717:	eb 65                	jmp    77e <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 719:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 71d:	75 1d                	jne    73c <printf+0x12e>
        putc(fd, *ap);
 71f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 722:	8b 00                	mov    (%eax),%eax
 724:	0f be c0             	movsbl %al,%eax
 727:	83 ec 08             	sub    $0x8,%esp
 72a:	50                   	push   %eax
 72b:	ff 75 08             	pushl  0x8(%ebp)
 72e:	e8 06 fe ff ff       	call   539 <putc>
 733:	83 c4 10             	add    $0x10,%esp
        ap++;
 736:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 73a:	eb 42                	jmp    77e <printf+0x170>
      } else if(c == '%'){
 73c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 740:	75 17                	jne    759 <printf+0x14b>
        putc(fd, c);
 742:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 745:	0f be c0             	movsbl %al,%eax
 748:	83 ec 08             	sub    $0x8,%esp
 74b:	50                   	push   %eax
 74c:	ff 75 08             	pushl  0x8(%ebp)
 74f:	e8 e5 fd ff ff       	call   539 <putc>
 754:	83 c4 10             	add    $0x10,%esp
 757:	eb 25                	jmp    77e <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 759:	83 ec 08             	sub    $0x8,%esp
 75c:	6a 25                	push   $0x25
 75e:	ff 75 08             	pushl  0x8(%ebp)
 761:	e8 d3 fd ff ff       	call   539 <putc>
 766:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 769:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 76c:	0f be c0             	movsbl %al,%eax
 76f:	83 ec 08             	sub    $0x8,%esp
 772:	50                   	push   %eax
 773:	ff 75 08             	pushl  0x8(%ebp)
 776:	e8 be fd ff ff       	call   539 <putc>
 77b:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 77e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 785:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 789:	8b 55 0c             	mov    0xc(%ebp),%edx
 78c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78f:	01 d0                	add    %edx,%eax
 791:	0f b6 00             	movzbl (%eax),%eax
 794:	84 c0                	test   %al,%al
 796:	0f 85 94 fe ff ff    	jne    630 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 79c:	c9                   	leave  
 79d:	c3                   	ret    

0000079e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 79e:	55                   	push   %ebp
 79f:	89 e5                	mov    %esp,%ebp
 7a1:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7a4:	8b 45 08             	mov    0x8(%ebp),%eax
 7a7:	83 e8 08             	sub    $0x8,%eax
 7aa:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ad:	a1 68 8d 00 00       	mov    0x8d68,%eax
 7b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7b5:	eb 24                	jmp    7db <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ba:	8b 00                	mov    (%eax),%eax
 7bc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7bf:	77 12                	ja     7d3 <free+0x35>
 7c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7c7:	77 24                	ja     7ed <free+0x4f>
 7c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cc:	8b 00                	mov    (%eax),%eax
 7ce:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7d1:	77 1a                	ja     7ed <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d6:	8b 00                	mov    (%eax),%eax
 7d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7de:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7e1:	76 d4                	jbe    7b7 <free+0x19>
 7e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e6:	8b 00                	mov    (%eax),%eax
 7e8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7eb:	76 ca                	jbe    7b7 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f0:	8b 40 04             	mov    0x4(%eax),%eax
 7f3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fd:	01 c2                	add    %eax,%edx
 7ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 802:	8b 00                	mov    (%eax),%eax
 804:	39 c2                	cmp    %eax,%edx
 806:	75 24                	jne    82c <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 808:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80b:	8b 50 04             	mov    0x4(%eax),%edx
 80e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 811:	8b 00                	mov    (%eax),%eax
 813:	8b 40 04             	mov    0x4(%eax),%eax
 816:	01 c2                	add    %eax,%edx
 818:	8b 45 f8             	mov    -0x8(%ebp),%eax
 81b:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 81e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 821:	8b 00                	mov    (%eax),%eax
 823:	8b 10                	mov    (%eax),%edx
 825:	8b 45 f8             	mov    -0x8(%ebp),%eax
 828:	89 10                	mov    %edx,(%eax)
 82a:	eb 0a                	jmp    836 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 82c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82f:	8b 10                	mov    (%eax),%edx
 831:	8b 45 f8             	mov    -0x8(%ebp),%eax
 834:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 836:	8b 45 fc             	mov    -0x4(%ebp),%eax
 839:	8b 40 04             	mov    0x4(%eax),%eax
 83c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 843:	8b 45 fc             	mov    -0x4(%ebp),%eax
 846:	01 d0                	add    %edx,%eax
 848:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 84b:	75 20                	jne    86d <free+0xcf>
    p->s.size += bp->s.size;
 84d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 850:	8b 50 04             	mov    0x4(%eax),%edx
 853:	8b 45 f8             	mov    -0x8(%ebp),%eax
 856:	8b 40 04             	mov    0x4(%eax),%eax
 859:	01 c2                	add    %eax,%edx
 85b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 861:	8b 45 f8             	mov    -0x8(%ebp),%eax
 864:	8b 10                	mov    (%eax),%edx
 866:	8b 45 fc             	mov    -0x4(%ebp),%eax
 869:	89 10                	mov    %edx,(%eax)
 86b:	eb 08                	jmp    875 <free+0xd7>
  } else
    p->s.ptr = bp;
 86d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 870:	8b 55 f8             	mov    -0x8(%ebp),%edx
 873:	89 10                	mov    %edx,(%eax)
  freep = p;
 875:	8b 45 fc             	mov    -0x4(%ebp),%eax
 878:	a3 68 8d 00 00       	mov    %eax,0x8d68
}
 87d:	c9                   	leave  
 87e:	c3                   	ret    

0000087f <morecore>:

static Header*
morecore(uint nu)
{
 87f:	55                   	push   %ebp
 880:	89 e5                	mov    %esp,%ebp
 882:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 885:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 88c:	77 07                	ja     895 <morecore+0x16>
    nu = 4096;
 88e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 895:	8b 45 08             	mov    0x8(%ebp),%eax
 898:	c1 e0 03             	shl    $0x3,%eax
 89b:	83 ec 0c             	sub    $0xc,%esp
 89e:	50                   	push   %eax
 89f:	e8 4d fc ff ff       	call   4f1 <sbrk>
 8a4:	83 c4 10             	add    $0x10,%esp
 8a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8aa:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8ae:	75 07                	jne    8b7 <morecore+0x38>
    return 0;
 8b0:	b8 00 00 00 00       	mov    $0x0,%eax
 8b5:	eb 26                	jmp    8dd <morecore+0x5e>
  hp = (Header*)p;
 8b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c0:	8b 55 08             	mov    0x8(%ebp),%edx
 8c3:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c9:	83 c0 08             	add    $0x8,%eax
 8cc:	83 ec 0c             	sub    $0xc,%esp
 8cf:	50                   	push   %eax
 8d0:	e8 c9 fe ff ff       	call   79e <free>
 8d5:	83 c4 10             	add    $0x10,%esp
  return freep;
 8d8:	a1 68 8d 00 00       	mov    0x8d68,%eax
}
 8dd:	c9                   	leave  
 8de:	c3                   	ret    

000008df <malloc>:

void*
malloc(uint nbytes)
{
 8df:	55                   	push   %ebp
 8e0:	89 e5                	mov    %esp,%ebp
 8e2:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8e5:	8b 45 08             	mov    0x8(%ebp),%eax
 8e8:	83 c0 07             	add    $0x7,%eax
 8eb:	c1 e8 03             	shr    $0x3,%eax
 8ee:	83 c0 01             	add    $0x1,%eax
 8f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8f4:	a1 68 8d 00 00       	mov    0x8d68,%eax
 8f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 900:	75 23                	jne    925 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 902:	c7 45 f0 60 8d 00 00 	movl   $0x8d60,-0x10(%ebp)
 909:	8b 45 f0             	mov    -0x10(%ebp),%eax
 90c:	a3 68 8d 00 00       	mov    %eax,0x8d68
 911:	a1 68 8d 00 00       	mov    0x8d68,%eax
 916:	a3 60 8d 00 00       	mov    %eax,0x8d60
    base.s.size = 0;
 91b:	c7 05 64 8d 00 00 00 	movl   $0x0,0x8d64
 922:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 925:	8b 45 f0             	mov    -0x10(%ebp),%eax
 928:	8b 00                	mov    (%eax),%eax
 92a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 92d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 930:	8b 40 04             	mov    0x4(%eax),%eax
 933:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 936:	72 4d                	jb     985 <malloc+0xa6>
      if(p->s.size == nunits)
 938:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93b:	8b 40 04             	mov    0x4(%eax),%eax
 93e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 941:	75 0c                	jne    94f <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 943:	8b 45 f4             	mov    -0xc(%ebp),%eax
 946:	8b 10                	mov    (%eax),%edx
 948:	8b 45 f0             	mov    -0x10(%ebp),%eax
 94b:	89 10                	mov    %edx,(%eax)
 94d:	eb 26                	jmp    975 <malloc+0x96>
      else {
        p->s.size -= nunits;
 94f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 952:	8b 40 04             	mov    0x4(%eax),%eax
 955:	2b 45 ec             	sub    -0x14(%ebp),%eax
 958:	89 c2                	mov    %eax,%edx
 95a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 960:	8b 45 f4             	mov    -0xc(%ebp),%eax
 963:	8b 40 04             	mov    0x4(%eax),%eax
 966:	c1 e0 03             	shl    $0x3,%eax
 969:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 96c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 972:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 975:	8b 45 f0             	mov    -0x10(%ebp),%eax
 978:	a3 68 8d 00 00       	mov    %eax,0x8d68
      return (void*)(p + 1);
 97d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 980:	83 c0 08             	add    $0x8,%eax
 983:	eb 3b                	jmp    9c0 <malloc+0xe1>
    }
    if(p == freep)
 985:	a1 68 8d 00 00       	mov    0x8d68,%eax
 98a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 98d:	75 1e                	jne    9ad <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 98f:	83 ec 0c             	sub    $0xc,%esp
 992:	ff 75 ec             	pushl  -0x14(%ebp)
 995:	e8 e5 fe ff ff       	call   87f <morecore>
 99a:	83 c4 10             	add    $0x10,%esp
 99d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9a4:	75 07                	jne    9ad <malloc+0xce>
        return 0;
 9a6:	b8 00 00 00 00       	mov    $0x0,%eax
 9ab:	eb 13                	jmp    9c0 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b6:	8b 00                	mov    (%eax),%eax
 9b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9bb:	e9 6d ff ff ff       	jmp    92d <malloc+0x4e>
}
 9c0:	c9                   	leave  
 9c1:	c3                   	ret    


_TaskId_1:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:
typedef unsigned int uint;
#include "fcntl.h"
#include "osHeader.h"
#include "user.h"

int main(){
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  if(open("console", O_RDWR) < 0){
  11:	83 ec 08             	sub    $0x8,%esp
  14:	6a 02                	push   $0x2
  16:	68 44 08 00 00       	push   $0x844
  1b:	e8 0b 03 00 00       	call   32b <open>
  20:	83 c4 10             	add    $0x10,%esp
  23:	85 c0                	test   %eax,%eax
  25:	79 26                	jns    4d <main+0x4d>
    mknod("console", 1, 1);
  27:	83 ec 04             	sub    $0x4,%esp
  2a:	6a 01                	push   $0x1
  2c:	6a 01                	push   $0x1
  2e:	68 44 08 00 00       	push   $0x844
  33:	e8 fb 02 00 00       	call   333 <mknod>
  38:	83 c4 10             	add    $0x10,%esp
    open("console", O_RDWR);
  3b:	83 ec 08             	sub    $0x8,%esp
  3e:	6a 02                	push   $0x2
  40:	68 44 08 00 00       	push   $0x844
  45:	e8 e1 02 00 00       	call   32b <open>
  4a:	83 c4 10             	add    $0x10,%esp
  }
  dup(0);  // stdout
  4d:	83 ec 0c             	sub    $0xc,%esp
  50:	6a 00                	push   $0x0
  52:	e8 0c 03 00 00       	call   363 <dup>
  57:	83 c4 10             	add    $0x10,%esp
  dup(0);  // stderr
  5a:	83 ec 0c             	sub    $0xc,%esp
  5d:	6a 00                	push   $0x0
  5f:	e8 ff 02 00 00       	call   363 <dup>
  64:	83 c4 10             	add    $0x10,%esp

  printf(1,"I am task 1. Actualmente hay %d procesos\n",candprocs());
  67:	e8 47 03 00 00       	call   3b3 <candprocs>
  6c:	83 ec 04             	sub    $0x4,%esp
  6f:	50                   	push   %eax
  70:	68 4c 08 00 00       	push   $0x84c
  75:	6a 01                	push   $0x1
  77:	e8 14 04 00 00       	call   490 <printf>
  7c:	83 c4 10             	add    $0x10,%esp
  //wait
  sleep(100);
  7f:	83 ec 0c             	sub    $0xc,%esp
  82:	6a 64                	push   $0x64
  84:	e8 f2 02 00 00       	call   37b <sleep>
  89:	83 c4 10             	add    $0x10,%esp
  //stop the task
  waitTask();
  8c:	e8 0a 03 00 00       	call   39b <waitTask>
  exit();
  91:	e8 55 02 00 00       	call   2eb <exit>

00000096 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  96:	55                   	push   %ebp
  97:	89 e5                	mov    %esp,%ebp
  99:	57                   	push   %edi
  9a:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  9b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  9e:	8b 55 10             	mov    0x10(%ebp),%edx
  a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  a4:	89 cb                	mov    %ecx,%ebx
  a6:	89 df                	mov    %ebx,%edi
  a8:	89 d1                	mov    %edx,%ecx
  aa:	fc                   	cld    
  ab:	f3 aa                	rep stos %al,%es:(%edi)
  ad:	89 ca                	mov    %ecx,%edx
  af:	89 fb                	mov    %edi,%ebx
  b1:	89 5d 08             	mov    %ebx,0x8(%ebp)
  b4:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  b7:	5b                   	pop    %ebx
  b8:	5f                   	pop    %edi
  b9:	5d                   	pop    %ebp
  ba:	c3                   	ret    

000000bb <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  bb:	55                   	push   %ebp
  bc:	89 e5                	mov    %esp,%ebp
  be:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  c1:	8b 45 08             	mov    0x8(%ebp),%eax
  c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  c7:	90                   	nop
  c8:	8b 45 08             	mov    0x8(%ebp),%eax
  cb:	8d 50 01             	lea    0x1(%eax),%edx
  ce:	89 55 08             	mov    %edx,0x8(%ebp)
  d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  d4:	8d 4a 01             	lea    0x1(%edx),%ecx
  d7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  da:	0f b6 12             	movzbl (%edx),%edx
  dd:	88 10                	mov    %dl,(%eax)
  df:	0f b6 00             	movzbl (%eax),%eax
  e2:	84 c0                	test   %al,%al
  e4:	75 e2                	jne    c8 <strcpy+0xd>
    ;
  return os;
  e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e9:	c9                   	leave  
  ea:	c3                   	ret    

000000eb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  eb:	55                   	push   %ebp
  ec:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  ee:	eb 08                	jmp    f8 <strcmp+0xd>
    p++, q++;
  f0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  f4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  f8:	8b 45 08             	mov    0x8(%ebp),%eax
  fb:	0f b6 00             	movzbl (%eax),%eax
  fe:	84 c0                	test   %al,%al
 100:	74 10                	je     112 <strcmp+0x27>
 102:	8b 45 08             	mov    0x8(%ebp),%eax
 105:	0f b6 10             	movzbl (%eax),%edx
 108:	8b 45 0c             	mov    0xc(%ebp),%eax
 10b:	0f b6 00             	movzbl (%eax),%eax
 10e:	38 c2                	cmp    %al,%dl
 110:	74 de                	je     f0 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 112:	8b 45 08             	mov    0x8(%ebp),%eax
 115:	0f b6 00             	movzbl (%eax),%eax
 118:	0f b6 d0             	movzbl %al,%edx
 11b:	8b 45 0c             	mov    0xc(%ebp),%eax
 11e:	0f b6 00             	movzbl (%eax),%eax
 121:	0f b6 c0             	movzbl %al,%eax
 124:	29 c2                	sub    %eax,%edx
 126:	89 d0                	mov    %edx,%eax
}
 128:	5d                   	pop    %ebp
 129:	c3                   	ret    

0000012a <strlen>:

uint
strlen(char *s)
{
 12a:	55                   	push   %ebp
 12b:	89 e5                	mov    %esp,%ebp
 12d:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 130:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 137:	eb 04                	jmp    13d <strlen+0x13>
 139:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 13d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 140:	8b 45 08             	mov    0x8(%ebp),%eax
 143:	01 d0                	add    %edx,%eax
 145:	0f b6 00             	movzbl (%eax),%eax
 148:	84 c0                	test   %al,%al
 14a:	75 ed                	jne    139 <strlen+0xf>
    ;
  return n;
 14c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 14f:	c9                   	leave  
 150:	c3                   	ret    

00000151 <memset>:

void*
memset(void *dst, int c, uint n)
{
 151:	55                   	push   %ebp
 152:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 154:	8b 45 10             	mov    0x10(%ebp),%eax
 157:	50                   	push   %eax
 158:	ff 75 0c             	pushl  0xc(%ebp)
 15b:	ff 75 08             	pushl  0x8(%ebp)
 15e:	e8 33 ff ff ff       	call   96 <stosb>
 163:	83 c4 0c             	add    $0xc,%esp
  return dst;
 166:	8b 45 08             	mov    0x8(%ebp),%eax
}
 169:	c9                   	leave  
 16a:	c3                   	ret    

0000016b <strchr>:

char*
strchr(const char *s, char c)
{
 16b:	55                   	push   %ebp
 16c:	89 e5                	mov    %esp,%ebp
 16e:	83 ec 04             	sub    $0x4,%esp
 171:	8b 45 0c             	mov    0xc(%ebp),%eax
 174:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 177:	eb 14                	jmp    18d <strchr+0x22>
    if(*s == c)
 179:	8b 45 08             	mov    0x8(%ebp),%eax
 17c:	0f b6 00             	movzbl (%eax),%eax
 17f:	3a 45 fc             	cmp    -0x4(%ebp),%al
 182:	75 05                	jne    189 <strchr+0x1e>
      return (char*)s;
 184:	8b 45 08             	mov    0x8(%ebp),%eax
 187:	eb 13                	jmp    19c <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 189:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 18d:	8b 45 08             	mov    0x8(%ebp),%eax
 190:	0f b6 00             	movzbl (%eax),%eax
 193:	84 c0                	test   %al,%al
 195:	75 e2                	jne    179 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 197:	b8 00 00 00 00       	mov    $0x0,%eax
}
 19c:	c9                   	leave  
 19d:	c3                   	ret    

0000019e <gets>:

char*
gets(char *buf, int max)
{
 19e:	55                   	push   %ebp
 19f:	89 e5                	mov    %esp,%ebp
 1a1:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1ab:	eb 44                	jmp    1f1 <gets+0x53>
    cc = read(0, &c, 1);
 1ad:	83 ec 04             	sub    $0x4,%esp
 1b0:	6a 01                	push   $0x1
 1b2:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1b5:	50                   	push   %eax
 1b6:	6a 00                	push   $0x0
 1b8:	e8 46 01 00 00       	call   303 <read>
 1bd:	83 c4 10             	add    $0x10,%esp
 1c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1c7:	7f 02                	jg     1cb <gets+0x2d>
      break;
 1c9:	eb 31                	jmp    1fc <gets+0x5e>
    buf[i++] = c;
 1cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ce:	8d 50 01             	lea    0x1(%eax),%edx
 1d1:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1d4:	89 c2                	mov    %eax,%edx
 1d6:	8b 45 08             	mov    0x8(%ebp),%eax
 1d9:	01 c2                	add    %eax,%edx
 1db:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1df:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1e1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e5:	3c 0a                	cmp    $0xa,%al
 1e7:	74 13                	je     1fc <gets+0x5e>
 1e9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ed:	3c 0d                	cmp    $0xd,%al
 1ef:	74 0b                	je     1fc <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1f4:	83 c0 01             	add    $0x1,%eax
 1f7:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1fa:	7c b1                	jl     1ad <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1ff:	8b 45 08             	mov    0x8(%ebp),%eax
 202:	01 d0                	add    %edx,%eax
 204:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 207:	8b 45 08             	mov    0x8(%ebp),%eax
}
 20a:	c9                   	leave  
 20b:	c3                   	ret    

0000020c <stat>:

int
stat(char *n, struct stat *st)
{
 20c:	55                   	push   %ebp
 20d:	89 e5                	mov    %esp,%ebp
 20f:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 212:	83 ec 08             	sub    $0x8,%esp
 215:	6a 00                	push   $0x0
 217:	ff 75 08             	pushl  0x8(%ebp)
 21a:	e8 0c 01 00 00       	call   32b <open>
 21f:	83 c4 10             	add    $0x10,%esp
 222:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 225:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 229:	79 07                	jns    232 <stat+0x26>
    return -1;
 22b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 230:	eb 25                	jmp    257 <stat+0x4b>
  r = fstat(fd, st);
 232:	83 ec 08             	sub    $0x8,%esp
 235:	ff 75 0c             	pushl  0xc(%ebp)
 238:	ff 75 f4             	pushl  -0xc(%ebp)
 23b:	e8 03 01 00 00       	call   343 <fstat>
 240:	83 c4 10             	add    $0x10,%esp
 243:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 246:	83 ec 0c             	sub    $0xc,%esp
 249:	ff 75 f4             	pushl  -0xc(%ebp)
 24c:	e8 c2 00 00 00       	call   313 <close>
 251:	83 c4 10             	add    $0x10,%esp
  return r;
 254:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 257:	c9                   	leave  
 258:	c3                   	ret    

00000259 <atoi>:

int
atoi(const char *s)
{
 259:	55                   	push   %ebp
 25a:	89 e5                	mov    %esp,%ebp
 25c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 25f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 266:	eb 25                	jmp    28d <atoi+0x34>
    n = n*10 + *s++ - '0';
 268:	8b 55 fc             	mov    -0x4(%ebp),%edx
 26b:	89 d0                	mov    %edx,%eax
 26d:	c1 e0 02             	shl    $0x2,%eax
 270:	01 d0                	add    %edx,%eax
 272:	01 c0                	add    %eax,%eax
 274:	89 c1                	mov    %eax,%ecx
 276:	8b 45 08             	mov    0x8(%ebp),%eax
 279:	8d 50 01             	lea    0x1(%eax),%edx
 27c:	89 55 08             	mov    %edx,0x8(%ebp)
 27f:	0f b6 00             	movzbl (%eax),%eax
 282:	0f be c0             	movsbl %al,%eax
 285:	01 c8                	add    %ecx,%eax
 287:	83 e8 30             	sub    $0x30,%eax
 28a:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 28d:	8b 45 08             	mov    0x8(%ebp),%eax
 290:	0f b6 00             	movzbl (%eax),%eax
 293:	3c 2f                	cmp    $0x2f,%al
 295:	7e 0a                	jle    2a1 <atoi+0x48>
 297:	8b 45 08             	mov    0x8(%ebp),%eax
 29a:	0f b6 00             	movzbl (%eax),%eax
 29d:	3c 39                	cmp    $0x39,%al
 29f:	7e c7                	jle    268 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2a4:	c9                   	leave  
 2a5:	c3                   	ret    

000002a6 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2a6:	55                   	push   %ebp
 2a7:	89 e5                	mov    %esp,%ebp
 2a9:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2ac:	8b 45 08             	mov    0x8(%ebp),%eax
 2af:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2b8:	eb 17                	jmp    2d1 <memmove+0x2b>
    *dst++ = *src++;
 2ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2bd:	8d 50 01             	lea    0x1(%eax),%edx
 2c0:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2c3:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2c6:	8d 4a 01             	lea    0x1(%edx),%ecx
 2c9:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2cc:	0f b6 12             	movzbl (%edx),%edx
 2cf:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2d1:	8b 45 10             	mov    0x10(%ebp),%eax
 2d4:	8d 50 ff             	lea    -0x1(%eax),%edx
 2d7:	89 55 10             	mov    %edx,0x10(%ebp)
 2da:	85 c0                	test   %eax,%eax
 2dc:	7f dc                	jg     2ba <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2de:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2e1:	c9                   	leave  
 2e2:	c3                   	ret    

000002e3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2e3:	b8 01 00 00 00       	mov    $0x1,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <exit>:
SYSCALL(exit)
 2eb:	b8 02 00 00 00       	mov    $0x2,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <wait>:
SYSCALL(wait)
 2f3:	b8 03 00 00 00       	mov    $0x3,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <pipe>:
SYSCALL(pipe)
 2fb:	b8 04 00 00 00       	mov    $0x4,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <read>:
SYSCALL(read)
 303:	b8 05 00 00 00       	mov    $0x5,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <write>:
SYSCALL(write)
 30b:	b8 10 00 00 00       	mov    $0x10,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <close>:
SYSCALL(close)
 313:	b8 15 00 00 00       	mov    $0x15,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <kill>:
SYSCALL(kill)
 31b:	b8 06 00 00 00       	mov    $0x6,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <exec>:
SYSCALL(exec)
 323:	b8 07 00 00 00       	mov    $0x7,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <open>:
SYSCALL(open)
 32b:	b8 0f 00 00 00       	mov    $0xf,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <mknod>:
SYSCALL(mknod)
 333:	b8 11 00 00 00       	mov    $0x11,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <unlink>:
SYSCALL(unlink)
 33b:	b8 12 00 00 00       	mov    $0x12,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <fstat>:
SYSCALL(fstat)
 343:	b8 08 00 00 00       	mov    $0x8,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <link>:
SYSCALL(link)
 34b:	b8 13 00 00 00       	mov    $0x13,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <mkdir>:
SYSCALL(mkdir)
 353:	b8 14 00 00 00       	mov    $0x14,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <chdir>:
SYSCALL(chdir)
 35b:	b8 09 00 00 00       	mov    $0x9,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <dup>:
SYSCALL(dup)
 363:	b8 0a 00 00 00       	mov    $0xa,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <getpid>:
SYSCALL(getpid)
 36b:	b8 0b 00 00 00       	mov    $0xb,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <sbrk>:
SYSCALL(sbrk)
 373:	b8 0c 00 00 00       	mov    $0xc,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <sleep>:
SYSCALL(sleep)
 37b:	b8 0d 00 00 00       	mov    $0xd,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <uptime>:
SYSCALL(uptime)
 383:	b8 0e 00 00 00       	mov    $0xe,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <createTask>:

SYSCALL(createTask)
 38b:	b8 16 00 00 00       	mov    $0x16,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <startTask>:
SYSCALL(startTask)
 393:	b8 17 00 00 00       	mov    $0x17,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <waitTask>:
SYSCALL(waitTask)
 39b:	b8 18 00 00 00       	mov    $0x18,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <Sched>:
SYSCALL(Sched)
 3a3:	b8 19 00 00 00       	mov    $0x19,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <chmod>:

SYSCALL(chmod)
 3ab:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <candprocs>:
SYSCALL(candprocs)
 3b3:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3bb:	55                   	push   %ebp
 3bc:	89 e5                	mov    %esp,%ebp
 3be:	83 ec 18             	sub    $0x18,%esp
 3c1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c4:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3c7:	83 ec 04             	sub    $0x4,%esp
 3ca:	6a 01                	push   $0x1
 3cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3cf:	50                   	push   %eax
 3d0:	ff 75 08             	pushl  0x8(%ebp)
 3d3:	e8 33 ff ff ff       	call   30b <write>
 3d8:	83 c4 10             	add    $0x10,%esp
}
 3db:	c9                   	leave  
 3dc:	c3                   	ret    

000003dd <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3dd:	55                   	push   %ebp
 3de:	89 e5                	mov    %esp,%ebp
 3e0:	53                   	push   %ebx
 3e1:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3e4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3eb:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3ef:	74 17                	je     408 <printint+0x2b>
 3f1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3f5:	79 11                	jns    408 <printint+0x2b>
    neg = 1;
 3f7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3fe:	8b 45 0c             	mov    0xc(%ebp),%eax
 401:	f7 d8                	neg    %eax
 403:	89 45 ec             	mov    %eax,-0x14(%ebp)
 406:	eb 06                	jmp    40e <printint+0x31>
  } else {
    x = xx;
 408:	8b 45 0c             	mov    0xc(%ebp),%eax
 40b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 40e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 415:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 418:	8d 41 01             	lea    0x1(%ecx),%eax
 41b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 41e:	8b 5d 10             	mov    0x10(%ebp),%ebx
 421:	8b 45 ec             	mov    -0x14(%ebp),%eax
 424:	ba 00 00 00 00       	mov    $0x0,%edx
 429:	f7 f3                	div    %ebx
 42b:	89 d0                	mov    %edx,%eax
 42d:	0f b6 80 c8 0a 00 00 	movzbl 0xac8(%eax),%eax
 434:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 438:	8b 5d 10             	mov    0x10(%ebp),%ebx
 43b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 43e:	ba 00 00 00 00       	mov    $0x0,%edx
 443:	f7 f3                	div    %ebx
 445:	89 45 ec             	mov    %eax,-0x14(%ebp)
 448:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 44c:	75 c7                	jne    415 <printint+0x38>
  if(neg)
 44e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 452:	74 0e                	je     462 <printint+0x85>
    buf[i++] = '-';
 454:	8b 45 f4             	mov    -0xc(%ebp),%eax
 457:	8d 50 01             	lea    0x1(%eax),%edx
 45a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 45d:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 462:	eb 1d                	jmp    481 <printint+0xa4>
    putc(fd, buf[i]);
 464:	8d 55 dc             	lea    -0x24(%ebp),%edx
 467:	8b 45 f4             	mov    -0xc(%ebp),%eax
 46a:	01 d0                	add    %edx,%eax
 46c:	0f b6 00             	movzbl (%eax),%eax
 46f:	0f be c0             	movsbl %al,%eax
 472:	83 ec 08             	sub    $0x8,%esp
 475:	50                   	push   %eax
 476:	ff 75 08             	pushl  0x8(%ebp)
 479:	e8 3d ff ff ff       	call   3bb <putc>
 47e:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 481:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 485:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 489:	79 d9                	jns    464 <printint+0x87>
    putc(fd, buf[i]);
}
 48b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 48e:	c9                   	leave  
 48f:	c3                   	ret    

00000490 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 490:	55                   	push   %ebp
 491:	89 e5                	mov    %esp,%ebp
 493:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 496:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 49d:	8d 45 0c             	lea    0xc(%ebp),%eax
 4a0:	83 c0 04             	add    $0x4,%eax
 4a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4a6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4ad:	e9 59 01 00 00       	jmp    60b <printf+0x17b>
    c = fmt[i] & 0xff;
 4b2:	8b 55 0c             	mov    0xc(%ebp),%edx
 4b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4b8:	01 d0                	add    %edx,%eax
 4ba:	0f b6 00             	movzbl (%eax),%eax
 4bd:	0f be c0             	movsbl %al,%eax
 4c0:	25 ff 00 00 00       	and    $0xff,%eax
 4c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4c8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4cc:	75 2c                	jne    4fa <printf+0x6a>
      if(c == '%'){
 4ce:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4d2:	75 0c                	jne    4e0 <printf+0x50>
        state = '%';
 4d4:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4db:	e9 27 01 00 00       	jmp    607 <printf+0x177>
      } else {
        putc(fd, c);
 4e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4e3:	0f be c0             	movsbl %al,%eax
 4e6:	83 ec 08             	sub    $0x8,%esp
 4e9:	50                   	push   %eax
 4ea:	ff 75 08             	pushl  0x8(%ebp)
 4ed:	e8 c9 fe ff ff       	call   3bb <putc>
 4f2:	83 c4 10             	add    $0x10,%esp
 4f5:	e9 0d 01 00 00       	jmp    607 <printf+0x177>
      }
    } else if(state == '%'){
 4fa:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4fe:	0f 85 03 01 00 00    	jne    607 <printf+0x177>
      if(c == 'd'){
 504:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 508:	75 1e                	jne    528 <printf+0x98>
        printint(fd, *ap, 10, 1);
 50a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 50d:	8b 00                	mov    (%eax),%eax
 50f:	6a 01                	push   $0x1
 511:	6a 0a                	push   $0xa
 513:	50                   	push   %eax
 514:	ff 75 08             	pushl  0x8(%ebp)
 517:	e8 c1 fe ff ff       	call   3dd <printint>
 51c:	83 c4 10             	add    $0x10,%esp
        ap++;
 51f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 523:	e9 d8 00 00 00       	jmp    600 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 528:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 52c:	74 06                	je     534 <printf+0xa4>
 52e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 532:	75 1e                	jne    552 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 534:	8b 45 e8             	mov    -0x18(%ebp),%eax
 537:	8b 00                	mov    (%eax),%eax
 539:	6a 00                	push   $0x0
 53b:	6a 10                	push   $0x10
 53d:	50                   	push   %eax
 53e:	ff 75 08             	pushl  0x8(%ebp)
 541:	e8 97 fe ff ff       	call   3dd <printint>
 546:	83 c4 10             	add    $0x10,%esp
        ap++;
 549:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 54d:	e9 ae 00 00 00       	jmp    600 <printf+0x170>
      } else if(c == 's'){
 552:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 556:	75 43                	jne    59b <printf+0x10b>
        s = (char*)*ap;
 558:	8b 45 e8             	mov    -0x18(%ebp),%eax
 55b:	8b 00                	mov    (%eax),%eax
 55d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 560:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 564:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 568:	75 07                	jne    571 <printf+0xe1>
          s = "(null)";
 56a:	c7 45 f4 76 08 00 00 	movl   $0x876,-0xc(%ebp)
        while(*s != 0){
 571:	eb 1c                	jmp    58f <printf+0xff>
          putc(fd, *s);
 573:	8b 45 f4             	mov    -0xc(%ebp),%eax
 576:	0f b6 00             	movzbl (%eax),%eax
 579:	0f be c0             	movsbl %al,%eax
 57c:	83 ec 08             	sub    $0x8,%esp
 57f:	50                   	push   %eax
 580:	ff 75 08             	pushl  0x8(%ebp)
 583:	e8 33 fe ff ff       	call   3bb <putc>
 588:	83 c4 10             	add    $0x10,%esp
          s++;
 58b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 58f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 592:	0f b6 00             	movzbl (%eax),%eax
 595:	84 c0                	test   %al,%al
 597:	75 da                	jne    573 <printf+0xe3>
 599:	eb 65                	jmp    600 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 59b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 59f:	75 1d                	jne    5be <printf+0x12e>
        putc(fd, *ap);
 5a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a4:	8b 00                	mov    (%eax),%eax
 5a6:	0f be c0             	movsbl %al,%eax
 5a9:	83 ec 08             	sub    $0x8,%esp
 5ac:	50                   	push   %eax
 5ad:	ff 75 08             	pushl  0x8(%ebp)
 5b0:	e8 06 fe ff ff       	call   3bb <putc>
 5b5:	83 c4 10             	add    $0x10,%esp
        ap++;
 5b8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5bc:	eb 42                	jmp    600 <printf+0x170>
      } else if(c == '%'){
 5be:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5c2:	75 17                	jne    5db <printf+0x14b>
        putc(fd, c);
 5c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5c7:	0f be c0             	movsbl %al,%eax
 5ca:	83 ec 08             	sub    $0x8,%esp
 5cd:	50                   	push   %eax
 5ce:	ff 75 08             	pushl  0x8(%ebp)
 5d1:	e8 e5 fd ff ff       	call   3bb <putc>
 5d6:	83 c4 10             	add    $0x10,%esp
 5d9:	eb 25                	jmp    600 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5db:	83 ec 08             	sub    $0x8,%esp
 5de:	6a 25                	push   $0x25
 5e0:	ff 75 08             	pushl  0x8(%ebp)
 5e3:	e8 d3 fd ff ff       	call   3bb <putc>
 5e8:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ee:	0f be c0             	movsbl %al,%eax
 5f1:	83 ec 08             	sub    $0x8,%esp
 5f4:	50                   	push   %eax
 5f5:	ff 75 08             	pushl  0x8(%ebp)
 5f8:	e8 be fd ff ff       	call   3bb <putc>
 5fd:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 600:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 607:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 60b:	8b 55 0c             	mov    0xc(%ebp),%edx
 60e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 611:	01 d0                	add    %edx,%eax
 613:	0f b6 00             	movzbl (%eax),%eax
 616:	84 c0                	test   %al,%al
 618:	0f 85 94 fe ff ff    	jne    4b2 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 61e:	c9                   	leave  
 61f:	c3                   	ret    

00000620 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 620:	55                   	push   %ebp
 621:	89 e5                	mov    %esp,%ebp
 623:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 626:	8b 45 08             	mov    0x8(%ebp),%eax
 629:	83 e8 08             	sub    $0x8,%eax
 62c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 62f:	a1 e4 0a 00 00       	mov    0xae4,%eax
 634:	89 45 fc             	mov    %eax,-0x4(%ebp)
 637:	eb 24                	jmp    65d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 639:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63c:	8b 00                	mov    (%eax),%eax
 63e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 641:	77 12                	ja     655 <free+0x35>
 643:	8b 45 f8             	mov    -0x8(%ebp),%eax
 646:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 649:	77 24                	ja     66f <free+0x4f>
 64b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64e:	8b 00                	mov    (%eax),%eax
 650:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 653:	77 1a                	ja     66f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 655:	8b 45 fc             	mov    -0x4(%ebp),%eax
 658:	8b 00                	mov    (%eax),%eax
 65a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 65d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 660:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 663:	76 d4                	jbe    639 <free+0x19>
 665:	8b 45 fc             	mov    -0x4(%ebp),%eax
 668:	8b 00                	mov    (%eax),%eax
 66a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 66d:	76 ca                	jbe    639 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 66f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 672:	8b 40 04             	mov    0x4(%eax),%eax
 675:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 67c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67f:	01 c2                	add    %eax,%edx
 681:	8b 45 fc             	mov    -0x4(%ebp),%eax
 684:	8b 00                	mov    (%eax),%eax
 686:	39 c2                	cmp    %eax,%edx
 688:	75 24                	jne    6ae <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 68a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68d:	8b 50 04             	mov    0x4(%eax),%edx
 690:	8b 45 fc             	mov    -0x4(%ebp),%eax
 693:	8b 00                	mov    (%eax),%eax
 695:	8b 40 04             	mov    0x4(%eax),%eax
 698:	01 c2                	add    %eax,%edx
 69a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a3:	8b 00                	mov    (%eax),%eax
 6a5:	8b 10                	mov    (%eax),%edx
 6a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6aa:	89 10                	mov    %edx,(%eax)
 6ac:	eb 0a                	jmp    6b8 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b1:	8b 10                	mov    (%eax),%edx
 6b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b6:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bb:	8b 40 04             	mov    0x4(%eax),%eax
 6be:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c8:	01 d0                	add    %edx,%eax
 6ca:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6cd:	75 20                	jne    6ef <free+0xcf>
    p->s.size += bp->s.size;
 6cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d2:	8b 50 04             	mov    0x4(%eax),%edx
 6d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d8:	8b 40 04             	mov    0x4(%eax),%eax
 6db:	01 c2                	add    %eax,%edx
 6dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e0:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e6:	8b 10                	mov    (%eax),%edx
 6e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6eb:	89 10                	mov    %edx,(%eax)
 6ed:	eb 08                	jmp    6f7 <free+0xd7>
  } else
    p->s.ptr = bp;
 6ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6f5:	89 10                	mov    %edx,(%eax)
  freep = p;
 6f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fa:	a3 e4 0a 00 00       	mov    %eax,0xae4
}
 6ff:	c9                   	leave  
 700:	c3                   	ret    

00000701 <morecore>:

static Header*
morecore(uint nu)
{
 701:	55                   	push   %ebp
 702:	89 e5                	mov    %esp,%ebp
 704:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 707:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 70e:	77 07                	ja     717 <morecore+0x16>
    nu = 4096;
 710:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 717:	8b 45 08             	mov    0x8(%ebp),%eax
 71a:	c1 e0 03             	shl    $0x3,%eax
 71d:	83 ec 0c             	sub    $0xc,%esp
 720:	50                   	push   %eax
 721:	e8 4d fc ff ff       	call   373 <sbrk>
 726:	83 c4 10             	add    $0x10,%esp
 729:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 72c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 730:	75 07                	jne    739 <morecore+0x38>
    return 0;
 732:	b8 00 00 00 00       	mov    $0x0,%eax
 737:	eb 26                	jmp    75f <morecore+0x5e>
  hp = (Header*)p;
 739:	8b 45 f4             	mov    -0xc(%ebp),%eax
 73c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 73f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 742:	8b 55 08             	mov    0x8(%ebp),%edx
 745:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 748:	8b 45 f0             	mov    -0x10(%ebp),%eax
 74b:	83 c0 08             	add    $0x8,%eax
 74e:	83 ec 0c             	sub    $0xc,%esp
 751:	50                   	push   %eax
 752:	e8 c9 fe ff ff       	call   620 <free>
 757:	83 c4 10             	add    $0x10,%esp
  return freep;
 75a:	a1 e4 0a 00 00       	mov    0xae4,%eax
}
 75f:	c9                   	leave  
 760:	c3                   	ret    

00000761 <malloc>:

void*
malloc(uint nbytes)
{
 761:	55                   	push   %ebp
 762:	89 e5                	mov    %esp,%ebp
 764:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 767:	8b 45 08             	mov    0x8(%ebp),%eax
 76a:	83 c0 07             	add    $0x7,%eax
 76d:	c1 e8 03             	shr    $0x3,%eax
 770:	83 c0 01             	add    $0x1,%eax
 773:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 776:	a1 e4 0a 00 00       	mov    0xae4,%eax
 77b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 77e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 782:	75 23                	jne    7a7 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 784:	c7 45 f0 dc 0a 00 00 	movl   $0xadc,-0x10(%ebp)
 78b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78e:	a3 e4 0a 00 00       	mov    %eax,0xae4
 793:	a1 e4 0a 00 00       	mov    0xae4,%eax
 798:	a3 dc 0a 00 00       	mov    %eax,0xadc
    base.s.size = 0;
 79d:	c7 05 e0 0a 00 00 00 	movl   $0x0,0xae0
 7a4:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7aa:	8b 00                	mov    (%eax),%eax
 7ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b2:	8b 40 04             	mov    0x4(%eax),%eax
 7b5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7b8:	72 4d                	jb     807 <malloc+0xa6>
      if(p->s.size == nunits)
 7ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bd:	8b 40 04             	mov    0x4(%eax),%eax
 7c0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7c3:	75 0c                	jne    7d1 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c8:	8b 10                	mov    (%eax),%edx
 7ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7cd:	89 10                	mov    %edx,(%eax)
 7cf:	eb 26                	jmp    7f7 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d4:	8b 40 04             	mov    0x4(%eax),%eax
 7d7:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7da:	89 c2                	mov    %eax,%edx
 7dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7df:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e5:	8b 40 04             	mov    0x4(%eax),%eax
 7e8:	c1 e0 03             	shl    $0x3,%eax
 7eb:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f1:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7f4:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7fa:	a3 e4 0a 00 00       	mov    %eax,0xae4
      return (void*)(p + 1);
 7ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 802:	83 c0 08             	add    $0x8,%eax
 805:	eb 3b                	jmp    842 <malloc+0xe1>
    }
    if(p == freep)
 807:	a1 e4 0a 00 00       	mov    0xae4,%eax
 80c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 80f:	75 1e                	jne    82f <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 811:	83 ec 0c             	sub    $0xc,%esp
 814:	ff 75 ec             	pushl  -0x14(%ebp)
 817:	e8 e5 fe ff ff       	call   701 <morecore>
 81c:	83 c4 10             	add    $0x10,%esp
 81f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 822:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 826:	75 07                	jne    82f <malloc+0xce>
        return 0;
 828:	b8 00 00 00 00       	mov    $0x0,%eax
 82d:	eb 13                	jmp    842 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 82f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 832:	89 45 f0             	mov    %eax,-0x10(%ebp)
 835:	8b 45 f4             	mov    -0xc(%ebp),%eax
 838:	8b 00                	mov    (%eax),%eax
 83a:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 83d:	e9 6d ff ff ff       	jmp    7af <malloc+0x4e>
}
 842:	c9                   	leave  
 843:	c3                   	ret    

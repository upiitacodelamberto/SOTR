
_TaskSche:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:
#include "user.h"
#include "osHeader.h"
char *argv1[] = { "TaskId_1", 0 };
char *argv2[] = { "TaskId_2", 0 };

int main(){
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  createTask(1, TaskId_1,argv1);
  11:	83 ec 04             	sub    $0x4,%esp
  14:	68 54 0a 00 00       	push   $0xa54
  19:	6a 0a                	push   $0xa
  1b:	6a 01                	push   $0x1
  1d:	e8 16 03 00 00       	call   338 <createTask>
  22:	83 c4 10             	add    $0x10,%esp
  createTask(2, TaskId_2,argv2);
  25:	83 ec 04             	sub    $0x4,%esp
  28:	68 5c 0a 00 00       	push   $0xa5c
  2d:	6a 14                	push   $0x14
  2f:	6a 02                	push   $0x2
  31:	e8 02 03 00 00       	call   338 <createTask>
  36:	83 c4 10             	add    $0x10,%esp
  Sched();
  39:	e8 12 03 00 00       	call   350 <Sched>
  exit();
  3e:	e8 55 02 00 00       	call   298 <exit>

00000043 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  43:	55                   	push   %ebp
  44:	89 e5                	mov    %esp,%ebp
  46:	57                   	push   %edi
  47:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  48:	8b 4d 08             	mov    0x8(%ebp),%ecx
  4b:	8b 55 10             	mov    0x10(%ebp),%edx
  4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  51:	89 cb                	mov    %ecx,%ebx
  53:	89 df                	mov    %ebx,%edi
  55:	89 d1                	mov    %edx,%ecx
  57:	fc                   	cld    
  58:	f3 aa                	rep stos %al,%es:(%edi)
  5a:	89 ca                	mov    %ecx,%edx
  5c:	89 fb                	mov    %edi,%ebx
  5e:	89 5d 08             	mov    %ebx,0x8(%ebp)
  61:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  64:	5b                   	pop    %ebx
  65:	5f                   	pop    %edi
  66:	5d                   	pop    %ebp
  67:	c3                   	ret    

00000068 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  68:	55                   	push   %ebp
  69:	89 e5                	mov    %esp,%ebp
  6b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  6e:	8b 45 08             	mov    0x8(%ebp),%eax
  71:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  74:	90                   	nop
  75:	8b 45 08             	mov    0x8(%ebp),%eax
  78:	8d 50 01             	lea    0x1(%eax),%edx
  7b:	89 55 08             	mov    %edx,0x8(%ebp)
  7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  81:	8d 4a 01             	lea    0x1(%edx),%ecx
  84:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  87:	0f b6 12             	movzbl (%edx),%edx
  8a:	88 10                	mov    %dl,(%eax)
  8c:	0f b6 00             	movzbl (%eax),%eax
  8f:	84 c0                	test   %al,%al
  91:	75 e2                	jne    75 <strcpy+0xd>
    ;
  return os;
  93:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  96:	c9                   	leave  
  97:	c3                   	ret    

00000098 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  98:	55                   	push   %ebp
  99:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  9b:	eb 08                	jmp    a5 <strcmp+0xd>
    p++, q++;
  9d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  a1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  a5:	8b 45 08             	mov    0x8(%ebp),%eax
  a8:	0f b6 00             	movzbl (%eax),%eax
  ab:	84 c0                	test   %al,%al
  ad:	74 10                	je     bf <strcmp+0x27>
  af:	8b 45 08             	mov    0x8(%ebp),%eax
  b2:	0f b6 10             	movzbl (%eax),%edx
  b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  b8:	0f b6 00             	movzbl (%eax),%eax
  bb:	38 c2                	cmp    %al,%dl
  bd:	74 de                	je     9d <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  bf:	8b 45 08             	mov    0x8(%ebp),%eax
  c2:	0f b6 00             	movzbl (%eax),%eax
  c5:	0f b6 d0             	movzbl %al,%edx
  c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  cb:	0f b6 00             	movzbl (%eax),%eax
  ce:	0f b6 c0             	movzbl %al,%eax
  d1:	29 c2                	sub    %eax,%edx
  d3:	89 d0                	mov    %edx,%eax
}
  d5:	5d                   	pop    %ebp
  d6:	c3                   	ret    

000000d7 <strlen>:

uint
strlen(char *s)
{
  d7:	55                   	push   %ebp
  d8:	89 e5                	mov    %esp,%ebp
  da:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  e4:	eb 04                	jmp    ea <strlen+0x13>
  e6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
  ed:	8b 45 08             	mov    0x8(%ebp),%eax
  f0:	01 d0                	add    %edx,%eax
  f2:	0f b6 00             	movzbl (%eax),%eax
  f5:	84 c0                	test   %al,%al
  f7:	75 ed                	jne    e6 <strlen+0xf>
    ;
  return n;
  f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  fc:	c9                   	leave  
  fd:	c3                   	ret    

000000fe <memset>:

void*
memset(void *dst, int c, uint n)
{
  fe:	55                   	push   %ebp
  ff:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 101:	8b 45 10             	mov    0x10(%ebp),%eax
 104:	50                   	push   %eax
 105:	ff 75 0c             	pushl  0xc(%ebp)
 108:	ff 75 08             	pushl  0x8(%ebp)
 10b:	e8 33 ff ff ff       	call   43 <stosb>
 110:	83 c4 0c             	add    $0xc,%esp
  return dst;
 113:	8b 45 08             	mov    0x8(%ebp),%eax
}
 116:	c9                   	leave  
 117:	c3                   	ret    

00000118 <strchr>:

char*
strchr(const char *s, char c)
{
 118:	55                   	push   %ebp
 119:	89 e5                	mov    %esp,%ebp
 11b:	83 ec 04             	sub    $0x4,%esp
 11e:	8b 45 0c             	mov    0xc(%ebp),%eax
 121:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 124:	eb 14                	jmp    13a <strchr+0x22>
    if(*s == c)
 126:	8b 45 08             	mov    0x8(%ebp),%eax
 129:	0f b6 00             	movzbl (%eax),%eax
 12c:	3a 45 fc             	cmp    -0x4(%ebp),%al
 12f:	75 05                	jne    136 <strchr+0x1e>
      return (char*)s;
 131:	8b 45 08             	mov    0x8(%ebp),%eax
 134:	eb 13                	jmp    149 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 136:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 13a:	8b 45 08             	mov    0x8(%ebp),%eax
 13d:	0f b6 00             	movzbl (%eax),%eax
 140:	84 c0                	test   %al,%al
 142:	75 e2                	jne    126 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 144:	b8 00 00 00 00       	mov    $0x0,%eax
}
 149:	c9                   	leave  
 14a:	c3                   	ret    

0000014b <gets>:

char*
gets(char *buf, int max)
{
 14b:	55                   	push   %ebp
 14c:	89 e5                	mov    %esp,%ebp
 14e:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 151:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 158:	eb 44                	jmp    19e <gets+0x53>
    cc = read(0, &c, 1);
 15a:	83 ec 04             	sub    $0x4,%esp
 15d:	6a 01                	push   $0x1
 15f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 162:	50                   	push   %eax
 163:	6a 00                	push   $0x0
 165:	e8 46 01 00 00       	call   2b0 <read>
 16a:	83 c4 10             	add    $0x10,%esp
 16d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 170:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 174:	7f 02                	jg     178 <gets+0x2d>
      break;
 176:	eb 31                	jmp    1a9 <gets+0x5e>
    buf[i++] = c;
 178:	8b 45 f4             	mov    -0xc(%ebp),%eax
 17b:	8d 50 01             	lea    0x1(%eax),%edx
 17e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 181:	89 c2                	mov    %eax,%edx
 183:	8b 45 08             	mov    0x8(%ebp),%eax
 186:	01 c2                	add    %eax,%edx
 188:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 18c:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 18e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 192:	3c 0a                	cmp    $0xa,%al
 194:	74 13                	je     1a9 <gets+0x5e>
 196:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 19a:	3c 0d                	cmp    $0xd,%al
 19c:	74 0b                	je     1a9 <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 19e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1a1:	83 c0 01             	add    $0x1,%eax
 1a4:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1a7:	7c b1                	jl     15a <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1ac:	8b 45 08             	mov    0x8(%ebp),%eax
 1af:	01 d0                	add    %edx,%eax
 1b1:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1b4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1b7:	c9                   	leave  
 1b8:	c3                   	ret    

000001b9 <stat>:

int
stat(char *n, struct stat *st)
{
 1b9:	55                   	push   %ebp
 1ba:	89 e5                	mov    %esp,%ebp
 1bc:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1bf:	83 ec 08             	sub    $0x8,%esp
 1c2:	6a 00                	push   $0x0
 1c4:	ff 75 08             	pushl  0x8(%ebp)
 1c7:	e8 0c 01 00 00       	call   2d8 <open>
 1cc:	83 c4 10             	add    $0x10,%esp
 1cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1d6:	79 07                	jns    1df <stat+0x26>
    return -1;
 1d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1dd:	eb 25                	jmp    204 <stat+0x4b>
  r = fstat(fd, st);
 1df:	83 ec 08             	sub    $0x8,%esp
 1e2:	ff 75 0c             	pushl  0xc(%ebp)
 1e5:	ff 75 f4             	pushl  -0xc(%ebp)
 1e8:	e8 03 01 00 00       	call   2f0 <fstat>
 1ed:	83 c4 10             	add    $0x10,%esp
 1f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1f3:	83 ec 0c             	sub    $0xc,%esp
 1f6:	ff 75 f4             	pushl  -0xc(%ebp)
 1f9:	e8 c2 00 00 00       	call   2c0 <close>
 1fe:	83 c4 10             	add    $0x10,%esp
  return r;
 201:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 204:	c9                   	leave  
 205:	c3                   	ret    

00000206 <atoi>:

int
atoi(const char *s)
{
 206:	55                   	push   %ebp
 207:	89 e5                	mov    %esp,%ebp
 209:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 20c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 213:	eb 25                	jmp    23a <atoi+0x34>
    n = n*10 + *s++ - '0';
 215:	8b 55 fc             	mov    -0x4(%ebp),%edx
 218:	89 d0                	mov    %edx,%eax
 21a:	c1 e0 02             	shl    $0x2,%eax
 21d:	01 d0                	add    %edx,%eax
 21f:	01 c0                	add    %eax,%eax
 221:	89 c1                	mov    %eax,%ecx
 223:	8b 45 08             	mov    0x8(%ebp),%eax
 226:	8d 50 01             	lea    0x1(%eax),%edx
 229:	89 55 08             	mov    %edx,0x8(%ebp)
 22c:	0f b6 00             	movzbl (%eax),%eax
 22f:	0f be c0             	movsbl %al,%eax
 232:	01 c8                	add    %ecx,%eax
 234:	83 e8 30             	sub    $0x30,%eax
 237:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 23a:	8b 45 08             	mov    0x8(%ebp),%eax
 23d:	0f b6 00             	movzbl (%eax),%eax
 240:	3c 2f                	cmp    $0x2f,%al
 242:	7e 0a                	jle    24e <atoi+0x48>
 244:	8b 45 08             	mov    0x8(%ebp),%eax
 247:	0f b6 00             	movzbl (%eax),%eax
 24a:	3c 39                	cmp    $0x39,%al
 24c:	7e c7                	jle    215 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 24e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 251:	c9                   	leave  
 252:	c3                   	ret    

00000253 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 253:	55                   	push   %ebp
 254:	89 e5                	mov    %esp,%ebp
 256:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 259:	8b 45 08             	mov    0x8(%ebp),%eax
 25c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 25f:	8b 45 0c             	mov    0xc(%ebp),%eax
 262:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 265:	eb 17                	jmp    27e <memmove+0x2b>
    *dst++ = *src++;
 267:	8b 45 fc             	mov    -0x4(%ebp),%eax
 26a:	8d 50 01             	lea    0x1(%eax),%edx
 26d:	89 55 fc             	mov    %edx,-0x4(%ebp)
 270:	8b 55 f8             	mov    -0x8(%ebp),%edx
 273:	8d 4a 01             	lea    0x1(%edx),%ecx
 276:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 279:	0f b6 12             	movzbl (%edx),%edx
 27c:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 27e:	8b 45 10             	mov    0x10(%ebp),%eax
 281:	8d 50 ff             	lea    -0x1(%eax),%edx
 284:	89 55 10             	mov    %edx,0x10(%ebp)
 287:	85 c0                	test   %eax,%eax
 289:	7f dc                	jg     267 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 28b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 28e:	c9                   	leave  
 28f:	c3                   	ret    

00000290 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 290:	b8 01 00 00 00       	mov    $0x1,%eax
 295:	cd 40                	int    $0x40
 297:	c3                   	ret    

00000298 <exit>:
SYSCALL(exit)
 298:	b8 02 00 00 00       	mov    $0x2,%eax
 29d:	cd 40                	int    $0x40
 29f:	c3                   	ret    

000002a0 <wait>:
SYSCALL(wait)
 2a0:	b8 03 00 00 00       	mov    $0x3,%eax
 2a5:	cd 40                	int    $0x40
 2a7:	c3                   	ret    

000002a8 <pipe>:
SYSCALL(pipe)
 2a8:	b8 04 00 00 00       	mov    $0x4,%eax
 2ad:	cd 40                	int    $0x40
 2af:	c3                   	ret    

000002b0 <read>:
SYSCALL(read)
 2b0:	b8 05 00 00 00       	mov    $0x5,%eax
 2b5:	cd 40                	int    $0x40
 2b7:	c3                   	ret    

000002b8 <write>:
SYSCALL(write)
 2b8:	b8 10 00 00 00       	mov    $0x10,%eax
 2bd:	cd 40                	int    $0x40
 2bf:	c3                   	ret    

000002c0 <close>:
SYSCALL(close)
 2c0:	b8 15 00 00 00       	mov    $0x15,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <kill>:
SYSCALL(kill)
 2c8:	b8 06 00 00 00       	mov    $0x6,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <exec>:
SYSCALL(exec)
 2d0:	b8 07 00 00 00       	mov    $0x7,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <open>:
SYSCALL(open)
 2d8:	b8 0f 00 00 00       	mov    $0xf,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <mknod>:
SYSCALL(mknod)
 2e0:	b8 11 00 00 00       	mov    $0x11,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <unlink>:
SYSCALL(unlink)
 2e8:	b8 12 00 00 00       	mov    $0x12,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <fstat>:
SYSCALL(fstat)
 2f0:	b8 08 00 00 00       	mov    $0x8,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <link>:
SYSCALL(link)
 2f8:	b8 13 00 00 00       	mov    $0x13,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <mkdir>:
SYSCALL(mkdir)
 300:	b8 14 00 00 00       	mov    $0x14,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <chdir>:
SYSCALL(chdir)
 308:	b8 09 00 00 00       	mov    $0x9,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <dup>:
SYSCALL(dup)
 310:	b8 0a 00 00 00       	mov    $0xa,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <getpid>:
SYSCALL(getpid)
 318:	b8 0b 00 00 00       	mov    $0xb,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <sbrk>:
SYSCALL(sbrk)
 320:	b8 0c 00 00 00       	mov    $0xc,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <sleep>:
SYSCALL(sleep)
 328:	b8 0d 00 00 00       	mov    $0xd,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <uptime>:
SYSCALL(uptime)
 330:	b8 0e 00 00 00       	mov    $0xe,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <createTask>:

SYSCALL(createTask)
 338:	b8 16 00 00 00       	mov    $0x16,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <startTask>:
SYSCALL(startTask)
 340:	b8 17 00 00 00       	mov    $0x17,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <waitTask>:
SYSCALL(waitTask)
 348:	b8 18 00 00 00       	mov    $0x18,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <Sched>:
SYSCALL(Sched)
 350:	b8 19 00 00 00       	mov    $0x19,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <chmod>:

SYSCALL(chmod)
 358:	b8 1a 00 00 00       	mov    $0x1a,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <candprocs>:
SYSCALL(candprocs)
 360:	b8 1b 00 00 00       	mov    $0x1b,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 368:	55                   	push   %ebp
 369:	89 e5                	mov    %esp,%ebp
 36b:	83 ec 18             	sub    $0x18,%esp
 36e:	8b 45 0c             	mov    0xc(%ebp),%eax
 371:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 374:	83 ec 04             	sub    $0x4,%esp
 377:	6a 01                	push   $0x1
 379:	8d 45 f4             	lea    -0xc(%ebp),%eax
 37c:	50                   	push   %eax
 37d:	ff 75 08             	pushl  0x8(%ebp)
 380:	e8 33 ff ff ff       	call   2b8 <write>
 385:	83 c4 10             	add    $0x10,%esp
}
 388:	c9                   	leave  
 389:	c3                   	ret    

0000038a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 38a:	55                   	push   %ebp
 38b:	89 e5                	mov    %esp,%ebp
 38d:	53                   	push   %ebx
 38e:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 391:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 398:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 39c:	74 17                	je     3b5 <printint+0x2b>
 39e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3a2:	79 11                	jns    3b5 <printint+0x2b>
    neg = 1;
 3a4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3ab:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ae:	f7 d8                	neg    %eax
 3b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3b3:	eb 06                	jmp    3bb <printint+0x31>
  } else {
    x = xx;
 3b5:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3c2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3c5:	8d 41 01             	lea    0x1(%ecx),%eax
 3c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3cb:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3d1:	ba 00 00 00 00       	mov    $0x0,%edx
 3d6:	f7 f3                	div    %ebx
 3d8:	89 d0                	mov    %edx,%eax
 3da:	0f b6 80 64 0a 00 00 	movzbl 0xa64(%eax),%eax
 3e1:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3e5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3eb:	ba 00 00 00 00       	mov    $0x0,%edx
 3f0:	f7 f3                	div    %ebx
 3f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3f9:	75 c7                	jne    3c2 <printint+0x38>
  if(neg)
 3fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3ff:	74 0e                	je     40f <printint+0x85>
    buf[i++] = '-';
 401:	8b 45 f4             	mov    -0xc(%ebp),%eax
 404:	8d 50 01             	lea    0x1(%eax),%edx
 407:	89 55 f4             	mov    %edx,-0xc(%ebp)
 40a:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 40f:	eb 1d                	jmp    42e <printint+0xa4>
    putc(fd, buf[i]);
 411:	8d 55 dc             	lea    -0x24(%ebp),%edx
 414:	8b 45 f4             	mov    -0xc(%ebp),%eax
 417:	01 d0                	add    %edx,%eax
 419:	0f b6 00             	movzbl (%eax),%eax
 41c:	0f be c0             	movsbl %al,%eax
 41f:	83 ec 08             	sub    $0x8,%esp
 422:	50                   	push   %eax
 423:	ff 75 08             	pushl  0x8(%ebp)
 426:	e8 3d ff ff ff       	call   368 <putc>
 42b:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 42e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 432:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 436:	79 d9                	jns    411 <printint+0x87>
    putc(fd, buf[i]);
}
 438:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 43b:	c9                   	leave  
 43c:	c3                   	ret    

0000043d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 43d:	55                   	push   %ebp
 43e:	89 e5                	mov    %esp,%ebp
 440:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 443:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 44a:	8d 45 0c             	lea    0xc(%ebp),%eax
 44d:	83 c0 04             	add    $0x4,%eax
 450:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 453:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 45a:	e9 59 01 00 00       	jmp    5b8 <printf+0x17b>
    c = fmt[i] & 0xff;
 45f:	8b 55 0c             	mov    0xc(%ebp),%edx
 462:	8b 45 f0             	mov    -0x10(%ebp),%eax
 465:	01 d0                	add    %edx,%eax
 467:	0f b6 00             	movzbl (%eax),%eax
 46a:	0f be c0             	movsbl %al,%eax
 46d:	25 ff 00 00 00       	and    $0xff,%eax
 472:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 475:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 479:	75 2c                	jne    4a7 <printf+0x6a>
      if(c == '%'){
 47b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 47f:	75 0c                	jne    48d <printf+0x50>
        state = '%';
 481:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 488:	e9 27 01 00 00       	jmp    5b4 <printf+0x177>
      } else {
        putc(fd, c);
 48d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 490:	0f be c0             	movsbl %al,%eax
 493:	83 ec 08             	sub    $0x8,%esp
 496:	50                   	push   %eax
 497:	ff 75 08             	pushl  0x8(%ebp)
 49a:	e8 c9 fe ff ff       	call   368 <putc>
 49f:	83 c4 10             	add    $0x10,%esp
 4a2:	e9 0d 01 00 00       	jmp    5b4 <printf+0x177>
      }
    } else if(state == '%'){
 4a7:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4ab:	0f 85 03 01 00 00    	jne    5b4 <printf+0x177>
      if(c == 'd'){
 4b1:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4b5:	75 1e                	jne    4d5 <printf+0x98>
        printint(fd, *ap, 10, 1);
 4b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4ba:	8b 00                	mov    (%eax),%eax
 4bc:	6a 01                	push   $0x1
 4be:	6a 0a                	push   $0xa
 4c0:	50                   	push   %eax
 4c1:	ff 75 08             	pushl  0x8(%ebp)
 4c4:	e8 c1 fe ff ff       	call   38a <printint>
 4c9:	83 c4 10             	add    $0x10,%esp
        ap++;
 4cc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4d0:	e9 d8 00 00 00       	jmp    5ad <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4d5:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4d9:	74 06                	je     4e1 <printf+0xa4>
 4db:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4df:	75 1e                	jne    4ff <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4e4:	8b 00                	mov    (%eax),%eax
 4e6:	6a 00                	push   $0x0
 4e8:	6a 10                	push   $0x10
 4ea:	50                   	push   %eax
 4eb:	ff 75 08             	pushl  0x8(%ebp)
 4ee:	e8 97 fe ff ff       	call   38a <printint>
 4f3:	83 c4 10             	add    $0x10,%esp
        ap++;
 4f6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4fa:	e9 ae 00 00 00       	jmp    5ad <printf+0x170>
      } else if(c == 's'){
 4ff:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 503:	75 43                	jne    548 <printf+0x10b>
        s = (char*)*ap;
 505:	8b 45 e8             	mov    -0x18(%ebp),%eax
 508:	8b 00                	mov    (%eax),%eax
 50a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 50d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 511:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 515:	75 07                	jne    51e <printf+0xe1>
          s = "(null)";
 517:	c7 45 f4 03 08 00 00 	movl   $0x803,-0xc(%ebp)
        while(*s != 0){
 51e:	eb 1c                	jmp    53c <printf+0xff>
          putc(fd, *s);
 520:	8b 45 f4             	mov    -0xc(%ebp),%eax
 523:	0f b6 00             	movzbl (%eax),%eax
 526:	0f be c0             	movsbl %al,%eax
 529:	83 ec 08             	sub    $0x8,%esp
 52c:	50                   	push   %eax
 52d:	ff 75 08             	pushl  0x8(%ebp)
 530:	e8 33 fe ff ff       	call   368 <putc>
 535:	83 c4 10             	add    $0x10,%esp
          s++;
 538:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 53c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 53f:	0f b6 00             	movzbl (%eax),%eax
 542:	84 c0                	test   %al,%al
 544:	75 da                	jne    520 <printf+0xe3>
 546:	eb 65                	jmp    5ad <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 548:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 54c:	75 1d                	jne    56b <printf+0x12e>
        putc(fd, *ap);
 54e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 551:	8b 00                	mov    (%eax),%eax
 553:	0f be c0             	movsbl %al,%eax
 556:	83 ec 08             	sub    $0x8,%esp
 559:	50                   	push   %eax
 55a:	ff 75 08             	pushl  0x8(%ebp)
 55d:	e8 06 fe ff ff       	call   368 <putc>
 562:	83 c4 10             	add    $0x10,%esp
        ap++;
 565:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 569:	eb 42                	jmp    5ad <printf+0x170>
      } else if(c == '%'){
 56b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 56f:	75 17                	jne    588 <printf+0x14b>
        putc(fd, c);
 571:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 574:	0f be c0             	movsbl %al,%eax
 577:	83 ec 08             	sub    $0x8,%esp
 57a:	50                   	push   %eax
 57b:	ff 75 08             	pushl  0x8(%ebp)
 57e:	e8 e5 fd ff ff       	call   368 <putc>
 583:	83 c4 10             	add    $0x10,%esp
 586:	eb 25                	jmp    5ad <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 588:	83 ec 08             	sub    $0x8,%esp
 58b:	6a 25                	push   $0x25
 58d:	ff 75 08             	pushl  0x8(%ebp)
 590:	e8 d3 fd ff ff       	call   368 <putc>
 595:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 598:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 59b:	0f be c0             	movsbl %al,%eax
 59e:	83 ec 08             	sub    $0x8,%esp
 5a1:	50                   	push   %eax
 5a2:	ff 75 08             	pushl  0x8(%ebp)
 5a5:	e8 be fd ff ff       	call   368 <putc>
 5aa:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5ad:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5b4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5b8:	8b 55 0c             	mov    0xc(%ebp),%edx
 5bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5be:	01 d0                	add    %edx,%eax
 5c0:	0f b6 00             	movzbl (%eax),%eax
 5c3:	84 c0                	test   %al,%al
 5c5:	0f 85 94 fe ff ff    	jne    45f <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5cb:	c9                   	leave  
 5cc:	c3                   	ret    

000005cd <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5cd:	55                   	push   %ebp
 5ce:	89 e5                	mov    %esp,%ebp
 5d0:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5d3:	8b 45 08             	mov    0x8(%ebp),%eax
 5d6:	83 e8 08             	sub    $0x8,%eax
 5d9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5dc:	a1 80 0a 00 00       	mov    0xa80,%eax
 5e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5e4:	eb 24                	jmp    60a <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5e9:	8b 00                	mov    (%eax),%eax
 5eb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5ee:	77 12                	ja     602 <free+0x35>
 5f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5f3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5f6:	77 24                	ja     61c <free+0x4f>
 5f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5fb:	8b 00                	mov    (%eax),%eax
 5fd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 600:	77 1a                	ja     61c <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 602:	8b 45 fc             	mov    -0x4(%ebp),%eax
 605:	8b 00                	mov    (%eax),%eax
 607:	89 45 fc             	mov    %eax,-0x4(%ebp)
 60a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 60d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 610:	76 d4                	jbe    5e6 <free+0x19>
 612:	8b 45 fc             	mov    -0x4(%ebp),%eax
 615:	8b 00                	mov    (%eax),%eax
 617:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 61a:	76 ca                	jbe    5e6 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 61c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61f:	8b 40 04             	mov    0x4(%eax),%eax
 622:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 629:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62c:	01 c2                	add    %eax,%edx
 62e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 631:	8b 00                	mov    (%eax),%eax
 633:	39 c2                	cmp    %eax,%edx
 635:	75 24                	jne    65b <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 637:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63a:	8b 50 04             	mov    0x4(%eax),%edx
 63d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 640:	8b 00                	mov    (%eax),%eax
 642:	8b 40 04             	mov    0x4(%eax),%eax
 645:	01 c2                	add    %eax,%edx
 647:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64a:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 64d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 650:	8b 00                	mov    (%eax),%eax
 652:	8b 10                	mov    (%eax),%edx
 654:	8b 45 f8             	mov    -0x8(%ebp),%eax
 657:	89 10                	mov    %edx,(%eax)
 659:	eb 0a                	jmp    665 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 65b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65e:	8b 10                	mov    (%eax),%edx
 660:	8b 45 f8             	mov    -0x8(%ebp),%eax
 663:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 665:	8b 45 fc             	mov    -0x4(%ebp),%eax
 668:	8b 40 04             	mov    0x4(%eax),%eax
 66b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 672:	8b 45 fc             	mov    -0x4(%ebp),%eax
 675:	01 d0                	add    %edx,%eax
 677:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 67a:	75 20                	jne    69c <free+0xcf>
    p->s.size += bp->s.size;
 67c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67f:	8b 50 04             	mov    0x4(%eax),%edx
 682:	8b 45 f8             	mov    -0x8(%ebp),%eax
 685:	8b 40 04             	mov    0x4(%eax),%eax
 688:	01 c2                	add    %eax,%edx
 68a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 690:	8b 45 f8             	mov    -0x8(%ebp),%eax
 693:	8b 10                	mov    (%eax),%edx
 695:	8b 45 fc             	mov    -0x4(%ebp),%eax
 698:	89 10                	mov    %edx,(%eax)
 69a:	eb 08                	jmp    6a4 <free+0xd7>
  } else
    p->s.ptr = bp;
 69c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6a2:	89 10                	mov    %edx,(%eax)
  freep = p;
 6a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a7:	a3 80 0a 00 00       	mov    %eax,0xa80
}
 6ac:	c9                   	leave  
 6ad:	c3                   	ret    

000006ae <morecore>:

static Header*
morecore(uint nu)
{
 6ae:	55                   	push   %ebp
 6af:	89 e5                	mov    %esp,%ebp
 6b1:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6b4:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6bb:	77 07                	ja     6c4 <morecore+0x16>
    nu = 4096;
 6bd:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6c4:	8b 45 08             	mov    0x8(%ebp),%eax
 6c7:	c1 e0 03             	shl    $0x3,%eax
 6ca:	83 ec 0c             	sub    $0xc,%esp
 6cd:	50                   	push   %eax
 6ce:	e8 4d fc ff ff       	call   320 <sbrk>
 6d3:	83 c4 10             	add    $0x10,%esp
 6d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6d9:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6dd:	75 07                	jne    6e6 <morecore+0x38>
    return 0;
 6df:	b8 00 00 00 00       	mov    $0x0,%eax
 6e4:	eb 26                	jmp    70c <morecore+0x5e>
  hp = (Header*)p;
 6e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ef:	8b 55 08             	mov    0x8(%ebp),%edx
 6f2:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6f8:	83 c0 08             	add    $0x8,%eax
 6fb:	83 ec 0c             	sub    $0xc,%esp
 6fe:	50                   	push   %eax
 6ff:	e8 c9 fe ff ff       	call   5cd <free>
 704:	83 c4 10             	add    $0x10,%esp
  return freep;
 707:	a1 80 0a 00 00       	mov    0xa80,%eax
}
 70c:	c9                   	leave  
 70d:	c3                   	ret    

0000070e <malloc>:

void*
malloc(uint nbytes)
{
 70e:	55                   	push   %ebp
 70f:	89 e5                	mov    %esp,%ebp
 711:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 714:	8b 45 08             	mov    0x8(%ebp),%eax
 717:	83 c0 07             	add    $0x7,%eax
 71a:	c1 e8 03             	shr    $0x3,%eax
 71d:	83 c0 01             	add    $0x1,%eax
 720:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 723:	a1 80 0a 00 00       	mov    0xa80,%eax
 728:	89 45 f0             	mov    %eax,-0x10(%ebp)
 72b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 72f:	75 23                	jne    754 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 731:	c7 45 f0 78 0a 00 00 	movl   $0xa78,-0x10(%ebp)
 738:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73b:	a3 80 0a 00 00       	mov    %eax,0xa80
 740:	a1 80 0a 00 00       	mov    0xa80,%eax
 745:	a3 78 0a 00 00       	mov    %eax,0xa78
    base.s.size = 0;
 74a:	c7 05 7c 0a 00 00 00 	movl   $0x0,0xa7c
 751:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 754:	8b 45 f0             	mov    -0x10(%ebp),%eax
 757:	8b 00                	mov    (%eax),%eax
 759:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 75c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75f:	8b 40 04             	mov    0x4(%eax),%eax
 762:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 765:	72 4d                	jb     7b4 <malloc+0xa6>
      if(p->s.size == nunits)
 767:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76a:	8b 40 04             	mov    0x4(%eax),%eax
 76d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 770:	75 0c                	jne    77e <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 772:	8b 45 f4             	mov    -0xc(%ebp),%eax
 775:	8b 10                	mov    (%eax),%edx
 777:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77a:	89 10                	mov    %edx,(%eax)
 77c:	eb 26                	jmp    7a4 <malloc+0x96>
      else {
        p->s.size -= nunits;
 77e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 781:	8b 40 04             	mov    0x4(%eax),%eax
 784:	2b 45 ec             	sub    -0x14(%ebp),%eax
 787:	89 c2                	mov    %eax,%edx
 789:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 78f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 792:	8b 40 04             	mov    0x4(%eax),%eax
 795:	c1 e0 03             	shl    $0x3,%eax
 798:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 79b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79e:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7a1:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a7:	a3 80 0a 00 00       	mov    %eax,0xa80
      return (void*)(p + 1);
 7ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7af:	83 c0 08             	add    $0x8,%eax
 7b2:	eb 3b                	jmp    7ef <malloc+0xe1>
    }
    if(p == freep)
 7b4:	a1 80 0a 00 00       	mov    0xa80,%eax
 7b9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7bc:	75 1e                	jne    7dc <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7be:	83 ec 0c             	sub    $0xc,%esp
 7c1:	ff 75 ec             	pushl  -0x14(%ebp)
 7c4:	e8 e5 fe ff ff       	call   6ae <morecore>
 7c9:	83 c4 10             	add    $0x10,%esp
 7cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7d3:	75 07                	jne    7dc <malloc+0xce>
        return 0;
 7d5:	b8 00 00 00 00       	mov    $0x0,%eax
 7da:	eb 13                	jmp    7ef <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7df:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e5:	8b 00                	mov    (%eax),%eax
 7e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7ea:	e9 6d ff ff ff       	jmp    75c <malloc+0x4e>
}
 7ef:	c9                   	leave  
 7f0:	c3                   	ret    

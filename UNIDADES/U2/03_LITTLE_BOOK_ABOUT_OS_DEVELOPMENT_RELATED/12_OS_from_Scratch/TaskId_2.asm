
_TaskId_2:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:
typedef unsigned int uint;
#include "user.h"
#include "osHeader.h"

int main(){
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  static int dummy2=0;
  printf(1,"I am task 2 dummy2=%d. Actualmente hay %d procesos\n", dummy2,candprocs());
  11:	e8 61 03 00 00       	call   377 <candprocs>
  16:	89 c2                	mov    %eax,%edx
  18:	a1 a0 0a 00 00       	mov    0xaa0,%eax
  1d:	52                   	push   %edx
  1e:	50                   	push   %eax
  1f:	68 08 08 00 00       	push   $0x808
  24:	6a 01                	push   $0x1
  26:	e8 29 04 00 00       	call   454 <printf>
  2b:	83 c4 10             	add    $0x10,%esp
  //wait
  sleep(100);//? sec
  2e:	83 ec 0c             	sub    $0xc,%esp
  31:	6a 64                	push   $0x64
  33:	e8 07 03 00 00       	call   33f <sleep>
  38:	83 c4 10             	add    $0x10,%esp
  dummy2++;
  3b:	a1 a0 0a 00 00       	mov    0xaa0,%eax
  40:	83 c0 01             	add    $0x1,%eax
  43:	a3 a0 0a 00 00       	mov    %eax,0xaa0
  //start the task
  startTask(TaskId_1);
  48:	83 ec 0c             	sub    $0xc,%esp
  4b:	6a 0a                	push   $0xa
  4d:	e8 05 03 00 00       	call   357 <startTask>
  52:	83 c4 10             	add    $0x10,%esp
  exit();
  55:	e8 55 02 00 00       	call   2af <exit>

0000005a <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  5a:	55                   	push   %ebp
  5b:	89 e5                	mov    %esp,%ebp
  5d:	57                   	push   %edi
  5e:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  62:	8b 55 10             	mov    0x10(%ebp),%edx
  65:	8b 45 0c             	mov    0xc(%ebp),%eax
  68:	89 cb                	mov    %ecx,%ebx
  6a:	89 df                	mov    %ebx,%edi
  6c:	89 d1                	mov    %edx,%ecx
  6e:	fc                   	cld    
  6f:	f3 aa                	rep stos %al,%es:(%edi)
  71:	89 ca                	mov    %ecx,%edx
  73:	89 fb                	mov    %edi,%ebx
  75:	89 5d 08             	mov    %ebx,0x8(%ebp)
  78:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  7b:	5b                   	pop    %ebx
  7c:	5f                   	pop    %edi
  7d:	5d                   	pop    %ebp
  7e:	c3                   	ret    

0000007f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  7f:	55                   	push   %ebp
  80:	89 e5                	mov    %esp,%ebp
  82:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  85:	8b 45 08             	mov    0x8(%ebp),%eax
  88:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  8b:	90                   	nop
  8c:	8b 45 08             	mov    0x8(%ebp),%eax
  8f:	8d 50 01             	lea    0x1(%eax),%edx
  92:	89 55 08             	mov    %edx,0x8(%ebp)
  95:	8b 55 0c             	mov    0xc(%ebp),%edx
  98:	8d 4a 01             	lea    0x1(%edx),%ecx
  9b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  9e:	0f b6 12             	movzbl (%edx),%edx
  a1:	88 10                	mov    %dl,(%eax)
  a3:	0f b6 00             	movzbl (%eax),%eax
  a6:	84 c0                	test   %al,%al
  a8:	75 e2                	jne    8c <strcpy+0xd>
    ;
  return os;
  aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  ad:	c9                   	leave  
  ae:	c3                   	ret    

000000af <strcmp>:

int
strcmp(const char *p, const char *q)
{
  af:	55                   	push   %ebp
  b0:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  b2:	eb 08                	jmp    bc <strcmp+0xd>
    p++, q++;
  b4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  b8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  bc:	8b 45 08             	mov    0x8(%ebp),%eax
  bf:	0f b6 00             	movzbl (%eax),%eax
  c2:	84 c0                	test   %al,%al
  c4:	74 10                	je     d6 <strcmp+0x27>
  c6:	8b 45 08             	mov    0x8(%ebp),%eax
  c9:	0f b6 10             	movzbl (%eax),%edx
  cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  cf:	0f b6 00             	movzbl (%eax),%eax
  d2:	38 c2                	cmp    %al,%dl
  d4:	74 de                	je     b4 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  d6:	8b 45 08             	mov    0x8(%ebp),%eax
  d9:	0f b6 00             	movzbl (%eax),%eax
  dc:	0f b6 d0             	movzbl %al,%edx
  df:	8b 45 0c             	mov    0xc(%ebp),%eax
  e2:	0f b6 00             	movzbl (%eax),%eax
  e5:	0f b6 c0             	movzbl %al,%eax
  e8:	29 c2                	sub    %eax,%edx
  ea:	89 d0                	mov    %edx,%eax
}
  ec:	5d                   	pop    %ebp
  ed:	c3                   	ret    

000000ee <strlen>:

uint
strlen(char *s)
{
  ee:	55                   	push   %ebp
  ef:	89 e5                	mov    %esp,%ebp
  f1:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  fb:	eb 04                	jmp    101 <strlen+0x13>
  fd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 101:	8b 55 fc             	mov    -0x4(%ebp),%edx
 104:	8b 45 08             	mov    0x8(%ebp),%eax
 107:	01 d0                	add    %edx,%eax
 109:	0f b6 00             	movzbl (%eax),%eax
 10c:	84 c0                	test   %al,%al
 10e:	75 ed                	jne    fd <strlen+0xf>
    ;
  return n;
 110:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 113:	c9                   	leave  
 114:	c3                   	ret    

00000115 <memset>:

void*
memset(void *dst, int c, uint n)
{
 115:	55                   	push   %ebp
 116:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 118:	8b 45 10             	mov    0x10(%ebp),%eax
 11b:	50                   	push   %eax
 11c:	ff 75 0c             	pushl  0xc(%ebp)
 11f:	ff 75 08             	pushl  0x8(%ebp)
 122:	e8 33 ff ff ff       	call   5a <stosb>
 127:	83 c4 0c             	add    $0xc,%esp
  return dst;
 12a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 12d:	c9                   	leave  
 12e:	c3                   	ret    

0000012f <strchr>:

char*
strchr(const char *s, char c)
{
 12f:	55                   	push   %ebp
 130:	89 e5                	mov    %esp,%ebp
 132:	83 ec 04             	sub    $0x4,%esp
 135:	8b 45 0c             	mov    0xc(%ebp),%eax
 138:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 13b:	eb 14                	jmp    151 <strchr+0x22>
    if(*s == c)
 13d:	8b 45 08             	mov    0x8(%ebp),%eax
 140:	0f b6 00             	movzbl (%eax),%eax
 143:	3a 45 fc             	cmp    -0x4(%ebp),%al
 146:	75 05                	jne    14d <strchr+0x1e>
      return (char*)s;
 148:	8b 45 08             	mov    0x8(%ebp),%eax
 14b:	eb 13                	jmp    160 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 14d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 151:	8b 45 08             	mov    0x8(%ebp),%eax
 154:	0f b6 00             	movzbl (%eax),%eax
 157:	84 c0                	test   %al,%al
 159:	75 e2                	jne    13d <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 15b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 160:	c9                   	leave  
 161:	c3                   	ret    

00000162 <gets>:

char*
gets(char *buf, int max)
{
 162:	55                   	push   %ebp
 163:	89 e5                	mov    %esp,%ebp
 165:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 168:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 16f:	eb 44                	jmp    1b5 <gets+0x53>
    cc = read(0, &c, 1);
 171:	83 ec 04             	sub    $0x4,%esp
 174:	6a 01                	push   $0x1
 176:	8d 45 ef             	lea    -0x11(%ebp),%eax
 179:	50                   	push   %eax
 17a:	6a 00                	push   $0x0
 17c:	e8 46 01 00 00       	call   2c7 <read>
 181:	83 c4 10             	add    $0x10,%esp
 184:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 187:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 18b:	7f 02                	jg     18f <gets+0x2d>
      break;
 18d:	eb 31                	jmp    1c0 <gets+0x5e>
    buf[i++] = c;
 18f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 192:	8d 50 01             	lea    0x1(%eax),%edx
 195:	89 55 f4             	mov    %edx,-0xc(%ebp)
 198:	89 c2                	mov    %eax,%edx
 19a:	8b 45 08             	mov    0x8(%ebp),%eax
 19d:	01 c2                	add    %eax,%edx
 19f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1a3:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1a5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1a9:	3c 0a                	cmp    $0xa,%al
 1ab:	74 13                	je     1c0 <gets+0x5e>
 1ad:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1b1:	3c 0d                	cmp    $0xd,%al
 1b3:	74 0b                	je     1c0 <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b8:	83 c0 01             	add    $0x1,%eax
 1bb:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1be:	7c b1                	jl     171 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1c3:	8b 45 08             	mov    0x8(%ebp),%eax
 1c6:	01 d0                	add    %edx,%eax
 1c8:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ce:	c9                   	leave  
 1cf:	c3                   	ret    

000001d0 <stat>:

int
stat(char *n, struct stat *st)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d6:	83 ec 08             	sub    $0x8,%esp
 1d9:	6a 00                	push   $0x0
 1db:	ff 75 08             	pushl  0x8(%ebp)
 1de:	e8 0c 01 00 00       	call   2ef <open>
 1e3:	83 c4 10             	add    $0x10,%esp
 1e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1ed:	79 07                	jns    1f6 <stat+0x26>
    return -1;
 1ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1f4:	eb 25                	jmp    21b <stat+0x4b>
  r = fstat(fd, st);
 1f6:	83 ec 08             	sub    $0x8,%esp
 1f9:	ff 75 0c             	pushl  0xc(%ebp)
 1fc:	ff 75 f4             	pushl  -0xc(%ebp)
 1ff:	e8 03 01 00 00       	call   307 <fstat>
 204:	83 c4 10             	add    $0x10,%esp
 207:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 20a:	83 ec 0c             	sub    $0xc,%esp
 20d:	ff 75 f4             	pushl  -0xc(%ebp)
 210:	e8 c2 00 00 00       	call   2d7 <close>
 215:	83 c4 10             	add    $0x10,%esp
  return r;
 218:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 21b:	c9                   	leave  
 21c:	c3                   	ret    

0000021d <atoi>:

int
atoi(const char *s)
{
 21d:	55                   	push   %ebp
 21e:	89 e5                	mov    %esp,%ebp
 220:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 223:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 22a:	eb 25                	jmp    251 <atoi+0x34>
    n = n*10 + *s++ - '0';
 22c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 22f:	89 d0                	mov    %edx,%eax
 231:	c1 e0 02             	shl    $0x2,%eax
 234:	01 d0                	add    %edx,%eax
 236:	01 c0                	add    %eax,%eax
 238:	89 c1                	mov    %eax,%ecx
 23a:	8b 45 08             	mov    0x8(%ebp),%eax
 23d:	8d 50 01             	lea    0x1(%eax),%edx
 240:	89 55 08             	mov    %edx,0x8(%ebp)
 243:	0f b6 00             	movzbl (%eax),%eax
 246:	0f be c0             	movsbl %al,%eax
 249:	01 c8                	add    %ecx,%eax
 24b:	83 e8 30             	sub    $0x30,%eax
 24e:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 251:	8b 45 08             	mov    0x8(%ebp),%eax
 254:	0f b6 00             	movzbl (%eax),%eax
 257:	3c 2f                	cmp    $0x2f,%al
 259:	7e 0a                	jle    265 <atoi+0x48>
 25b:	8b 45 08             	mov    0x8(%ebp),%eax
 25e:	0f b6 00             	movzbl (%eax),%eax
 261:	3c 39                	cmp    $0x39,%al
 263:	7e c7                	jle    22c <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 265:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 268:	c9                   	leave  
 269:	c3                   	ret    

0000026a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 26a:	55                   	push   %ebp
 26b:	89 e5                	mov    %esp,%ebp
 26d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 270:	8b 45 08             	mov    0x8(%ebp),%eax
 273:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 276:	8b 45 0c             	mov    0xc(%ebp),%eax
 279:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 27c:	eb 17                	jmp    295 <memmove+0x2b>
    *dst++ = *src++;
 27e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 281:	8d 50 01             	lea    0x1(%eax),%edx
 284:	89 55 fc             	mov    %edx,-0x4(%ebp)
 287:	8b 55 f8             	mov    -0x8(%ebp),%edx
 28a:	8d 4a 01             	lea    0x1(%edx),%ecx
 28d:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 290:	0f b6 12             	movzbl (%edx),%edx
 293:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 295:	8b 45 10             	mov    0x10(%ebp),%eax
 298:	8d 50 ff             	lea    -0x1(%eax),%edx
 29b:	89 55 10             	mov    %edx,0x10(%ebp)
 29e:	85 c0                	test   %eax,%eax
 2a0:	7f dc                	jg     27e <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2a2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a5:	c9                   	leave  
 2a6:	c3                   	ret    

000002a7 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2a7:	b8 01 00 00 00       	mov    $0x1,%eax
 2ac:	cd 40                	int    $0x40
 2ae:	c3                   	ret    

000002af <exit>:
SYSCALL(exit)
 2af:	b8 02 00 00 00       	mov    $0x2,%eax
 2b4:	cd 40                	int    $0x40
 2b6:	c3                   	ret    

000002b7 <wait>:
SYSCALL(wait)
 2b7:	b8 03 00 00 00       	mov    $0x3,%eax
 2bc:	cd 40                	int    $0x40
 2be:	c3                   	ret    

000002bf <pipe>:
SYSCALL(pipe)
 2bf:	b8 04 00 00 00       	mov    $0x4,%eax
 2c4:	cd 40                	int    $0x40
 2c6:	c3                   	ret    

000002c7 <read>:
SYSCALL(read)
 2c7:	b8 05 00 00 00       	mov    $0x5,%eax
 2cc:	cd 40                	int    $0x40
 2ce:	c3                   	ret    

000002cf <write>:
SYSCALL(write)
 2cf:	b8 10 00 00 00       	mov    $0x10,%eax
 2d4:	cd 40                	int    $0x40
 2d6:	c3                   	ret    

000002d7 <close>:
SYSCALL(close)
 2d7:	b8 15 00 00 00       	mov    $0x15,%eax
 2dc:	cd 40                	int    $0x40
 2de:	c3                   	ret    

000002df <kill>:
SYSCALL(kill)
 2df:	b8 06 00 00 00       	mov    $0x6,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret    

000002e7 <exec>:
SYSCALL(exec)
 2e7:	b8 07 00 00 00       	mov    $0x7,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret    

000002ef <open>:
SYSCALL(open)
 2ef:	b8 0f 00 00 00       	mov    $0xf,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret    

000002f7 <mknod>:
SYSCALL(mknod)
 2f7:	b8 11 00 00 00       	mov    $0x11,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret    

000002ff <unlink>:
SYSCALL(unlink)
 2ff:	b8 12 00 00 00       	mov    $0x12,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret    

00000307 <fstat>:
SYSCALL(fstat)
 307:	b8 08 00 00 00       	mov    $0x8,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret    

0000030f <link>:
SYSCALL(link)
 30f:	b8 13 00 00 00       	mov    $0x13,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret    

00000317 <mkdir>:
SYSCALL(mkdir)
 317:	b8 14 00 00 00       	mov    $0x14,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret    

0000031f <chdir>:
SYSCALL(chdir)
 31f:	b8 09 00 00 00       	mov    $0x9,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <dup>:
SYSCALL(dup)
 327:	b8 0a 00 00 00       	mov    $0xa,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret    

0000032f <getpid>:
SYSCALL(getpid)
 32f:	b8 0b 00 00 00       	mov    $0xb,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <sbrk>:
SYSCALL(sbrk)
 337:	b8 0c 00 00 00       	mov    $0xc,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <sleep>:
SYSCALL(sleep)
 33f:	b8 0d 00 00 00       	mov    $0xd,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <uptime>:
SYSCALL(uptime)
 347:	b8 0e 00 00 00       	mov    $0xe,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <createTask>:

SYSCALL(createTask)
 34f:	b8 16 00 00 00       	mov    $0x16,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <startTask>:
SYSCALL(startTask)
 357:	b8 17 00 00 00       	mov    $0x17,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <waitTask>:
SYSCALL(waitTask)
 35f:	b8 18 00 00 00       	mov    $0x18,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <Sched>:
SYSCALL(Sched)
 367:	b8 19 00 00 00       	mov    $0x19,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <chmod>:

SYSCALL(chmod)
 36f:	b8 1a 00 00 00       	mov    $0x1a,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    

00000377 <candprocs>:
SYSCALL(candprocs)
 377:	b8 1b 00 00 00       	mov    $0x1b,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret    

0000037f <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 37f:	55                   	push   %ebp
 380:	89 e5                	mov    %esp,%ebp
 382:	83 ec 18             	sub    $0x18,%esp
 385:	8b 45 0c             	mov    0xc(%ebp),%eax
 388:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 38b:	83 ec 04             	sub    $0x4,%esp
 38e:	6a 01                	push   $0x1
 390:	8d 45 f4             	lea    -0xc(%ebp),%eax
 393:	50                   	push   %eax
 394:	ff 75 08             	pushl  0x8(%ebp)
 397:	e8 33 ff ff ff       	call   2cf <write>
 39c:	83 c4 10             	add    $0x10,%esp
}
 39f:	c9                   	leave  
 3a0:	c3                   	ret    

000003a1 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3a1:	55                   	push   %ebp
 3a2:	89 e5                	mov    %esp,%ebp
 3a4:	53                   	push   %ebx
 3a5:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3a8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3af:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3b3:	74 17                	je     3cc <printint+0x2b>
 3b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3b9:	79 11                	jns    3cc <printint+0x2b>
    neg = 1;
 3bb:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3c2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c5:	f7 d8                	neg    %eax
 3c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3ca:	eb 06                	jmp    3d2 <printint+0x31>
  } else {
    x = xx;
 3cc:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3d9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3dc:	8d 41 01             	lea    0x1(%ecx),%eax
 3df:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3e2:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3e8:	ba 00 00 00 00       	mov    $0x0,%edx
 3ed:	f7 f3                	div    %ebx
 3ef:	89 d0                	mov    %edx,%eax
 3f1:	0f b6 80 8c 0a 00 00 	movzbl 0xa8c(%eax),%eax
 3f8:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3fc:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
 402:	ba 00 00 00 00       	mov    $0x0,%edx
 407:	f7 f3                	div    %ebx
 409:	89 45 ec             	mov    %eax,-0x14(%ebp)
 40c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 410:	75 c7                	jne    3d9 <printint+0x38>
  if(neg)
 412:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 416:	74 0e                	je     426 <printint+0x85>
    buf[i++] = '-';
 418:	8b 45 f4             	mov    -0xc(%ebp),%eax
 41b:	8d 50 01             	lea    0x1(%eax),%edx
 41e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 421:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 426:	eb 1d                	jmp    445 <printint+0xa4>
    putc(fd, buf[i]);
 428:	8d 55 dc             	lea    -0x24(%ebp),%edx
 42b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 42e:	01 d0                	add    %edx,%eax
 430:	0f b6 00             	movzbl (%eax),%eax
 433:	0f be c0             	movsbl %al,%eax
 436:	83 ec 08             	sub    $0x8,%esp
 439:	50                   	push   %eax
 43a:	ff 75 08             	pushl  0x8(%ebp)
 43d:	e8 3d ff ff ff       	call   37f <putc>
 442:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 445:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 449:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 44d:	79 d9                	jns    428 <printint+0x87>
    putc(fd, buf[i]);
}
 44f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 452:	c9                   	leave  
 453:	c3                   	ret    

00000454 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 454:	55                   	push   %ebp
 455:	89 e5                	mov    %esp,%ebp
 457:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 45a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 461:	8d 45 0c             	lea    0xc(%ebp),%eax
 464:	83 c0 04             	add    $0x4,%eax
 467:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 46a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 471:	e9 59 01 00 00       	jmp    5cf <printf+0x17b>
    c = fmt[i] & 0xff;
 476:	8b 55 0c             	mov    0xc(%ebp),%edx
 479:	8b 45 f0             	mov    -0x10(%ebp),%eax
 47c:	01 d0                	add    %edx,%eax
 47e:	0f b6 00             	movzbl (%eax),%eax
 481:	0f be c0             	movsbl %al,%eax
 484:	25 ff 00 00 00       	and    $0xff,%eax
 489:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 48c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 490:	75 2c                	jne    4be <printf+0x6a>
      if(c == '%'){
 492:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 496:	75 0c                	jne    4a4 <printf+0x50>
        state = '%';
 498:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 49f:	e9 27 01 00 00       	jmp    5cb <printf+0x177>
      } else {
        putc(fd, c);
 4a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4a7:	0f be c0             	movsbl %al,%eax
 4aa:	83 ec 08             	sub    $0x8,%esp
 4ad:	50                   	push   %eax
 4ae:	ff 75 08             	pushl  0x8(%ebp)
 4b1:	e8 c9 fe ff ff       	call   37f <putc>
 4b6:	83 c4 10             	add    $0x10,%esp
 4b9:	e9 0d 01 00 00       	jmp    5cb <printf+0x177>
      }
    } else if(state == '%'){
 4be:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4c2:	0f 85 03 01 00 00    	jne    5cb <printf+0x177>
      if(c == 'd'){
 4c8:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4cc:	75 1e                	jne    4ec <printf+0x98>
        printint(fd, *ap, 10, 1);
 4ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4d1:	8b 00                	mov    (%eax),%eax
 4d3:	6a 01                	push   $0x1
 4d5:	6a 0a                	push   $0xa
 4d7:	50                   	push   %eax
 4d8:	ff 75 08             	pushl  0x8(%ebp)
 4db:	e8 c1 fe ff ff       	call   3a1 <printint>
 4e0:	83 c4 10             	add    $0x10,%esp
        ap++;
 4e3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4e7:	e9 d8 00 00 00       	jmp    5c4 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4ec:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4f0:	74 06                	je     4f8 <printf+0xa4>
 4f2:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4f6:	75 1e                	jne    516 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4fb:	8b 00                	mov    (%eax),%eax
 4fd:	6a 00                	push   $0x0
 4ff:	6a 10                	push   $0x10
 501:	50                   	push   %eax
 502:	ff 75 08             	pushl  0x8(%ebp)
 505:	e8 97 fe ff ff       	call   3a1 <printint>
 50a:	83 c4 10             	add    $0x10,%esp
        ap++;
 50d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 511:	e9 ae 00 00 00       	jmp    5c4 <printf+0x170>
      } else if(c == 's'){
 516:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 51a:	75 43                	jne    55f <printf+0x10b>
        s = (char*)*ap;
 51c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 51f:	8b 00                	mov    (%eax),%eax
 521:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 524:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 528:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 52c:	75 07                	jne    535 <printf+0xe1>
          s = "(null)";
 52e:	c7 45 f4 3c 08 00 00 	movl   $0x83c,-0xc(%ebp)
        while(*s != 0){
 535:	eb 1c                	jmp    553 <printf+0xff>
          putc(fd, *s);
 537:	8b 45 f4             	mov    -0xc(%ebp),%eax
 53a:	0f b6 00             	movzbl (%eax),%eax
 53d:	0f be c0             	movsbl %al,%eax
 540:	83 ec 08             	sub    $0x8,%esp
 543:	50                   	push   %eax
 544:	ff 75 08             	pushl  0x8(%ebp)
 547:	e8 33 fe ff ff       	call   37f <putc>
 54c:	83 c4 10             	add    $0x10,%esp
          s++;
 54f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 553:	8b 45 f4             	mov    -0xc(%ebp),%eax
 556:	0f b6 00             	movzbl (%eax),%eax
 559:	84 c0                	test   %al,%al
 55b:	75 da                	jne    537 <printf+0xe3>
 55d:	eb 65                	jmp    5c4 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 55f:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 563:	75 1d                	jne    582 <printf+0x12e>
        putc(fd, *ap);
 565:	8b 45 e8             	mov    -0x18(%ebp),%eax
 568:	8b 00                	mov    (%eax),%eax
 56a:	0f be c0             	movsbl %al,%eax
 56d:	83 ec 08             	sub    $0x8,%esp
 570:	50                   	push   %eax
 571:	ff 75 08             	pushl  0x8(%ebp)
 574:	e8 06 fe ff ff       	call   37f <putc>
 579:	83 c4 10             	add    $0x10,%esp
        ap++;
 57c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 580:	eb 42                	jmp    5c4 <printf+0x170>
      } else if(c == '%'){
 582:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 586:	75 17                	jne    59f <printf+0x14b>
        putc(fd, c);
 588:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 58b:	0f be c0             	movsbl %al,%eax
 58e:	83 ec 08             	sub    $0x8,%esp
 591:	50                   	push   %eax
 592:	ff 75 08             	pushl  0x8(%ebp)
 595:	e8 e5 fd ff ff       	call   37f <putc>
 59a:	83 c4 10             	add    $0x10,%esp
 59d:	eb 25                	jmp    5c4 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 59f:	83 ec 08             	sub    $0x8,%esp
 5a2:	6a 25                	push   $0x25
 5a4:	ff 75 08             	pushl  0x8(%ebp)
 5a7:	e8 d3 fd ff ff       	call   37f <putc>
 5ac:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b2:	0f be c0             	movsbl %al,%eax
 5b5:	83 ec 08             	sub    $0x8,%esp
 5b8:	50                   	push   %eax
 5b9:	ff 75 08             	pushl  0x8(%ebp)
 5bc:	e8 be fd ff ff       	call   37f <putc>
 5c1:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5c4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5cb:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5cf:	8b 55 0c             	mov    0xc(%ebp),%edx
 5d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5d5:	01 d0                	add    %edx,%eax
 5d7:	0f b6 00             	movzbl (%eax),%eax
 5da:	84 c0                	test   %al,%al
 5dc:	0f 85 94 fe ff ff    	jne    476 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5e2:	c9                   	leave  
 5e3:	c3                   	ret    

000005e4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5e4:	55                   	push   %ebp
 5e5:	89 e5                	mov    %esp,%ebp
 5e7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5ea:	8b 45 08             	mov    0x8(%ebp),%eax
 5ed:	83 e8 08             	sub    $0x8,%eax
 5f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f3:	a1 ac 0a 00 00       	mov    0xaac,%eax
 5f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5fb:	eb 24                	jmp    621 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 600:	8b 00                	mov    (%eax),%eax
 602:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 605:	77 12                	ja     619 <free+0x35>
 607:	8b 45 f8             	mov    -0x8(%ebp),%eax
 60a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 60d:	77 24                	ja     633 <free+0x4f>
 60f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 612:	8b 00                	mov    (%eax),%eax
 614:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 617:	77 1a                	ja     633 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 619:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61c:	8b 00                	mov    (%eax),%eax
 61e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 621:	8b 45 f8             	mov    -0x8(%ebp),%eax
 624:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 627:	76 d4                	jbe    5fd <free+0x19>
 629:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62c:	8b 00                	mov    (%eax),%eax
 62e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 631:	76 ca                	jbe    5fd <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 633:	8b 45 f8             	mov    -0x8(%ebp),%eax
 636:	8b 40 04             	mov    0x4(%eax),%eax
 639:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 640:	8b 45 f8             	mov    -0x8(%ebp),%eax
 643:	01 c2                	add    %eax,%edx
 645:	8b 45 fc             	mov    -0x4(%ebp),%eax
 648:	8b 00                	mov    (%eax),%eax
 64a:	39 c2                	cmp    %eax,%edx
 64c:	75 24                	jne    672 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 64e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 651:	8b 50 04             	mov    0x4(%eax),%edx
 654:	8b 45 fc             	mov    -0x4(%ebp),%eax
 657:	8b 00                	mov    (%eax),%eax
 659:	8b 40 04             	mov    0x4(%eax),%eax
 65c:	01 c2                	add    %eax,%edx
 65e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 661:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 664:	8b 45 fc             	mov    -0x4(%ebp),%eax
 667:	8b 00                	mov    (%eax),%eax
 669:	8b 10                	mov    (%eax),%edx
 66b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66e:	89 10                	mov    %edx,(%eax)
 670:	eb 0a                	jmp    67c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 672:	8b 45 fc             	mov    -0x4(%ebp),%eax
 675:	8b 10                	mov    (%eax),%edx
 677:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 67c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67f:	8b 40 04             	mov    0x4(%eax),%eax
 682:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 689:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68c:	01 d0                	add    %edx,%eax
 68e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 691:	75 20                	jne    6b3 <free+0xcf>
    p->s.size += bp->s.size;
 693:	8b 45 fc             	mov    -0x4(%ebp),%eax
 696:	8b 50 04             	mov    0x4(%eax),%edx
 699:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69c:	8b 40 04             	mov    0x4(%eax),%eax
 69f:	01 c2                	add    %eax,%edx
 6a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6aa:	8b 10                	mov    (%eax),%edx
 6ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6af:	89 10                	mov    %edx,(%eax)
 6b1:	eb 08                	jmp    6bb <free+0xd7>
  } else
    p->s.ptr = bp;
 6b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6b9:	89 10                	mov    %edx,(%eax)
  freep = p;
 6bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6be:	a3 ac 0a 00 00       	mov    %eax,0xaac
}
 6c3:	c9                   	leave  
 6c4:	c3                   	ret    

000006c5 <morecore>:

static Header*
morecore(uint nu)
{
 6c5:	55                   	push   %ebp
 6c6:	89 e5                	mov    %esp,%ebp
 6c8:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6cb:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6d2:	77 07                	ja     6db <morecore+0x16>
    nu = 4096;
 6d4:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6db:	8b 45 08             	mov    0x8(%ebp),%eax
 6de:	c1 e0 03             	shl    $0x3,%eax
 6e1:	83 ec 0c             	sub    $0xc,%esp
 6e4:	50                   	push   %eax
 6e5:	e8 4d fc ff ff       	call   337 <sbrk>
 6ea:	83 c4 10             	add    $0x10,%esp
 6ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6f0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6f4:	75 07                	jne    6fd <morecore+0x38>
    return 0;
 6f6:	b8 00 00 00 00       	mov    $0x0,%eax
 6fb:	eb 26                	jmp    723 <morecore+0x5e>
  hp = (Header*)p;
 6fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 700:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 703:	8b 45 f0             	mov    -0x10(%ebp),%eax
 706:	8b 55 08             	mov    0x8(%ebp),%edx
 709:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 70c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 70f:	83 c0 08             	add    $0x8,%eax
 712:	83 ec 0c             	sub    $0xc,%esp
 715:	50                   	push   %eax
 716:	e8 c9 fe ff ff       	call   5e4 <free>
 71b:	83 c4 10             	add    $0x10,%esp
  return freep;
 71e:	a1 ac 0a 00 00       	mov    0xaac,%eax
}
 723:	c9                   	leave  
 724:	c3                   	ret    

00000725 <malloc>:

void*
malloc(uint nbytes)
{
 725:	55                   	push   %ebp
 726:	89 e5                	mov    %esp,%ebp
 728:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 72b:	8b 45 08             	mov    0x8(%ebp),%eax
 72e:	83 c0 07             	add    $0x7,%eax
 731:	c1 e8 03             	shr    $0x3,%eax
 734:	83 c0 01             	add    $0x1,%eax
 737:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 73a:	a1 ac 0a 00 00       	mov    0xaac,%eax
 73f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 742:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 746:	75 23                	jne    76b <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 748:	c7 45 f0 a4 0a 00 00 	movl   $0xaa4,-0x10(%ebp)
 74f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 752:	a3 ac 0a 00 00       	mov    %eax,0xaac
 757:	a1 ac 0a 00 00       	mov    0xaac,%eax
 75c:	a3 a4 0a 00 00       	mov    %eax,0xaa4
    base.s.size = 0;
 761:	c7 05 a8 0a 00 00 00 	movl   $0x0,0xaa8
 768:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 76b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 76e:	8b 00                	mov    (%eax),%eax
 770:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 773:	8b 45 f4             	mov    -0xc(%ebp),%eax
 776:	8b 40 04             	mov    0x4(%eax),%eax
 779:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 77c:	72 4d                	jb     7cb <malloc+0xa6>
      if(p->s.size == nunits)
 77e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 781:	8b 40 04             	mov    0x4(%eax),%eax
 784:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 787:	75 0c                	jne    795 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 789:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78c:	8b 10                	mov    (%eax),%edx
 78e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 791:	89 10                	mov    %edx,(%eax)
 793:	eb 26                	jmp    7bb <malloc+0x96>
      else {
        p->s.size -= nunits;
 795:	8b 45 f4             	mov    -0xc(%ebp),%eax
 798:	8b 40 04             	mov    0x4(%eax),%eax
 79b:	2b 45 ec             	sub    -0x14(%ebp),%eax
 79e:	89 c2                	mov    %eax,%edx
 7a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a3:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a9:	8b 40 04             	mov    0x4(%eax),%eax
 7ac:	c1 e0 03             	shl    $0x3,%eax
 7af:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b5:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7b8:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7be:	a3 ac 0a 00 00       	mov    %eax,0xaac
      return (void*)(p + 1);
 7c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c6:	83 c0 08             	add    $0x8,%eax
 7c9:	eb 3b                	jmp    806 <malloc+0xe1>
    }
    if(p == freep)
 7cb:	a1 ac 0a 00 00       	mov    0xaac,%eax
 7d0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7d3:	75 1e                	jne    7f3 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7d5:	83 ec 0c             	sub    $0xc,%esp
 7d8:	ff 75 ec             	pushl  -0x14(%ebp)
 7db:	e8 e5 fe ff ff       	call   6c5 <morecore>
 7e0:	83 c4 10             	add    $0x10,%esp
 7e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7ea:	75 07                	jne    7f3 <malloc+0xce>
        return 0;
 7ec:	b8 00 00 00 00       	mov    $0x0,%eax
 7f1:	eb 13                	jmp    806 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fc:	8b 00                	mov    (%eax),%eax
 7fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 801:	e9 6d ff ff ff       	jmp    773 <malloc+0x4e>
}
 806:	c9                   	leave  
 807:	c3                   	ret    

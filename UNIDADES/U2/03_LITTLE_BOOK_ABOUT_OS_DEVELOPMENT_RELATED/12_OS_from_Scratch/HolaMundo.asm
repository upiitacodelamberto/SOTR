
_HolaMundo:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:
#include "user.h"




int main(){
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  printf(1, "Hola Mundo XV6!!\n");
  11:	83 ec 08             	sub    $0x8,%esp
  14:	68 d6 07 00 00       	push   $0x7d6
  19:	6a 01                	push   $0x1
  1b:	e8 02 04 00 00       	call   422 <printf>
  20:	83 c4 10             	add    $0x10,%esp
  exit();
  23:	e8 55 02 00 00       	call   27d <exit>

00000028 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  28:	55                   	push   %ebp
  29:	89 e5                	mov    %esp,%ebp
  2b:	57                   	push   %edi
  2c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  2d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  30:	8b 55 10             	mov    0x10(%ebp),%edx
  33:	8b 45 0c             	mov    0xc(%ebp),%eax
  36:	89 cb                	mov    %ecx,%ebx
  38:	89 df                	mov    %ebx,%edi
  3a:	89 d1                	mov    %edx,%ecx
  3c:	fc                   	cld    
  3d:	f3 aa                	rep stos %al,%es:(%edi)
  3f:	89 ca                	mov    %ecx,%edx
  41:	89 fb                	mov    %edi,%ebx
  43:	89 5d 08             	mov    %ebx,0x8(%ebp)
  46:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  49:	5b                   	pop    %ebx
  4a:	5f                   	pop    %edi
  4b:	5d                   	pop    %ebp
  4c:	c3                   	ret    

0000004d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  4d:	55                   	push   %ebp
  4e:	89 e5                	mov    %esp,%ebp
  50:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  53:	8b 45 08             	mov    0x8(%ebp),%eax
  56:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  59:	90                   	nop
  5a:	8b 45 08             	mov    0x8(%ebp),%eax
  5d:	8d 50 01             	lea    0x1(%eax),%edx
  60:	89 55 08             	mov    %edx,0x8(%ebp)
  63:	8b 55 0c             	mov    0xc(%ebp),%edx
  66:	8d 4a 01             	lea    0x1(%edx),%ecx
  69:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  6c:	0f b6 12             	movzbl (%edx),%edx
  6f:	88 10                	mov    %dl,(%eax)
  71:	0f b6 00             	movzbl (%eax),%eax
  74:	84 c0                	test   %al,%al
  76:	75 e2                	jne    5a <strcpy+0xd>
    ;
  return os;
  78:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  7b:	c9                   	leave  
  7c:	c3                   	ret    

0000007d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7d:	55                   	push   %ebp
  7e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  80:	eb 08                	jmp    8a <strcmp+0xd>
    p++, q++;
  82:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  86:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  8a:	8b 45 08             	mov    0x8(%ebp),%eax
  8d:	0f b6 00             	movzbl (%eax),%eax
  90:	84 c0                	test   %al,%al
  92:	74 10                	je     a4 <strcmp+0x27>
  94:	8b 45 08             	mov    0x8(%ebp),%eax
  97:	0f b6 10             	movzbl (%eax),%edx
  9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  9d:	0f b6 00             	movzbl (%eax),%eax
  a0:	38 c2                	cmp    %al,%dl
  a2:	74 de                	je     82 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  a4:	8b 45 08             	mov    0x8(%ebp),%eax
  a7:	0f b6 00             	movzbl (%eax),%eax
  aa:	0f b6 d0             	movzbl %al,%edx
  ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  b0:	0f b6 00             	movzbl (%eax),%eax
  b3:	0f b6 c0             	movzbl %al,%eax
  b6:	29 c2                	sub    %eax,%edx
  b8:	89 d0                	mov    %edx,%eax
}
  ba:	5d                   	pop    %ebp
  bb:	c3                   	ret    

000000bc <strlen>:

uint
strlen(char *s)
{
  bc:	55                   	push   %ebp
  bd:	89 e5                	mov    %esp,%ebp
  bf:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  c9:	eb 04                	jmp    cf <strlen+0x13>
  cb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  cf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  d2:	8b 45 08             	mov    0x8(%ebp),%eax
  d5:	01 d0                	add    %edx,%eax
  d7:	0f b6 00             	movzbl (%eax),%eax
  da:	84 c0                	test   %al,%al
  dc:	75 ed                	jne    cb <strlen+0xf>
    ;
  return n;
  de:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e1:	c9                   	leave  
  e2:	c3                   	ret    

000000e3 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e3:	55                   	push   %ebp
  e4:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  e6:	8b 45 10             	mov    0x10(%ebp),%eax
  e9:	50                   	push   %eax
  ea:	ff 75 0c             	pushl  0xc(%ebp)
  ed:	ff 75 08             	pushl  0x8(%ebp)
  f0:	e8 33 ff ff ff       	call   28 <stosb>
  f5:	83 c4 0c             	add    $0xc,%esp
  return dst;
  f8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  fb:	c9                   	leave  
  fc:	c3                   	ret    

000000fd <strchr>:

char*
strchr(const char *s, char c)
{
  fd:	55                   	push   %ebp
  fe:	89 e5                	mov    %esp,%ebp
 100:	83 ec 04             	sub    $0x4,%esp
 103:	8b 45 0c             	mov    0xc(%ebp),%eax
 106:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 109:	eb 14                	jmp    11f <strchr+0x22>
    if(*s == c)
 10b:	8b 45 08             	mov    0x8(%ebp),%eax
 10e:	0f b6 00             	movzbl (%eax),%eax
 111:	3a 45 fc             	cmp    -0x4(%ebp),%al
 114:	75 05                	jne    11b <strchr+0x1e>
      return (char*)s;
 116:	8b 45 08             	mov    0x8(%ebp),%eax
 119:	eb 13                	jmp    12e <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 11b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 11f:	8b 45 08             	mov    0x8(%ebp),%eax
 122:	0f b6 00             	movzbl (%eax),%eax
 125:	84 c0                	test   %al,%al
 127:	75 e2                	jne    10b <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 129:	b8 00 00 00 00       	mov    $0x0,%eax
}
 12e:	c9                   	leave  
 12f:	c3                   	ret    

00000130 <gets>:

char*
gets(char *buf, int max)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 136:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 13d:	eb 44                	jmp    183 <gets+0x53>
    cc = read(0, &c, 1);
 13f:	83 ec 04             	sub    $0x4,%esp
 142:	6a 01                	push   $0x1
 144:	8d 45 ef             	lea    -0x11(%ebp),%eax
 147:	50                   	push   %eax
 148:	6a 00                	push   $0x0
 14a:	e8 46 01 00 00       	call   295 <read>
 14f:	83 c4 10             	add    $0x10,%esp
 152:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 155:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 159:	7f 02                	jg     15d <gets+0x2d>
      break;
 15b:	eb 31                	jmp    18e <gets+0x5e>
    buf[i++] = c;
 15d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 160:	8d 50 01             	lea    0x1(%eax),%edx
 163:	89 55 f4             	mov    %edx,-0xc(%ebp)
 166:	89 c2                	mov    %eax,%edx
 168:	8b 45 08             	mov    0x8(%ebp),%eax
 16b:	01 c2                	add    %eax,%edx
 16d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 171:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 173:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 177:	3c 0a                	cmp    $0xa,%al
 179:	74 13                	je     18e <gets+0x5e>
 17b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17f:	3c 0d                	cmp    $0xd,%al
 181:	74 0b                	je     18e <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 183:	8b 45 f4             	mov    -0xc(%ebp),%eax
 186:	83 c0 01             	add    $0x1,%eax
 189:	3b 45 0c             	cmp    0xc(%ebp),%eax
 18c:	7c b1                	jl     13f <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 18e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 191:	8b 45 08             	mov    0x8(%ebp),%eax
 194:	01 d0                	add    %edx,%eax
 196:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 199:	8b 45 08             	mov    0x8(%ebp),%eax
}
 19c:	c9                   	leave  
 19d:	c3                   	ret    

0000019e <stat>:

int
stat(char *n, struct stat *st)
{
 19e:	55                   	push   %ebp
 19f:	89 e5                	mov    %esp,%ebp
 1a1:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a4:	83 ec 08             	sub    $0x8,%esp
 1a7:	6a 00                	push   $0x0
 1a9:	ff 75 08             	pushl  0x8(%ebp)
 1ac:	e8 0c 01 00 00       	call   2bd <open>
 1b1:	83 c4 10             	add    $0x10,%esp
 1b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1bb:	79 07                	jns    1c4 <stat+0x26>
    return -1;
 1bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1c2:	eb 25                	jmp    1e9 <stat+0x4b>
  r = fstat(fd, st);
 1c4:	83 ec 08             	sub    $0x8,%esp
 1c7:	ff 75 0c             	pushl  0xc(%ebp)
 1ca:	ff 75 f4             	pushl  -0xc(%ebp)
 1cd:	e8 03 01 00 00       	call   2d5 <fstat>
 1d2:	83 c4 10             	add    $0x10,%esp
 1d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1d8:	83 ec 0c             	sub    $0xc,%esp
 1db:	ff 75 f4             	pushl  -0xc(%ebp)
 1de:	e8 c2 00 00 00       	call   2a5 <close>
 1e3:	83 c4 10             	add    $0x10,%esp
  return r;
 1e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1e9:	c9                   	leave  
 1ea:	c3                   	ret    

000001eb <atoi>:

int
atoi(const char *s)
{
 1eb:	55                   	push   %ebp
 1ec:	89 e5                	mov    %esp,%ebp
 1ee:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 1f8:	eb 25                	jmp    21f <atoi+0x34>
    n = n*10 + *s++ - '0';
 1fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1fd:	89 d0                	mov    %edx,%eax
 1ff:	c1 e0 02             	shl    $0x2,%eax
 202:	01 d0                	add    %edx,%eax
 204:	01 c0                	add    %eax,%eax
 206:	89 c1                	mov    %eax,%ecx
 208:	8b 45 08             	mov    0x8(%ebp),%eax
 20b:	8d 50 01             	lea    0x1(%eax),%edx
 20e:	89 55 08             	mov    %edx,0x8(%ebp)
 211:	0f b6 00             	movzbl (%eax),%eax
 214:	0f be c0             	movsbl %al,%eax
 217:	01 c8                	add    %ecx,%eax
 219:	83 e8 30             	sub    $0x30,%eax
 21c:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 21f:	8b 45 08             	mov    0x8(%ebp),%eax
 222:	0f b6 00             	movzbl (%eax),%eax
 225:	3c 2f                	cmp    $0x2f,%al
 227:	7e 0a                	jle    233 <atoi+0x48>
 229:	8b 45 08             	mov    0x8(%ebp),%eax
 22c:	0f b6 00             	movzbl (%eax),%eax
 22f:	3c 39                	cmp    $0x39,%al
 231:	7e c7                	jle    1fa <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 233:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 236:	c9                   	leave  
 237:	c3                   	ret    

00000238 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 238:	55                   	push   %ebp
 239:	89 e5                	mov    %esp,%ebp
 23b:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 23e:	8b 45 08             	mov    0x8(%ebp),%eax
 241:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 244:	8b 45 0c             	mov    0xc(%ebp),%eax
 247:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 24a:	eb 17                	jmp    263 <memmove+0x2b>
    *dst++ = *src++;
 24c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 24f:	8d 50 01             	lea    0x1(%eax),%edx
 252:	89 55 fc             	mov    %edx,-0x4(%ebp)
 255:	8b 55 f8             	mov    -0x8(%ebp),%edx
 258:	8d 4a 01             	lea    0x1(%edx),%ecx
 25b:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 25e:	0f b6 12             	movzbl (%edx),%edx
 261:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 263:	8b 45 10             	mov    0x10(%ebp),%eax
 266:	8d 50 ff             	lea    -0x1(%eax),%edx
 269:	89 55 10             	mov    %edx,0x10(%ebp)
 26c:	85 c0                	test   %eax,%eax
 26e:	7f dc                	jg     24c <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 270:	8b 45 08             	mov    0x8(%ebp),%eax
}
 273:	c9                   	leave  
 274:	c3                   	ret    

00000275 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 275:	b8 01 00 00 00       	mov    $0x1,%eax
 27a:	cd 40                	int    $0x40
 27c:	c3                   	ret    

0000027d <exit>:
SYSCALL(exit)
 27d:	b8 02 00 00 00       	mov    $0x2,%eax
 282:	cd 40                	int    $0x40
 284:	c3                   	ret    

00000285 <wait>:
SYSCALL(wait)
 285:	b8 03 00 00 00       	mov    $0x3,%eax
 28a:	cd 40                	int    $0x40
 28c:	c3                   	ret    

0000028d <pipe>:
SYSCALL(pipe)
 28d:	b8 04 00 00 00       	mov    $0x4,%eax
 292:	cd 40                	int    $0x40
 294:	c3                   	ret    

00000295 <read>:
SYSCALL(read)
 295:	b8 05 00 00 00       	mov    $0x5,%eax
 29a:	cd 40                	int    $0x40
 29c:	c3                   	ret    

0000029d <write>:
SYSCALL(write)
 29d:	b8 10 00 00 00       	mov    $0x10,%eax
 2a2:	cd 40                	int    $0x40
 2a4:	c3                   	ret    

000002a5 <close>:
SYSCALL(close)
 2a5:	b8 15 00 00 00       	mov    $0x15,%eax
 2aa:	cd 40                	int    $0x40
 2ac:	c3                   	ret    

000002ad <kill>:
SYSCALL(kill)
 2ad:	b8 06 00 00 00       	mov    $0x6,%eax
 2b2:	cd 40                	int    $0x40
 2b4:	c3                   	ret    

000002b5 <exec>:
SYSCALL(exec)
 2b5:	b8 07 00 00 00       	mov    $0x7,%eax
 2ba:	cd 40                	int    $0x40
 2bc:	c3                   	ret    

000002bd <open>:
SYSCALL(open)
 2bd:	b8 0f 00 00 00       	mov    $0xf,%eax
 2c2:	cd 40                	int    $0x40
 2c4:	c3                   	ret    

000002c5 <mknod>:
SYSCALL(mknod)
 2c5:	b8 11 00 00 00       	mov    $0x11,%eax
 2ca:	cd 40                	int    $0x40
 2cc:	c3                   	ret    

000002cd <unlink>:
SYSCALL(unlink)
 2cd:	b8 12 00 00 00       	mov    $0x12,%eax
 2d2:	cd 40                	int    $0x40
 2d4:	c3                   	ret    

000002d5 <fstat>:
SYSCALL(fstat)
 2d5:	b8 08 00 00 00       	mov    $0x8,%eax
 2da:	cd 40                	int    $0x40
 2dc:	c3                   	ret    

000002dd <link>:
SYSCALL(link)
 2dd:	b8 13 00 00 00       	mov    $0x13,%eax
 2e2:	cd 40                	int    $0x40
 2e4:	c3                   	ret    

000002e5 <mkdir>:
SYSCALL(mkdir)
 2e5:	b8 14 00 00 00       	mov    $0x14,%eax
 2ea:	cd 40                	int    $0x40
 2ec:	c3                   	ret    

000002ed <chdir>:
SYSCALL(chdir)
 2ed:	b8 09 00 00 00       	mov    $0x9,%eax
 2f2:	cd 40                	int    $0x40
 2f4:	c3                   	ret    

000002f5 <dup>:
SYSCALL(dup)
 2f5:	b8 0a 00 00 00       	mov    $0xa,%eax
 2fa:	cd 40                	int    $0x40
 2fc:	c3                   	ret    

000002fd <getpid>:
SYSCALL(getpid)
 2fd:	b8 0b 00 00 00       	mov    $0xb,%eax
 302:	cd 40                	int    $0x40
 304:	c3                   	ret    

00000305 <sbrk>:
SYSCALL(sbrk)
 305:	b8 0c 00 00 00       	mov    $0xc,%eax
 30a:	cd 40                	int    $0x40
 30c:	c3                   	ret    

0000030d <sleep>:
SYSCALL(sleep)
 30d:	b8 0d 00 00 00       	mov    $0xd,%eax
 312:	cd 40                	int    $0x40
 314:	c3                   	ret    

00000315 <uptime>:
SYSCALL(uptime)
 315:	b8 0e 00 00 00       	mov    $0xe,%eax
 31a:	cd 40                	int    $0x40
 31c:	c3                   	ret    

0000031d <createTask>:

SYSCALL(createTask)
 31d:	b8 16 00 00 00       	mov    $0x16,%eax
 322:	cd 40                	int    $0x40
 324:	c3                   	ret    

00000325 <startTask>:
SYSCALL(startTask)
 325:	b8 17 00 00 00       	mov    $0x17,%eax
 32a:	cd 40                	int    $0x40
 32c:	c3                   	ret    

0000032d <waitTask>:
SYSCALL(waitTask)
 32d:	b8 18 00 00 00       	mov    $0x18,%eax
 332:	cd 40                	int    $0x40
 334:	c3                   	ret    

00000335 <Sched>:
SYSCALL(Sched)
 335:	b8 19 00 00 00       	mov    $0x19,%eax
 33a:	cd 40                	int    $0x40
 33c:	c3                   	ret    

0000033d <chmod>:

SYSCALL(chmod)
 33d:	b8 1a 00 00 00       	mov    $0x1a,%eax
 342:	cd 40                	int    $0x40
 344:	c3                   	ret    

00000345 <candprocs>:
SYSCALL(candprocs)
 345:	b8 1b 00 00 00       	mov    $0x1b,%eax
 34a:	cd 40                	int    $0x40
 34c:	c3                   	ret    

0000034d <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 34d:	55                   	push   %ebp
 34e:	89 e5                	mov    %esp,%ebp
 350:	83 ec 18             	sub    $0x18,%esp
 353:	8b 45 0c             	mov    0xc(%ebp),%eax
 356:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 359:	83 ec 04             	sub    $0x4,%esp
 35c:	6a 01                	push   $0x1
 35e:	8d 45 f4             	lea    -0xc(%ebp),%eax
 361:	50                   	push   %eax
 362:	ff 75 08             	pushl  0x8(%ebp)
 365:	e8 33 ff ff ff       	call   29d <write>
 36a:	83 c4 10             	add    $0x10,%esp
}
 36d:	c9                   	leave  
 36e:	c3                   	ret    

0000036f <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 36f:	55                   	push   %ebp
 370:	89 e5                	mov    %esp,%ebp
 372:	53                   	push   %ebx
 373:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 376:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 37d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 381:	74 17                	je     39a <printint+0x2b>
 383:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 387:	79 11                	jns    39a <printint+0x2b>
    neg = 1;
 389:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 390:	8b 45 0c             	mov    0xc(%ebp),%eax
 393:	f7 d8                	neg    %eax
 395:	89 45 ec             	mov    %eax,-0x14(%ebp)
 398:	eb 06                	jmp    3a0 <printint+0x31>
  } else {
    x = xx;
 39a:	8b 45 0c             	mov    0xc(%ebp),%eax
 39d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3a7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3aa:	8d 41 01             	lea    0x1(%ecx),%eax
 3ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3b0:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3b6:	ba 00 00 00 00       	mov    $0x0,%edx
 3bb:	f7 f3                	div    %ebx
 3bd:	89 d0                	mov    %edx,%eax
 3bf:	0f b6 80 38 0a 00 00 	movzbl 0xa38(%eax),%eax
 3c6:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3ca:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3d0:	ba 00 00 00 00       	mov    $0x0,%edx
 3d5:	f7 f3                	div    %ebx
 3d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3da:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3de:	75 c7                	jne    3a7 <printint+0x38>
  if(neg)
 3e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3e4:	74 0e                	je     3f4 <printint+0x85>
    buf[i++] = '-';
 3e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3e9:	8d 50 01             	lea    0x1(%eax),%edx
 3ec:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3ef:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 3f4:	eb 1d                	jmp    413 <printint+0xa4>
    putc(fd, buf[i]);
 3f6:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3fc:	01 d0                	add    %edx,%eax
 3fe:	0f b6 00             	movzbl (%eax),%eax
 401:	0f be c0             	movsbl %al,%eax
 404:	83 ec 08             	sub    $0x8,%esp
 407:	50                   	push   %eax
 408:	ff 75 08             	pushl  0x8(%ebp)
 40b:	e8 3d ff ff ff       	call   34d <putc>
 410:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 413:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 417:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 41b:	79 d9                	jns    3f6 <printint+0x87>
    putc(fd, buf[i]);
}
 41d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 420:	c9                   	leave  
 421:	c3                   	ret    

00000422 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 422:	55                   	push   %ebp
 423:	89 e5                	mov    %esp,%ebp
 425:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 428:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 42f:	8d 45 0c             	lea    0xc(%ebp),%eax
 432:	83 c0 04             	add    $0x4,%eax
 435:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 438:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 43f:	e9 59 01 00 00       	jmp    59d <printf+0x17b>
    c = fmt[i] & 0xff;
 444:	8b 55 0c             	mov    0xc(%ebp),%edx
 447:	8b 45 f0             	mov    -0x10(%ebp),%eax
 44a:	01 d0                	add    %edx,%eax
 44c:	0f b6 00             	movzbl (%eax),%eax
 44f:	0f be c0             	movsbl %al,%eax
 452:	25 ff 00 00 00       	and    $0xff,%eax
 457:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 45a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 45e:	75 2c                	jne    48c <printf+0x6a>
      if(c == '%'){
 460:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 464:	75 0c                	jne    472 <printf+0x50>
        state = '%';
 466:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 46d:	e9 27 01 00 00       	jmp    599 <printf+0x177>
      } else {
        putc(fd, c);
 472:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 475:	0f be c0             	movsbl %al,%eax
 478:	83 ec 08             	sub    $0x8,%esp
 47b:	50                   	push   %eax
 47c:	ff 75 08             	pushl  0x8(%ebp)
 47f:	e8 c9 fe ff ff       	call   34d <putc>
 484:	83 c4 10             	add    $0x10,%esp
 487:	e9 0d 01 00 00       	jmp    599 <printf+0x177>
      }
    } else if(state == '%'){
 48c:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 490:	0f 85 03 01 00 00    	jne    599 <printf+0x177>
      if(c == 'd'){
 496:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 49a:	75 1e                	jne    4ba <printf+0x98>
        printint(fd, *ap, 10, 1);
 49c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 49f:	8b 00                	mov    (%eax),%eax
 4a1:	6a 01                	push   $0x1
 4a3:	6a 0a                	push   $0xa
 4a5:	50                   	push   %eax
 4a6:	ff 75 08             	pushl  0x8(%ebp)
 4a9:	e8 c1 fe ff ff       	call   36f <printint>
 4ae:	83 c4 10             	add    $0x10,%esp
        ap++;
 4b1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4b5:	e9 d8 00 00 00       	jmp    592 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4ba:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4be:	74 06                	je     4c6 <printf+0xa4>
 4c0:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4c4:	75 1e                	jne    4e4 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4c9:	8b 00                	mov    (%eax),%eax
 4cb:	6a 00                	push   $0x0
 4cd:	6a 10                	push   $0x10
 4cf:	50                   	push   %eax
 4d0:	ff 75 08             	pushl  0x8(%ebp)
 4d3:	e8 97 fe ff ff       	call   36f <printint>
 4d8:	83 c4 10             	add    $0x10,%esp
        ap++;
 4db:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4df:	e9 ae 00 00 00       	jmp    592 <printf+0x170>
      } else if(c == 's'){
 4e4:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4e8:	75 43                	jne    52d <printf+0x10b>
        s = (char*)*ap;
 4ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4ed:	8b 00                	mov    (%eax),%eax
 4ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 4f2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 4f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4fa:	75 07                	jne    503 <printf+0xe1>
          s = "(null)";
 4fc:	c7 45 f4 e8 07 00 00 	movl   $0x7e8,-0xc(%ebp)
        while(*s != 0){
 503:	eb 1c                	jmp    521 <printf+0xff>
          putc(fd, *s);
 505:	8b 45 f4             	mov    -0xc(%ebp),%eax
 508:	0f b6 00             	movzbl (%eax),%eax
 50b:	0f be c0             	movsbl %al,%eax
 50e:	83 ec 08             	sub    $0x8,%esp
 511:	50                   	push   %eax
 512:	ff 75 08             	pushl  0x8(%ebp)
 515:	e8 33 fe ff ff       	call   34d <putc>
 51a:	83 c4 10             	add    $0x10,%esp
          s++;
 51d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 521:	8b 45 f4             	mov    -0xc(%ebp),%eax
 524:	0f b6 00             	movzbl (%eax),%eax
 527:	84 c0                	test   %al,%al
 529:	75 da                	jne    505 <printf+0xe3>
 52b:	eb 65                	jmp    592 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 52d:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 531:	75 1d                	jne    550 <printf+0x12e>
        putc(fd, *ap);
 533:	8b 45 e8             	mov    -0x18(%ebp),%eax
 536:	8b 00                	mov    (%eax),%eax
 538:	0f be c0             	movsbl %al,%eax
 53b:	83 ec 08             	sub    $0x8,%esp
 53e:	50                   	push   %eax
 53f:	ff 75 08             	pushl  0x8(%ebp)
 542:	e8 06 fe ff ff       	call   34d <putc>
 547:	83 c4 10             	add    $0x10,%esp
        ap++;
 54a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 54e:	eb 42                	jmp    592 <printf+0x170>
      } else if(c == '%'){
 550:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 554:	75 17                	jne    56d <printf+0x14b>
        putc(fd, c);
 556:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 559:	0f be c0             	movsbl %al,%eax
 55c:	83 ec 08             	sub    $0x8,%esp
 55f:	50                   	push   %eax
 560:	ff 75 08             	pushl  0x8(%ebp)
 563:	e8 e5 fd ff ff       	call   34d <putc>
 568:	83 c4 10             	add    $0x10,%esp
 56b:	eb 25                	jmp    592 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 56d:	83 ec 08             	sub    $0x8,%esp
 570:	6a 25                	push   $0x25
 572:	ff 75 08             	pushl  0x8(%ebp)
 575:	e8 d3 fd ff ff       	call   34d <putc>
 57a:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 57d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 580:	0f be c0             	movsbl %al,%eax
 583:	83 ec 08             	sub    $0x8,%esp
 586:	50                   	push   %eax
 587:	ff 75 08             	pushl  0x8(%ebp)
 58a:	e8 be fd ff ff       	call   34d <putc>
 58f:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 592:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 599:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 59d:	8b 55 0c             	mov    0xc(%ebp),%edx
 5a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5a3:	01 d0                	add    %edx,%eax
 5a5:	0f b6 00             	movzbl (%eax),%eax
 5a8:	84 c0                	test   %al,%al
 5aa:	0f 85 94 fe ff ff    	jne    444 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5b0:	c9                   	leave  
 5b1:	c3                   	ret    

000005b2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5b2:	55                   	push   %ebp
 5b3:	89 e5                	mov    %esp,%ebp
 5b5:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5b8:	8b 45 08             	mov    0x8(%ebp),%eax
 5bb:	83 e8 08             	sub    $0x8,%eax
 5be:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5c1:	a1 54 0a 00 00       	mov    0xa54,%eax
 5c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5c9:	eb 24                	jmp    5ef <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ce:	8b 00                	mov    (%eax),%eax
 5d0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5d3:	77 12                	ja     5e7 <free+0x35>
 5d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5d8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5db:	77 24                	ja     601 <free+0x4f>
 5dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5e0:	8b 00                	mov    (%eax),%eax
 5e2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5e5:	77 1a                	ja     601 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ea:	8b 00                	mov    (%eax),%eax
 5ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5f2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5f5:	76 d4                	jbe    5cb <free+0x19>
 5f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5fa:	8b 00                	mov    (%eax),%eax
 5fc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5ff:	76 ca                	jbe    5cb <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 601:	8b 45 f8             	mov    -0x8(%ebp),%eax
 604:	8b 40 04             	mov    0x4(%eax),%eax
 607:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 60e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 611:	01 c2                	add    %eax,%edx
 613:	8b 45 fc             	mov    -0x4(%ebp),%eax
 616:	8b 00                	mov    (%eax),%eax
 618:	39 c2                	cmp    %eax,%edx
 61a:	75 24                	jne    640 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 61c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61f:	8b 50 04             	mov    0x4(%eax),%edx
 622:	8b 45 fc             	mov    -0x4(%ebp),%eax
 625:	8b 00                	mov    (%eax),%eax
 627:	8b 40 04             	mov    0x4(%eax),%eax
 62a:	01 c2                	add    %eax,%edx
 62c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62f:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 632:	8b 45 fc             	mov    -0x4(%ebp),%eax
 635:	8b 00                	mov    (%eax),%eax
 637:	8b 10                	mov    (%eax),%edx
 639:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63c:	89 10                	mov    %edx,(%eax)
 63e:	eb 0a                	jmp    64a <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 640:	8b 45 fc             	mov    -0x4(%ebp),%eax
 643:	8b 10                	mov    (%eax),%edx
 645:	8b 45 f8             	mov    -0x8(%ebp),%eax
 648:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 64a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64d:	8b 40 04             	mov    0x4(%eax),%eax
 650:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 657:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65a:	01 d0                	add    %edx,%eax
 65c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 65f:	75 20                	jne    681 <free+0xcf>
    p->s.size += bp->s.size;
 661:	8b 45 fc             	mov    -0x4(%ebp),%eax
 664:	8b 50 04             	mov    0x4(%eax),%edx
 667:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66a:	8b 40 04             	mov    0x4(%eax),%eax
 66d:	01 c2                	add    %eax,%edx
 66f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 672:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 675:	8b 45 f8             	mov    -0x8(%ebp),%eax
 678:	8b 10                	mov    (%eax),%edx
 67a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67d:	89 10                	mov    %edx,(%eax)
 67f:	eb 08                	jmp    689 <free+0xd7>
  } else
    p->s.ptr = bp;
 681:	8b 45 fc             	mov    -0x4(%ebp),%eax
 684:	8b 55 f8             	mov    -0x8(%ebp),%edx
 687:	89 10                	mov    %edx,(%eax)
  freep = p;
 689:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68c:	a3 54 0a 00 00       	mov    %eax,0xa54
}
 691:	c9                   	leave  
 692:	c3                   	ret    

00000693 <morecore>:

static Header*
morecore(uint nu)
{
 693:	55                   	push   %ebp
 694:	89 e5                	mov    %esp,%ebp
 696:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 699:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6a0:	77 07                	ja     6a9 <morecore+0x16>
    nu = 4096;
 6a2:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6a9:	8b 45 08             	mov    0x8(%ebp),%eax
 6ac:	c1 e0 03             	shl    $0x3,%eax
 6af:	83 ec 0c             	sub    $0xc,%esp
 6b2:	50                   	push   %eax
 6b3:	e8 4d fc ff ff       	call   305 <sbrk>
 6b8:	83 c4 10             	add    $0x10,%esp
 6bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6be:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6c2:	75 07                	jne    6cb <morecore+0x38>
    return 0;
 6c4:	b8 00 00 00 00       	mov    $0x0,%eax
 6c9:	eb 26                	jmp    6f1 <morecore+0x5e>
  hp = (Header*)p;
 6cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6d4:	8b 55 08             	mov    0x8(%ebp),%edx
 6d7:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6da:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6dd:	83 c0 08             	add    $0x8,%eax
 6e0:	83 ec 0c             	sub    $0xc,%esp
 6e3:	50                   	push   %eax
 6e4:	e8 c9 fe ff ff       	call   5b2 <free>
 6e9:	83 c4 10             	add    $0x10,%esp
  return freep;
 6ec:	a1 54 0a 00 00       	mov    0xa54,%eax
}
 6f1:	c9                   	leave  
 6f2:	c3                   	ret    

000006f3 <malloc>:

void*
malloc(uint nbytes)
{
 6f3:	55                   	push   %ebp
 6f4:	89 e5                	mov    %esp,%ebp
 6f6:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6f9:	8b 45 08             	mov    0x8(%ebp),%eax
 6fc:	83 c0 07             	add    $0x7,%eax
 6ff:	c1 e8 03             	shr    $0x3,%eax
 702:	83 c0 01             	add    $0x1,%eax
 705:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 708:	a1 54 0a 00 00       	mov    0xa54,%eax
 70d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 710:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 714:	75 23                	jne    739 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 716:	c7 45 f0 4c 0a 00 00 	movl   $0xa4c,-0x10(%ebp)
 71d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 720:	a3 54 0a 00 00       	mov    %eax,0xa54
 725:	a1 54 0a 00 00       	mov    0xa54,%eax
 72a:	a3 4c 0a 00 00       	mov    %eax,0xa4c
    base.s.size = 0;
 72f:	c7 05 50 0a 00 00 00 	movl   $0x0,0xa50
 736:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 739:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73c:	8b 00                	mov    (%eax),%eax
 73e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 741:	8b 45 f4             	mov    -0xc(%ebp),%eax
 744:	8b 40 04             	mov    0x4(%eax),%eax
 747:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 74a:	72 4d                	jb     799 <malloc+0xa6>
      if(p->s.size == nunits)
 74c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 74f:	8b 40 04             	mov    0x4(%eax),%eax
 752:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 755:	75 0c                	jne    763 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 757:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75a:	8b 10                	mov    (%eax),%edx
 75c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75f:	89 10                	mov    %edx,(%eax)
 761:	eb 26                	jmp    789 <malloc+0x96>
      else {
        p->s.size -= nunits;
 763:	8b 45 f4             	mov    -0xc(%ebp),%eax
 766:	8b 40 04             	mov    0x4(%eax),%eax
 769:	2b 45 ec             	sub    -0x14(%ebp),%eax
 76c:	89 c2                	mov    %eax,%edx
 76e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 771:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 774:	8b 45 f4             	mov    -0xc(%ebp),%eax
 777:	8b 40 04             	mov    0x4(%eax),%eax
 77a:	c1 e0 03             	shl    $0x3,%eax
 77d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 780:	8b 45 f4             	mov    -0xc(%ebp),%eax
 783:	8b 55 ec             	mov    -0x14(%ebp),%edx
 786:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 789:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78c:	a3 54 0a 00 00       	mov    %eax,0xa54
      return (void*)(p + 1);
 791:	8b 45 f4             	mov    -0xc(%ebp),%eax
 794:	83 c0 08             	add    $0x8,%eax
 797:	eb 3b                	jmp    7d4 <malloc+0xe1>
    }
    if(p == freep)
 799:	a1 54 0a 00 00       	mov    0xa54,%eax
 79e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7a1:	75 1e                	jne    7c1 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7a3:	83 ec 0c             	sub    $0xc,%esp
 7a6:	ff 75 ec             	pushl  -0x14(%ebp)
 7a9:	e8 e5 fe ff ff       	call   693 <morecore>
 7ae:	83 c4 10             	add    $0x10,%esp
 7b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7b8:	75 07                	jne    7c1 <malloc+0xce>
        return 0;
 7ba:	b8 00 00 00 00       	mov    $0x0,%eax
 7bf:	eb 13                	jmp    7d4 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ca:	8b 00                	mov    (%eax),%eax
 7cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7cf:	e9 6d ff ff ff       	jmp    741 <malloc+0x4e>
}
 7d4:	c9                   	leave  
 7d5:	c3                   	ret    

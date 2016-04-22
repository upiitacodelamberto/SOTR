
_forktest:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <printf>:

#define N  1000

void
printf(int fd, char *s, ...)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 08             	sub    $0x8,%esp
  write(fd, s, strlen(s));
   6:	83 ec 0c             	sub    $0xc,%esp
   9:	ff 75 0c             	pushl  0xc(%ebp)
   c:	e8 95 01 00 00       	call   1a6 <strlen>
  11:	83 c4 10             	add    $0x10,%esp
  14:	83 ec 04             	sub    $0x4,%esp
  17:	50                   	push   %eax
  18:	ff 75 0c             	pushl  0xc(%ebp)
  1b:	ff 75 08             	pushl  0x8(%ebp)
  1e:	e8 64 03 00 00       	call   387 <write>
  23:	83 c4 10             	add    $0x10,%esp
}
  26:	c9                   	leave  
  27:	c3                   	ret    

00000028 <forktest>:

void
forktest(void)
{
  28:	55                   	push   %ebp
  29:	89 e5                	mov    %esp,%ebp
  2b:	83 ec 18             	sub    $0x18,%esp
  int n, pid;

  printf(1, "fork test\n");
  2e:	83 ec 08             	sub    $0x8,%esp
  31:	68 38 04 00 00       	push   $0x438
  36:	6a 01                	push   $0x1
  38:	e8 c3 ff ff ff       	call   0 <printf>
  3d:	83 c4 10             	add    $0x10,%esp

  for(n=0; n<N; n++){
  40:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  47:	eb 1f                	jmp    68 <forktest+0x40>
    pid = fork();
  49:	e8 11 03 00 00       	call   35f <fork>
  4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0)
  51:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  55:	79 02                	jns    59 <forktest+0x31>
      break;
  57:	eb 18                	jmp    71 <forktest+0x49>
    if(pid == 0){
  59:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  5d:	75 05                	jne    64 <forktest+0x3c>
      exit();
  5f:	e8 03 03 00 00       	call   367 <exit>
{
  int n, pid;

  printf(1, "fork test\n");

  for(n=0; n<N; n++){
  64:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  68:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
  6f:	7e d8                	jle    49 <forktest+0x21>
    if(pid == 0){
      exit();
    }
  }
  
  if(n == N){
  71:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
  78:	75 1c                	jne    96 <forktest+0x6e>
    printf(1, "fork claimed to work N times!\n", N);
  7a:	83 ec 04             	sub    $0x4,%esp
  7d:	68 e8 03 00 00       	push   $0x3e8
  82:	68 44 04 00 00       	push   $0x444
  87:	6a 01                	push   $0x1
  89:	e8 72 ff ff ff       	call   0 <printf>
  8e:	83 c4 10             	add    $0x10,%esp
    exit();
  91:	e8 d1 02 00 00       	call   367 <exit>
  }
  
  for(; n > 0; n--){
  96:	eb 24                	jmp    bc <forktest+0x94>
    if(wait() < 0){
  98:	e8 d2 02 00 00       	call   36f <wait>
  9d:	85 c0                	test   %eax,%eax
  9f:	79 17                	jns    b8 <forktest+0x90>
      printf(1, "wait stopped early\n");
  a1:	83 ec 08             	sub    $0x8,%esp
  a4:	68 63 04 00 00       	push   $0x463
  a9:	6a 01                	push   $0x1
  ab:	e8 50 ff ff ff       	call   0 <printf>
  b0:	83 c4 10             	add    $0x10,%esp
      exit();
  b3:	e8 af 02 00 00       	call   367 <exit>
  if(n == N){
    printf(1, "fork claimed to work N times!\n", N);
    exit();
  }
  
  for(; n > 0; n--){
  b8:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  c0:	7f d6                	jg     98 <forktest+0x70>
      printf(1, "wait stopped early\n");
      exit();
    }
  }
  
  if(wait() != -1){
  c2:	e8 a8 02 00 00       	call   36f <wait>
  c7:	83 f8 ff             	cmp    $0xffffffff,%eax
  ca:	74 17                	je     e3 <forktest+0xbb>
    printf(1, "wait got too many\n");
  cc:	83 ec 08             	sub    $0x8,%esp
  cf:	68 77 04 00 00       	push   $0x477
  d4:	6a 01                	push   $0x1
  d6:	e8 25 ff ff ff       	call   0 <printf>
  db:	83 c4 10             	add    $0x10,%esp
    exit();
  de:	e8 84 02 00 00       	call   367 <exit>
  }
  
  printf(1, "fork test OK\n");
  e3:	83 ec 08             	sub    $0x8,%esp
  e6:	68 8a 04 00 00       	push   $0x48a
  eb:	6a 01                	push   $0x1
  ed:	e8 0e ff ff ff       	call   0 <printf>
  f2:	83 c4 10             	add    $0x10,%esp
}
  f5:	c9                   	leave  
  f6:	c3                   	ret    

000000f7 <main>:

int
main(void)
{
  f7:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  fb:	83 e4 f0             	and    $0xfffffff0,%esp
  fe:	ff 71 fc             	pushl  -0x4(%ecx)
 101:	55                   	push   %ebp
 102:	89 e5                	mov    %esp,%ebp
 104:	51                   	push   %ecx
 105:	83 ec 04             	sub    $0x4,%esp
  forktest();
 108:	e8 1b ff ff ff       	call   28 <forktest>
  exit();
 10d:	e8 55 02 00 00       	call   367 <exit>

00000112 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 112:	55                   	push   %ebp
 113:	89 e5                	mov    %esp,%ebp
 115:	57                   	push   %edi
 116:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 117:	8b 4d 08             	mov    0x8(%ebp),%ecx
 11a:	8b 55 10             	mov    0x10(%ebp),%edx
 11d:	8b 45 0c             	mov    0xc(%ebp),%eax
 120:	89 cb                	mov    %ecx,%ebx
 122:	89 df                	mov    %ebx,%edi
 124:	89 d1                	mov    %edx,%ecx
 126:	fc                   	cld    
 127:	f3 aa                	rep stos %al,%es:(%edi)
 129:	89 ca                	mov    %ecx,%edx
 12b:	89 fb                	mov    %edi,%ebx
 12d:	89 5d 08             	mov    %ebx,0x8(%ebp)
 130:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 133:	5b                   	pop    %ebx
 134:	5f                   	pop    %edi
 135:	5d                   	pop    %ebp
 136:	c3                   	ret    

00000137 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 137:	55                   	push   %ebp
 138:	89 e5                	mov    %esp,%ebp
 13a:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 13d:	8b 45 08             	mov    0x8(%ebp),%eax
 140:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 143:	90                   	nop
 144:	8b 45 08             	mov    0x8(%ebp),%eax
 147:	8d 50 01             	lea    0x1(%eax),%edx
 14a:	89 55 08             	mov    %edx,0x8(%ebp)
 14d:	8b 55 0c             	mov    0xc(%ebp),%edx
 150:	8d 4a 01             	lea    0x1(%edx),%ecx
 153:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 156:	0f b6 12             	movzbl (%edx),%edx
 159:	88 10                	mov    %dl,(%eax)
 15b:	0f b6 00             	movzbl (%eax),%eax
 15e:	84 c0                	test   %al,%al
 160:	75 e2                	jne    144 <strcpy+0xd>
    ;
  return os;
 162:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 165:	c9                   	leave  
 166:	c3                   	ret    

00000167 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 167:	55                   	push   %ebp
 168:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 16a:	eb 08                	jmp    174 <strcmp+0xd>
    p++, q++;
 16c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 170:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 174:	8b 45 08             	mov    0x8(%ebp),%eax
 177:	0f b6 00             	movzbl (%eax),%eax
 17a:	84 c0                	test   %al,%al
 17c:	74 10                	je     18e <strcmp+0x27>
 17e:	8b 45 08             	mov    0x8(%ebp),%eax
 181:	0f b6 10             	movzbl (%eax),%edx
 184:	8b 45 0c             	mov    0xc(%ebp),%eax
 187:	0f b6 00             	movzbl (%eax),%eax
 18a:	38 c2                	cmp    %al,%dl
 18c:	74 de                	je     16c <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 18e:	8b 45 08             	mov    0x8(%ebp),%eax
 191:	0f b6 00             	movzbl (%eax),%eax
 194:	0f b6 d0             	movzbl %al,%edx
 197:	8b 45 0c             	mov    0xc(%ebp),%eax
 19a:	0f b6 00             	movzbl (%eax),%eax
 19d:	0f b6 c0             	movzbl %al,%eax
 1a0:	29 c2                	sub    %eax,%edx
 1a2:	89 d0                	mov    %edx,%eax
}
 1a4:	5d                   	pop    %ebp
 1a5:	c3                   	ret    

000001a6 <strlen>:

uint
strlen(char *s)
{
 1a6:	55                   	push   %ebp
 1a7:	89 e5                	mov    %esp,%ebp
 1a9:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1b3:	eb 04                	jmp    1b9 <strlen+0x13>
 1b5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1bc:	8b 45 08             	mov    0x8(%ebp),%eax
 1bf:	01 d0                	add    %edx,%eax
 1c1:	0f b6 00             	movzbl (%eax),%eax
 1c4:	84 c0                	test   %al,%al
 1c6:	75 ed                	jne    1b5 <strlen+0xf>
    ;
  return n;
 1c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1cb:	c9                   	leave  
 1cc:	c3                   	ret    

000001cd <memset>:

void*
memset(void *dst, int c, uint n)
{
 1cd:	55                   	push   %ebp
 1ce:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1d0:	8b 45 10             	mov    0x10(%ebp),%eax
 1d3:	50                   	push   %eax
 1d4:	ff 75 0c             	pushl  0xc(%ebp)
 1d7:	ff 75 08             	pushl  0x8(%ebp)
 1da:	e8 33 ff ff ff       	call   112 <stosb>
 1df:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1e2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e5:	c9                   	leave  
 1e6:	c3                   	ret    

000001e7 <strchr>:

char*
strchr(const char *s, char c)
{
 1e7:	55                   	push   %ebp
 1e8:	89 e5                	mov    %esp,%ebp
 1ea:	83 ec 04             	sub    $0x4,%esp
 1ed:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f0:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1f3:	eb 14                	jmp    209 <strchr+0x22>
    if(*s == c)
 1f5:	8b 45 08             	mov    0x8(%ebp),%eax
 1f8:	0f b6 00             	movzbl (%eax),%eax
 1fb:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1fe:	75 05                	jne    205 <strchr+0x1e>
      return (char*)s;
 200:	8b 45 08             	mov    0x8(%ebp),%eax
 203:	eb 13                	jmp    218 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 205:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 209:	8b 45 08             	mov    0x8(%ebp),%eax
 20c:	0f b6 00             	movzbl (%eax),%eax
 20f:	84 c0                	test   %al,%al
 211:	75 e2                	jne    1f5 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 213:	b8 00 00 00 00       	mov    $0x0,%eax
}
 218:	c9                   	leave  
 219:	c3                   	ret    

0000021a <gets>:

char*
gets(char *buf, int max)
{
 21a:	55                   	push   %ebp
 21b:	89 e5                	mov    %esp,%ebp
 21d:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 220:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 227:	eb 44                	jmp    26d <gets+0x53>
    cc = read(0, &c, 1);
 229:	83 ec 04             	sub    $0x4,%esp
 22c:	6a 01                	push   $0x1
 22e:	8d 45 ef             	lea    -0x11(%ebp),%eax
 231:	50                   	push   %eax
 232:	6a 00                	push   $0x0
 234:	e8 46 01 00 00       	call   37f <read>
 239:	83 c4 10             	add    $0x10,%esp
 23c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 23f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 243:	7f 02                	jg     247 <gets+0x2d>
      break;
 245:	eb 31                	jmp    278 <gets+0x5e>
    buf[i++] = c;
 247:	8b 45 f4             	mov    -0xc(%ebp),%eax
 24a:	8d 50 01             	lea    0x1(%eax),%edx
 24d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 250:	89 c2                	mov    %eax,%edx
 252:	8b 45 08             	mov    0x8(%ebp),%eax
 255:	01 c2                	add    %eax,%edx
 257:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 25b:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 25d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 261:	3c 0a                	cmp    $0xa,%al
 263:	74 13                	je     278 <gets+0x5e>
 265:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 269:	3c 0d                	cmp    $0xd,%al
 26b:	74 0b                	je     278 <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 26d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 270:	83 c0 01             	add    $0x1,%eax
 273:	3b 45 0c             	cmp    0xc(%ebp),%eax
 276:	7c b1                	jl     229 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 278:	8b 55 f4             	mov    -0xc(%ebp),%edx
 27b:	8b 45 08             	mov    0x8(%ebp),%eax
 27e:	01 d0                	add    %edx,%eax
 280:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 283:	8b 45 08             	mov    0x8(%ebp),%eax
}
 286:	c9                   	leave  
 287:	c3                   	ret    

00000288 <stat>:

int
stat(char *n, struct stat *st)
{
 288:	55                   	push   %ebp
 289:	89 e5                	mov    %esp,%ebp
 28b:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 28e:	83 ec 08             	sub    $0x8,%esp
 291:	6a 00                	push   $0x0
 293:	ff 75 08             	pushl  0x8(%ebp)
 296:	e8 0c 01 00 00       	call   3a7 <open>
 29b:	83 c4 10             	add    $0x10,%esp
 29e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2a5:	79 07                	jns    2ae <stat+0x26>
    return -1;
 2a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2ac:	eb 25                	jmp    2d3 <stat+0x4b>
  r = fstat(fd, st);
 2ae:	83 ec 08             	sub    $0x8,%esp
 2b1:	ff 75 0c             	pushl  0xc(%ebp)
 2b4:	ff 75 f4             	pushl  -0xc(%ebp)
 2b7:	e8 03 01 00 00       	call   3bf <fstat>
 2bc:	83 c4 10             	add    $0x10,%esp
 2bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2c2:	83 ec 0c             	sub    $0xc,%esp
 2c5:	ff 75 f4             	pushl  -0xc(%ebp)
 2c8:	e8 c2 00 00 00       	call   38f <close>
 2cd:	83 c4 10             	add    $0x10,%esp
  return r;
 2d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2d3:	c9                   	leave  
 2d4:	c3                   	ret    

000002d5 <atoi>:

int
atoi(const char *s)
{
 2d5:	55                   	push   %ebp
 2d6:	89 e5                	mov    %esp,%ebp
 2d8:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2e2:	eb 25                	jmp    309 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2e4:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2e7:	89 d0                	mov    %edx,%eax
 2e9:	c1 e0 02             	shl    $0x2,%eax
 2ec:	01 d0                	add    %edx,%eax
 2ee:	01 c0                	add    %eax,%eax
 2f0:	89 c1                	mov    %eax,%ecx
 2f2:	8b 45 08             	mov    0x8(%ebp),%eax
 2f5:	8d 50 01             	lea    0x1(%eax),%edx
 2f8:	89 55 08             	mov    %edx,0x8(%ebp)
 2fb:	0f b6 00             	movzbl (%eax),%eax
 2fe:	0f be c0             	movsbl %al,%eax
 301:	01 c8                	add    %ecx,%eax
 303:	83 e8 30             	sub    $0x30,%eax
 306:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 309:	8b 45 08             	mov    0x8(%ebp),%eax
 30c:	0f b6 00             	movzbl (%eax),%eax
 30f:	3c 2f                	cmp    $0x2f,%al
 311:	7e 0a                	jle    31d <atoi+0x48>
 313:	8b 45 08             	mov    0x8(%ebp),%eax
 316:	0f b6 00             	movzbl (%eax),%eax
 319:	3c 39                	cmp    $0x39,%al
 31b:	7e c7                	jle    2e4 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 31d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 320:	c9                   	leave  
 321:	c3                   	ret    

00000322 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 322:	55                   	push   %ebp
 323:	89 e5                	mov    %esp,%ebp
 325:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 328:	8b 45 08             	mov    0x8(%ebp),%eax
 32b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 32e:	8b 45 0c             	mov    0xc(%ebp),%eax
 331:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 334:	eb 17                	jmp    34d <memmove+0x2b>
    *dst++ = *src++;
 336:	8b 45 fc             	mov    -0x4(%ebp),%eax
 339:	8d 50 01             	lea    0x1(%eax),%edx
 33c:	89 55 fc             	mov    %edx,-0x4(%ebp)
 33f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 342:	8d 4a 01             	lea    0x1(%edx),%ecx
 345:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 348:	0f b6 12             	movzbl (%edx),%edx
 34b:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 34d:	8b 45 10             	mov    0x10(%ebp),%eax
 350:	8d 50 ff             	lea    -0x1(%eax),%edx
 353:	89 55 10             	mov    %edx,0x10(%ebp)
 356:	85 c0                	test   %eax,%eax
 358:	7f dc                	jg     336 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 35a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 35d:	c9                   	leave  
 35e:	c3                   	ret    

0000035f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 35f:	b8 01 00 00 00       	mov    $0x1,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <exit>:
SYSCALL(exit)
 367:	b8 02 00 00 00       	mov    $0x2,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <wait>:
SYSCALL(wait)
 36f:	b8 03 00 00 00       	mov    $0x3,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    

00000377 <pipe>:
SYSCALL(pipe)
 377:	b8 04 00 00 00       	mov    $0x4,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret    

0000037f <read>:
SYSCALL(read)
 37f:	b8 05 00 00 00       	mov    $0x5,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret    

00000387 <write>:
SYSCALL(write)
 387:	b8 10 00 00 00       	mov    $0x10,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret    

0000038f <close>:
SYSCALL(close)
 38f:	b8 15 00 00 00       	mov    $0x15,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret    

00000397 <kill>:
SYSCALL(kill)
 397:	b8 06 00 00 00       	mov    $0x6,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret    

0000039f <exec>:
SYSCALL(exec)
 39f:	b8 07 00 00 00       	mov    $0x7,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret    

000003a7 <open>:
SYSCALL(open)
 3a7:	b8 0f 00 00 00       	mov    $0xf,%eax
 3ac:	cd 40                	int    $0x40
 3ae:	c3                   	ret    

000003af <mknod>:
SYSCALL(mknod)
 3af:	b8 11 00 00 00       	mov    $0x11,%eax
 3b4:	cd 40                	int    $0x40
 3b6:	c3                   	ret    

000003b7 <unlink>:
SYSCALL(unlink)
 3b7:	b8 12 00 00 00       	mov    $0x12,%eax
 3bc:	cd 40                	int    $0x40
 3be:	c3                   	ret    

000003bf <fstat>:
SYSCALL(fstat)
 3bf:	b8 08 00 00 00       	mov    $0x8,%eax
 3c4:	cd 40                	int    $0x40
 3c6:	c3                   	ret    

000003c7 <link>:
SYSCALL(link)
 3c7:	b8 13 00 00 00       	mov    $0x13,%eax
 3cc:	cd 40                	int    $0x40
 3ce:	c3                   	ret    

000003cf <mkdir>:
SYSCALL(mkdir)
 3cf:	b8 14 00 00 00       	mov    $0x14,%eax
 3d4:	cd 40                	int    $0x40
 3d6:	c3                   	ret    

000003d7 <chdir>:
SYSCALL(chdir)
 3d7:	b8 09 00 00 00       	mov    $0x9,%eax
 3dc:	cd 40                	int    $0x40
 3de:	c3                   	ret    

000003df <dup>:
SYSCALL(dup)
 3df:	b8 0a 00 00 00       	mov    $0xa,%eax
 3e4:	cd 40                	int    $0x40
 3e6:	c3                   	ret    

000003e7 <getpid>:
SYSCALL(getpid)
 3e7:	b8 0b 00 00 00       	mov    $0xb,%eax
 3ec:	cd 40                	int    $0x40
 3ee:	c3                   	ret    

000003ef <sbrk>:
SYSCALL(sbrk)
 3ef:	b8 0c 00 00 00       	mov    $0xc,%eax
 3f4:	cd 40                	int    $0x40
 3f6:	c3                   	ret    

000003f7 <sleep>:
SYSCALL(sleep)
 3f7:	b8 0d 00 00 00       	mov    $0xd,%eax
 3fc:	cd 40                	int    $0x40
 3fe:	c3                   	ret    

000003ff <uptime>:
SYSCALL(uptime)
 3ff:	b8 0e 00 00 00       	mov    $0xe,%eax
 404:	cd 40                	int    $0x40
 406:	c3                   	ret    

00000407 <createTask>:

SYSCALL(createTask)
 407:	b8 16 00 00 00       	mov    $0x16,%eax
 40c:	cd 40                	int    $0x40
 40e:	c3                   	ret    

0000040f <startTask>:
SYSCALL(startTask)
 40f:	b8 17 00 00 00       	mov    $0x17,%eax
 414:	cd 40                	int    $0x40
 416:	c3                   	ret    

00000417 <waitTask>:
SYSCALL(waitTask)
 417:	b8 18 00 00 00       	mov    $0x18,%eax
 41c:	cd 40                	int    $0x40
 41e:	c3                   	ret    

0000041f <Sched>:
SYSCALL(Sched)
 41f:	b8 19 00 00 00       	mov    $0x19,%eax
 424:	cd 40                	int    $0x40
 426:	c3                   	ret    

00000427 <chmod>:

SYSCALL(chmod)
 427:	b8 1a 00 00 00       	mov    $0x1a,%eax
 42c:	cd 40                	int    $0x40
 42e:	c3                   	ret    

0000042f <candprocs>:
SYSCALL(candprocs)
 42f:	b8 1b 00 00 00       	mov    $0x1b,%eax
 434:	cd 40                	int    $0x40
 436:	c3                   	ret    

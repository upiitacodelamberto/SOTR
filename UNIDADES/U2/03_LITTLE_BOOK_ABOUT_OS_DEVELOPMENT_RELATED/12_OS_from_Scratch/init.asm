
_init:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:
//char *argv1[] = { "TaskId_1", 0 };
//char *argv2[] = { "TaskId_2", 0 };

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
  11:	83 ec 08             	sub    $0x8,%esp
  14:	6a 02                	push   $0x2
  16:	68 c3 08 00 00       	push   $0x8c3
  1b:	e8 86 03 00 00       	call   3a6 <open>
  20:	83 c4 10             	add    $0x10,%esp
  23:	85 c0                	test   %eax,%eax
  25:	79 26                	jns    4d <main+0x4d>
    mknod("console", 1, 1);
  27:	83 ec 04             	sub    $0x4,%esp
  2a:	6a 01                	push   $0x1
  2c:	6a 01                	push   $0x1
  2e:	68 c3 08 00 00       	push   $0x8c3
  33:	e8 76 03 00 00       	call   3ae <mknod>
  38:	83 c4 10             	add    $0x10,%esp
    open("console", O_RDWR);
  3b:	83 ec 08             	sub    $0x8,%esp
  3e:	6a 02                	push   $0x2
  40:	68 c3 08 00 00       	push   $0x8c3
  45:	e8 5c 03 00 00       	call   3a6 <open>
  4a:	83 c4 10             	add    $0x10,%esp
  }
  dup(0);  // stdout
  4d:	83 ec 0c             	sub    $0xc,%esp
  50:	6a 00                	push   $0x0
  52:	e8 87 03 00 00       	call   3de <dup>
  57:	83 c4 10             	add    $0x10,%esp
  dup(0);  // stderr
  5a:	83 ec 0c             	sub    $0xc,%esp
  5d:	6a 00                	push   $0x0
  5f:	e8 7a 03 00 00       	call   3de <dup>
  64:	83 c4 10             	add    $0x10,%esp
  //createTask(2, TaskId_2,argv2);
  for(;;){
    /*Este mensaje solo se muestra una vez*/
    /*Por lo que aunque este ciclo for es infinito, 
      en realidad parece ejecutarse solo una vez.*/
    printf(1, "init: starting sh\n");
  67:	83 ec 08             	sub    $0x8,%esp
  6a:	68 cb 08 00 00       	push   $0x8cb
  6f:	6a 01                	push   $0x1
  71:	e8 95 04 00 00       	call   50b <printf>
  76:	83 c4 10             	add    $0x10,%esp
    pid = fork();
  79:	e8 e0 02 00 00       	call   35e <fork>
  7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(pid < 0){
  81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  85:	79 17                	jns    9e <main+0x9e>
      printf(1, "init: fork failed\n");
  87:	83 ec 08             	sub    $0x8,%esp
  8a:	68 de 08 00 00       	push   $0x8de
  8f:	6a 01                	push   $0x1
  91:	e8 75 04 00 00       	call   50b <printf>
  96:	83 c4 10             	add    $0x10,%esp
      exit();
  99:	e8 c8 02 00 00       	call   366 <exit>
    }
    if(pid == 0){
  9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a2:	75 3e                	jne    e2 <main+0xe2>
//20160401
      printf(1,"En el proceso hijo de init.c:exec(\"sh\", argv);\n");
  a4:	83 ec 08             	sub    $0x8,%esp
  a7:	68 f4 08 00 00       	push   $0x8f4
  ac:	6a 01                	push   $0x1
  ae:	e8 58 04 00 00       	call   50b <printf>
  b3:	83 c4 10             	add    $0x10,%esp
      exec("sh", argv);
  b6:	83 ec 08             	sub    $0x8,%esp
  b9:	68 94 0b 00 00       	push   $0xb94
  be:	68 c0 08 00 00       	push   $0x8c0
  c3:	e8 d6 02 00 00       	call   39e <exec>
  c8:	83 c4 10             	add    $0x10,%esp
//      Sched();

      printf(1, "init: exec sh failed\n");
  cb:	83 ec 08             	sub    $0x8,%esp
  ce:	68 24 09 00 00       	push   $0x924
  d3:	6a 01                	push   $0x1
  d5:	e8 31 04 00 00       	call   50b <printf>
  da:	83 c4 10             	add    $0x10,%esp
      exit();
  dd:	e8 84 02 00 00       	call   366 <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  e2:	eb 12                	jmp    f6 <main+0xf6>
      printf(1, "zombie!\n");
  e4:	83 ec 08             	sub    $0x8,%esp
  e7:	68 3a 09 00 00       	push   $0x93a
  ec:	6a 01                	push   $0x1
  ee:	e8 18 04 00 00       	call   50b <printf>
  f3:	83 c4 10             	add    $0x10,%esp
//      Sched();

      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  f6:	e8 73 02 00 00       	call   36e <wait>
  fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 102:	78 08                	js     10c <main+0x10c>
 104:	8b 45 f0             	mov    -0x10(%ebp),%eax
 107:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 10a:	75 d8                	jne    e4 <main+0xe4>
      printf(1, "zombie!\n");
  }
 10c:	e9 56 ff ff ff       	jmp    67 <main+0x67>

00000111 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 111:	55                   	push   %ebp
 112:	89 e5                	mov    %esp,%ebp
 114:	57                   	push   %edi
 115:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 116:	8b 4d 08             	mov    0x8(%ebp),%ecx
 119:	8b 55 10             	mov    0x10(%ebp),%edx
 11c:	8b 45 0c             	mov    0xc(%ebp),%eax
 11f:	89 cb                	mov    %ecx,%ebx
 121:	89 df                	mov    %ebx,%edi
 123:	89 d1                	mov    %edx,%ecx
 125:	fc                   	cld    
 126:	f3 aa                	rep stos %al,%es:(%edi)
 128:	89 ca                	mov    %ecx,%edx
 12a:	89 fb                	mov    %edi,%ebx
 12c:	89 5d 08             	mov    %ebx,0x8(%ebp)
 12f:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 132:	5b                   	pop    %ebx
 133:	5f                   	pop    %edi
 134:	5d                   	pop    %ebp
 135:	c3                   	ret    

00000136 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 136:	55                   	push   %ebp
 137:	89 e5                	mov    %esp,%ebp
 139:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 13c:	8b 45 08             	mov    0x8(%ebp),%eax
 13f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 142:	90                   	nop
 143:	8b 45 08             	mov    0x8(%ebp),%eax
 146:	8d 50 01             	lea    0x1(%eax),%edx
 149:	89 55 08             	mov    %edx,0x8(%ebp)
 14c:	8b 55 0c             	mov    0xc(%ebp),%edx
 14f:	8d 4a 01             	lea    0x1(%edx),%ecx
 152:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 155:	0f b6 12             	movzbl (%edx),%edx
 158:	88 10                	mov    %dl,(%eax)
 15a:	0f b6 00             	movzbl (%eax),%eax
 15d:	84 c0                	test   %al,%al
 15f:	75 e2                	jne    143 <strcpy+0xd>
    ;
  return os;
 161:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 164:	c9                   	leave  
 165:	c3                   	ret    

00000166 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 166:	55                   	push   %ebp
 167:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 169:	eb 08                	jmp    173 <strcmp+0xd>
    p++, q++;
 16b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 173:	8b 45 08             	mov    0x8(%ebp),%eax
 176:	0f b6 00             	movzbl (%eax),%eax
 179:	84 c0                	test   %al,%al
 17b:	74 10                	je     18d <strcmp+0x27>
 17d:	8b 45 08             	mov    0x8(%ebp),%eax
 180:	0f b6 10             	movzbl (%eax),%edx
 183:	8b 45 0c             	mov    0xc(%ebp),%eax
 186:	0f b6 00             	movzbl (%eax),%eax
 189:	38 c2                	cmp    %al,%dl
 18b:	74 de                	je     16b <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 18d:	8b 45 08             	mov    0x8(%ebp),%eax
 190:	0f b6 00             	movzbl (%eax),%eax
 193:	0f b6 d0             	movzbl %al,%edx
 196:	8b 45 0c             	mov    0xc(%ebp),%eax
 199:	0f b6 00             	movzbl (%eax),%eax
 19c:	0f b6 c0             	movzbl %al,%eax
 19f:	29 c2                	sub    %eax,%edx
 1a1:	89 d0                	mov    %edx,%eax
}
 1a3:	5d                   	pop    %ebp
 1a4:	c3                   	ret    

000001a5 <strlen>:

uint
strlen(char *s)
{
 1a5:	55                   	push   %ebp
 1a6:	89 e5                	mov    %esp,%ebp
 1a8:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1b2:	eb 04                	jmp    1b8 <strlen+0x13>
 1b4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1b8:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1bb:	8b 45 08             	mov    0x8(%ebp),%eax
 1be:	01 d0                	add    %edx,%eax
 1c0:	0f b6 00             	movzbl (%eax),%eax
 1c3:	84 c0                	test   %al,%al
 1c5:	75 ed                	jne    1b4 <strlen+0xf>
    ;
  return n;
 1c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1ca:	c9                   	leave  
 1cb:	c3                   	ret    

000001cc <memset>:

void*
memset(void *dst, int c, uint n)
{
 1cc:	55                   	push   %ebp
 1cd:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1cf:	8b 45 10             	mov    0x10(%ebp),%eax
 1d2:	50                   	push   %eax
 1d3:	ff 75 0c             	pushl  0xc(%ebp)
 1d6:	ff 75 08             	pushl  0x8(%ebp)
 1d9:	e8 33 ff ff ff       	call   111 <stosb>
 1de:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1e1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e4:	c9                   	leave  
 1e5:	c3                   	ret    

000001e6 <strchr>:

char*
strchr(const char *s, char c)
{
 1e6:	55                   	push   %ebp
 1e7:	89 e5                	mov    %esp,%ebp
 1e9:	83 ec 04             	sub    $0x4,%esp
 1ec:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ef:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1f2:	eb 14                	jmp    208 <strchr+0x22>
    if(*s == c)
 1f4:	8b 45 08             	mov    0x8(%ebp),%eax
 1f7:	0f b6 00             	movzbl (%eax),%eax
 1fa:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1fd:	75 05                	jne    204 <strchr+0x1e>
      return (char*)s;
 1ff:	8b 45 08             	mov    0x8(%ebp),%eax
 202:	eb 13                	jmp    217 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 204:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 208:	8b 45 08             	mov    0x8(%ebp),%eax
 20b:	0f b6 00             	movzbl (%eax),%eax
 20e:	84 c0                	test   %al,%al
 210:	75 e2                	jne    1f4 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 212:	b8 00 00 00 00       	mov    $0x0,%eax
}
 217:	c9                   	leave  
 218:	c3                   	ret    

00000219 <gets>:

char*
gets(char *buf, int max)
{
 219:	55                   	push   %ebp
 21a:	89 e5                	mov    %esp,%ebp
 21c:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 21f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 226:	eb 44                	jmp    26c <gets+0x53>
    cc = read(0, &c, 1);
 228:	83 ec 04             	sub    $0x4,%esp
 22b:	6a 01                	push   $0x1
 22d:	8d 45 ef             	lea    -0x11(%ebp),%eax
 230:	50                   	push   %eax
 231:	6a 00                	push   $0x0
 233:	e8 46 01 00 00       	call   37e <read>
 238:	83 c4 10             	add    $0x10,%esp
 23b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 23e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 242:	7f 02                	jg     246 <gets+0x2d>
      break;
 244:	eb 31                	jmp    277 <gets+0x5e>
    buf[i++] = c;
 246:	8b 45 f4             	mov    -0xc(%ebp),%eax
 249:	8d 50 01             	lea    0x1(%eax),%edx
 24c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 24f:	89 c2                	mov    %eax,%edx
 251:	8b 45 08             	mov    0x8(%ebp),%eax
 254:	01 c2                	add    %eax,%edx
 256:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 25a:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 25c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 260:	3c 0a                	cmp    $0xa,%al
 262:	74 13                	je     277 <gets+0x5e>
 264:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 268:	3c 0d                	cmp    $0xd,%al
 26a:	74 0b                	je     277 <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 26c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 26f:	83 c0 01             	add    $0x1,%eax
 272:	3b 45 0c             	cmp    0xc(%ebp),%eax
 275:	7c b1                	jl     228 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 277:	8b 55 f4             	mov    -0xc(%ebp),%edx
 27a:	8b 45 08             	mov    0x8(%ebp),%eax
 27d:	01 d0                	add    %edx,%eax
 27f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 282:	8b 45 08             	mov    0x8(%ebp),%eax
}
 285:	c9                   	leave  
 286:	c3                   	ret    

00000287 <stat>:

int
stat(char *n, struct stat *st)
{
 287:	55                   	push   %ebp
 288:	89 e5                	mov    %esp,%ebp
 28a:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 28d:	83 ec 08             	sub    $0x8,%esp
 290:	6a 00                	push   $0x0
 292:	ff 75 08             	pushl  0x8(%ebp)
 295:	e8 0c 01 00 00       	call   3a6 <open>
 29a:	83 c4 10             	add    $0x10,%esp
 29d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2a4:	79 07                	jns    2ad <stat+0x26>
    return -1;
 2a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2ab:	eb 25                	jmp    2d2 <stat+0x4b>
  r = fstat(fd, st);
 2ad:	83 ec 08             	sub    $0x8,%esp
 2b0:	ff 75 0c             	pushl  0xc(%ebp)
 2b3:	ff 75 f4             	pushl  -0xc(%ebp)
 2b6:	e8 03 01 00 00       	call   3be <fstat>
 2bb:	83 c4 10             	add    $0x10,%esp
 2be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2c1:	83 ec 0c             	sub    $0xc,%esp
 2c4:	ff 75 f4             	pushl  -0xc(%ebp)
 2c7:	e8 c2 00 00 00       	call   38e <close>
 2cc:	83 c4 10             	add    $0x10,%esp
  return r;
 2cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2d2:	c9                   	leave  
 2d3:	c3                   	ret    

000002d4 <atoi>:

int
atoi(const char *s)
{
 2d4:	55                   	push   %ebp
 2d5:	89 e5                	mov    %esp,%ebp
 2d7:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2e1:	eb 25                	jmp    308 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2e6:	89 d0                	mov    %edx,%eax
 2e8:	c1 e0 02             	shl    $0x2,%eax
 2eb:	01 d0                	add    %edx,%eax
 2ed:	01 c0                	add    %eax,%eax
 2ef:	89 c1                	mov    %eax,%ecx
 2f1:	8b 45 08             	mov    0x8(%ebp),%eax
 2f4:	8d 50 01             	lea    0x1(%eax),%edx
 2f7:	89 55 08             	mov    %edx,0x8(%ebp)
 2fa:	0f b6 00             	movzbl (%eax),%eax
 2fd:	0f be c0             	movsbl %al,%eax
 300:	01 c8                	add    %ecx,%eax
 302:	83 e8 30             	sub    $0x30,%eax
 305:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 308:	8b 45 08             	mov    0x8(%ebp),%eax
 30b:	0f b6 00             	movzbl (%eax),%eax
 30e:	3c 2f                	cmp    $0x2f,%al
 310:	7e 0a                	jle    31c <atoi+0x48>
 312:	8b 45 08             	mov    0x8(%ebp),%eax
 315:	0f b6 00             	movzbl (%eax),%eax
 318:	3c 39                	cmp    $0x39,%al
 31a:	7e c7                	jle    2e3 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 31c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 31f:	c9                   	leave  
 320:	c3                   	ret    

00000321 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 321:	55                   	push   %ebp
 322:	89 e5                	mov    %esp,%ebp
 324:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 327:	8b 45 08             	mov    0x8(%ebp),%eax
 32a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 32d:	8b 45 0c             	mov    0xc(%ebp),%eax
 330:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 333:	eb 17                	jmp    34c <memmove+0x2b>
    *dst++ = *src++;
 335:	8b 45 fc             	mov    -0x4(%ebp),%eax
 338:	8d 50 01             	lea    0x1(%eax),%edx
 33b:	89 55 fc             	mov    %edx,-0x4(%ebp)
 33e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 341:	8d 4a 01             	lea    0x1(%edx),%ecx
 344:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 347:	0f b6 12             	movzbl (%edx),%edx
 34a:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 34c:	8b 45 10             	mov    0x10(%ebp),%eax
 34f:	8d 50 ff             	lea    -0x1(%eax),%edx
 352:	89 55 10             	mov    %edx,0x10(%ebp)
 355:	85 c0                	test   %eax,%eax
 357:	7f dc                	jg     335 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 359:	8b 45 08             	mov    0x8(%ebp),%eax
}
 35c:	c9                   	leave  
 35d:	c3                   	ret    

0000035e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 35e:	b8 01 00 00 00       	mov    $0x1,%eax
 363:	cd 40                	int    $0x40
 365:	c3                   	ret    

00000366 <exit>:
SYSCALL(exit)
 366:	b8 02 00 00 00       	mov    $0x2,%eax
 36b:	cd 40                	int    $0x40
 36d:	c3                   	ret    

0000036e <wait>:
SYSCALL(wait)
 36e:	b8 03 00 00 00       	mov    $0x3,%eax
 373:	cd 40                	int    $0x40
 375:	c3                   	ret    

00000376 <pipe>:
SYSCALL(pipe)
 376:	b8 04 00 00 00       	mov    $0x4,%eax
 37b:	cd 40                	int    $0x40
 37d:	c3                   	ret    

0000037e <read>:
SYSCALL(read)
 37e:	b8 05 00 00 00       	mov    $0x5,%eax
 383:	cd 40                	int    $0x40
 385:	c3                   	ret    

00000386 <write>:
SYSCALL(write)
 386:	b8 10 00 00 00       	mov    $0x10,%eax
 38b:	cd 40                	int    $0x40
 38d:	c3                   	ret    

0000038e <close>:
SYSCALL(close)
 38e:	b8 15 00 00 00       	mov    $0x15,%eax
 393:	cd 40                	int    $0x40
 395:	c3                   	ret    

00000396 <kill>:
SYSCALL(kill)
 396:	b8 06 00 00 00       	mov    $0x6,%eax
 39b:	cd 40                	int    $0x40
 39d:	c3                   	ret    

0000039e <exec>:
SYSCALL(exec)
 39e:	b8 07 00 00 00       	mov    $0x7,%eax
 3a3:	cd 40                	int    $0x40
 3a5:	c3                   	ret    

000003a6 <open>:
SYSCALL(open)
 3a6:	b8 0f 00 00 00       	mov    $0xf,%eax
 3ab:	cd 40                	int    $0x40
 3ad:	c3                   	ret    

000003ae <mknod>:
SYSCALL(mknod)
 3ae:	b8 11 00 00 00       	mov    $0x11,%eax
 3b3:	cd 40                	int    $0x40
 3b5:	c3                   	ret    

000003b6 <unlink>:
SYSCALL(unlink)
 3b6:	b8 12 00 00 00       	mov    $0x12,%eax
 3bb:	cd 40                	int    $0x40
 3bd:	c3                   	ret    

000003be <fstat>:
SYSCALL(fstat)
 3be:	b8 08 00 00 00       	mov    $0x8,%eax
 3c3:	cd 40                	int    $0x40
 3c5:	c3                   	ret    

000003c6 <link>:
SYSCALL(link)
 3c6:	b8 13 00 00 00       	mov    $0x13,%eax
 3cb:	cd 40                	int    $0x40
 3cd:	c3                   	ret    

000003ce <mkdir>:
SYSCALL(mkdir)
 3ce:	b8 14 00 00 00       	mov    $0x14,%eax
 3d3:	cd 40                	int    $0x40
 3d5:	c3                   	ret    

000003d6 <chdir>:
SYSCALL(chdir)
 3d6:	b8 09 00 00 00       	mov    $0x9,%eax
 3db:	cd 40                	int    $0x40
 3dd:	c3                   	ret    

000003de <dup>:
SYSCALL(dup)
 3de:	b8 0a 00 00 00       	mov    $0xa,%eax
 3e3:	cd 40                	int    $0x40
 3e5:	c3                   	ret    

000003e6 <getpid>:
SYSCALL(getpid)
 3e6:	b8 0b 00 00 00       	mov    $0xb,%eax
 3eb:	cd 40                	int    $0x40
 3ed:	c3                   	ret    

000003ee <sbrk>:
SYSCALL(sbrk)
 3ee:	b8 0c 00 00 00       	mov    $0xc,%eax
 3f3:	cd 40                	int    $0x40
 3f5:	c3                   	ret    

000003f6 <sleep>:
SYSCALL(sleep)
 3f6:	b8 0d 00 00 00       	mov    $0xd,%eax
 3fb:	cd 40                	int    $0x40
 3fd:	c3                   	ret    

000003fe <uptime>:
SYSCALL(uptime)
 3fe:	b8 0e 00 00 00       	mov    $0xe,%eax
 403:	cd 40                	int    $0x40
 405:	c3                   	ret    

00000406 <createTask>:

SYSCALL(createTask)
 406:	b8 16 00 00 00       	mov    $0x16,%eax
 40b:	cd 40                	int    $0x40
 40d:	c3                   	ret    

0000040e <startTask>:
SYSCALL(startTask)
 40e:	b8 17 00 00 00       	mov    $0x17,%eax
 413:	cd 40                	int    $0x40
 415:	c3                   	ret    

00000416 <waitTask>:
SYSCALL(waitTask)
 416:	b8 18 00 00 00       	mov    $0x18,%eax
 41b:	cd 40                	int    $0x40
 41d:	c3                   	ret    

0000041e <Sched>:
SYSCALL(Sched)
 41e:	b8 19 00 00 00       	mov    $0x19,%eax
 423:	cd 40                	int    $0x40
 425:	c3                   	ret    

00000426 <chmod>:

SYSCALL(chmod)
 426:	b8 1a 00 00 00       	mov    $0x1a,%eax
 42b:	cd 40                	int    $0x40
 42d:	c3                   	ret    

0000042e <candprocs>:
SYSCALL(candprocs)
 42e:	b8 1b 00 00 00       	mov    $0x1b,%eax
 433:	cd 40                	int    $0x40
 435:	c3                   	ret    

00000436 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 436:	55                   	push   %ebp
 437:	89 e5                	mov    %esp,%ebp
 439:	83 ec 18             	sub    $0x18,%esp
 43c:	8b 45 0c             	mov    0xc(%ebp),%eax
 43f:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 442:	83 ec 04             	sub    $0x4,%esp
 445:	6a 01                	push   $0x1
 447:	8d 45 f4             	lea    -0xc(%ebp),%eax
 44a:	50                   	push   %eax
 44b:	ff 75 08             	pushl  0x8(%ebp)
 44e:	e8 33 ff ff ff       	call   386 <write>
 453:	83 c4 10             	add    $0x10,%esp
}
 456:	c9                   	leave  
 457:	c3                   	ret    

00000458 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 458:	55                   	push   %ebp
 459:	89 e5                	mov    %esp,%ebp
 45b:	53                   	push   %ebx
 45c:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 45f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 466:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 46a:	74 17                	je     483 <printint+0x2b>
 46c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 470:	79 11                	jns    483 <printint+0x2b>
    neg = 1;
 472:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 479:	8b 45 0c             	mov    0xc(%ebp),%eax
 47c:	f7 d8                	neg    %eax
 47e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 481:	eb 06                	jmp    489 <printint+0x31>
  } else {
    x = xx;
 483:	8b 45 0c             	mov    0xc(%ebp),%eax
 486:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 489:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 490:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 493:	8d 41 01             	lea    0x1(%ecx),%eax
 496:	89 45 f4             	mov    %eax,-0xc(%ebp)
 499:	8b 5d 10             	mov    0x10(%ebp),%ebx
 49c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 49f:	ba 00 00 00 00       	mov    $0x0,%edx
 4a4:	f7 f3                	div    %ebx
 4a6:	89 d0                	mov    %edx,%eax
 4a8:	0f b6 80 9c 0b 00 00 	movzbl 0xb9c(%eax),%eax
 4af:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4b3:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4b9:	ba 00 00 00 00       	mov    $0x0,%edx
 4be:	f7 f3                	div    %ebx
 4c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4c3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4c7:	75 c7                	jne    490 <printint+0x38>
  if(neg)
 4c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4cd:	74 0e                	je     4dd <printint+0x85>
    buf[i++] = '-';
 4cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4d2:	8d 50 01             	lea    0x1(%eax),%edx
 4d5:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4d8:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4dd:	eb 1d                	jmp    4fc <printint+0xa4>
    putc(fd, buf[i]);
 4df:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4e5:	01 d0                	add    %edx,%eax
 4e7:	0f b6 00             	movzbl (%eax),%eax
 4ea:	0f be c0             	movsbl %al,%eax
 4ed:	83 ec 08             	sub    $0x8,%esp
 4f0:	50                   	push   %eax
 4f1:	ff 75 08             	pushl  0x8(%ebp)
 4f4:	e8 3d ff ff ff       	call   436 <putc>
 4f9:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4fc:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 500:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 504:	79 d9                	jns    4df <printint+0x87>
    putc(fd, buf[i]);
}
 506:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 509:	c9                   	leave  
 50a:	c3                   	ret    

0000050b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 50b:	55                   	push   %ebp
 50c:	89 e5                	mov    %esp,%ebp
 50e:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 511:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 518:	8d 45 0c             	lea    0xc(%ebp),%eax
 51b:	83 c0 04             	add    $0x4,%eax
 51e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 521:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 528:	e9 59 01 00 00       	jmp    686 <printf+0x17b>
    c = fmt[i] & 0xff;
 52d:	8b 55 0c             	mov    0xc(%ebp),%edx
 530:	8b 45 f0             	mov    -0x10(%ebp),%eax
 533:	01 d0                	add    %edx,%eax
 535:	0f b6 00             	movzbl (%eax),%eax
 538:	0f be c0             	movsbl %al,%eax
 53b:	25 ff 00 00 00       	and    $0xff,%eax
 540:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 543:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 547:	75 2c                	jne    575 <printf+0x6a>
      if(c == '%'){
 549:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 54d:	75 0c                	jne    55b <printf+0x50>
        state = '%';
 54f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 556:	e9 27 01 00 00       	jmp    682 <printf+0x177>
      } else {
        putc(fd, c);
 55b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 55e:	0f be c0             	movsbl %al,%eax
 561:	83 ec 08             	sub    $0x8,%esp
 564:	50                   	push   %eax
 565:	ff 75 08             	pushl  0x8(%ebp)
 568:	e8 c9 fe ff ff       	call   436 <putc>
 56d:	83 c4 10             	add    $0x10,%esp
 570:	e9 0d 01 00 00       	jmp    682 <printf+0x177>
      }
    } else if(state == '%'){
 575:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 579:	0f 85 03 01 00 00    	jne    682 <printf+0x177>
      if(c == 'd'){
 57f:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 583:	75 1e                	jne    5a3 <printf+0x98>
        printint(fd, *ap, 10, 1);
 585:	8b 45 e8             	mov    -0x18(%ebp),%eax
 588:	8b 00                	mov    (%eax),%eax
 58a:	6a 01                	push   $0x1
 58c:	6a 0a                	push   $0xa
 58e:	50                   	push   %eax
 58f:	ff 75 08             	pushl  0x8(%ebp)
 592:	e8 c1 fe ff ff       	call   458 <printint>
 597:	83 c4 10             	add    $0x10,%esp
        ap++;
 59a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 59e:	e9 d8 00 00 00       	jmp    67b <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5a3:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5a7:	74 06                	je     5af <printf+0xa4>
 5a9:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5ad:	75 1e                	jne    5cd <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5af:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b2:	8b 00                	mov    (%eax),%eax
 5b4:	6a 00                	push   $0x0
 5b6:	6a 10                	push   $0x10
 5b8:	50                   	push   %eax
 5b9:	ff 75 08             	pushl  0x8(%ebp)
 5bc:	e8 97 fe ff ff       	call   458 <printint>
 5c1:	83 c4 10             	add    $0x10,%esp
        ap++;
 5c4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5c8:	e9 ae 00 00 00       	jmp    67b <printf+0x170>
      } else if(c == 's'){
 5cd:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5d1:	75 43                	jne    616 <printf+0x10b>
        s = (char*)*ap;
 5d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5d6:	8b 00                	mov    (%eax),%eax
 5d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5db:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5e3:	75 07                	jne    5ec <printf+0xe1>
          s = "(null)";
 5e5:	c7 45 f4 43 09 00 00 	movl   $0x943,-0xc(%ebp)
        while(*s != 0){
 5ec:	eb 1c                	jmp    60a <printf+0xff>
          putc(fd, *s);
 5ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5f1:	0f b6 00             	movzbl (%eax),%eax
 5f4:	0f be c0             	movsbl %al,%eax
 5f7:	83 ec 08             	sub    $0x8,%esp
 5fa:	50                   	push   %eax
 5fb:	ff 75 08             	pushl  0x8(%ebp)
 5fe:	e8 33 fe ff ff       	call   436 <putc>
 603:	83 c4 10             	add    $0x10,%esp
          s++;
 606:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 60a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 60d:	0f b6 00             	movzbl (%eax),%eax
 610:	84 c0                	test   %al,%al
 612:	75 da                	jne    5ee <printf+0xe3>
 614:	eb 65                	jmp    67b <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 616:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 61a:	75 1d                	jne    639 <printf+0x12e>
        putc(fd, *ap);
 61c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 61f:	8b 00                	mov    (%eax),%eax
 621:	0f be c0             	movsbl %al,%eax
 624:	83 ec 08             	sub    $0x8,%esp
 627:	50                   	push   %eax
 628:	ff 75 08             	pushl  0x8(%ebp)
 62b:	e8 06 fe ff ff       	call   436 <putc>
 630:	83 c4 10             	add    $0x10,%esp
        ap++;
 633:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 637:	eb 42                	jmp    67b <printf+0x170>
      } else if(c == '%'){
 639:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 63d:	75 17                	jne    656 <printf+0x14b>
        putc(fd, c);
 63f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 642:	0f be c0             	movsbl %al,%eax
 645:	83 ec 08             	sub    $0x8,%esp
 648:	50                   	push   %eax
 649:	ff 75 08             	pushl  0x8(%ebp)
 64c:	e8 e5 fd ff ff       	call   436 <putc>
 651:	83 c4 10             	add    $0x10,%esp
 654:	eb 25                	jmp    67b <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 656:	83 ec 08             	sub    $0x8,%esp
 659:	6a 25                	push   $0x25
 65b:	ff 75 08             	pushl  0x8(%ebp)
 65e:	e8 d3 fd ff ff       	call   436 <putc>
 663:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 666:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 669:	0f be c0             	movsbl %al,%eax
 66c:	83 ec 08             	sub    $0x8,%esp
 66f:	50                   	push   %eax
 670:	ff 75 08             	pushl  0x8(%ebp)
 673:	e8 be fd ff ff       	call   436 <putc>
 678:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 67b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 682:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 686:	8b 55 0c             	mov    0xc(%ebp),%edx
 689:	8b 45 f0             	mov    -0x10(%ebp),%eax
 68c:	01 d0                	add    %edx,%eax
 68e:	0f b6 00             	movzbl (%eax),%eax
 691:	84 c0                	test   %al,%al
 693:	0f 85 94 fe ff ff    	jne    52d <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 699:	c9                   	leave  
 69a:	c3                   	ret    

0000069b <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 69b:	55                   	push   %ebp
 69c:	89 e5                	mov    %esp,%ebp
 69e:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6a1:	8b 45 08             	mov    0x8(%ebp),%eax
 6a4:	83 e8 08             	sub    $0x8,%eax
 6a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6aa:	a1 b8 0b 00 00       	mov    0xbb8,%eax
 6af:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6b2:	eb 24                	jmp    6d8 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b7:	8b 00                	mov    (%eax),%eax
 6b9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6bc:	77 12                	ja     6d0 <free+0x35>
 6be:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6c4:	77 24                	ja     6ea <free+0x4f>
 6c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c9:	8b 00                	mov    (%eax),%eax
 6cb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ce:	77 1a                	ja     6ea <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d3:	8b 00                	mov    (%eax),%eax
 6d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6db:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6de:	76 d4                	jbe    6b4 <free+0x19>
 6e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e3:	8b 00                	mov    (%eax),%eax
 6e5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6e8:	76 ca                	jbe    6b4 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ed:	8b 40 04             	mov    0x4(%eax),%eax
 6f0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fa:	01 c2                	add    %eax,%edx
 6fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ff:	8b 00                	mov    (%eax),%eax
 701:	39 c2                	cmp    %eax,%edx
 703:	75 24                	jne    729 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 705:	8b 45 f8             	mov    -0x8(%ebp),%eax
 708:	8b 50 04             	mov    0x4(%eax),%edx
 70b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70e:	8b 00                	mov    (%eax),%eax
 710:	8b 40 04             	mov    0x4(%eax),%eax
 713:	01 c2                	add    %eax,%edx
 715:	8b 45 f8             	mov    -0x8(%ebp),%eax
 718:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 71b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71e:	8b 00                	mov    (%eax),%eax
 720:	8b 10                	mov    (%eax),%edx
 722:	8b 45 f8             	mov    -0x8(%ebp),%eax
 725:	89 10                	mov    %edx,(%eax)
 727:	eb 0a                	jmp    733 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 729:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72c:	8b 10                	mov    (%eax),%edx
 72e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 731:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 733:	8b 45 fc             	mov    -0x4(%ebp),%eax
 736:	8b 40 04             	mov    0x4(%eax),%eax
 739:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 740:	8b 45 fc             	mov    -0x4(%ebp),%eax
 743:	01 d0                	add    %edx,%eax
 745:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 748:	75 20                	jne    76a <free+0xcf>
    p->s.size += bp->s.size;
 74a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74d:	8b 50 04             	mov    0x4(%eax),%edx
 750:	8b 45 f8             	mov    -0x8(%ebp),%eax
 753:	8b 40 04             	mov    0x4(%eax),%eax
 756:	01 c2                	add    %eax,%edx
 758:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 75e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 761:	8b 10                	mov    (%eax),%edx
 763:	8b 45 fc             	mov    -0x4(%ebp),%eax
 766:	89 10                	mov    %edx,(%eax)
 768:	eb 08                	jmp    772 <free+0xd7>
  } else
    p->s.ptr = bp;
 76a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 770:	89 10                	mov    %edx,(%eax)
  freep = p;
 772:	8b 45 fc             	mov    -0x4(%ebp),%eax
 775:	a3 b8 0b 00 00       	mov    %eax,0xbb8
}
 77a:	c9                   	leave  
 77b:	c3                   	ret    

0000077c <morecore>:

static Header*
morecore(uint nu)
{
 77c:	55                   	push   %ebp
 77d:	89 e5                	mov    %esp,%ebp
 77f:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 782:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 789:	77 07                	ja     792 <morecore+0x16>
    nu = 4096;
 78b:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 792:	8b 45 08             	mov    0x8(%ebp),%eax
 795:	c1 e0 03             	shl    $0x3,%eax
 798:	83 ec 0c             	sub    $0xc,%esp
 79b:	50                   	push   %eax
 79c:	e8 4d fc ff ff       	call   3ee <sbrk>
 7a1:	83 c4 10             	add    $0x10,%esp
 7a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7a7:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7ab:	75 07                	jne    7b4 <morecore+0x38>
    return 0;
 7ad:	b8 00 00 00 00       	mov    $0x0,%eax
 7b2:	eb 26                	jmp    7da <morecore+0x5e>
  hp = (Header*)p;
 7b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7bd:	8b 55 08             	mov    0x8(%ebp),%edx
 7c0:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c6:	83 c0 08             	add    $0x8,%eax
 7c9:	83 ec 0c             	sub    $0xc,%esp
 7cc:	50                   	push   %eax
 7cd:	e8 c9 fe ff ff       	call   69b <free>
 7d2:	83 c4 10             	add    $0x10,%esp
  return freep;
 7d5:	a1 b8 0b 00 00       	mov    0xbb8,%eax
}
 7da:	c9                   	leave  
 7db:	c3                   	ret    

000007dc <malloc>:

void*
malloc(uint nbytes)
{
 7dc:	55                   	push   %ebp
 7dd:	89 e5                	mov    %esp,%ebp
 7df:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7e2:	8b 45 08             	mov    0x8(%ebp),%eax
 7e5:	83 c0 07             	add    $0x7,%eax
 7e8:	c1 e8 03             	shr    $0x3,%eax
 7eb:	83 c0 01             	add    $0x1,%eax
 7ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7f1:	a1 b8 0b 00 00       	mov    0xbb8,%eax
 7f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7fd:	75 23                	jne    822 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7ff:	c7 45 f0 b0 0b 00 00 	movl   $0xbb0,-0x10(%ebp)
 806:	8b 45 f0             	mov    -0x10(%ebp),%eax
 809:	a3 b8 0b 00 00       	mov    %eax,0xbb8
 80e:	a1 b8 0b 00 00       	mov    0xbb8,%eax
 813:	a3 b0 0b 00 00       	mov    %eax,0xbb0
    base.s.size = 0;
 818:	c7 05 b4 0b 00 00 00 	movl   $0x0,0xbb4
 81f:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 822:	8b 45 f0             	mov    -0x10(%ebp),%eax
 825:	8b 00                	mov    (%eax),%eax
 827:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 82a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82d:	8b 40 04             	mov    0x4(%eax),%eax
 830:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 833:	72 4d                	jb     882 <malloc+0xa6>
      if(p->s.size == nunits)
 835:	8b 45 f4             	mov    -0xc(%ebp),%eax
 838:	8b 40 04             	mov    0x4(%eax),%eax
 83b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 83e:	75 0c                	jne    84c <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 840:	8b 45 f4             	mov    -0xc(%ebp),%eax
 843:	8b 10                	mov    (%eax),%edx
 845:	8b 45 f0             	mov    -0x10(%ebp),%eax
 848:	89 10                	mov    %edx,(%eax)
 84a:	eb 26                	jmp    872 <malloc+0x96>
      else {
        p->s.size -= nunits;
 84c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84f:	8b 40 04             	mov    0x4(%eax),%eax
 852:	2b 45 ec             	sub    -0x14(%ebp),%eax
 855:	89 c2                	mov    %eax,%edx
 857:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85a:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 85d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 860:	8b 40 04             	mov    0x4(%eax),%eax
 863:	c1 e0 03             	shl    $0x3,%eax
 866:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 869:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86c:	8b 55 ec             	mov    -0x14(%ebp),%edx
 86f:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 872:	8b 45 f0             	mov    -0x10(%ebp),%eax
 875:	a3 b8 0b 00 00       	mov    %eax,0xbb8
      return (void*)(p + 1);
 87a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87d:	83 c0 08             	add    $0x8,%eax
 880:	eb 3b                	jmp    8bd <malloc+0xe1>
    }
    if(p == freep)
 882:	a1 b8 0b 00 00       	mov    0xbb8,%eax
 887:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 88a:	75 1e                	jne    8aa <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 88c:	83 ec 0c             	sub    $0xc,%esp
 88f:	ff 75 ec             	pushl  -0x14(%ebp)
 892:	e8 e5 fe ff ff       	call   77c <morecore>
 897:	83 c4 10             	add    $0x10,%esp
 89a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 89d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8a1:	75 07                	jne    8aa <malloc+0xce>
        return 0;
 8a3:	b8 00 00 00 00       	mov    $0x0,%eax
 8a8:	eb 13                	jmp    8bd <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b3:	8b 00                	mov    (%eax),%eax
 8b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8b8:	e9 6d ff ff ff       	jmp    82a <malloc+0x4e>
}
 8bd:	c9                   	leave  
 8be:	c3                   	ret    

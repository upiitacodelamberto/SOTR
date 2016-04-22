
_chmod:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc,char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	83 ec 30             	sub    $0x30,%esp
  12:	89 cb                	mov    %ecx,%ebx
  if(argc<3)
  14:	83 3b 02             	cmpl   $0x2,(%ebx)
  17:	7f 05                	jg     1e <main+0x1e>
    exit();
  19:	e8 82 03 00 00       	call   3a0 <exit>

  int fd;
  struct stat st;
  char *path=argv[2];
  1e:	8b 43 04             	mov    0x4(%ebx),%eax
  21:	8b 40 08             	mov    0x8(%eax),%eax
  24:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((fd=open(path,0))<0){
  27:	83 ec 08             	sub    $0x8,%esp
  2a:	6a 00                	push   $0x0
  2c:	ff 75 f4             	pushl  -0xc(%ebp)
  2f:	e8 ac 03 00 00       	call   3e0 <open>
  34:	83 c4 10             	add    $0x10,%esp
  37:	89 45 f0             	mov    %eax,-0x10(%ebp)
  3a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  3e:	79 1a                	jns    5a <main+0x5a>
    printf(2,"chmod: cannot open %s\n",path);
  40:	83 ec 04             	sub    $0x4,%esp
  43:	ff 75 f4             	pushl  -0xc(%ebp)
  46:	68 fc 08 00 00       	push   $0x8fc
  4b:	6a 02                	push   $0x2
  4d:	e8 f3 04 00 00       	call   545 <printf>
  52:	83 c4 10             	add    $0x10,%esp
    exit();
  55:	e8 46 03 00 00       	call   3a0 <exit>
  }

  if(fstat(fd,&st)<0){
  5a:	83 ec 08             	sub    $0x8,%esp
  5d:	8d 45 d0             	lea    -0x30(%ebp),%eax
  60:	50                   	push   %eax
  61:	ff 75 f0             	pushl  -0x10(%ebp)
  64:	e8 8f 03 00 00       	call   3f8 <fstat>
  69:	83 c4 10             	add    $0x10,%esp
  6c:	85 c0                	test   %eax,%eax
  6e:	79 28                	jns    98 <main+0x98>
    printf(2,"chmod: cannot stat %s\n",path);
  70:	83 ec 04             	sub    $0x4,%esp
  73:	ff 75 f4             	pushl  -0xc(%ebp)
  76:	68 13 09 00 00       	push   $0x913
  7b:	6a 02                	push   $0x2
  7d:	e8 c3 04 00 00       	call   545 <printf>
  82:	83 c4 10             	add    $0x10,%esp
    close(fd);
  85:	83 ec 0c             	sub    $0xc,%esp
  88:	ff 75 f0             	pushl  -0x10(%ebp)
  8b:	e8 38 03 00 00       	call   3c8 <close>
  90:	83 c4 10             	add    $0x10,%esp
    exit();
  93:	e8 08 03 00 00       	call   3a0 <exit>
  }

  int mode=st.mode;
  98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  9b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  close(fd);
  9e:	83 ec 0c             	sub    $0xc,%esp
  a1:	ff 75 f0             	pushl  -0x10(%ebp)
  a4:	e8 1f 03 00 00       	call   3c8 <close>
  a9:	83 c4 10             	add    $0x10,%esp

  if(strcmp(argv[1],"-x")==0){
  ac:	8b 43 04             	mov    0x4(%ebx),%eax
  af:	83 c0 04             	add    $0x4,%eax
  b2:	8b 00                	mov    (%eax),%eax
  b4:	83 ec 08             	sub    $0x8,%esp
  b7:	68 2a 09 00 00       	push   $0x92a
  bc:	50                   	push   %eax
  bd:	e8 de 00 00 00       	call   1a0 <strcmp>
  c2:	83 c4 10             	add    $0x10,%esp
  c5:	85 c0                	test   %eax,%eax
  c7:	75 36                	jne    ff <main+0xff>
printf(1,"path_-x:%s, mode=%x,0x100^mode=%x\n",path,mode,0x100^mode);
  c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  cc:	80 f4 01             	xor    $0x1,%ah
  cf:	83 ec 0c             	sub    $0xc,%esp
  d2:	50                   	push   %eax
  d3:	ff 75 ec             	pushl  -0x14(%ebp)
  d6:	ff 75 f4             	pushl  -0xc(%ebp)
  d9:	68 30 09 00 00       	push   $0x930
  de:	6a 01                	push   $0x1
  e0:	e8 60 04 00 00       	call   545 <printf>
  e5:	83 c4 20             	add    $0x20,%esp
    chmod(path,0x100^mode);
  e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  eb:	80 f4 01             	xor    $0x1,%ah
  ee:	83 ec 08             	sub    $0x8,%esp
  f1:	50                   	push   %eax
  f2:	ff 75 f4             	pushl  -0xc(%ebp)
  f5:	e8 66 03 00 00       	call   460 <chmod>
  fa:	83 c4 10             	add    $0x10,%esp
  fd:	eb 47                	jmp    146 <main+0x146>
  }else if(strcmp(argv[1],"+x")==0){
  ff:	8b 43 04             	mov    0x4(%ebx),%eax
 102:	83 c0 04             	add    $0x4,%eax
 105:	8b 00                	mov    (%eax),%eax
 107:	83 ec 08             	sub    $0x8,%esp
 10a:	68 53 09 00 00       	push   $0x953
 10f:	50                   	push   %eax
 110:	e8 8b 00 00 00       	call   1a0 <strcmp>
 115:	83 c4 10             	add    $0x10,%esp
 118:	85 c0                	test   %eax,%eax
 11a:	75 2a                	jne    146 <main+0x146>
printf(1,"path_+x:%s\n",path);
 11c:	83 ec 04             	sub    $0x4,%esp
 11f:	ff 75 f4             	pushl  -0xc(%ebp)
 122:	68 56 09 00 00       	push   $0x956
 127:	6a 01                	push   $0x1
 129:	e8 17 04 00 00       	call   545 <printf>
 12e:	83 c4 10             	add    $0x10,%esp
    chmod(path,0x100^mode);
 131:	8b 45 ec             	mov    -0x14(%ebp),%eax
 134:	80 f4 01             	xor    $0x1,%ah
 137:	83 ec 08             	sub    $0x8,%esp
 13a:	50                   	push   %eax
 13b:	ff 75 f4             	pushl  -0xc(%ebp)
 13e:	e8 1d 03 00 00       	call   460 <chmod>
 143:	83 c4 10             	add    $0x10,%esp
  }
  exit();
 146:	e8 55 02 00 00       	call   3a0 <exit>

0000014b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 14b:	55                   	push   %ebp
 14c:	89 e5                	mov    %esp,%ebp
 14e:	57                   	push   %edi
 14f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 150:	8b 4d 08             	mov    0x8(%ebp),%ecx
 153:	8b 55 10             	mov    0x10(%ebp),%edx
 156:	8b 45 0c             	mov    0xc(%ebp),%eax
 159:	89 cb                	mov    %ecx,%ebx
 15b:	89 df                	mov    %ebx,%edi
 15d:	89 d1                	mov    %edx,%ecx
 15f:	fc                   	cld    
 160:	f3 aa                	rep stos %al,%es:(%edi)
 162:	89 ca                	mov    %ecx,%edx
 164:	89 fb                	mov    %edi,%ebx
 166:	89 5d 08             	mov    %ebx,0x8(%ebp)
 169:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 16c:	5b                   	pop    %ebx
 16d:	5f                   	pop    %edi
 16e:	5d                   	pop    %ebp
 16f:	c3                   	ret    

00000170 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 176:	8b 45 08             	mov    0x8(%ebp),%eax
 179:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 17c:	90                   	nop
 17d:	8b 45 08             	mov    0x8(%ebp),%eax
 180:	8d 50 01             	lea    0x1(%eax),%edx
 183:	89 55 08             	mov    %edx,0x8(%ebp)
 186:	8b 55 0c             	mov    0xc(%ebp),%edx
 189:	8d 4a 01             	lea    0x1(%edx),%ecx
 18c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 18f:	0f b6 12             	movzbl (%edx),%edx
 192:	88 10                	mov    %dl,(%eax)
 194:	0f b6 00             	movzbl (%eax),%eax
 197:	84 c0                	test   %al,%al
 199:	75 e2                	jne    17d <strcpy+0xd>
    ;
  return os;
 19b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 19e:	c9                   	leave  
 19f:	c3                   	ret    

000001a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1a3:	eb 08                	jmp    1ad <strcmp+0xd>
    p++, q++;
 1a5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1a9:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1ad:	8b 45 08             	mov    0x8(%ebp),%eax
 1b0:	0f b6 00             	movzbl (%eax),%eax
 1b3:	84 c0                	test   %al,%al
 1b5:	74 10                	je     1c7 <strcmp+0x27>
 1b7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ba:	0f b6 10             	movzbl (%eax),%edx
 1bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c0:	0f b6 00             	movzbl (%eax),%eax
 1c3:	38 c2                	cmp    %al,%dl
 1c5:	74 de                	je     1a5 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1c7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ca:	0f b6 00             	movzbl (%eax),%eax
 1cd:	0f b6 d0             	movzbl %al,%edx
 1d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d3:	0f b6 00             	movzbl (%eax),%eax
 1d6:	0f b6 c0             	movzbl %al,%eax
 1d9:	29 c2                	sub    %eax,%edx
 1db:	89 d0                	mov    %edx,%eax
}
 1dd:	5d                   	pop    %ebp
 1de:	c3                   	ret    

000001df <strlen>:

uint
strlen(char *s)
{
 1df:	55                   	push   %ebp
 1e0:	89 e5                	mov    %esp,%ebp
 1e2:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1ec:	eb 04                	jmp    1f2 <strlen+0x13>
 1ee:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1f2:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1f5:	8b 45 08             	mov    0x8(%ebp),%eax
 1f8:	01 d0                	add    %edx,%eax
 1fa:	0f b6 00             	movzbl (%eax),%eax
 1fd:	84 c0                	test   %al,%al
 1ff:	75 ed                	jne    1ee <strlen+0xf>
    ;
  return n;
 201:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 204:	c9                   	leave  
 205:	c3                   	ret    

00000206 <memset>:

void*
memset(void *dst, int c, uint n)
{
 206:	55                   	push   %ebp
 207:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 209:	8b 45 10             	mov    0x10(%ebp),%eax
 20c:	50                   	push   %eax
 20d:	ff 75 0c             	pushl  0xc(%ebp)
 210:	ff 75 08             	pushl  0x8(%ebp)
 213:	e8 33 ff ff ff       	call   14b <stosb>
 218:	83 c4 0c             	add    $0xc,%esp
  return dst;
 21b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 21e:	c9                   	leave  
 21f:	c3                   	ret    

00000220 <strchr>:

char*
strchr(const char *s, char c)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	83 ec 04             	sub    $0x4,%esp
 226:	8b 45 0c             	mov    0xc(%ebp),%eax
 229:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 22c:	eb 14                	jmp    242 <strchr+0x22>
    if(*s == c)
 22e:	8b 45 08             	mov    0x8(%ebp),%eax
 231:	0f b6 00             	movzbl (%eax),%eax
 234:	3a 45 fc             	cmp    -0x4(%ebp),%al
 237:	75 05                	jne    23e <strchr+0x1e>
      return (char*)s;
 239:	8b 45 08             	mov    0x8(%ebp),%eax
 23c:	eb 13                	jmp    251 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 23e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 242:	8b 45 08             	mov    0x8(%ebp),%eax
 245:	0f b6 00             	movzbl (%eax),%eax
 248:	84 c0                	test   %al,%al
 24a:	75 e2                	jne    22e <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 24c:	b8 00 00 00 00       	mov    $0x0,%eax
}
 251:	c9                   	leave  
 252:	c3                   	ret    

00000253 <gets>:

char*
gets(char *buf, int max)
{
 253:	55                   	push   %ebp
 254:	89 e5                	mov    %esp,%ebp
 256:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 259:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 260:	eb 44                	jmp    2a6 <gets+0x53>
    cc = read(0, &c, 1);
 262:	83 ec 04             	sub    $0x4,%esp
 265:	6a 01                	push   $0x1
 267:	8d 45 ef             	lea    -0x11(%ebp),%eax
 26a:	50                   	push   %eax
 26b:	6a 00                	push   $0x0
 26d:	e8 46 01 00 00       	call   3b8 <read>
 272:	83 c4 10             	add    $0x10,%esp
 275:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 278:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 27c:	7f 02                	jg     280 <gets+0x2d>
      break;
 27e:	eb 31                	jmp    2b1 <gets+0x5e>
    buf[i++] = c;
 280:	8b 45 f4             	mov    -0xc(%ebp),%eax
 283:	8d 50 01             	lea    0x1(%eax),%edx
 286:	89 55 f4             	mov    %edx,-0xc(%ebp)
 289:	89 c2                	mov    %eax,%edx
 28b:	8b 45 08             	mov    0x8(%ebp),%eax
 28e:	01 c2                	add    %eax,%edx
 290:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 294:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 296:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 29a:	3c 0a                	cmp    $0xa,%al
 29c:	74 13                	je     2b1 <gets+0x5e>
 29e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a2:	3c 0d                	cmp    $0xd,%al
 2a4:	74 0b                	je     2b1 <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2a9:	83 c0 01             	add    $0x1,%eax
 2ac:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2af:	7c b1                	jl     262 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2b4:	8b 45 08             	mov    0x8(%ebp),%eax
 2b7:	01 d0                	add    %edx,%eax
 2b9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2bf:	c9                   	leave  
 2c0:	c3                   	ret    

000002c1 <stat>:

int
stat(char *n, struct stat *st)
{
 2c1:	55                   	push   %ebp
 2c2:	89 e5                	mov    %esp,%ebp
 2c4:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c7:	83 ec 08             	sub    $0x8,%esp
 2ca:	6a 00                	push   $0x0
 2cc:	ff 75 08             	pushl  0x8(%ebp)
 2cf:	e8 0c 01 00 00       	call   3e0 <open>
 2d4:	83 c4 10             	add    $0x10,%esp
 2d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2de:	79 07                	jns    2e7 <stat+0x26>
    return -1;
 2e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2e5:	eb 25                	jmp    30c <stat+0x4b>
  r = fstat(fd, st);
 2e7:	83 ec 08             	sub    $0x8,%esp
 2ea:	ff 75 0c             	pushl  0xc(%ebp)
 2ed:	ff 75 f4             	pushl  -0xc(%ebp)
 2f0:	e8 03 01 00 00       	call   3f8 <fstat>
 2f5:	83 c4 10             	add    $0x10,%esp
 2f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2fb:	83 ec 0c             	sub    $0xc,%esp
 2fe:	ff 75 f4             	pushl  -0xc(%ebp)
 301:	e8 c2 00 00 00       	call   3c8 <close>
 306:	83 c4 10             	add    $0x10,%esp
  return r;
 309:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 30c:	c9                   	leave  
 30d:	c3                   	ret    

0000030e <atoi>:

int
atoi(const char *s)
{
 30e:	55                   	push   %ebp
 30f:	89 e5                	mov    %esp,%ebp
 311:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 314:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 31b:	eb 25                	jmp    342 <atoi+0x34>
    n = n*10 + *s++ - '0';
 31d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 320:	89 d0                	mov    %edx,%eax
 322:	c1 e0 02             	shl    $0x2,%eax
 325:	01 d0                	add    %edx,%eax
 327:	01 c0                	add    %eax,%eax
 329:	89 c1                	mov    %eax,%ecx
 32b:	8b 45 08             	mov    0x8(%ebp),%eax
 32e:	8d 50 01             	lea    0x1(%eax),%edx
 331:	89 55 08             	mov    %edx,0x8(%ebp)
 334:	0f b6 00             	movzbl (%eax),%eax
 337:	0f be c0             	movsbl %al,%eax
 33a:	01 c8                	add    %ecx,%eax
 33c:	83 e8 30             	sub    $0x30,%eax
 33f:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 342:	8b 45 08             	mov    0x8(%ebp),%eax
 345:	0f b6 00             	movzbl (%eax),%eax
 348:	3c 2f                	cmp    $0x2f,%al
 34a:	7e 0a                	jle    356 <atoi+0x48>
 34c:	8b 45 08             	mov    0x8(%ebp),%eax
 34f:	0f b6 00             	movzbl (%eax),%eax
 352:	3c 39                	cmp    $0x39,%al
 354:	7e c7                	jle    31d <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 356:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 359:	c9                   	leave  
 35a:	c3                   	ret    

0000035b <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 35b:	55                   	push   %ebp
 35c:	89 e5                	mov    %esp,%ebp
 35e:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 361:	8b 45 08             	mov    0x8(%ebp),%eax
 364:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 367:	8b 45 0c             	mov    0xc(%ebp),%eax
 36a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 36d:	eb 17                	jmp    386 <memmove+0x2b>
    *dst++ = *src++;
 36f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 372:	8d 50 01             	lea    0x1(%eax),%edx
 375:	89 55 fc             	mov    %edx,-0x4(%ebp)
 378:	8b 55 f8             	mov    -0x8(%ebp),%edx
 37b:	8d 4a 01             	lea    0x1(%edx),%ecx
 37e:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 381:	0f b6 12             	movzbl (%edx),%edx
 384:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 386:	8b 45 10             	mov    0x10(%ebp),%eax
 389:	8d 50 ff             	lea    -0x1(%eax),%edx
 38c:	89 55 10             	mov    %edx,0x10(%ebp)
 38f:	85 c0                	test   %eax,%eax
 391:	7f dc                	jg     36f <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 393:	8b 45 08             	mov    0x8(%ebp),%eax
}
 396:	c9                   	leave  
 397:	c3                   	ret    

00000398 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 398:	b8 01 00 00 00       	mov    $0x1,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <exit>:
SYSCALL(exit)
 3a0:	b8 02 00 00 00       	mov    $0x2,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <wait>:
SYSCALL(wait)
 3a8:	b8 03 00 00 00       	mov    $0x3,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <pipe>:
SYSCALL(pipe)
 3b0:	b8 04 00 00 00       	mov    $0x4,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <read>:
SYSCALL(read)
 3b8:	b8 05 00 00 00       	mov    $0x5,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <write>:
SYSCALL(write)
 3c0:	b8 10 00 00 00       	mov    $0x10,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <close>:
SYSCALL(close)
 3c8:	b8 15 00 00 00       	mov    $0x15,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <kill>:
SYSCALL(kill)
 3d0:	b8 06 00 00 00       	mov    $0x6,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <exec>:
SYSCALL(exec)
 3d8:	b8 07 00 00 00       	mov    $0x7,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <open>:
SYSCALL(open)
 3e0:	b8 0f 00 00 00       	mov    $0xf,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <mknod>:
SYSCALL(mknod)
 3e8:	b8 11 00 00 00       	mov    $0x11,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <unlink>:
SYSCALL(unlink)
 3f0:	b8 12 00 00 00       	mov    $0x12,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <fstat>:
SYSCALL(fstat)
 3f8:	b8 08 00 00 00       	mov    $0x8,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <link>:
SYSCALL(link)
 400:	b8 13 00 00 00       	mov    $0x13,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <mkdir>:
SYSCALL(mkdir)
 408:	b8 14 00 00 00       	mov    $0x14,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <chdir>:
SYSCALL(chdir)
 410:	b8 09 00 00 00       	mov    $0x9,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <dup>:
SYSCALL(dup)
 418:	b8 0a 00 00 00       	mov    $0xa,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <getpid>:
SYSCALL(getpid)
 420:	b8 0b 00 00 00       	mov    $0xb,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <sbrk>:
SYSCALL(sbrk)
 428:	b8 0c 00 00 00       	mov    $0xc,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <sleep>:
SYSCALL(sleep)
 430:	b8 0d 00 00 00       	mov    $0xd,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    

00000438 <uptime>:
SYSCALL(uptime)
 438:	b8 0e 00 00 00       	mov    $0xe,%eax
 43d:	cd 40                	int    $0x40
 43f:	c3                   	ret    

00000440 <createTask>:

SYSCALL(createTask)
 440:	b8 16 00 00 00       	mov    $0x16,%eax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret    

00000448 <startTask>:
SYSCALL(startTask)
 448:	b8 17 00 00 00       	mov    $0x17,%eax
 44d:	cd 40                	int    $0x40
 44f:	c3                   	ret    

00000450 <waitTask>:
SYSCALL(waitTask)
 450:	b8 18 00 00 00       	mov    $0x18,%eax
 455:	cd 40                	int    $0x40
 457:	c3                   	ret    

00000458 <Sched>:
SYSCALL(Sched)
 458:	b8 19 00 00 00       	mov    $0x19,%eax
 45d:	cd 40                	int    $0x40
 45f:	c3                   	ret    

00000460 <chmod>:

SYSCALL(chmod)
 460:	b8 1a 00 00 00       	mov    $0x1a,%eax
 465:	cd 40                	int    $0x40
 467:	c3                   	ret    

00000468 <candprocs>:
SYSCALL(candprocs)
 468:	b8 1b 00 00 00       	mov    $0x1b,%eax
 46d:	cd 40                	int    $0x40
 46f:	c3                   	ret    

00000470 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	83 ec 18             	sub    $0x18,%esp
 476:	8b 45 0c             	mov    0xc(%ebp),%eax
 479:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 47c:	83 ec 04             	sub    $0x4,%esp
 47f:	6a 01                	push   $0x1
 481:	8d 45 f4             	lea    -0xc(%ebp),%eax
 484:	50                   	push   %eax
 485:	ff 75 08             	pushl  0x8(%ebp)
 488:	e8 33 ff ff ff       	call   3c0 <write>
 48d:	83 c4 10             	add    $0x10,%esp
}
 490:	c9                   	leave  
 491:	c3                   	ret    

00000492 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 492:	55                   	push   %ebp
 493:	89 e5                	mov    %esp,%ebp
 495:	53                   	push   %ebx
 496:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 499:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4a0:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4a4:	74 17                	je     4bd <printint+0x2b>
 4a6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4aa:	79 11                	jns    4bd <printint+0x2b>
    neg = 1;
 4ac:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4b3:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b6:	f7 d8                	neg    %eax
 4b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4bb:	eb 06                	jmp    4c3 <printint+0x31>
  } else {
    x = xx;
 4bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4ca:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4cd:	8d 41 01             	lea    0x1(%ecx),%eax
 4d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4d3:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4d9:	ba 00 00 00 00       	mov    $0x0,%edx
 4de:	f7 f3                	div    %ebx
 4e0:	89 d0                	mov    %edx,%eax
 4e2:	0f b6 80 b8 0b 00 00 	movzbl 0xbb8(%eax),%eax
 4e9:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4ed:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4f3:	ba 00 00 00 00       	mov    $0x0,%edx
 4f8:	f7 f3                	div    %ebx
 4fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 501:	75 c7                	jne    4ca <printint+0x38>
  if(neg)
 503:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 507:	74 0e                	je     517 <printint+0x85>
    buf[i++] = '-';
 509:	8b 45 f4             	mov    -0xc(%ebp),%eax
 50c:	8d 50 01             	lea    0x1(%eax),%edx
 50f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 512:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 517:	eb 1d                	jmp    536 <printint+0xa4>
    putc(fd, buf[i]);
 519:	8d 55 dc             	lea    -0x24(%ebp),%edx
 51c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 51f:	01 d0                	add    %edx,%eax
 521:	0f b6 00             	movzbl (%eax),%eax
 524:	0f be c0             	movsbl %al,%eax
 527:	83 ec 08             	sub    $0x8,%esp
 52a:	50                   	push   %eax
 52b:	ff 75 08             	pushl  0x8(%ebp)
 52e:	e8 3d ff ff ff       	call   470 <putc>
 533:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 536:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 53a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 53e:	79 d9                	jns    519 <printint+0x87>
    putc(fd, buf[i]);
}
 540:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 543:	c9                   	leave  
 544:	c3                   	ret    

00000545 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 545:	55                   	push   %ebp
 546:	89 e5                	mov    %esp,%ebp
 548:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 54b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 552:	8d 45 0c             	lea    0xc(%ebp),%eax
 555:	83 c0 04             	add    $0x4,%eax
 558:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 55b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 562:	e9 59 01 00 00       	jmp    6c0 <printf+0x17b>
    c = fmt[i] & 0xff;
 567:	8b 55 0c             	mov    0xc(%ebp),%edx
 56a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 56d:	01 d0                	add    %edx,%eax
 56f:	0f b6 00             	movzbl (%eax),%eax
 572:	0f be c0             	movsbl %al,%eax
 575:	25 ff 00 00 00       	and    $0xff,%eax
 57a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 57d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 581:	75 2c                	jne    5af <printf+0x6a>
      if(c == '%'){
 583:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 587:	75 0c                	jne    595 <printf+0x50>
        state = '%';
 589:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 590:	e9 27 01 00 00       	jmp    6bc <printf+0x177>
      } else {
        putc(fd, c);
 595:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 598:	0f be c0             	movsbl %al,%eax
 59b:	83 ec 08             	sub    $0x8,%esp
 59e:	50                   	push   %eax
 59f:	ff 75 08             	pushl  0x8(%ebp)
 5a2:	e8 c9 fe ff ff       	call   470 <putc>
 5a7:	83 c4 10             	add    $0x10,%esp
 5aa:	e9 0d 01 00 00       	jmp    6bc <printf+0x177>
      }
    } else if(state == '%'){
 5af:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5b3:	0f 85 03 01 00 00    	jne    6bc <printf+0x177>
      if(c == 'd'){
 5b9:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5bd:	75 1e                	jne    5dd <printf+0x98>
        printint(fd, *ap, 10, 1);
 5bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c2:	8b 00                	mov    (%eax),%eax
 5c4:	6a 01                	push   $0x1
 5c6:	6a 0a                	push   $0xa
 5c8:	50                   	push   %eax
 5c9:	ff 75 08             	pushl  0x8(%ebp)
 5cc:	e8 c1 fe ff ff       	call   492 <printint>
 5d1:	83 c4 10             	add    $0x10,%esp
        ap++;
 5d4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d8:	e9 d8 00 00 00       	jmp    6b5 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5dd:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5e1:	74 06                	je     5e9 <printf+0xa4>
 5e3:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5e7:	75 1e                	jne    607 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ec:	8b 00                	mov    (%eax),%eax
 5ee:	6a 00                	push   $0x0
 5f0:	6a 10                	push   $0x10
 5f2:	50                   	push   %eax
 5f3:	ff 75 08             	pushl  0x8(%ebp)
 5f6:	e8 97 fe ff ff       	call   492 <printint>
 5fb:	83 c4 10             	add    $0x10,%esp
        ap++;
 5fe:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 602:	e9 ae 00 00 00       	jmp    6b5 <printf+0x170>
      } else if(c == 's'){
 607:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 60b:	75 43                	jne    650 <printf+0x10b>
        s = (char*)*ap;
 60d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 610:	8b 00                	mov    (%eax),%eax
 612:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 615:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 619:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 61d:	75 07                	jne    626 <printf+0xe1>
          s = "(null)";
 61f:	c7 45 f4 62 09 00 00 	movl   $0x962,-0xc(%ebp)
        while(*s != 0){
 626:	eb 1c                	jmp    644 <printf+0xff>
          putc(fd, *s);
 628:	8b 45 f4             	mov    -0xc(%ebp),%eax
 62b:	0f b6 00             	movzbl (%eax),%eax
 62e:	0f be c0             	movsbl %al,%eax
 631:	83 ec 08             	sub    $0x8,%esp
 634:	50                   	push   %eax
 635:	ff 75 08             	pushl  0x8(%ebp)
 638:	e8 33 fe ff ff       	call   470 <putc>
 63d:	83 c4 10             	add    $0x10,%esp
          s++;
 640:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 644:	8b 45 f4             	mov    -0xc(%ebp),%eax
 647:	0f b6 00             	movzbl (%eax),%eax
 64a:	84 c0                	test   %al,%al
 64c:	75 da                	jne    628 <printf+0xe3>
 64e:	eb 65                	jmp    6b5 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 650:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 654:	75 1d                	jne    673 <printf+0x12e>
        putc(fd, *ap);
 656:	8b 45 e8             	mov    -0x18(%ebp),%eax
 659:	8b 00                	mov    (%eax),%eax
 65b:	0f be c0             	movsbl %al,%eax
 65e:	83 ec 08             	sub    $0x8,%esp
 661:	50                   	push   %eax
 662:	ff 75 08             	pushl  0x8(%ebp)
 665:	e8 06 fe ff ff       	call   470 <putc>
 66a:	83 c4 10             	add    $0x10,%esp
        ap++;
 66d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 671:	eb 42                	jmp    6b5 <printf+0x170>
      } else if(c == '%'){
 673:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 677:	75 17                	jne    690 <printf+0x14b>
        putc(fd, c);
 679:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 67c:	0f be c0             	movsbl %al,%eax
 67f:	83 ec 08             	sub    $0x8,%esp
 682:	50                   	push   %eax
 683:	ff 75 08             	pushl  0x8(%ebp)
 686:	e8 e5 fd ff ff       	call   470 <putc>
 68b:	83 c4 10             	add    $0x10,%esp
 68e:	eb 25                	jmp    6b5 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 690:	83 ec 08             	sub    $0x8,%esp
 693:	6a 25                	push   $0x25
 695:	ff 75 08             	pushl  0x8(%ebp)
 698:	e8 d3 fd ff ff       	call   470 <putc>
 69d:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6a3:	0f be c0             	movsbl %al,%eax
 6a6:	83 ec 08             	sub    $0x8,%esp
 6a9:	50                   	push   %eax
 6aa:	ff 75 08             	pushl  0x8(%ebp)
 6ad:	e8 be fd ff ff       	call   470 <putc>
 6b2:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6b5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6bc:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6c0:	8b 55 0c             	mov    0xc(%ebp),%edx
 6c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6c6:	01 d0                	add    %edx,%eax
 6c8:	0f b6 00             	movzbl (%eax),%eax
 6cb:	84 c0                	test   %al,%al
 6cd:	0f 85 94 fe ff ff    	jne    567 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6d3:	c9                   	leave  
 6d4:	c3                   	ret    

000006d5 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6d5:	55                   	push   %ebp
 6d6:	89 e5                	mov    %esp,%ebp
 6d8:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6db:	8b 45 08             	mov    0x8(%ebp),%eax
 6de:	83 e8 08             	sub    $0x8,%eax
 6e1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e4:	a1 d4 0b 00 00       	mov    0xbd4,%eax
 6e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6ec:	eb 24                	jmp    712 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f1:	8b 00                	mov    (%eax),%eax
 6f3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f6:	77 12                	ja     70a <free+0x35>
 6f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6fe:	77 24                	ja     724 <free+0x4f>
 700:	8b 45 fc             	mov    -0x4(%ebp),%eax
 703:	8b 00                	mov    (%eax),%eax
 705:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 708:	77 1a                	ja     724 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 70a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70d:	8b 00                	mov    (%eax),%eax
 70f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 712:	8b 45 f8             	mov    -0x8(%ebp),%eax
 715:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 718:	76 d4                	jbe    6ee <free+0x19>
 71a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71d:	8b 00                	mov    (%eax),%eax
 71f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 722:	76 ca                	jbe    6ee <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 724:	8b 45 f8             	mov    -0x8(%ebp),%eax
 727:	8b 40 04             	mov    0x4(%eax),%eax
 72a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 731:	8b 45 f8             	mov    -0x8(%ebp),%eax
 734:	01 c2                	add    %eax,%edx
 736:	8b 45 fc             	mov    -0x4(%ebp),%eax
 739:	8b 00                	mov    (%eax),%eax
 73b:	39 c2                	cmp    %eax,%edx
 73d:	75 24                	jne    763 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 73f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 742:	8b 50 04             	mov    0x4(%eax),%edx
 745:	8b 45 fc             	mov    -0x4(%ebp),%eax
 748:	8b 00                	mov    (%eax),%eax
 74a:	8b 40 04             	mov    0x4(%eax),%eax
 74d:	01 c2                	add    %eax,%edx
 74f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 752:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 755:	8b 45 fc             	mov    -0x4(%ebp),%eax
 758:	8b 00                	mov    (%eax),%eax
 75a:	8b 10                	mov    (%eax),%edx
 75c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75f:	89 10                	mov    %edx,(%eax)
 761:	eb 0a                	jmp    76d <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 763:	8b 45 fc             	mov    -0x4(%ebp),%eax
 766:	8b 10                	mov    (%eax),%edx
 768:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76b:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 76d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 770:	8b 40 04             	mov    0x4(%eax),%eax
 773:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 77a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77d:	01 d0                	add    %edx,%eax
 77f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 782:	75 20                	jne    7a4 <free+0xcf>
    p->s.size += bp->s.size;
 784:	8b 45 fc             	mov    -0x4(%ebp),%eax
 787:	8b 50 04             	mov    0x4(%eax),%edx
 78a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78d:	8b 40 04             	mov    0x4(%eax),%eax
 790:	01 c2                	add    %eax,%edx
 792:	8b 45 fc             	mov    -0x4(%ebp),%eax
 795:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 798:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79b:	8b 10                	mov    (%eax),%edx
 79d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a0:	89 10                	mov    %edx,(%eax)
 7a2:	eb 08                	jmp    7ac <free+0xd7>
  } else
    p->s.ptr = bp;
 7a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a7:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7aa:	89 10                	mov    %edx,(%eax)
  freep = p;
 7ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7af:	a3 d4 0b 00 00       	mov    %eax,0xbd4
}
 7b4:	c9                   	leave  
 7b5:	c3                   	ret    

000007b6 <morecore>:

static Header*
morecore(uint nu)
{
 7b6:	55                   	push   %ebp
 7b7:	89 e5                	mov    %esp,%ebp
 7b9:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7bc:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7c3:	77 07                	ja     7cc <morecore+0x16>
    nu = 4096;
 7c5:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7cc:	8b 45 08             	mov    0x8(%ebp),%eax
 7cf:	c1 e0 03             	shl    $0x3,%eax
 7d2:	83 ec 0c             	sub    $0xc,%esp
 7d5:	50                   	push   %eax
 7d6:	e8 4d fc ff ff       	call   428 <sbrk>
 7db:	83 c4 10             	add    $0x10,%esp
 7de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7e1:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7e5:	75 07                	jne    7ee <morecore+0x38>
    return 0;
 7e7:	b8 00 00 00 00       	mov    $0x0,%eax
 7ec:	eb 26                	jmp    814 <morecore+0x5e>
  hp = (Header*)p;
 7ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f7:	8b 55 08             	mov    0x8(%ebp),%edx
 7fa:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 800:	83 c0 08             	add    $0x8,%eax
 803:	83 ec 0c             	sub    $0xc,%esp
 806:	50                   	push   %eax
 807:	e8 c9 fe ff ff       	call   6d5 <free>
 80c:	83 c4 10             	add    $0x10,%esp
  return freep;
 80f:	a1 d4 0b 00 00       	mov    0xbd4,%eax
}
 814:	c9                   	leave  
 815:	c3                   	ret    

00000816 <malloc>:

void*
malloc(uint nbytes)
{
 816:	55                   	push   %ebp
 817:	89 e5                	mov    %esp,%ebp
 819:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 81c:	8b 45 08             	mov    0x8(%ebp),%eax
 81f:	83 c0 07             	add    $0x7,%eax
 822:	c1 e8 03             	shr    $0x3,%eax
 825:	83 c0 01             	add    $0x1,%eax
 828:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 82b:	a1 d4 0b 00 00       	mov    0xbd4,%eax
 830:	89 45 f0             	mov    %eax,-0x10(%ebp)
 833:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 837:	75 23                	jne    85c <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 839:	c7 45 f0 cc 0b 00 00 	movl   $0xbcc,-0x10(%ebp)
 840:	8b 45 f0             	mov    -0x10(%ebp),%eax
 843:	a3 d4 0b 00 00       	mov    %eax,0xbd4
 848:	a1 d4 0b 00 00       	mov    0xbd4,%eax
 84d:	a3 cc 0b 00 00       	mov    %eax,0xbcc
    base.s.size = 0;
 852:	c7 05 d0 0b 00 00 00 	movl   $0x0,0xbd0
 859:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 85c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 85f:	8b 00                	mov    (%eax),%eax
 861:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 864:	8b 45 f4             	mov    -0xc(%ebp),%eax
 867:	8b 40 04             	mov    0x4(%eax),%eax
 86a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 86d:	72 4d                	jb     8bc <malloc+0xa6>
      if(p->s.size == nunits)
 86f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 872:	8b 40 04             	mov    0x4(%eax),%eax
 875:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 878:	75 0c                	jne    886 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 87a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87d:	8b 10                	mov    (%eax),%edx
 87f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 882:	89 10                	mov    %edx,(%eax)
 884:	eb 26                	jmp    8ac <malloc+0x96>
      else {
        p->s.size -= nunits;
 886:	8b 45 f4             	mov    -0xc(%ebp),%eax
 889:	8b 40 04             	mov    0x4(%eax),%eax
 88c:	2b 45 ec             	sub    -0x14(%ebp),%eax
 88f:	89 c2                	mov    %eax,%edx
 891:	8b 45 f4             	mov    -0xc(%ebp),%eax
 894:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 897:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89a:	8b 40 04             	mov    0x4(%eax),%eax
 89d:	c1 e0 03             	shl    $0x3,%eax
 8a0:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8a9:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8af:	a3 d4 0b 00 00       	mov    %eax,0xbd4
      return (void*)(p + 1);
 8b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b7:	83 c0 08             	add    $0x8,%eax
 8ba:	eb 3b                	jmp    8f7 <malloc+0xe1>
    }
    if(p == freep)
 8bc:	a1 d4 0b 00 00       	mov    0xbd4,%eax
 8c1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8c4:	75 1e                	jne    8e4 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8c6:	83 ec 0c             	sub    $0xc,%esp
 8c9:	ff 75 ec             	pushl  -0x14(%ebp)
 8cc:	e8 e5 fe ff ff       	call   7b6 <morecore>
 8d1:	83 c4 10             	add    $0x10,%esp
 8d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8db:	75 07                	jne    8e4 <malloc+0xce>
        return 0;
 8dd:	b8 00 00 00 00       	mov    $0x0,%eax
 8e2:	eb 13                	jmp    8f7 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ed:	8b 00                	mov    (%eax),%eax
 8ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8f2:	e9 6d ff ff ff       	jmp    864 <malloc+0x4e>
}
 8f7:	c9                   	leave  
 8f8:	c3                   	ret    

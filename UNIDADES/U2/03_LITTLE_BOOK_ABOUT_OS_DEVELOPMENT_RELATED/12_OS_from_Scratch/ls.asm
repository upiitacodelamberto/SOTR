
_ls:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 14             	sub    $0x14,%esp
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   7:	83 ec 0c             	sub    $0xc,%esp
   a:	ff 75 08             	pushl  0x8(%ebp)
   d:	e8 48 04 00 00       	call   45a <strlen>
  12:	83 c4 10             	add    $0x10,%esp
  15:	89 c2                	mov    %eax,%edx
  17:	8b 45 08             	mov    0x8(%ebp),%eax
  1a:	01 d0                	add    %edx,%eax
  1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1f:	eb 04                	jmp    25 <fmtname+0x25>
  21:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  28:	3b 45 08             	cmp    0x8(%ebp),%eax
  2b:	72 0a                	jb     37 <fmtname+0x37>
  2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  30:	0f b6 00             	movzbl (%eax),%eax
  33:	3c 2f                	cmp    $0x2f,%al
  35:	75 ea                	jne    21 <fmtname+0x21>
    ;
  p++;
  37:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  3b:	83 ec 0c             	sub    $0xc,%esp
  3e:	ff 75 f4             	pushl  -0xc(%ebp)
  41:	e8 14 04 00 00       	call   45a <strlen>
  46:	83 c4 10             	add    $0x10,%esp
  49:	83 f8 0d             	cmp    $0xd,%eax
  4c:	76 05                	jbe    53 <fmtname+0x53>
    return p;
  4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  51:	eb 60                	jmp    b3 <fmtname+0xb3>
  memmove(buf, p, strlen(p));
  53:	83 ec 0c             	sub    $0xc,%esp
  56:	ff 75 f4             	pushl  -0xc(%ebp)
  59:	e8 fc 03 00 00       	call   45a <strlen>
  5e:	83 c4 10             	add    $0x10,%esp
  61:	83 ec 04             	sub    $0x4,%esp
  64:	50                   	push   %eax
  65:	ff 75 f4             	pushl  -0xc(%ebp)
  68:	68 9c 0e 00 00       	push   $0xe9c
  6d:	e8 64 05 00 00       	call   5d6 <memmove>
  72:	83 c4 10             	add    $0x10,%esp
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  75:	83 ec 0c             	sub    $0xc,%esp
  78:	ff 75 f4             	pushl  -0xc(%ebp)
  7b:	e8 da 03 00 00       	call   45a <strlen>
  80:	83 c4 10             	add    $0x10,%esp
  83:	ba 0e 00 00 00       	mov    $0xe,%edx
  88:	89 d3                	mov    %edx,%ebx
  8a:	29 c3                	sub    %eax,%ebx
  8c:	83 ec 0c             	sub    $0xc,%esp
  8f:	ff 75 f4             	pushl  -0xc(%ebp)
  92:	e8 c3 03 00 00       	call   45a <strlen>
  97:	83 c4 10             	add    $0x10,%esp
  9a:	05 9c 0e 00 00       	add    $0xe9c,%eax
  9f:	83 ec 04             	sub    $0x4,%esp
  a2:	53                   	push   %ebx
  a3:	6a 20                	push   $0x20
  a5:	50                   	push   %eax
  a6:	e8 d6 03 00 00       	call   481 <memset>
  ab:	83 c4 10             	add    $0x10,%esp
  return buf;
  ae:	b8 9c 0e 00 00       	mov    $0xe9c,%eax
}
  b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  b6:	c9                   	leave  
  b7:	c3                   	ret    

000000b8 <ls>:

void
ls(char *path)
{
  b8:	55                   	push   %ebp
  b9:	89 e5                	mov    %esp,%ebp
  bb:	57                   	push   %edi
  bc:	56                   	push   %esi
  bd:	53                   	push   %ebx
  be:	81 ec 5c 02 00 00    	sub    $0x25c,%esp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
  c4:	83 ec 08             	sub    $0x8,%esp
  c7:	6a 00                	push   $0x0
  c9:	ff 75 08             	pushl  0x8(%ebp)
  cc:	e8 8a 05 00 00       	call   65b <open>
  d1:	83 c4 10             	add    $0x10,%esp
  d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  db:	79 1a                	jns    f7 <ls+0x3f>
    printf(2, "ls: cannot open %s\n", path);
  dd:	83 ec 04             	sub    $0x4,%esp
  e0:	ff 75 08             	pushl  0x8(%ebp)
  e3:	68 74 0b 00 00       	push   $0xb74
  e8:	6a 02                	push   $0x2
  ea:	e8 d1 06 00 00       	call   7c0 <printf>
  ef:	83 c4 10             	add    $0x10,%esp
    return;
  f2:	e9 63 02 00 00       	jmp    35a <ls+0x2a2>
  }
  
  if(fstat(fd, &st) < 0){
  f7:	83 ec 08             	sub    $0x8,%esp
  fa:	8d 85 b4 fd ff ff    	lea    -0x24c(%ebp),%eax
 100:	50                   	push   %eax
 101:	ff 75 e4             	pushl  -0x1c(%ebp)
 104:	e8 6a 05 00 00       	call   673 <fstat>
 109:	83 c4 10             	add    $0x10,%esp
 10c:	85 c0                	test   %eax,%eax
 10e:	79 28                	jns    138 <ls+0x80>
    printf(2, "ls: cannot stat %s\n", path);
 110:	83 ec 04             	sub    $0x4,%esp
 113:	ff 75 08             	pushl  0x8(%ebp)
 116:	68 88 0b 00 00       	push   $0xb88
 11b:	6a 02                	push   $0x2
 11d:	e8 9e 06 00 00       	call   7c0 <printf>
 122:	83 c4 10             	add    $0x10,%esp
    close(fd);
 125:	83 ec 0c             	sub    $0xc,%esp
 128:	ff 75 e4             	pushl  -0x1c(%ebp)
 12b:	e8 13 05 00 00       	call   643 <close>
 130:	83 c4 10             	add    $0x10,%esp
    return;
 133:	e9 22 02 00 00       	jmp    35a <ls+0x2a2>
  }
  
  switch(st.type){
 138:	0f b7 85 b4 fd ff ff 	movzwl -0x24c(%ebp),%eax
 13f:	98                   	cwtl   
 140:	83 f8 01             	cmp    $0x1,%eax
 143:	0f 84 86 00 00 00    	je     1cf <ls+0x117>
 149:	83 f8 02             	cmp    $0x2,%eax
 14c:	0f 85 fa 01 00 00    	jne    34c <ls+0x294>
  case T_FILE:
    //printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
    printf(1, "%s %d %d %d %x %d %d\n", fmtname(path), st.type, st.ownerid, st.groupid, st.mode, st.ino, st.size);
 152:	8b 85 cc fd ff ff    	mov    -0x234(%ebp),%eax
 158:	89 85 a4 fd ff ff    	mov    %eax,-0x25c(%ebp)
 15e:	8b 8d bc fd ff ff    	mov    -0x244(%ebp),%ecx
 164:	89 8d a0 fd ff ff    	mov    %ecx,-0x260(%ebp)
 16a:	8b 95 c8 fd ff ff    	mov    -0x238(%ebp),%edx
 170:	89 95 9c fd ff ff    	mov    %edx,-0x264(%ebp)
 176:	0f b7 85 c4 fd ff ff 	movzwl -0x23c(%ebp),%eax
 17d:	0f bf f8             	movswl %ax,%edi
 180:	0f b7 85 c2 fd ff ff 	movzwl -0x23e(%ebp),%eax
 187:	0f bf f0             	movswl %ax,%esi
 18a:	0f b7 85 b4 fd ff ff 	movzwl -0x24c(%ebp),%eax
 191:	0f bf d8             	movswl %ax,%ebx
 194:	83 ec 0c             	sub    $0xc,%esp
 197:	ff 75 08             	pushl  0x8(%ebp)
 19a:	e8 61 fe ff ff       	call   0 <fmtname>
 19f:	83 c4 10             	add    $0x10,%esp
 1a2:	83 ec 0c             	sub    $0xc,%esp
 1a5:	ff b5 a4 fd ff ff    	pushl  -0x25c(%ebp)
 1ab:	ff b5 a0 fd ff ff    	pushl  -0x260(%ebp)
 1b1:	ff b5 9c fd ff ff    	pushl  -0x264(%ebp)
 1b7:	57                   	push   %edi
 1b8:	56                   	push   %esi
 1b9:	53                   	push   %ebx
 1ba:	50                   	push   %eax
 1bb:	68 9c 0b 00 00       	push   $0xb9c
 1c0:	6a 01                	push   $0x1
 1c2:	e8 f9 05 00 00       	call   7c0 <printf>
 1c7:	83 c4 30             	add    $0x30,%esp
    break;
 1ca:	e9 7d 01 00 00       	jmp    34c <ls+0x294>
  
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 1cf:	83 ec 0c             	sub    $0xc,%esp
 1d2:	ff 75 08             	pushl  0x8(%ebp)
 1d5:	e8 80 02 00 00       	call   45a <strlen>
 1da:	83 c4 10             	add    $0x10,%esp
 1dd:	83 c0 10             	add    $0x10,%eax
 1e0:	3d 00 02 00 00       	cmp    $0x200,%eax
 1e5:	76 17                	jbe    1fe <ls+0x146>
      printf(1, "ls: path too long\n");
 1e7:	83 ec 08             	sub    $0x8,%esp
 1ea:	68 b2 0b 00 00       	push   $0xbb2
 1ef:	6a 01                	push   $0x1
 1f1:	e8 ca 05 00 00       	call   7c0 <printf>
 1f6:	83 c4 10             	add    $0x10,%esp
      break;
 1f9:	e9 4e 01 00 00       	jmp    34c <ls+0x294>
    }
    strcpy(buf, path);
 1fe:	83 ec 08             	sub    $0x8,%esp
 201:	ff 75 08             	pushl  0x8(%ebp)
 204:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 20a:	50                   	push   %eax
 20b:	e8 db 01 00 00       	call   3eb <strcpy>
 210:	83 c4 10             	add    $0x10,%esp
    p = buf+strlen(buf);
 213:	83 ec 0c             	sub    $0xc,%esp
 216:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 21c:	50                   	push   %eax
 21d:	e8 38 02 00 00       	call   45a <strlen>
 222:	83 c4 10             	add    $0x10,%esp
 225:	89 c2                	mov    %eax,%edx
 227:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 22d:	01 d0                	add    %edx,%eax
 22f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    *p++ = '/';
 232:	8b 45 e0             	mov    -0x20(%ebp),%eax
 235:	8d 50 01             	lea    0x1(%eax),%edx
 238:	89 55 e0             	mov    %edx,-0x20(%ebp)
 23b:	c6 00 2f             	movb   $0x2f,(%eax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 23e:	e9 e8 00 00 00       	jmp    32b <ls+0x273>
      if(de.inum == 0)
 243:	0f b7 85 d0 fd ff ff 	movzwl -0x230(%ebp),%eax
 24a:	66 85 c0             	test   %ax,%ax
 24d:	75 05                	jne    254 <ls+0x19c>
        continue;
 24f:	e9 d7 00 00 00       	jmp    32b <ls+0x273>
      memmove(p, de.name, DIRSIZ);
 254:	83 ec 04             	sub    $0x4,%esp
 257:	6a 0e                	push   $0xe
 259:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 25f:	83 c0 02             	add    $0x2,%eax
 262:	50                   	push   %eax
 263:	ff 75 e0             	pushl  -0x20(%ebp)
 266:	e8 6b 03 00 00       	call   5d6 <memmove>
 26b:	83 c4 10             	add    $0x10,%esp
      p[DIRSIZ] = 0;
 26e:	8b 45 e0             	mov    -0x20(%ebp),%eax
 271:	83 c0 0e             	add    $0xe,%eax
 274:	c6 00 00             	movb   $0x0,(%eax)
      if(stat(buf, &st) < 0){
 277:	83 ec 08             	sub    $0x8,%esp
 27a:	8d 85 b4 fd ff ff    	lea    -0x24c(%ebp),%eax
 280:	50                   	push   %eax
 281:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 287:	50                   	push   %eax
 288:	e8 af 02 00 00       	call   53c <stat>
 28d:	83 c4 10             	add    $0x10,%esp
 290:	85 c0                	test   %eax,%eax
 292:	79 1b                	jns    2af <ls+0x1f7>
        printf(1, "ls: cannot stat %s\n", buf);
 294:	83 ec 04             	sub    $0x4,%esp
 297:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 29d:	50                   	push   %eax
 29e:	68 88 0b 00 00       	push   $0xb88
 2a3:	6a 01                	push   $0x1
 2a5:	e8 16 05 00 00       	call   7c0 <printf>
 2aa:	83 c4 10             	add    $0x10,%esp
        continue;
 2ad:	eb 7c                	jmp    32b <ls+0x273>
      }
      //printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
      printf(1, "%s  %d %d %d %x %d %d\n", fmtname(buf), st.type, st.ownerid, st.groupid, st.mode, st.ino, st.size);
 2af:	8b 85 cc fd ff ff    	mov    -0x234(%ebp),%eax
 2b5:	89 85 a4 fd ff ff    	mov    %eax,-0x25c(%ebp)
 2bb:	8b 8d bc fd ff ff    	mov    -0x244(%ebp),%ecx
 2c1:	89 8d a0 fd ff ff    	mov    %ecx,-0x260(%ebp)
 2c7:	8b 9d c8 fd ff ff    	mov    -0x238(%ebp),%ebx
 2cd:	89 9d 9c fd ff ff    	mov    %ebx,-0x264(%ebp)
 2d3:	0f b7 85 c4 fd ff ff 	movzwl -0x23c(%ebp),%eax
 2da:	0f bf f8             	movswl %ax,%edi
 2dd:	0f b7 85 c2 fd ff ff 	movzwl -0x23e(%ebp),%eax
 2e4:	0f bf f0             	movswl %ax,%esi
 2e7:	0f b7 85 b4 fd ff ff 	movzwl -0x24c(%ebp),%eax
 2ee:	0f bf d8             	movswl %ax,%ebx
 2f1:	83 ec 0c             	sub    $0xc,%esp
 2f4:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 2fa:	50                   	push   %eax
 2fb:	e8 00 fd ff ff       	call   0 <fmtname>
 300:	83 c4 10             	add    $0x10,%esp
 303:	83 ec 0c             	sub    $0xc,%esp
 306:	ff b5 a4 fd ff ff    	pushl  -0x25c(%ebp)
 30c:	ff b5 a0 fd ff ff    	pushl  -0x260(%ebp)
 312:	ff b5 9c fd ff ff    	pushl  -0x264(%ebp)
 318:	57                   	push   %edi
 319:	56                   	push   %esi
 31a:	53                   	push   %ebx
 31b:	50                   	push   %eax
 31c:	68 c5 0b 00 00       	push   $0xbc5
 321:	6a 01                	push   $0x1
 323:	e8 98 04 00 00       	call   7c0 <printf>
 328:	83 c4 30             	add    $0x30,%esp
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 32b:	83 ec 04             	sub    $0x4,%esp
 32e:	6a 10                	push   $0x10
 330:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 336:	50                   	push   %eax
 337:	ff 75 e4             	pushl  -0x1c(%ebp)
 33a:	e8 f4 02 00 00       	call   633 <read>
 33f:	83 c4 10             	add    $0x10,%esp
 342:	83 f8 10             	cmp    $0x10,%eax
 345:	0f 84 f8 fe ff ff    	je     243 <ls+0x18b>
        continue;
      }
      //printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
      printf(1, "%s  %d %d %d %x %d %d\n", fmtname(buf), st.type, st.ownerid, st.groupid, st.mode, st.ino, st.size);
    }
    break;
 34b:	90                   	nop
  }
  close(fd);
 34c:	83 ec 0c             	sub    $0xc,%esp
 34f:	ff 75 e4             	pushl  -0x1c(%ebp)
 352:	e8 ec 02 00 00       	call   643 <close>
 357:	83 c4 10             	add    $0x10,%esp
}
 35a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 35d:	5b                   	pop    %ebx
 35e:	5e                   	pop    %esi
 35f:	5f                   	pop    %edi
 360:	5d                   	pop    %ebp
 361:	c3                   	ret    

00000362 <main>:

int
main(int argc, char *argv[])
{
 362:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 366:	83 e4 f0             	and    $0xfffffff0,%esp
 369:	ff 71 fc             	pushl  -0x4(%ecx)
 36c:	55                   	push   %ebp
 36d:	89 e5                	mov    %esp,%ebp
 36f:	53                   	push   %ebx
 370:	51                   	push   %ecx
 371:	83 ec 10             	sub    $0x10,%esp
 374:	89 cb                	mov    %ecx,%ebx
  int i;

  if(argc < 2){
 376:	83 3b 01             	cmpl   $0x1,(%ebx)
 379:	7f 15                	jg     390 <main+0x2e>
    ls(".");
 37b:	83 ec 0c             	sub    $0xc,%esp
 37e:	68 dc 0b 00 00       	push   $0xbdc
 383:	e8 30 fd ff ff       	call   b8 <ls>
 388:	83 c4 10             	add    $0x10,%esp
    exit();
 38b:	e8 8b 02 00 00       	call   61b <exit>
  }
  for(i=1; i<argc; i++)
 390:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 397:	eb 21                	jmp    3ba <main+0x58>
    ls(argv[i]);
 399:	8b 45 f4             	mov    -0xc(%ebp),%eax
 39c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 3a3:	8b 43 04             	mov    0x4(%ebx),%eax
 3a6:	01 d0                	add    %edx,%eax
 3a8:	8b 00                	mov    (%eax),%eax
 3aa:	83 ec 0c             	sub    $0xc,%esp
 3ad:	50                   	push   %eax
 3ae:	e8 05 fd ff ff       	call   b8 <ls>
 3b3:	83 c4 10             	add    $0x10,%esp

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
 3b6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 3ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3bd:	3b 03                	cmp    (%ebx),%eax
 3bf:	7c d8                	jl     399 <main+0x37>
    ls(argv[i]);
  exit();
 3c1:	e8 55 02 00 00       	call   61b <exit>

000003c6 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 3c6:	55                   	push   %ebp
 3c7:	89 e5                	mov    %esp,%ebp
 3c9:	57                   	push   %edi
 3ca:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 3cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
 3ce:	8b 55 10             	mov    0x10(%ebp),%edx
 3d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d4:	89 cb                	mov    %ecx,%ebx
 3d6:	89 df                	mov    %ebx,%edi
 3d8:	89 d1                	mov    %edx,%ecx
 3da:	fc                   	cld    
 3db:	f3 aa                	rep stos %al,%es:(%edi)
 3dd:	89 ca                	mov    %ecx,%edx
 3df:	89 fb                	mov    %edi,%ebx
 3e1:	89 5d 08             	mov    %ebx,0x8(%ebp)
 3e4:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 3e7:	5b                   	pop    %ebx
 3e8:	5f                   	pop    %edi
 3e9:	5d                   	pop    %ebp
 3ea:	c3                   	ret    

000003eb <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 3eb:	55                   	push   %ebp
 3ec:	89 e5                	mov    %esp,%ebp
 3ee:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 3f1:	8b 45 08             	mov    0x8(%ebp),%eax
 3f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 3f7:	90                   	nop
 3f8:	8b 45 08             	mov    0x8(%ebp),%eax
 3fb:	8d 50 01             	lea    0x1(%eax),%edx
 3fe:	89 55 08             	mov    %edx,0x8(%ebp)
 401:	8b 55 0c             	mov    0xc(%ebp),%edx
 404:	8d 4a 01             	lea    0x1(%edx),%ecx
 407:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 40a:	0f b6 12             	movzbl (%edx),%edx
 40d:	88 10                	mov    %dl,(%eax)
 40f:	0f b6 00             	movzbl (%eax),%eax
 412:	84 c0                	test   %al,%al
 414:	75 e2                	jne    3f8 <strcpy+0xd>
    ;
  return os;
 416:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 419:	c9                   	leave  
 41a:	c3                   	ret    

0000041b <strcmp>:

int
strcmp(const char *p, const char *q)
{
 41b:	55                   	push   %ebp
 41c:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 41e:	eb 08                	jmp    428 <strcmp+0xd>
    p++, q++;
 420:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 424:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 428:	8b 45 08             	mov    0x8(%ebp),%eax
 42b:	0f b6 00             	movzbl (%eax),%eax
 42e:	84 c0                	test   %al,%al
 430:	74 10                	je     442 <strcmp+0x27>
 432:	8b 45 08             	mov    0x8(%ebp),%eax
 435:	0f b6 10             	movzbl (%eax),%edx
 438:	8b 45 0c             	mov    0xc(%ebp),%eax
 43b:	0f b6 00             	movzbl (%eax),%eax
 43e:	38 c2                	cmp    %al,%dl
 440:	74 de                	je     420 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 442:	8b 45 08             	mov    0x8(%ebp),%eax
 445:	0f b6 00             	movzbl (%eax),%eax
 448:	0f b6 d0             	movzbl %al,%edx
 44b:	8b 45 0c             	mov    0xc(%ebp),%eax
 44e:	0f b6 00             	movzbl (%eax),%eax
 451:	0f b6 c0             	movzbl %al,%eax
 454:	29 c2                	sub    %eax,%edx
 456:	89 d0                	mov    %edx,%eax
}
 458:	5d                   	pop    %ebp
 459:	c3                   	ret    

0000045a <strlen>:

uint
strlen(char *s)
{
 45a:	55                   	push   %ebp
 45b:	89 e5                	mov    %esp,%ebp
 45d:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 460:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 467:	eb 04                	jmp    46d <strlen+0x13>
 469:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 46d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 470:	8b 45 08             	mov    0x8(%ebp),%eax
 473:	01 d0                	add    %edx,%eax
 475:	0f b6 00             	movzbl (%eax),%eax
 478:	84 c0                	test   %al,%al
 47a:	75 ed                	jne    469 <strlen+0xf>
    ;
  return n;
 47c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 47f:	c9                   	leave  
 480:	c3                   	ret    

00000481 <memset>:

void*
memset(void *dst, int c, uint n)
{
 481:	55                   	push   %ebp
 482:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 484:	8b 45 10             	mov    0x10(%ebp),%eax
 487:	50                   	push   %eax
 488:	ff 75 0c             	pushl  0xc(%ebp)
 48b:	ff 75 08             	pushl  0x8(%ebp)
 48e:	e8 33 ff ff ff       	call   3c6 <stosb>
 493:	83 c4 0c             	add    $0xc,%esp
  return dst;
 496:	8b 45 08             	mov    0x8(%ebp),%eax
}
 499:	c9                   	leave  
 49a:	c3                   	ret    

0000049b <strchr>:

char*
strchr(const char *s, char c)
{
 49b:	55                   	push   %ebp
 49c:	89 e5                	mov    %esp,%ebp
 49e:	83 ec 04             	sub    $0x4,%esp
 4a1:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a4:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 4a7:	eb 14                	jmp    4bd <strchr+0x22>
    if(*s == c)
 4a9:	8b 45 08             	mov    0x8(%ebp),%eax
 4ac:	0f b6 00             	movzbl (%eax),%eax
 4af:	3a 45 fc             	cmp    -0x4(%ebp),%al
 4b2:	75 05                	jne    4b9 <strchr+0x1e>
      return (char*)s;
 4b4:	8b 45 08             	mov    0x8(%ebp),%eax
 4b7:	eb 13                	jmp    4cc <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 4b9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 4bd:	8b 45 08             	mov    0x8(%ebp),%eax
 4c0:	0f b6 00             	movzbl (%eax),%eax
 4c3:	84 c0                	test   %al,%al
 4c5:	75 e2                	jne    4a9 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 4c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
 4cc:	c9                   	leave  
 4cd:	c3                   	ret    

000004ce <gets>:

char*
gets(char *buf, int max)
{
 4ce:	55                   	push   %ebp
 4cf:	89 e5                	mov    %esp,%ebp
 4d1:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 4db:	eb 44                	jmp    521 <gets+0x53>
    cc = read(0, &c, 1);
 4dd:	83 ec 04             	sub    $0x4,%esp
 4e0:	6a 01                	push   $0x1
 4e2:	8d 45 ef             	lea    -0x11(%ebp),%eax
 4e5:	50                   	push   %eax
 4e6:	6a 00                	push   $0x0
 4e8:	e8 46 01 00 00       	call   633 <read>
 4ed:	83 c4 10             	add    $0x10,%esp
 4f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 4f3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4f7:	7f 02                	jg     4fb <gets+0x2d>
      break;
 4f9:	eb 31                	jmp    52c <gets+0x5e>
    buf[i++] = c;
 4fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4fe:	8d 50 01             	lea    0x1(%eax),%edx
 501:	89 55 f4             	mov    %edx,-0xc(%ebp)
 504:	89 c2                	mov    %eax,%edx
 506:	8b 45 08             	mov    0x8(%ebp),%eax
 509:	01 c2                	add    %eax,%edx
 50b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 50f:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 511:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 515:	3c 0a                	cmp    $0xa,%al
 517:	74 13                	je     52c <gets+0x5e>
 519:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 51d:	3c 0d                	cmp    $0xd,%al
 51f:	74 0b                	je     52c <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 521:	8b 45 f4             	mov    -0xc(%ebp),%eax
 524:	83 c0 01             	add    $0x1,%eax
 527:	3b 45 0c             	cmp    0xc(%ebp),%eax
 52a:	7c b1                	jl     4dd <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 52c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 52f:	8b 45 08             	mov    0x8(%ebp),%eax
 532:	01 d0                	add    %edx,%eax
 534:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 537:	8b 45 08             	mov    0x8(%ebp),%eax
}
 53a:	c9                   	leave  
 53b:	c3                   	ret    

0000053c <stat>:

int
stat(char *n, struct stat *st)
{
 53c:	55                   	push   %ebp
 53d:	89 e5                	mov    %esp,%ebp
 53f:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 542:	83 ec 08             	sub    $0x8,%esp
 545:	6a 00                	push   $0x0
 547:	ff 75 08             	pushl  0x8(%ebp)
 54a:	e8 0c 01 00 00       	call   65b <open>
 54f:	83 c4 10             	add    $0x10,%esp
 552:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 555:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 559:	79 07                	jns    562 <stat+0x26>
    return -1;
 55b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 560:	eb 25                	jmp    587 <stat+0x4b>
  r = fstat(fd, st);
 562:	83 ec 08             	sub    $0x8,%esp
 565:	ff 75 0c             	pushl  0xc(%ebp)
 568:	ff 75 f4             	pushl  -0xc(%ebp)
 56b:	e8 03 01 00 00       	call   673 <fstat>
 570:	83 c4 10             	add    $0x10,%esp
 573:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 576:	83 ec 0c             	sub    $0xc,%esp
 579:	ff 75 f4             	pushl  -0xc(%ebp)
 57c:	e8 c2 00 00 00       	call   643 <close>
 581:	83 c4 10             	add    $0x10,%esp
  return r;
 584:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 587:	c9                   	leave  
 588:	c3                   	ret    

00000589 <atoi>:

int
atoi(const char *s)
{
 589:	55                   	push   %ebp
 58a:	89 e5                	mov    %esp,%ebp
 58c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 58f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 596:	eb 25                	jmp    5bd <atoi+0x34>
    n = n*10 + *s++ - '0';
 598:	8b 55 fc             	mov    -0x4(%ebp),%edx
 59b:	89 d0                	mov    %edx,%eax
 59d:	c1 e0 02             	shl    $0x2,%eax
 5a0:	01 d0                	add    %edx,%eax
 5a2:	01 c0                	add    %eax,%eax
 5a4:	89 c1                	mov    %eax,%ecx
 5a6:	8b 45 08             	mov    0x8(%ebp),%eax
 5a9:	8d 50 01             	lea    0x1(%eax),%edx
 5ac:	89 55 08             	mov    %edx,0x8(%ebp)
 5af:	0f b6 00             	movzbl (%eax),%eax
 5b2:	0f be c0             	movsbl %al,%eax
 5b5:	01 c8                	add    %ecx,%eax
 5b7:	83 e8 30             	sub    $0x30,%eax
 5ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 5bd:	8b 45 08             	mov    0x8(%ebp),%eax
 5c0:	0f b6 00             	movzbl (%eax),%eax
 5c3:	3c 2f                	cmp    $0x2f,%al
 5c5:	7e 0a                	jle    5d1 <atoi+0x48>
 5c7:	8b 45 08             	mov    0x8(%ebp),%eax
 5ca:	0f b6 00             	movzbl (%eax),%eax
 5cd:	3c 39                	cmp    $0x39,%al
 5cf:	7e c7                	jle    598 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 5d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 5d4:	c9                   	leave  
 5d5:	c3                   	ret    

000005d6 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 5d6:	55                   	push   %ebp
 5d7:	89 e5                	mov    %esp,%ebp
 5d9:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 5dc:	8b 45 08             	mov    0x8(%ebp),%eax
 5df:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 5e2:	8b 45 0c             	mov    0xc(%ebp),%eax
 5e5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 5e8:	eb 17                	jmp    601 <memmove+0x2b>
    *dst++ = *src++;
 5ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ed:	8d 50 01             	lea    0x1(%eax),%edx
 5f0:	89 55 fc             	mov    %edx,-0x4(%ebp)
 5f3:	8b 55 f8             	mov    -0x8(%ebp),%edx
 5f6:	8d 4a 01             	lea    0x1(%edx),%ecx
 5f9:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 5fc:	0f b6 12             	movzbl (%edx),%edx
 5ff:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 601:	8b 45 10             	mov    0x10(%ebp),%eax
 604:	8d 50 ff             	lea    -0x1(%eax),%edx
 607:	89 55 10             	mov    %edx,0x10(%ebp)
 60a:	85 c0                	test   %eax,%eax
 60c:	7f dc                	jg     5ea <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 60e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 611:	c9                   	leave  
 612:	c3                   	ret    

00000613 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 613:	b8 01 00 00 00       	mov    $0x1,%eax
 618:	cd 40                	int    $0x40
 61a:	c3                   	ret    

0000061b <exit>:
SYSCALL(exit)
 61b:	b8 02 00 00 00       	mov    $0x2,%eax
 620:	cd 40                	int    $0x40
 622:	c3                   	ret    

00000623 <wait>:
SYSCALL(wait)
 623:	b8 03 00 00 00       	mov    $0x3,%eax
 628:	cd 40                	int    $0x40
 62a:	c3                   	ret    

0000062b <pipe>:
SYSCALL(pipe)
 62b:	b8 04 00 00 00       	mov    $0x4,%eax
 630:	cd 40                	int    $0x40
 632:	c3                   	ret    

00000633 <read>:
SYSCALL(read)
 633:	b8 05 00 00 00       	mov    $0x5,%eax
 638:	cd 40                	int    $0x40
 63a:	c3                   	ret    

0000063b <write>:
SYSCALL(write)
 63b:	b8 10 00 00 00       	mov    $0x10,%eax
 640:	cd 40                	int    $0x40
 642:	c3                   	ret    

00000643 <close>:
SYSCALL(close)
 643:	b8 15 00 00 00       	mov    $0x15,%eax
 648:	cd 40                	int    $0x40
 64a:	c3                   	ret    

0000064b <kill>:
SYSCALL(kill)
 64b:	b8 06 00 00 00       	mov    $0x6,%eax
 650:	cd 40                	int    $0x40
 652:	c3                   	ret    

00000653 <exec>:
SYSCALL(exec)
 653:	b8 07 00 00 00       	mov    $0x7,%eax
 658:	cd 40                	int    $0x40
 65a:	c3                   	ret    

0000065b <open>:
SYSCALL(open)
 65b:	b8 0f 00 00 00       	mov    $0xf,%eax
 660:	cd 40                	int    $0x40
 662:	c3                   	ret    

00000663 <mknod>:
SYSCALL(mknod)
 663:	b8 11 00 00 00       	mov    $0x11,%eax
 668:	cd 40                	int    $0x40
 66a:	c3                   	ret    

0000066b <unlink>:
SYSCALL(unlink)
 66b:	b8 12 00 00 00       	mov    $0x12,%eax
 670:	cd 40                	int    $0x40
 672:	c3                   	ret    

00000673 <fstat>:
SYSCALL(fstat)
 673:	b8 08 00 00 00       	mov    $0x8,%eax
 678:	cd 40                	int    $0x40
 67a:	c3                   	ret    

0000067b <link>:
SYSCALL(link)
 67b:	b8 13 00 00 00       	mov    $0x13,%eax
 680:	cd 40                	int    $0x40
 682:	c3                   	ret    

00000683 <mkdir>:
SYSCALL(mkdir)
 683:	b8 14 00 00 00       	mov    $0x14,%eax
 688:	cd 40                	int    $0x40
 68a:	c3                   	ret    

0000068b <chdir>:
SYSCALL(chdir)
 68b:	b8 09 00 00 00       	mov    $0x9,%eax
 690:	cd 40                	int    $0x40
 692:	c3                   	ret    

00000693 <dup>:
SYSCALL(dup)
 693:	b8 0a 00 00 00       	mov    $0xa,%eax
 698:	cd 40                	int    $0x40
 69a:	c3                   	ret    

0000069b <getpid>:
SYSCALL(getpid)
 69b:	b8 0b 00 00 00       	mov    $0xb,%eax
 6a0:	cd 40                	int    $0x40
 6a2:	c3                   	ret    

000006a3 <sbrk>:
SYSCALL(sbrk)
 6a3:	b8 0c 00 00 00       	mov    $0xc,%eax
 6a8:	cd 40                	int    $0x40
 6aa:	c3                   	ret    

000006ab <sleep>:
SYSCALL(sleep)
 6ab:	b8 0d 00 00 00       	mov    $0xd,%eax
 6b0:	cd 40                	int    $0x40
 6b2:	c3                   	ret    

000006b3 <uptime>:
SYSCALL(uptime)
 6b3:	b8 0e 00 00 00       	mov    $0xe,%eax
 6b8:	cd 40                	int    $0x40
 6ba:	c3                   	ret    

000006bb <createTask>:

SYSCALL(createTask)
 6bb:	b8 16 00 00 00       	mov    $0x16,%eax
 6c0:	cd 40                	int    $0x40
 6c2:	c3                   	ret    

000006c3 <startTask>:
SYSCALL(startTask)
 6c3:	b8 17 00 00 00       	mov    $0x17,%eax
 6c8:	cd 40                	int    $0x40
 6ca:	c3                   	ret    

000006cb <waitTask>:
SYSCALL(waitTask)
 6cb:	b8 18 00 00 00       	mov    $0x18,%eax
 6d0:	cd 40                	int    $0x40
 6d2:	c3                   	ret    

000006d3 <Sched>:
SYSCALL(Sched)
 6d3:	b8 19 00 00 00       	mov    $0x19,%eax
 6d8:	cd 40                	int    $0x40
 6da:	c3                   	ret    

000006db <chmod>:

SYSCALL(chmod)
 6db:	b8 1a 00 00 00       	mov    $0x1a,%eax
 6e0:	cd 40                	int    $0x40
 6e2:	c3                   	ret    

000006e3 <candprocs>:
SYSCALL(candprocs)
 6e3:	b8 1b 00 00 00       	mov    $0x1b,%eax
 6e8:	cd 40                	int    $0x40
 6ea:	c3                   	ret    

000006eb <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 6eb:	55                   	push   %ebp
 6ec:	89 e5                	mov    %esp,%ebp
 6ee:	83 ec 18             	sub    $0x18,%esp
 6f1:	8b 45 0c             	mov    0xc(%ebp),%eax
 6f4:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 6f7:	83 ec 04             	sub    $0x4,%esp
 6fa:	6a 01                	push   $0x1
 6fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
 6ff:	50                   	push   %eax
 700:	ff 75 08             	pushl  0x8(%ebp)
 703:	e8 33 ff ff ff       	call   63b <write>
 708:	83 c4 10             	add    $0x10,%esp
}
 70b:	c9                   	leave  
 70c:	c3                   	ret    

0000070d <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 70d:	55                   	push   %ebp
 70e:	89 e5                	mov    %esp,%ebp
 710:	53                   	push   %ebx
 711:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 714:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 71b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 71f:	74 17                	je     738 <printint+0x2b>
 721:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 725:	79 11                	jns    738 <printint+0x2b>
    neg = 1;
 727:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 72e:	8b 45 0c             	mov    0xc(%ebp),%eax
 731:	f7 d8                	neg    %eax
 733:	89 45 ec             	mov    %eax,-0x14(%ebp)
 736:	eb 06                	jmp    73e <printint+0x31>
  } else {
    x = xx;
 738:	8b 45 0c             	mov    0xc(%ebp),%eax
 73b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 73e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 745:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 748:	8d 41 01             	lea    0x1(%ecx),%eax
 74b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 74e:	8b 5d 10             	mov    0x10(%ebp),%ebx
 751:	8b 45 ec             	mov    -0x14(%ebp),%eax
 754:	ba 00 00 00 00       	mov    $0x0,%edx
 759:	f7 f3                	div    %ebx
 75b:	89 d0                	mov    %edx,%eax
 75d:	0f b6 80 88 0e 00 00 	movzbl 0xe88(%eax),%eax
 764:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 768:	8b 5d 10             	mov    0x10(%ebp),%ebx
 76b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 76e:	ba 00 00 00 00       	mov    $0x0,%edx
 773:	f7 f3                	div    %ebx
 775:	89 45 ec             	mov    %eax,-0x14(%ebp)
 778:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 77c:	75 c7                	jne    745 <printint+0x38>
  if(neg)
 77e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 782:	74 0e                	je     792 <printint+0x85>
    buf[i++] = '-';
 784:	8b 45 f4             	mov    -0xc(%ebp),%eax
 787:	8d 50 01             	lea    0x1(%eax),%edx
 78a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 78d:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 792:	eb 1d                	jmp    7b1 <printint+0xa4>
    putc(fd, buf[i]);
 794:	8d 55 dc             	lea    -0x24(%ebp),%edx
 797:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79a:	01 d0                	add    %edx,%eax
 79c:	0f b6 00             	movzbl (%eax),%eax
 79f:	0f be c0             	movsbl %al,%eax
 7a2:	83 ec 08             	sub    $0x8,%esp
 7a5:	50                   	push   %eax
 7a6:	ff 75 08             	pushl  0x8(%ebp)
 7a9:	e8 3d ff ff ff       	call   6eb <putc>
 7ae:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 7b1:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 7b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7b9:	79 d9                	jns    794 <printint+0x87>
    putc(fd, buf[i]);
}
 7bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 7be:	c9                   	leave  
 7bf:	c3                   	ret    

000007c0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 7c0:	55                   	push   %ebp
 7c1:	89 e5                	mov    %esp,%ebp
 7c3:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 7c6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 7cd:	8d 45 0c             	lea    0xc(%ebp),%eax
 7d0:	83 c0 04             	add    $0x4,%eax
 7d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 7d6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 7dd:	e9 59 01 00 00       	jmp    93b <printf+0x17b>
    c = fmt[i] & 0xff;
 7e2:	8b 55 0c             	mov    0xc(%ebp),%edx
 7e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e8:	01 d0                	add    %edx,%eax
 7ea:	0f b6 00             	movzbl (%eax),%eax
 7ed:	0f be c0             	movsbl %al,%eax
 7f0:	25 ff 00 00 00       	and    $0xff,%eax
 7f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 7f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7fc:	75 2c                	jne    82a <printf+0x6a>
      if(c == '%'){
 7fe:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 802:	75 0c                	jne    810 <printf+0x50>
        state = '%';
 804:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 80b:	e9 27 01 00 00       	jmp    937 <printf+0x177>
      } else {
        putc(fd, c);
 810:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 813:	0f be c0             	movsbl %al,%eax
 816:	83 ec 08             	sub    $0x8,%esp
 819:	50                   	push   %eax
 81a:	ff 75 08             	pushl  0x8(%ebp)
 81d:	e8 c9 fe ff ff       	call   6eb <putc>
 822:	83 c4 10             	add    $0x10,%esp
 825:	e9 0d 01 00 00       	jmp    937 <printf+0x177>
      }
    } else if(state == '%'){
 82a:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 82e:	0f 85 03 01 00 00    	jne    937 <printf+0x177>
      if(c == 'd'){
 834:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 838:	75 1e                	jne    858 <printf+0x98>
        printint(fd, *ap, 10, 1);
 83a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 83d:	8b 00                	mov    (%eax),%eax
 83f:	6a 01                	push   $0x1
 841:	6a 0a                	push   $0xa
 843:	50                   	push   %eax
 844:	ff 75 08             	pushl  0x8(%ebp)
 847:	e8 c1 fe ff ff       	call   70d <printint>
 84c:	83 c4 10             	add    $0x10,%esp
        ap++;
 84f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 853:	e9 d8 00 00 00       	jmp    930 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 858:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 85c:	74 06                	je     864 <printf+0xa4>
 85e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 862:	75 1e                	jne    882 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 864:	8b 45 e8             	mov    -0x18(%ebp),%eax
 867:	8b 00                	mov    (%eax),%eax
 869:	6a 00                	push   $0x0
 86b:	6a 10                	push   $0x10
 86d:	50                   	push   %eax
 86e:	ff 75 08             	pushl  0x8(%ebp)
 871:	e8 97 fe ff ff       	call   70d <printint>
 876:	83 c4 10             	add    $0x10,%esp
        ap++;
 879:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 87d:	e9 ae 00 00 00       	jmp    930 <printf+0x170>
      } else if(c == 's'){
 882:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 886:	75 43                	jne    8cb <printf+0x10b>
        s = (char*)*ap;
 888:	8b 45 e8             	mov    -0x18(%ebp),%eax
 88b:	8b 00                	mov    (%eax),%eax
 88d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 890:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 894:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 898:	75 07                	jne    8a1 <printf+0xe1>
          s = "(null)";
 89a:	c7 45 f4 de 0b 00 00 	movl   $0xbde,-0xc(%ebp)
        while(*s != 0){
 8a1:	eb 1c                	jmp    8bf <printf+0xff>
          putc(fd, *s);
 8a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a6:	0f b6 00             	movzbl (%eax),%eax
 8a9:	0f be c0             	movsbl %al,%eax
 8ac:	83 ec 08             	sub    $0x8,%esp
 8af:	50                   	push   %eax
 8b0:	ff 75 08             	pushl  0x8(%ebp)
 8b3:	e8 33 fe ff ff       	call   6eb <putc>
 8b8:	83 c4 10             	add    $0x10,%esp
          s++;
 8bb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 8bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c2:	0f b6 00             	movzbl (%eax),%eax
 8c5:	84 c0                	test   %al,%al
 8c7:	75 da                	jne    8a3 <printf+0xe3>
 8c9:	eb 65                	jmp    930 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 8cb:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 8cf:	75 1d                	jne    8ee <printf+0x12e>
        putc(fd, *ap);
 8d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8d4:	8b 00                	mov    (%eax),%eax
 8d6:	0f be c0             	movsbl %al,%eax
 8d9:	83 ec 08             	sub    $0x8,%esp
 8dc:	50                   	push   %eax
 8dd:	ff 75 08             	pushl  0x8(%ebp)
 8e0:	e8 06 fe ff ff       	call   6eb <putc>
 8e5:	83 c4 10             	add    $0x10,%esp
        ap++;
 8e8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8ec:	eb 42                	jmp    930 <printf+0x170>
      } else if(c == '%'){
 8ee:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8f2:	75 17                	jne    90b <printf+0x14b>
        putc(fd, c);
 8f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8f7:	0f be c0             	movsbl %al,%eax
 8fa:	83 ec 08             	sub    $0x8,%esp
 8fd:	50                   	push   %eax
 8fe:	ff 75 08             	pushl  0x8(%ebp)
 901:	e8 e5 fd ff ff       	call   6eb <putc>
 906:	83 c4 10             	add    $0x10,%esp
 909:	eb 25                	jmp    930 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 90b:	83 ec 08             	sub    $0x8,%esp
 90e:	6a 25                	push   $0x25
 910:	ff 75 08             	pushl  0x8(%ebp)
 913:	e8 d3 fd ff ff       	call   6eb <putc>
 918:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 91b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 91e:	0f be c0             	movsbl %al,%eax
 921:	83 ec 08             	sub    $0x8,%esp
 924:	50                   	push   %eax
 925:	ff 75 08             	pushl  0x8(%ebp)
 928:	e8 be fd ff ff       	call   6eb <putc>
 92d:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 930:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 937:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 93b:	8b 55 0c             	mov    0xc(%ebp),%edx
 93e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 941:	01 d0                	add    %edx,%eax
 943:	0f b6 00             	movzbl (%eax),%eax
 946:	84 c0                	test   %al,%al
 948:	0f 85 94 fe ff ff    	jne    7e2 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 94e:	c9                   	leave  
 94f:	c3                   	ret    

00000950 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 950:	55                   	push   %ebp
 951:	89 e5                	mov    %esp,%ebp
 953:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 956:	8b 45 08             	mov    0x8(%ebp),%eax
 959:	83 e8 08             	sub    $0x8,%eax
 95c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 95f:	a1 b4 0e 00 00       	mov    0xeb4,%eax
 964:	89 45 fc             	mov    %eax,-0x4(%ebp)
 967:	eb 24                	jmp    98d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 969:	8b 45 fc             	mov    -0x4(%ebp),%eax
 96c:	8b 00                	mov    (%eax),%eax
 96e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 971:	77 12                	ja     985 <free+0x35>
 973:	8b 45 f8             	mov    -0x8(%ebp),%eax
 976:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 979:	77 24                	ja     99f <free+0x4f>
 97b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 97e:	8b 00                	mov    (%eax),%eax
 980:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 983:	77 1a                	ja     99f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 985:	8b 45 fc             	mov    -0x4(%ebp),%eax
 988:	8b 00                	mov    (%eax),%eax
 98a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 98d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 990:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 993:	76 d4                	jbe    969 <free+0x19>
 995:	8b 45 fc             	mov    -0x4(%ebp),%eax
 998:	8b 00                	mov    (%eax),%eax
 99a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 99d:	76 ca                	jbe    969 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 99f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9a2:	8b 40 04             	mov    0x4(%eax),%eax
 9a5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9af:	01 c2                	add    %eax,%edx
 9b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b4:	8b 00                	mov    (%eax),%eax
 9b6:	39 c2                	cmp    %eax,%edx
 9b8:	75 24                	jne    9de <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 9ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9bd:	8b 50 04             	mov    0x4(%eax),%edx
 9c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c3:	8b 00                	mov    (%eax),%eax
 9c5:	8b 40 04             	mov    0x4(%eax),%eax
 9c8:	01 c2                	add    %eax,%edx
 9ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9cd:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 9d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9d3:	8b 00                	mov    (%eax),%eax
 9d5:	8b 10                	mov    (%eax),%edx
 9d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9da:	89 10                	mov    %edx,(%eax)
 9dc:	eb 0a                	jmp    9e8 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 9de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e1:	8b 10                	mov    (%eax),%edx
 9e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9e6:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 9e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9eb:	8b 40 04             	mov    0x4(%eax),%eax
 9ee:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9f8:	01 d0                	add    %edx,%eax
 9fa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9fd:	75 20                	jne    a1f <free+0xcf>
    p->s.size += bp->s.size;
 9ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a02:	8b 50 04             	mov    0x4(%eax),%edx
 a05:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a08:	8b 40 04             	mov    0x4(%eax),%eax
 a0b:	01 c2                	add    %eax,%edx
 a0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a10:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 a13:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a16:	8b 10                	mov    (%eax),%edx
 a18:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a1b:	89 10                	mov    %edx,(%eax)
 a1d:	eb 08                	jmp    a27 <free+0xd7>
  } else
    p->s.ptr = bp;
 a1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a22:	8b 55 f8             	mov    -0x8(%ebp),%edx
 a25:	89 10                	mov    %edx,(%eax)
  freep = p;
 a27:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a2a:	a3 b4 0e 00 00       	mov    %eax,0xeb4
}
 a2f:	c9                   	leave  
 a30:	c3                   	ret    

00000a31 <morecore>:

static Header*
morecore(uint nu)
{
 a31:	55                   	push   %ebp
 a32:	89 e5                	mov    %esp,%ebp
 a34:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 a37:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 a3e:	77 07                	ja     a47 <morecore+0x16>
    nu = 4096;
 a40:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a47:	8b 45 08             	mov    0x8(%ebp),%eax
 a4a:	c1 e0 03             	shl    $0x3,%eax
 a4d:	83 ec 0c             	sub    $0xc,%esp
 a50:	50                   	push   %eax
 a51:	e8 4d fc ff ff       	call   6a3 <sbrk>
 a56:	83 c4 10             	add    $0x10,%esp
 a59:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a5c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a60:	75 07                	jne    a69 <morecore+0x38>
    return 0;
 a62:	b8 00 00 00 00       	mov    $0x0,%eax
 a67:	eb 26                	jmp    a8f <morecore+0x5e>
  hp = (Header*)p;
 a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a72:	8b 55 08             	mov    0x8(%ebp),%edx
 a75:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a7b:	83 c0 08             	add    $0x8,%eax
 a7e:	83 ec 0c             	sub    $0xc,%esp
 a81:	50                   	push   %eax
 a82:	e8 c9 fe ff ff       	call   950 <free>
 a87:	83 c4 10             	add    $0x10,%esp
  return freep;
 a8a:	a1 b4 0e 00 00       	mov    0xeb4,%eax
}
 a8f:	c9                   	leave  
 a90:	c3                   	ret    

00000a91 <malloc>:

void*
malloc(uint nbytes)
{
 a91:	55                   	push   %ebp
 a92:	89 e5                	mov    %esp,%ebp
 a94:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a97:	8b 45 08             	mov    0x8(%ebp),%eax
 a9a:	83 c0 07             	add    $0x7,%eax
 a9d:	c1 e8 03             	shr    $0x3,%eax
 aa0:	83 c0 01             	add    $0x1,%eax
 aa3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 aa6:	a1 b4 0e 00 00       	mov    0xeb4,%eax
 aab:	89 45 f0             	mov    %eax,-0x10(%ebp)
 aae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 ab2:	75 23                	jne    ad7 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 ab4:	c7 45 f0 ac 0e 00 00 	movl   $0xeac,-0x10(%ebp)
 abb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 abe:	a3 b4 0e 00 00       	mov    %eax,0xeb4
 ac3:	a1 b4 0e 00 00       	mov    0xeb4,%eax
 ac8:	a3 ac 0e 00 00       	mov    %eax,0xeac
    base.s.size = 0;
 acd:	c7 05 b0 0e 00 00 00 	movl   $0x0,0xeb0
 ad4:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ad7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ada:	8b 00                	mov    (%eax),%eax
 adc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae2:	8b 40 04             	mov    0x4(%eax),%eax
 ae5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 ae8:	72 4d                	jb     b37 <malloc+0xa6>
      if(p->s.size == nunits)
 aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aed:	8b 40 04             	mov    0x4(%eax),%eax
 af0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 af3:	75 0c                	jne    b01 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 af8:	8b 10                	mov    (%eax),%edx
 afa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 afd:	89 10                	mov    %edx,(%eax)
 aff:	eb 26                	jmp    b27 <malloc+0x96>
      else {
        p->s.size -= nunits;
 b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b04:	8b 40 04             	mov    0x4(%eax),%eax
 b07:	2b 45 ec             	sub    -0x14(%ebp),%eax
 b0a:	89 c2                	mov    %eax,%edx
 b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b0f:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b15:	8b 40 04             	mov    0x4(%eax),%eax
 b18:	c1 e0 03             	shl    $0x3,%eax
 b1b:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b21:	8b 55 ec             	mov    -0x14(%ebp),%edx
 b24:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 b27:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b2a:	a3 b4 0e 00 00       	mov    %eax,0xeb4
      return (void*)(p + 1);
 b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b32:	83 c0 08             	add    $0x8,%eax
 b35:	eb 3b                	jmp    b72 <malloc+0xe1>
    }
    if(p == freep)
 b37:	a1 b4 0e 00 00       	mov    0xeb4,%eax
 b3c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 b3f:	75 1e                	jne    b5f <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 b41:	83 ec 0c             	sub    $0xc,%esp
 b44:	ff 75 ec             	pushl  -0x14(%ebp)
 b47:	e8 e5 fe ff ff       	call   a31 <morecore>
 b4c:	83 c4 10             	add    $0x10,%esp
 b4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b56:	75 07                	jne    b5f <malloc+0xce>
        return 0;
 b58:	b8 00 00 00 00       	mov    $0x0,%eax
 b5d:	eb 13                	jmp    b72 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b62:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b65:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b68:	8b 00                	mov    (%eax),%eax
 b6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 b6d:	e9 6d ff ff ff       	jmp    adf <malloc+0x4e>
}
 b72:	c9                   	leave  
 b73:	c3                   	ret    

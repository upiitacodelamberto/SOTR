#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc,char *argv[])
{
  if(argc<3)
    exit();

  int fd;
  struct stat st;
  char *path=argv[2];
  if((fd=open(path,0))<0){
    printf(2,"chmod: cannot open %s\n",path);
    exit();
  }

  if(fstat(fd,&st)<0){
    printf(2,"chmod: cannot stat %s\n",path);
    close(fd);
    exit();
  }

  int mode=st.mode;
  close(fd);

  if(strcmp(argv[1],"-x")==0){
printf(1,"path_-x:%s, mode=%x,0x100^mode=%x\n",path,mode,0x100^mode);
    chmod(path,0x100^mode);
  }else if(strcmp(argv[1],"+x")==0){
printf(1,"path_+x:%s\n",path);
    chmod(path,0x100^mode);
  }
  exit();
}

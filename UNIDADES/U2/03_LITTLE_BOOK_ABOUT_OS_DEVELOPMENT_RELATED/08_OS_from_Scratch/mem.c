/*convinient functions for manipuling memory*/
unsigned char *memcpy1(unsigned char *dest,const unsigned char *src,int count){
  int i;
  for(i=0;i<count;i++)
    dest[i]=src[i];
  return dest;
}

unsigned char *memset1(unsigned char *dest,unsigned char val,int count){
  int i;
  for(i=0;i<count;i++)
    dest[i]=val;
  return dest;
}

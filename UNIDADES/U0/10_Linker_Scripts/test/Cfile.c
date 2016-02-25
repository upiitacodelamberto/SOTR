#include <string.h>

extern char data_start[];
extern char data_size[];
extern char data_load_start[];

void copy_data(void){
  if(data_start!=data_load_start){
    memcpy(data_start,data_load_start,(size_t)data_size);
  }
}


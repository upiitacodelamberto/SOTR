#include "types.h"
#include "mem.h"
#include "basicio.h"

#define COLOURS  0xF0
#define COLS  80
#define ROWS  25
#define VGA_START  0xB8000
#define PRINTABLE(c)  (c>=' ') /*is this a printable character*/

uint16_t *Scrn;  /*Screen area*/
int Curx=0,Cury=0;  /*current cursor cordinates*/
uint16_t EmptySpace=COLOURS<<8|0x20; /*0x20 is ascii value of space*/

/*scroll the screen (a 'copy and blank' operation)*/
void scroll(void){
  int dist=Cury-ROWS+1;
  if(dist>0){
    uint8_t *newstart=((uint8_t*)Scrn)+dist*COLS*2;
    int bytesToCopy=(ROWS-dist)*COLS*2;
    uint16_t *newblankstart=Scrn+(ROWS-dist)*COLS;
    int bytesToBlank=dist*COLS*2;
    memcpy1((uint8_t*)Scrn,newstart,bytesToCopy);
    memset1((uint8_t*)newblankstart,EmptySpace,bytesToBlank);
  }
}

/*Print a character on the screen*/
void putchar(uint8_t c){
  uint16_t *addr;
  
  /*first handle a few special characters*/
  /*tab -> move cursor in steps of 4*/
  if(c=='\t')Curx=((Curx+4)/4)*4;
  /*carriage return->reset x pos*/
  else if(c=='\r')Curx=0;
  /*newline:reset x pos and go to newline*/
  else if(c=='\n'){
    Curx=0;
    Cury++;
  }
  /*backspace->cursor moves left*/
  else if(c==0x08 && Curx!=0)Curx--;
  /*finally, if a normal character, print it*/
  else if(PRINTABLE(c)){
    addr=Scrn+(Cury*COLS+Curx);
    *addr=(COLOURS<<8)|c;
    Curx++;
  }
  /*if we have reached the end of the line, move to the next*/
  if(Curx>=COLS){
    Curx=0;
    Cury++;
  }
  /*also scroll if needed*/
  scroll();
}

/*print a longer string*/
void puts(unsigned char *str){
  while(*str){putchar(*str); str++;}
}

/*clear the screen*/
void clear(){
  int i;
  for(i=0;i<ROWS*COLS;i++)
    putchar(' ');
  Curx=Cury=0;
}

//init and clear screen
void vga_init(void){
  Scrn=(unsigned short*)VGA_START;
  clear();
}

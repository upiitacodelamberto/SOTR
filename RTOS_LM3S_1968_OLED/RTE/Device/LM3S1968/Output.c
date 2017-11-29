// Output.c
// Runs on LM3S1968
// Implement the fputc() function in stdio.h to enable useful
// functions such as printf() to write text to the onboard
// organic LED display.  Remember that the OLED is vulnerable
// to screen image "burn-in" like old CRT monitors, so be sure
// to turn the OLED off when it is not in use.
// Daniel Valvano
// July 28, 2011

/* This example accompanies the book
   "Embedded Systems: Real Time Interfacing to the Arm Cortex M3",
   ISBN: 978-1463590154, Jonathan Valvano, copyright (c) 2011
   Section 3.4.5

 Copyright 2011 by Jonathan W. Valvano, valvano@mail.utexas.edu
    You may use, edit, run or distribute this file
    as long as the above copyright notice remains
 THIS SOFTWARE IS PROVIDED "AS IS".  NO WARRANTIES, WHETHER EXPRESS, IMPLIED
 OR STATUTORY, INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE APPLY TO THIS SOFTWARE.
 VALVANO SHALL NOT, IN ANY CIRCUMSTANCES, BE LIABLE FOR SPECIAL, INCIDENTAL,
 OR CONSEQUENTIAL DAMAGES, FOR ANY REASON WHATSOEVER.
 For more information about my classes, my research, and my books, see
 http://users.ece.utexas.edu/~valvano/
 */

#include <stdio.h>
#include "rit128x96x4.h"
#include "Output.h"

#include "inc/hw_types.h"
#include "driverlib/debug.h"
#include "driverlib/sysctl.h"
#include "driverlib/rit128x96x4.h"

#define CHARCOLS                6    // a character is 6 columns wide (right column blank)
#define CHARROWS                8    // a character is 8 rows tall (bottom row blank)
#define TOTALCHARCOLUMNS        21   // (128 pixels)/(6 pixels/char) columns
#define TOTALCHARROWS           12   // (96 pixels)/(8 pixels/char) rows
#define WRAP                    1    // automatically wrap to next line

// Cursor x-position [0:126] of next character
static unsigned short CursorX = 0;
// Cursor y-position [0:88] of next character
static unsigned short CursorY = 0;
// Color [0:15] of next character
static unsigned char Color = 15;
// Character 2-D array of the screen character contents
static unsigned char CharBuffer[TOTALCHARROWS][TOTALCHARCOLUMNS];
// Color 2-D array of the screen color contents
static unsigned char ColorBuffer[TOTALCHARROWS][TOTALCHARCOLUMNS];
// Status of OLED display (1 = on; 0 = off)
static unsigned char Status = 0;
// Shift everything up; clear last line; re-print all
void shiftEverythingUp(void){
  int i, j;
  unsigned char outStr[2];
  outStr[1] = 0;              // output string terminated with NULL
                              // put contents of line i+1 in line i and print
  for(i=0; i<(TOTALCHARROWS-1); i=i+1){ // every row but the last one
    for(j=0; j<TOTALCHARCOLUMNS; j=j+1){// every column
      CharBuffer[i][j] = CharBuffer[i+1][j];
      ColorBuffer[i][j] = ColorBuffer[i+1][j];
      outStr[0] = CharBuffer[i][j];
      RIT128x96x4StringDraw((const char *)outStr, j*CHARCOLS, i*CHARROWS, ColorBuffer[i][j]);
    }
  }
                              // clear the last line
  outStr[0] = ' ';
  for(j=0; j<TOTALCHARCOLUMNS; j=j+1){ // every column
    CharBuffer[TOTALCHARROWS-1][j] = ' ';
    ColorBuffer[TOTALCHARROWS-1][j] = Color;
    RIT128x96x4StringDraw((const char *)outStr, j*CHARCOLS, (TOTALCHARROWS-1)*CHARROWS, ColorBuffer[TOTALCHARROWS-1][j]);
  }
}
// Print a character to OLED.
int fputc(int ch, FILE *f){
  unsigned char outStr[2];
  if(Status == 0){            // verify that OLED display is on
    return EOF;               // error
  }
  if(Color > 15){             // verify 'Color' is valid
    Color = 15;
  }
  // special case characters require moving the cursor
  if((ch == BACKSPACE) && (CursorX >= CHARCOLS)){
    CursorX = CursorX - CHARCOLS;// back up one character
  }
  else if(ch == TAB){
    while(CursorX < 63){      // still on left side of screen
                              // insert spaces
      CharBuffer[CursorY/CHARROWS][CursorX/CHARCOLS] = ' ';
      ColorBuffer[CursorY/CHARROWS][CursorX/CHARCOLS] = Color;
      outStr[0] = ' ';        // build output string
      outStr[1] = 0;          // terminate with NULL
                              // print
      RIT128x96x4StringDraw((const char *)outStr, CursorX, CursorY, Color);
      CursorX = CursorX + CHARCOLS;
    }
  }
  else if((ch == LF) || (ch == HOME)){
    CursorX = 0;              // move cursor all the way left on current line
  }
  else if((ch == NEWLINE) || (ch == RETURN) || (ch == CR)){
    // fill in the remainder of the current line with spaces
    while((CursorX/CHARCOLS) < TOTALCHARCOLUMNS){
                              // insert spaces
      CharBuffer[CursorY/CHARROWS][CursorX/CHARCOLS] = ' ';
      ColorBuffer[CursorY/CHARROWS][CursorX/CHARCOLS] = Color;
      outStr[0] = ' ';        // build output string
      outStr[1] = 0;          // terminate with NULL
                              // print
      RIT128x96x4StringDraw((const char *)outStr, CursorX, CursorY, Color);
      CursorX = CursorX + CHARCOLS;
    }
    CursorX = 0;              // move cursor all the way left
    if((CursorY/CHARROWS) == (TOTALCHARROWS - 1)){
                              // on the last line
      shiftEverythingUp();
    }
    else{                     // not on the last line; go to next line
      CursorY = CursorY + CHARROWS;
    }
  }
  else{                       // regular character
                              // check if there is space to print
    if((CursorX/CHARCOLS) == TOTALCHARCOLUMNS){
                              // current line is full
      if(WRAP == 0){          // wrapping is disabled
        return EOF;           // error
      }
      else{                   // wrapping is enabled
        CursorX = 0;          // move cursor all the way left
        if((CursorY/CHARROWS) == (TOTALCHARROWS - 1)){
                              // on the last line
          shiftEverythingUp();
        }
        else{                 // not on the last line; go to next line
          CursorY = CursorY + CHARROWS;
        }
      }
    }
    outStr[0] = ch;           // build output string
    outStr[1] = 0;            // terminate with NULL
                              // print
    RIT128x96x4StringDraw((const char *)outStr, CursorX, CursorY, Color);
                              // store character in the buffer
    CharBuffer[CursorY/CHARROWS][CursorX/CHARCOLS] = ch;
    ColorBuffer[CursorY/CHARROWS][CursorX/CHARCOLS] = Color;
                              // increment cursor
    CursorX = CursorX + CHARCOLS;
  }
  return 1;
}
// No input from OLED, always return 0.
int fgetc (FILE *f){
  return 0;
}
// Function called when file error occurs.
int ferror(FILE *f){
  /* Your implementation of ferror */
  return EOF;
}
//------------Output_Init------------
// Initializes the OLED interface.
// Input: none
// Output: none
void Output_Init(void){
  int i, j;
    //
    // Set the clocking to run directly from the crystal.
    //
//    SysCtlClockSet(SYSCTL_SYSDIV_1 | SYSCTL_USE_OSC | SYSCTL_OSC_MAIN |
//                   SYSCTL_XTAL_8MHZ);
//Esta inicializacion se hizo ya en OS_Init() /* 2015.12.26 */
  RIT128x96x4Init(1000000);   // initialize OLED
  for(i=0; i<TOTALCHARROWS; i=i+1){
    for(j=0; j<TOTALCHARCOLUMNS; j=j+1){
      CharBuffer[i][j] = 0;   // clear screen contents
      ColorBuffer[i][j] = 0;
    }
  }
  CursorX = 0;                // initialize the cursors
  CursorY = 0;
  Color = 15;
  Status = 1;
}

//------------Output_Clear------------
// Clears the OLED display.
// Input: none
// Output: none
void Output_Clear(void){
  int i, j;
  RIT128x96x4Clear();         // clear the screen
  for(i=0; i<TOTALCHARROWS; i=i+1){
    for(j=0; j<TOTALCHARCOLUMNS; j=j+1){
      CharBuffer[i][j] = 0;   // clear screen contents
      ColorBuffer[i][j] = 0;
    }
  }
  CursorX = 0;                // reset the cursors
  CursorY = 0;
}

//------------Output_Off------------
// Turns off the OLED display
// Input: none
// Output: none
void Output_Off(void){        //   to prevent burn-in damage
  RIT128x96x4DisplayOff();    // turn off
  Status = 0;                 // ignore any incoming writes
}

//------------Output_On------------
// Turns on the OLED display
//  called after Output_Off to turn it back on
// Input: none
// Output: none
void Output_On(void){
  RIT128x96x4DisplayOn();     // turn on
  Status = 1;                 // resume accepting writes
}

//------------Output_Color------------
// Set the color of future characters.
// Input: 0 is off, non-zero is on
// Output: none
void Output_Color(unsigned char newColor){
  if(newColor > 15){
    Color = 15;
  }
  else{
    Color = newColor;
  }
}

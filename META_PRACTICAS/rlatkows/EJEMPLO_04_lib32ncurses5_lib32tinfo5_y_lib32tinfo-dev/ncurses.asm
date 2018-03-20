#
#___ /home/jan/assembler/include/ncurses.asm _______________________________
 # ncurses.asm          - donated to the public domain by Jan Wagemakers -
 # afgeleid van onderstaand C-programma
 # #include <curses.h>
 #
 # int main(void)
 # {
 #     initscr();  /* Init the curses libraries */
 #     move(10, 2);  /* Place the cursor at X: 2, Y: 10 */
 #     printw("Hello, World !"); /* Print anything */
 #     refresh(); /* This places the "Hello, World !" on the physical screen */
 #     getch(); /* Wait for keypress */
 #     endwin(); /* deinit the curses libraries. */
 #     return 0;
 # }
 #
 # Because I know NOT very much of C The following can be incorrect.
 # Please, do not hesitate to make corrections :-)
 # So, when you want to put something on the screen with ncurses, you call
 # the following macro's :
 #      1. _initscr
 #      2. _locate x y  (x,y = screen coordinates)
 #      3. _printw message
 #      4. _refresh
 #      5. _endwin      (end win.... sounds nice, isn't it ;-)

 .MACRO _initscr 
 # start _initscr
 call initscr
 # end   _initscr
 .ENDM
 
 .MACRO _locate x y
 # start _locate x y
 pushl \x
 pushl \y
 movl stdscr,%eax
 pushl %eax
 call wmove
 addl $12,%esp
 # end   _locate x y
 .ENDM
 
 .MACRO _printw message
 # start _print message
 pushl \message
 call printw
 addl $4,%esp
 # end   _printw message
 .ENDM
       
 .MACRO _refresh
 # start _refresh
 movl stdscr,%eax
 pushl %eax
 call wrefresh
 addl $4,%esp
 # end   _refresh
 .ENDM
 
 .MACRO _endwin
 # start _endwin
 call endwin
 # end   _endwin
 .ENDM

# Colors and ncurses. (15/07/97)
# - After _initscr , call _start_color
# - Init with _init_pair a color-pair.
# - With _use_pair select a color-pair.

 .MACRO _start_color
 # start _start_color
 call start_color
 # end   _start_color
 .ENDM
 
 .MACRO _init_pair pair foreground background
 # start _init_pair
 pushl \background
 pushl \foreground
 pushl \pair
 call init_pair
 addl $12,%esp
 # end   _init_pair
 .ENDM
 
 .MACRO _use_pair pair
 # start _use_pair
 movl \pair,%eax
 #                |        |  %ah   |  %al   |
 # %eax = xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx
 #                    |        |
 #                    |        |
 #                    |        +----> Number of color-pair
 #                    +-------------> 00 = Normaal , 20 = BOLD 
 pushl %eax
 movl stdscr,%eax
 pushl %eax
 call wattr_on
 addl $8,%esp
 #end _use_pair
 .ENDM
#___________________________________________________________________________
#
#as sat_color.s -o sat_color.o
#gcc sat_color.o -o sat_color -lncurses
#sat_color

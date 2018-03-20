#___ sat_color.s ___________________________________________________________
#
#        .include "/home/jan/assembler/include/ncurses.asm"
        .include "/home/lamberto/2017_08_A_2017_12/SOTR/META_PRACTICAS/rlatkows/EJEMPLO_04_lib32ncurses5_lib32tinfo5_y_lib32tinfo-dev/ncurses.asm"

        .globl main
main:
        _initscr
        _start_color
        _init_pair $1,$2,$4
        _init_pair $2,$0,$6
        _init_pair $3,$3,$4
        _init_pair $4,$4,$4             # Hide the flashing cursor
                
        call cls                        # clear screen/init colors.

        _use_pair $0x00000200           # 00 00(NORMAL) 02(PAIR) 00
        _locate $1,$0
        _printw $titel
        _locate $46,$0
        _printw $pd
        _use_pair  $0x00200100          # 00 20(BOLD) 01(PAIR) 00               
        _locate $32,$12
        _printw $world

        _use_pair  $0x00200300          # 00 20(BOLD) 03(PAIR) 00               
        movl $0,%esi
lus:
        movb tabel(%esi),%dl            # %dl = X(%esi)
        incl %esi
        movb tabel(%esi),%cl            # %cl = Y(%esi)
        incl %esi
        cmpb $242,%cl
        jne n242_1
        movl $0,%esi
        jmp lus
n242_1: 
        movl %esi,%edi
redo:
        movb tabel(%edi),%dh            # %dh = X(%esi + 1)
        incl %edi
        movb tabel(%edi),%ch            # %ch = Y(%esi + 1)
        cmpb $242,%ch
        jne  n242_2
        movl $0,%edi
        jmp redo
n242_2: 
        movl $leeg,%ebp
        call print_item
        movl $linux,%ebp
        movb %ch,%cl
        movb %dh,%dl
        call print_item

        pushl $160000                   # C : usleep(....);
        call usleep                     # Wacht-lus
        addl $4,%esp

        _refresh
        jmp lus
        _endwin
        ret

print_item:
        pushal
        movzbl %cl,%eax
        movzbl %dl,%ebx
        _locate %ebx,%eax
        _printw %ebp
        popal
        ret
        
cls:
        _use_pair $0x00000200           # 00 00(NORMAL) 02(PAIR) 00
                                        # Color of the first line
        movb $0,%cl
        movb $0,%dl
cls_lus:        
        movl $chr32,%ebp
        call print_item
        incb %dl
        cmpb $79,%dl
        jna cls_lus
        pushal
        _use_pair  $0x00000400          # 00 00(NORMAL) 04(PAIR) 00 
                                        # Color of the rest of the screen
        popal
        xorb %dl,%dl
        incb %cl
        cmpb $25,%cl
        jna cls_lus
        ret

linux:
 .string "Linux"
leeg:
 .string "     "
chr32:
 .string " "
world:
 .string "World Domination"
titel:
 .string "sat_color.s - 1997 Jan Wagemakers -"
pd:
 .string "Donated to the Public Domain :-)"
tabel:
 .include "cirkel.dat"
 .byte 242,242

.END

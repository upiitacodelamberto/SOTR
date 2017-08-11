#baremetal
all:HOLA HOLA1

HOLA:holamundoC.o exit.o 
	ld -m elf_i386 -e main $^ -o $@

holamundoC.o:holamundoC.c
	gcc -m32 -c $^ -o $@

exit.o:exit.s
	as --32 $^ -o exit.o


HOLA1:holamundoC.o exit.o 
	ld -m elf_i386  $^ -o $@

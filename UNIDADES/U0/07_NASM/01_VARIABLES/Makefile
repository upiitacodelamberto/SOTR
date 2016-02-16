CC=gcc
AS=nasm

all:CyASM CyASM1

CyASM:start.c nuevo.asm
	${CC} -c start.c
	${AS} -f elf64 -l nuevo.lst nuevo.asm
	${CC} start.o nuevo.o -o $@

CyASM1:start1.c nuevo1.asm
	${CC} -c start1.c
	${AS} -f elf64 -l nuevo1.lst nuevo1.asm
	${CC} start1.o nuevo1.o -o $@

MostrarObjStart:
	objdump -Sr start.o

MostrarObjNuevo:
	objdump -Sr nuevo.o

clean:
	rm -v *.o *.lst CyASM CyASM1

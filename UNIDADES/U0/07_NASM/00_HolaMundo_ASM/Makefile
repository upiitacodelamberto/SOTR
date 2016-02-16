CC=gcc
AS=nasm

all:hello

hello:hello.asm
	${AS} -f elf64 -l $@.lst $<
	${CC} $@.o -o $@

clean:
	rm -v hello.o hello.lst hello

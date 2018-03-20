all:hello2

hello2:hello2.o
	ld -m elf_i386 -e _hw hello2.o -o hello2

hello2.o:hello2.s
	as --32 hello2.s -o hello2.o

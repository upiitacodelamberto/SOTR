all:hello1

hello1:hello1.o
	gcc -m32 hello1.o -o hello1

hello1.o:hello1.s
	as --32 hello1.s -o hello1.o

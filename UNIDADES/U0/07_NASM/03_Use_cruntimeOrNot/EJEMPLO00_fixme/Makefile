#Makefile
all:prog sections_of_maindoto sections_ofprog
main.o:main.c
	gcc -m32 -c main.c

prog:main.o
	ld -o prog -T my_script.lds main.o

sections_of_maindoto:main.o
	objdump -h $<

sections_ofprog:prog
	objdump -h $<

clean:
	rm -v main.o prog

all:prog2 sections_of_main2doto sections_ofprog2

main2.o:main2.c
	gcc -m32 -c main2.c

prog2:main2.o
	ld -o prog2 -T my_script.lds main2.o

sections_of_main2doto:main2.o
	objdump -h $<

sections_ofprog2:prog2
	objdump -h $<

clean:
	rm -v main2.o prog2


#./prog2 ; echo $?

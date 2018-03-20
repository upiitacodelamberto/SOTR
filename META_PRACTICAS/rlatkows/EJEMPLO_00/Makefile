all:hello




hello:hello.asm
	nasm -f elf hello.asm
	gcc -m32 hello.o -o $@

clean:
	rm -vf hello hello.o

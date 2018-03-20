all:hello

hello:Hello-World.asm
	nasm -f elf Hello-World.asm -o Hello-World.o
	gcc -m32 Hello-World.o -o hello

hello1:hello.s
	as --32 -o hello.o hello.s
	gcc -m32 -o hello1 hello.o

hello2:Hello-World.asm hello.s
	as --32 -o hello.o hello.s
	nasm -f elf -o Hello-World.o Hello-World.asm
	gcc -m32 -o hello2 hello.o Hello-World.o

clean:
	rm -vf hello hello1 hello2 *.o


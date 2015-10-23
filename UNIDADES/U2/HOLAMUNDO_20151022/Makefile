CC=gcc
CFLAGS=-m32
all:testHola_64 testHola_32
testHola_64:hola_mundo.c
	${CC} $< -o $@

testHola_32:hola_mundo.c
	${CC} ${CFLAGS} $< -o $@


clean:
	rm -v testHola_64 testHola_32

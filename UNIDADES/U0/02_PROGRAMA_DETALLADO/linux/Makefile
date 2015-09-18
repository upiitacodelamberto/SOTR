#makefile para compilar:
#temario_sotr y temario_vision
CC = gcc
RM = rm
all:temario_sotr temario_vision

temario_sotr:main.o progdetallado.o sotr.o
	${CC} main.o progdetallado.o sotr.o -o $@

temario_vision:main.o progdetallado.o visionartificial.o
	${CC} main.o progdetallado.o visionartificial.o -o $@

#.PHONY
clean:
	${RM} *.o temario_sotr temario_vision

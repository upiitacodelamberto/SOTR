#makefile para compilar:
#temario_sotr y temario_vision
CC = gcc
RM = rm
all:temario_sotr temario_vision temario_progavanzada

temario_sotr:main.o progdetallado.o sotr.o
	${CC} main.o progdetallado.o sotr.o -o $@

temario_vision:main.o progdetallado.o visionartificial.o
	${CC} main.o progdetallado.o visionartificial.o -o $@

temario_progavanzada:main.o progdetallado.o progavanzada.o
	${CC} main.o progdetallado.o progavanzada.o -o $@

#.PHONY
clean:
	${RM} -vf *.o temario_sotr temario_vision temario_progavanzada

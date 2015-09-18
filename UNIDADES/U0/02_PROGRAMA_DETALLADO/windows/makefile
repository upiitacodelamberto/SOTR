#makefile para compilar:
#temario_sotr.exe y temario_vision.exe
CC = gcc.exe
RM = rm.exe
all:temario_sotr.exe temario_vision.exe

temario_sotr.exe:main.o progdetallado.o sotr.o
	${CC} main.o progdetallado.o sotr.o -o $@

temario_vision.exe:main.o progdetallado.o visionartificial.o
	${CC} main.o progdetallado.o visionartificial.o -o $@

#.PHONY
clean:
	${RM} *.o temario_sotr.exe temario_vision.exe

#makefile para compilar:
#temario_sotr.exe y temario_vision.exe
CPP=g++.exe
CC = gcc.exe
RM = rm.exe
all:Weak.exe

Weak.exe:main.o cpp2.o cpp3.o
	${CPP} main.o cpp2.o cpp3.o -o $@


#.PHONY
clean:
	${RM} *.o Weak.exe


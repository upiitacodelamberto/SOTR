numvar_dargs: programa_13_9.o
	gcc programa_13_9.o -o $@
	make clean


numvar_dargs_debug: CPPFLAGS += -DDEBUG
numvar_dargs_debug: programa_13_9.o
	gcc programa_13_9.o -o $@
	make clean

clean:
	rm -v programa_13_9.o

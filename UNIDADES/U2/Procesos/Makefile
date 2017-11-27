CC=gcc
all:ejecutar
ejecutar:creashm adjuntashm
	./creashm|./adjuntashm
#	./adjuntashm

creashm:creashm.c
	$(CC) $< -o $@

adjuntashm:adjuntashm.c
	$(CC) $< -o $@

clean:
	rm -vf creashm adjuntashm

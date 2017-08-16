AS=as
ASFLAGS=--32
CC=gcc
#CFLAGS=-fno-builtin -m32 -c
# If you are using a linux distribution based on Ubuntu, instead of 
# the previous line use:
CFLAGS=-fno-stack-protector -fno-builtin -m32 -c

LD=ld
LDFLAGS=-m elf_i386 -s -e main 

BIN=testprintf

all:$(BIN)

$(BIN):TestPrintf.o exit.o putc.o printf.o
	$(LD) $(LDFLAGS) $^ -o $@

TestPrintf.o:TestPrintf.c
	$(CC) $(CFLAGS) $< -o $@

printf.o:printf.c
	$(CC) $(CFLAGS) $< -o $@

exit.o:exit.s
	$(AS) $(ASFLAGS) $< -o $@

putc.o:putc.s
	$(AS) $(ASFLAGS) $< -o $@


clean:
	rm -v *.o $(BIN)

run:
	./run.sh $(BIN)

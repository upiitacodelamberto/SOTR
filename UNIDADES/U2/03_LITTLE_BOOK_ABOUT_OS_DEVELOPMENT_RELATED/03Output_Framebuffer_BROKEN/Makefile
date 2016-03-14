#OBJECTS = loader.o io.o lgdt.o gdt.o device.o serial.o fb.o kmain.o
#OBJECTS = bootasm.o kmain.o
OBJECTS = start.o kmain.o meminit.o panic.o memcpy.o intr.o icu.o initialize.o resume.o create.o resched.o getstk.o newqueue.o bufinit.o clkinit.o init.o ready.o getpid.o userret.o queue.o ctxsw.o clkdisp.o insert.o kill.o getitem.o xdone.o send.o close.o freemem.o unsleep.o kprintf.o evec.o main.o recvclr.o shell.o receive.o read.o lexan.o open.o addargs.o platinit.o pci.o early_imr.o quark_irq.o strncpy.o conf.o ttyinit.o ttyread.o ttywrite.o ttycontrol.o ttygetc.o ttyputc.o ttydispatch.o ionull.o ioerr.o semcreate.o ttykickout.o semcount.o wait.o signal.o clkhandler.o doprnt.o sleep.o yield.o insertd.o sprintf.o fprintf.o control.o xsh_argecho.o xsh_arp.o
CC = gcc
#AS = gas
LD = ld
#CFLAGS = -I . -m32 -nostdlib -nostdinc -fno-builtin -fno-stack-protector \
#         -nostartfiles -nodefaultlibs -Wall -Wextra -c
##         -nostartfiles -nodefaultlibs -Wall -Wextra -Werror -c
#CFLAGS = -fno-pic -static -fno-builtin -fno-strict-aliasing -fvar-tracking -fvar-tracking-assignments -O0 -g -Wall -MD -gdwarf-2 -m32 -Werror -fno-omit-frame-pointer -fno-stack-protector -fno-pic -nostdinc -I. -c
CFLAGS = -march=i586 -m32 -fno-builtin -fno-stack-protector -nostdlib -c -Wall -O0 -DBSDURG -I.
ASFLAGS = -m32 -gdwarf-2 -Wa,-divide
LDFLAGS = -T link.ld -melf_i386
#LDFLAGS = -T kernel.ld -melf_i386
#LDFLAGS += -m $(shell $(LD) -V | grep elf_i386 2>/dev/null)
#AS = nasm
ASFLAGS = -f elf 

all: kernel.elf

kernel.elf: $(OBJECTS)
	ld $(LDFLAGS) $(OBJECTS) -o kernel.elf
#	$(LD) $(LDFLAGS) -T link.ld -o kernel entry.o $(OBJS) -b binary initcode entryother

tags: $(OBJECTS) entryother.S _init
	etags *.S *.c

bootasm.o:bootasm.S
	$(CC) $(CFLAGS) bootasm.S

start.o: start.S
	${CC} ${CFLAGS} -o start.o ./start.S

intr.o: intr.S
	${CC} ${CFLAGS} -o intr.o ./intr.S

icu.o:icu.s
	${CC} ${CFLAGS} -o icu.o ./icu.s

clkdisp.o: clkdisp.S
	${CC} ${CFLAGS} -o clkdisp.o ./clkdisp.S

ctxsw.o:ctxsw.S
	${CC} ${CFLAGS} -o ctxsw.o ./ctxsw.S

ttydispatch.o: ttydispatch.S
	${CC} ${CFLAGS} -o ttydispatch.o ./ttydispatch.S

os.iso: kernel.elf
	cp -v kernel.elf iso/boot/kernel.elf
	genisoimage -R				\
                    -b boot/grub/stage2_eltorito\
                    -no-emul-boot               \
                    -boot-load-size 4           \
                    -A os                       \
                    -input-charset utf8         \
                    -quiet                      \
                    -boot-info-table            \
                    -o os.iso                   \
                    iso

run: os.iso
	bochs -f bochsrc.txt -q

%.o: %.c
	$(CC) $(CFLAGS) $< -o $@

%.o: %.S
	$(AS) $(ASFLAGS) $< -o $@

clean:
	rm -rfv *.o kernel.elf os.iso

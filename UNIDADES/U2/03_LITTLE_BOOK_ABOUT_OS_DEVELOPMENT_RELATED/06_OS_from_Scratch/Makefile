OBJS = start.o\
       kernel.o\
       mem.o\
       basicio.o\
       scrn.o\
       pic.o\
       irq.o\
       interrupt.o\
       syscall_handler.o\
       kalloc.o\
       spinlock.o\
       console.o\
       string.o\
       uart.o\
       proc.o\
       file.o\
       picirq.o\
       ioapic.o\
       lapic.o\
       trapasm.o\
       vm.o\
       swtch.o\
       pipe.o\
       mp.o\
       trap.o\
       ide.o\
       kbd.o\
       syscall.o\
       sysproc.o\
       sysfile.o

CC=gcc

#ifndef CFLAGS
CFLAGS = -I . -m32 -nostdlib -nostdinc -fno-builtin -fno-stack-protector \
       -nostartfiles -nodefaultlibs -Wall -Wextra -c \
#       -g -ggdb -Wall -ansi -pedantic -ffreestanding
#endif
LDFLAGS = -melf_i386

all: kernel.elf

#kernel.elf: start.o kernel.o mem.o basicio.o scrn.o pic.o irq.o interrupt.o syscall_handler.o
kernel.elf: $(OBJS)
	ld -T link.ld $(LDFLAGS) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) $< -o $@

start.o: start.asm
	nasm -f elf start.asm -o start.o

trapasm.o: trapasm.S
	gcc -m32 -gdwarf-2 -Wa,-divide   -c -o trapasm.o trapasm.S

swtch.o: swtch.S
	gcc -m32 -gdwarf-2 -Wa,-divide   -c -o swtch.o swtch.S

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



clean:
	rm -rfv *.o kernel.elf os.iso

#
# if you want the ram-disk device, define this to be the
# size in blocks.
#
RAMDISK =  #-DRAMDISK=512
#RAMDISK =  -DRAMDISK=512

# This is a basic Makefile for setting the general configuration
include ./Makefile.header

#LDFLAGS	+= -Ttext 0 -e startup_32
LDFLAGS	+= -Ttext 0
CFLAGS	+= $(RAMDISK) -Iinclude
CPP	+= -Iinclude

#ARCHIVES=kernel/kernel.o mm/mm.o fs/fs.o
ARCHIVES=kernel/kernel.o mm/mm.o fs/fs.o
DRIVERS =kernel/blk_drv/blk_drv.a kernel/chr_drv/chr_drv.a
#MATH	=kernel/math/math.a
LIBS	=lib/lib.a

.c.o:
	$(CC) $(CFLAGS) -c -o $*.o $<

all: Image

Image: bootsect setup system
	cp -v -f system system.tmp
	$(STRIP) system.tmp
	$(OBJCOPY) -O binary -R .note -R .comment system.tmp tools/kernel
#	tools/build.sh boot/bootsect boot/setup tools/kernel Image $(ROOT_DEV)
	tools/build.sh bootsect setup tools/kernel Image $(ROOT_DEV)
	rm -v -f system.tmp
	rm -v -f tools/kernel
	sync

##boot: boot.o
##	ld -Ttext 0 -Tdata 7c00 --oformat binary boot.o -o boot
#bootsect: bootsect.o
#	ld -Ttext 0 -Tdata 7c00 --oformat binary bootsect.o -o bootsect
bootsect: bootsect.s
	$(AS) -o bootsect.o bootsect.s
	$(LD) $(LDFLAGS) -o bootsect bootsect.o
	$(OBJCOPY) -R .pdr -R .comment -R.note -S -O binary bootsect

##boot.o: boot.s
##	as boot.s -o boot.o
#bootsect.o: bootsect.s
#	as bootsect.s -o bootsect.o

##OBJS  = sched.o system_call.o traps.o asm.o fork.o \
##	panic.o printk.o vsprintf.o sys.o exit.o \
##	signal.o mktime.o who.o
#OBJS  = sched.o vsprintf.o 
#kernel.o: $(OBJS)
##	$(LD) $(LDFLAGS) -o kernel.o $(OBJS)
#	$(LD) -m elf_i386 -r -o kernel.o $(OBJS)
#	sync


kernel/math/math.a:
	@make -C kernel/math

kernel/blk_drv/blk_drv.a:
	@make -C kernel/blk_drv

kernel/chr_drv/chr_drv.a:
	@make -C kernel/chr_drv

kernel/kernel.o:
	make -C kernel

mm/mm.o:
	@make -C mm

fs/fs.o:
	make -C fs

lib/lib.a:
	@make -C lib

boot/setup: boot/setup.s
	@make setup -C boot

##kernel: kernel.o
##	ld -M -Ttext 0 -e startup_32  kernel.o -o kernel > system.map
##
##kernel.o: kernel.s
##	as kernel.s -o kernel.o
#setup: setup.o
#	ld -m elf_i386 -Ttext 0 -e startup_32 setup.o -o setup > system.map
#
#setup.o: setup.s
#	as --32 setup.s -o setup.o
setup: setup.s
	$(AS) -o setup.o setup.s
	$(LD) $(LDFLAGS) -o setup setup.o
	$(OBJCOPY) -R .pdr -R .comment -R.note -S -O binary setup

head.o:head.s
	$(AS) -o head.o head.s
#sched.o:sched.c
#	$(CC) $(CFLAGS) -c sched.c -o sched.o 

#tools/system:	boot/head.o init/main.o \
#		$(ARCHIVES) $(DRIVERS) $(MATH) $(LIBS)
system:head.o main.o $(ARCHIVES) $(DRIVERS) $(LIBS)
	$(LD) $(LDFLAGS) -e startup_32 head.o main.o $(ARCHIVES) $(DRIVERS) $(LIBS) -o system
	nm system | grep -v '\(compiled\)\|\(\.o$$\)\|\( [aU] \)\|\(\.\.ng$$\)\|\(LASH[RL]DI\)'| sort > System.map 



#clean:
#	@rm -fv boot.o kernel.o boot kernel *~
clean:
#	@rm -fv bootsect.o setup.o bootsect setup *~
	@rm -fv *.o bootsect setup *~
#	@for i in mm fs kernel lib boot; do make clean -C $$i; done 
	for i in kernel lib boot; do make clean -C $$i; done 

calltree:
ifeq ($(CALLTREE),)
	@make -C tools/calltree-2.3
endif

calltree-clean:
	@(find tools/calltree-2.3 -name "*.o" \
	-o -name "calltree" -type f | xargs -i rm -f {})

cg: callgraph
callgraph:
	@calltree -b -np -m init/main.c | tools/tree2dotx > linux-0.11.dot
	@dot -Tjpg linux-0.11.dot -o linux-0.11.jpg
 
### Dependencies:
main.o: main.c include/unistd.h include/sys/stat.h \
  include/sys/types.h include/sys/times.h include/sys/utsname.h \
  include/utime.h include/time.h include/linux/tty.h include/termios.h \
  include/linux/sched.h include/linux/head.h include/linux/fs.h \
  include/linux/mm.h include/signal.h include/asm/system.h \
  include/asm/io.h include/stddef.h include/stdarg.h include/fcntl.h

iso:Image
	cp -v -f Image ISO/iso/boot/kernel.elf
	make -C ISO

grabarCD:ISO/OS_IMAGE.iso
	wodim -sao -eject -v dev=/dev/sr0 ISO/OS_IMAGE.iso


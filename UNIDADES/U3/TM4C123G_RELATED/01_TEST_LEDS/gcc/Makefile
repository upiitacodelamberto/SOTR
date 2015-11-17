INCLUDE_DIRS:= device/include cmsis/include 
SOURCE_DIRS:=  device/source ../src

CFILES:= system_TM4C123.c main.c
ASM_FILES:= startup_ARMCM4.S



INCLUDE_FLAGS:=$(patsubst %,-I%,$(INCLUDE_DIRS)) 
TCHIP=TM4C123GH6PM
CC=/root/2015_08_A_2015_12/ARM_TIVAC_related_work_in_linux/gcc-arm-none-eabi-4_9-2015q3/bin/arm-none-eabi-gcc
#CFLAGS=-mthumb -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16 -std=c99 -g -Wall
CFLAGS=-mthumb -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16 -g -Wall
CPPFLAGS= $(INCLUDE_FLAGS) -D$(TCHIP)
#LDFLAGS=-llto_plugin -L/root/2015_08_A_2015_12/ARM_TIVAC_related_work_in_linux/01_TEST_LEDS/gcc/lib/
vpath %.h $(INCLUDE_DIRS)
vpath %.c $(SOURCE_DIRS)
vpath %.S device/source
vpath %.o objects

COBJECTS:= $(patsubst %.c,%.o,$(CFILES)) 
ASMOBJECTS:= $(patsubst %.S,%.o,$(ASM_FILES))

all: salida.elf 
objects:
	mkdir objects
salida.elf: objects $(COBJECTS) $(ASMOBJECTS)
	$(CC) $(CFLAGS) -Ldevice -Tgcc_arm.ld objects/*.o  -o $@
$(COBJECTS): %.o: %.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o objects/$@
$(ASMOBJECTS): %.o: %.S
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o objects/$@

.PHONY: clean rebuild burn debug
clean:
	rm -fv  *.elf
	rm -frv objects
rebuild: clean all
burn: salida.elf
	openocd -fboard/ek-tm4c123gxl.cfg -c"init" -c"reset" -c"sleep 300" -c"reset halt" -c"sleep 300" -c"flash write_image erase salida.elf 0x00 elf" -c"reset" -c"shutdown"
debug: salida.elf 
	openocd -fboard/ek-tm4c123gxl.cfg -lmyLog &
	sleep 1
	! echo "reset" | telnet localhost 4444
	! echo "reset halt" | telnet localhost 4444
	arm-none-eabi-gdb --tui --eval-command="target remote localhost:3333" salida.elf	
debugClose: myLog
	! echo "reset" | telnet localhost 4444
	! echo "shutdown" | telnet localhost 4444
	rm -f myLog

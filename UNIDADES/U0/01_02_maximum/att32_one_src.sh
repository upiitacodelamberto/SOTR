#!/bin/sh
as --32 $1.s -o $1.o
echo "as --32 $1.s -o $1.o"
echo "objdump -D $1.o"
objdump -D $1.o
ld -melf_i386 $1.o -o $1
echo "ld -melf_i386 $1.o -o $1"
objcopy -j .data -j .text -j .bss -O binary $1 $1.bin
echo "objcopy -j .data -j .text -j .bss -O binary $1 $1.bin"
echo "od -t x1 $1.bin"
od -t x1 $1.bin
echo "Ahora ejecutamos el programa ./$1 y mostramos lo que devuelve:"
./$1
echo $?

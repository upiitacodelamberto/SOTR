#!/bin/sh
as $1.s -o $1.o
#ld -lc $1.o -o $1
ld $1.o -o $1
./$1
echo $?

#!/bin/bash
LNX=/media/root/Personal2/Usuario/2017/15_SistemasOperativosEnTiempoReal/02_Linux_0.00_github_found/issamabd/branch_asm/linux-0.00/
#    cd / 	
    find  $LNX                                                                \
	-path "$LNX/arch/*" ! -path "$LNX/arch/i386*" -prune -o               \
	-path "$LNX/include/asm-*" ! -path "$LNX/include/asm-i386*" -prune -o \
	-path "$LNX/tmp*" -prune -o                                           \
	-path "$LNX/Documentation*" -prune -o                                 \
	-path "$LNX/scripts*" -prune -o                                       \
	-path "$LNX/drivers*" -prune -o                                       \
        -name "*.[chxsS]" -print >./cscope.files
# despues de ejecutar este script crear la scope BD con 
# cscope -b -q -k
# y despues por ejemplo usar
# cscope -d
# Enjoy cscope

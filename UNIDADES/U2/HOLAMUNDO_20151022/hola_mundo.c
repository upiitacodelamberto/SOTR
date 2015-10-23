/*
  hola_mundo.c
  Al compilar con:
   gcc -m32 hola_mundo.c -o test_hola
  se obtiene un archivo ELF para 32 bits que tambien corre
  en un linux de 64 bits. Si solo preprocesamos:
   gcc -m32 -E hola_mundo.c -o hola_mundo.i
  vemos que como consecuencia de #include <stdio.h>
  se incluira (
  # 1 "/usr/include/sys/cdefs.h" 1 3 4
  # 385 "/usr/include/sys/cdefs.h" 3 4
  ) 
  Para saber (en Debian) el nombre del paquete deb que 
  instalo el archivo /usr/include/sys/cdefs.h
  intentamos con el comando
  dpkg -S /usr/include/sys/cdefs.h
  y se obtiene como respuesta (20151022):
  libc6-dev-i386: /usr/include/sys/cdefs.h
  Por lo tanto si en otra PC con Debian (o alguna distro 
  basada en Debian) al compilar nos sale el mensaje que 
  que:
  no such file or directory /usr/include/sys/cdefs.h
  debemos instalar en esta otra PC el paquete 
  libc6-dev-i386
  Ejecutando:
  apt-cache search libc6-dev-i386
  se obtiene:
  libc6-dev-i386 - GNU C Library: 32-bit development libraries for AMD64
  /---------------------------------------/
  Mientras que si preprocesamos solo con:
   gcc -E hola_mundo.c -o hola_mundo.i
  vemos que como consecuencia de #include <stdio.h>
  se incluira (
  # 1 "/usr/include/x86_64-linux-gnu/sys/cdefs.h" 1 3 4
  # 385 "/usr/include/x86_64-linux-gnu/sys/cdefs.h" 3 4
  # 1 "/usr/include/x86_64-linux-gnu/bits/wordsize.h" 1 3 4
  # 386 "/usr/include/x86_64-linux-gnu/sys/cdefs.h" 2 3 4
  )

  /--------------------------------------/
  Para quitar el warning de builtin 
  podemos usar el modificador -fno-builtin:
   gcc -m32 -fno-builtin hola_mundo.c -o test_hola
  Asi podemos por ejemplo redefinir printf(), putc() --usando 
  la syscall write(), sin que se despligue al warning de builtin.
  /--------------------------------------/
 */
#include <stdio.h>

int main(){
  printf("Hola Mundo C!!\n");
  return 0;
}

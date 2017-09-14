# float2int.s
# Una funcion para copiar en crudo el contenido de una 
# variable float en una variable int. Esto deberia funcionar 
# bien si sizeof(int)== sizeof(float) es true.
.code32
# No hay datos
.section .data
.section .text

.globl float_to_int
#.def 
.type float_to_int, @function
float_to_int:
pushl %ebp               # Prologo
movl %esp,%ebp
#subl $4,%ebp            # esta funcion no usa variables locales

movl 8(%ebp),%eax        # Ponemos el primer y unico argumento en %eax
                         # Como el valor de retorno debe estar en %eax
                         # we are almost done. Falta regresar.
                         
                         # Epilogo
movl %ebp,%esp           # restore the stack pointer
popl %ebp                
ret 
#.endef

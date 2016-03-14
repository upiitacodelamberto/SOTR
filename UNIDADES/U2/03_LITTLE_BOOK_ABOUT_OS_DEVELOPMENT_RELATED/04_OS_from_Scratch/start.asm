;============
SECTION .text
;============
[BITS 32]
[GLOBAL start]
[EXTERN main]
MULTIBOOT_PAGE_ALIGN   equ 1<<0
MULTIBOOT_MEMORY_INFO  equ 1<<1
MULTIBOOT_AOUT_KLUDGE  equ 1<<16
MULTIBOOT_HEADER_MAGIC equ 0x1BADB002
MULTIBOOT_HEADER_FLAGS equ MULTIBOOT_PAGE_ALIGN | MULTIBOOT_MEMORY_INFO | MULTIBOOT_AOUT_KLUDGE
MULTIBOOT_CHECKSUM     equ -(MULTIBOOT_HEADER_MAGIC + MULTIBOOT_HEADER_FLAGS)

EXTERN code, bss, end

ALIGN 4  
mboot:
  dd MULTIBOOT_HEADER_MAGIC
  dd MULTIBOOT_HEADER_FLAGS
  dd MULTIBOOT_CHECKSUM

  dd mboot  ;these are PHYSICAL addresses
  dd code   ;start of kernel .text (code) section
  dd bss    ;start of kernel .bss setion
  dd end    ;end of kernel BSS
  dd start  ;kernel entry point
extern kmain

start:
  ;start C code
  mov eax, 0xCAFEBABE		; place the number 0xCAFEBABE in the 
				; register eax
  mov esp,stack
  call kmain
  ;shouldn't return from main; if we do, just do an idle loop
  sti
.idle:
  hlt
  jmp .idle

;============
SECTION .data
;============

;set up things like IDT, GDT or ISR/IRQ definitions


;============
SECTION .bss
;============

;add other stacks like timerstack

stack_start:
  resd 1024
stack:

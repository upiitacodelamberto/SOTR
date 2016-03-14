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
;  mov eax, 0xCAFEBABE		; place the number 0xCAFEBABE in the 
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

;GDT
gdt:
NULL_SEL  equ $-gdt
  dw 0             ; limit 15:0
  dw 0             ; base 15:0
  db 0             ; base 23:16
  db 0             ; type
  db 0             ; limit 19:16, flags
  db 0             ; base 31:24

SYS_CODE_SEL  equ $-gdt
  dw 0FFFFh
  dw 0
  db 0
  db 10011010b     ; present, ring 0, code, non-conforming,readable
  db 11001111b     ; page-granular (4 gig limit), 32-bit
  db 0

SYS_DATA_SEL  equ $-gdt
  dw 0FFFFh
  dw 0
  db 0
  db 10010010b     ; present, ring 0, data, expand-up, writable
  db 11001111b     ; page-granular (4 gig limit), 32-bit
  db 0
  
USER_CODE_SEL  equ ($-gdt)|0x3
  dw 0FFFFh
  dw 0
  db 0
  db 11111010b     ; present, ring 3,code,non-conforming,readable
  db 11001111b     ; page-granular (4 gig limit), 32-bit
  db 0

USER_DATA_SEL  equ ($-gdt)|0x3
  dw 0FFFFh
  dw 0
  db 0
  db 11110010b     ; present, ring 3, data, expand-up, writable
  db 11001111b     ; page-granular (4 gig limit), 32-bit
  db 0

SYS_TSS_SEL  equ $-gdt
  dw 104           ; limit 15.. 0
  dw 0             ; base 15.. 0, to be filled
  db 0             ; base 23.. 16, to be filled
  db 10001001b     ; present, ring 0, not busy TSS
  db 0             ; limit 19.. 16, not granular
  db 0             ; base 31.. 24, to be filled

INT_TSS_SEL  equ $-gdt
  dw 104           ; limit 15.. 0
  dw 0             ; base 15.. 0, to be filled
  db 0             ; base 23.. 16, to be filled
  db 10001001b     ; present, ring 0, not busy TSS
  db 0             ; limit 19.. 16, not granular
  db 0             ; base 31.. 24, to be filled

TIMER_TSS_SEL  equ $-gdt
  dw 104           ; limit 15.. 0
  dw 0             ; base 15.. 0, to be filled
  db 0             ; base 23.. 16, to be filled
  db 10001001b     ; present, ring 0, not busy TSS
  db 0             ; limit 19.. 16, not granular
  db 0             ; base 31.. 24, to be filled

gdt_end:           ; The reason for putting a label at the end of the 
                   ; GDT is so we can have the assembler calculate 
                   ; the size of the GDT for the GDT descriptor (below)

global gdt_descriptor
;GDT descriptor
gdt_descriptor:
  dw gdt_end - gdt - 1   ; Size of our GDT, alwais less one 
                         ; of the true size
  dd gdt                 ; start address of our GDT

  cli

  lgdt [gdt_descriptor]    ; load our global descriptor table, which defines 
                         ; the protected mode segments (e.g. for code and data)

  mov eax,cr0              ; To make the switch to protected mode, we set 
  or eax,0x1               ; the first bit of CR0, a control register
  mov cr0,eax

  ; Reload segment registers; load code segment by a far jump
  jmp SYS_CODE_SEL:$gdt1  ; CS descriptor 1
gdt1:
  mov eax,SYS_DATA_SEL    ; DS descriptor 2
  mov ds,ax
  mov eax,USER_CODE_SEL
  mov es,ax
  mov eax,USER_DATA_SEL
  mov fs,ax
  mov gs,ax
;  mov eax,0x18    ; SS descriptor 3
;  mov ss,ax
  ret

%macro SETIDT 1 
idt%1:
%if %1 = 0x80
  dw 0             ; unused
  dw INT_TSS_SEL   ; TSS segment selector
  db 0             ; unsused
  db 11100101b     ; present, ring 3, task gate
  dw 0             ; unused
%elif %1 = 0x20
  dw 0             ; unused
  dw TIMER_TSS_SEL ; TSS segment selector
  db 0             ; unused
  db 10000101b     ; present, ring 0, task gate
  dw 0             ; unused
%else
  dw 0x0           ; not known yet; filled in at execution
  dw SYS_CODE_SEL  ; code selector that will be used
  db 0             ; 0 for interrupt gates
  db 10001110b     ; 1-00-01110
  dw 0x0           ; not known yet filled in at execution
%endif
%endmacro

;IDT 
idt_ptr:
%assign i 0
%rep 256
  SETIDT i 
%assign i (i + 1) 
%endrep

%macro TSS_BODY 2
%define label %1
%define handler %2
  call handler
  add esp,4         ; drop error code
%if label = 0x20
  mov al,0x20
  mov dx,0x20
  out dx,al
%endif
  iret
  jmp isr %+ label ; as a task gate rather than an interrupt gate, the line after the iret
%endmacro          ; is stored in the eip; solve the problem by jumping back into isr

; implementation of one ISR, depending on the ISR number (argument 1)
; and wheter the given ISR needs adummy error (argument 2)
%macro INTBODY 2
isr%1:
%if %2 = 0
  push dword 0         ; "fake error code"
%endif
%if %1 = 0x20          ; isr32
  TSS_BODY %1, timer_handler
%elif %1 = 0x80        ; isr128
  TSS_BODY %1, syscall_handler          ; 
%else
  push dword %1        ; exception number
  push gs              ; push segment registers
  push fs              ;
  push es              ;
  push ds              ;
  pusha                ; push GP registers
  mov ax,SYS_DATA_SEL  ; put known-good registers ...
  mov ds,ax            ; ...in segment registers
  mov es,ax            ;
  mov fs,ax            ;
  mov gs,ax            ;
  mov eax,esp          ;
  push eax             ;
  call interrupt
  pop eax
  popa                 ; pop GP registers
  pop ds               ; pop segment register
  pop es
  pop fs 
  pop gs
  add esp,8            ; drop exception number and error code
  iret
%endif
%endmacro

extern timer_handler
extern syscall_handler
extern interrupt
;;"now declare isr's"
  INTBODY  0,0
  INTBODY  1,0
  INTBODY  2,0
  INTBODY  3,0
  INTBODY  4,0
  INTBODY  5,0
  INTBODY  6,0
  INTBODY  7,0
  INTBODY  8,1
  INTBODY  9,0
  INTBODY 10,1
  INTBODY 11,1
  INTBODY 12,1
  INTBODY 13,1
  INTBODY 14,1
  INTBODY 15,0
  INTBODY 16,0
  INTBODY 17,1
  INTBODY 18,0
  INTBODY 19,0

%assign i 014h
%rep 0FFh - 013h
  INTBODY i,0
%assign i (i + 1)
%endrep

; store isr addresses int idt fields and load idt
%macro SETISR 1
%if %1 != 0x80 && %1 != 0x20
  mov eax,isr%1
  mov [idt%1],ax
  shr eax,16
  mov [idt%1 + 6],ax
%endif
%endmacro

global idt_descriptor
;IDT descriptor
idt_descriptor:
global vectors
vectors:
%assign i 0
%rep 256
  SETISR i
%assign i (i + 1)
%endrep

idt_end:

;;IDT descriptor
;idt_descriptor:
  dw idt_end - idt_ptr - 1
  dd idt_ptr

  lidt [idt_descriptor]
  ret

;============
SECTION .bss
;============

;add other stacks like timerstack

stack_start:
  resd 1024
stack:

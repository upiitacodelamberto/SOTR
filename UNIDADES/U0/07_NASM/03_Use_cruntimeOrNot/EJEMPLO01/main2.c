void mymain(void)
{
  int a = 42;
  a++;
  asm volatile("mov $1,%%eax; mov %0,%%ebx; int $0x80" 
               : : "r"(a) : "%eax" );
}

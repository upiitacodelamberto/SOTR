OUTPUT_ARCH(i386)
/*ENTRY(loader)*/			/* the name of the entry label */
ENTRY(start)			/* the name of the entry label */
physbase = 0x100000;

SECTIONS {
/*  . = 0x00100000;*/		/* the code shoud be loaded at 1MB */
  . = physbase;                 /* Image starts here                    */

/*  . = ALIGN(4096);*/              /* Accommodate bad physbase             */
  .text ALIGN (0x1000) : 	/* align at 4KB */
  {
    text = ABSOLUTE(.);         /* text: beginning of text segment      */
/*    *(.text)*/			/* all text sections from all files */
    *(.text .text.*)            /* asm text, then C text                */
    *(.rodata .rodata.*)        /* asm and C read-only data             */
    etext = ABSOLUTE(.) ;       /* etext: end of text                   */
    . = ALIGN(4096);
  }

/*  .rodata ALIGN (0x1000) :*/ 	/* align at 4KB */
/*  {*/
/*    *.(rodata*)*/			/* all read-only data sections from all files */
/*  }*/

  .data ALIGN (0x1000) :        /* align at 4KB */
  {
    data = ABSOLUTE(.);         /* data: beginning of data segment      */
/*    *(.data)*/                    /* all data sctions from all files */
    *(.data .data.*)                                                    
    edata = ABSOLUTE(.) ;       /* edata: end of data                   */
  }

  .bss ALIGN (0x1000) :		/* align at 4KB */   
  {
    bss = ABSOLUTE(.);          /* bss: beginning of bss segment        */
    *(.bss .bss.*)
    *(COMMON)			/* all COMMON sections from all files */
    ebss = ABSOLUTE(.) ;        /* ebss: end of bss                     */
/*    *(.bss)*/			/* all bss sections from all files */
    . = ALIGN(4096); */
    end = ABSOLUTE(.);          /* end: end of image                    */
    _end = ABSOLUTE(.);         /* _end: end of image                   */
    . = ALIGN(4096);
  }
}

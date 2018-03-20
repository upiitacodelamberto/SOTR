#ifndef FECHA_FAT12
#define FECHA_FAT12

struct fechafat12{                   /* Packing structs                                             */
  unsigned dia	:5;                  /* When using a struct there is no guarantee that the size of  */
  unsigned mes	:4;                  /* the struct will be exactly of the size one could expect.    */
  unsigned anio	:7;                  /* The compiler can add some padding between elements for      */
} __attribute__((packed));           /* various reasons (mainly efficiency). The attribute packed   */
                                     /* can be used to force GCC to not add any padding.            */

typedef struct fechafat12 FechaFAT12;


struct Int16{
  unsigned myInt16  :16;
} __attribute__ ( ( packed ) );

typedef struct Int16 uInt16;		/* unsigned Int de 16 bits */

union UInt16{                         /*Esta union se puede usar para convertir enteros uInt16 a FechaFAT12*/
  FechaFAT12 fecha;
  uInt16     int16;
};

typedef union UInt16 UInt16;

#endif

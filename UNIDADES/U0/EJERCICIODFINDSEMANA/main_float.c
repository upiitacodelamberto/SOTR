/** main_float.c - 
 * Forma de uso: ./#*argv[0] <un numero con punto decimal> 
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define CAT_BYTES(charA,charB)	(   (((charA)<<(8))&(0x0000ff00))  |((charB)&(0x000000ff)))
#define CAT_WORDS(intWordA,intWordB)	((((intWordA)<<(16))&(0xffff0000))|(intWordB))
#define BIAS	127

/* signo y los 7 bits mas significativos de exponente */
#define CAT_SIGN_EXP(A,B)	((((A)<<(7))&(0x80))|( ((B)>>(1))&(0x7f)))

/* bit menos significativo de exponente y los 7 bits mas significativos de los 23 bits de mantisa */
#define CAT_EXP_MANT(Exp,Mant)	((((Exp)&(0x01))<<(7))|(Mant&0x7f))

union {
  float f;
  int i;
}mistery;

typedef 
struct flotante{
  unsigned char signo;
  unsigned char exponente;
  char *mantisa;//[3];
}Flotante;
union NumFloat{
  Flotante FlotanteVar;
  unsigned char abcd[5];//abcd[0],abcd[1],*(mantisa+1),*(mantisa+2)
};//Falta ver si se puede usar abcd[0], abcd[1] instead of 
  //CAT_SIGN_EXP(numfloat.abcd[0],numfloat.abcd[1])  y 
  //CAT_EXP_MANT(numfloat.abcd[1],((*(numfloat.FlotanteVar.mantisa))<<(0)))
  //donde numfloat es una instancia de la struct myfloat que contiene campos de bits. 
float *floatPt;

typedef 
struct myfloat{
  unsigned mantisa	:23;
  unsigned power	:8;
  unsigned sign		:1;
}MyFloat;
struct four_chars{
  unsigned char abcd0;
  unsigned char abcd1;
  unsigned char abcd2;
  unsigned char abcd3;
};
union mynumfloat{
  MyFloat MyF;
  unsigned char abcd[4];
  //unsigned char *abcd;
  //struct four_chars FC; 
};

/**
 * Imprime los bits de un int
 */
void show_bits(int);
/**
 * Concatena los cuatro chars a, b, c y d para "construir" un
 * float devuelto (por referencia) en *floatPt.
 * Los bytes (bits) del float *floatPt se devuelven (return) 
 * en un int.
 */
int hacer_float(char a,char b,char c,char d,float *floatPt);

int hacer_Flotante(unsigned char sign,unsigned char exp,char * mant,Flotante *F);

long main(int argc,char *argv[]){
  float floatA,i; 
//  union mistery unionM;
  if(argc<2){
    printf("Forma de uso:./%s <num float>\n",argv[0]);
    return 0;
  }
  floatA=atof(argv[1]);
  mistery.f=floatA;
  //int tmp=*((int*)((void*)(&floatA)));
  int tmp=*((int*)(&floatA));		/* asi guardamos lo bytes de un float en un int */
  printf("sizeof(float)=%d, sizeof(float*)=%d\n",sizeof(float),sizeof(float*));
  printf("sizeof(int)=%d, sizeof(int*)=%d\n",sizeof(int),sizeof(int*));
  printf("tmp=%d\n",tmp);
//A1:  for(i=8*sizeof(int)-1;i>=0;i--){
//A2:    printf("%d",(((int)tmp)>>i)&0x00000001);
//A3:  }
  show_bits(tmp);
  printf("\n");
  show_bits(mistery.i);
  printf("\n");
  
  printf("\n");
//  char charA=0x40,charB=0xf0;
  char charA=0x40,charB=0xf2;			//B1:
  int intWordA=CAT_BYTES(charA,charB);		//B2:
  //int intWordA=(   (((charA)<<(8))&(0x0000ff00))  |((charB)&(0x000000ff)));
  printf("intWordA=");
  show_bits(intWordA);
  printf("\n");
  int intWordB=0x00000000;			//B3:
  //int intLong=((((intWordA)<<(16))&(0xffff0000))|(intWordB));
  int intLong=CAT_WORDS(intWordA,intWordB);	//B4:
  show_bits(intLong);
  printf("\n");
  float floatB=*((float*)(&intLong));	/* asi guardamos los bytes de un int en un float *///B5:
  printf("floatB=%f\n",floatB);

  unsigned char a=0x40,b=0xf2,c=0x00,d=0x00;
  int intLong1=hacer_float(a,b,c,d,&floatB);
  printf("Ahora floatB obtenido usando la funcion int hacer_float(char,char,char,char,float*)\n");
  printf("floatB=%f\t",floatB);
  show_bits(intLong1);
  printf("\n");

  /*Uso de la union NumFloat */
  printf("Utilizando una union NumFloat que contiene una struct flotante (sin campos de bits)\n");
  union NumFloat numfloat;
  numfloat.FlotanteVar.signo=0;
  //numfloat.FlotanteVar.exponente=0x81;
  numfloat.FlotanteVar.exponente=BIAS+2;
  numfloat.FlotanteVar.mantisa=(char*)malloc(3*sizeof(char));
  *(numfloat.FlotanteVar.mantisa)=0x72;
  *(numfloat.FlotanteVar.mantisa+1)=0x00;
  *(numfloat.FlotanteVar.mantisa+2)=0x00;
  //numfloat.abcd[0]=0x40;
  //numfloat.abcd[1]=0xf2;
  //numfloat.abcd[2]=0x00;
  //numfloat.abcd[3]=0x00;
printf("numfloat.FlotanteVar.signo=%x\n",numfloat.FlotanteVar.signo);
printf("numfloat.FlotanteVar.exponente=%x\n",numfloat.FlotanteVar.exponente);
printf("numfloat.FlotanteVar.mantisa=%x\n",numfloat.FlotanteVar.mantisa);
printf("a=%x\tb=%x\tc=%x\td=%x\n",a,b,c,d);
//printf("abcd[0]=%d\tabcd[1]=%d\tabcd[2]=%d\tabcd[3]=%d\n",numfloat.abcd[0],numfloat.abcd[1],
//							  numfloat.abcd[2],numfloat.abcd[3]);
printf("%x\n",*(numfloat.FlotanteVar.mantisa));
printf("a_en_structF=%x\tb_en_structF=%x\tc_en_structF=%x\td_en_structF=%x\n",
			CAT_SIGN_EXP(numfloat.abcd[0],numfloat.abcd[1]),
                   CAT_EXP_MANT(numfloat.abcd[1],((*(numfloat.FlotanteVar.mantisa))<<(0))),
		*(numfloat.FlotanteVar.mantisa+1),*(numfloat.FlotanteVar.mantisa+2));
  int intLong2=hacer_float(CAT_SIGN_EXP(numfloat.abcd[0],numfloat.abcd[1]),
			CAT_EXP_MANT(numfloat.abcd[1],((*(numfloat.FlotanteVar.mantisa))<<(0))),
			*(numfloat.FlotanteVar.mantisa+1),*(numfloat.FlotanteVar.mantisa+2),&floatB);
  printf("floatB=%f\t",floatB);
  show_bits(intLong2);
  printf("\n");

  numfloat.FlotanteVar=(Flotante){0x00,0x81,(char*)malloc(3*sizeof(char))};//{0x72,0x00,0x00}
  *(numfloat.FlotanteVar.mantisa)=0x72;
  *(numfloat.FlotanteVar.mantisa+1)=0x00;
  *(numfloat.FlotanteVar.mantisa+2)=0x00;
printf("numfloat.FlotanteVar.signo=%x\n",numfloat.FlotanteVar.signo);
printf("numfloat.FlotanteVar.exponente=%x\n",numfloat.FlotanteVar.exponente);
printf("numfloat.FlotanteVar.mantisa=%x\n",numfloat.FlotanteVar.mantisa);
printf("abcd[0]=%x\tabcd[1]=%x\tabcd[2]=%x\tabcd[3]=%x\n",numfloat.abcd[0],numfloat.abcd[1],
							  numfloat.abcd[2],numfloat.abcd[3]);
  int intLong3=hacer_float(CAT_SIGN_EXP(numfloat.abcd[0],numfloat.abcd[1]),
				CAT_EXP_MANT(numfloat.abcd[1],*(numfloat.FlotanteVar.mantisa)),
				*(numfloat.FlotanteVar.mantisa+1),*(numfloat.FlotanteVar.mantisa+2),&floatB);
  printf("floatB=%f\t",floatB);
  show_bits(intLong3);
  printf("\n");

  /* Ahora intento usar los campos de bits de un instancia de MyFloat */
  printf("Utilizando una union mynumfloat que contiene una struct myfloat (con campos de bits)\n");
  printf("Inicializando primero los campos de bits de una instancia de MyFloat (struct myfloat)\n");
  MyFloat MyF=*((MyFloat*)(&floatB));/* struct myfloat con campos de bits sign, power y mantisa */
  union mynumfloat union_mynumfloat;
  union_mynumfloat.MyF=MyF;
  //union_mynumfloat.abcd=(unsigned char*)(&MyF);
  printf("char 0=%x\tchar 1=%x\tchar 2=%x\tchar 3=%x\n",union_mynumfloat.abcd[0],union_mynumfloat.abcd[1],
	union_mynumfloat.abcd[2],union_mynumfloat.abcd[3]);
  printf("\n");

  printf("Utilizando una union mynumfloat que contiene una struct myfloat (con campos de bits)\n");
  printf("Inicializando primero el arreglo de unsigned chars (SE TIENE QUE USAR Little Endian!)\n");
  union mynumfloat union_mynumfloat1;
  printf("sizeof(union_mynumfloat1)=%d\n",sizeof(union_mynumfloat1));
  printf("sizeof(union_mynumfloat1.MyF)=%d\n",sizeof(union_mynumfloat1.MyF));
  printf("sizeof(unsigned int)=%d\n",sizeof(unsigned int));
  printf("sizeof(unsigned char)=%d\n",sizeof(unsigned char));
  unsigned char abcd[]={0x00,0x00,0xf2,0x40};	
  //union_mynumfloat1.abcd=abcd;
  //strcpy(union_mynumfloat1.abcd,abcd);
  //for(i=0;i<4;i++){
  //  union_mynumfloat1.abcd[i]=abcd[i]; /* error: array subscript is not an integer */
  //}
  //union_mynumfloat1.abcd=(unsigned char*)malloc(4*sizeof(unsigned char));
  floatPt=(float*)malloc(sizeof(float));
  //union_mynumfloat1.abcd=(unsigned char*)floatPt;
  union_mynumfloat1.abcd[0]=0x00;
  union_mynumfloat1.abcd[1]=0x00;
  union_mynumfloat1.abcd[2]=0xf2;
  union_mynumfloat1.abcd[3]=0x40;
  printf("sign=%x\n",union_mynumfloat1.MyF.sign);	/* aqui deberia imprimirse 0 ... OK */
  printf("power=%x\n",union_mynumfloat1.MyF.power);	/* aqui deberia imprimirse 81 ... OK */
  printf("mantisa=%x\n",union_mynumfloat1.MyF.mantisa);	/* aqui deberia imprimirse 720000 ... OK */
  floatB=*((float*)(&(union_mynumfloat1.MyF)));
  printf("floatB=%f\n",floatB);				/* aqui deberia imprimirse 7.562500 ... OK */
  
  
  /* Vease el archivo campos.c para una version mas clara y simple (y sobre todo correcta) de este programa*/
  
  
  return floatA;
}//end main()

void show_bits(int intTmp){
  int i;
  for(i=8*sizeof(int)-1;i>=0;i--){        //A1:
    printf("%d",((intTmp)>>i)&0x00000001);//A2:
  }                                       //A3:
}

int hacer_float(char a,char b,char c,char d,float *floatPtVar)
{
  char charA=a,charB=b,charC=c,charD=d;				       //B1:
  int intWordA=CAT_BYTES(charA,charB);				       //B2:
  int intWordB=CAT_BYTES(charC,charD);				       //B2:   
  int *intLongPt=(int*)malloc(sizeof(int));
  *intLongPt=CAT_WORDS(intWordA,intWordB);			       //B4:   
  /* asi guardamos lo bytes de un int en un float */		       //   
  *floatPtVar=*((float*)(intLongPt));				       //B5:
  return *intLongPt;
}

int hacer_Flotante(unsigned char sign,unsigned char exp,char *mant,Flotante *F)
{
  F->signo=sign;
  F->exponente=exp;
  F->mantisa=mant;
  union NumFloat NF;
  NF.FlotanteVar=*F;
  return hacer_float(NF.abcd[0],NF.abcd[1],NF.abcd[2],NF.abcd[3],floatPt);
}

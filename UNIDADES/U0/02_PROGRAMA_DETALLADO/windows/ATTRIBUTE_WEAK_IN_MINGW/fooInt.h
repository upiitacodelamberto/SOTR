#define EXAMPLEORIG
#define CONDUMMYVACIA
#define CONMAIN_N_MAINDOTCPP
//#define CONMAIN_N_CPP3DOTCPP
// the proper way would be
#define __WEAK__ __attribute__((weak))

// I have tried extern ,dllimport, but they are all ignored (and warned) because of the 
// "= 6". If not for the assignment, extern with changing definition of __WEAK__ 
// could work. All modules compiled with "extern" and one with out.
// what could be the defenition of __WEAK__ that will make this project to link?
// I thought that a combination of section and asm() could do it but I cannot 
// figure out what the magig should be. Weak symbles are supported in templates.
// So what is the compiler's magic for weak templates symbles that make the linker
// happy

__WEAK__ int fooInt = 1 ;
//extern __WEAK__ int fooInt ;

extern int foo_2() ;
extern int foo_3() ;
extern void dummy();

template <typename T> /* Esto parece funcionar como */
class Static_T        /* __attribute__((weak)) */
{
public:
static T My ;
} ;

//template <typename T>
//T Static_T<T>::My = 17 ;


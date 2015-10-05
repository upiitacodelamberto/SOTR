#include <iostream>
#include "fooInt.h"
using namespace std;

int foo_3()
{
    dummy();
#ifdef EXAMPLEORIG
    return fooInt*fooInt*fooInt * Static_T<int>::My ;
#else
    cout << Static_T<char*>::My[0] << "\n";
#endif
    return fooInt*fooInt*fooInt ;
}

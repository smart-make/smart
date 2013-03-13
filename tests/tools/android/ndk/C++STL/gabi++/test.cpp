#include <cassert>
#include <cctype>
#include <cerrno>
#include <cfloat>
#include <climits>
#include <cmath>
#include <csetjmp>
#include <csignal>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <ctime>
#include <cwchar>
#include <cwctype_is_not_supported>
#include <exception>
#include <new>
#include <typeinfo>
#include <utility>
#include <cxxabi.h>
#include <unwind.h>
#include <stl_pair.h>

class C {};

int main (int argc, char**argv)
{
    const std::type_info		*ti = NULL;
    const abi::__fundamental_type_info	*ti_fundamental = NULL;
    const abi::__array_type_info	*ti_array = NULL;
    const abi::__function_type_info	*ti_function = NULL;
    const abi::__enum_type_info		*ti_enum = NULL;
    const abi::__class_type_info	*ti_class = NULL;

    /*
    ti = &typeid (int);
    ti = &typeid (int*);
    */

    (void) ti;
    (void) ti_fundamental;
    (void) ti_array;
    (void) ti_function;
    (void) ti_enum;
    (void) ti_class;
    return 0;
}

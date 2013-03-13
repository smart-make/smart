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
#include <new>
#include <typeinfo>
#include <utility>
#include <stl_pair.h>

int main (int argc, char**argv)
{
    std::type_info *ti = NULL;
    std::time_t t = std::time (NULL);
    std::tm tm;
    std::clock_t c;

    t = std::mktime (&tm);
    //std::gmtime_r (&t, &tm);

    (void) ti;
    return 0;
}

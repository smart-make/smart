#include <cxxabi.h>
#include <ext/rope>
//#include <ext/hash_map>
#include <system_error>
#include <random>
#include <debug/debug.h>
#include <fenv.h>
#include <initializer_list>
#ifdef _GLIBCXX_HAS_GTHREADS
#include <thread>
#include <future>
#endif
#include <bits/gthr.h>
#include <tgmath.h>
#include <iostream>
#include <tr1/fenv.h>
#include <tr1/random>
#include <tr1/random.h>
#include <tr1/random.tcc>
/*
#include <tr2/type_traits>
#include <tr2/ratio>
#include <tr2/bool_set>
#include <tr2/dynamic_bitset>
*/

int main (int argc, char**argv)
{
    {
	__gnu_cxx::recursive_init_error *p = NULL;
    }

    {
	using namespace __gnu_debug;
	_GLIBCXX_DEBUG_ASSERT (true);
    }

    {
	std::string s("foo");
	std::cout << s;
    }

    {
#ifdef _GLIBCXX_HAS_GTHREADS
	std::thread t ([] () {
		
	    });
#endif//_GLIBCXX_HAS_GTHREADS
    }
    return 0;
}

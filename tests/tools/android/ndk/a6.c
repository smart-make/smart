#include <module0.h>
#include <module1.h>
#include <module2.h>
#include <module3.h>

/**
 *  NOTE: This is NOT a valid native application!!
 */

int main (int argc, char** argv)
{
    const char * module0 = get_module_0 ();
    const char * module1 = get_module_1 ();
    const char * module2 = get_module_2 ();
    const char * module3 = get_module_3 ();
    (void) module0;
    (void) module1;
    (void) module2;
    (void) module3;
    return 0;
}

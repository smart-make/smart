#include <foo_app_glue.h>
#include <jni.h>

/**
 *  NOTE: This is NOT a valid native application!!
 */

int main (int argc, char** argv)
{
    struct android_app app = { 0 };
    android_main (&app);
    return 0;
}

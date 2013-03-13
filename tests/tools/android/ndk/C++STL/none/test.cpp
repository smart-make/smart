#include <stdio.h>
#include <stdlib.h>
int main (int argc, char**argv)
{
    FILE *file = fopen ("/tmp/test", "+w");
    fprintf (file, "%d", argc);
    fclose (file);

    printf ("%d\n", argc);
    return 0;
}

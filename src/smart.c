#include <unistd.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

static char smartroot[1024], smartload[1024];

/**
 *  #!/usr/bin/env bash
 *  SMARTROOT=$(dirname $(dirname $0))
 *  GNUMAKE=$(which make)
 *  exec $GNUMAKE -f $SMARTROOT/load/main.mk $@
 */
int main(int argc, char**argv)
{
  int n = readlink ("/proc/self/exe", smartroot, 1024);
  if (n < 0) {
    fprintf (stderr, "error: %s\n", strerror(errno));
    return n;
  } else {
    char * slash;
    slash = strrchr (smartroot, '/');
    *slash = '\0';
    slash = strrchr (smartroot, '/');
    *slash = '\0';
  }

  sprintf (smartload, "%s/load/main.mk", smartroot);

  char **args = (char **) malloc (sizeof(char *) * (argc + 3));
  for (n = 0; n < argc + 3; ++n) args[n] = NULL;

  args[0] = argv[0];
  args[1] = "-f";
  args[2] = smartload;
  for (n = 1; n < argc; ++n) args[n + 2] = argv[n];

  if ((n = execvp ("make", (char * const *) args)) < 0) {
    fprintf (stderr, "error: %s\n", strerror(errno));
  }

  free (args);
  return n;
}

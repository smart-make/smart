# Example of build a C program using smart-make

Main Smart Files
================

  * `.tool`
  
    Set the `TOOL` variable to tell which build tool is going to be used, `gcc` in this case. This is
    optional, but if it's absent, a explicit `TOOL=gcc` should be used on the `smart` command line.
```makefile
TOOL := gcc
```


  * `smart`
  
    The top level `smart` script for the main `example` program.
```makefile
PROGRAM  := example
SOURCES  := main.c
REQUIRES := libfoo
SUBDIRS  := libfoo
```
    
  * `libfoo/smart`
  
    A sub-level `smart` script to build `libfoo` sub module (a static library).
```makefile
## Set LIBRARY to build a library
LIBRARY := libfoo.a

## Set SOURCES to include source files
SOURCES := foo.c

## EXPORT properties
EXPORT.INCLUDES := $(SRCDIR)
EXPORT.LOADLIBS := $(SRCDIR)/libfoo.a
```

Build The Example
=================

```shell
$ smart
{% endhighlight %}
```

Or explicitly specify a `TOOL`:

```shell
$ smart TOOL=gcc
```

smart-make
==========

An enhanced (smart) `make` tool based on GNU/Make.

Features:

  * Multiple `TOOL` set for different programming language
  * Simplified makefile (renamed `smart`) without the needs to write complicated build rules
  * Easy way to build sub-modules (even different programming languages)
  * Easy way to maintain library dependencies.

Here is the example `smart` file:
```makefile
# Use `PROGRAM` to build a executable
PROGRAM  := example

# Use `SOURCES` to include the sources to be compiled
SOURCES  := main.c

# Use `REQUIRES` to declare dependencies
REQUIRES := libfoo

# Use `SUBDIRS` to build modules in other sub-directories
SUBDIRS  := libfoo
```

And here is the example library `smart` file:
```makefile
# Use LIBRARY to build a library
LIBRARY := libfoo.a

# Use SOURCES to include source files to be compiled
SOURCES := foo.c

# Use `EXPORT.INCLUDES` to tell -I directories for the module `REQUIRES` it.
EXPORT.INCLUDES := $(SRCDIR)

# Use `EXPORT.LOADLIBS` to tell library name for the module `REQUIRES` it.
EXPORT.LOADLIBS := $(SRCDIR)/libfoo.a
```

Installation
============

The installation is going to add a new utility `/usr/bin/smart`. After the installation, please don't
remove the cloned `smart` directory, it's being loaded by `/usr/bin/smart` on each build. So it's best
to clone it in a persistant workspace.

```shell
$ git clone https://github.com/smart-make/smart.git
$ cd smart && make
$ sudo make install
```

Examples
========

  * [Build a C program](examples/build-c-program)

Variables
=========

Module Target Name
------------------
  * PROGRAM
  * LIBRARY

Source Files and Sub-modules
----------------------------
  * SOURCES
  * SRCDIR

Compile Flags
-------------
  * CFLAGS
  * CXXFLAGS

Link Flags
----------
  * LDFLAGS
  * LOADLIBS

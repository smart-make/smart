smart-make
==========

An enhanced (smart) `make` tool based on GNU/Make.

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

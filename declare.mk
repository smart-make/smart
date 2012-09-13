MAKEFILE_LIST := $(filter-out $(lastword $(MAKEFILE_LIST)),$(MAKEFILE_LIST))

SRCDIR := $(smart.me)
NAME := $(notdir $(SRCDIR))

CXXFLAGS :=
ARFLAGS := cru
LDFLAGS :=
LIBADD :=
LOADLIBS := 

SUBDIRS :=
PROGRAMS :=
LIBRARIES :=
SOURCES :=
OBJECTS :=

EXEEXT := .exe

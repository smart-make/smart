MAKEFILE_LIST := $(filter-out $(lastword $(MAKEFILE_LIST)),$(MAKEFILE_LIST))

SM.MK := $(lastword $(MAKEFILE_LIST))
SRCDIR := $(smart.me)
NAME := $(notdir $(SRCDIR))

CC := gcc
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

-include $(wildcard $(ROOT)/declare.mk)

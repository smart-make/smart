#
#    Copyright (C) 2012, Duzy Chan <code@duzy.info>.
#    All rights reserved.
#
$(smart.internal)
$(foreach smart~name,$(filter $(smart.context.names),$(.VARIABLES)),$(eval $(smart~name):=))

SM.MK := $(lastword $(MAKEFILE_LIST))
SRCDIR := $(smart.me)
NAME := $(notdir $(SRCDIR))

$(warning TODO: set TOOL for $(NAME))

ifeq ($(NAME),.)
  NAME := $(notdir $(PWD))
endif

# G_GNUC_WARN_UNUSED_RESULT
# -Werror=format  -->  __attribute__((__sentinel__)) (e.g. G_GNUC_NULL_TERMINATED)
GCC_Werrors := \
  -Werror=declaration-after-statement \
  -Werror=format \
  -Werror=format-extra-args \
  -Werror=implicit-function-declaration \
  -Werror=nested-externs \
  -Werror=pointer-sign \
  -Werror=return-type \
  -Werror=switch \
  -Werror=uninitialized \
  -Werror=unused-function \
  -Werror=unused-variable \
  -Werror=unused-result \

CC := gcc
CFLAGS := $(GCC_Werrors) -Werror=declaration-after-statement
CXXFLAGS := $(GCC_Werrors)
ARFLAGS := cru
LDFLAGS :=
LIBADD :=
LOADLIBS :=

ifeq ($(shell uname),Linux)

else # uname == Linux
LOADLIBS += \
  -lkernel32\
  -luser32\
  -lgdi32\
  -lcomdlg32\
  -lwinspool\
  -lwinmm\
  -lshell32\
  -lcomctl32\
  -lole32\
  -loleaut32\
  -luuid\
  -lrpcrt4\
  -ladvapi32\
  -lwsock32\
  -lodbc32\
  -lws2_32\
  -lnetapi32\
  -lmpr\

endif # uname != Linux

EXEEXT := .exe

$(foreach 1,$(wildcard $(smart.root)/internal/tools/*/detect.mk),\
    $(eval include $1))
-include $(wildcard $(ROOT)/declare.mk)

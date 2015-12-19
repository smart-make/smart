#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

ifeq ($(and $(NDK_ROOT),$(BUILD_SYSTEM),$(NDK_ALL_TOOLCHAINS),$(NDK_ALL_ABIS),$(NDK_ALL_ARCHS)),)
  include $(smart.tooldir)/glue/init.mk
  DEFAULT_TOOLCHAIN_VERSION := 4.8
endif

## Use debug version by defalult
ifndef APP_OPTIM
  APP_OPTIM := debug
endif #!APP_OPTIM

## Free the dictionary of LOCAL_MODULE definitions
##   BUG: clear modules will affect other modules, so don't do this here
#$(call modules-clear)

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
  -Werror=unused-result \
  -Werror=unused-variable \

CFLAGS :=
CXXFLAGS :=
ARFLAGS :=
LDFLAGS :=
LDLIBS :=
LOADLIBS :=
LIBADD :=

# TOOLCHAIN_NAME := 
#TOOLCHAIN_VERSION := 4.6
#TOOLCHAIN_VERSION := 4.7
TOOLCHAIN_VERSION := 4.8

EXPORT.LIBS := $(OUT)/$(NAME).native

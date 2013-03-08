#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

ifeq ($(and $(NDK_ROOT),$(BUILD_SYSTEM),$(NDK_ALL_TOOLCHAINS),$(NDK_ALL_ABIS),$(NDK_ALL_ARCHS)),)
  include $(smart.tooldir)/glue/init.mk
endif

# $(warning $(NDK_ROOT))
# $(warning $(TARGET_ABI))
# $(warning $(TARGET_TOOLCHAIN_LIST))
# $(warning $(TARGET_TOOLCHAIN))
# $(warning $(TARGET_ARCH_ABI))
# $(warning $(TARGET_PLATFORM))
# $(warning $(TARGET_ARCH))
# $(warning $(TOOLCHAIN_PREFIX))

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

# AR := $(TARGET_AR)
# CC := $(TARGET_CC)
# CXX := $(TARGET_CXX)
# LD := $(TARGET_LD)

# $(GCC_Werrors)
CFLAGS := $(TARGET_CFLAGS)
CXXFLAGS := $(TARGET_CXXFLAGS)
ARFLAGS := $(TARGET_ARFLAGS)
LDFLAGS := $(TARGET_LDFLAGS)
LDLIBS := $(TARGET_LDLIBS)
LOADLIBS :=
LIBADD :=
LIBGCC := $(TARGET_LIBGCC)

EXPORT.LIBS := $(OUT)/$(NAME).native

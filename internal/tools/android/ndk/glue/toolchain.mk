#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

##
## Reference:
##     NDK: $(BUILD_SYSTEM)/setup-toolchain.mk
## 

$(call assert-defined,TARGET_PLATFORM TARGET_ARCH TARGET_ARCH_ABI)

## Copied from NDK:setup-toolchain.mk
LLVM_VERSION_LIST := 2.6 2.7 2.8 2.9 3.0 3.1

##
## Choose TARGET_TOOLCHAIN, should always check in setup-toolchain.mk for
## this algorithm
ifndef NDK_TOOLCHAIN
    TARGET_TOOLCHAIN_LIST := $(strip $(sort $(NDK_ABI.$(TARGET_ARCH_ABI).toolchains)))

    # Filter out the Clang toolchain, so that we can keep GCC as the default
    # toolchain.
    $(foreach _ver,$(LLVM_VERSION_LIST), \
        $(eval TARGET_TOOLCHAIN_LIST := \
            $(filter-out %-clang$(_ver),$(TARGET_TOOLCHAIN_LIST))))

    # Filter out 4.7 which is considered experimental at this moment
    TARGET_TOOLCHAIN_LIST := $(filter-out %4.7,$(TARGET_TOOLCHAIN_LIST))

    ifndef TARGET_TOOLCHAIN_LIST
        $(call __ndk_info,There is no toolchain that supports the $(TARGET_ARCH_ABI) ABI.)
        $(call __ndk_info,Please modify the APP_ABI definition in $(NDK_APP_APPLICATION_MK) to use)
        $(call __ndk_info,a set of the following values: $(NDK_ALL_ABIS))
        $(call __ndk_error,Aborting)
    endif

    # Select the last toolchain from the sorted list.
    # For now, this is enough to select armeabi-4.6 by default for ARM
    TARGET_TOOLCHAIN := $(lastword $(TARGET_TOOLCHAIN_LIST))

    # If NDK_TOOLCHAIN_VERSION is defined, we replace the toolchain version
    # suffix with it.
    #
    ifdef NDK_TOOLCHAIN_VERSION
        # We assume the toolchain name uses dashes (-) as separators and doesn't
        # contain any space. The following is a bit subtle, but essentially
        # does the following:
        #
        #   1/ Use 'subst' to convert dashes into spaces, this generates a list
        #   2/ Use 'chop' to remove the last element of the list
        #   3/ Use 'subst' again to convert the spaces back into dashes
        #
        # So it TARGET_TOOLCHAIN is 'foo-bar-zoo-xxx', then
        # TARGET_TOOLCHAIN_BASE will be 'foo-bar-zoo'
        #
        TARGET_TOOLCHAIN_BASE := $(subst $(space),-,$(call chop,$(subst -,$(space),$(TARGET_TOOLCHAIN))))
        TARGET_TOOLCHAIN := $(TARGET_TOOLCHAIN_BASE)-$(NDK_TOOLCHAIN_VERSION)
        $(call ndk_log,Using target toolchain '$(TARGET_TOOLCHAIN)' for '$(TARGET_ARCH_ABI)' ABI (through NDK_TOOLCHAIN_VERSION))
    else
        $(call ndk_log,Using target toolchain '$(TARGET_TOOLCHAIN)' for '$(TARGET_ARCH_ABI)' ABI)
    endif
else # NDK_TOOLCHAIN is not empty
    TARGET_TOOLCHAIN_LIST := $(strip $(filter $(NDK_TOOLCHAIN),$(NDK_ABI.$(TARGET_ARCH_ABI).toolchains)))
    ifndef TARGET_TOOLCHAIN_LIST
        $(call __ndk_info,The selected toolchain ($(NDK_TOOLCHAIN)) does not support the $(TARGET_ARCH_ABI) ABI.)
        $(call __ndk_info,Please modify the APP_ABI definition in $(NDK_APP_APPLICATION_MK) to use)
        $(call __ndk_info,a set of the following values: $(NDK_TOOLCHAIN.$(NDK_TOOLCHAIN).abis))
        $(call __ndk_info,Or change your NDK_TOOLCHAIN definition.)
        $(call __ndk_error,Aborting)
    endif
    TARGET_TOOLCHAIN := $(NDK_TOOLCHAIN)
endif

#$(warning $(NDK_TOOLCHAIN), $(TARGET_TOOLCHAIN))
#$(warning $(NDK_TOOLCHAIN.$(TARGET_TOOLCHAIN).setup))
#$(warning $(NDK_ABI.$(TARGET_ARCH_ABI).toolchains))
#$(warning $(NDK_ABI.$(TARGET_ARCH_ABI).arch))
#$(warning $(NDK_PLATFORMS_ROOT))

TARGET_ABI := $(TARGET_PLATFORM)-$(TARGET_ARCH_ABI)

# setup sysroot-related variables. The SYSROOT point to a directory
# that contains all public header files for a given platform, plus
# some libraries and object files used for linking the generated
# target files properly.
#
SYSROOT := $(NDK_PLATFORMS_ROOT)/$(TARGET_PLATFORM)/arch-$(TARGET_ARCH)

TARGET_CRTBEGIN_STATIC_O  := $(SYSROOT)/usr/lib/crtbegin_static.o
TARGET_CRTBEGIN_DYNAMIC_O := $(SYSROOT)/usr/lib/crtbegin_dynamic.o
TARGET_CRTEND_O           := $(SYSROOT)/usr/lib/crtend_android.o

# crtbegin_so.o and crtend_so.o are not available for all platforms, so
# only define them if they are in the sysroot
#
TARGET_CRTBEGIN_SO_O := $(strip $(wildcard $(SYSROOT)/usr/lib/crtbegin_so.o))
TARGET_CRTEND_SO_O   := $(strip $(wildcard $(SYSROOT)/usr/lib/crtend_so.o))

TARGET_PREBUILT_SHARED_LIBRARIES :=

# Define default values for TOOLCHAIN_NAME, this can be overriden in
# the setup file.
TOOLCHAIN_NAME   := $(TARGET_TOOLCHAIN)
TOOLCHAIN_VERSION := $(call last,$(subst -,$(space),$(TARGET_TOOLCHAIN)))

# Define the root path of the toolchain in the NDK tree.
TOOLCHAIN_ROOT   := $(NDK_ROOT)/toolchains/$(TOOLCHAIN_NAME)

# Define the root path where toolchain prebuilts are stored
TOOLCHAIN_PREBUILT_ROOT := $(TOOLCHAIN_ROOT)/prebuilt/$(HOST_TAG)

# Do the same for TOOLCHAIN_PREFIX. Note that we must chop the version
# number from the toolchain name, e.g. arm-eabi-4.4.0 -> path/bin/arm-eabi-
# to do that, we split at dashes, remove the last element, then merge the
# result. Finally, add the complete path prefix.
#
TOOLCHAIN_PREFIX := $(call merge,-,$(call chop,$(call split,-,$(TOOLCHAIN_NAME))))-
TOOLCHAIN_PREFIX := $(TOOLCHAIN_PREBUILT_ROOT)/bin/$(TOOLCHAIN_PREFIX)

# Default build commands, can be overriden by the toolchain's setup script
include $(BUILD_SYSTEM)/default-build-commands.mk

# now call the toolchain-specific setup script
include $(NDK_TOOLCHAIN.$(TARGET_TOOLCHAIN).setup)

# We expect the gdbserver binary for this toolchain to be located at its root.
TARGET_GDBSERVER := $(NDK_ROOT)/prebuilt/android-$(TARGET_ARCH)/gdbserver/gdbserver

# compute NDK_APP_DST_DIR as the destination directory for the generated files
#NDK_APP_DST_DIR := $(NDK_APP_PROJECT_PATH)/libs/$(TARGET_ARCH_ABI)
#NDK_APP_GDBSERVER := $(NDK_APP_DST_DIR)/gdbserver
#NDK_APP_GDBSETUP := $(NDK_APP_DST_DIR)/gdb.setup

ifdef APP_STL
  $(call ndk-stl-select,$(APP_STL))
  #$(call ndk-stl-add-dependencies,$(APP_STL))
  #$(call modules-compute-dependencies)
  #$(call modules-dump-database)
endif

smart~app~stl := $(or $(APP_STL),$(smart~app~stl))

##################################################
## Initializs flags
smart~CFLAGS   := $(TARGET_CFLAGS) $(CFLAGS)
smart~CXXFLAGS := $(TARGET_CXXFLAGS) $(CXXFLAGS)
smart~CPPFLAGS := $(TARGET_CPPFLAGS) $(CPPFLAGS)
smart~INCLUDES := $(TARGET_C_INCLUDES) $(INCLUDES)
smart~DEFINES  := -DANDROID $(DEFINES)
smart~ARFLAGS  := $(TARGET_ARFLAGS) $(ARFLAGS)
smart~LDFLAGS  := $(TARGET_LDFLAGS) $(LDFLAGS)
smart~LDLIBS   := $(TARGET_LDLIBS) $(LDLIBS)
smart~OBJS     := $(OBJECTS)
smart~LIBS     :=

ifneq ($(ALLOW_UNDEFINED_SYMBOLS),true)
  smart~LDFLAGS += $(TARGET_NO_UNDEFINED_LDFLAGS)
endif

define smart~use
$(eval \
  smart~CFLAGS   += $(call smart~mexport,CFLAGS)
  smart~CXXFLAGS += $(call smart~mexport,CXXFLAGS)
  smart~CPPFLAGS += $(call smart~mexport,CPPFLAGS)
  smart~LDFLAGS  += $(call smart~mexport,LDFLAGS)
  smart~LDLIBS   += $(call smart~mexport,LDLIBS)
  smart~INCLUDES += $(call smart~mexport,C_INCLUDES)
  smart~OBJS     += $(call smart~mexport,OBJECTS)
  smart~LIBS     += $(addprefix $~,$(call smart.get,$(smart~m),LIBRARY))
 )$(foreach smart~m,$(call smart.get,$(smart~m),USE_MODULES),\
      $(call smart~use))
endef #smart~use
smart~mexport = $(call module-get-export,$(smart~m),$(strip $1))
$(foreach smart~m,$(USE_MODULES) $(smart~app~stl),$(smart~use))
smart~mexport =
smart~use :=

ifneq (,$(call module-has-c++-features,$(NAME),rtti))
  smart~CXXFLAGS := $(filter-out -fno-rtti,$(smart~CXXFLAGS))
  smart~CPPFLAGS := $(filter-out -fno-rtti,$(smart~CPPFLAGS))
  smart~CPPFLAGS += -frtti
endif
ifneq (,$(call module-has-c++-features,$(NAME),exceptions))
  smart~CXXFLAGS := $(filter-out -fno-exceptions,$(smart~CXXFLAGS))
  smart~CPPFLAGS := $(filter-out -fno-exceptions,$(smart~CPPFLAGS))
  smart~CPPFLAGS += -fexceptions
endif

smart~LIBS := $(strip $(smart~LIBS))
smart~LDFLAGS := $(filter-out -shared,$(smart~LDFLAGS))
smart~LDLIBS := $(strip $(smart~LDLIBS) $(TARGET_LDLIBS))

## TODO: should only link against libsupc++ if rtti, exceptions are enabled
ifneq (,$(call module-has-c++-features,$(NAME),rtti exceptions))
  ifeq (system,$(APP_STL))
    smart~LDLIBS += $(call host-path,$(NDK_ROOT)/sources/cxx-stl/gnu-libstdc++/$(TOOLCHAIN_VERSION)/libs/$(TARGET_ARCH_ABI)/libsupc++.a)
  endif
endif

smart~LDLIBS += $(TARGET_LIBGCC)

$(foreach 1,\
	smart~CFLAGS \
	smart~CXXFLAGS \
	smart~CPPFLAGS \
	smart~INCLUDES \
	smart~DEFINES \
	smart~ARFLAGS \
	smart~LDFLAGS \
	smart~LDLIBS \
	smart~OBJS \
	smart~LIBS \
 ,$(eval $1 := $(foreach 2,$($1),$2)))

#ifeq ($(NAME),boost_thread)
#$(warning $(NAME): $(smart~app~stl): $(smart~CXXFLAGS))
#endif
#$(warning $(NAME): $(smart~app~stl): $(smart~INCLUDES))
#$(warning $(NAME): $(smart~app~stl): $(smart~LIBS))

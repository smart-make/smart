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
APP_GDBSERVER := $(TARGET_OUT)/gdbserver
APP_GDBSETUP := $(TARGET_OUT)/gdb.setup
ifeq ($(APP_OPTIM),debug)
  $(OUT)/$(NAME).native: $(APP_GDBSERVER) $(APP_GDBSETUP)
  ifneq ($(smart.has.$(APP_GDBSERVER)),yes)
    smart.has.$(APP_GDBSERVER) := yes
    $(call smart~make~target~dir,$(APP_GDBSERVER))
    $(call smart~make~target~dir,$(APP_GDBSETUP))
    $(APP_GDBSERVER): $(TARGET_GDBSERVER) | $(dir $(APP_GDBSERVER))
	@echo "install $@"
	@install $< $@
    $(APP_GDBSETUP): PRIVATE_SOLIB_PATH := $(TARGET_OUT)
    $(APP_GDBSETUP): PRIVATE_SRC_DIRS := $(SYSROOT)/usr/include
    $(APP_GDBSETUP): | $(dir $(APP_GDBSETUP))
	@echo "install $@"
	@echo "set solib-search-path $(call host-path,$(PRIVATE_SOLIB_PATH))" > $@
	@echo "directory $(call host-path,$(call remove-duplicates,$(PRIVATE_SRC_DIRS)))" >> $@
  endif
endif #$(APP_OPTIM)==debug

##
## Setting up STL
smart~app~stl := $(or $(APP_STL),$(smart~app~stl))
ifdef smart~app~stl
  smart~stl~mods := $(NDK_STL.$(smart~app~stl).STATIC_LIBS) $(NDK_STL.$(smart~app~stl).SHARED_LIBS)
  __ndk_import_list := $(call set_remove,$(NDK_STL.$(smart~app~stl).IMPORT_MODULE),$(__ndk_import_list))
  __ndk_modules := $(call set_remove,$(smart~stl~mods),$(__ndk_import_list))
  $(foreach 1,$(smart~stl~mods),$(foreach 2,\
       $(filter __ndk_modules.$1.%,$(.VARIABLES)),$(eval $2 :=)))
  $(call ndk-stl-check,$(smart~app~stl))
  $(call ndk-stl-select,$(smart~app~stl))
  $(call ndk-stl-add-dependencies,$(smart~app~stl))
  $(call modules-compute-dependencies)
  #$(call modules-dump-database)
  #$(warning info: $(__ndk_modules.$(smart~app~stl).OBJECTS), $(__ndk_modules.$(smart~app~stl).BUILT_MODULE))
endif

##################################################
## Initializs flags
smart~CFLAGS   := $(TARGET_CFLAGS) $(CFLAGS)
smart~CXXFLAGS := $(TARGET_CXXFLAGS) $(CXXFLAGS)
smart~CPPFLAGS := $(TARGET_CPPFLAGS) $(CPPFLAGS)
smart~INCLUDES := $(TARGET_C_INCLUDES) $(INCLUDES)
smart~DEFINES  := -DANDROID -D__ANDROID__ $(DEFINES)
smart~ARFLAGS  := $(TARGET_ARFLAGS) $(ARFLAGS)
smart~LDFLAGS  := $(TARGET_LDFLAGS) $(LDFLAGS)
smart~LDLIBS   := $(TARGET_LDLIBS) $(LDLIBS)
smart~OBJS     := $(OBJECTS)
smart~LIBS     := $(TARGET_LIBS) $(LIBS)
smart~CPP_FEATURES := $(CPP_FEATURES)

ifneq ($(ALLOW_UNDEFINED_SYMBOLS),true)
  smart~LDFLAGS += $(TARGET_NO_UNDEFINED_LDFLAGS)
endif

#$(warning $(smart~m): $(__ndk_modules.$(smart~m).BUILT_MODULE))

define smart~use~STATIC_LIBRARY
$(eval \
  #smart~LDLIBS += $(__ndk_modules.$(smart~m).BUILT_MODULE)
 )
endef #smart~use~STATIC_LIBRARY

define smart~use~SHARED_LIBRARY
$(eval \
  #smart~LDLIBS += $(__ndk_modules.$(smart~m).BUILT_MODULE)
 )
endef #smart~use~SHARED_LIBRARY

define smart~use~PREBUILT_STATIC_LIBRARY
$(eval \
  smart~LDLIBS += $(__ndk_modules.$(smart~m).OBJECTS)
 )
endef #smart~use~PREBUILT_STATIC_LIBRARY

define smart~use~PREBUILT_SHARED_LIBRARY
$(eval \
  smart~LDLIBS += $(__ndk_modules.$(smart~m).OBJECTS)
 )
endef #smart~use~PREBUILT_SHARED_LIBRARY

define smart~use
$(call smart~use~$(call module-get-class,$(smart~m)))\
$(eval \
  smart~CFLAGS   += $(call smart~mexport,CFLAGS)
  smart~CXXFLAGS += $(call smart~mexport,CXXFLAGS)
  smart~CPPFLAGS += $(call smart~mexport,CPPFLAGS)
  smart~LDFLAGS  += $(call smart~mexport,LDFLAGS)
  smart~LDLIBS   += $(call smart~mexport,LDLIBS)
  smart~INCLUDES += $(call smart~mexport,C_INCLUDES)
  smart~OBJS     += $(call smart~mexport,OBJECTS)
  smart~LIBS     += $(addprefix $(TARGET_OUT)/,$(call smart.get,$(smart~m),LIBRARY))
  smart~CPP_FEATURES += $(__ndk_modules.$(smart~m).CPP_FEATURES)
 )$(foreach smart~m,$(call smart.get,$(smart~m),USE_MODULES),\
      $(call smart~use))
endef #smart~use
smart~mexport = $(call module-get-export,$(smart~m),$(strip $1))
$(foreach smart~m,$(USE_MODULES) \
    $(NDK_STL.$(smart~app~stl).STATIC_LIBS:lib%=%) \
    $(NDK_STL.$(smart~app~stl).SHARED_LIBS:lib%=%) \
  ,$(smart~use))
smart~mexport =
smart~use :=

#$(warning $(NDK_STL.$(smart~app~stl).IMPORT_MODULE))
#$(warning $(NDK_STL.$(smart~app~stl).STATIC_LIBS))
#$(warning $(NDK_STL.$(smart~app~stl).SHARED_LIBS))

smart~optimize~debug := $(TARGET_$(ARM_MODE)_$(APP_OPTIM)_CFLAGS)
smart~optimize~release := $(TARGET_$(ARM_MODE)_$(APP_OPTIM)_CFLAGS)
$(foreach v,smart~CPPFLAGS smart~CXXFLAGS smart~CFLAGS,\
    $(eval $v := $(filter-out -O% -g -ggdb,$($v))))
smart~CFLAGS := $(smart~optimize~$(APP_OPTIM)) $(smart~CFLAGS)

ifeq ($(ARM_NEON),true)
  smart~CFLAGS := $(TARGET_CFLAGS.neon) $(smart~CFLAGS)
endif

smart~CPP_FEATURES := $(sort $(smart~CPP_FEATURES))

smart~has~rtti := $(strip $(or \
  $(call module-has-c++-features,$(NAME),rtti),\
  $(if $(filter rtti,$(smart~CPP_FEATURES)),true)))

smart~has~exceptions := $(strip $(or \
  $(call module-has-c++-features,$(NAME),exceptions),\
  $(if $(filter exceptions,$(smart~CPP_FEATURES)),true)))

ifneq (,$(smart~has~rtti))
  smart~CFLAGS := $(filter-out -fno-rtti,$(smart~CFLAGS))
  smart~CXXFLAGS := $(filter-out -fno-rtti,$(smart~CXXFLAGS))
  smart~CPPFLAGS := $(filter-out -fno-rtti,$(smart~CPPFLAGS))
  smart~CPPFLAGS += -frtti
endif
ifneq (,$(smart~has~exceptions))
  smart~CFLAGS := $(filter-out -fno-exceptions,$(smart~CFLAGS))
  smart~CXXFLAGS := $(filter-out -fno-exceptions,$(smart~CXXFLAGS))
  smart~CPPFLAGS := $(filter-out -fno-exceptions,$(smart~CPPFLAGS))
  smart~CPPFLAGS += -fexceptions
endif

#$(warning $(NAME): $(smart~has~rtti) $(smart~has~exceptions))

smart~LIBS := $(strip $(smart~LIBS))
smart~LDFLAGS := $(filter-out -shared,$(smart~LDFLAGS))
smart~LDLIBS := $(strip $(smart~LDLIBS) $(TARGET_LDLIBS))

ifneq (,$(call module-has-c++-features,$(NAME),rtti exceptions))
  ifeq (system,$(smart~app~stl))
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
#$(warning $(NAME): $(TARGET_OUT): $(smart~LIBS))

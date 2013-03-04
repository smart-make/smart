#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

#
# The android/ndk/setup subdirectory is used to glue Android NDK build
# system with smart build system. And it's tarting with the init.mk.
#
ifeq ($(and $(BUILD_SYSTEM),$(NDK_ALL_ABIS),$(NDK_ALL_ARCHS),$(NDK_ALL_TOOLCHAINS),$(NDK_ALL_PLATFORMS)),)
  # NDK_ROOT *must* be defined and point to the root of the NDK installation
  # before init.mk
  NDK_ROOT := /store/open/android-ndk
  include $(NDK_ROOT)/build/core/init.mk
endif

# Some usefull variables from init.mk:
#   HOST_OS
#   HOST_OS_BASE
#   HOST_ARCH
#   HOST_ARCH64
#   HOST_TAG
#   HOST_TAG64
#   HOST_DIRSEP
#   HOST_EXEEXT
#   
#   BUILD_SYSTEM
#   
#   TOOLCHAIN_CONFIGS
#   
#   NDK_ALL_TOOLCHAINS
#   NDK_ALL_ABIS
#   NDK_ALL_ARCHS
#   
#   NDK_PLATFORMS_ROOT
#   NDK_ALL_PLATFORMS
#   NDK_ALL_PLATFORM_LEVELS
#
#   NDK_MAX_PLATFORM_LEVEL
#

#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

#
# The android/ndk/glue subdirectory is used to glue Android NDK build
# system with smart build system. And it's tarting with the init.mk.
#
ifeq ($(and $(BUILD_SYSTEM),$(NDK_ALL_ABIS),$(NDK_ALL_ARCHS),$(NDK_ALL_TOOLCHAINS),$(NDK_ALL_PLATFORMS)),)
  NDK_HOST_AWK := $(shell which awk)

  # NDK_ROOT *must* be defined and point to the root of the NDK installation
  # before init.mk
  NDK_ROOT := /open/android/android-ndk
  include $(NDK_ROOT)/build/core/init.mk

  ##################################################
  # Setup imports (see $(BUILD_SYSTEM)/setup-imports.mk)
  CLEAR_VARS                := $(BUILD_SYSTEM)/clear-vars.mk
  BUILD_HOST_EXECUTABLE     := $(BUILD_SYSTEM)/build-host-executable.mk
  BUILD_HOST_STATIC_LIBRARY := $(BUILD_SYSTEM)/build-host-static-library.mk
  BUILD_STATIC_LIBRARY      := $(BUILD_SYSTEM)/build-static-library.mk
  BUILD_SHARED_LIBRARY      := $(BUILD_SYSTEM)/build-shared-library.mk
  BUILD_EXECUTABLE          := $(BUILD_SYSTEM)/build-executable.mk
  PREBUILT_SHARED_LIBRARY   := $(BUILD_SYSTEM)/prebuilt-shared-library.mk
  PREBUILT_STATIC_LIBRARY   := $(BUILD_SYSTEM)/prebuilt-static-library.mk
  $(call import-init)
  $(foreach 1,$(subst $(HOST_DIRSEP),$(space),$(NDK_MODULE_PATH)),\
      $(call import-add-path,$1))
  $(call import-add-path-optional,$(NDK_ROOT)/sources)
  $(call import-add-path-optional,$(NDK_ROOT)/../development/ndk/sources)
  ##################################################
endif

#$(warning $(HOST_OS), $(HOST_OS_BASE), $(HOST_ARCH), $(HOST_ARCH64))

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

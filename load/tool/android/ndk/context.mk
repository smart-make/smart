#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)
smart.context.global.android/ndk := \
  APP_OPTIM \
  APP_CPPFLAGS \
  APP_CFLAGS \
  APP_CXXFLAGS \
  APP_PLATFORM \
  APP_BUILD_SCRIPT \
  APP_ABI \
  APP_MODULES \
  APP_PROJECT_PATH \
  APP_STL \
  APP_SHORT_COMMANDS \
  APP_PIE \
  APP_DEBUG \
  APP_DEBUGGABLE \
  APP_MANIFEST \
  MODULE_PATH IMPORTS

smart.context.private.android/ndk := \
  USE_MODULES

smart.context.android/ndk := \
  PROGRAM \
  LIBRARY \
  SOURCES \
  OBJECTS \
  DEFINES \
  INCLUDES \
  ASFLAGS \
  CFLAGS \
  CXXFLAGS \
  CPPFLAGS \
  CPP_FEATURES \
  LDFLAGS \
  LDLIBS \
  LOADLIBS \
  LIBADD \
  LIBS \
  FULLLIBS \
  \
  TOOLCHAIN_NAME \
  TOOLCHAIN_VERSION \
  ARM_MODE \
  ARM_NEON \
  \
  ALLOW_UNDEFINED_SYMBOLS \

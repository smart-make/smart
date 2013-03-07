#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

NATIVE_LIBS :=
PLATFORM := $(or $(PLATFORM),android-14)
CLASSPATH := $(ANDROID_PLATFORM_LIB)
$(foreach 1,$(SUPPORTS),$(eval LIBS += $(ANDROID.root)/android-compatibility/$1/android-support-$1.jar))

LIBS.local :=
LIBS.native :=
ifneq ($(wildcard $(SRCDIR)/libs),)
  LIBS.local := $(wildcard $(PWD)/$(SRCDIR)/libs/*.jar)
  LIBS.native := $(call smart.find,$(SRCDIR)/libs,%.so %/gdbserver %/gdb.setup)
endif

LIBS += $(LIBS.local)
$(foreach 1,$(LIBS),$(eval CLASSPATH := $(CLASSPATH):$1))

## Java sources
ifndef SOURCES
  SOURCES := $(call smart.find,$(SRCDIR)/src,%.java)
endif #SOURCES

## Native sources (e.g. C, C++)
ifneq ($(or $(NDK_BUILD),$(NDK_LIBRARY),$(NDK_PROGRAM)),)
  ifdef NDK_BUILD
    SOURCES += $(call smart.find,$(dir $(NDK_BUILD)),%.c %.cpp)
  endif #NDK_BUILD
endif

SOURCES.aidl := $(filter %.aidl,$(SOURCES))
SOURCES.java := $(filter %.java,$(SOURCES))
SOURCES.c := $(filter %.c,$(SOURCES))
SOURCES.c++ := $(filter %.cpp,$(SOURCES))

ifneq ($(wildcard $(SRCDIR)/res $(SRCDIR)/assets),)
  include $(smart.tooldir)/res.mk
endif

ifdef SOURCES.aidl
  include $(smart.tooldir)/aidl.mk
endif #SOURCES.aidl

ifdef SOURCES.java
  include $(smart.tooldir)/java.mk
endif #SOURCES.java

ifdef LIBS.native
  include $(smart.tooldir)/so.mk
endif #LIBS.native

ifdef NDK_LIBRARY
  $(error TODO: native support for NDK_LIBRARY)
endif #NDK_LIBRARY

ifdef NDK_PROGRAM
  $(error TODO: native support for NDK_PROGRAM)
endif #NDK_PROGRAM

ifdef NDK_BUILD
  include $(smart.tooldir)/ndk/build.mk
endif #NDK_BUILD

ifdef PACKAGE
  include $(smart.tooldir)/jar.mk
endif #PACKAGE

ifdef APK
  include $(smart.tooldir)/apk.mk
endif #APK

ifneq ($(or $(APK),$(NDK_LIBRARY),$(NDK_PROGRAM),$(NDK_BUILD)),)
  ifdef APK
    module-$(SM.MK): $(APK)
    modules: module-$(SM.MK)
  endif #APK
  ifdef NDK_BUILD_TARGETS
    module-$(SM.MK): $(NDK_BUILD_TARGETS)
    modules: module-$(SM.MK)
  endif #NDK_BUILD_TARGETS
endif #APK

#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

PLATFORM := $(or $(PLATFORM),android-14)
$(foreach 1,$(SUPPORTS),$(eval LIBS += $(ANDROID.root)/android-compatibility/$1/android-support-$1.jar))

LIBS.java := $(filter %.jar,$(LIBS))
LIBS.native := $(filter %.so,$(LIBS))
LIBS.native_list := $(filter %.native,$(LIBS))
ifneq ($(wildcard $(SRCDIR)/libs),)
  LIBS.java += $(wildcard $(PWD)/$(SRCDIR)/libs/*.jar)
  LIBS.native += $(call smart.find,$(SRCDIR)/libs,%.so %/gdbserver %/gdb.setup)
endif

$(info $(NAME): $(LIBS.native))

CLASSPATH := $(ANDROID_PLATFORM_LIB):$(CLASSPATH)
$(foreach 1,$(LIBS.java),$(eval CLASSPATH := $(CLASSPATH):$1))

# $(modules-get-list), __ndk_modules, __ndk_import_list, __ndk_import_dirs
$(foreach 1,$(USE_MODULES),$(warning $1))

## Java sources
ifndef SOURCES
  SOURCES := $(call smart.find,$(SRCDIR)/src,%.java %.aidl)
endif #SOURCES

SOURCES.aidl := $(filter %.aidl,$(SOURCES))
SOURCES.java := $(filter %.java,$(SOURCES))

ifneq ($(wildcard $(SRCDIR)/res $(SRCDIR)/assets),)
  include $(smart.tooldir)/res.mk
endif

ifdef SOURCES.aidl
  include $(smart.tooldir)/aidl.mk
endif #SOURCES.aidl

ifdef SOURCES.java
  include $(smart.tooldir)/java.mk
endif #SOURCES.java

ifneq ($(or $(LIBS.native),$(LIBS.native_list)),)
  include $(smart.tooldir)/native.mk
endif #LIBS.native or LIBS.native_list

ifdef PACKAGE
  include $(smart.tooldir)/jar.mk
endif #PACKAGE

ifdef APK
  include $(smart.tooldir)/apk.mk
  module-$(SCRIPT): $(APK)
  modules: module-$(SCRIPT)
endif #APK

#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

PLATFORM := $(or $(PLATFORM),android-14)
CLASSPATH := $(ANDROID_PLATFORM_LIB)
$(foreach 1,$(SUPPORTS),$(eval LIBS += $(ANDROID.root)/android-compatibility/$1/android-support-$1.jar))

#$(foreach 1,$(REQUIRES),$(warning $(call smart.get,$1,LIBRARY)))
#$(warning $(LIBS))

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

ifdef LIBS.native
  include $(smart.tooldir)/native.mk
endif #LIBS.native

ifdef PACKAGE
  include $(smart.tooldir)/jar.mk
endif #PACKAGE

ifdef APK
  include $(smart.tooldir)/apk.mk
  module-$(SCRIPT): $(APK)
  modules: module-$(SCRIPT)
endif #APK

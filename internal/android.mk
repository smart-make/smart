$(smart.internal)

NATIVE_LIBS :=
PLATFORM := $(or $(PLATFORM),android-14)
CLASSPATH := $(ANDROID_PLATFORM_LIB)
$(foreach 1,$(SUPPORTS),$(eval LIBS += $(ANDROID.root)/android-compatibility/$1/android-support-$1.jar))

LIBS.local :=
LIBS.native :=
ifneq ($(wildcard $(SRCDIR)/libs),)
  LIBS.local := $(wildcard $(PWD)/$(SRCDIR)/libs/*.jar)
  LIBS.native := $(call smart.find,$(SRCDIR)/libs,%.so)
endif

LIBS += $(LIBS.local)
$(foreach 1,$(LIBS),$(eval CLASSPATH := $(CLASSPATH):$1))

ifndef SOURCES
  SOURCES := $(call smart.find,$(SRCDIR)/src,%.java)
endif #SOURCES

SOURCES.aidl := $(filter %.aidl,$(SOURCES))
SOURCES.java := $(filter %.java,$(SOURCES))

ifneq ($(wildcard $(SRCDIR)/res $(SRCDIR)/assets),)
  include $(smart.root)/internal/android/res.mk
endif

ifdef SOURCES.aidl
  include $(smart.root)/internal/android/aidl.mk
endif #SOURCES.aidl

ifdef SOURCES.java
  include $(smart.root)/internal/android/java.mk
endif #SOURCES.java

ifdef LIBS.native
  include $(smart.root)/internal/android/so.mk
endif #LIBS.native

ifdef PACKAGE
  include $(smart.root)/internal/android/jar.mk
endif #PACKAGE

ifdef APK
  include $(smart.root)/internal/android/apk.mk
endif #APK

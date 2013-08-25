#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

## Helper for getting variable of $(smart~m)
smart~var = $(call smart.get,$(smart~m),$1)

PLATFORM := $(or $(PLATFORM),android-14)
$(foreach 1,$(SUPPORTS),$(eval LIBS += $(ANDROID.root)/android-compatibility/$1/android-support-$1.jar))

RES.proguard :=
RES.crunched :=
LIBS.classes :=
LIBS.jar := $(filter %.jar,$(LIBS))
LIBS.native := $(filter %.so,$(LIBS))
LIBS.native_list := $(filter %.native,$(LIBS))
ifneq ($(wildcard $(SRCDIR)/libs),)
  LIBS.jar += $(wildcard $(PWD)/$(SRCDIR)/libs/*.jar)
  LIBS.native += $(call smart.find,$(SRCDIR)/libs,%.so %/gdbserver %/gdb.setup)
endif

define smart~use
$(eval \
  ifeq ($(call smart~var,TOOL),$(TOOL))
    ifneq ($(call smart~var,LIBRARY),)
      #LIBS.classes += $(OUT)/$(call smart~var,NAME)/classes
      #LIBS.jar += $(OUT)/$(call smart~var,NAME)/classes.jar
      RES.proguard += ../$(call smart~var,NAME)/res.proguard
      RES.crunched += $(OUT)/$(call smart~var,NAME)/res
      RES += $(call smart~var,SRCDIR)/res
      ifneq ($(wildcard $(call smart~var,SRCDIR)/AndroidManifest.xml),)
        EXTRA_PACKAGES := $(if $(EXTRA_PACKAGES),$(EXTRA_PACKAGES):)$$(shell awk -f $(smart.tooldir)/extract-package-name.awk $(call smart~var,SRCDIR)/AndroidManifest.xml)
      endif
    endif
  endif
 )$(foreach smart~m,$(call smart~var,REQUIRES),$(call smart~use))
endef #smart~use
$(foreach smart~m,$(REQUIRES),$(smart~use))

#CLASSPATH := $(ANDROID_PLATFORM_LIB):$(CLASSPATH)
$(foreach 1,$(LIBS.jar),$(eval CLASSPATH := $(CLASSPATH):$1))
CLASSPATH := $(CLASSPATH::%=%)

# $(modules-get-list), __ndk_modules, __ndk_import_list, __ndk_import_dirs
# $(foreach 1,$(USE_MODULES),$(warning $1))

## Java sources
ifndef SOURCES
  SOURCES := $(call smart.find,$(SRCDIR)/src,%.java %.aidl)
endif #SOURCES

SOURCES.aidl := $(filter %.aidl,$(SOURCES))
SOURCES.java := $(filter %.java,$(SOURCES))

ifdef SOURCES.java
  include $(smart.tooldir)/java.mk
endif #SOURCES.java

ifneq ($(or $(LIBS.native),$(LIBS.native_list)),)
  include $(smart.tooldir)/native.mk
endif #LIBS.native or LIBS.native_list

ifdef LIBRARY
  include $(smart.tooldir)/library.mk
  module-$(SCRIPT): $(OUT)/$(NAME)
  modules: module-$(SCRIPT)
endif #LIBRARY

ifdef APK
  include $(smart.tooldir)/apk.mk
  module-$(SCRIPT): $(APK)
  modules: module-$(SCRIPT)
endif #APK

ifdef PACKAGE
  #$(error PACKAGE is deprecated, use "LIBRARY=yes" instead)
endif #PACKAGE

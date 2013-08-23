#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

ifndef ANDROID.root
  include $(smart.tooldir)/init.mk
endif #ANDROID.root

ANDROID_ROOT = $(ANDROID.root)
ANDROID_COMPAT = $(ANDROID.root)/android-compatibility
ANDROID_EXTRAS = $(ANDROID.root)/extras
MANIFEST := $(SRCDIR)/AndroidManifest.xml
APK := $(NAME).apk
CLASSPATH :=
LIBS :=

#PROGUARD := $(wildcard $(SRCDIR)/proguard.cfg)
PROGUARD := $(wildcard $(SRCDIR)/obfuscate.pro)

ifndef ANDROID_SDK_LIBS.initialized
  ANDROID_SDK_LIBS.initialized := yes
  ANDROID_SDK_LIBS := $(wildcard $(smart.tooldir)/libs/*.mk)
  $(foreach @loadee,$(ANDROID_SDK_LIBS),$(eval include $(smart.root)/funs/smart.load))
endif #ANDROID_SDK_LIBS_INITIALIZED

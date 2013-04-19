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
ANDROID_EXTRAS = $(ANDROID.root)/extras
APK := $(NAME).apk
CLASSPATH :=
LIBS :=

#PROGUARD := $(wildcard $(SRCDIR)/proguard.cfg)
PROGUARD := $(wildcard $(SRCDIR)/obfuscate.pro)

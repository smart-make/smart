#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

ifndef ANDROID.root
  include $(smart.tooldir)/init.mk
  uninstall: uninstall-$(shell basename $(PWD))
  install: install-$(shell basename $(PWD))
  run: run-$(shell basename $(PWD))
endif #ANDROID.root

APK := $(NAME).apk
MANIFEST := $(SRCDIR)/AndroidManifest.xml
PACKAGE := $(shell awk -f $(smart.tooldir)/extract-package-name.awk $(MANIFEST))
EXTRA_PACKAGES :=
CLASSPATH :=
LIBS :=
JAVAC_FLAGS := -Xlint:deprecation -Xlint:unchecked

ifndef PACKAGE
  $(error package name unknown ($(MANIFEST)))
endif

PROGUARD := $(or $(wildcard $(SRCDIR)/obfuscate.pro),$(wildcard $(SRCDIR)/obfuscate.cfg))

ifndef ANDROID_SDK_LIBS.initialized
  ANDROID_SDK_LIBS.initialized := yes
  ANDROID_SDK_LIBS := $(wildcard $(smart.tooldir)/libs/*.mk)
  $(foreach @loadee,$(ANDROID_SDK_LIBS),$(eval include $(smart.root)/funs/smart.load))
endif #ANDROID_SDK_LIBS_INITIALIZED

#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

ifndef ANDROID.root
  ANDROID.root := $(patsubst %/tools/,%,$(dir $(shell which android)))
endif #ANDROID.root

ifndef ANDROID.root
  ANDROID.root := $(patsubst %/tools/,%,$(dir $(shell which aapt)))
endif #ANDROID.root

ifndef ANDROID.dx
  ANDROID.dx = $(ANDROID.root)/platform-tools/dx
endif #ANDROID.dx

ifndef ANDROID.aapt
  ANDROID.aapt = $(ANDROID.root)/platform-tools/aapt
endif #ANDROID.aapt

ifndef ANDROID.aidl
  ANDROID.aidl = $(ANDROID.root)/platform-tools/aidl
endif #ANDROID.aidl

ifndef ANDROID.zipalign
  ANDROID.zipalign = $(ANDROID.root)/tools/zipalign
endif #ANDROID.zipalign

ifndef ANDROID.jarsigner
  ANDROID.jarsigner = jarsigner
endif #ANDROID.jarsigner

ANDROID_PLATFORM_LIB = $(ANDROID.root)/platforms/$(PLATFORM)/android.jar
ANDROID_PREPROCESS_IMPORT = $(ANDROID.root)/platforms/$(PLATFORM)/framework.aidl

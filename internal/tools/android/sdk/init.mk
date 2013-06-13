#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

ANDROID.get-platform-tools = $(or \
	$(wildcard $(ANDROID.root)/build-tools/17.0.0/$1),\
	$(wildcard $(ANDROID.root)/platform-tools/$1),\
	$(wildcard $(ANDROID.root)/platforms/android-4/tools/$1),\
	$(wildcard $(ANDROID.root)/platforms/android-3/tools/$1),\
	)

ifndef ANDROID.root
  ANDROID.root := $(patsubst %/tools/,%,$(dir $(shell which android)))
endif #ANDROID.root

ifndef ANDROID.root
  ANDROID.root := $(patsubst %/tools/,%,$(dir $(shell which aapt)))
endif #ANDROID.root

ifndef ANDROID.dx
  #ANDROID.dx = $(ANDROID.root)/platform-tools/dx
  ANDROID.dx = $(call ANDROID.get-platform-tools,dx)
endif #ANDROID.dx

ifndef ANDROID.aapt
  ANDROID.aapt = $(call ANDROID.get-platform-tools,aapt)
endif #ANDROID.aapt

ifndef ANDROID.aidl
  #ANDROID.aidl = $(ANDROID.root)/platform-tools/aidl
  ANDROID.aidl = $(call ANDROID.get-platform-tools,aidl)
endif #ANDROID.aidl

ifndef ANDROID.zipalign
  ANDROID.zipalign = $(ANDROID.root)/tools/zipalign
endif #ANDROID.zipalign

ifndef ANDROID.proguard
  ## This is a directory!
  ANDROID.proguard = $(ANDROID.root)/tools/proguard
endif #ANDROID.proguard

ifndef ANDROID.jarsigner
  ANDROID.jarsigner = jarsigner
endif #ANDROID.jarsigner

ANDROID_PLATFORM_LIB = $(ANDROID.root)/platforms/$(PLATFORM)/android.jar
ANDROID_PREPROCESS_IMPORT = $(ANDROID.root)/platforms/$(PLATFORM)/framework.aidl


android-new-app:
	@if test -f $(SRCDIR)/AndroidManifest.xml; then \
	    echo "Already has an AndroidManifest.xml!"; \
	    false; \
	fi
	$(ANDROID.root)/tools/android create project \
	    -n $(NAME) -p $(SRCDIR) -k $(PACKAGE) -a Main -t 1

android-new-lib:
	echo $(SRCDIR), $(smart.tooldir) 


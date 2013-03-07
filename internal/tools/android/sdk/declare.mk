#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

smart~android_files := $(wildcard $(SRCDIR)/AndroidManifest.xml)
ifdef smart~android_files
  ifndef ANDROID.root
    include $(smart.tooldir)/init.mk
  endif #ANDROID.root
  ANDROID_ROOT = $(ANDROID.root)
  ANDROID_EXTRAS = $(ANDROID.root)/extras
  APK := $(NAME).apk
endif

smart~android_files :=

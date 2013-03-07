#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

smart~android_files := $(wildcard $(SRCDIR)/AndroidManifest.xml)
ifdef smart~android_files
  TOOL := android/sdk
endif

smart~android_files :=

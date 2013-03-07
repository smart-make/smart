#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

ifeq ($(notdir $(SRCDIR)),jni)
ifneq ($(wildcard $(dir $(SRCDIR))AndroidManifest.xml),)
  TOOL := android/ndk
endif
endif

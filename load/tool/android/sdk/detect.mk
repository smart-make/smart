#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

ifneq ($(wildcard $(SRCDIR)/AndroidManifest.xml),)
  TOOL := android/sdk
endif

#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)
include $(smart.root)/internal/tools/android/sdk/detect.mk
ifndef TOOL
include $(smart.root)/internal/tools/android/ndk/detect.mk
endif

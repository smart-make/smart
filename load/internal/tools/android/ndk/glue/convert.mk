#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

ifeq ($(and $(smart.scripts.$(smart~m))),)
  include $(smart~convert)/go.mk
endif

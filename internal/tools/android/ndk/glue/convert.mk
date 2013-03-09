#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)
ifeq ($(and $(smart.scripts.$(smart~m))),)
  include $(smart~convert)/go.mk
else
  smart~new~app~abi := $(call smart.get,$(smart~m),APP_ABI)
  smart~new~app~abi := $(smart~new~app~abi) \
    $(filter-out $(smart~new~app~abi),$(smart~app~abi))
  $(call smart.set,$(smart~m),APP_ABI,$(smart~new~app~abi))

  #$(warning $(smart~m): $(call smart.get,$(smart~m),APP_ABI))
  #$(warning info: $(NAME) $(smart~m))
endif

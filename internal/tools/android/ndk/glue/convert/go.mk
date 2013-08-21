#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

##
##  Convert Android NDK modules into smart modules without checking
##	*) Say the list $(modules-get-list)
##  

ifneq ($(call smart~ndk~get,MODULE),$(smart~m))
  $(error smart: internal build system error: $(call smart~ndk~get,MODULE) != $(smart~m))
endif

ifdef smart~
$(warning info: $(smart~m))
$(foreach 1,$(modules-fields),\
    $(if $(call smart~ndk~get,$1),\
        $(info $(space4)$1: $(call smart~ndk~get,$1))))
endif

$(call smart.test.load.before.push)
$(call smart.push)
$(call smart.test.load.after.push)

include $(SMART.DECLARE)
include $(smart~convert)/smart.mk
include $(SMART.RULES)

$(call smart.test.load.before.pop)
$(call smart.pop)
$(call smart.test.load.after.pop)

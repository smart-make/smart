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

smart~get = $(__ndk_modules.$(smart~m).$(strip $1))
smart~get~export = $(call module-get-export,$(smart~m),$(strip $1))

ifneq ($(call smart~get,MODULE),$(smart~m))
  $(error smart: internal build system error: $(call smart~get,MODULE) != $(smart~m))
endif

ifdef smart~
$(warning info: $(smart~m))
$(foreach 1,$(modules-fields),\
    $(if $(call smart~get,$1),\
        $(info $(space4)$1: $(call smart~get,$1))))
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

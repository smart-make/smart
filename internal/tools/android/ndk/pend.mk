#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

## Process imports..
ifdef IMPORTS
$(foreach 1,$(MODULE_PATH),$(call import-add-path,$1))
$(foreach 1,$(IMPORTS),$(call import-module,$1))
endif

## Convert Android NDK modules into smart build system..
##     *) See $(modules-get-list) for all modules
ifdef USE_MODULES
$(foreach smart~convert,$(smart.tooldir)/glue/convert,\
    $(foreach smart~m,$(USE_MODULES),\
        $(eval include $(smart.tooldir)/glue/convert.mk)))
endif

#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

#$(warning $(NAME), $(APP_ABI), $(APP_PLATFORM), $(SCRIPT))

## Pend it as a new app: see glue/pend.mk
$(foreach smart~app,pend,$(eval include $(smart.tooldir)/glue/app.mk))

# ## Convert Android NDK modules into smart build system..
# ##     *) See $(modules-get-list) for all modules
# ifdef USE_MODULES
# ## Use smart~app~* to pass APP_* variables to imported modules.
# smart~app~abi := $(APP_ABI)
# smart~app~platform := $(APP_PLATFORM)
# smart~app~stl := $(APP_STL)
# #$(warning $(NAME): $(USE_MODULES))
# $(foreach smart~convert,$(smart.tooldir)/glue/convert,\
#     $(foreach smart~m,$(USE_MODULES),\
#         $(eval include $(smart.tooldir)/glue/convert.mk)))
# #smart~app~abi :=
# #smart~app~platform :=
# #smart~app~stl :=
# endif

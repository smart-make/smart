#
#    Copyright (C) 2012, 2013, Duzy Chan <code@duzy.info>.
#    
#    All rights reserved.
#
$(smart.internal)

#$(warning $(NAME), $(APP_ABI), $(APP_PLATFORM), $(SCRIPT))

## Pend it as a new app: see glue/pend.mk
$(foreach smart~action,pend,$(eval include $(smart.tooldir)/glue/run.mk))

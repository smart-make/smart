#
#    Copyright (C) 2012, Duzy Chan <code@duzy.info>.
#    All rights reserved.
#
$(smart.internal)

#$(warning $(NAME), $(TOOL), $(SRCDIR), $(SCRIPT))

ifdef TOOL
  -include $(wildcard $(smart.tooldir)/declare.mk)
endif

-include $(wildcard $(ROOT)/declare.mk)

#$(warning NDK_MODULE_PATH: $(NDK_MODULE_PATH), $(NAME))
